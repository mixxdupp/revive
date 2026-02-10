import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                // Background (System Background)
                Color(uiColor: .systemGroupedBackground)
                    .edgesIgnoringSafeArea(.all)
                
                // Centered Content
                VStack(spacing: 60) {
                    Spacer()
                    
                    // MARK: - Header (Phase 51: Centered)
                    VStack(spacing: 8) {
                        Text("Revive")
                            .font(.system(size: 48, weight: .bold, design: .default))
                            .foregroundStyle(DesignSystem.textPrimary)
                        
                        Text("Survival Intelligence")
                            .font(.title3)
                            .fontWeight(.medium)
                            .foregroundStyle(DesignSystem.textSecondary)
                    }
                    .multilineTextAlignment(.center)
                    
                    // MARK: - Action Buttons (Centered Stack)
                    VStack(spacing: 24) {
                        
                        // 1. Emergency Button (Centered Content)
                        NavigationLink(destination: EmergencyMenuView()) {
                            VStack(spacing: 16) {
                                Image(systemName: "exclamationmark.triangle.fill")
                                    .font(.system(size: 40))
                                    .foregroundStyle(.white)
                                
                                Text("Emergency")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundStyle(.white)
                                
                                Text("Immediate Action")
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                    .foregroundStyle(.white.opacity(0.8))
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 32)
                            .background(Color.red) // Pure Standard Red
                            .clipShape(RoundedRectangle(cornerRadius: 32, style: .continuous))
                            .shadow(color: Color.black.opacity(0.15), radius: 15, x: 0, y: 8)
                        }
                        .buttonStyle(ScalableButtonStyle())
                        
                        // 2. Library Button (Centered Content)
                        NavigationLink(destination: GuideMainView()) {
                            VStack(spacing: 16) {
                                Image(systemName: "book.fill")
                                    .font(.system(size: 40))
                                    .foregroundStyle(.white)
                                
                                Text("Library")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundStyle(.white)
                                
                                Text("Survival Guide")
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                    .foregroundStyle(.white.opacity(0.8))
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 32)
                            .background(Color.blue) // Pure Standard Blue
                            .clipShape(RoundedRectangle(cornerRadius: 32, style: .continuous))
                            .shadow(color: Color.black.opacity(0.15), radius: 15, x: 0, y: 8)
                        }
                        .buttonStyle(ScalableButtonStyle())
                        
                    }
                    .padding(.horizontal, 32) // Inset for centered look
                    
                    Spacer()
                    Spacer() // Push slightly up visually
                }
            }
        }
    }
}
