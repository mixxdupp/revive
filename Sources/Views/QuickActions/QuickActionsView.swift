import SwiftUI

struct QuickActionsView: View {
    private let criticalTechniques: [Technique]

    init() {
        let criticalIds = [
            "firstaid-cpr",
            "firstaid-choking-response",
            "firstaid-tourniquet",
            "firstaid-heimlich",
            "firstaid-bleeding-control-advanced",
            "firstaid-anaphylaxis",
            "firstaid-choking",
            "firstaid-burn-char",
            "firstaid-head-trauma"
        ]
        let db = ContentDatabase.shared
        self.criticalTechniques = criticalIds.compactMap { id in
            db.techniques.first { $0.id == id }
        }
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 32) {

                // MARK: - Header
                VStack(alignment: .leading, spacing: 4) {
                    Text("Quick Actions")
                        .font(.system(size: 40, weight: .bold, design: .serif))
                        .foregroundStyle(DesignSystem.textPrimary)
                    Text("Life-Threatening — 1-Tap Access")
                        .font(.body.weight(.medium))
                        .foregroundStyle(DesignSystem.textSecondary)
                }
                .padding(.top, 24)
                .padding(.horizontal, 24)

                // MARK: - Warning
                HStack(spacing: 10) {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .font(.title3)
                        .foregroundStyle(.yellow)
                    Text("Call Emergency Services if someone is unresponsive or not breathing.")
                        .font(.subheadline.weight(.medium))
                        .foregroundStyle(.white)
                }
                .padding(16)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.red.opacity(0.85))
                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                .padding(.horizontal, 24)

                // MARK: - Critical Techniques
                VStack(spacing: 12) {
                    ForEach(criticalTechniques) { technique in
                        NavigationLink(destination: StepCardPager(technique: technique)) {
                            HStack(spacing: 14) {
                                // Urgency indicator
                                Circle()
                                    .fill(Color.red)
                                    .frame(width: 10, height: 10)

                                Image(systemName: technique.icon)
                                    .font(.system(size: 22))
                                    .foregroundStyle(.white)
                                    .frame(width: 44, height: 44)
                                    .background(Color.red)
                                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))

                                VStack(alignment: .leading, spacing: 2) {
                                    Text(technique.name)
                                        .font(.headline)
                                        .foregroundStyle(DesignSystem.textPrimary)
                                    Text(technique.subtitle)
                                        .font(.subheadline)
                                        .foregroundStyle(DesignSystem.textSecondary)
                                        .lineLimit(1)
                                }

                                Spacer()

                                Image(systemName: "chevron.right")
                                    .font(.subheadline.weight(.semibold))
                                    .foregroundStyle(DesignSystem.textSecondary)
                            }
                            .padding(14)
                            .background(Color(uiColor: .secondarySystemGroupedBackground))
                            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                        }
                        .buttonStyle(ScalableButtonStyle())
                    }

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
                }
                .padding(.horizontal, 24)

                Spacer(minLength: 40)
            }
        }
        .background(Color(uiColor: .systemGroupedBackground))
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
    }
}
