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
                    VStack(alignment: .center, spacing: 12) {
                        Image(systemName: "shield.fill")
                            .font(.system(size: 44))
                            .foregroundStyle(.blue.gradient)
                        
                        Text("Terms & Conditions")
                             .font(.system(size: 34, weight: .bold))
                             .foregroundStyle(DesignSystem.textPrimary)
                             .multilineTextAlignment(.center)
                    }
                    .padding(.top, 60)
                    .padding(.bottom, 24)
                }
                
                // Scrollable Legalese
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        Group {
                            VStack(alignment: .leading, spacing: 6) {
                                Text("1. No Medical Advice")
                                    .font(.headline)
                                    .foregroundStyle(DesignSystem.textPrimary)
                                Text("The content of this app is for educational and reference purposes only. It is not a substitute for professional medical advice, diagnosis, or treatment. Always call emergency services (911) in a medical emergency.")
                            }
                            
                            VStack(alignment: .leading, spacing: 6) {
                                Text("2. Waiver of Liability")
                                    .font(.headline)
                                    .foregroundStyle(DesignSystem.textPrimary)
                                Text("By selecting 'Agree', you completely waive all rights to hold the developers or contributors liable for any injury, loss, property damage, or death resulting from the use or misuse of the information provided herein. You use this app entirely at your own risk.")
                            }
                            
                            VStack(alignment: .leading, spacing: 6) {
                                Text("3. Assumption of Risk")
                                    .font(.headline)
                                    .foregroundStyle(DesignSystem.textPrimary)
                                Text("Survival and medical emergencies are inherently dangerous. The developers make no warranties, express or implied, regarding the accuracy or completeness of the information provided. The app is provided 'as is'.")
                            }
                            
                            VStack(alignment: .leading, spacing: 6) {
                                Text("4. Offline Use & Privacy")
                                    .font(.headline)
                                    .foregroundStyle(DesignSystem.textPrimary)
                                Text("This app is designed to function entirely offline. Location services are processed strictly on-device for the mapping tools. Revive does not collect, transmit, or store personal data.")
                            }
                        }
                        .font(.system(size: 15))
                        .foregroundStyle(DesignSystem.textSecondary)
                        .lineSpacing(4)
                        
                        Text("Last Updated: Feb 2026")
                            .font(.caption)
                            .foregroundStyle(Color.gray.opacity(0.6))
                            .padding(.top, 16)
                    }
                    .padding(24)
                }
                .background(Color(uiColor: .systemGray6).opacity(0.1))
                .cornerRadius(16)
                .padding(.horizontal, 24)
                // Removed aggressive shadow for cleaner iOS look
                
                // Sticky Footer Actions (Native Apple Style)
                VStack(spacing: 24) {
                    Text("By selecting 'Agree', you accept the Terms & Conditions and acknowledge this app does not provide professional medical advice.")
                        .font(.caption)
                        .foregroundStyle(Color.gray)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 16)
                    
                    VStack(spacing: 12) {
                        // AGREE -> ENTER APP
                        Button(action: {
                            HapticsService.shared.playNotification(type: .success)
                            withAnimation {
                                settings.hasAcceptedLiability = true
                            }
                        }) {
                            Text("Agree")
                                .font(.system(size: 17, weight: .bold))
                                .foregroundColor(.black)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(Color.white)
                                .clipShape(Capsule())
                        }
                        .accessibilityLabel("Agree to terms")
                        
                        // DISAGREE -> KILL APP
                        Button(action: {
                            print("User disagreed. Terminating app.")
                            exit(0)
                        }) {
                            Text("Disagree")
                                .font(.system(size: 17, weight: .regular))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                        }
                        .accessibilityLabel("Disagree, terminates app")
                    }
                }
                .padding(.horizontal, 32)
                .padding(.bottom, 40)
                .padding(.top, 24)
                .background(DesignSystem.backgroundPrimary)
            }
        }
    }
}
