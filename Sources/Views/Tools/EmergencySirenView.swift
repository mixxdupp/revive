import SwiftUI
import AVFoundation

struct EmergencySirenView: View {
    var autoPlay: Bool = false // Default to manual start
    
    @State private var isPlaying = false
    @State private var audioEngine: AVAudioEngine?
    @State private var sourceNode: AVAudioSourceNode?
    @State private var phase: Double = 0
    @State private var animationPhase: Double = 0

    // Siren sweeps between two frequencies
    private let lowFreq: Double = 600
    private let highFreq: Double = 1400
    private let sweepRate: Double = 2.0 // Hz — full cycle per second
    // SOS Pattern
    private let sosPattern: [(Bool, Double)] = [
        (true, 0.2), (false, 0.2), (true, 0.2), (false, 0.2), (true, 0.2), (false, 0.6), // S
        (true, 0.6), (false, 0.2), (true, 0.6), (false, 0.2), (true, 0.6), (false, 0.6), // O
        (true, 0.2), (false, 0.2), (true, 0.2), (false, 0.2), (true, 0.2), (false, 1.4)  // S
    ]
    
    @State private var includeStrobe = false

    var body: some View {
        VStack(spacing: 32) {
            Spacer()

            // Visual siren indicator
            ZStack {
                ForEach(0..<3, id: \.self) { i in
                    Circle()
                        .stroke(Color.purple.opacity(isPlaying ? 0.4 - Double(i) * 0.1 : 0.1), lineWidth: 3)
                        .frame(
                            width: 140 + CGFloat(i) * 40,
                            height: 140 + CGFloat(i) * 40
                        )
                        .scaleEffect(isPlaying ? 1.1 : 1.0)
                        .animation(
                            .easeInOut(duration: 0.5)
                            .repeatForever(autoreverses: true)
                            .delay(Double(i) * 0.15),
                            value: isPlaying
                        )
                }

                Circle()
                    .fill(isPlaying ? Color.purple : Color.purple.opacity(0.2))
                    .frame(width: 120, height: 120)

                Image(systemName: isPlaying ? "light.beacon.max.fill" : "speaker.wave.3.fill")
                    .font(.system(size: 44))
                    .foregroundStyle(isPlaying ? .white : DesignSystem.textSecondary)
                    .symbolEffect(.variableColor.iterative, isActive: isPlaying)
            }

            Text("Emergency Siren")
                .font(.system(size: 28, weight: .bold, design: .serif))
                .foregroundStyle(DesignSystem.textPrimary)

            Text(isPlaying ? "Distress Signal Active" : "Generates loud alarm & strobe")
                .font(.body.weight(.medium))
                .foregroundStyle(isPlaying ? .red : DesignSystem.textSecondary)

            Spacer()

            // Controls
            VStack(spacing: 24) {
                // Strobe Toggle
                Toggle(isOn: $includeStrobe) {
                    HStack {
                        Image(systemName: "flashlight.on.fill")
                            .foregroundStyle(DesignSystem.textSecondary)
                        Text("Include SOS Strobe")
                            .font(.body.weight(.medium))
                            .foregroundStyle(DesignSystem.textPrimary)
                    }
                }
                .toggleStyle(SwitchToggleStyle(tint: .purple))
                .padding(.horizontal, 24)
                .padding(.vertical, 12)
                .background(Color(uiColor: .secondarySystemGroupedBackground))
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .padding(.horizontal, 40)
                .onChange(of: includeStrobe) { _, newValue in
                    if isPlaying {
                        if newValue { startFlash() } else { stopFlash() }
                    }
                }

                // Warning
                HStack(spacing: 8) {
                    Image(systemName: "ear.trianglebadge.exclamationmark")
                        .font(.subheadline)
                    Text("Very loud. Check device volume.")
                        .font(.caption.weight(.medium))
                }
                .foregroundStyle(DesignSystem.textSecondary)

                Button(action: toggleSiren) {
                    Text(isPlaying ? "STOP SIGNAL" : "ACTIVATE SIGNAL")
                        .font(.title2.weight(.bold))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 20)
                        .background(isPlaying ? Color.gray : Color.purple)
                        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                }
                .padding(.horizontal, 40)
            }
            .padding(.bottom, 30)
        }
        .background(Color(uiColor: .systemGroupedBackground))
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            if autoPlay {
                includeStrobe = true // Auto-enable strobe for emergency
                startSiren()
            }
        }
        .onDisappear { stopSiren() }
    }

    private func toggleSiren() {
        if isPlaying { stopSiren() } else { startSiren() }
    }

    private func startSiren() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: .duckOthers)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch { return }

        // Start Audio
        startAudioEngine()
        
        // Start Strobe if enabled
        if includeStrobe {
            startFlash()
        }
        
        isPlaying = true
    }

    private func stopSiren() {
        stopAudioEngine()
        stopFlash()
        isPlaying = false
    }
    
    // MARK: - Audio
    private func startAudioEngine() {
        let engine = AVAudioEngine()
        let sampleRate = engine.outputNode.outputFormat(forBus: 0).sampleRate
        var lfoPhase: Double = 0
        var tonePhase: Double = 0
        
        let source = AVAudioSourceNode { _, _, frameCount, audioBufferList -> OSStatus in
            let ablPointer = UnsafeMutableAudioBufferListPointer(audioBufferList)
            
            for frame in 0..<Int(frameCount) {
                // 1. Update LFO Phase
                lfoPhase += 1.0 / sampleRate
                
                // 2. Frequency Modulation
                // LFO: Triangle wave for smoother sweep than sine, 0.0 to 1.0
                // let lfoValue = 0.5 + 0.5 * sin(2.0 * .pi * self.sweepRate * lfoPhase) // OLD SINE
                
                // Triangle LFO math:
                let t = self.sweepRate * lfoPhase
                let dt = t - floor(t)
                let lfoValue = abs(2.0 * dt - 1.0) // Triangle 1->0->1
                
                let currentFreq = self.lowFreq + (self.highFreq - self.lowFreq) * lfoValue
                
                // 3. Tone Phase Integration
                tonePhase += currentFreq / sampleRate
                if tonePhase >= 1.0 { tonePhase -= 1.0 }
                
                // 4. Generate Audio (Square Wave for Max Loudness)
                // Sine was: let sample = Float(sin(2.0 * .pi * tonePhase)) * 0.9
                // Square Wave:
                let val = sin(2.0 * .pi * tonePhase)
                let sample: Float = (val >= 0 ? 0.9 : -0.9) // Hard square wave
                
                for buffer in ablPointer {
                    let buf = buffer.mData?.assumingMemoryBound(to: Float.self)
                    buf?[frame] = sample
                }
            }
            return noErr
        }

        engine.attach(source)
        engine.connect(source, to: engine.mainMixerNode, format: nil)

        do {
            try engine.start()
            self.audioEngine = engine
            self.sourceNode = source
        } catch {}
    }

    private func stopAudioEngine() {
        audioEngine?.stop()
        audioEngine = nil
        sourceNode = nil
    }
    
    // MARK: - Flashlight
    private func startFlash() {
        Task {
            // Keep flashing while siren is playing AND strobe is enabled
            while isPlaying && includeStrobe {
                for (on, duration) in sosPattern {
                    guard isPlaying && includeStrobe else {
                        setTorch(on: false)
                        return
                    }
                    setTorch(on: on)
                    try? await Task.sleep(nanoseconds: UInt64(duration * 1_000_000_000))
                }
            }
            setTorch(on: false)
        }
    }
    
    private func stopFlash() {
        setTorch(on: false)
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
