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
        VStack(spacing: 0) {
            Spacer()

            // MARK: - Core Metronome Visual
            ZStack {
                // Background tracking ring
                Circle()
                    .fill(Color.red.opacity(0.05))
                    .frame(width: 240, height: 240)
                
                // Active compression ring
                Circle()
                    .fill(isRunning ? Color.red : Color.red.opacity(0.15))
                    // Physical compression scale: shrinks on the beat
                    .frame(width: isBeatOn ? 190 : 220, height: isBeatOn ? 190 : 220)
                    // Hyper-realistic spatial spring for a heavy chest compression
                    .animation(.interpolatingSpring(stiffness: 300, damping: 20), value: isBeatOn)
                    .shadow(color: isRunning ? Color.red.opacity(0.3) : .clear, radius: isBeatOn ? 5 : 20, y: isBeatOn ? 2 : 10)

                VStack(spacing: 2) {
                    Text("\(Int(bpm))")
                        .font(.system(size: 72, weight: .semibold, design: .rounded).monospacedDigit())
                        .foregroundStyle(isRunning ? .white : DesignSystem.textPrimary)
                        .scaleEffect(isBeatOn ? 0.95 : 1.0)
                        .animation(.interpolatingSpring(stiffness: 300, damping: 20), value: isBeatOn)
                    
                    Text("BPM")
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                        .foregroundStyle(isRunning ? .white.opacity(0.8) : DesignSystem.textSecondary)
                        .kerning(1)
                }
            }
            .accessibilityElement(children: .combine)
            .accessibilityLabel("\(Int(bpm)) BPM")

            Spacer()
                .frame(height: 48)

            // MARK: - Real-time Protocol Feedback
            VStack(spacing: 8) {
                if isRunning {
                    Text("\(beatCount)")
                        .font(.system(size: 44, weight: .heavy, design: .rounded).monospacedDigit())
                        .foregroundStyle(Color.red)
                        .contentTransition(.numericText())
                        .animation(.snappy, value: beatCount)
                    
                    Text("COMPRESSIONS")
                        .font(.system(size: 13, weight: .bold))
                        .foregroundStyle(DesignSystem.textSecondary)
                        .kerning(1.5)
                } else {
                    Text("Ready")
                        .font(.system(size: 24, weight: .medium))
                        .foregroundStyle(DesignSystem.textPrimary)
                    
                    Text("TAP START TO BEGIN PACER")
                        .font(.system(size: 13, weight: .bold))
                        .foregroundStyle(DesignSystem.textSecondary)
                        .kerning(1.5)
                }
            }
            .frame(height: 80) // Fixed height to prevent layout shift

            Spacer()

            // MARK: - Clinical Guidelines (Ultra Minimal)
            VStack(spacing: 8) {
                Label("Push Hard & Fast", systemImage: "bolt.heart.fill")
                    .font(.system(size: 17, weight: .bold))
                    .foregroundStyle(DesignSystem.textPrimary)
                
                HStack(spacing: 16) {
                    Text("2 INCHES DEEP")
                    Text("•")
                        .foregroundStyle(DesignSystem.textSecondary.opacity(0.5))
                    Text("FULL RECOIL")
                }
                .font(.system(size: 13, weight: .semibold))
                .foregroundStyle(DesignSystem.textSecondary)
            }
            .padding(.bottom, 48)

            // MARK: - Primary Action
            Button(action: toggleMetronome) {
                HStack(spacing: 12) {
                    Image(systemName: isRunning ? "stop.fill" : "play.fill")
                        .font(.system(size: 20, weight: .black))
                    Text(isRunning ? "STOP PACER" : "START CPR PACER")
                        .font(.system(size: 18, weight: .heavy, design: .rounded))
                        .kerning(1)
                }
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 24)
                // Apple Maps style hyper-smooth corner radius
                .background(
                    RoundedRectangle(cornerRadius: 24, style: .continuous)
                        .fill(isRunning ? Color.primary.opacity(0.8) : Color.red)
                )
                // Spatial shadow mapping
                .shadow(color: isRunning ? .clear : Color.red.opacity(0.25), radius: 20, y: 10)
            }
            .padding(.horizontal, 32)
            .padding(.bottom, 40)
        }
        .background(DesignSystem.backgroundPrimary.ignoresSafeArea())
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear { prepareHaptics() }
        .onDisappear { stopMetronome() }
    }

    private func toggleMetronome() {
        let generator = UIImpactFeedbackGenerator(style: .rigid)
        generator.impactOccurred()
        if isRunning { stopMetronome() } else { startMetronome() }
    }

    private func startMetronome() {
        beatCount = 0
        isRunning = true
        // Fire first beat immediately for zero-latency UI response
        beat()
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

        // Core Haptic: Sharp, driving impact simulating actual chest compression depth
        triggerHaptic()

        // Audio standard medical metronome click
        AudioServicesPlaySystemSound(1104)

        // Ultra-snappy visual release imitating optimal chest recoil (.08s)
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
            // Fallback natively handled
        }
    }

    private func triggerHaptic() {
        guard let engine = engine else {
            let generator = UIImpactFeedbackGenerator(style: .heavy)
            // Fallback for non-corehaptics
            generator.impactOccurred()
            return
        }
        
        // Custom haptic matching CPR compression: maximum sharpness, maximum intensity
        let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 1.0)
        let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 1.0)
        let event = CHHapticEvent(eventType: .hapticTransient, parameters: [sharpness, intensity], relativeTime: 0)
        
        do {
            let pattern = try CHHapticPattern(events: [event], parameters: [])
            let player = try engine.makePlayer(with: pattern)
            try player.start(atTime: 0)
        } catch {
            let generator = UIImpactFeedbackGenerator(style: .heavy)
            generator.impactOccurred()
        }
    }
}

struct GuidelineRow: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(.red)
                .frame(width: 24)
            
            Text(text)
                .font(.subheadline.weight(.medium))
                .foregroundStyle(.primary)
                .fixedSize(horizontal: false, vertical: true)
            
            Spacer(minLength: 0)
        }
    }
}
