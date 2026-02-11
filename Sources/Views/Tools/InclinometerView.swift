import SwiftUI
import CoreMotion

struct InclinometerView: View {
    @State private var pitch: Double = 0  // Forward/back tilt
    @State private var roll: Double = 0   // Side tilt
    @State private var motionManager = CMMotionManager()
    @State private var isActive = false

    var slopeAngle: Double {
        // Primary angle (pitch when device is held upright)
        abs(pitch * 180 / .pi)
    }

    var rollAngle: Double {
        abs(roll * 180 / .pi)
    }

    var slopeCategory: (String, Color) {
        switch slopeAngle {
        case 0..<5:    return ("Level", .green)
        case 5..<15:   return ("Gentle Slope", .blue)
        case 15..<30:  return ("Moderate Slope", .orange)
        case 30..<45:  return ("Steep", .red)
        default:       return ("Very Steep", .red)
        }
    }

    var body: some View {
        VStack(spacing: 24) {
            Spacer()

            // MARK: - Bubble Level
            ZStack {
                // Outer ring
                Circle()
                    .stroke(Color.gray.opacity(0.3), lineWidth: 2)
                    .frame(width: 220, height: 220)

                // Cross hairs
                Rectangle()
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: 1, height: 220)
                Rectangle()
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: 220, height: 1)

                // Center target
                Circle()
                    .stroke(Color.green.opacity(0.4), lineWidth: 1)
                    .frame(width: 40, height: 40)

                // Bubble
                Circle()
                    .fill(slopeAngle < 3 ? Color.green : Color.orange)
                    .frame(width: 24, height: 24)
                    .shadow(color: (slopeAngle < 3 ? Color.green : Color.orange).opacity(0.5), radius: 8)
                    .offset(
                        x: CGFloat(roll * 180 / .pi) * 2.5,
                        y: CGFloat(pitch * 180 / .pi) * 2.5
                    )
                    .animation(.interpolatingSpring(stiffness: 100, damping: 12), value: pitch)
                    .animation(.interpolatingSpring(stiffness: 100, damping: 12), value: roll)
            }

            // MARK: - Angle Readout
            VStack(spacing: 8) {
                Text(String(format: "%.1f°", slopeAngle))
                    .font(.system(size: 56, weight: .bold, design: .rounded))
                    .foregroundStyle(slopeCategory.1)
                    .contentTransition(.numericText())
                    .animation(.default, value: slopeAngle)

                Text(slopeCategory.0)
                    .font(.title3.weight(.semibold))
                    .foregroundStyle(DesignSystem.textSecondary)
            }

            Text("Inclinometer")
                .font(.system(size: 28, weight: .bold, design: .serif))
                .foregroundStyle(DesignSystem.textPrimary)

            // MARK: - Usage hints
            VStack(spacing: 4) {
                Label("Shelter: <15° for drainage", systemImage: "house.fill")
                Label("Avalanche risk: >30°", systemImage: "mountain.2.fill")
                Label("Campsite: <5° ideal", systemImage: "tent.fill")
            }
            .font(.subheadline)
            .foregroundStyle(DesignSystem.textSecondary)

            Spacer()

            // Start/Stop
            Button(action: toggleMotion) {
                Text(isActive ? "STOP" : "START LEVEL")
                    .font(.title2.weight(.bold))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 20)
                    .background(isActive ? Color.gray : Color.teal)
                    .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
            }
            .padding(.horizontal, 40)
            .padding(.bottom, 30)
        }
        .background(Color(uiColor: .systemGroupedBackground))
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .onDisappear { stopMotion() }
    }

    private func toggleMotion() {
        if isActive { stopMotion() } else { startMotion() }
    }

    private func startMotion() {
        guard motionManager.isDeviceMotionAvailable else { return }
        isActive = true
        motionManager.deviceMotionUpdateInterval = 1.0 / 30.0
        motionManager.startDeviceMotionUpdates(to: .main) { motion, _ in
            guard let motion = motion else { return }
            pitch = motion.attitude.pitch
            roll = motion.attitude.roll
        }
    }

    private func stopMotion() {
        isActive = false
        motionManager.stopDeviceMotionUpdates()
    }
}
