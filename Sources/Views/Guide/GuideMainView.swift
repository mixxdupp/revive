import SwiftUI

struct GuideMainView: View {
    @State private var searchText = ""
    
    var filteredTechniques: [Technique] {
        if searchText.isEmpty { return [] }
        return ContentDatabase.shared.search(query: searchText)
    }
    
    // Standard Grid (Clean, Open)
    let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 32) {
                

                // MARK: - Banner
                if searchText.isEmpty {
                    EmergencyBanner()
                        .padding(.horizontal, 24)
                        .padding(.top, 16)
                }
                
                // MARK: - Header (Clean & Centered)
                if searchText.isEmpty {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Library")
                            .font(.system(size: 40, weight: .bold, design: .serif)) // New York
                            .foregroundStyle(DesignSystem.textPrimary)
                        
                        Text("Survival Guide")
                            .font(.body)
                            .fontWeight(.medium)
                            .foregroundStyle(DesignSystem.textSecondary)
                    }
                    .padding(.horizontal, 24)
                }
                
                // MARK: - CATEGORIES GRID (Shortcuts Style)
                if searchText.isEmpty {
                    LazyVGrid(columns: columns, spacing: 16) {
                        ForEach(SurvivalDomain.allCases) { domain in
                            NavigationLink(destination: DomainDetailView(domain: domain)) {
                                VStack(alignment: .leading, spacing: 12) {
                                    // Icon (Clean)
                                    Image(systemName: domain.icon)
                                        .font(.system(size: 28))
                                        .foregroundStyle(.white)
                                    
                                    Spacer()
                                    
                                    // Text (Clean)
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text(domain.displayName)
                                            .font(.title3)
                                            .fontWeight(.bold)
                                            .foregroundStyle(.white)
                                            .multilineTextAlignment(.leading)
                                            .lineLimit(1)
                                            .minimumScaleFactor(0.8)
                                        
                                        Text("\(ContentDatabase.shared.getTechniques(for: domain).count) Items")
                                            .font(.caption)
                                            .fontWeight(.medium)
                                            .foregroundStyle(.white.opacity(0.8))
                                    }
                                }
                                .padding(20)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .frame(height: 140) // Standard box height
                                .background(domain.color) // Vibrant Solid Color
                                .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
                                // Subtle shadow
                                .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
                            }
                            .buttonStyle(ScalableButtonStyle())
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 40)
                    
                } else {
                    // MARK: - SEARCH RESULTS
                    LazyVStack(spacing: 16) {
                        if filteredTechniques.isEmpty {
                            Text("No results found")
                                .foregroundStyle(.secondary)
                                .padding(.top, 40)
                        } else {
                            ForEach(filteredTechniques) { technique in
                                NavigationLink(destination: StepCardPager(technique: technique)) {
                                    TechniqueRow(technique: technique)
                                }
                            }
                        }
                    }
                    .padding(24)
                }
            }
        }
        .background(Color(uiColor: .systemGroupedBackground))
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: "Search techniques")
    }
}
