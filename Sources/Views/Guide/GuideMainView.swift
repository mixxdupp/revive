import SwiftUI

struct GuideMainView: View {
    @State private var searchText = ""
    @State private var selectedMode = 0 // 0: Browse, 1: Inventory, 2: Saved
    
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
        ZStack {
            Color.black
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Only visible when not searching
                if searchText.isEmpty {
                    Picker("Mode", selection: $selectedMode) {
                        Text("Browse", comment: "Library Mode").tag(0)
                        Text("Inventory", comment: "Library Mode").tag(1)
                        Text("Saved", comment: "Library Mode").tag(2)
                    }
                    .pickerStyle(.segmented)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 10)
                }
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        
                        if searchText.isEmpty {
                            switch selectedMode {
                            case 0: // BROWSE
                                LazyVGrid(columns: columns, spacing: 16) {
                                    ForEach(SurvivalDomain.allCases) { domain in
                                        NavigationLink(destination: DomainDetailView(domain: domain)) {
                                            GlassDomainCell(domain: domain)
                                        }
                                        .buttonStyle(ScalableButtonStyle())
                                    }
                                }
                                .padding(.horizontal, 24)
                                .padding(.bottom, 40)
                                .transition(.opacity.combined(with: .move(edge: .leading)))
                                
                            case 1: // INVENTORY
                                InventoryView()
                                    .transition(.opacity.combined(with: .move(edge: .trailing)))
                                
                            case 2: // SAVED
                                SavedTechniquesView()
                                    .transition(.opacity.combined(with: .move(edge: .trailing)))
                            default: EmptyView()
                            }
                            
                        } else {
                            LazyVStack(spacing: 16) {
                                if filteredTechniques.isEmpty {
                                    VStack(spacing: 12) {
                                        Image(systemName: "magnifyingglass")
                                            .font(.system(size: 36))
                                            .foregroundStyle(DesignSystem.textSecondary)
                                        Text("No results found")
                                            .font(.headline)
                                            .foregroundStyle(DesignSystem.textSecondary)
                                        Text("Try a different search term")
                                            .font(.subheadline)
                                            .foregroundStyle(DesignSystem.textSecondary.opacity(0.7))
                                    }
                                    .frame(maxWidth: .infinity)
                                    .padding(.top, 60)
                                } else {
                                    ForEach(filteredTechniques) { technique in
                                        NavigationLink(destination: VerticalGuideView(technique: technique)) {
                                            TechniqueRow(technique: technique)
                                        }
                                    }
                                }
                            }
                            .padding(24)
                        }
                    }
                }
                .animation(.easeInOut(duration: 0.25), value: selectedMode)
            }
        }
        .navigationTitle("Library")
        .navigationBarTitleDisplayMode(.large)
        .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: Text("Search"))
    }
}

struct GlassDomainCell: View {
    let domain: SurvivalDomain
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(.ultraThinMaterial)
                .overlay(
                    LinearGradient(
                        colors: [
                            domain.color.opacity(0.15),
                            domain.color.opacity(0.02)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
            
            VStack(alignment: .leading, spacing: 0) {
                // Icon Header
                HStack(alignment: .top) {
                    ZStack {
                        Circle()
                            .fill(domain.color.opacity(0.15))
                            .frame(width: 44, height: 44)
                        
                        Image(systemName: domain.icon)
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundStyle(domain.color)
                    }
                    
                    Spacer()
                    
                    // Count Badge
                    Text("\(ContentDatabase.shared.getTechniques(for: domain).count) guides")
                        .font(.system(size: 12, weight: .semibold, design: .rounded))
                        .foregroundStyle(domain.color)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(domain.color.opacity(0.12))
                        .clipShape(Capsule())
                }
                
                Spacer(minLength: 0)
                
                // Title
                Text(domain.displayName)
                    .font(.system(size: 18, weight: .bold, design: .default))
                    .foregroundStyle(DesignSystem.textPrimary)
                    .multilineTextAlignment(.leading)
                    .lineLimit(2)
                    .minimumScaleFactor(0.85)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(16)
        }
        .frame(height: 160)
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .strokeBorder(Color.white.opacity(0.1), lineWidth: 0.5)
        )
        // Soft Shadow for Depth
        .shadow(color: Color.black.opacity(0.15), radius: 10, x: 0, y: 5)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(domain.displayName), \(ContentDatabase.shared.getTechniques(for: domain).count) techniques")
        .accessibilityAddTraits(.isButton)
    }
}
