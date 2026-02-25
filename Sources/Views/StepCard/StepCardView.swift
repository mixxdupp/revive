import SwiftUI
import SpriteKit

struct StepCardView: View {
    let technique: Technique
    let step: TechniqueStep
    let stepIndex: Int
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        // Step Indicator
                        HStack {
                            Text("Step \(stepIndex + 1)")
                                .font(.caption.weight(.bold))
                                .textCase(.uppercase)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 8)
                                .background(technique.domain.color.opacity(0.15))
                                .clipShape(Capsule())
                                .foregroundColor(technique.domain.color)
                                .overlay(
                                    Capsule()
                                        .stroke(technique.domain.color.opacity(0.3), lineWidth: 1)
                                )
                            Spacer()
                        }
                        .padding(.bottom, 8)
                        
                        Text(step.instruction)
                            .font(.title2.weight(.bold))
                            .foregroundColor(DesignSystem.textPrimary)
                            .fixedSize(horizontal: false, vertical: true)
                        
                        if !step.helpDetail.isEmpty {
                            Text(step.helpDetail)
                                .font(.body)
                                .foregroundColor(DesignSystem.textSecondary)
                                .fixedSize(horizontal: false, vertical: true)
                                .lineSpacing(6)
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.vertical, 30)
                }
                .frame(width: geometry.size.width, height: geometry.size.height)
                .background(Color(uiColor: .secondarySystemGroupedBackground))
            }
            .mask(RoundedRectangle(cornerRadius: 22, style: .continuous))
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
            // Accessibility Configuration
            .accessibilityElement(children: .ignore)
            .accessibilityLabel("Step \(stepIndex + 1)")
            .accessibilityValue("\(step.instruction). \(step.helpDetail)")
            .accessibilityAddTraits(.isStaticText)
        }
    }
}
