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
                    // Custom Page Indicator (Hidden on Welcome Page)
                    if currentPage > 0 {
                        HStack(spacing: 8) {
                            ForEach(0..<4) { index in
                                Capsule()
                                    .fill(currentPage == index ? Color.white : Color.gray.opacity(0.4))
                                    .frame(width: currentPage == index ? 20 : 8, height: 8)
                                    .animation(.spring(response: 0.4, dampingFraction: 0.7), value: currentPage)
                            }
                        }
                        .padding(.bottom, 8)
                    }
                    
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
                    .accessibilityLabel(currentPage == 0 ? "Continue" : "Next page")
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
                    .minimumScaleFactor(0.8)
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
                        // The Question Header
                        HStack {
                            Text("What is your environment?")
                                .font(.system(size: 28, weight: .bold))
                                .foregroundStyle(DesignSystem.textPrimary)
                                .fixedSize(horizontal: false, vertical: true)
                            Spacer()
                        }
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                    }
                    
                    if step >= 3 {
                        // Options Grid (Simulated)
                        LazyVGrid(columns: [GridItem(.flexible(), spacing: 12), GridItem(.flexible(), spacing: 12)], spacing: 16) {
                            
                            MockTriageOptionCard(
                                icon: "thermometer.snowflake",
                                label: "Sub-Zero",
                                color: .cyan,
                                isSelected: false
                            )
                            
                            MockTriageOptionCard(
                                icon: "leaf.fill",
                                label: "Dense Forest",
                                color: .green,
                                isSelected: step >= 4 // Highlights on step 4
                            )
                        }
                        .transition(.scale.combined(with: .opacity))
                    }
                    
                    // The Final Recommendation (The "Lean-To" Card)
                    if step >= 5 {
                        VStack(spacing: 16) {
                            HStack {
                                Text("Recommended Technique")
                                    .font(.caption)
                                    .foregroundStyle(.orange)
                                    .fontWeight(.bold)
                                    .textCase(.uppercase)
                                Spacer()
                            }
                            
                            HStack(spacing: 16) {
                                Circle()
                                    .fill(Color.orange.opacity(0.2))
                                    .frame(width: 44, height: 44)
                                    .overlay(
                                        Image(systemName: "tent.fill")
                                            .foregroundStyle(.orange)
                                            .font(.title3)
                                    )
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Construct a Lean-To")
                                        .font(.body.weight(.bold))
                                        .foregroundStyle(.white)
                                    Text("Find a sturdy ridgepole and rest it securely against a tree.")
                                        .font(.caption)
                                        .foregroundStyle(.gray)
                                        .fixedSize(horizontal: false, vertical: true)
                                }
                                Spacer()
                            }
                        }
                        .padding(20)
                        .background(.ultraThinMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                        .overlay(
                            RoundedRectangle(cornerRadius: 20, style: .continuous)
                                .strokeBorder(LinearGradient(colors: [.orange.opacity(0.5), .white.opacity(0.0)], startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 1)
                        )
                        .shadow(color: Color.black.opacity(0.2), radius: 15, x: 0, y: 10)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                    }
                    
                    if step >= 6 {
                        VStack(spacing: 10) {
                            // The Toggles Row mimicking VerticalGuideView header
                            HStack(spacing: 12) {
                                Spacer()
                                
                                // Text-to-Speech Mock
                                HStack(spacing: 6) {
                                    Image(systemName: "speaker.wave.3.fill")
                                        .foregroundStyle(.orange)
                                        .font(.system(size: 16))
                                }
                                .padding(.horizontal, 14)
                                .padding(.vertical, 10)
                                .background(.ultraThinMaterial)
                                .clipShape(Capsule())
                                .transition(.scale.combined(with: .opacity))
                                
                                // Hands-Free Trigger Mock
                                if step >= 7 {
                                    HStack(spacing: 6) {
                                        Image(systemName: "mic.fill")
                                            .foregroundStyle(.red)
                                            .font(.system(size: 16))
                                            .symbolEffect(.pulse.byLayer)
                                        
                                        Text("Listening")
                                            .font(.system(size: 14, weight: .bold))
                                            .foregroundStyle(.red)
                                    }
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 10)
                                    .background(.ultraThinMaterial)
                                    .clipShape(Capsule())
                                    .overlay(
                                        Capsule().strokeBorder(Color.red.opacity(0.5), lineWidth: 1.5)
                                    )
                                    .transition(.scale.combined(with: .opacity))
                                }
                                
                                Spacer()
                            }
                            
                            // Contextual caption
                            Text("Hands full? Read steps aloud & go hands-free with voice.")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                                .multilineTextAlignment(.center)
                                .transition(.opacity)
                        }
                        .padding(.top, 8)
                    }
                }
                .padding(.horizontal, 24)
                
                Spacer(minLength: 40)
            }
            .padding(.bottom, 160) // Clear safe area for sticky CTA
        }
        .onAppear {
            if reduceMotion {
                step = 5
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
                
                // Leaf indicator
                HStack {
                    Spacer()
                    Image(systemName: "arrow.right")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundStyle(color.opacity(0.6))
                }
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
                
                Spacer()
                
                // Premium Glassmorphic Tool Grid
                LazyVGrid(columns: [GridItem(.flexible(), spacing: 16), GridItem(.flexible(), spacing: 16)], spacing: 16) {
                    ForEach(0..<tools.count, id: \.self) { index in
                        let tool = tools[index]
                        
                        VStack(alignment: .leading, spacing: 12) {
                            Image(systemName: tool.2)
                                .font(.system(size: 28))
                                .foregroundStyle(tool.3)
                                .frame(width: 48, height: 48)
                                .background(tool.3.opacity(0.15))
                                .clipShape(Circle())
                                .symbolEffect(.bounce, value: isVisible)
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text(tool.0)
                                    .font(.system(size: 15, weight: .bold))
                                    .foregroundStyle(.white)
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.8)
                                
                                Text(tool.1)
                                    .font(.system(size: 13))
                                    .foregroundStyle(.gray)
                                    .fixedSize(horizontal: false, vertical: true)
                                    .lineSpacing(2)
                            }
                        }
                        .padding(16)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                        .background(.ultraThinMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                        .overlay(
                            RoundedRectangle(cornerRadius: 20, style: .continuous)
                                .strokeBorder(LinearGradient(colors: [tool.3.opacity(0.4), .clear], startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 1)
                        )
                        .shadow(color: Color.black.opacity(0.15), radius: 10, x: 0, y: 5)
                        .opacity(isVisible ? 1 : 0)
                        .scaleEffect(isVisible ? 1 : 0.95)
                        // Stagger the animation timing based on index
                        .animation(reduceMotion ? nil : .spring(response: 0.6, dampingFraction: 0.7).delay(Double(index) * 0.15 + 0.3), value: isVisible)
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
