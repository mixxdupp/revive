import SwiftUI

struct VerticalGuideView: View {
    let technique: Technique
    @State private var expandedStep: Int? = 0 // Start with step 1 open
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            DesignSystem.backgroundPrimary.edgesIgnoringSafeArea(.all)
            
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    
                    // MARK: - Header
                    VStack(alignment: .leading, spacing: 8) {
                        Button(action: { dismiss() }) {
                            HStack(spacing: 4) {
                                Image(systemName: "chevron.left")
                                Text("Browse")
                            }
                            .font(.headline)
                            .foregroundStyle(technique.domain.color)
                        }
                        .padding(.bottom, 10)
                        
                        Text(technique.name)
                            .font(.system(size: 34, weight: .bold, design: .rounded))
                            .foregroundStyle(DesignSystem.textPrimary)
                            .fixedSize(horizontal: false, vertical: true)
                        
                        Text(technique.subtitle)
                            .font(.body)
                            .foregroundStyle(DesignSystem.textSecondary)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    
                    if technique.isCritical {
                        EmergencyWarningBanner()
                            .padding(.horizontal, 20)
                    }
                    
                    // MARK: - Steps List
                    VStack(spacing: 16) {
                        ForEach(0..<technique.steps.count, id: \.self) { index in
                            StepAccordionRow(
                                step: technique.steps[index],
                                stepIndex: index,
                                domain: technique.domain,
                                expandedStep: $expandedStep
                            )
                        }
                    }

                    
                    // MARK: - Source Link
                    if let sourceName = technique.sourceName, let sourceUrl = technique.sourceUrl, let url = URL(string: sourceUrl) {
                        Link(destination: url) {
                            HStack(spacing: 6) {
                                Text("Source:")
                                    .font(.footnote)
                                    .foregroundStyle(.secondary)
                                
                                Text(sourceName)
                                    .font(.footnote.weight(.semibold))
                                    .foregroundStyle(technique.domain.color)
                                    .underline()
                                
                                Image(systemName: "arrow.up.right")
                                    .font(.caption2)
                                    .foregroundStyle(technique.domain.color)
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 8)
                    }
                    
                    Spacer().frame(height: 120) // Space for floating button
                }
            }
            
            // MARK: - Floating Action Button
            VStack {
                Spacer()
                if let current = expandedStep, current < technique.steps.count - 1 {
                    Button(action: {
                        withAnimation {
                            expandedStep = current + 1
                        }
                        HapticsService.shared.playImpact(style: .medium)
                    }) {
                        Text("Next Step")
                            .font(.headline.weight(.bold))
                            .foregroundStyle(.white)
                            .padding(.horizontal, 32)
                            .padding(.vertical, 16)
                            .background(technique.domain.color)
                            .clipShape(Capsule())
                            .shadow(color: technique.domain.color.opacity(0.4), radius: 10, x: 0, y: 5)
                    }
                    .padding(.bottom, 30)
                    .transition(.scale.combined(with: .opacity))
                } else if expandedStep == technique.steps.count - 1 {
                    Button(action: {
                        dismiss()
                        HapticsService.shared.playNotification(type: .success)
                    }) {
                        Text("Finish Guide")
                            .font(.headline.weight(.bold))
                            .foregroundStyle(.white)
                            .padding(.horizontal, 32)
                            .padding(.vertical, 16)
                            .background(Color.green)
                            .clipShape(Capsule())
                            .shadow(color: Color.green.opacity(0.4), radius: 10, x: 0, y: 5)
                    }
                    .padding(.bottom, 30)
                }
            }
        }
        .navigationBarHidden(true)
    }
}
