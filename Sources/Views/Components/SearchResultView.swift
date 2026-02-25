import SwiftUI

struct SearchResultView: View {
    let results: [Technique]
    @Binding var isSearching: Bool
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                if results.isEmpty {
                    VStack(spacing: 20) {
                        Image(systemName: "magnifyingglass")
                            .font(.system(size: 48))
                            .foregroundColor(DesignSystem.textSecondary.opacity(0.5))
                        .accessibilityHidden(true)
                        
                        Text("No techniques found")
                            .font(Typography.headline)
                            .foregroundColor(DesignSystem.textSecondary)
                    }
                    .padding(.top, 60)
                } else {
                    Text("Found \(results.count) results")
                        .font(Typography.caption)
                        .foregroundColor(DesignSystem.textSecondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, Layout.screenPadding)
                    
                    ForEach(results) { technique in
                        NavigationLink(destination: VerticalGuideView(technique: technique)) {
                            // Reusing TechniqueRow from DomainDetailView.swift
                            TechniqueRow(technique: technique)
                        }
                        .buttonStyle(ScalableButtonStyle())
                    }
                }
            }
            .padding(.top, 20)
            .padding(.bottom, 40)
        }
    }
}
