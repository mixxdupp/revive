import SwiftUI

struct ToolsMenuView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 32) {

                // MARK: - Header
                VStack(alignment: .leading, spacing: 4) {
                    Text("Tools")
                        .font(.system(size: 40, weight: .bold, design: .serif))
                        .foregroundStyle(DesignSystem.textPrimary)
                    Text("Offline Survival Utilities")
                        .font(.body.weight(.medium))
                        .foregroundStyle(DesignSystem.textSecondary)
                }
                .padding(.top, 24)
                .padding(.horizontal, 24)

                // MARK: - Tool Cards
                VStack(spacing: 16) {
                    NavigationLink(destination: SOSFlashlightView()) {
                        ToolCard(
                            icon: "flashlight.on.fill",
                            title: "SOS Flashlight",
                            subtitle: "Morse code SOS via camera flash",
                            color: .orange
                        )
                    }
                    .buttonStyle(ScalableButtonStyle())

                    NavigationLink(destination: CPRMetronomeView()) {
                        ToolCard(
                            icon: "heart.fill",
                            title: "CPR Metronome",
                            subtitle: "110 BPM chest compression pacer",
                            color: .red
                        )
                    }
                    .buttonStyle(ScalableButtonStyle())

                    NavigationLink(destination: EmergencySirenView()) {
                        ToolCard(
                            icon: "speaker.wave.3.fill",
                            title: "Emergency Siren",
                            subtitle: "Max-volume distress signal",
                            color: .purple
                        )
                    }
                    .buttonStyle(ScalableButtonStyle())

                    NavigationLink(destination: InclinometerView()) {
                        ToolCard(
                            icon: "level.fill",
                            title: "Inclinometer",
                            subtitle: "Slope angle & bubble level",
                            color: .teal
                        )
                    }
                    .buttonStyle(ScalableButtonStyle())
                }
                .padding(.horizontal, 24)

                Spacer(minLength: 40)
            }
        }
        .background(Color(uiColor: .systemGroupedBackground))
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Tool Card Component
struct ToolCard: View {
    let icon: String
    let title: String
    let subtitle: String
    let color: Color

    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 28))
                .foregroundStyle(.white)
                .frame(width: 56, height: 56)
                .background(color)
                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))

            VStack(alignment: .leading, spacing: 3) {
                Text(title)
                    .font(.headline)
                    .foregroundStyle(DesignSystem.textPrimary)
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundStyle(DesignSystem.textSecondary)
                    .lineLimit(1)
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(DesignSystem.textSecondary)
        }
        .padding(16)
        .background(Color(uiColor: .secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .shadow(color: Color.black.opacity(0.06), radius: 6, x: 0, y: 3)
    }
}
