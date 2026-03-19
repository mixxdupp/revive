import SwiftUI
import UIKit

struct ArticleView: View {
    let article: Article
    @Environment(\.dismiss) var dismiss
    @State private var scrollOffset: CGFloat = 0
    @ObservedObject var favorites = FavoritesService.shared
    
    // Parsed content
    private var sections: [ArticleSection] {
        ArticleParser.parse(article.body)
    }
    
    // Estimated Read Time (Avg 200 wpm)
    private var readTime: String {
        let wordCount = article.body.split(separator: " ").count
        let minutes = max(1, wordCount / 200)
        return "\(minutes) min read"
    }
    
    var body: some View {
        ZStack {
            DesignSystem.backgroundPrimary.edgesIgnoringSafeArea(.all)
            
            ScrollView {
                VStack(spacing: 0) {
                    
                    GeometryReader { geo in
                        let scrollOffset = geo.frame(in: .global).minY
                        let height = 400 + (scrollOffset > 0 ? scrollOffset : 0) // Stretch on pull
                        
                        ZStack(alignment: .bottomLeading) {
                            // Background Color (Subtle gradient or solid)
                            LinearGradient(
                                gradient: Gradient(colors: [article.domain.color.opacity(0.2), article.domain.color.opacity(0.05)]),
                                startPoint: .top,
                                endPoint: .bottom
                            )
                            
                            // Header Content
                            VStack(alignment: .leading, spacing: 20) {
                                // Metadata Pill
                                HStack(spacing: 8) {
                                    Text(article.domain.displayName.uppercased())
                                        .font(.caption.weight(.bold))
                                        .tracking(1)
                                    
                                    Circle()
                                        .frame(width: 4, height: 4)
                                        .opacity(0.5)
                                    
                                    Text(readTime.uppercased())
                                        .font(.caption.weight(.bold))
                                        .tracking(1)
                                        .opacity(0.7)
                                }
                                .foregroundStyle(article.domain.color)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(.ultraThinMaterial)
                                .clipShape(Capsule())
                                
                                // Title
                                Text(article.title)
                                    .font(.system(size: 42, weight: .bold)) // SF Pro Bold
                                    .foregroundStyle(DesignSystem.textPrimary)
                                    .fixedSize(horizontal: false, vertical: true)
                                    .padding(.trailing, 20)
                            }
                            .padding(.horizontal, 24)
                            .padding(.bottom, 48)
                        }
                        .frame(height: height)
                        .offset(y: scrollOffset > 0 ? -scrollOffset : 0)
                    }
                    .frame(height: 400)
                    .background(GeometryReader { proxy in
                        Color.clear.preference(key: ScrollOffsetPreferenceKey.self, value: proxy.frame(in: .global).minY)
                    })

                    
                    VStack(alignment: .leading, spacing: 24) {
                        ForEach(sections) { section in
                            switch section.type {
                            case .header:
                                Text(section.content)
                                    .font(.system(.title3, design: .rounded).weight(.bold)) // Rounded Sans for headers
                                    .foregroundStyle(article.domain.color)
                                    .padding(.top, 24)
                                
                            case .paragraph:
                                // Markdown parsing for Bold/Italics
                                Text((try? AttributedString(markdown: section.content)) ?? AttributedString(section.content))
                                    .font(.system(.body, design: .serif))
                                    .foregroundStyle(DesignSystem.textPrimary.opacity(0.9))
                                    .lineSpacing(8)
                                
                            case .bullet:
                                HStack(alignment: .top, spacing: 14) {
                                    Circle()
                                        .fill(article.domain.color.opacity(0.6))
                                        .frame(width: 5, height: 5)
                                        .padding(.top, 10)
                                    
                                    Text((try? AttributedString(markdown: section.content)) ?? AttributedString(section.content))
                                        .font(.system(.body, design: .serif))
                                        .foregroundStyle(DesignSystem.textPrimary.opacity(0.9))
                                        .lineSpacing(8)
                                }
                                
                            case .number(let num):
                                HStack(alignment: .top, spacing: 14) {
                                    Text("\(num).")
                                        .font(.system(.body, design: .monospaced).weight(.bold))
                                        .foregroundStyle(article.domain.color)
                                        .frame(width: 24, alignment: .trailing)
                                    
                                    Text((try? AttributedString(markdown: section.content)) ?? AttributedString(section.content))
                                        .font(.system(.body, design: .serif))
                                        .foregroundStyle(DesignSystem.textPrimary.opacity(0.9))
                                        .lineSpacing(8)
                                }
                                
                            case .blockquote:
                                HStack(spacing: 16) {
                                    Rectangle()
                                        .fill(article.domain.color.opacity(0.4))
                                        .frame(width: 3)
                                    
                                    Text((try? AttributedString(markdown: section.content)) ?? AttributedString(section.content))
                                        .font(.system(.body, design: .serif).italic())
                                        .foregroundStyle(DesignSystem.textSecondary)
                                        .lineSpacing(4)
                                }
                                .padding(.vertical, 8)
                            }
                        }
                        
                        Divider()
                            .padding(.top, 16)
                            .padding(.bottom, 8)
                        
                        if let sourceName = article.sourceName, !sourceName.isEmpty {
                            VStack(alignment: .leading, spacing: 16) {
                                Text("Source Material")
                                    .font(.caption.weight(.bold))
                                    .foregroundStyle(DesignSystem.textSecondary)
                                    .textCase(.uppercase)
                                    .tracking(1)
                                
                                HStack(spacing: 6) {
                                    Text(sourceName)
                                        .font(.footnote.weight(.semibold))
                                        .foregroundStyle(article.domain.color)
                                    
                                    Spacer()
                                }
                            }
                        }
                    }
                    .padding(24)
                    .padding(.bottom, 60)
                    .background(DesignSystem.backgroundPrimary) // Opaque background covers header
                    .clipShape(RoundedCorner(radius: 32, corners: [.topLeft, .topRight]))
                    .offset(y: -40) // Overlap header
                }
            }
            .edgesIgnoringSafeArea(.top)
            .onPreferenceChange(ScrollOffsetPreferenceKey.self) { value in
                self.scrollOffset = value
            }

            
            VStack {
                HStack {
                    Button(action: { dismiss() }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundStyle(DesignSystem.textPrimary)
                            .frame(width: 40, height: 40)
                            .background(.ultraThinMaterial)
                            .clipShape(Circle())
                            .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
                    }
                    .accessibilityLabel("Back")
                    .padding(.leading, 24)
                    
                    Spacer()
                    
                    HStack(spacing: 12) {
                        // Bookmark Toggle
                        Button(action: {
                            favorites.toggleArticle(article.id)
                            HapticsService.shared.playImpact(style: .light)
                        }) {
                            Image(systemName: favorites.isArticleSaved(article.id) ? "bookmark.fill" : "bookmark")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundStyle(favorites.isArticleSaved(article.id) ? article.domain.color : DesignSystem.textSecondary)
                                .frame(width: 40, height: 40)
                                .background(.ultraThinMaterial)
                                .clipShape(Circle())
                        }
                        .accessibilityLabel("Bookmark Article")
                        
                        // Glossary Link (Standard Right Placement)
                        NavigationLink(destination: GlossaryView()) {
                            Image(systemName: "text.book.closed.fill")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundStyle(DesignSystem.textSecondary)
                                .frame(width: 40, height: 40)
                                .background(.ultraThinMaterial)
                                .clipShape(Circle())
                        }
                        .accessibilityLabel("Glossary")
                    }
                    .padding(.trailing, 24)
                }
                .padding(.top, 16)
                .padding(.bottom, 16)
                .background(
                    Rectangle()
                        .fill(.ultraThinMaterial)
                        .edgesIgnoringSafeArea(.top)
                        .opacity(min(1, max(0, (-scrollOffset - 50) / 100)))
                )
                
                Spacer()
            }
        }
        .navigationBarHidden(true)
    }
}

struct ArticleSection: Identifiable {
    let id = UUID()
    let type: SectionType
    let content: String
    
    enum SectionType {
        case header
        case paragraph
        case bullet
        case number(Int)
        case blockquote
    }
}

struct ArticleParser {
    static func parse(_ body: String) -> [ArticleSection] {
        var sections: [ArticleSection] = []
        let lines = body.components(separatedBy: .newlines)
        
        var currentNumber = 1
        
        for line in lines {
            let trimmed = line.trimmingCharacters(in: .whitespaces)
            if trimmed.isEmpty { 
                currentNumber = 1 // Reset numbering on empty lines
                continue 
            }
            
            if trimmed.hasSuffix(":") {
                // Header (e.g. "Preparation:")
                sections.append(ArticleSection(type: .header, content: trimmed.replacingOccurrences(of: ":", with: "")))
                currentNumber = 1
            } else if trimmed.hasPrefix("- ") || trimmed.hasPrefix("• ") {
                // Bullet Point
                let content = trimmed.dropFirst(2).trimmingCharacters(in: .whitespaces)
                sections.append(ArticleSection(type: .bullet, content: content))
                currentNumber = 1
            } else if let match = trimmed.range(of: "^\\d+\\. ", options: .regularExpression) {
                // Numbered List (e.g. "1. Step one")
                let content = String(trimmed[match.upperBound...]).trimmingCharacters(in: .whitespaces)
                sections.append(ArticleSection(type: .number(currentNumber), content: content))
                currentNumber += 1
            } else if trimmed.hasPrefix("> ") {
                // Blockquote (Standard Markdown)
                let content = trimmed.dropFirst(2).trimmingCharacters(in: .whitespaces)
                sections.append(ArticleSection(type: .blockquote, content: content))
                currentNumber = 1
            } else if trimmed.hasPrefix("\"") {
                // Blockquote (Stylistic Quote)
                sections.append(ArticleSection(type: .blockquote, content: trimmed))
                currentNumber = 1
            } else {
                // Regular Paragraph
                sections.append(ArticleSection(type: .paragraph, content: trimmed))
                currentNumber = 1
            }
        }
        
        return sections
    }
}

// Helper for rounded corners on specific sides
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

// Preference Key for Scroll Tracking
struct ScrollOffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}
