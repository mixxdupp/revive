import SwiftUI
import AVFoundation

struct SOSFlashlightView: View {
    @State private var isFlashing = false
    @State private var statusText = "Ready"

    // SOS Morse: ··· — — — ···
    // Dot = 0.2s, Dash = 0.6s, gap between = 0.2s, letter gap = 0.6s, word gap = 1.4s
    private let sosPattern: [(Bool, Double)] = {
        var pattern: [(Bool, Double)] = []
        // S: ···
        for i in 0..<3 {
            pattern.append((true, 0.2))   // dot ON
            if i < 2 { pattern.append((false, 0.2)) } // intra-char gap
        }
        pattern.append((false, 0.6)) // letter gap
        // O: ---
        for i in 0..<3 {
            pattern.append((true, 0.6))   // dash ON
            if i < 2 { pattern.append((false, 0.2)) }
        }
        pattern.append((false, 0.6)) // letter gap
        // S: ···
        for i in 0..<3 {
            pattern.append((true, 0.2))
            if i < 2 { pattern.append((false, 0.2)) }
        }
        pattern.append((false, 1.4)) // word gap
        return pattern
    }()

    var body: some View {
        VStack(spacing: 40) {
            Spacer()

            // Visual indicator
            ZStack {
                Circle()
                    .fill(isFlashing ? Color.yellow : Color.gray.opacity(0.3))
                    .frame(width: 160, height: 160)
                    .shadow(color: isFlashing ? .yellow.opacity(0.6) : .clear, radius: 30)
                    .animation(.easeInOut(duration: 0.15), value: isFlashing)

                Image(systemName: "flashlight.on.fill")
                    .font(.system(size: 56))
                    .foregroundStyle(isFlashing ? .black : .white)
            }
            .accessibilityHidden(true)

            Text("SOS Flashlight")
                .font(.system(size: 32, weight: .bold, design: .serif))
                .foregroundStyle(DesignSystem.textPrimary)

            Text(statusText)
                .font(.title3.weight(.medium))
                .foregroundStyle(DesignSystem.textSecondary)

            // Start/Stop button
            Button(action: toggleSOS) {
                Text(isFlashing ? "STOP" : "START SOS")
                    .font(.title2.weight(.bold))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 20)
                    .background(isFlashing ? Color.gray : Color.orange)
                    .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
            }
            .padding(.horizontal, 40)

            Text("Points camera flash at the sky.\nRepeatedly sends ··· — — — ···")
                .font(.caption)
                .foregroundStyle(DesignSystem.textSecondary)
                .multilineTextAlignment(.center)

            Spacer()
        }
        .background(Color(uiColor: .systemGroupedBackground))
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .onDisappear { stopFlashing() }
    }

    private func toggleSOS() {
        if isFlashing {
            stopFlashing()
        } else {
            startFlashing()
        }
    }

    private func startFlashing() {
        statusText = "Sending SOS..."
        isFlashing = true
        flashLoop()
    }

    private func stopFlashing() {
        isFlashing = false
        statusText = "Ready"
        setTorch(on: false)
    }

    private func flashLoop() {
        Task {
            while isFlashing {
                for (on, duration) in sosPattern {
                    guard isFlashing else { return }
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
            // Silently fail — device may not support torch
        }
    }
}
