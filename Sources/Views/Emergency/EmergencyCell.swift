import SwiftUI

struct EmergencyCell: View {
    let situation: EmergencySituation
    
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            // MARK: - 1. Glassmorphic Background with Gradient
            RoundedRectangle(cornerRadius: 24, style: .continuous)
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
            
            // MARK: - 2. Content
            VStack(alignment: .leading) {
                // Icon Header
                HStack(alignment: .top) {
                    ZStack {
                        Circle()
                            .fill(situation.color.opacity(0.1))
                            .frame(width: 48, height: 48)
                        
                        Image(systemName: situation.icon)
                            .font(.system(size: 24, weight: .semibold))
                            .foregroundStyle(situation.color)
                    }
                    
                    Spacer()
                    
                    // Optional: Chevron or Indicator (Clean)
                    Image(systemName: "chevron.right")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundStyle(situation.color.opacity(0.4))
                        .padding(.top, 8)
                        .padding(.trailing, 4)
                }
                
                Spacer()
                
                // Title
                Text(situation.displayName)
                    .font(.system(size: 20, weight: .bold))
                    .foregroundStyle(DesignSystem.textPrimary)
                    .lineLimit(2)
                    .minimumScaleFactor(0.85)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(16)
        }
        .frame(minHeight: 160)
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .strokeBorder(situation.color.opacity(0.2), lineWidth: 1)
        )
        // Soft Shadow for Depth
        .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 4)
        .accessibilityElement(children: .combine)
        .accessibilityAddTraits(.isButton)
    }
}
