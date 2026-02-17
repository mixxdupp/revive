import SwiftUI

struct ArticleView: View {
    let article: Article
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
                            .foregroundStyle(article.domain.color)
                        }
                        .padding(.bottom, 10)
                        
                        // Metadata
                        Text("ARTICLE • \(article.domain.displayName.uppercased())")
                            .font(.caption.weight(.bold))
                            .foregroundStyle(article.domain.color)
                            .tracking(1)
                        
                        // Title
                        Text(article.title)
                            .font(.system(size: 34, weight: .black))
                            .foregroundStyle(DesignSystem.textPrimary)
                            .fixedSize(horizontal: false, vertical: true)
                        
                        // Source Link
                        if let sourceUrl = article.sourceUrl, let url = URL(string: sourceUrl) {
                            Link(destination: url) {
                                HStack(spacing: 4) {
                                    Text("Source:")
                                        .font(.footnote)
                                        .foregroundStyle(DesignSystem.textSecondary)
                                    
                                    Text(article.sourceName ?? "View Original")
                                        .font(.footnote.weight(.semibold))
                                        .foregroundStyle(article.domain.color)
                                        .underline()
                                    
                                    Image(systemName: "arrow.up.right")
                                        .font(.caption2)
                                        .foregroundStyle(article.domain.color)
                                }
                            }
                            .padding(.top, 4)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    
                    Divider()
                        .background(article.domain.color.opacity(0.3))
                        .padding(.horizontal, 20)
                    
                    // MARK: - Body Content
                    Text(article.body)
                        .font(.body)
                        .foregroundStyle(DesignSystem.textPrimary)
                        .lineSpacing(6)
                        .padding(.horizontal, 20)
                    
                    // MARK: - Related Techniques Link (Optional Future Enhancement)
                    // If we had logic to link back to techniques, it would go here.
                    
                    Spacer(minLength: 40)
                }
                .padding(.bottom, 40)
            }
        }
        .navigationBarHidden(true)
    }
}
