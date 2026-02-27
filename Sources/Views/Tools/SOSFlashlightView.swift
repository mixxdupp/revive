import SwiftUI
import AVFoundation

struct SOSFlashlightView: View {
    @State private var isFlashing = false
    @State private var statusText = "STANDBY"
    @State private var currentPulse = false // Tracks individual on/off flash state

    // SOS Morse: ··· — — — ···
    // Dot = 0.2s, Dash = 0.6s, gap between = 0.2s, letter gap = 0.6s, word gap = 1.4s
    private let sosPattern: [(Bool, Double)] = {
        var pattern: [(Bool, Double)] = []
        for i in 0..<3 { pattern.append((true, 0.2)); if i < 2 { pattern.append((false, 0.2)) } }
        pattern.append((false, 0.6))
        for i in 0..<3 { pattern.append((true, 0.6)); if i < 2 { pattern.append((false, 0.2)) } }
        pattern.append((false, 0.6))
        for i in 0..<3 { pattern.append((true, 0.2)); if i < 2 { pattern.append((false, 0.2)) } }
        pattern.append((false, 1.4))
        return pattern
    }()

    // Apple Watch Ultra amber
    private let signalAmber = Color(red: 1.0, green: 0.6, blue: 0.0)

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            // Ambient OLED glow synced to torch state
            Circle()
                .fill(signalAmber.opacity(currentPulse ? 0.25 : 0.0))
                .frame(width: 300, height: 300)
                .blur(radius: 80)
                .animation(.easeOut(duration: 0.1), value: currentPulse)
                .offset(y: -40)
            
            VStack(spacing: 0) {
                // MARK: - Header
                Text("SOS SIGNAL")
                    .font(.system(size: 14, weight: .bold, design: .rounded))
                    .foregroundStyle(Color(white: 0.4))
                    .kerning(2)
                    .padding(.top, 40)
                
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
                }
                .accessibilityElement(children: .combine)
                .accessibilityLabel(isFlashing ? "SOS Signal Transmitting" : "SOS Signal Standby")

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

                // MARK: - Action Button
                Button(action: toggleSOS) {
                    HStack(spacing: 12) {
                        Image(systemName: isFlashing ? "stop.fill" : "antenna.radiowaves.left.and.right")
                            .font(.system(size: 20, weight: .black))
                        
                        Text(isFlashing ? "STOP SIGNAL" : "TRANSMIT SOS")
                            .font(.system(size: 18, weight: .heavy, design: .rounded))
                            .kerning(1)
                    }
                    .foregroundStyle(isFlashing ? .black : .white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 72)
                    .background(
                        Capsule()
                            .fill(isFlashing ? Color.white : signalAmber)
                    )
                    .overlay(
                        Capsule()
                            .stroke(Color.white.opacity(isFlashing ? 0.0 : 0.15), lineWidth: 1)
                    )
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 24)
            }
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.hidden, for: .navigationBar)
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
        statusText = "TRANSMIT"
        isFlashing = true
        flashLoop()
    }

    private func stopFlashing() {
        isFlashing = false
        currentPulse = false
        statusText = "STANDBY"
        setTorch(on: false)
    }

    private func flashLoop() {
        Task {
            while isFlashing {
                for (on, duration) in sosPattern {
                    guard isFlashing else { return }
                    await MainActor.run { currentPulse = on }
                    setTorch(on: on)
                    try? await Task.sleep(nanoseconds: UInt64(duration * 1_000_000_000))
                }
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
