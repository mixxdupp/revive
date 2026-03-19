import SwiftUI

struct TechniqueRow: View {
    let technique: Technique
    
    var body: some View {
        HStack(spacing: 16) {
            // No gradient, just pure color. List Style.
            ZStack {
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(technique.domain.color) // Solid Domain Color
                
                Image(systemName: technique.icon)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(.white)
            }
            .frame(width: 48, height: 48) // Standard List Icon Size
            
            VStack(alignment: .leading, spacing: 4) {
                Text(technique.name)
                    .font(.headline) // Standard iOS Headline
                    .fontWeight(.semibold)
                    .foregroundStyle(DesignSystem.textPrimary)
                    .lineLimit(1)
                
                Text(technique.subtitle)
                    .font(.subheadline) // Standard iOS Subheadline
                    .foregroundStyle(DesignSystem.textSecondary)
                    .lineLimit(1)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.caption)
                .fontWeight(.bold)
                .foregroundStyle(DesignSystem.textSecondary.opacity(0.4))
        }
        .padding(16)
        .background(Color(uiColor: .secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .accessibilityElement(children: .combine)
        .accessibilityAddTraits(.isButton)
    }
}
