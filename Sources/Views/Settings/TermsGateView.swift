import SwiftUI

struct TermsGateView: View {
    @ObservedObject var settings = SettingsService.shared
    var isOnboarding: Bool = false
    
    var body: some View {
        ZStack {
            DesignSystem.backgroundPrimary.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header (Only show if standalone)
                if !isOnboarding {
                    VStack(spacing: 12) {
                        Image(systemName: "hand.raised.fill")
                            .font(.system(size: 48))
                            .foregroundStyle(.red)
                            .padding(.top, 40)
                        
                        Text("Legal Agreement")
                            .font(.system(size: 28, weight: .black))
                            .foregroundStyle(DesignSystem.textPrimary)
                        
                        Text("Please read carefully before using Revive.")
                            .font(.subheadline)
                            .foregroundStyle(DesignSystem.textSecondary)
                    }
                    .padding(.bottom, 20)
                } else {
                    // Simpler header for onboarding
                    Text("Final Step: Safety")
                         .font(.system(size: 32, weight: .bold))
                         .foregroundStyle(DesignSystem.textPrimary)
                         .padding(.top, 60)
                         .padding(.bottom, 20)
                }
                
                // Scrollable Legalese
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        Group {
                            Text("1. NO MEDICAL ADVICE")
                                .font(.headline)
                            Text("The content of this app is for educational and informational purposes only. It is NOT a substitute for professional medical advice, diagnosis, or treatment. Always call your local emergency services in a medical emergency.")
                            
                            Text("2. LIABILITY WAIVER")
                                .font(.headline)
                            Text("By using this app, you agree that the developers and contributors of Revive are not liable for any injury, loss, or damage resulting from the use or misuse of the information provided herein. You use this app entirely at your own risk.")
                            
                            Text("3. OFFLINE USE")
                                .font(.headline)
                            Text("This app is designed to function offline. However, location services and other hardware features may be limited by your device's battery and sensor availability.")
                            
                            Text("4. PRIVACY POLICY")
                                .font(.headline)
                            Text("Revive does not collect, store, or transmit any personal data. All location data stays on your device and is used solely for the Compass and GPS features.")
                        }
                        .font(.system(size: 15))
                        .foregroundStyle(DesignSystem.textPrimary)
                        
                        Text("LAST UPDATED: FEB 2026")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .padding(.top, 20)
                    }
                    .padding(24)
                }
                .background(Color(uiColor: .systemBackground))
                .cornerRadius(16)
                .padding(.horizontal, 20)
                .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
                
                // Sticky Footer Actions
                VStack(spacing: 16) {
                    Text("Do you agree to these terms?")
                        .font(.headline)
                    
                    HStack(spacing: 16) {
                        // DISAGREE -> KILL APP
                        Button(action: {
                            print("User disagreed. Terminating app.")
                            exit(0)
                        }) {
                            Text("Disagree")
                                .font(.headline)
                                .foregroundColor(.red)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.red.opacity(0.1))
                                .cornerRadius(12)
                        }
                        .accessibilityLabel("Disagree, terminates app")
                        
                        // AGREE -> ENTER APP
                        Button(action: {
                            HapticsService.shared.playNotification(type: .success)
                            withAnimation {
                                settings.hasAcceptedLiability = true
                            }
                        }) {
                            Text("I Agree")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.green)
                                .cornerRadius(12)
                                .shadow(color: Color.green.opacity(0.3), radius: 5, x: 0, y: 2)
                        }
                    }
                }
                .padding(24)
                .background(DesignSystem.backgroundPrimary)
            }
        }
    }
}
