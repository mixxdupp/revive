import SwiftUI

struct QuickActionsView: View {
    @ObservedObject var db = ContentDatabase.shared
    @State private var isAnimating = false
    
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
        ZStack(alignment: .top) {
            // MARK: - Ambient Background
            DesignSystem.backgroundPrimary
                .ignoresSafeArea()
            
            // Subtle Animated Mesh Gradient Simulation (Red/Orange for Urgency)
            GeometryReader { proxy in
                ZStack {
                    Circle()
                        .fill(Color.red.opacity(0.15))
                        .frame(width: 350, height: 350)
                        .blur(radius: 60)
                        .offset(x: isAnimating ? -50 : -150, y: isAnimating ? -50 : -150)
                    
                    Circle()
                        .fill(Color.orange.opacity(0.12))
                        .frame(width: 300, height: 300)
                        .blur(radius: 60)
                        .offset(x: isAnimating ? 150 : 250, y: isAnimating ? 50 : 150)
                }
                .frame(width: proxy.size.width, height: proxy.size.height)
                .onAppear {
                    withAnimation(.easeInOut(duration: 8.0).repeatForever(autoreverses: true)) {
                        isAnimating = true
                    }
                }
            }
            .ignoresSafeArea()
            
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: 20) {
                    
                    // MARK: - Header
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Quick Actions")
                            .font(.system(size: 40, weight: .bold)) // High-impact native title
                            .foregroundStyle(DesignSystem.textPrimary)
                            .tracking(-0.5)
                        
                        Text("Life-threatening conditions — 1-tap access")
                            .font(.system(size: 16, weight: .medium)) // Fixed sub-heading typography
                            .foregroundStyle(DesignSystem.textSecondary)
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 16)
                    .padding(.bottom, 8)


                    // MARK: - Critical Techniques
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
                        .padding(.vertical, 60)
                    } else {
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
        VStack(alignment: .center, spacing: 14) {
            // Refined Crisp Icon Box (Smaller, more elegant)
            ZStack {
                Circle()
                    .fill(Color.red.opacity(0.12))
                    .frame(width: 50, height: 50)
                
                Image(systemName: technique.icon)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(Color.red)
            }
            .padding(.top, 4)
            
            // Clean Typography Title
            Text(LocalizedStringKey(technique.name))
                .font(.system(size: 15, weight: .semibold, design: .default))
                .foregroundStyle(DesignSystem.textPrimary)
                .multilineTextAlignment(.center)
                .lineLimit(3)
                .minimumScaleFactor(0.85)
                .fixedSize(horizontal: false, vertical: true)
                .frame(maxWidth: .infinity)
                
            Spacer(minLength: 0)
        }
        .padding(16)
        .frame(height: 140) // Fixed Apple-standard square-ish tile height
        .frame(maxWidth: .infinity)
        .background(.ultraThinMaterial) // Pure uncolored glass
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous)) // Squircle aesthetic
        .overlay(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .strokeBorder(Color.white.opacity(0.1), lineWidth: 0.5)
        )
        .contentShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .accessibilityElement(children: .combine)
        .accessibilityAddTraits(.isButton)
    }
}
