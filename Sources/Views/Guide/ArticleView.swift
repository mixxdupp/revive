import SwiftUI

struct ArticleView: View {
    let article: Article
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            DesignSystem.backgroundPrimary.edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 0) {
                // Header
                HStack {
                    Button(action: { dismiss() }) {
                        HStack(spacing: 4) {
                            Image(systemName: "chevron.left")
                            Text(article.domain.displayName)
                        }
                        .font(Typography.button)
                        .foregroundColor(DesignSystem.textSecondary)
                    }
                    Spacer()
                }
                .padding(.horizontal, Layout.screenPadding)
                .padding(.top, 20)
                .padding(.bottom, 20)
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        Text(article.title)
                            .font(Typography.title)
                            .foregroundColor(DesignSystem.textPrimary)
                        
                        Divider()
                            .background(article.domain.color.opacity(0.5))
                        
                        Text(article.body)
                            .font(Typography.body)
                            .foregroundColor(DesignSystem.textPrimary)
                            .lineSpacing(6)
                        
                        Spacer(minLength: 40)
                    }
                    .padding(.horizontal, Layout.screenPadding)
                    .padding(.bottom, 40)
                }
            }
        }
        .navigationBarHidden(true)
    }
}
