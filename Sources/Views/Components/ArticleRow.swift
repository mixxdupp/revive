import SwiftUI

struct ArticleRow: View {
    let article: Article
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(article.title)
                    .font(Typography.headline)
                    .foregroundColor(DesignSystem.textPrimary)
                
                Text("Read Article")
                    .font(Typography.caption)
                    .foregroundColor(DesignSystem.textSecondary)
            }
            Spacer()
            
            Image(systemName: "doc.text.fill")
                .foregroundColor(article.domain.color)
            .accessibilityHidden(true)
        }
        .padding()
    }
}
