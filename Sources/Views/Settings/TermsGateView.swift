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
                            Text("1. NO MEDICAL ADVICE (INFORMATIONAL ONLY)")
                                .font(.headline)
                                .foregroundStyle(.red)
                            Text("The content of this app is for educational and reference purposes only. It is NOT a substitute for professional medical advice, diagnosis, or treatment. NEVER disregard professional medical advice or delay seeking it because of something you have read in this app. ALWAYS CALL EMERGENCY SERVICES (911/112/999) IN A MEDICAL EMERGENCY.")
                            
                            Text("2. COMPLETE WAIVER OF LIABILITY")
                                .font(.headline)
                                .foregroundStyle(.red)
                            Text("By clicking 'I Agree' and using this app, you AUTOMATICALLY AND COMPLETELY WAIVE ANY AND ALL RIGHTS TO HOLD THE DEVELOPERS, CREATORS, OR CONTRIBUTORS LIABLE for any injury, loss, property damage, or death resulting from the use or misuse of the information provided herein. YOU USE THIS APP ENTIRELY AT YOUR OWN RISK.")
                            
                            Text("3. ASSUMPTION OF RISK & NO WARRANTY")
                                .font(.headline)
                            Text("Survival and medical emergencies are inherently dangerous. The developers make NO WARRANTIES, express or implied, regarding the accuracy, completeness, or effectiveness of the information provided. The app is provided 'AS IS'.")
                            
                            Text("4. OFFLINE USE & PRIVACY")
                                .font(.headline)
                            Text("This app is designed to function offline. Location services are processed entirely on-device for the Compass/GPS tools. Revive does not collect, transmit, or store personal data.")
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
