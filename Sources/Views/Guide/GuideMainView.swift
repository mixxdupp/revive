import SwiftUI

struct GuideMainView: View {
    @State private var searchText = ""
    
    var filteredTechniques: [Technique] {
        if searchText.isEmpty { return [] }
        return ContentDatabase.shared.search(query: searchText)
    }
    
    // VisionOS Inspired Grid
    // Clean, centered, "Object" spatial design
    let columns = [
        GridItem(.flexible(), spacing: 20),
        GridItem(.flexible(), spacing: 20)
    ]
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 32) {
                
                // MARK: - Header (Clean & Centered)
                if searchText.isEmpty {
                    VStack(spacing: 8) {
                        Text("Library")
                            .font(.system(size: 40, weight: .bold, design: .rounded))
                            .foregroundStyle(DesignSystem.textPrimary)
                        
                        Text("210 Techniques • 10 Domains")
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundStyle(DesignSystem.textSecondary)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.top, 24)
                }
                
                // MARK: - CATEGORIES GRID (VISION OS STYLE)
                if searchText.isEmpty {
                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(SurvivalDomain.allCases) { domain in
                            NavigationLink(destination: DomainDetailView(domain: domain)) {
                                VStack(spacing: 16) {
                                    // 1. 3D Icon Container
                                    // Floating glass object
                                    ZStack {
                                        Circle()
                                            .fill(
                                                LinearGradient(
                                                    colors: [
                                                        domain.color.opacity(0.8),
                                                        domain.color
                                                    ],
                                                    startPoint: .topLeading,
                                                    endPoint: .bottomTrailing
                                                )
                                            )
                                            .shadow(color: domain.color.opacity(0.4), radius: 10, x: 0, y: 5)
                                        
                                        Image(systemName: domain.icon)
                                            .font(.system(size: 32, weight: .semibold)) // Crisp
                                            .foregroundStyle(.white)
                                            .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 2)
                                    }
                                    .frame(width: 80, height: 80)
                                    
                                    // 2. Typography
                                    VStack(spacing: 4) {
                                        Text(domain.displayName)
                                            .font(.system(size: 20, weight: .bold, design: .rounded))
                                            .foregroundStyle(DesignSystem.textPrimary)
                                            .multilineTextAlignment(.center)
                                        
                                        Text("\(ContentDatabase.shared.getTechniques(for: domain).count) Items")
                                            .font(.caption)
                                            .fontWeight(.medium)
                                            .foregroundStyle(DesignSystem.textSecondary)
                                    }
                                }
                                .padding(.vertical, 32)
                                .padding(.horizontal, 16)
                                .frame(maxWidth: .infinity)
                                .background(
                                    // Multi-layer Glass
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 32, style: .continuous)
                                            .fill(.ultraThinMaterial)
                                            .opacity(0.8) // High opacity glass
                                        
                                        RoundedRectangle(cornerRadius: 32, style: .continuous)
                                            .fill(Color(uiColor: .systemBackground).opacity(0.3)) // Light tint
                                    }
                                )
                                .clipShape(RoundedRectangle(cornerRadius: 32, style: .continuous))
                                .shadow(color: Color.black.opacity(0.05), radius: 12, x: 0, y: 6) // Soft ambient
                                .overlay(
                                    RoundedRectangle(cornerRadius: 32, style: .continuous)
                                        .stroke(.white.opacity(0.4), lineWidth: 1) // Specular rim
                                )
                                // Scale effect on press handled by buttonStyle
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
        .background(
            // Subtle ambient background
            ZStack {
                Color(uiColor: .systemGroupedBackground)
                
                // Ambient Glow
                GeometryReader { geo in
                    Circle()
                        .fill(Color.blue.opacity(0.03))
                        .frame(width: 400, height: 400)
                        .blur(radius: 100)
                        .position(x: geo.size.width * 0.2, y: geo.size.height * 0.2)
                    
                    Circle()
                        .fill(Color.orange.opacity(0.03))
                        .frame(width: 400, height: 400)
                        .blur(radius: 100)
                        .position(x: geo.size.width * 0.8, y: geo.size.height * 0.8)
                }
            }
            .edgesIgnoringSafeArea(.all)
        )
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: "Search techniques")
    }
}
