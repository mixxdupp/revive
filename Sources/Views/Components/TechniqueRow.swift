import SwiftUI

struct TechniqueRow: View {
    let technique: Technique
    
    var body: some View {
        HStack(spacing: 16) {
            // MARK: - ICON (Squircle Gradient)
            ZStack {
                // Background Gradient
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: [
                                technique.domain.color,
                                technique.domain.color.opacity(0.7)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .shadow(color: technique.domain.color.opacity(0.3), radius: 8, x: 0, y: 4)
                
                // Icon
                Image(systemName: technique.icon)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(.white)
            }
            .frame(width: 52, height: 52)
            
            // MARK: - CONTENT
            VStack(alignment: .leading, spacing: 4) {
                Text(technique.name)
                    .font(.system(size: 17, weight: .bold, design: .rounded))
                    .foregroundStyle(DesignSystem.textPrimary)
                    .lineLimit(1)
                
                Text(technique.subtitle)
                    .font(.system(size: 14, weight: .medium, design: .default))
                    .foregroundStyle(DesignSystem.textSecondary)
                    .lineLimit(1)
                
                // Optional Metadata Badges could go here
                // e.g. Difficulty, Time
            }
            
            Spacer()
            
            // MARK: - CHEVRON
            Image(systemName: "chevron.right")
                .font(.system(size: 14, weight: .bold))
                .foregroundStyle(DesignSystem.textSecondary.opacity(0.5))
        }
        .padding(16)
        .background(Color(uiColor: .secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 2)
    }
}
