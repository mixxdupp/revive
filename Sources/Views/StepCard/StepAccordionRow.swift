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
                withAnimation(.easeInOut(duration: 0.25)) {
                    if isExpanded {
                        expandedStep = nil
                    } else {
                        expandedStep = stepIndex
                    }
                }
            }) {
                HStack(alignment: .top, spacing: 0) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Step \(stepIndex + 1)")
                            .font(.footnote.weight(.heavy))
                            .textCase(.uppercase)
                            .foregroundStyle(isExpanded ? .white.opacity(0.8) : domain.color)
                        
                        Text(step.instruction)
                            .font(.headline.weight(.bold))
                            .foregroundStyle(isExpanded ? .white : .primary)
                            .lineLimit(nil)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    
                    Spacer(minLength: 16) // Pushes chevron to the right
                    
                    Image(systemName: "chevron.down")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundStyle(isExpanded ? .white : .secondary)
                        .rotationEffect(.degrees(isExpanded ? 180 : 0))
                        .animation(.easeInOut(duration: 0.25), value: isExpanded)
                        .padding(.top, 4)
                        .frame(width: 24, alignment: .trailing) // Lock chevron width
                }
                .frame(maxWidth: .infinity, alignment: .leading)
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
                    
                    if !step.helpDetail.isEmpty {
                        Text(step.helpDetail)
                            .font(.body)
                            .foregroundStyle(DesignSystem.textSecondary)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    // Shown when step mentions calling emergency services
                    if step.instruction.localizedCaseInsensitiveContains("emergency services") ||
                       step.helpDetail.localizedCaseInsensitiveContains("call emergency services") {
                        NavigationLink(destination: EmergencyDirectoryView()) {
                            HStack(spacing: 10) {
                                Image(systemName: "phone.arrow.up.right.fill")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundStyle(.white)
                                    .frame(width: 32, height: 32)
                                    .background(Color.red)
                                    .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                                
                                VStack(alignment: .leading, spacing: 2) {
                                    Text("Find Your Emergency Number")
                                        .font(.subheadline.weight(.semibold))
                                        .foregroundStyle(.primary)
                                    Text("Global directory of emergency services")
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                                
                                Spacer()
                                
                                Image(systemName: "chevron.right")
                                    .font(.caption.weight(.bold))
                                    .foregroundStyle(.secondary)
                            }
                            .padding(12)
                            .background(Color.red.opacity(0.08))
                            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                            .overlay(
                                RoundedRectangle(cornerRadius: 12, style: .continuous)
                                    .strokeBorder(Color.red.opacity(0.2), lineWidth: 1)
                            )
                        }
                        .buttonStyle(.plain)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(20)
                .background(Color(uiColor: .secondarySystemGroupedBackground))
                .overlay(
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(Color(uiColor: .separator)),
                    alignment: .top
                )
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .padding(.horizontal, 20)
    }
}
