import SwiftUI

struct InjuryTypeView: View {
    let bodyPart: String
    let suggestedTechniqueIDs: [String]
    @Environment(\.dismiss) var dismiss
    
    // Get matching techniques from the database
    var matchingTechniques: [Technique] {
        let db = ContentDatabase.shared
        // First: exact ID matches from suggested list
        var results = suggestedTechniqueIDs.compactMap { id in
            db.techniques.first(where: { $0.id == id })
        }
        
        // If no exact matches found, fall back to all firstAid techniques
        if results.isEmpty {
            results = db.getTechniques(for: .firstAid)
        }
        
        return results
    }
    
    var body: some View {
        ZStack {
            DesignSystem.backgroundPrimary.edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 0) {
                // Header
                HStack {
                    Button(action: { dismiss() }) {
                        HStack(spacing: 4) {
                            Image(systemName: "chevron.left")
                            Text("Back")
                        }
                        .font(Typography.button)
                        .foregroundColor(DesignSystem.textSecondary)
                    }
                    Spacer()
                }
                .padding(.horizontal, Layout.screenPadding)
                .padding(.top, 20)
                .padding(.bottom, 10)
                
                Text("\(bodyPart) Injury")
                    .font(Typography.emergencyTitle)
                    .foregroundColor(DesignSystem.textPrimary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, Layout.screenPadding)
                    .padding(.bottom, 20)
                
                ScrollView {
                    VStack(spacing: 12) {
                        ForEach(matchingTechniques) { technique in
                            NavigationLink(destination: StepCardPager(technique: technique)) {
                                HStack(spacing: 14) {
                                    Image(systemName: "cross.case.fill")
                                        .font(.system(size: 20))
                                        .foregroundColor(DesignSystem.emergencyRed)
                                        .frame(width: 40, height: 40)
                                        .background(DesignSystem.emergencyRed.opacity(0.15))
                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                    
                                    VStack(alignment: .leading, spacing: 3) {
                                        Text(technique.name)
                                            .font(Typography.headline)
                                            .foregroundColor(DesignSystem.textPrimary)
                                            .lineLimit(1)
                                        
                                        Text(technique.subtitle)
                                            .font(Typography.caption)
                                            .foregroundColor(DesignSystem.textSecondary)
                                            .lineLimit(1)
                                    }
                                    
                                    Spacer()
                                    
                                    Image(systemName: "chevron.right")
                                        .font(.system(size: 14, weight: .semibold))
                                        .foregroundColor(DesignSystem.textSecondary)
                                }
                                .padding(14)
                                .background(DesignSystem.backgroundSecondary)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                            }
                            .buttonStyle(ScalableButtonStyle())
                        }
                        
                        if matchingTechniques.isEmpty {
                            VStack(spacing: 12) {
                                Image(systemName: "bandage")
                                    .font(.system(size: 40))
                                    .foregroundColor(DesignSystem.textSecondary)
                                Text("No specific techniques found.\nUse the Knowledge Base for general first aid.")
                                    .font(Typography.body)
                                    .foregroundColor(DesignSystem.textSecondary)
                                    .multilineTextAlignment(.center)
                            }
                            .padding(.top, 40)
                        }
                    }
                    .padding(.horizontal, Layout.screenPadding)
                    .padding(.bottom, 30)
                }
            }
        }
        .navigationBarHidden(true)
    }
}
