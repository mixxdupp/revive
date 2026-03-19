import SwiftUI

struct EmergencyMenuView: View {
    @State private var searchText = ""
    
    var filteredSituations: [EmergencySituation] {
        if searchText.isEmpty { return EmergencySituation.allCases }
        return EmergencySituation.allCases.filter { $0.displayName.localizedCaseInsensitiveContains(searchText) }
    }
    
    // Standard Grid (Clean, Open)
    let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    var body: some View {
        ZStack {
            DesignSystem.backgroundPrimary
                .ignoresSafeArea()
            
            // Subtle Mesh Gradient Simulation
            GeometryReader { proxy in
                ZStack {
                    Circle()
                        .fill(Color.blue.opacity(0.1))
                        .frame(width: 300, height: 300)
                        .blur(radius: 60)
                        .offset(x: -100, y: -100)
                    
                    Circle()
                        .fill(Color.orange.opacity(0.1))
                        .frame(width: 300, height: 300)
                        .blur(radius: 60)
                        .offset(x: 200, y: 100)
                }
                .frame(width: proxy.size.width, height: proxy.size.height)
            }
            .ignoresSafeArea()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    
                    Text("Fast response protocols", comment: "Section Subtitle")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundStyle(DesignSystem.textSecondary)
                        .padding(.horizontal, 16)
                    
                    HStack(spacing: 8) {
                        Image(systemName: "magnifyingglass")
                            .foregroundStyle(DesignSystem.textSecondary)
                        .accessibilityHidden(true)
                        TextField("Search situations", text: $searchText)
                            .font(.body)
                            .foregroundStyle(DesignSystem.textPrimary)
                            .submitLabel(.search)
                        
                        if !searchText.isEmpty {
                            Button {
                                searchText = ""
                            } label: {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundStyle(DesignSystem.textSecondary)
                            }
                            .accessibilityLabel("Clear search")
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(Color(uiColor: .secondarySystemGroupedBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                    .padding(.horizontal, 24)
                    if searchText.isEmpty {
                        LazyVGrid(columns: columns, spacing: 16) {
                            ForEach(EmergencySituation.allCases) { situation in
                                NavigationLink(destination: destinationView(for: situation)) {
                                    EmergencyCell(situation: situation)
                                }
                                .buttonStyle(ScalableButtonStyle())
                            }
                        }
                        .padding(.horizontal, 24)
                    } else {
                        let searchResults = ContentDatabase.shared.searchTriageOptions(query: searchText)
                        if searchResults.isEmpty {
                            VStack(spacing: 12) {
                                Image(systemName: "magnifyingglass")
                                    .font(.system(size: 36))
                                    .foregroundStyle(DesignSystem.textSecondary)
                                    .accessibilityHidden(true)
                                Text("No triage tools found")
                                    .font(.headline)
                                    .foregroundStyle(DesignSystem.textSecondary)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.top, 60)
                        } else {
                            LazyVGrid(columns: columns, spacing: 16) {
                                ForEach(searchResults, id: \.option.id) { result in
                                    TriageOptionRoutingView(option: result.option, situationColor: result.color)
                                }
                            }
                            .padding(.horizontal, 24)
                        }
                    }
                    if !RecentlyViewedService.shared.recentTechniques().isEmpty {
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Quick Access", comment: "Recently Viewed Header")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundStyle(DesignSystem.textPrimary)
                                .padding(.horizontal, 24)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 16) {
                                    ForEach(RecentlyViewedService.shared.recentTechniques(limit: 5)) { technique in
                                        NavigationLink(destination: VerticalGuideView(technique: technique)) {
                                            HStack(spacing: 12) {
                                                Image(systemName: technique.icon)
                                                    .font(.system(size: 20))
                                                    .foregroundStyle(technique.domain.color)
                                                    .frame(width: 44, height: 44)
                                                    .background(.ultraThinMaterial)
                                                    .clipShape(Circle())
                                                .accessibilityHidden(true)
                                                
                                                VStack(alignment: .leading, spacing: 2) {
                                                    Text(LocalizedStringKey(technique.name))
                                                        .font(.subheadline.weight(.semibold))
                                                        .foregroundStyle(DesignSystem.textPrimary)
                                                    Text(LocalizedStringKey(technique.subtitle))
                                                        .font(.caption)
                                                        .foregroundStyle(DesignSystem.textSecondary)
                                                        .lineLimit(1)
                                                }
                                                .frame(maxWidth: 160, alignment: .leading)
                                            }
                                            .padding(12)
                                            .background(.ultraThinMaterial)
                                            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 16, style: .continuous)
                                                    .strokeBorder(Color.white.opacity(0.2), lineWidth: 0.5)
                                            )
                                        }
                                        .buttonStyle(ScalableButtonStyle())
                                    }
                                }
                                .padding(.horizontal, 24)
                            }
                        }
                    }
                    
                    Spacer(minLength: 40)
                }
            }
        }
        .navigationTitle("Emergency")
        .navigationBarTitleDisplayMode(.large)
    }
    

    func destinationView(for situation: EmergencySituation) -> some View {
        InventoryQuestionView(situation: situation)
    }
}

struct TriageOptionRoutingView: View {
    let option: TriageOption
    let situationColor: Color
    
    @ViewBuilder
    var body: some View {
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
                TriageOptionCard(option: option, situationColor: situationColor).opacity(0.4)
            }
            
        case .techniqueList(let techniqueIDs):
            let techniques = techniqueIDs.compactMap { id in ContentDatabase.shared.techniques.first(where: { $0.id == id }) }
            if !techniques.isEmpty {
                NavigationLink(destination: TriageTechniqueListView(techniques: techniques, situationColor: situationColor)) {
                    TriageOptionCard(option: option, situationColor: situationColor, isLeaf: true)
                }
                .buttonStyle(ScalableButtonStyle())
            } else {
                TriageOptionCard(option: option, situationColor: situationColor).opacity(0.4)
            }
            
        case .rankedTechniqueList(let rankedTechniques, _):
            let techniques = rankedTechniques.compactMap { ranked in ContentDatabase.shared.techniques.first(where: { $0.id == ranked.id }) }
            if !techniques.isEmpty {
                NavigationLink(destination: TriageTechniqueListView(techniques: techniques, situationColor: situationColor)) {
                    TriageOptionCard(option: option, situationColor: situationColor, isLeaf: true)
                }
                .buttonStyle(ScalableButtonStyle())
            } else {
                TriageOptionCard(option: option, situationColor: situationColor).opacity(0.4)
            }
            
        case .article(let articleID):
            if let article = ContentDatabase.shared.articles.first(where: { $0.id == articleID }) {
                NavigationLink(destination: ArticleView(article: article)) {
                    TriageOptionCard(option: option, situationColor: situationColor, isLeaf: true)
                }
                .buttonStyle(ScalableButtonStyle())
            } else {
                TriageOptionCard(option: option, situationColor: situationColor).opacity(0.4)
            }
            
        case .articleList(let articleIDs):
            let articles = articleIDs.compactMap { id in ContentDatabase.shared.articles.first(where: { $0.id == id }) }
            if !articles.isEmpty {
                NavigationLink(destination: TriageArticleListView(articles: articles, situationColor: situationColor)) {
                    TriageOptionCard(option: option, situationColor: situationColor, isLeaf: true)
                }
                .buttonStyle(ScalableButtonStyle())
            } else {
                TriageOptionCard(option: option, situationColor: situationColor).opacity(0.4)
            }
        }
    }
}
