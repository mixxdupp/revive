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
        ZStack {
            Color.black.ignoresSafeArea()
            
            // MARK: - Ambient OLED Glow (Apple Health style lighting)
            Circle()
                .fill(Color(red: 1.0, green: 0.15, blue: 0.15).opacity(isBeatOn ? 0.2 : 0.0))
                .frame(width: 320, height: 320)
                .blur(radius: 60)
                .scaleEffect(isBeatOn ? 1.3 : 0.8)
                .animation(.spring(response: 0.5, dampingFraction: 0.6), value: isBeatOn)
                .offset(y: -50)
            
            VStack(spacing: 0) {
                Spacer()
                    .frame(height: 40)
                
                // MARK: - Navigation Header (Apple Maps/Workout style)
                Text("CPR PACER")
                    .font(.system(size: 14, weight: .bold, design: .rounded))
                    .foregroundStyle(Color.white.opacity(0.4))
                    .kerning(2)
                
                Spacer()
                
                // MARK: - Core Pulse Visuals
                VStack(spacing: 8) {
                    Text("\(isRunning ? beatCount : Int(bpm))")
                        // iOS 18 Fitness-style massive tracking typography
                        .font(.system(size: 150, weight: .light, design: .rounded).monospacedDigit())
                        .foregroundStyle(.white)
                        // True physical compression animation (chest pushes IN, not OUT)
                        .scaleEffect(isBeatOn ? 0.94 : 1.0)
                        .animation(.interactiveSpring(response: 0.25, dampingFraction: 0.4), value: isBeatOn)
                        .contentTransition(.numericText())
                    
                    Text(isRunning ? "COMPRESSIONS" : "BEATS PER MINUTE")
                        .font(.system(size: 15, weight: .bold, design: .rounded))
                        .foregroundStyle(Color(red: 1.0, green: 0.25, blue: 0.25))
                        .kerning(1.5)
                }
                .accessibilityElement(children: .combine)
                .accessibilityLabel(isRunning ? "\(beatCount) Compressions" : "\(Int(bpm)) BPM")

                Spacer()

                // MARK: - iOS 18 Metric Cards (Apple Health aesthetic)
                HStack(spacing: 12) {
                    MetricCard(
                        title: "DEPTH",
                        value: "2 in",
                        subtitle: "5 cm",
                        icon: "arrow.down.to.line.compact"
                    )
                    
                    MetricCard(
                        title: "RECOIL",
                        value: "Full",
                        subtitle: "Release",
                        icon: "arrow.up.and.down"
                    )
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 32)

                // MARK: - Premium Action Capsule
                Button(action: toggleMetronome) {
                    HStack(spacing: 12) {
                        Image(systemName: isRunning ? "stop.fill" : "play.fill")
                            .font(.system(size: 20, weight: .black))
                        
                        Text(isRunning ? "STOP PACER" : "START PACER")
                            .font(.system(size: 18, weight: .heavy, design: .rounded))
                            .kerning(1)
                    }
                    .foregroundStyle(isRunning ? .black : .white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 72)
                    .background(
                        Capsule()
                            .fill(isRunning ? Color.white : Color(red: 0.9, green: 0.2, blue: 0.2))
                    )
                    // High-end iOS button stroke overlay
                    .overlay(
                        Capsule()
                            .stroke(Color.white.opacity(isRunning ? 0.0 : 0.2), lineWidth: 1)
                    )
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 24)
            }
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.hidden, for: .navigationBar)
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
        
        // Zero-latency instantaneous execution
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

        // True haptic resistance
        triggerHaptic()

        // Clinical metronome audio focus
        AudioServicesPlaySystemSound(1104)

        // Perfect physical recoil release mapping (0.08s)
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
            // Natively handled fallback
        }
    }

    private func triggerHaptic() {
        guard let engine = engine else {
            let generator = UIImpactFeedbackGenerator(style: .heavy)
            generator.impactOccurred()
            return
        }
        
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

// MARK: - iOS 18 Design System Components

private struct MetricCard: View {
    let title: String
    let value: String
    let subtitle: String
    let icon: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.system(size: 12, weight: .bold))
                    .foregroundStyle(Color(red: 1.0, green: 0.3, blue: 0.3))
                Text(title)
                    .font(.system(size: 13, weight: .bold, design: .rounded))
                    .foregroundStyle(Color(white: 0.5))
                    .kerning(0.5)
            }
            
            VStack(alignment: .leading, spacing: 0) {
                Text(value)
                    .font(.system(size: 26, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)
                Text(subtitle)
                    .font(.system(size: 14, weight: .semibold, design: .rounded))
                    .foregroundStyle(Color(white: 0.4))
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(18)
        .background(Color(white: 0.1)) // Deep dynamic black equivalent
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
    }
}
