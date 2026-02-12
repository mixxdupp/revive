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
        ScrollView {
            VStack(alignment: .leading, spacing: 32) {
                
                // MARK: - Warning
                EmergencyBanner()
                    .padding(.top, 16) // Top spacing
                    .padding(.horizontal, 24)
                
                // MARK: - Header
                VStack(alignment: .leading, spacing: 4) {
                    Text("Quick Actions")
                        .font(.system(size: 40, weight: .bold, design: .serif))
                        .foregroundStyle(DesignSystem.textPrimary)
                    Text("Life-Threatening — 1-Tap Access")
                        .font(.body.weight(.medium))
                        .foregroundStyle(DesignSystem.textSecondary)
                }
                .padding(.horizontal, 24)


                // MARK: - Critical Techniques
                // Moved to 2-column grid for density
                LazyVGrid(columns: [
                    GridItem(.flexible(), spacing: 16),
                    GridItem(.flexible(), spacing: 16)
                ], spacing: 16) {
                    ForEach(criticalTechniques) { technique in
                        NavigationLink(destination: StepCardPager(technique: technique)) {
                            VStack(spacing: 12) {
                                // Large Centered Icon
                                Image(systemName: technique.icon)
                                    .font(.system(size: 32, weight: .semibold))
                                    .foregroundStyle(.white)
                                    .frame(width: 64, height: 64)
                                    .background(Color.red)
                                    .clipShape(Circle()) // Circle for urgent feel
                                    .shadow(color: Color.red.opacity(0.3), radius: 8, x: 0, y: 4)
                                
                                // Title Only (No subtitle for density)
                                Text(technique.name)
                                    .font(.headline)
                                    .foregroundStyle(DesignSystem.textPrimary)
                                    .multilineTextAlignment(.center)
                                    .lineLimit(3) // Allow wrapping
                                    .fixedSize(horizontal: false, vertical: true) // Grow vertically
                            }
                            .frame(maxWidth: .infinity)
                            .padding(16)
                            .background(Color(uiColor: .secondarySystemGroupedBackground))
                            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                            .shadow(color: Color.black.opacity(0.06), radius: 6, x: 0, y: 3)
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
        .background(Color(uiColor: .systemGroupedBackground))
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
    }
}
