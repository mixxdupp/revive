import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                // Background (System Background)
                Color(uiColor: .systemGroupedBackground)
                    .edgesIgnoringSafeArea(.all)
                
                // Centered Content
                VStack(spacing: 30) {
                    // MARK: - Header (Phase 53: Serif Branding)
                    // High-End, Editorial, Distinctive.
                    VStack(spacing: 6) {
                        // Brand Logotype
                        // Using Apple's New York (Serif) for premium feel
                        Text("Revive")
                            .font(.system(size: 56, weight: .black, design: .serif))
                            .foregroundStyle(DesignSystem.textPrimary)
                            .tracking(-1) // Tight, authoritative tracking
                        
                        // Tagline (Minimalist)
                        Text("SURVIVAL INTELLIGENCE")
                            .font(.system(size: 13, weight: .semibold, design: .rounded)) // Rounded for contrast
                            .foregroundStyle(DesignSystem.textSecondary.opacity(0.8))
                            .tracking(4) // Wide, sophisticated
                            .textCase(.uppercase)
                    }
                    .multilineTextAlignment(.center)
                    .padding(.top, 74) // Clear Notch + Status Bar
                    
                    .padding(.top, 20)

                    // MARK: - Action Buttons (Centered Stack)
                    VStack(spacing: 24) {
                        
                        // 0. PANIC BUTTON (Instant Siren)
                        Button(action: {
                            // URL Scheme is unreliable for in-app triggers. Use Notification.
                            NotificationCenter.default.post(name: .triggerPanic, object: nil)
                        }) {
                            HStack(spacing: 16) {
                                Image(systemName: "light.beacon.max.fill")
                                    .font(.system(size: 32))
                                    .foregroundStyle(.white)
                                    .symbolEffect(.pulse.byLayer)
                                
                                VStack(alignment: .leading, spacing: 2) {
                                    Text("PANIC SIREN")
                                        .font(.title3)
                                        .fontWeight(.black)
                                        .foregroundStyle(.white)
                                    
                                    Text("TAP TO ACTIVATE")
                                        .font(.caption)
                                        .fontWeight(.bold)
                                        .foregroundStyle(.white.opacity(0.9))
                                }
                                Spacer()
                            }
                            .padding(.horizontal, 24)
                            .padding(.vertical, 20)
                            .background(
                                LinearGradient(colors: [Color.red, Color(red: 0.8, green: 0, blue: 0)], startPoint: .topLeading, endPoint: .bottomTrailing)
                            )
                            .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
                            .overlay(
                                RoundedRectangle(cornerRadius: 24)
                                    .stroke(.white.opacity(0.3), lineWidth: 1)
                            )
                            .shadow(color: Color.red.opacity(0.4), radius: 10, x: 0, y: 5)
                        }
                        .buttonStyle(ScalableButtonStyle())

                        // 1. Emergency Menu (Checklists)
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
                        
                        // 2. Library Button (Clean & Bold)
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
                        
                        // 3. Quick Actions & Tools (Side by Side)
                        HStack(spacing: 16) {
                            NavigationLink(destination: QuickActionsView()) {
                                VStack(spacing: 10) {
                                    Image(systemName: "bolt.heart.fill")
                                        .font(.system(size: 28))
                                        .foregroundStyle(.white)
                                    
                                    Text("Quick Actions")
                                        .font(.callout)
                                        .fontWeight(.bold)
                                        .foregroundStyle(.white)
                                        .multilineTextAlignment(.center)
                                        .lineLimit(2)
                                        .minimumScaleFactor(0.8)
                                        .fixedSize(horizontal: false, vertical: true)
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 24)
                                .background(Color.green)
                                .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
                                .shadow(color: Color.black.opacity(0.15), radius: 12, x: 0, y: 6)
                            }
                            .buttonStyle(ScalableButtonStyle())
                            
                            NavigationLink(destination: ToolsMenuView()) {
                                VStack(spacing: 10) {
                                    Image(systemName: "wrench.and.screwdriver.fill")
                                        .font(.system(size: 28))
                                        .foregroundStyle(.white)
                                    
                                    Text("Tools")
                                        .font(.callout)
                                        .fontWeight(.bold)
                                        .foregroundStyle(.white)
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 24)
                                .background(Color.indigo)
                                .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
                                .shadow(color: Color.black.opacity(0.15), radius: 12, x: 0, y: 6)
                            }
                            .buttonStyle(ScalableButtonStyle())
                        }
                        
                    }
                    .padding(.horizontal, 32) // Inset for centered look
                    
                    Spacer()
                    Spacer() // Push slightly up visually
                }
            }
        }
    }
}
