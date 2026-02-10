import SwiftUI

struct RelatedTechniquesCard: View {
    let technique: Technique
    let relatedTechniques: [Technique]
    let onDismiss: () -> Void
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                // Celebration Area (Top 40%)
                ZStack {
                    Rectangle()
                        .fill(DesignSystem.backgroundSecondary)
                        .overlay(
                            Image(systemName: "checkmark.circle.fill")
                                .font(.system(size: 80))
                                .foregroundColor(technique.domain.color.opacity(0.3))
                        )
                    
                    Text("Complete")
                        .font(Typography.emergencyTitle)
                        .foregroundColor(technique.domain.color)
                        .offset(y: 60)
                }
                .frame(height: geometry.size.height * 0.4)
                .clipped()
                
                // Content Area (Bottom 60%)
                VStack(alignment: .leading, spacing: 20) {
                    Text("What's Next?")
                        .font(Typography.title)
                        .foregroundColor(DesignSystem.textPrimary)
                        .padding(.top, 20)
                    
                    ScrollView {
                        VStack(spacing: 12) {
                            ForEach(relatedTechniques) { related in
                                NavigationLink(destination: StepCardPager(technique: related)) {
                                    TechniqueRow(technique: related)
                                        .glassCard()
                                }
                                .buttonStyle(PlainButtonStyle()) // Important for lists
                            }
                        }
                    }
                    
                    Spacer()
                    
                    Button(action: onDismiss) {
                        Text("Return to Guide")
                            .font(Typography.button)
                            .foregroundColor(DesignSystem.textPrimary)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(DesignSystem.backgroundTertiary)
                            .cornerRadius(Layout.cornerRadius)
                    }
                    .padding(.bottom, 20)
                }
                .padding(.horizontal, Layout.cardPadding)
                .frame(maxWidth: .infinity, alignment: .leading) // Ensure full width
                .background(.ultraThinMaterial)
            }
            .mask(RoundedRectangle(cornerRadius: Layout.cornerRadius))
            .padding(.horizontal, Layout.screenPadding)
            .padding(.vertical, 10)
            .shadow(color: Color.black.opacity(0.3), radius: 20, x: 0, y: 10)
        }
    }
}
