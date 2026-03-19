import SwiftUI

struct EmergencyCell: View {
    let situation: EmergencySituation
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(.ultraThinMaterial)
                .overlay(
                    LinearGradient(
                        colors: [
                            situation.color.opacity(0.15),
                            situation.color.opacity(0.02)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
            
            VStack(alignment: .leading, spacing: 0) {
                // Icon
                ZStack {
                    Circle()
                        .fill(situation.color.opacity(0.15))
                        .frame(width: 44, height: 44)
                    
                    Image(systemName: situation.icon)
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundStyle(situation.color)
                }
                
                Spacer(minLength: 0)
                
                // Title
                Text(situation.displayName)
                    .font(.system(size: 18, weight: .bold, design: .default))
                    .foregroundStyle(DesignSystem.textPrimary)
                    .lineLimit(2)
                    .minimumScaleFactor(0.85)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(16)
        }
        .frame(height: 160)
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .strokeBorder(Color.white.opacity(0.1), lineWidth: 0.5)
        )
        // Soft Shadow for Depth
        .shadow(color: Color.black.opacity(0.15), radius: 10, x: 0, y: 5)
        .accessibilityElement(children: .combine)
        .accessibilityLabel(situation.displayName)
        .accessibilityHint("Opens triage guide for \(situation.displayName)")
        .accessibilityAddTraits(.isButton)
    }
}
