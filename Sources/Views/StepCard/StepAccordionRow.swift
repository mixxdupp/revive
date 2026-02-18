import SwiftUI

struct StepAccordionRow: View {
    let step: TechniqueStep
    let stepIndex: Int
    let domain: SurvivalDomain
    @Binding var expandedStep: Int?
    
    var isExpanded: Bool {
        expandedStep == stepIndex
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // MARK: - Header (Always Visible)
            Button(action: {
                withAnimation(.easeInOut(duration: 0.35)) {
                    if isExpanded {
                        expandedStep = nil
                    } else {
                        expandedStep = stepIndex
                    }
                }
            }) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Step \(stepIndex + 1)")
                            .font(.caption.weight(.bold))
                            .textCase(.uppercase)
                            .foregroundStyle(isExpanded ? .white.opacity(0.8) : .secondary)
                        
                        Text(step.instruction)
                            .font(.headline.weight(.bold))
                            .foregroundStyle(isExpanded ? .white : .primary)
                            .lineLimit(nil)
                            .multilineTextAlignment(.leading)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    
                    Spacer()
                    
                    Image(systemName: "chevron.down")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundStyle(isExpanded ? .white : .secondary)
                        .rotationEffect(.degrees(isExpanded ? 180 : 0))
                }
                .padding(20)
                .background(
                    Group {
                        if isExpanded {
                            domain.color
                        } else {
                            Color(uiColor: .secondarySystemGroupedBackground)
                        }
                    }
                )
            }
            .buttonStyle(PlainButtonStyle())
            
            // MARK: - Expanded Content
            if isExpanded {
                VStack(alignment: .leading, spacing: 16) {
                    
                    // Alert / Warning (Simulation of provided design)
                    if step.helpDetail.contains("!") || step.helpDetail.lowercased().contains("warning") {
                        HStack(alignment: .top, spacing: 12) {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .foregroundStyle(.red)
                            
                            Text(step.helpDetail)
                                .font(.subheadline.weight(.medium))
                                .foregroundStyle(.white)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                        .padding(16)
                        .background(Color(red: 0.2, green: 0.2, blue: 0.25))
                        .cornerRadius(12)
                    } else if !step.helpDetail.isEmpty {
                        Text(step.helpDetail)
                            .font(.body)
                            .foregroundStyle(DesignSystem.textSecondary)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    
                    if let illustration = step.illustrationName {
                        Image(systemName: illustration)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 120)
                            .foregroundStyle(domain.color)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 8)
                    }
                }
                .padding(20)
                .background(Color(uiColor: .secondarySystemGroupedBackground))
                .overlay(
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(Color(uiColor: .separator)),
                    alignment: .top
                )
                .transition(.opacity)
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .background(Color(uiColor: .secondarySystemGroupedBackground))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 2)
        .padding(.horizontal, 20)
    }
}
