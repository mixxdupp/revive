import SwiftUI
import AVFoundation
import CoreHaptics

struct SOSFlashlightView: View {
    @State private var isFlashing = false
    @State private var currentPulse = false
    @State private var cycleCount = 0
    @State private var backgroundTaskID: UIBackgroundTaskIdentifier = .invalid

    // SOS Morse: ··· — — — ···
    private let sosPattern: [(Bool, Double, Bool)] = {
        var pattern: [(Bool, Double, Bool)] = []
        for i in 0..<3 { pattern.append((true, 0.2, false)); if i < 2 { pattern.append((false, 0.2, false)) } }
        pattern.append((false, 0.6, false))
        for i in 0..<3 { pattern.append((true, 0.6, true)); if i < 2 { pattern.append((false, 0.2, false)) } }
        pattern.append((false, 0.6, false))
        for i in 0..<3 { pattern.append((true, 0.2, false)); if i < 2 { pattern.append((false, 0.2, false)) } }
        pattern.append((false, 1.4, false))
        return pattern
    }()

    private let signalAmber = Color(red: 1.0, green: 0.6, blue: 0.0)

    var body: some View {
        ZStack {
            // Background: pulses amber when torch fires
            (currentPulse && isFlashing ? signalAmber.opacity(0.12) : Color.black)
                .ignoresSafeArea()
                .animation(.easeOut(duration: 0.08), value: currentPulse)
            
            // Ambient glow
            if isFlashing {
                Circle()
                    .fill(signalAmber.opacity(currentPulse ? 0.25 : 0.0))
                    .frame(width: 300, height: 300)
                    .blur(radius: 80)
                    .animation(.easeOut(duration: 0.1), value: currentPulse)
                    .offset(y: -40)
            }
            
            VStack(spacing: 0) {
                Spacer()

                if isFlashing {
                    activeView
                } else {
                    inactiveView
                }

                Spacer()

                // MARK: - Action Button
                Button(action: toggleSOS) {
                    HStack(spacing: 10) {
                        Image(systemName: isFlashing ? "stop.fill" : "antenna.radiowaves.left.and.right")
                            .font(.system(size: 20, weight: .bold))
                        
                        Text(isFlashing ? "Stop Signal" : "Transmit SOS")
                            .font(.system(size: 20, weight: .bold, design: .rounded))
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
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.hidden, for: .navigationBar)
        .onDisappear { stopFlashing() }
    }
    
    // MARK: - Inactive State
    
    private var inactiveView: some View {
        VStack(spacing: 28) {
            // Hero: bare SOS — same pattern as Inclinometer's angle readout
            Text("SOS")
                .font(.system(size: 80, weight: .light, design: .rounded))
                .foregroundStyle(signalAmber)
                .kerning(8)
            
            // Title + subtitle
            VStack(spacing: 8) {
                Text("DISTRESS SIGNAL")
                    .font(.system(size: 13, weight: .medium, design: .rounded))
                    .foregroundStyle(Color(white: 0.45))
                    .kerning(2)
                
                Text("Flashes your torch in international\nMorse code SOS pattern")
                    .font(.system(size: 14, weight: .regular))
                    .foregroundStyle(Color(white: 0.35))
                    .multilineTextAlignment(.center)
                    .lineSpacing(2)
            }
            
            // Morse visualization — refined
            HStack(spacing: 5) {
                // S
                ForEach(0..<3, id: \.self) { _ in
                    RoundedRectangle(cornerRadius: 2).fill(signalAmber.opacity(0.4)).frame(width: 6, height: 6)
                }
                Spacer().frame(width: 10)
                // O
                ForEach(0..<3, id: \.self) { _ in
                    RoundedRectangle(cornerRadius: 2).fill(signalAmber.opacity(0.4)).frame(width: 20, height: 6)
                }
                Spacer().frame(width: 10)
                // S
                ForEach(0..<3, id: \.self) { _ in
                    RoundedRectangle(cornerRadius: 2).fill(signalAmber.opacity(0.4)).frame(width: 6, height: 6)
                }
            }
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("SOS Distress Signal, ready to transmit")
    }
    
    // MARK: - Active State
    private var activeView: some View {
        VStack(spacing: 16) {
            Text("Transmitting")
                .font(.title2.weight(.bold))
                .foregroundStyle(signalAmber.opacity(0.9))
                .frame(height: 30)
            
            Image(systemName: "flashlight.on.fill")
                .font(.system(size: 140, weight: .light))
                .foregroundStyle(currentPulse ? signalAmber : Color(white: 0.2))
                .shadow(color: currentPulse ? signalAmber.opacity(0.6) : .clear, radius: 30)
                .scaleEffect(currentPulse ? 1.0 : 0.95)
                .animation(.easeOut(duration: 0.08), value: currentPulse)
            
            // Morse pattern — highlights current pulse type
            HStack(spacing: 6) {
                ForEach(0..<3, id: \.self) { _ in
                    Capsule().fill(signalAmber).frame(width: 8, height: 8)
                }
                Spacer().frame(width: 6)
                ForEach(0..<3, id: \.self) { _ in
                    Capsule().fill(signalAmber).frame(width: 24, height: 8)
                }
                Spacer().frame(width: 6)
                ForEach(0..<3, id: \.self) { _ in
                    Capsule().fill(signalAmber).frame(width: 8, height: 8)
                }
            }
            
            if cycleCount > 0 {
                Text("Cycle \(cycleCount)")
                    .font(.system(size: 15, weight: .semibold, design: .rounded))
                    .foregroundStyle(Color(white: 0.35))
                    .padding(.top, 4)
            }
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("SOS Signal Transmitting, Cycle \(cycleCount)")
    }
    


    // MARK: - Engine

    private func toggleSOS() {
        let generator = UIImpactFeedbackGenerator(style: .rigid)
        generator.impactOccurred()
        if isFlashing { stopFlashing() } else { startFlashing() }
    }

    private func startFlashing() {
        isFlashing = true
        cycleCount = 0
        UIApplication.shared.isIdleTimerDisabled = true
        backgroundTaskID = UIApplication.shared.beginBackgroundTask(withName: "SOSFlash") {
            UIApplication.shared.endBackgroundTask(self.backgroundTaskID)
            self.backgroundTaskID = .invalid
        }
        flashLoop()
    }

    private func stopFlashing() {
        isFlashing = false
        currentPulse = false
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
                    if on {
                        let generator = UIImpactFeedbackGenerator(style: isDash ? .heavy : .light)
                        generator.impactOccurred()
                    }
                    try? await Task.sleep(nanoseconds: UInt64(duration * 1_000_000_000))
                }
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
        } catch {}
    }
}
