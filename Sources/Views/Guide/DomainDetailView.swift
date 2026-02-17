import SwiftUI

struct DomainDetailView: View {
    let domain: SurvivalDomain
    @Environment(\.dismiss) var dismiss
    
    var techniques: [Technique] {
        ContentDatabase.shared.getTechniques(for: domain)
    }
    
    var articles: [Article] {
        ContentDatabase.shared.getArticles(for: domain)
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                
                // MARK: - HERO HEADER (Clean List Style)
                // New York Serif Large Title
                VStack(alignment: .leading, spacing: 16) {
                    
                    // Icon Container (Solid Color)
                    ZStack {
                        Circle()
                            .fill(domain.color)
                        Image(systemName: domain.icon)
                            .font(.system(size: 32, weight: .bold))
                            .foregroundStyle(.white)
                    }
                    .frame(width: 64, height: 64)
                    .shadow(color: domain.color.opacity(0.3), radius: 8, x: 0, y: 4)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(domain.displayName)
                            .font(.system(size: 40, weight: .bold, design: .serif)) // New York
                            .foregroundStyle(DesignSystem.textPrimary)
                        
                        Text("Master essential skills for \(domain.displayName.lowercased()) scenarios.")
                            .font(.body)
                            .fontWeight(.medium)
                            .foregroundStyle(DesignSystem.textSecondary)
                            .lineLimit(2)
                    }
                }
                .padding(.top, 24)
                .padding(.horizontal, 24)
                
                // MARK: - CONTENT STACK
                LazyVStack(spacing: 24) {
                    
                    // TECHNIQUES SECTION
                    if !techniques.isEmpty {
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Techniques")
                                .font(.title3)
                                .fontWeight(.bold)
                                .foregroundStyle(DesignSystem.textPrimary)
                                .padding(.horizontal, 24)
                            
                            ForEach(techniques) { technique in
                                NavigationLink(destination: VerticalGuideView(technique: technique)) {
                                    TechniqueRow(technique: technique)
                                }
                                .buttonStyle(ScalableButtonStyle())
                            }
                            .padding(.horizontal, 24)
                        }
                    }
                    
                    // ARTICLES SECTION
                    if !articles.isEmpty {
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Articles")
                                .font(.title3)
                                .fontWeight(.bold)
                                .foregroundStyle(DesignSystem.textPrimary)
                                .padding(.horizontal, 24)
                            
                            ForEach(articles) { article in
                                NavigationLink(destination: ArticleView(article: article)) {
                                    HStack(spacing: 16) {
                                        ZStack {
                                            RoundedRectangle(cornerRadius: 12, style: .continuous)
                                                .fill(domain.color.opacity(0.1))
                                            Image(systemName: "doc.text.fill")
                                                .font(.system(size: 20))
                                                .foregroundStyle(domain.color)
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
