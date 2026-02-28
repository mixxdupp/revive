import SwiftUI

struct DomainDetailView: View {
    let domain: SurvivalDomain
    @Environment(\.dismiss) var dismiss
    @State private var selectedTab: DomainTab = .techniques
    @State private var searchText = ""
    
    enum DomainTab: String, CaseIterable {
        case techniques = "Techniques"
        case articles = "Articles"
    }
    
    var techniques: [Technique] {
        let all = ContentDatabase.shared.getTechniques(for: domain)
        if searchText.isEmpty { return all }
        return all.filter { $0.name.localizedCaseInsensitiveContains(searchText) || $0.subtitle.localizedCaseInsensitiveContains(searchText) }
    }
    
    var articles: [Article] {
        let all = ContentDatabase.shared.getArticles(for: domain)
        if searchText.isEmpty { return all }
        return all.filter { $0.title.localizedCaseInsensitiveContains(searchText) }
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                
                // MARK: - HERO HEADER (Clean List Style)
                VStack(alignment: .leading, spacing: 16) {
                    
                    // Icon Container (Flat, no glow)
                    ZStack {
                        Circle()
                            .fill(domain.color)
                        Image(systemName: domain.icon)
                            .font(.system(size: 32, weight: .bold))
                            .foregroundStyle(.white)
                        .accessibilityHidden(true)
                    }
                    .frame(width: 64, height: 64)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(domain.displayName)
                            .font(.system(size: 40, weight: .bold))
                            .foregroundStyle(DesignSystem.textPrimary)
                        
                        Text("Master essential skills for \(domain.displayName.lowercased()) scenarios.")
                            .font(.body)
                            .fontWeight(.medium)
                            .foregroundStyle(DesignSystem.textSecondary)
                            .lineLimit(2)
                    }
                    
                    // Search Bar
                    SearchBar(text: $searchText, placeholder: "Search \(selectedTab.rawValue.lowercased())...")
                        .padding(.top, 8)
                    
                    // MARK: - Segmented Control
                    Picker("Section", selection: $selectedTab) {
                        ForEach(DomainTab.allCases, id: \.self) { tab in
                            Text(tab.rawValue).tag(tab)
                        }
                    }
                    .pickerStyle(.segmented)
                    .padding(.top, 8)
                }
                .padding(.top, 24)
                .padding(.horizontal, 24)
                
                // MARK: - CONTENT STACK
                LazyVStack(spacing: 24) {
                    
                    switch selectedTab {
                    case .techniques:
                        if techniques.isEmpty {
                            ContentUnavailableView("No Techniques", systemImage: "magnifyingglass", description: Text("No techniques match your search."))
                        } else {
                            ForEach(techniques) { technique in
                                NavigationLink(destination: VerticalGuideView(technique: technique)) {
                                    TechniqueRow(technique: technique)
                                }
                                .buttonStyle(ScalableButtonStyle())
                            }
                            .padding(.horizontal, 24)
                        }
                        
                    case .articles:
                        if articles.isEmpty {
                            ContentUnavailableView("No Articles", systemImage: "magnifyingglass", description: Text("No articles match your search."))
                        } else {
                            ForEach(articles) { article in
                                NavigationLink(destination: ArticleView(article: article)) {
                                    HStack(spacing: 16) {
                                        ZStack {
                                            RoundedRectangle(cornerRadius: 12, style: .continuous)
                                                .fill(domain.color.opacity(0.1))
                                            Image(systemName: "doc.text.fill")
                                                .font(.system(size: 20))
                                                .foregroundStyle(domain.color)
                                            .accessibilityHidden(true)
                                        }
                                        .frame(width: 48, height: 48)
                                        
                                        VStack(alignment: .leading, spacing: 4) {
                                            Text(article.title)
                                                .font(.system(size: 17, weight: .semibold))
                                                .foregroundStyle(DesignSystem.textPrimary)
                                                .lineLimit(1)
                                            
                                            Text("Read Guide")
                                                .font(.caption)
                                                .fontWeight(.medium)
                                                .foregroundStyle(DesignSystem.textSecondary)
                                        }
                                        
                                        Spacer()
                                        
                                        Image(systemName: "chevron.right")
                                            .font(.system(size: 14, weight: .bold))
                                            .foregroundStyle(DesignSystem.textSecondary.opacity(0.5))
                                        .accessibilityHidden(true)
                                    }
                                    .padding(16)
                                    .background(Color(uiColor: .secondarySystemGroupedBackground))
                                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                                    .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 2)
                                }
                                .buttonStyle(ScalableButtonStyle())
                            }
                            .padding(.horizontal, 24)
                        }
                    }
                }
                .padding(.bottom, 40)
            }
        }
        .background(Color(uiColor: .systemGroupedBackground))
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
    }
}
