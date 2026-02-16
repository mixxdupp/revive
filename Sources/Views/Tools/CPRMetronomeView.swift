import SwiftUI
import AudioToolbox
import CoreHaptics

struct CPRMetronomeView: View {
    @State private var isRunning = false
    @State private var beatCount = 0
    @State private var isBeatOn = false
    @State private var engine: CHHapticEngine?
    @State private var timer: Timer?

    // AHA Guidelines: 100-120 compressions/min → 110 BPM = ~0.545s interval
    private let bpm: Double = 110
    private var interval: Double { 60.0 / bpm }

    var body: some View {
        VStack(spacing: 32) {
            Spacer()

            // BPM display
            ZStack {
                Circle()
                    .stroke(Color.red.opacity(0.2), lineWidth: 8)
                    .frame(width: 200, height: 200)

                Circle()
                    .fill(isBeatOn ? Color.red : Color.red.opacity(0.1))
                    .frame(width: 180, height: 180)
                    .animation(.easeOut(duration: 0.1), value: isBeatOn)

                VStack(spacing: 4) {
                    Text("\(Int(bpm))")
                        .font(.system(size: 56, weight: .bold, design: .rounded))
                        .foregroundStyle(isBeatOn ? .white : DesignSystem.textPrimary)
                    Text("BPM")
                        .font(.title3.weight(.semibold))
                        .foregroundStyle(isBeatOn ? .white.opacity(0.8) : DesignSystem.textSecondary)
                        .foregroundStyle(isBeatOn ? .white.opacity(0.8) : DesignSystem.textSecondary)
                }
            }
            .accessibilityElement(children: .combine)
            .accessibilityLabel("\(Int(bpm)) BPM")

            Text("CPR Metronome")
                .font(.system(size: 28, weight: .bold, design: .serif))
                .foregroundStyle(DesignSystem.textPrimary)

            // Compression counter
            if isRunning {
                Text("Compressions: \(beatCount)")
                    .font(.title3.weight(.medium).monospacedDigit())
                    .foregroundStyle(DesignSystem.textSecondary)
            }

            // Guidelines
            VStack(spacing: 6) {
                Text("Push hard, push fast")
                    .font(.headline)
                    .foregroundStyle(DesignSystem.textPrimary)
                Text("At least 2 inches (5 cm) depth")
                    .font(.subheadline)
                    .foregroundStyle(DesignSystem.textSecondary)
                Text("Allow full chest recoil between compressions")
                    .font(.subheadline)
                    .foregroundStyle(DesignSystem.textSecondary)
            }

            Spacer()

            // Start/Stop
            Button(action: toggleMetronome) {
                Text(isRunning ? "STOP" : "START CPR PACER")
                    .font(.title2.weight(.bold))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 20)
                    .background(isRunning ? Color.gray : Color.red)
                    .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
            }
            .padding(.horizontal, 40)
            .padding(.bottom, 30)
        }
        .background(Color(uiColor: .systemGroupedBackground))
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear { prepareHaptics() }
        .onDisappear { stopMetronome() }
    }

    private func toggleMetronome() {
        if isRunning { stopMetronome() } else { startMetronome() }
    }

    private func startMetronome() {
        beatCount = 0
        isRunning = true
        timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { _ in
            beat()
        }
    }

    private func stopMetronome() {
        isRunning = false
        isBeatOn = false
        timer?.invalidate()
        timer = nil
    }

    private func beat() {
        beatCount += 1
        isBeatOn = true

        // Haptic
        triggerHaptic()

        // Audio click
        AudioServicesPlaySystemSound(1104)

        // Reset visual after short delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.08) {
            isBeatOn = false
        }
    }

    private func prepareHaptics() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        do {
            engine = try CHHapticEngine()
            try engine?.start()
        } catch {
            // Device doesn't support haptics
        }
    }

    private func triggerHaptic() {
        guard let engine = engine else {
            // Fallback to basic haptic
            let generator = UIImpactFeedbackGenerator(style: .heavy)
            generator.impactOccurred()
            return
        }
        let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.8)
        let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 1.0)
        let event = CHHapticEvent(eventType: .hapticTransient, parameters: [sharpness, intensity], relativeTime: 0)
        do {
            let pattern = try CHHapticPattern(events: [event], parameters: [])
            let player = try engine.makePlayer(with: pattern)
            try player.start(atTime: 0)
        } catch {
            // Fallback
            let generator = UIImpactFeedbackGenerator(style: .heavy)
            generator.impactOccurred()
        }
    }
}
