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
                    
                    // MARK: - Header (Brand Style)
                    if searchText.isEmpty {
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Library", comment: "Section Title")
                                .font(.system(size: 42, weight: .black))
                                .foregroundStyle(DesignSystem.textPrimary)
                                .tracking(-0.5)
                            
                            Text("Survival Guide", comment: "Section Subtitle")
                                .font(.system(size: 20, weight: .medium))
                                .foregroundStyle(DesignSystem.textSecondary)
                            
                            // 3-Way Segmented Control
                            Picker("Mode", selection: $selectedMode) {
                                Text("Browse", comment: "Library Mode").tag(0)
                                Text("Inventory", comment: "Library Mode").tag(1)
                                Text("Saved", comment: "Library Mode").tag(2)
                            }
                            .pickerStyle(.segmented)
                            .padding(.vertical, 8)
                        }
                        .padding(.horizontal, 24)
                        .padding(.top, 20)
                    }
                    
                    // MARK: - CONTENT SWITCHER
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
                            
                        case 1: // INVENTORY
                            InventoryView()
                                .padding(.top, 8)
                            
                        case 2: // SAVED
                            SavedTechniquesView()
                                .padding(.horizontal, 24)
                        default: EmptyView()
                        }
                        
                    } else {
                        // MARK: - SEARCH RESULTS
                        LazyVStack(spacing: 16) {
                            if filteredTechniques.isEmpty {
                                Text("No results found")
                                    .foregroundStyle(.secondary)
                                    .padding(.top, 40)
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
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: Text("Search techniques", comment: "Search Placeholder"))
    }
}

// MARK: - Glass Domain Cell (Component)
struct GlassDomainCell: View {
    let domain: SurvivalDomain
    
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            // MARK: - 1. Glassmorphic Background with Gradient
            RoundedRectangle(cornerRadius: 24, style: .continuous)
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
            
            // MARK: - 2. Content
            VStack(alignment: .leading) {
                // Icon Header
                HStack(alignment: .top) {
                    ZStack {
                        Circle()
                            .fill(domain.color.opacity(0.1))
                            .frame(width: 48, height: 48)
                        
                        Image(systemName: domain.icon)
                            .font(.system(size: 24, weight: .semibold))
                            .foregroundStyle(domain.color)
                    }
                    
                    Spacer()
                    
                    // Count Badge (Pill)
                    Text("\(ContentDatabase.shared.getTechniques(for: domain).count)")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundStyle(domain.color)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(domain.color.opacity(0.1))
                        .clipShape(Capsule())
                }
                
                Spacer()
                
                // Title
                Text(domain.displayName)
                    .font(.system(size: 20, weight: .bold))
                    .foregroundStyle(DesignSystem.textPrimary)
                    .multilineTextAlignment(.leading)
                    .fixedSize(horizontal: false, vertical: true)
                    .minimumScaleFactor(0.85)
            }
            .padding(16)
        }
        .frame(height: 160) // Standard box height matches Emergency
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .stroke(domain.color.opacity(0.2), lineWidth: 1)
        )
        // Soft Shadow for Depth
        .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 4)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(domain.displayName), \(ContentDatabase.shared.getTechniques(for: domain).count) techniques")
        .accessibilityAddTraits(.isButton)
    }
}
