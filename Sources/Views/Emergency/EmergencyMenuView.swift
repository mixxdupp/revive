import SwiftUI

struct EmergencyMenuView: View {
    @State private var searchText = ""
    
    var filteredSituations: [EmergencySituation] {
        if searchText.isEmpty { return EmergencySituation.allCases }
        return EmergencySituation.allCases.filter { $0.displayName.localizedCaseInsensitiveContains(searchText) }
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
                EmergencyBanner()
                    .padding(.horizontal, 24)
                    .padding(.top, 16) // Top spacing
                
                // MARK: - Header (Clean Apple)
                // Left-Aligned Large Title
                if searchText.isEmpty {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Emergency")
                            .font(.system(size: 40, weight: .bold, design: .serif)) // New York
                            .foregroundStyle(DesignSystem.textPrimary)
                        
                        Text("Select Situation")
                            .font(.body)
                            .fontWeight(.medium)
                            .foregroundStyle(DesignSystem.textSecondary)
                    }
                    .padding(.horizontal, 24)
                }
                
                // MARK: - SITUATIONS GRID (Shortcuts Style)
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(filteredSituations) { situation in
                        NavigationLink(destination: destinationView(for: situation)) {
                            VStack(alignment: .leading, spacing: 12) {
                                // Icon (Clean)
                                Image(systemName: situation.icon)
                                    .font(.system(size: 28))
                                    .foregroundStyle(.white)
                                
                                Spacer()
                                
                                // Text (Clean)
                                Text(situation.displayName)
                                    .font(.title3) // Standard Title Size
                                    .fontWeight(.bold)
                                    .foregroundStyle(.white)
                                    .multilineTextAlignment(.leading)
                                    .lineLimit(2)
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                            .padding(20)
                            .frame(maxWidth: .infinity, alignment: .leading) // Left alignment
                            .frame(height: 140) // Standard box height
                            .background(situation.color) // Vibrant Solid Color
                            .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
                            // Subtle shadow
                            .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
                        }
                        .buttonStyle(ScalableButtonStyle())
                    }
                }
                .padding(.horizontal, 24)
                
                // MARK: - Recently Viewed
                if !RecentlyViewedService.shared.recentTechniques().isEmpty {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Recently Viewed")
                            .font(.system(size: 20, weight: .bold, design: .serif))
                            .foregroundStyle(DesignSystem.textPrimary)
                        
                        ForEach(RecentlyViewedService.shared.recentTechniques(limit: 5)) { technique in
                            NavigationLink(destination: StepCardPager(technique: technique)) {
                                HStack(spacing: 12) {
                                    Image(systemName: technique.icon)
                                        .font(.system(size: 18))
                                        .foregroundStyle(technique.domain.color)
                                        .frame(width: 36, height: 36)
                                        .background(technique.domain.color.opacity(0.15))
                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                    
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text(technique.name)
                                            .font(.subheadline.weight(.semibold))
                                            .foregroundStyle(DesignSystem.textPrimary)
                                        Text(technique.subtitle)
                                            .font(.caption)
                                            .foregroundStyle(DesignSystem.textSecondary)
                                            .lineLimit(1)
                                    }
                                    
                                    Spacer()
                                    
                                    Image(systemName: "chevron.right")
                                        .font(.caption.weight(.semibold))
                                        .foregroundStyle(DesignSystem.textSecondary)
                                }
                                .padding(.vertical, 8)
                                .padding(.horizontal, 14)
                                .background(Color(uiColor: .secondarySystemGroupedBackground))
                                .clipShape(RoundedRectangle(cornerRadius: 14))
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.horizontal, 24)
                }
                
                Spacer(minLength: 40)
            }
        }
        .background(Color(uiColor: .systemGroupedBackground))
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: "Search situations")
    }
    
    @ViewBuilder
    func destinationView(for situation: EmergencySituation) -> some View {
        if situation == .hurt {
            BodyOutlineView()
        } else {
            InventoryQuestionView(situation: situation)
        }
    }
}
