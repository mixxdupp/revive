import SwiftUI

struct SavedTechniquesView: View {
    @ObservedObject var favorites = FavoritesService.shared
    @State private var selectedTab: SavedTab = .techniques
    
    enum SavedTab: String, CaseIterable {
        case techniques = "Techniques"
        case articles = "Articles"
    }
    
    var savedTechniques: [Technique] {
        favorites.getSavedTechniques()
    }
    
    var savedArticles: [Article] {
        favorites.getSavedArticles()
    }
    
    var body: some View {
        VStack(spacing: 0) {
            if savedTechniques.isEmpty && savedArticles.isEmpty {
                ContentUnavailableView("No Saved Guides", systemImage: "bookmark", description: Text("Tap the bookmark icon on any guide or article to save it here."))
                    .padding(.top, 40)
            } else {
                VStack(spacing: 24) {
                    Picker("Section", selection: $selectedTab) {
                        ForEach(SavedTab.allCases, id: \.self) { tab in
                            Text(tab.rawValue).tag(tab)
                        }
                    }
                    .pickerStyle(.segmented)
                    .padding(.horizontal, 24)
                    .padding(.top, 8)
                    
                    LazyVStack(spacing: 24) {
                        switch selectedTab {
                        case .techniques:
                            if savedTechniques.isEmpty {
                                ContentUnavailableView("No Saved Techniques", systemImage: "bookmark", description: Text("Techniques you save will appear here."))
                                    .padding(.top, 40)
                            } else {
                                ForEach(savedTechniques) { technique in
                                    NavigationLink(destination: VerticalGuideView(technique: technique)) {
                                        TechniqueRow(technique: technique)
                                    }
                                    .padding(.horizontal, 24)
                                    .buttonStyle(ScalableButtonStyle())
                                }
                            }
                            
                        case .articles:
                            if savedArticles.isEmpty {
                                ContentUnavailableView("No Saved Articles", systemImage: "bookmark", description: Text("Articles you save will appear here."))
                                    .padding(.top, 40)
                            } else {
                                ForEach(savedArticles) { article in
                                    NavigationLink(destination: ArticleView(article: article)) {
                                        HStack(spacing: 16) {
                                            ZStack {
                                                RoundedRectangle(cornerRadius: 12, style: .continuous)
                                                    .fill(article.domain.color)
                                                Image(systemName: "doc.text.fill")
                                                    .font(.system(size: 20, weight: .semibold))
                                                    .foregroundStyle(.white)
                                            }
                                            .frame(width: 48, height: 48)
                                            
                                            VStack(alignment: .leading, spacing: 4) {
                                                Text(article.title)
                                                    .font(.headline)
                                                    .fontWeight(.semibold)
                                                    .foregroundStyle(DesignSystem.textPrimary)
                                                    .lineLimit(1)
                                                
                                                Text(article.domain.displayName)
                                                    .font(.subheadline)
                                                    .foregroundStyle(DesignSystem.textSecondary)
                                                    .lineLimit(1)
                                            }
                                            
                                            Spacer()
                                            
                                            Image(systemName: "chevron.right")
                                                .font(.caption)
                                                .fontWeight(.bold)
                                                .foregroundStyle(DesignSystem.textSecondary.opacity(0.4))
                                        }
                                        .padding(16)
                                        .background(Color(uiColor: .secondarySystemGroupedBackground))
                                        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                                    }
                                    .padding(.horizontal, 24)
                                    .buttonStyle(ScalableButtonStyle())
                                }
                            }
                        }
                    }
                    .padding(.bottom, 40)
                }
            }
        }
    }
}
