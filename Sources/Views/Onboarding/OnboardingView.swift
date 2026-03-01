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
                
                // Page 4: Voice / Accessibility (Temporarily Disabled)
                // OnboardingVoicePage(currentPage: $currentPage)
                //     .tag(3)
                
                // Page 4: Terms & Liability
                TermsGateView(isOnboarding: true)
                    .tag(3)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .animation(.spring(response: 0.6, dampingFraction: 0.8), value: currentPage)
            .sensoryFeedback(.selection, trigger: currentPage)
            
            // Sticky Bottom CTA
            if currentPage < 3 {
                VStack(spacing: 16) {
                    Button(action: {
                        if currentPage == 2 {
                            // SpeechRecognitionService.shared.requestAuthorization()
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                withAnimation { currentPage = 3 }
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
                    .accessibilityLabel(currentPage == 0 ? "Continue" : "Next page")
                    .accessibilityAddTraits(.isButton)
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 40)
                .transition(.move(edge: .bottom).combined(with: .opacity))
            }
            
            // Top-right Skip button (pages 1-2 only)
            if currentPage > 0 && currentPage < 3 {
                VStack {
                    HStack {
                        Spacer()
                        Button(action: {
                            withAnimation { currentPage = 3 }
                        }) {
                            Text("Skip")
                                .font(.system(size: 17))
                                .foregroundStyle(Color.gray)
                        }
                        .accessibilityLabel("Skip onboarding")
                        .padding(.trailing, 24)
                        .padding(.top, 16)
                    }
                    Spacer()
                }
            }
        }
    }
}

// MARK: - Page 1: Apple Welcome Standard
struct OnboardingWelcomePage: View {
    @State private var isVisible = false
    @Environment(\.accessibilityReduceMotion) var reduceMotion
    
    let features: [(icon: String, color: Color, title: String, desc: String)] = [
        ("arrow.triangle.branch", .blue, "Interactive Scenarios", "Answer critical questions in high-stress situations to instantly pinpoint the exact survival technique."),
        ("list.bullet.clipboard.fill", .orange, "Actionable Protocols", "Master hundreds of step-by-step, categorized techniques ranging from fire-starting to trauma triage."),
        ("wrench.and.screwdriver.fill", .teal, "Offline Arsenal", "Navigate the backcountry securely using an altimeter, true-north compass, and SOS distress siren.")
    ]
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                Spacer(minLength: 40)
                
                // Header (Apple Setup Assistant Style)
                Text("Welcome to\nRevive")
                    .font(.largeTitle.weight(.bold))
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .minimumScaleFactor(0.5)
                    .padding(.horizontal, 24)
                    .opacity(isVisible ? 1 : 0)
                    .offset(y: isVisible ? 0 : 20)
                    .animation(reduceMotion ? nil : .spring(response: 0.6, dampingFraction: 0.7).delay(0.1), value: isVisible)
                
                Spacer(minLength: 40)
                
                // Floating Feature List (Pure iOS Onboarding Pattern)
                VStack(alignment: .leading, spacing: 32) {
                    ForEach(0..<features.count, id: \.self) { index in
                        let feature = features[index]
                        
                        HStack(alignment: .center, spacing: 20) {
                            Image(systemName: feature.icon)
                                .font(.system(size: 32, weight: .regular))
                                .foregroundStyle(feature.color)
                                .frame(width: 44, alignment: .center)
                                .symbolEffect(.bounce, value: isVisible)
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text(feature.title)
                                    .font(.system(size: 17, weight: .semibold))
                                    .foregroundStyle(.white)
                                Text(feature.desc)
                                    .font(.subheadline)
                                    .foregroundStyle(.gray)
                                    .fixedSize(horizontal: false, vertical: true)
                                    .lineSpacing(4) // Increased line spacing for better readability
                            }
                        }
                        .padding(.vertical, 8) // Added padding between features
                        .opacity(isVisible ? 1 : 0)
                        .offset(x: isVisible ? 0 : 20)
                        // Stagger the animation timing based on index
                        .animation(reduceMotion ? nil : .spring(response: 0.6, dampingFraction: 0.7).delay(Double(index) * 0.15 + 0.2), value: isVisible)
                    }
                }
                .padding(.horizontal, 32)
                
                Spacer(minLength: 60)
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

// MARK: - Page 2: Survival Demo (Interactive Q&A)
struct OnboardingSurvivalDemoPage: View {
    @State private var step = 0
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
                Spacer(minLength: 20)
                
                // Header (Apple Setup Assistant Style)
                if step < 2 {
                    VStack(spacing: 12) {
                        Image(systemName: "tent.fill")
                            .font(.system(size: 46))
                            .foregroundStyle(.orange)
                            .symbolEffect(.bounce, value: step > 0)
                        
                        Text("Master Survival")
                            .font(.largeTitle.weight(.bold))
                            .foregroundStyle(.white)
                            .minimumScaleFactor(0.8)
                            .lineLimit(1)
                    }
                    .padding(.horizontal, 24)
                    .opacity(step > 0 ? 1 : 0)
                    .offset(y: step > 0 ? 0 : 20)
                    .transition(.move(edge: .top).combined(with: .opacity))
                }
                
                Spacer(minLength: 20)
                
                // Dynamic Q&A Flow Animation (Mimicking InventoryQuestionView)
                VStack(spacing: 24) {
                    
                    if step >= 2 {
                        // The Question Header (matches fire-root in ContentDatabase)
                        HStack {
                            Text("What fire-starting tools do you have?")
                                .font(.system(size: 28, weight: .bold))
                                .foregroundStyle(DesignSystem.textPrimary)
                                .fixedSize(horizontal: false, vertical: true)
                            Spacer()
                        }
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                    }
                    
                    if step >= 3 {
                        // Options Grid (real options from fire triage tree)
                        LazyVGrid(columns: [GridItem(.flexible(), spacing: 12), GridItem(.flexible(), spacing: 12)], spacing: 16) {
                            
                            MockTriageOptionCard(
                                icon: "xmark.circle.fill",
                                label: "Nothing — No Tools",
                                color: .red,
                                isSelected: false
                            )
                            
                            MockTriageOptionCard(
                                icon: "lightbulb.fill",
                                label: "Household Hacks",
                                color: .yellow,
                                isSelected: step >= 4
                            )
                        }
                        .transition(.scale.combined(with: .opacity))
                    }
                    
                    // The Final Recommendation (The "Lean-To" Card)
                    if step >= 5 {
                        VStack(spacing: 12) {
                            // Card header: label + toggles toolbar
                            HStack {
                                Text("Recommended Technique")
                                    .font(.caption)
                                    .foregroundStyle(.orange)
                                    .fontWeight(.bold)
                                Spacer()
                                
                                // Voice toggles toolbar (right-aligned, matching VerticalGuideView)
                                if step >= 6 {
                                    HStack(spacing: 8) {
                                        // Text-to-Speech
                                        HStack(spacing: 4) {
                                            Image(systemName: "speaker.wave.3.fill")
                                                .foregroundStyle(.orange)
                                                .font(.system(size: 13))
                                        }
                                        .padding(.horizontal, 10)
                                        .padding(.vertical, 6)
                                        .background(.ultraThinMaterial)
                                        .clipShape(Capsule())
                                        .transition(.scale.combined(with: .opacity))
                                        
                                        // Hands-Free
                                        if step >= 7 {
                                            HStack(spacing: 4) {
                                                Image(systemName: "mic.fill")
                                                    .foregroundStyle(.red)
                                                    .font(.system(size: 13))
                                                    .symbolEffect(.pulse.byLayer)
                                                
                                                Text("Listening")
                                                    .font(.system(size: 12, weight: .bold))
                                                    .foregroundStyle(.red)
                                            }
                                            .padding(.horizontal, 10)
                                            .padding(.vertical, 6)
                                            .background(.ultraThinMaterial)
                                            .clipShape(Capsule())
                                            .overlay(
                                                Capsule().strokeBorder(Color.red.opacity(0.5), lineWidth: 1)
                                            )
                                            .transition(.scale.combined(with: .opacity))
                                        }
                                    }
                                }
                            }
                            
                            // Technique content
                            HStack(spacing: 16) {
                                Circle()
                                    .fill(Color.orange.opacity(0.2))
                                    .frame(width: 44, height: 44)
                                    .overlay(
                                        Image(systemName: "bolt.fill")
                                            .foregroundStyle(.orange)
                                            .font(.title3)
                                    )
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Battery & Gum Wrapper Fire")
                                        .font(.body.weight(.bold))
                                        .foregroundStyle(.white)
                                    Text("Bridge a battery with foil to ignite a flame in seconds.")
                                        .font(.caption)
                                        .foregroundStyle(.gray)
                                        .fixedSize(horizontal: false, vertical: true)
                                }
                                Spacer()
                            }
                            
                            // Contextual voice caption
                            if step >= 7 {
                                Text("Hands full? Read steps aloud & go hands-free.")
                                    .font(.caption2)
                                    .foregroundStyle(.secondary)
                                    .transition(.opacity)
                            }
                        }
                        .padding(16)
                        .background(.ultraThinMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                        .overlay(
                            RoundedRectangle(cornerRadius: 20, style: .continuous)
                                .strokeBorder(LinearGradient(colors: [.orange.opacity(0.5), .white.opacity(0.0)], startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 1)
                        )
                        .shadow(color: Color.black.opacity(0.2), radius: 15, x: 0, y: 10)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                    }
                }
                .padding(.horizontal, 24)
                
                Spacer(minLength: 16)
            }
            .padding(.bottom, 140) // Clear safe area for sticky CTA
        }
        .onAppear {
            if reduceMotion {
                step = 7
            } else {
                // Sequence the dynamic Q&A animation
                withAnimation(.spring(response: 0.8, dampingFraction: 0.7).delay(0.1)) { step = 1 }
                withAnimation(.spring(response: 0.6, dampingFraction: 0.7).delay(0.7)) { step = 2 }
                withAnimation(.spring(response: 0.6, dampingFraction: 0.7).delay(1.5)) { step = 3 }
                withAnimation(.spring(response: 0.4, dampingFraction: 0.6).delay(2.5)) { step = 4 } // Simulate tap highlight
                withAnimation(.spring(response: 0.7, dampingFraction: 0.6).delay(3.2)) { step = 5 } // Show recommendation
                withAnimation(.spring(response: 0.5, dampingFraction: 0.7).delay(4.2)) { step = 6 } // Show Voice toggle
                withAnimation(.spring(response: 0.5, dampingFraction: 0.7).delay(4.8)) { step = 7 } // Show Hands-Free toggle
            }
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Master Survival. Answer critical questions to find the perfect solution, like building a Lean-To.")
    }
}

// Helper view to mimic TriageOptionCard from InventoryQuestionView
struct MockTriageOptionCard: View {
    let icon: String
    let label: String
    let color: Color
    var isSelected: Bool
    
    var body: some View {
        ZStack(alignment: .leading) {
            // Glass Background
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(isSelected ? AnyShapeStyle(color.opacity(0.15)) : AnyShapeStyle(.ultraThinMaterial))
                .overlay(
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .stroke(isSelected ? color : color.opacity(0.3), lineWidth: isSelected ? 2 : 1)
                )
            
            VStack(alignment: .leading, spacing: 12) {
                // Icon
                Image(systemName: icon)
                    .font(.system(size: 24))
                    .foregroundStyle(color)
                    .frame(width: 48, height: 48)
                    .background(color.opacity(0.1))
                    .clipShape(Circle())
                
                Spacer(minLength: 12)
                
                // Label
                Text(label)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(DesignSystem.textPrimary)
                    .multilineTextAlignment(.leading)
                    .fixedSize(horizontal: false, vertical: true)
                

            }
            .padding(16)
        }
        .frame(minHeight: 140, alignment: .topLeading)
        .shadow(color: isSelected ? color.opacity(0.2) : Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
        .scaleEffect(isSelected ? 0.95 : 1.0)
    }
}

// MARK: - Page 3: Arsenal Demo (Offline Tools)
struct OnboardingToolsDemoPage: View {
    @State private var isVisible = false
    @Environment(\.accessibilityReduceMotion) var reduceMotion
    
    let tools: [(name: String, icon: String, color: Color)] = [
        ("Offline Compass", "location.north.fill", .red),
        ("Emergency Siren", "speaker.wave.3.fill", .orange),
        ("GPS Coordinates", "mappin.and.ellipse", .blue),
        ("SOS Flashlight", "flashlight.on.fill", .yellow),
        ("CPR Metronome", "heart.fill", .pink),
        ("Gear Tracker", "briefcase.fill", .green)
    ]
    
    var body: some View {
        ZStack {
            // Background glow
            Circle()
                .fill(Color.blue.opacity(0.15))
                .blur(radius: 60)
                .frame(width: 250, height: 250)
                .offset(y: 50)
                
            VStack(spacing: 20) {
                Spacer(minLength: 40)
                
                
                // Header
                VStack(spacing: 12) {
                    Image(systemName: "antenna.radiowaves.left.and.right")
                        .font(.system(size: 46))
                        .foregroundStyle(.blue)
                        .symbolEffect(.bounce, value: isVisible)
                        
                    Text("Off The Grid")
                        .font(.largeTitle.weight(.bold))
                        .foregroundStyle(.white)
                        .minimumScaleFactor(0.8)
                        .lineLimit(1)
                }
                .padding(.horizontal, 24)
                .opacity(isVisible ? 1 : 0)
                .offset(y: isVisible ? 0 : 20)
                .padding(.top, 16)
                .padding(.bottom, 48)
                
                // Tool Grid (clean card style)
                LazyVGrid(columns: [GridItem(.flexible(), spacing: 16), GridItem(.flexible(), spacing: 16)], spacing: 16) {
                    ForEach(0..<tools.count, id: \.self) { index in
                        let tool = tools[index]
                        
                        ZStack(alignment: .topLeading) {
                            // Glassmorphic background with color tint
                            RoundedRectangle(cornerRadius: 20, style: .continuous)
                                .fill(.ultraThinMaterial)
                                .overlay(
                                    LinearGradient(
                                        colors: [
                                            tool.color.opacity(0.15),
                                            tool.color.opacity(0.02)
                                        ],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                            
                            VStack(alignment: .leading, spacing: 0) {
                                // Icon in circle
                                ZStack {
                                    Circle()
                                        .fill(tool.color.opacity(0.15))
                                        .frame(width: 48, height: 48)
                                    
                                    Image(systemName: tool.icon)
                                        .font(.system(size: 22, weight: .semibold))
                                        .foregroundStyle(tool.color)
                                        .symbolEffect(.bounce, value: isVisible)
                                }
                                
                                Spacer(minLength: 0)
                                
                                // Bold title at bottom
                                Text(tool.name)
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundStyle(DesignSystem.textPrimary)
                                    .lineLimit(2)
                                    .minimumScaleFactor(0.85)
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                            .padding(16)
                        }
                        .frame(height: 125)
                        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                        .overlay(
                            RoundedRectangle(cornerRadius: 20, style: .continuous)
                                .strokeBorder(tool.color.opacity(0.3), lineWidth: 1)
                        )
                        .shadow(color: Color.black.opacity(0.15), radius: 10, x: 0, y: 5)
                        .opacity(isVisible ? 1 : 0)
                        .scaleEffect(isVisible ? 1 : 0.95)
                        .animation(reduceMotion ? nil : .spring(response: 0.6, dampingFraction: 0.7).delay(Double(index) * 0.12 + 0.3), value: isVisible)
                    }
                }
                .padding(.horizontal, 24)
                
                Spacer()
                
                Text("100% functional without cellular service.")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .minimumScaleFactor(0.8)
                    .lineLimit(1)
                    .opacity(isVisible ? 1 : 0)
            }
            .padding(.bottom, 160)
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
