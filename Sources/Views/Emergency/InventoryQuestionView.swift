import SwiftUI

struct InventoryQuestionView: View {
    let situation: EmergencySituation
    @Environment(\.dismiss) var dismiss
    
    var rootNode: TriageNode? {
        ContentDatabase.shared.triageTrees[situation]
    }
    
    var body: some View {
        if let node = rootNode {
            TriageQuestionView(node: node, situationColor: situation.color)
        } else {
            ZStack {
                DesignSystem.backgroundPrimary.edgesIgnoringSafeArea(.all)
                Text("No triage flow for \(situation.displayName)")
                    .foregroundColor(DesignSystem.textSecondary)
            }
        }
    }
}

// MARK: - Recursive Triage Question View

struct TriageQuestionView: View {
    let node: TriageNode
    let situationColor: Color
    @Environment(\.dismiss) var dismiss
    
    let columns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]
    
    var body: some View {
        ZStack {
            DesignSystem.backgroundPrimary.edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 0) {
                // Nav Bar
                HStack {
                    Button(action: { dismiss() }) {
                        HStack(spacing: 4) {
                            Image(systemName: "chevron.left")
                            Text("Back")
                        }
                        .font(Typography.button)
                        .foregroundColor(DesignSystem.textSecondary)
                    }
                    Spacer()
                }
                .padding(.horizontal, Layout.screenPadding)
                .padding(.top, 20)
                .padding(.bottom, 20)
                
                // Question
                HStack {
                    Text(node.question)
                        .font(Typography.emergencyTitle)
                        .foregroundColor(DesignSystem.textPrimary)
                        .fixedSize(horizontal: false, vertical: true)
                    Spacer()
                }
                .padding(.horizontal, Layout.screenPadding)
                .padding(.bottom, 24)
                
                // Options
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 12) {
                        ForEach(node.options) { option in
                            triageOptionView(option)
                        }
                    }
                    .padding(.horizontal, Layout.screenPadding)
                    .padding(.bottom, 30)
                }
            }
        }
        .navigationBarHidden(true)
    }
    
    @ViewBuilder
    private func triageOptionView(_ option: TriageOption) -> some View {
        switch option.destination {
        case .nextQuestion(let nextNode):
            NavigationLink(destination: TriageQuestionView(node: nextNode, situationColor: situationColor)) {
                TriageOptionCard(option: option, situationColor: situationColor)
            }
            .buttonStyle(ScalableButtonStyle())
            
        case .technique(let techniqueID):
            if let technique = ContentDatabase.shared.techniques.first(where: { $0.id == techniqueID }) {
                NavigationLink(destination: StepCardPager(technique: technique)) {
                    TriageOptionCard(option: option, situationColor: situationColor, isLeaf: true)
                }
                .buttonStyle(ScalableButtonStyle())
            } else {
                TriageOptionCard(option: option, situationColor: situationColor)
                    .opacity(0.4)
            }
            
        case .techniqueList(let techniqueIDs):
            let techniques = techniqueIDs.compactMap { id in
                ContentDatabase.shared.techniques.first(where: { $0.id == id })
            }
            if !techniques.isEmpty {
                NavigationLink(destination: TriageTechniqueListView(techniques: techniques, situationColor: situationColor)) {
                    TriageOptionCard(option: option, situationColor: situationColor, isLeaf: true)
                }
                .buttonStyle(ScalableButtonStyle())
            } else {
                TriageOptionCard(option: option, situationColor: situationColor)
                    .opacity(0.4)
            }
        }
    }
}

// MARK: - Option Card

struct TriageOptionCard: View {
    let option: TriageOption
    let situationColor: Color
    var isLeaf: Bool = false
    
    var body: some View {
        VStack(spacing: 10) {
            Image(systemName: option.icon)
                .font(.system(size: 32))
                .foregroundColor(.white)
                .frame(width: 52, height: 52)
                .background(
                    LinearGradient(
                        colors: [situationColor, situationColor.opacity(0.7)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .clipShape(RoundedRectangle(cornerRadius: 14))
            
            Text(option.label)
                .font(Typography.headline)
                .foregroundColor(DesignSystem.textPrimary)
                .multilineTextAlignment(.center)
                .lineLimit(3)
                .minimumScaleFactor(0.8)
            
            if isLeaf {
                Image(systemName: "arrow.right.circle.fill")
                    .font(.system(size: 12))
                    .foregroundColor(situationColor)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 18)
        .padding(.horizontal, 8)
        .background(DesignSystem.backgroundSecondary)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .contentShape(Rectangle()) // Essential for NavigationLink hit testing
    }
}

// MARK: - Technique List (for techniqueList destinations)

struct TriageTechniqueListView: View {
    let techniques: [Technique]
    let situationColor: Color
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            DesignSystem.backgroundPrimary.edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 0) {
                HStack {
                    Button(action: { dismiss() }) {
                        HStack(spacing: 4) {
                            Image(systemName: "chevron.left")
                            Text("Back")
                        }
                        .font(Typography.button)
                        .foregroundColor(DesignSystem.textSecondary)
                    }
                    Spacer()
                }
                .padding(.horizontal, Layout.screenPadding)
                .padding(.top, 20)
                .padding(.bottom, 10)
                
                Text("Recommended Techniques")
                    .font(Typography.emergencyTitle)
                    .foregroundColor(DesignSystem.textPrimary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, Layout.screenPadding)
                    .padding(.bottom, 20)
                
                ScrollView {
                    VStack(spacing: 12) {
                        ForEach(techniques) { technique in
                            NavigationLink(destination: StepCardPager(technique: technique)) {
                                HStack(spacing: 14) {
                                    Image(systemName: "checkmark.circle.fill")
                                        .font(.system(size: 20))
                                        .foregroundColor(situationColor)
                                        .frame(width: 40, height: 40)
                                        .background(situationColor.opacity(0.15))
                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                    
                                    VStack(alignment: .leading, spacing: 3) {
                                        Text(technique.name)
                                            .font(Typography.headline)
                                            .foregroundColor(DesignSystem.textPrimary)
                                            .lineLimit(1)
                                        
                                        Text(technique.subtitle)
                                            .font(Typography.caption)
                                            .foregroundColor(DesignSystem.textSecondary)
                                            .lineLimit(2)
                                    }
                                    
                                    Spacer()
                                    
                                    Image(systemName: "chevron.right")
                                        .font(.system(size: 14, weight: .semibold))
                                        .foregroundColor(DesignSystem.textSecondary)
                                }
                                .padding(14)
                                .background(DesignSystem.backgroundSecondary)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                            }
                            .buttonStyle(ScalableButtonStyle())
                        }
                    }
                    .padding(.horizontal, Layout.screenPadding)
                    .padding(.bottom, 30)
                }
            }
        }
        .navigationBarHidden(true)
    }
}
