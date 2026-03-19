import SwiftUI

struct TermsGateView: View {
    @ObservedObject var settings = SettingsService.shared
    var isOnboarding: Bool = false
    
    var body: some View {
        ZStack {
            DesignSystem.backgroundPrimary.ignoresSafeArea()
            
            VStack(spacing: 0) {
                ScrollView {
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
                            // Simpler header for onboarding (Apple Setup Assistant Style)
                            VStack(alignment: .center, spacing: 16) {
                                Image(systemName: "shield.fill")
                                    .font(.system(size: 60))
                                    .foregroundStyle(.blue.gradient)
                                
                                Text("Terms & Conditions")
                                     .font(.system(size: 34, weight: .bold))
                                     .foregroundStyle(DesignSystem.textPrimary)
                                     .multilineTextAlignment(.center)
                            }
                            .padding(.top, 40)
                            .padding(.bottom, 16)
                        }
                        
                        // Scrollable Legalese
                        VStack(alignment: .leading, spacing: 24) {
                        Group {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("1. NO MEDICAL ADVICE\n(INFORMATIONAL ONLY)")
                                    .font(.headline)
                                    .foregroundStyle(Color.red)
                                    .lineSpacing(2)
                                Text("The content of this app is for educational and reference purposes only. It is NOT a substitute for professional medical advice, diagnosis, or treatment. NEVER disregard professional medical advice or delay seeking it because of something you have read in this app. ALWAYS CALL YOUR LOCAL EMERGENCY SERVICES IN A MEDICAL EMERGENCY.")
                            }
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text("2. COMPLETE WAIVER OF LIABILITY")
                                    .font(.headline)
                                    .foregroundStyle(Color.red)
                                Text("By using this app, you AUTOMATICALLY AND COMPLETELY WAIVE ANY AND ALL RIGHTS TO HOLD THE DEVELOPERS, CREATORS, OR CONTRIBUTORS LIABLE for any injury, loss, property damage, or death resulting from the use or misuse of the information provided herein. YOU USE THIS APP ENTIRELY AT YOUR OWN RISK.")
                            }
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text("3. ASSUMPTION OF RISK & NO WARRANTY")
                                    .font(.headline)
                                    .foregroundStyle(DesignSystem.textPrimary)
                                Text("Survival and medical emergencies are inherently dangerous. The developers make NO WARRANTIES, express or implied, regarding the accuracy, completeness, or effectiveness of the information provided. The app is provided 'AS IS'.")
                            }
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text("4. OFFLINE USE & PRIVACY")
                                    .font(.headline)
                                    .foregroundStyle(DesignSystem.textPrimary)
                                Text("This app is designed to function offline. Location services are processed entirely on-device for the Compass/GPS tools. Revive does not collect, transmit, or store personal data.")
                            }
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text("5. APPLE INC. DISCLAIMER")
                                    .font(.headline)
                                    .foregroundStyle(DesignSystem.textPrimary)
                                Text("You acknowledge that this agreement is concluded between you and the Developer only, and not with Apple Inc. ('Apple'). Apple is not responsible for the App or the content thereof, nor does Apple provide any medical or survival warranties regarding the App's use.")
                            }
                        }
                        .font(.system(size: 15, weight: .regular))
                        .foregroundStyle(DesignSystem.textPrimary) // Made whiter for readability per screenshot
                        .lineSpacing(4)
                        
                        Text("Last Updated: February 2026")
                            .font(.system(size: 13, weight: .medium))
                            .foregroundStyle(Color.gray.opacity(0.8))
                            .padding(.top, 16)
                    }
                    .padding(.horizontal, 32)
                    .padding(.vertical, 8)
                }
                }
                // Removed custom container constraints to allow native iOS edge-to-edge scrolling
                
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
