import SwiftUI
import SpriteKit

struct StepCardView: View {
    let technique: Technique
    let step: TechniqueStep
    let stepIndex: Int
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                // Illustration Area (Top 55%)
                ZStack {
                    Rectangle()
                        .fill(Color(uiColor: .tertiarySystemGroupedBackground))
                    
                    // Dynamic Step Illustration
                    let rawIcon = step.illustrationName ?? StepIllustrationMapper.icon(for: step, in: technique.domain)
                    let iconName = rawIcon.isEmpty ? StepIllustrationMapper.defaultIcon(for: technique.domain) : rawIcon
                    
                    Image(systemName: iconName)
                        .symbolRenderingMode(.hierarchical)
                        .font(.system(size: 120))
                        .foregroundColor(technique.domain.color)
                        .frame(width: 200, height: 200)
                        .background(
                            Circle()
                                .fill(technique.domain.color.opacity(0.1))
                        )
                    
                    // Step Indicator (Top Left)
                    VStack {
                        HStack {
                            Text("Step \(stepIndex + 1)")
                                .font(.caption.weight(.bold))
                                .textCase(.uppercase)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 6)
                                .background(.regularMaterial)
                                .clipShape(Capsule())
                                .foregroundColor(DesignSystem.textPrimary)
                            Spacer()
                        }
                        .padding(16)
                        Spacer()
                    }
                }
                .frame(height: geometry.size.height * 0.55)
                .clipped()
                
                // Instruction Area (Bottom 45%)
                ScrollView {
                    VStack(alignment: .leading, spacing: 14) {
                        Text(step.instruction)
                            .font(.title3.weight(.bold))
                            .foregroundColor(DesignSystem.textPrimary)
                            .fixedSize(horizontal: false, vertical: true)
                        
                        if !step.helpDetail.isEmpty {
                            Text(step.helpDetail)
                                .font(.body)
                                .foregroundColor(DesignSystem.textSecondary)
                                .fixedSize(horizontal: false, vertical: true)
                                .lineSpacing(4)
                        }
                    }
                    .padding(24)
                }
                .frame(width: geometry.size.width, height: geometry.size.height * 0.45)
                .background(Color(uiColor: .secondarySystemGroupedBackground))
            }
            .mask(RoundedRectangle(cornerRadius: 22, style: .continuous))
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
            .shadow(color: Color.black.opacity(0.08), radius: 12, x: 0, y: 6)
            // Accessibility Configuration
            .accessibilityElement(children: .ignore)
            .accessibilityLabel("Step \(stepIndex + 1)")
            .accessibilityValue("\(step.instruction). \(step.helpDetail)")
            .accessibilityAddTraits(.isStaticText)
        }
    }
}
