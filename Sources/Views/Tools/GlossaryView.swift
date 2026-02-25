import SwiftUI

struct GlossaryView: View {
    @ObservedObject var contentDB = ContentDatabase.shared
    @State private var searchText = ""
    @Environment(\.dismiss) var dismiss
    
    var filteredTerms: [GlossaryTerm] {
        if searchText.isEmpty {
            return contentDB.glossaryTerms
        } else {
            return contentDB.glossaryTerms.filter { 
                $0.term.localizedCaseInsensitiveContains(searchText) ||
                $0.definition.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            DesignSystem.backgroundPrimary.edgesIgnoringSafeArea(.all)
            
            // Main Content
            ScrollView {
                VStack(spacing: 0) {
                    // Search Bar
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundStyle(.secondary)
                        .accessibilityHidden(true)
                        TextField("Search terms...", text: $searchText)
                            .foregroundStyle(.primary)
                        if !searchText.isEmpty {
                            Button(action: { searchText = "" }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundStyle(.secondary)
                                .accessibilityHidden(true)
                            }
                        }
                    }
                    .padding(12)
                    .background(Color(uiColor: .tertiarySystemGroupedBackground))
                    .cornerRadius(12)
                    .padding(.horizontal, 20)
                    .padding(.top, 60) // Header height (44) + padding (16)
                    .padding(.bottom, 16)
                    
                    // List
                    LazyVStack(alignment: .leading, spacing: 16) {
                        ForEach(filteredTerms) { item in
                            VStack(alignment: .leading, spacing: 6) {
                                Text(item.term)
                                    .font(.system(size: 18, weight: .bold, design: .serif))
                                    .foregroundStyle(DesignSystem.textPrimary)
                                
                                Text(item.definition)
                                    .font(.body)
                                    .foregroundStyle(DesignSystem.textSecondary)
                                    .fixedSize(horizontal: false, vertical: true)
                                    .lineSpacing(4)
                            }
                            .padding(16)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color(uiColor: .secondarySystemGroupedBackground))
                            .cornerRadius(16)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 40)
                }
            }
            
            // Pinned Header
            HStack {
                Button(action: { dismiss() }) {
                    HStack(spacing: 4) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 18, weight: .semibold))
                        .accessibilityHidden(true)
                        Text("Back")
                            .font(.system(size: 17, weight: .medium))
                    }
                    .foregroundStyle(DesignSystem.textPrimary)
                }
                
                Spacer()
            }
            .overlay(
                Text("Glossary")
                    .font(.system(size: 20, weight: .semibold, design: .serif))
                    .foregroundStyle(DesignSystem.textPrimary)
            )
            .padding(.horizontal, 20)
            .padding(.bottom, 12)
            .frame(height: 44) // Standard Nav Bar Height
            .background(.ultraThinMaterial)
            .background(
                // Extend background to top safe area
                Rectangle()
                    .fill(.ultraThinMaterial)
                    .edgesIgnoringSafeArea(.top)
            )
        }
        .navigationBarHidden(true)
    }
}
