import SwiftUI
import AudioToolbox
import CoreHaptics

struct CPRMetronomeView: View {
    @State private var isRunning = false
    @State private var beatCount = 0          // Total compressions
    @State private var cycleCount = 0         // Current compression in 30-count set
    @State private var setCount = 0           // Number of completed 30:2 sets
    @State private var isBeatOn = false
    @State private var isBreathPause = false  // True during "GIVE 2 BREATHS" window
    @State private var prepCountdown = 0      // 5-second countdown before starting
    @State private var engine: CHHapticEngine?
    @State private var timer: Timer?
    @State private var prepTimer: Timer?

    // AHA Guidelines: 100-120 compressions/min → 110 BPM
    private let bpm: Double = 110
    private var interval: Double { 60.0 / bpm }
    private let compressionsPerSet = 30
    private let breathPauseDuration: Double = 4.0 // ~4s for 2 rescue breaths

    var body: some View {
        ZStack {
            // Full-screen beat flash — visible in peripheral vision
            (isBeatOn ? Color(red: 0.15, green: 0.0, blue: 0.0) : Color.black)
                .ignoresSafeArea()
                .animation(.easeOut(duration: 0.06), value: isBeatOn)
            
            // Breath pause: full screen goes blue
            if isBreathPause {
                Color.blue.opacity(0.15)
                    .ignoresSafeArea()
            }
            
            VStack(spacing: 0) {
                Spacer()

                if isBreathPause {
                    breathPauseView
                } else if prepCountdown > 0 {
                    prepCountdownView
                } else {
                    compressionView
                }

                Spacer()

                guidanceStrip
                    .padding(.bottom, 24)

                Button(action: toggleMetronome) {
                    HStack(spacing: 10) {
                        Image(systemName: isRunning ? "stop.fill" : "play.fill")
                            .font(.system(size: 20, weight: .bold))
                        
                        Text(isRunning ? "STOP" : "START CPR")
                            .font(.system(size: 20, weight: .bold, design: .rounded))
                    }
                    .foregroundStyle(isRunning ? .black : .white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 72)
                    .background(
                        RoundedRectangle(cornerRadius: 20, style: .continuous)
                            .fill(isRunning ? Color.white : Color.red)
                    )
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 24)
            }
        }
        .navigationTitle("CPR Pacer")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear { prepareHaptics() }
        .onDisappear { stopMetronome() }
    }
    
    private var compressionView: some View {
        VStack(spacing: 16) {
            // Coaching word — massive, unmissable
            Text(isBeatOn ? "PUSH" : "")
                .font(.system(size: 22, weight: .bold))
                .foregroundStyle(Color.red)
                .frame(height: 30)
            
            // Compression counter
            Text("\(cycleCount)")
                .font(.system(size: 140, weight: .light, design: .rounded).monospacedDigit())
                .foregroundStyle(.white)
                .scaleEffect(isBeatOn ? 0.95 : 1.0)
                .animation(.interactiveSpring(response: 0.2, dampingFraction: 0.5), value: isBeatOn)
                .contentTransition(.numericText())
            
            // Progress — how far through the 30
            Text("of \(compressionsPerSet)")
                .font(.system(size: 18, weight: .medium, design: .rounded))
                .foregroundStyle(Color(white: 0.4))
            
            // Set counter
            if setCount > 0 {
                Text("Set \(setCount + 1)")
                    .font(.system(size: 15, weight: .semibold, design: .rounded))
                    .foregroundStyle(Color(white: 0.35))
                    .padding(.top, 4)
            }
        }
        .accessibilityLabel("\(cycleCount) of \(compressionsPerSet) compressions")
    }

    private var prepCountdownView: some View {
        VStack(spacing: 16) {
            Text("GET IN POSITION")
                .font(.system(size: 22, weight: .bold))
                .foregroundStyle(Color.yellow)
                .frame(height: 30)
            
            Text("\(prepCountdown)")
                .font(.system(size: 140, weight: .light, design: .rounded).monospacedDigit())
                .foregroundStyle(.white)
                .contentTransition(.numericText())
                .animation(.spring(response: 0.3, dampingFraction: 0.6), value: prepCountdown)
            
            Text("Starting compressions...")
                .font(.system(size: 18, weight: .medium, design: .rounded))
                .foregroundStyle(Color(white: 0.4))
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Starting in \(prepCountdown) seconds")
    }
    
    private var breathPauseView: some View {
        VStack(spacing: 20) {
            Image(systemName: "wind")
                .font(.system(size: 56, weight: .light))
                .foregroundStyle(.blue)
            
            Text("GIVE 2 BREATHS")
                .font(.system(size: 28, weight: .bold))
                .foregroundStyle(.white)
            
            Text("Tilt head back, lift chin, seal mouth")
                .font(.system(size: 16, weight: .medium))
                .foregroundStyle(Color(white: 0.5))
                .multilineTextAlignment(.center)
            
            Text("Resuming compressions...")
                .font(.system(size: 14, weight: .regular))
                .foregroundStyle(Color(white: 0.3))
                .padding(.top, 8)
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Give 2 rescue breaths now")
    }
    
    private var guidanceStrip: some View {
        HStack(spacing: 0) {
            guidanceItem(icon: "arrow.down", label: "2 in deep")
            Spacer()
            guidanceItem(icon: "arrow.up", label: "Full recoil")
            Spacer()
            guidanceItem(icon: "metronome", label: "110/min")
        }
        .padding(.horizontal, 32)
        .padding(.vertical, 16)
        .background(Color(white: 0.08))
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .padding(.horizontal, 24)
    }
    
    private func guidanceItem(icon: String, label: String) -> some View {
        HStack(spacing: 6) {
            Image(systemName: icon)
                .font(.system(size: 13, weight: .bold))
                .foregroundStyle(Color(white: 0.5))
            Text(label)
                .font(.system(size: 13, weight: .semibold, design: .rounded))
                .foregroundStyle(Color(white: 0.5))
        }
    }


    private func toggleMetronome() {
        let generator = UIImpactFeedbackGenerator(style: .rigid)
        generator.impactOccurred()
        if isRunning { stopMetronome() } else { beginPrepPhase() }
    }

    private func beginPrepPhase() {
        // Reset states
        beatCount = 0
        cycleCount = 0
        setCount = 0
        isRunning = true
        isBreathPause = false
        prepCountdown = 5
        
        // Initial pip
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        
        prepTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            prepCountdown -= 1
            
            if prepCountdown > 0 {
                let generator = UIImpactFeedbackGenerator(style: .light)
                generator.impactOccurred()
            } else {
                prepTimer?.invalidate()
                prepTimer = nil
                startMetronome()
            }
        }
    }

    private func startMetronome() {
        // Zero-latency: first beat fires immediately
        beat()
        
        timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { _ in
            beat()
        }
    }

    private func stopMetronome() {
        isRunning = false
        isBeatOn = false
        isBreathPause = false
        prepCountdown = 0
        
        prepTimer?.invalidate()
        prepTimer = nil
        timer?.invalidate()
        timer = nil
    }

    private func beat() {
        guard !isBreathPause else { return }
        
        beatCount += 1
        cycleCount += 1
        isBeatOn = true

        triggerHaptic()
        AudioServicesPlaySystemSound(1104)

        // Visual reset
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.08) {
            isBeatOn = false
        }
        
        // 30:2 cycle check
        if cycleCount >= compressionsPerSet {
            // Pause for 2 rescue breaths
            timer?.invalidate()
            timer = nil
            isBreathPause = true
            
            // Auto-resume after breath pause
            DispatchQueue.main.asyncAfter(deadline: .now() + breathPauseDuration) {
                guard isRunning else { return }
                isBreathPause = false
                cycleCount = 0
                setCount += 1
                
                // Restart rhythm
                beat()
                timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { _ in
                    beat()
                }
            }
        }
    }

    private func prepareHaptics() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        do {
            engine = try CHHapticEngine()
            try engine?.start()
        } catch {
            // Fallback to UIKit haptics
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
