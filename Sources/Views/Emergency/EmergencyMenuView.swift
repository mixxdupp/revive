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
        ZStack {
            // MARK: - Ambient Background
            DesignSystem.backgroundPrimary
                .ignoresSafeArea()
            
            // Subtle Mesh Gradient Simulation
            GeometryReader { proxy in
                ZStack {
                    Circle()
                        .fill(Color.blue.opacity(0.1))
                        .frame(width: 300, height: 300)
                        .blur(radius: 60)
                        .offset(x: -100, y: -100)
                    
                    Circle()
                        .fill(Color.orange.opacity(0.1))
                        .frame(width: 300, height: 300)
                        .blur(radius: 60)
                        .offset(x: 200, y: 100)
                }
                .frame(width: proxy.size.width, height: proxy.size.height)
            }
            .ignoresSafeArea()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 32) {
                    
                    // MARK: - Banner
                    // Removed as per user request (Home only)
                    
                    // MARK: - Header (Clean Apple)
                    // Left-Aligned Large Title
                    // MARK: - Header (Brand Style)
                    // Left-Aligned Large Title
                    if searchText.isEmpty {
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Emergency", comment: "Section Title")
                                .font(.system(size: 42, weight: .bold)) // Match Revive Brand
                                .foregroundStyle(DesignSystem.textPrimary)
                                .tracking(-0.5) // Tight tracking for impact
                            
                            Text("Fast response protocols", comment: "Section Subtitle")
                                .font(.system(size: 20, weight: .medium)) // Match Subtitle Style
                                .foregroundStyle(DesignSystem.textSecondary)
                        }
                        .padding(.horizontal, 24)
                        .padding(.top, 20)
                    }
                    
                    // MARK: - SITUATIONS GRID (Shortcuts Style)
                    LazyVGrid(columns: columns, spacing: 16) {
                        ForEach(filteredSituations) { situation in
                            NavigationLink(destination: destinationView(for: situation)) {
                                EmergencyCell(situation: situation)
                            }
                            .buttonStyle(ScalableButtonStyle())
                        }
                    }
                    .padding(.horizontal, 24)
                    
                    // MARK: - Recently Viewed
                    if !RecentlyViewedService.shared.recentTechniques().isEmpty {
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Quick Access", comment: "Recently Viewed Header")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundStyle(DesignSystem.textPrimary)
                                .padding(.horizontal, 24)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 16) {
                                    ForEach(RecentlyViewedService.shared.recentTechniques(limit: 5)) { technique in
                                        NavigationLink(destination: VerticalGuideView(technique: technique)) {
                                            HStack(spacing: 12) {
                                                Image(systemName: technique.icon)
                                                    .font(.system(size: 20))
                                                    .foregroundStyle(technique.domain.color)
                                                    .frame(width: 44, height: 44)
                                                    .background(.ultraThinMaterial)
                                                    .clipShape(Circle())
                                                
                                                VStack(alignment: .leading, spacing: 2) {
                                                    Text(LocalizedStringKey(technique.name))
                                                        .font(.subheadline.weight(.semibold))
                                                        .foregroundStyle(DesignSystem.textPrimary)
                                                    Text(LocalizedStringKey(technique.subtitle))
                                                        .font(.caption)
                                                        .foregroundStyle(DesignSystem.textSecondary)
                                                        .lineLimit(1)
                                                }
                                                .frame(maxWidth: 160, alignment: .leading)
                                            }
                                            .padding(12)
                                            .background(.ultraThinMaterial)
                                            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 16, style: .continuous)
                                                    .strokeBorder(Color.white.opacity(0.2), lineWidth: 0.5)
                                            )
                                        }
                                        .buttonStyle(ScalableButtonStyle())
                                    }
                                }
                                .padding(.horizontal, 24)
                            }
                        }
                    }
                    
                    Spacer(minLength: 40)
                }
            }
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: Text("Search situations", comment: "Search Placeholder"))
    }
    

    func destinationView(for situation: EmergencySituation) -> some View {
        InventoryQuestionView(situation: situation)
    }
}
