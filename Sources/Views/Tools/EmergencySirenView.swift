import SwiftUI
import AVFoundation

struct EmergencySirenView: View {
    @State private var isPlaying = false
    @State private var audioEngine: AVAudioEngine?
    @State private var sourceNode: AVAudioSourceNode?
    @State private var phase: Double = 0
    @State private var animationPhase: Double = 0

    // Siren sweeps between two frequencies
    private let lowFreq: Double = 600
    private let highFreq: Double = 1400
    private let sweepRate: Double = 2.0 // Hz — full cycle per second

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

                Image(systemName: "speaker.wave.3.fill")
                    .font(.system(size: 44))
                    .foregroundStyle(isPlaying ? .white : DesignSystem.textSecondary)
                    .symbolEffect(.variableColor.iterative, isActive: isPlaying)
            }

            Text("Emergency Siren")
                .font(.system(size: 28, weight: .bold, design: .serif))
                .foregroundStyle(DesignSystem.textPrimary)

            Text(isPlaying ? "Siren Active — Max Volume" : "Generates loud distress signal")
                .font(.body.weight(.medium))
                .foregroundStyle(isPlaying ? .red : DesignSystem.textSecondary)

            Spacer()

            // Warning
            HStack(spacing: 8) {
                Image(systemName: "ear.trianglebadge.exclamationmark")
                    .font(.subheadline)
                Text("Very loud. Hold device away from ears.")
                    .font(.caption.weight(.medium))
            }
            .foregroundStyle(DesignSystem.textSecondary)

            Button(action: toggleSiren) {
                Text(isPlaying ? "STOP SIREN" : "ACTIVATE SIREN")
                    .font(.title2.weight(.bold))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 20)
                    .background(isPlaying ? Color.gray : Color.purple)
                    .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
            }
            .padding(.horizontal, 40)
            .padding(.bottom, 30)
        }
        .background(Color(uiColor: .systemGroupedBackground))
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .onDisappear { stopSiren() }
    }

    private func toggleSiren() {
        if isPlaying { stopSiren() } else { startSiren() }
    }

    private func startSiren() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch { return }

        let engine = AVAudioEngine()
        let sampleRate = engine.outputNode.outputFormat(forBus: 0).sampleRate
        var localPhase = 0.0

        let source = AVAudioSourceNode { _, _, frameCount, audioBufferList -> OSStatus in
            let ablPointer = UnsafeMutableAudioBufferListPointer(audioBufferList)
            for frame in 0..<Int(frameCount) {
                let time = localPhase / sampleRate
                // Sweep frequency using sine wave modulation
                let freq = self.lowFreq + (self.highFreq - self.lowFreq) * 
                    (0.5 + 0.5 * sin(2.0 * .pi * self.sweepRate * time))
                let sample = Float(sin(2.0 * .pi * freq * time)) * 0.9
                for buffer in ablPointer {
                    let buf = buffer.mData?.assumingMemoryBound(to: Float.self)
                    buf?[frame] = sample
                }
                localPhase += 1
            }
            return noErr
        }

        engine.attach(source)
        engine.connect(source, to: engine.mainMixerNode, format: nil)

        do {
            try engine.start()
            self.audioEngine = engine
            self.sourceNode = source
            isPlaying = true
        } catch {
            // Failed to start audio engine
        }
    }

    private func stopSiren() {
        audioEngine?.stop()
        audioEngine = nil
        sourceNode = nil
        isPlaying = false
    }
}
