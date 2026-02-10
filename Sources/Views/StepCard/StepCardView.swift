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
                    
                    // Ultra-Clean Icon (No shadows, flat style like Apple Tips)
                    Image(systemName: technique.domain.icon)
                        .font(.system(size: 90))
                        .foregroundColor(technique.domain.color)
                    
                    // Step Indicator (Top Left)
                    VStack {
                        HStack {
                            Text("Step \(stepIndex + 1)")
                                .font(.caption)
                                .fontWeight(.bold)
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
                .accessibilityHidden(true) 
                
                // Instruction Area (Bottom 45%)
                VStack(alignment: .leading, spacing: 14) {
                    Text(step.instruction)
                        .font(.title3) // Standard Title Size
                        .fontWeight(.bold) // Standard Bold
                        .foregroundColor(DesignSystem.textPrimary)
                        .fixedSize(horizontal: false, vertical: true)
                    
                    if !step.helpDetail.isEmpty {
                        Text(step.helpDetail)
                            .font(.body) // SF Pro Regular
                            .foregroundColor(DesignSystem.textSecondary)
                            .fixedSize(horizontal: false, vertical: true)
                            .lineSpacing(4)
                    }
                    
                    Spacer()
                }
                .padding(24) // Standard 24pt padding
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color(uiColor: .secondarySystemGroupedBackground)) // Clean Background
            }
            .mask(RoundedRectangle(cornerRadius: 22, style: .continuous)) // 22pt Corner Radius
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
            // Ultra-Subtle Shadow (Apple Card Style)
            .shadow(color: Color.black.opacity(0.08), radius: 12, x: 0, y: 6)
        }
    }
}
