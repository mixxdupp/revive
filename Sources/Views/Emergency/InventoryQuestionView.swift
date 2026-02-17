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
            // MARK: - Ambient Background
            DesignSystem.backgroundPrimary
                .ignoresSafeArea()
            
            // Subtle Mesh Gradient Simulation (Matches Emergency/Library)
            GeometryReader { proxy in
                ZStack {
                    Circle()
                        .fill(situationColor.opacity(0.1)) // Use situation color for theme
                        .frame(width: 300, height: 300)
                        .blur(radius: 60)
                        .offset(x: -100, y: -100)
                    
                    Circle()
                        .fill(Color.orange.opacity(0.05))
                        .frame(width: 300, height: 300)
                        .blur(radius: 60)
                        .offset(x: 200, y: 100)
                }
                .frame(width: proxy.size.width, height: proxy.size.height)
            }
            .ignoresSafeArea()
            
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
                .padding(.bottom, 10)
                
                // Question
                HStack {
                    Text(node.question)
                        .font(.system(size: 32, weight: .bold, design: .serif)) // Serif for questions
                        .foregroundColor(DesignSystem.textPrimary)
                        .fixedSize(horizontal: false, vertical: true)
                    Spacer()
                }
                .padding(.horizontal, Layout.screenPadding)
                .padding(.bottom, 24)
                
                // Options
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 16) {
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
                NavigationLink(destination: VerticalGuideView(technique: technique)) {
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
        ZStack(alignment: .leading) {
            // Glass Background
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .stroke(situationColor.opacity(0.3), lineWidth: 1)
                )
            
            VStack(alignment: .leading, spacing: 12) {
                // Icon
                Image(systemName: option.icon)
                    .font(.system(size: 24))
                    .foregroundStyle(situationColor)
                    .frame(width: 48, height: 48)
                    .background(situationColor.opacity(0.1))
                    .clipShape(Circle())
                
                Spacer()
                
                // Label
                Text(option.label)
                    .font(.system(size: 18, weight: .semibold, design: .rounded))
                    .foregroundStyle(DesignSystem.textPrimary)
                    .multilineTextAlignment(.leading)
                    .fixedSize(horizontal: false, vertical: true)
                
                // Leaf indicator
                if isLeaf {
                    HStack {
                        Spacer()
                        Image(systemName: "arrow.right")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundStyle(situationColor.opacity(0.6))
                    }
                }
            }
            .padding(16)
        }
        .frame(minHeight: 160, alignment: .topLeading)
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
        .accessibilityElement(children: .combine)
        .accessibilityAddTraits(.isButton)
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
                            NavigationLink(destination: VerticalGuideView(technique: technique)) {
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
                                .padding(14)
                                .background(.ultraThinMaterial)
                                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                                        .stroke(Color.white.opacity(0.1), lineWidth: 0.5)
                                )
                                .accessibilityElement(children: .combine)
                                .accessibilityAddTraits(.isButton)
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
