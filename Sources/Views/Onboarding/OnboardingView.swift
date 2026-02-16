import SwiftUI

struct OnboardingView: View {
    @State private var currentPage = 0
    @ObservedObject var settings = SettingsService.shared
    
    var body: some View {
        ZStack {
            DesignSystem.backgroundPrimary.ignoresSafeArea()
            
            TabView(selection: $currentPage) {
                // Page 1: Offline First
                OnboardingPage(
                    imageName: "wifi.slash",
                    title: "Offline First",
                    description: "Revive works entirely without internet. Your lifeline, anywhere.",
                    color: .blue
                )
                .tag(0)
                
                // Page 2: Emergency Ready
                OnboardingPage(
                    imageName: "cross.case.fill",
                    title: "Emergency Ready",
                    description: "Instant access to triage guides, SOS signals, and medical tools.",
                    color: .red
                )
                .tag(1)
                
                // Page 3: Legal & Start
                TermsGateView(isOnboarding: true)
                .tag(2)
            }
            .tabViewStyle(.page(indexDisplayMode: .always))
            .indexViewStyle(.page(backgroundDisplayMode: .always))
        }
    }
}

struct OnboardingPage: View {
    let imageName: String
    let title: LocalizedStringKey
    let description: LocalizedStringKey
    let color: Color
    
    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            
            Image(systemName: imageName)
                .font(.system(size: 100))
                .foregroundStyle(color)
                .padding()
                .background(
                    Circle()
                        .fill(color.opacity(0.1))
                        .frame(width: 200, height: 200)
                )
                .shadow(color: color.opacity(0.3), radius: 20, x: 0, y: 10)
            
            VStack(spacing: 12) {
                Text(title)
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                    .foregroundStyle(DesignSystem.textPrimary)
                    .multilineTextAlignment(.center)
                
                Text(description)
                    .font(.body)
                    .foregroundStyle(DesignSystem.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }
            
            Spacer()
            Spacer()
        }
    }
}
