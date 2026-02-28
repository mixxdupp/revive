import SwiftUI
import CoreMotion

struct InclinometerView: View {
    @State private var pitch: Double = 0  // Forward/back tilt
    @State private var roll: Double = 0   // Side tilt
    @State private var motionManager = CMMotionManager()

    var slopeAngle: Double {
        abs(pitch * 180 / .pi)
    }

    var rollAngle: Double {
        abs(roll * 180 / .pi)
    }

    var slopeCategory: (String, Color) {
        switch slopeAngle {
        case 0..<2:    return ("LEVEL", .green)
        case 2..<15:   return ("GENTLE", Color(red: 0.3, green: 0.7, blue: 1.0))
        case 15..<30:  return ("MODERATE", Color(red: 1.0, green: 0.6, blue: 0.0))
        case 30..<45:  return ("STEEP", Color(red: 1.0, green: 0.3, blue: 0.2))
        default:       return ("CRITICAL", .red)
        }
    }

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack(spacing: 0) {
                Spacer()
                    .frame(height: 20)

                Spacer()

                // MARK: - Bubble Level (Physical Precision)
                ZStack {
                    // Outer precision ring
                    Circle()
                        .stroke(Color(white: 0.15), lineWidth: 1)
                        .frame(width: 260, height: 260)

                    // Cross-hairs
                    Path { path in
                        path.move(to: CGPoint(x: 130, y: 0))
                        path.addLine(to: CGPoint(x: 130, y: 260))
                        path.move(to: CGPoint(x: 0, y: 130))
                        path.addLine(to: CGPoint(x: 260, y: 130))
                    }
                    .stroke(Color(white: 0.1), lineWidth: 0.5)
                    .frame(width: 260, height: 260)

                    // Center "bullseye" target ring
                    Circle()
                        .stroke(Color.green.opacity(0.4), lineWidth: 1.5)
                        .frame(width: 48, height: 48)

                    // Fluid physical bubble
                    Circle()
                        .fill(slopeCategory.1)
                        .frame(width: 40, height: 40)
                        .shadow(color: slopeCategory.1.opacity(0.5), radius: 10)
                        .offset(
                            x: CGFloat(roll * 180 / .pi) * 3.0,
                            y: CGFloat(pitch * 180 / .pi) * 3.0
                        )
                        .animation(.interpolatingSpring(stiffness: 120, damping: 14), value: pitch)
                        .animation(.interpolatingSpring(stiffness: 120, damping: 14), value: roll)
                }
                .frame(width: 260, height: 260)
                .accessibilityHidden(true)

                Spacer()
                    .frame(height: 40)

                // MARK: - Massive Angle Readout
                VStack(spacing: 8) {
                    Text("INCLINOMETER")
                        .font(.system(size: 13, weight: .medium, design: .rounded))
                        .foregroundStyle(Color(white: 0.45))
                        .kerning(2)
                    
                    Text(String(format: "%.1f°", slopeAngle))
                        .font(.system(size: 80, weight: .light, design: .rounded).monospacedDigit())
                        .foregroundStyle(.white)
                        .contentTransition(.numericText())
                        .animation(.default, value: slopeAngle)

                    Text(slopeCategory.0)
                        .font(.system(size: 14, weight: .medium, design: .rounded))
                        .foregroundStyle(slopeCategory.1)
                        .kerning(2)
                }
                .accessibilityElement(children: .combine)
                .accessibilityLabel("\(String(format: "%.1f°", slopeAngle)), \(slopeCategory.0)")

                Spacer()

                // MARK: - Survival Metric Cards
                HStack(spacing: 12) {
                    InclineMetricCard(
                        title: "SHELTER",
                        threshold: "<15°",
                        icon: "house.fill",
                        color: Color(red: 0.3, green: 0.7, blue: 1.0)
                    )
                    InclineMetricCard(
                        title: "AVALANCHE",
                        threshold: ">30°",
                        icon: "mountain.2.fill",
                        color: Color(red: 1.0, green: 0.3, blue: 0.2)
                    )
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 32)
            }
        }
        .navigationTitle("Inclinometer")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear { startMotion() }
        .onDisappear { stopMotion() }
    }

    private func startMotion() {
        guard motionManager.isDeviceMotionAvailable else { return }
        UIApplication.shared.isIdleTimerDisabled = true
        motionManager.deviceMotionUpdateInterval = 1.0 / 60.0
        motionManager.startDeviceMotionUpdates(to: .main) { motion, _ in
            guard let motion = motion else { return }
            pitch = motion.attitude.pitch
            roll = motion.attitude.roll
            
            // Subtle haptic tick when locking perfectly flat
            if abs(pitch) < 0.03 && abs(roll) < 0.03 {
                HapticsService.shared.playImpact(style: .light)
            }
        }
    }

    private func stopMotion() {
        motionManager.stopDeviceMotionUpdates()
        UIApplication.shared.isIdleTimerDisabled = false
        withAnimation {
            pitch = 0
            roll = 0
        }
    }
}

// MARK: - Metric Card Component
private struct InclineMetricCard: View {
    let title: String
    let threshold: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.system(size: 12, weight: .bold))
                    .foregroundStyle(color)
                Text(title)
                    .font(.system(size: 13, weight: .bold, design: .rounded))
                    .foregroundStyle(Color(white: 0.5))
                    .kerning(0.5)
            }
            
            Text(threshold)
                .font(.system(size: 26, weight: .bold, design: .rounded))
                .foregroundStyle(.white)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(18)
        .background(Color(white: 0.1))
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
    }
}
