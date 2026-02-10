import SwiftUI

struct EmergencyMenuView: View {
    // VisionOS Inspired Grid (Same as GuideMainView)
    let columns = [
        GridItem(.flexible(), spacing: 20),
        GridItem(.flexible(), spacing: 20)
    ]
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 32) {
                // MARK: - Header (VisionOS Clean)
                VStack(spacing: 8) {
                    Text("Emergency")
                        .font(.system(size: 40, weight: .bold, design: .rounded))
                        .foregroundStyle(DesignSystem.textPrimary)
                    
                    Text("Select Situation")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundStyle(DesignSystem.textSecondary)
                }
                .frame(maxWidth: .infinity)
                .padding(.top, 24)
                
                // MARK: - SITUATIONS GRID
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(EmergencySituation.allCases) { situation in
                        NavigationLink(destination: destinationView(for: situation)) {
                            VStack(spacing: 16) {
                                // 1. 3D Icon Container
                                ZStack {
                                    Circle()
                                        .fill(
                                            LinearGradient(
                                                colors: [
                                                    situation.color.opacity(0.8),
                                                    situation.color
                                                ],
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            )
                                        )
                                        .shadow(color: situation.color.opacity(0.4), radius: 10, x: 0, y: 5)
                                    
                                    Image(systemName: situation.icon)
                                        .font(.system(size: 32, weight: .semibold))
                                        .foregroundStyle(.white)
                                        .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 2)
                                }
                                .frame(width: 80, height: 80)
                                
                                // 2. Typography
                                Text(situation.displayName)
                                    .font(.system(size: 20, weight: .bold, design: .rounded))
                                    .foregroundStyle(DesignSystem.textPrimary)
                                    .multilineTextAlignment(.center)
                            }
                            .padding(.vertical, 32)
                            .padding(.horizontal, 16)
                            .frame(maxWidth: .infinity)
                            .background(
                                // Multi-layer Glass
                                ZStack {
                                    RoundedRectangle(cornerRadius: 32, style: .continuous)
                                        .fill(.ultraThinMaterial)
                                        .opacity(0.8)
                                    
                                    RoundedRectangle(cornerRadius: 32, style: .continuous)
                                        .fill(Color(uiColor: .systemBackground).opacity(0.3))
                                }
                            )
                            .clipShape(RoundedRectangle(cornerRadius: 32, style: .continuous))
                            .shadow(color: Color.black.opacity(0.05), radius: 12, x: 0, y: 6)
                            .overlay(
                                RoundedRectangle(cornerRadius: 32, style: .continuous)
                                    .stroke(.white.opacity(0.4), lineWidth: 1)
                            )
                        }
                        .buttonStyle(ScalableButtonStyle())
                    }
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 40)
            }
        }
        .background(
            // Subtle ambient background (Red/Orange tint for Emergency)
            ZStack {
                Color(uiColor: .systemGroupedBackground)
                
                GeometryReader { geo in
                    Circle()
                        .fill(Color.red.opacity(0.04))
                        .frame(width: 500, height: 500)
                        .blur(radius: 120)
                        .position(x: geo.size.width * 0.5, y: geo.size.height * 0.4)
                }
            }
            .edgesIgnoringSafeArea(.all)
        )
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
