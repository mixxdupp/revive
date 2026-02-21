import SwiftUI
import CoreLocation

struct OnboardingView: View {
    @State private var currentPage = 0
    @ObservedObject var settings = SettingsService.shared
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ZStack(alignment: .bottom) {
            DesignSystem.backgroundPrimary.ignoresSafeArea()
            
            TabView(selection: $currentPage) {
                // Page 1: Apple Welcome Standard
                OnboardingWelcomePage()
                    .tag(0)
                
                // Page 2: Survival Demo
                OnboardingSurvivalDemoPage()
                    .tag(1)
                
                // Page 3: Tools Demo
                OnboardingToolsDemoPage()
                    .tag(2)
                
                // Page 4: Voice / Accessibility
                OnboardingVoicePage(currentPage: $currentPage)
                    .tag(3)
                
                // Page 5: Terms & Liability
                TermsGateView(isOnboarding: true)
                    .tag(4)
            }
            .tabViewStyle(.page(indexDisplayMode: .never)) // Hide default dots for a cleaner modern look
            .animation(.spring(response: 0.6, dampingFraction: 0.8), value: currentPage)
            .sensoryFeedback(.selection, trigger: currentPage)
            
            // Modern Apple Sticky Bottom CTA
            if currentPage < 4 {
                VStack(spacing: 16) {
                    // Custom Page Indicator
                    HStack(spacing: 8) {
                        ForEach(0..<4) { index in
                            Capsule()
                                .fill(currentPage == index ? Color.white : Color.gray.opacity(0.4))
                                .frame(width: currentPage == index ? 20 : 8, height: 8)
                                .animation(.spring(response: 0.4, dampingFraction: 0.7), value: currentPage)
                        }
                    }
                    .padding(.bottom, 8)
                    
                    Button(action: {
                        // If on Voice Page (3), request speech auth on continue tap, then proceed
                        if currentPage == 3 {
                            SpeechRecognitionService.shared.requestAuthorization()
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                withAnimation { currentPage = 4 }
                            }
                        } else {
                            withAnimation { currentPage += 1 }
                        }
                    }) {
                        Text(currentPage == 0 ? "Swipe to begin" : "Continue")
                            .font(.system(size: 18, weight: .bold))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(Color.white)
                            .foregroundStyle(Color.black)
                            .clipShape(Capsule())
                            .shadow(color: Color.white.opacity(0.15), radius: 10, x: 0, y: 5)
                            .contentTransition(.identity)
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel(currentPage == 0 ? "Start onboarding" : "Next page")
                    .accessibilityAddTraits(.isButton)
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 40)
                .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
    }
}

// MARK: - Page 1: Apple Welcome Standard
struct OnboardingWelcomePage: View {
    @State private var isVisible = false
    @Environment(\.accessibilityReduceMotion) var reduceMotion
    
    let features: [(icon: String, color: Color, title: String, desc: String)] = [
        ("cross.case.fill", .red, "Instant Triage", "Access step-by-step trauma protocols instantly, designed for high-stress bleeding control."),
        ("wrench.and.screwdriver.fill", .orange, "Offline Arsenal", "Turn your device into a true survival multi-tool with a compass, siren, and GPS."),
        ("briefcase.fill", .green, "Kit Readiness", "Build a medically accurate, scenario-linked survival kit to prepare before disaster strikes.")
    ]
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                Spacer(minLength: 40)
                
                // Header (Apple Setup Assistant Style)
                Text("Welcome to\nRevive")
                    .font(.system(size: 44, weight: .bold))
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .minimumScaleFactor(0.8)
                    .padding(.horizontal, 24)
                    .opacity(isVisible ? 1 : 0)
                    .offset(y: isVisible ? 0 : 20)
                
                Spacer(minLength: 60)
                
                // Floating Feature List (Pure iOS Onboarding Pattern)
                VStack(alignment: .leading, spacing: 40) {
                    ForEach(0..<features.count, id: \.self) { index in
                        let feature = features[index]
                        
                        HStack(alignment: .center, spacing: 24) {
                            Image(systemName: feature.icon)
                                .font(.system(size: 38, weight: .regular))
                                .foregroundStyle(feature.color.gradient)
                                .frame(width: 50, alignment: .center)
                                .symbolEffect(.bounce, value: isVisible)
                                .shadow(color: feature.color.opacity(0.4), radius: 10, x: 0, y: 5)
                            
                            VStack(alignment: .leading, spacing: 6) {
                                Text(feature.title)
                                    .font(.system(size: 17, weight: .bold))
                                    .foregroundStyle(.white)
                                Text(feature.desc)
                                    .font(.system(size: 15, weight: .regular))
                                    .foregroundStyle(.gray)
                                    .fixedSize(horizontal: false, vertical: true)
                                    .lineSpacing(3)
                            }
                        }
                        .opacity(isVisible ? 1 : 0)
                        .offset(x: isVisible ? 0 : 20)
                        // Stagger the animation timing based on index
                        .animation(reduceMotion ? nil : .spring(response: 0.6, dampingFraction: 0.7).delay(Double(index) * 0.15 + 0.3), value: isVisible)
                    }
                }
                .padding(.horizontal, 32)
                
                Spacer(minLength: 80)
            }
            .padding(.bottom, 160) // Clear the sticky bottom CTA
        }
        .onAppear {
            if reduceMotion {
                isVisible = true
            } else {
                withAnimation(.spring(response: 0.8, dampingFraction: 0.8)) {
                    isVisible = true
                }
            }
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Welcome to Revive. Instant Triage, Offline Arsenal, and Kit Readiness.")
    }
}

// MARK: - Page 2: Survival Demo (Glassmorphism Identity)
struct OnboardingSurvivalDemoPage: View {
    @State private var isVisible = false
    @Environment(\.accessibilityReduceMotion) var reduceMotion

    var body: some View {
        ZStack {
            // Background glow to make glassmorphism visible
            Circle()
                .fill(Color.orange.opacity(0.15))
                .blur(radius: 60)
                .frame(width: 250, height: 250)
                .offset(x: 50, y: 50)
            
            VStack(spacing: 24) {
                Spacer()
                
                // Header
                VStack(spacing: 8) {
                    Image(systemName: "tent.fill")
                        .font(.system(size: 46))
                        .foregroundStyle(.orange)
                        .symbolEffect(.bounce, value: isVisible)
                    
                    Text("Master Survival")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundStyle(.white)
                        .minimumScaleFactor(0.6)
                        .lineLimit(1)
                }
                .padding(.horizontal, 24)
                .opacity(isVisible ? 1 : 0)
                .offset(y: isVisible ? 0 : 20)
                
                Spacer()
                
                // Premium Glassmorphic Survival Card
                VStack(spacing: 20) {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Emergency Shelter")
                                .font(.headline)
                                .foregroundStyle(.white)
                            Text("Step 1 of 5")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        Spacer()
                        Image(systemName: "location.north.line.fill")
                            .foregroundStyle(.orange)
                            .symbolEffect(.pulse, options: .repeating, value: isVisible)
                    }
                    
                    Divider().background(Color.white.opacity(0.2))
                    
                    HStack(spacing: 16) {
                        Circle()
                            .fill(Color.orange.opacity(0.2))
                            .frame(width: 50, height: 50)
                            .overlay(
                                Image(systemName: "leaf.fill")
                                    .foregroundStyle(.orange)
                                    .font(.title3)
                            )
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Construct a Lean-To")
                                .font(.body.weight(.bold))
                                .foregroundStyle(.white)
                            Text("Find a sturdy ridgepole and rest it securely against a tree.")
                                .font(.subheadline)
                                .foregroundStyle(.gray)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                        Spacer()
                    }
                }
                .padding(24)
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: 24, style: .continuous)
                        .strokeBorder(LinearGradient(colors: [.white.opacity(0.4), .white.opacity(0.0)], startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 1)
                )
                .shadow(color: Color.black.opacity(0.3), radius: 20, x: 0, y: 10)
                .padding(.horizontal, 24)
                .opacity(isVisible ? 1 : 0)
                .scaleEffect(isVisible ? 1 : 0.95)
                .rotation3DEffect(.degrees(isVisible ? 0 : 5), axis: (x: 1, y: 0, z: 0))
                
                Spacer()
                
                Text("Instant, offline survival instructions.")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(.gray)
                    .opacity(isVisible ? 1 : 0)
            }
            .padding(.bottom, 160) // Clear safe area for sticky CTA
        }
        .onAppear {
            if reduceMotion {
                isVisible = true
            } else {
                withAnimation(.spring(response: 0.8, dampingFraction: 0.7).delay(0.2)) {
                    isVisible = true
                }
            }
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Master Survival. Instant, offline survival instructions.")
    }
}

// MARK: - Page 3: Arsenal Demo (Offline Tools)
struct OnboardingToolsDemoPage: View {
    @State private var isVisible = false
    @Environment(\.accessibilityReduceMotion) var reduceMotion
    
    let tools = [
        ("Offline Compass", "True-north navigation even deep in the backcountry without GPS.", "location.north.fill", Color.red),
        ("Emergency Siren", "120dB distress signal to instantly alert nearby rescue teams.", "speaker.wave.3.fill", Color.orange),
        ("Coordinates", "Pinpoint your exact latitude and longitude to relay to authorities.", "mappin.and.ellipse", Color.blue),
        ("Gear Tracker", "Inventory your essential kit to guarantee readiness before disaster.", "briefcase.fill", Color.green)
    ]
    
    var body: some View {
        ZStack {
            // Background glow to make glassmorphism pop
            Circle()
                .fill(Color.blue.opacity(0.15))
                .blur(radius: 60)
                .frame(width: 250, height: 250)
                .offset(y: 50)
                
            VStack(spacing: 24) {
                Spacer()
                
                // Header
                VStack(spacing: 8) {
                    Image(systemName: "antenna.radiowaves.left.and.right")
                        .font(.system(size: 46))
                        .foregroundStyle(.blue)
                        .symbolEffect(.bounce, value: isVisible)
                        
                    Text("Off The Grid")
                        .font(.system(size: 34, weight: .bold))
                        .foregroundStyle(.white)
                        .minimumScaleFactor(0.8)
                        .lineLimit(1)
                }
                .padding(.horizontal, 24)
                .opacity(isVisible ? 1 : 0)
                .offset(y: isVisible ? 0 : 20)
                
                Spacer()
                
                // Floating Feature List (Pure iOS Onboarding Pattern)
                VStack(alignment: .leading, spacing: 32) {
                    ForEach(0..<tools.count, id: \.self) { index in
                        let tool = tools[index]
                        
                        HStack(alignment: .center, spacing: 24) {
                            Image(systemName: tool.2)
                                .font(.system(size: 38, weight: .regular))
                                .foregroundStyle(tool.3.gradient)
                                .frame(width: 50, alignment: .center)
                                .symbolEffect(.bounce, value: isVisible)
                                .shadow(color: tool.3.opacity(0.4), radius: 10, x: 0, y: 5)
                            
                            VStack(alignment: .leading, spacing: 6) {
                                Text(tool.0)
                                    .font(.system(size: 17, weight: .bold))
                                    .foregroundStyle(.white)
                                Text(tool.1)
                                    .font(.system(size: 15, weight: .regular))
                                    .foregroundStyle(.gray)
                                    .fixedSize(horizontal: false, vertical: true)
                                    .lineSpacing(3)
                            }
                        }
                        .opacity(isVisible ? 1 : 0)
                        .offset(x: isVisible ? 0 : 20)
                        // Stagger the animation timing based on index
                        .animation(reduceMotion ? nil : .spring(response: 0.6, dampingFraction: 0.7).delay(Double(index) * 0.15 + 0.3), value: isVisible)
                    }
                }
                .padding(.horizontal, 32)
                
                Spacer()
                
                Text("100% functional without cellular service.")
                    .font(.system(size: 15, weight: .medium))
                    .foregroundStyle(.green)
                    .minimumScaleFactor(0.8)
                    .lineLimit(1)
                    .opacity(isVisible ? 1 : 0)
            }
            .padding(.bottom, 160) // Clear safe area for sticky CTA
        }
        .onAppear {
            if reduceMotion {
                isVisible = true
            } else {
                withAnimation(.spring(response: 0.8, dampingFraction: 0.7).delay(0.2)) {
                    isVisible = true
                }
            }
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Off the grid. Your phone is a survival multi-tool with compass, siren, coordinates, and gear tracking. 100 percent functional without cellular service.")
    }
}

// MARK: - Page 4: Voice / Accessibility
struct OnboardingVoicePage: View {
    @State private var isVisible = false
    @Environment(\.accessibilityReduceMotion) var reduceMotion
    @Binding var currentPage: Int
    
    var body: some View {
        ZStack {
            // Siri Blue Glow Background
            Circle()
                .fill(Color.blue.opacity(0.12))
                .blur(radius: 70)
                .frame(width: 300, height: 300)
            
            VStack(spacing: 32) {
                Spacer()
                
                // Glowing Waveform
                ZStack {
                    Circle()
                        .fill(Color.blue.opacity(0.1))
                        .frame(width: 160, height: 160)
                    
                    Circle()
                        .stroke(Color.blue.opacity(0.3), lineWidth: 2)
                        .frame(width: 140, height: 140)
                        .scaleEffect(isVisible ? 1.1 : 0.9)
                        .animation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true), value: isVisible)
                    
                    Image(systemName: "waveform")
                        .font(.system(size: 60))
                        .foregroundStyle(.blue)
                        .symbolEffect(.variableColor.iterative.dimInactiveLayers, options: .repeating, value: isVisible)
                }
                
                VStack(spacing: 12) {
                    Text("Hands Full?")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundStyle(.white)
                        .minimumScaleFactor(0.8)
                        .lineLimit(1)
                    
                    Text("When your hands are covered in mud, your voice is your lifeline.")
                        .font(.body)
                        .foregroundStyle(.gray)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 32)
                }
                .opacity(isVisible ? 1 : 0)
                .offset(y: isVisible ? 0 : 20)
                
                // Example Prompt Bubble
                HStack {
                    Image(systemName: "mic.fill")
                        .foregroundStyle(.blue)
                    Text("\"Hey Siri, ask Revive how to purify water\"")
                        .font(.system(size: 14, weight: .medium, design: .default))
                        .italic()
                        .foregroundStyle(.white)
                        .minimumScaleFactor(0.6)
                        .lineLimit(1)
                }
                .padding(.vertical, 16)
                .padding(.horizontal, 20)
                .background(.ultraThinMaterial)
                .clipShape(Capsule())
                .overlay(Capsule().strokeBorder(LinearGradient(colors: [.blue.opacity(0.5), .blue.opacity(0.0)], startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 1))
                .shadow(color: Color.blue.opacity(0.2), radius: 10, x: 0, y: 5)
                .padding(.horizontal, 24)
                .opacity(isVisible ? 1 : 0)
                .scaleEffect(isVisible ? 1 : 0.9)
                
                Spacer()
                
                Text("Powered by App Intents & Siri")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(.secondary)
                    .opacity(isVisible ? 1 : 0)
            }
            .padding(.bottom, 160) // Clear safe area for sticky CTA
        }
        .onAppear {
            if reduceMotion {
                isVisible = true
            } else {
                withAnimation(.spring(response: 0.8, dampingFraction: 0.7).delay(0.2)) {
                    isVisible = true
                }
            }
            // Note: Speech recognition occurs on the CTA tap, managed globally in the parent view.
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Hands Full? Voice control enabled for when you cannot touch your phone. Powered by Siri.")
    }
}
