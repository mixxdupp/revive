import SwiftUI

struct VerticalGuideView: View {
    let technique: Technique
    @State private var expandedStep: Int? = 0 // Start with step 1 open
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ScrollViewReader { proxy in
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
                                .font(.system(size: 34, weight: .bold))
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
                                .id(index) // Anchor for scrolling
                            }
                        }
                        
                        // MARK: - Source Link & Glossary
                        HStack {
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
                            }
                            
                            Spacer()
                            
                            NavigationLink(destination: GlossaryView()) {
                                HStack(spacing: 4) {
                                    Image(systemName: "text.book.closed.fill")
                                    Text("Glossary")
                                }
                                .font(.footnote.weight(.medium))
                                .foregroundStyle(.secondary)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(Color(uiColor: .secondarySystemBackground))
                                .clipShape(Capsule())
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 8)
                        
                        // MARK: - Related Techniques
                        if let relatedIds = technique.relatedIds, !relatedIds.isEmpty {
                            VStack(alignment: .leading, spacing: 16) {
                                Text("Related Guides")
                                .font(.title3.weight(.bold))
                                .foregroundStyle(DesignSystem.textPrimary)
                                .padding(.horizontal, 20)
                            
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 16) {
                                        ForEach(relatedIds, id: \.self) { id in
                                            if let relatedTechnique = ContentDatabase.shared.techniques.first(where: { $0.id == id }) {
                                                NavigationLink(destination: VerticalGuideView(technique: relatedTechnique)) {
                                                    RelatedTechniqueCard(technique: relatedTechnique)
                                                }
                                                .buttonStyle(ScalableButtonStyle())
                                            }
                                        }
                                    }
                                    .padding(.horizontal, 20)
                                }
                            }
                            .padding(.top, 24)
                        }
                        
                        Spacer().frame(height: 120) // Space for floating button
                    }
                }
                
                // MARK: - Floating Action Button
                VStack {
                    Spacer()
                    if let current = expandedStep, current < technique.steps.count - 1 {
                        Button(action: {
                            withAnimation(.easeInOut(duration: 0.35)) {
                                expandedStep = current + 1
                                proxy.scrollTo(current + 1, anchor: .center) // Auto-scroll
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
}

struct RelatedTechniqueCard: View {
    let technique: Technique
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            ZStack {
                Circle()
                    .fill(technique.domain.color.opacity(0.15))
                    .frame(width: 48, height: 48)
                
                Image(systemName: technique.icon)
                    .font(.system(size: 22))
                    .foregroundStyle(technique.domain.color)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(technique.name)
                    .font(.headline)
                    .foregroundStyle(DesignSystem.textPrimary)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                
                Text(technique.domain.rawValue.capitalized)
                    .font(.caption.weight(.medium))
                    .foregroundStyle(technique.domain.color)
            }
        }
        .padding(16)
        .frame(width: 160, height: 180, alignment: .topLeading)
        .background(Color(uiColor: .secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(Color.white.opacity(0.1), lineWidth: 0.5)
        )
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
    }
}
