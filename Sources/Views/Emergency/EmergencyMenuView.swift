import SwiftUI

struct EmergencyMenuView: View {
    // Standard Grid (Clean, Open)
    let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 32) {
                
                // MARK: - Header (Clean Apple)
                // Left-Aligned Large Title
                VStack(alignment: .leading, spacing: 4) {
                    Text("Emergency")
                        .font(.system(size: 40, weight: .bold, design: .serif)) // New York
                        .foregroundStyle(DesignSystem.textPrimary)
                    
                    Text("Select Situation")
                        .font(.body)
                        .fontWeight(.medium)
                        .foregroundStyle(DesignSystem.textSecondary)
                }
                .padding(.top, 24)
                .padding(.horizontal, 24)
                
                // MARK: - SITUATIONS GRID (Shortcuts Style)
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(EmergencySituation.allCases) { situation in
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
                .padding(.bottom, 40)
            }
        }
        .background(Color(uiColor: .systemGroupedBackground))
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
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
