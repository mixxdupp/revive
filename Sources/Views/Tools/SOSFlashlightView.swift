import SwiftUI
import AVFoundation
import CoreHaptics

struct SOSFlashlightView: View {
    @State private var isFlashing = false
    @State private var statusText = "Standby"
    @State private var currentPulse = false
    @State private var cycleCount = 0
    @State private var backgroundTaskID: UIBackgroundTaskIdentifier = .invalid

    // SOS Morse: ··· — — — ···
    // Dot = 0.2s, Dash = 0.6s, gap between = 0.2s, letter gap = 0.6s, word gap = 1.4s
    private let sosPattern: [(Bool, Double, Bool)] = {
        // (torchOn, duration, isDash)
        var pattern: [(Bool, Double, Bool)] = []
        // S: · · ·
        for i in 0..<3 { pattern.append((true, 0.2, false)); if i < 2 { pattern.append((false, 0.2, false)) } }
        pattern.append((false, 0.6, false))
        // O: — — —
        for i in 0..<3 { pattern.append((true, 0.6, true)); if i < 2 { pattern.append((false, 0.2, false)) } }
        pattern.append((false, 0.6, false))
        // S: · · ·
        for i in 0..<3 { pattern.append((true, 0.2, false)); if i < 2 { pattern.append((false, 0.2, false)) } }
        pattern.append((false, 1.4, false))
        return pattern
    }()

    // Apple Watch Ultra amber
    private let signalAmber = Color(red: 1.0, green: 0.6, blue: 0.0)

    var body: some View {
        ZStack {
            // Background: pulses amber on torch-on beats
            (currentPulse && isFlashing ? signalAmber.opacity(0.12) : Color.black)
                .ignoresSafeArea()
                .animation(.easeOut(duration: 0.08), value: currentPulse)
            
            // Ambient OLED glow synced to torch state
            Circle()
                .fill(signalAmber.opacity(currentPulse ? 0.25 : 0.0))
                .frame(width: 300, height: 300)
                .blur(radius: 80)
                .animation(.easeOut(duration: 0.1), value: currentPulse)
                .offset(y: -40)
            
            VStack(spacing: 0) {
                Spacer()
                    .frame(height: 20)
                
                Spacer()
                
                // MARK: - Core Visualization
                VStack(spacing: 24) {
                    // Flashlight icon with pulse
                    Image(systemName: currentPulse ? "flashlight.on.fill" : "flashlight.off.fill")
                        .font(.system(size: 80, weight: .thin))
                        .foregroundStyle(currentPulse ? signalAmber : Color(white: 0.3))
                        .shadow(color: currentPulse ? signalAmber.opacity(0.6) : .clear, radius: 20)
                        .animation(.easeOut(duration: 0.08), value: currentPulse)
                    
                    // Morse Code Visual
                    HStack(spacing: 6) {
                        // S: ···
                        ForEach(0..<3, id: \.self) { _ in
                            Capsule().fill(signalAmber).frame(width: 8, height: 8)
                        }
                        Spacer().frame(width: 8)
                        // O: ———
                        ForEach(0..<3, id: \.self) { _ in
                            Capsule().fill(signalAmber).frame(width: 24, height: 8)
                        }
                        Spacer().frame(width: 8)
                        // S: ···
                        ForEach(0..<3, id: \.self) { _ in
                            Capsule().fill(signalAmber).frame(width: 8, height: 8)
                        }
                    }
                    .opacity(isFlashing ? 1.0 : 0.3)
                    
                    // Status
                    Text(statusText)
                        .font(.system(size: 48, weight: .light, design: .rounded).monospacedDigit())
                        .foregroundStyle(isFlashing ? signalAmber : .white)
                        .contentTransition(.numericText())
                    
                    // Cycle counter
                    if isFlashing && cycleCount > 0 {
                        Text("Cycle \(cycleCount)")
                            .font(.system(size: 15, weight: .semibold, design: .rounded))
                            .foregroundStyle(Color(white: 0.4))
                    }
                }
                .accessibilityElement(children: .combine)
                .accessibilityLabel(isFlashing ? "SOS Signal Transmitting, Cycle \(cycleCount)" : "SOS Signal Standby")

                Spacer()
                
                // MARK: - Info
                VStack(spacing: 8) {
                    Text("INTERNATIONAL DISTRESS SIGNAL")
                        .font(.system(size: 13, weight: .bold, design: .rounded))
                        .foregroundStyle(Color(white: 0.5))
                        .kerning(1)
                    
                    Text("· · ·  — — —  · · ·")
                        .font(.system(size: 18, weight: .medium, design: .monospaced))
                        .foregroundStyle(Color(white: 0.6))
                }
                .padding(.bottom, 48)

                // MARK: - Action Button (matches Siren & CPR)
                Button(action: toggleSOS) {
                    HStack(spacing: 12) {
                        Image(systemName: isFlashing ? "stop.fill" : "antenna.radiowaves.left.and.right")
                            .font(.system(size: 20, weight: .black))
                        
                        Text(isFlashing ? "Stop Signal" : "Transmit SOS")
                            .font(.system(size: 18, weight: .heavy, design: .rounded))
                    }
                    .foregroundStyle(isFlashing ? .black : .white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 72)
                    .background(
                        RoundedRectangle(cornerRadius: 20, style: .continuous)
                            .fill(isFlashing ? Color.white : signalAmber)
                    )
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 24)
            }
        }
        .navigationTitle("SOS Signal")
        .navigationBarTitleDisplayMode(.inline)
        .onDisappear { stopFlashing() }
    }

    private func toggleSOS() {
        let generator = UIImpactFeedbackGenerator(style: .rigid)
        generator.impactOccurred()
        
        if isFlashing {
            stopFlashing()
        } else {
            startFlashing()
        }
    }

    private func startFlashing() {
        statusText = "Transmitting"
        isFlashing = true
        cycleCount = 0
        
        // Prevent screen lock
        UIApplication.shared.isIdleTimerDisabled = true
        
        // Keep running in background
        backgroundTaskID = UIApplication.shared.beginBackgroundTask(withName: "SOSFlash") {
            UIApplication.shared.endBackgroundTask(self.backgroundTaskID)
            self.backgroundTaskID = .invalid
        }
        
        flashLoop()
    }

    private func stopFlashing() {
        isFlashing = false
        currentPulse = false
        statusText = "Standby"
        setTorch(on: false)
        
        UIApplication.shared.isIdleTimerDisabled = false
        
        if backgroundTaskID != .invalid {
            UIApplication.shared.endBackgroundTask(backgroundTaskID)
            backgroundTaskID = .invalid
        }
    }

    private func flashLoop() {
        Task {
            while isFlashing {
                for (on, duration, isDash) in sosPattern {
                    guard isFlashing else { return }
                    await MainActor.run { currentPulse = on }
                    setTorch(on: on)
                    
                    // Haptic sync: heavy for dashes, light for dots
                    if on {
                        let generator = UIImpactFeedbackGenerator(style: isDash ? .heavy : .light)
                        generator.impactOccurred()
                    }
                    
                    try? await Task.sleep(nanoseconds: UInt64(duration * 1_000_000_000))
                }
                // One full SOS cycle completed
                await MainActor.run { cycleCount += 1 }
            }
        }
    }

    private func setTorch(on: Bool) {
        guard let device = AVCaptureDevice.default(for: .video),
              device.hasTorch else { return }
        do {
            try device.lockForConfiguration()
            device.torchMode = on ? .on : .off
            device.unlockForConfiguration()
        } catch {
            // Silently fail if torch unsupported
        }
    }
}
