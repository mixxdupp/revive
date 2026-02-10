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
            VStack(spacing: 24) {
                // MARK: - HERO HEADER (God Tier)
                ZStack(alignment: .bottomLeading) {
                    // Background
                    GeometryReader { geo in
                        LinearGradient(
                            colors: [
                                domain.color,
                                domain.color.opacity(0.6),
                                Color(uiColor: .systemGroupedBackground)
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                        .frame(height: geo.size.height + 100) // Stretch up
                        .offset(y: -100)
                    }
                    .frame(height: 280)
                    
                    // Huge Watermark Icon
                    HStack {
                        Spacer()
                        Image(systemName: domain.icon)
                            .font(.system(size: 200, weight: .black))
                            .foregroundStyle(.white.opacity(0.1))
                            .rotationEffect(.degrees(-10))
                            .offset(x: 40, y: 40)
                    }
                    
                    // Content
                    VStack(alignment: .leading, spacing: 8) {
                        Image(systemName: domain.icon)
                            .font(.system(size: 48))
                            .foregroundStyle(.white)
                            .shadow(radius: 10)
                        
                        Text(domain.displayName)
                            .font(.system(size: 40, weight: .black, design: .rounded))
                            .foregroundStyle(.white)
                            .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 2)
                        
                        Text("Master essential skills for \(domain.displayName.lowercased()) scenarios.")
                            .font(.title3)
                            .fontWeight(.medium)
                            .foregroundStyle(.white.opacity(0.9))
                            .shadow(radius: 2)
                    }
                    .padding(24)
                    .padding(.bottom, 20)
                }
                .frame(height: 280)
                // Remove safe area top to let gradient bleed
                
                // MARK: - CONTENT STACK
                LazyVStack(spacing: 24) {
                    
                    // TECHNIQUES SECTION
                    if !techniques.isEmpty {
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Techniques")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundStyle(DesignSystem.textPrimary)
                                .padding(.horizontal, 24)
                            
                            ForEach(techniques) { technique in
                                NavigationLink(destination: StepCardPager(technique: technique)) {
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
                                .font(.title2)
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
                                                .font(.system(size: 17, weight: .semibold, design: .rounded))
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
        .edgesIgnoringSafeArea(.top) // Bleed header
    }
}
