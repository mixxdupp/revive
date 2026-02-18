import SwiftUI
import CoreLocation

struct OnboardingView: View {
    @State private var currentPage = 0
    @ObservedObject var settings = SettingsService.shared
    
    var body: some View {
        ZStack {
            DesignSystem.backgroundPrimary.ignoresSafeArea()
            
            TabView(selection: $currentPage) {
                // Page 1: Impact / Hook
                OnboardingImpactPage()
                    .tag(0)
                
                // Page 2: Triage Demo
                OnboardingTriageDemoPage()
                    .tag(1)
                
                // Page 3: Tools Demo
                OnboardingToolsDemoPage()
                    .tag(2)
                
                // Page 4: Voice / Accessibility
                OnboardingVoicePage()
                    .tag(3)
                
                // Page 5: Terms & Liability
                TermsGateView(isOnboarding: true)
                    .tag(4)
            }
            .tabViewStyle(.page(indexDisplayMode: .always))
            .indexViewStyle(.page(backgroundDisplayMode: .always))
            .animation(.easeInOut, value: currentPage)
        }
    }
}

// MARK: - Page 1: Impact
struct OnboardingImpactPage: View {
    @State private var showText1 = false
    @State private var showText2 = false
    @State private var showText3 = false
    @Environment(\.accessibilityReduceMotion) var reduceMotion
    
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
            if showText1 {
                Text("NO SIGNAL.")
                    .font(.system(size: 40, weight: .black))
                    .foregroundStyle(.white)
                    .transition(.opacity.combined(with: .scale))
            }
            
            if showText2 {
                Text("NO HELP.")
                    .font(.system(size: 40, weight: .black))
                    .foregroundStyle(.red)
                    .transition(.opacity.combined(with: .scale))
            }
            
            if showText3 {
                Text("JUST YOU.")
                    .font(.system(size: 40, weight: .black))
                    .foregroundStyle(.white)
                    .transition(.opacity.combined(with: .scale))
            }
            
            Spacer()
            
            if showText3 {
                Text("Swipe to survive →")
                    .font(.subheadline)
                    .foregroundStyle(.gray)
                    .padding(.bottom, 50)
            }
        }
        .onAppear {
            if reduceMotion {
                // Instant show for accessibility
                showText1 = true
                showText2 = true
                showText3 = true
            } else {
                withAnimation(.easeIn(duration: 0.8).delay(0.5)) { showText1 = true }
                withAnimation(.easeIn(duration: 0.8).delay(1.5)) { showText2 = true }
                withAnimation(.easeIn(duration: 0.8).delay(2.5)) { showText3 = true }
            }
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("No Signal. No Help. Just You. Swipe to survive.")
    }
}

// MARK: - Page 2: Triage Demo
struct OnboardingTriageDemoPage: View {
    @State private var step = 0
    @Environment(\.accessibilityReduceMotion) var reduceMotion

    var body: some View {
        VStack(spacing: 20) {
            Text("Medical Emergency?")
                .font(.title.weight(.bold))
                .padding(.top, 60)
            
            Spacer()
            
            // Simulated Triage Card
            ZStack {
                if step == 0 {
                    TriageCard(title: "What is the emergency?", options: ["I'm Hurt", "Sickness", "Environment"]) {
                        if reduceMotion { step = 1 } else { withAnimation { step = 1 } }
                    }
                    .transition(.move(edge: .leading))
                } else if step == 1 {
                    TriageCard(title: "Where is the injury?", options: ["Head / Neck", "Arms / Legs", "Torso"]) {
                        if reduceMotion { step = 2 } else { withAnimation { step = 2 } }
                    }
                    .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
                } else {
                    VStack(spacing: 20) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 80))
                            .foregroundStyle(.green)
                        Text("Protocol Found")
                            .font(.title2.weight(.bold))
                        Text("Apply Pressure. Elevate.")
                            .font(.body)
                    }
                    .transition(.scale)
                }
            }
            .frame(height: 300)
            
            Spacer()
            
            Text("Interactive Triage Guides")
                .font(.headline)
                .foregroundStyle(.gray)
                .padding(.bottom, 50)
        }
        .accessibilityElement(children: .contain)
    }
}

struct TriageCard: View {
    let title: String
    let options: [String]
    let action: () -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            Text(title)
                .font(.headline)
            
            ForEach(options, id: \.self) { option in
                Button(action: action) {
                    HStack {
                        Text(option)
                        Spacer()
                        Image(systemName: "chevron.right")
                    }
                    .padding()
                    .background(Color.white.opacity(0.1))
                    .cornerRadius(12)
                }
            }
        }
        .padding()
        .background(Color.black.opacity(0.5))
        .cornerRadius(20)
        .padding(.horizontal)
    }
}

// MARK: - Page 3: Tools Demo
struct OnboardingToolsDemoPage: View {
    @State private var rotation = 0.0
    @Environment(\.accessibilityReduceMotion) var reduceMotion
    
    var body: some View {
        VStack {
            Text("Lost?")
                .font(.title.weight(.bold))
                .padding(.top, 60)
            
            Spacer()
            
            ZStack {
                Circle()
                    .stroke(Color.gray.opacity(0.3), lineWidth: 2)
                    .frame(width: 250, height: 250)
                
                Image(systemName: "location.north.fill")
                    .font(.system(size: 80))
                    .foregroundStyle(.red)
                    .rotationEffect(.degrees(rotation))
                
                VStack {
                    Text("N")
                        .font(.title)
                        .offset(y: -140)
                    Spacer()
                }
            }
            .frame(height: 300)
            .onAppear {
                if !reduceMotion {
                    withAnimation(.linear(duration: 10).repeatForever(autoreverses: false)) {
                        rotation = 360
                    }
                }
            }
            .accessibilityElement(children: .combine)
            .accessibilityLabel("Compass demo showing north direction.")
            
            Spacer()
            
            Text("Offline GPS & Compass")
                .font(.headline)
                .foregroundStyle(.gray)
                .padding(.bottom, 50)
        }
    }
}

// MARK: - Page 4: Voice / Accessibility
struct OnboardingVoicePage: View {
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
            Image(systemName: "waveform")
                .font(.system(size: 100))
                .foregroundStyle(.blue)
                .symbolEffect(.variableColor.iterative.dimInactiveLayers)
            
            Text("Hands Full?")
                .font(.title.weight(.bold))
            
            Text("\"Hey Revive... how do I treat a burn?\"")
                .font(.body)
                .italic()
                .foregroundStyle(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Spacer()
            
            Text("Fully Accessible")
                .font(.headline)
                .foregroundStyle(.gray)
                .padding(.bottom, 50)
        }
    }
}
