import SwiftUI

struct QuickActionsView: View {
    @ObservedObject var db = ContentDatabase.shared
    
    private var criticalTechniques: [Technique] {
        let criticalIds = [
            "firstaid-cpr",
            "firstaid-choking-response",
            "firstaid-tourniquet",
            "firstaid-heimlich",
            "firstaid-bleeding-control-advanced",
            "firstaid-anaphylaxis",
            "firstaid-choking",
            "firstaid-burn-char",
            "firstaid-head-trauma",
            "firstaid-heart-attack",
            "firstaid-stroke",
            "firstaid-shock",
            "firstaid-snakebite",
            "firstaid-poison",
            "firstaid-seizure",
            "firstaid-drowning",
            "firstaid-heatstroke",
            "firstaid-hypothermia",
            "firstaid-childbirth",
            "firstaid-spinal-immobilization",
            "firstaid-impaled-object",
            "firstaid-electrocution"
        ]
        
        let found = criticalIds.compactMap { id in
            db.techniques.first { $0.id == id }
        }
        return found
    }

    init() {}
    
    var body: some View {
        ZStack {
            // MARK: - Ambient Background
            DesignSystem.backgroundPrimary
                .ignoresSafeArea()
            
            // Subtle Mesh Gradient Simulation (Red/Orange for Urgency)
            GeometryReader { proxy in
                ZStack {
                    Circle()
                        .fill(Color.red.opacity(0.1))
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
                    
                    // MARK: - Warning
                    // Removed as per user request (Home only)
                    
                    // MARK: - Header
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Quick Actions")
                            .font(.system(size: 42, weight: .black))
                            .foregroundStyle(DesignSystem.textPrimary)
                            .tracking(-0.5)
                        
                        Text("Life-Threatening — 1-Tap Access")
                            .font(.system(size: 20, weight: .medium))
                            .foregroundStyle(DesignSystem.textSecondary)
                    }
                    .padding(.horizontal, 24)


                    // MARK: - Critical Techniques
                    LazyVGrid(columns: [
                        GridItem(.flexible(), spacing: 16),
                        GridItem(.flexible(), spacing: 16)
                    ], spacing: 16) {
                        ForEach(criticalTechniques) { technique in
                            NavigationLink(destination: VerticalGuideView(technique: technique)) {
                                GlassActionCell(technique: technique)
                            }
                            .buttonStyle(ScalableButtonStyle())
                        }
                    }
                    .padding(.horizontal, 24)
                    
                    if criticalTechniques.isEmpty {
                        VStack(spacing: 12) {
                            Image(systemName: "heart.text.square")
                                .font(.system(size: 48))
                                .foregroundStyle(DesignSystem.textSecondary.opacity(0.5))
                            Text("Critical techniques will appear here")
                                .font(.subheadline)
                                .foregroundStyle(DesignSystem.textSecondary)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 40)
                    }

                    Spacer(minLength: 40)
                }
            }
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Glass Action Cell
struct GlassActionCell: View {
    let technique: Technique
    
    var body: some View {
        VStack(spacing: 16) {
            // Large Icon
            ZStack {
                Circle()
                    .fill(Color.red.opacity(0.15))
                    .frame(width: 72, height: 72)
                
                Image(systemName: technique.icon)
                    .font(.system(size: 32, weight: .semibold))
                    .foregroundStyle(Color.red)
            }
            .shadow(color: Color.red.opacity(0.2), radius: 8, x: 0, y: 4)
            
            // Title
            Text(LocalizedStringKey(technique.name))
                .font(.system(size: 18, weight: .bold))
                .foregroundStyle(DesignSystem.textPrimary)
                .multilineTextAlignment(.center)
                .lineLimit(3)
                .minimumScaleFactor(0.8)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(20)
        .frame(maxWidth: .infinity)
        .frame(minHeight: 180) // Taller for vertical layout
        .background(
            ZStack {
                // Material Background
                Rectangle()
                    .fill(.ultraThinMaterial)
                
                // Red Gradient Tint
                LinearGradient(
                    colors: [
                        Color.red.opacity(0.1),
                        Color.red.opacity(0.02)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            }
        )
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .stroke(Color.red.opacity(0.2), lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 4)
        .contentShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
        .accessibilityElement(children: .combine)
        .accessibilityAddTraits(.isButton)
    }
}
