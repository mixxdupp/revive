import SwiftUI

struct HomeView: View {
    // Dynamic Greeting
    private var dateString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMMM d"
        return formatter.string(from: Date()).uppercased()
    }
    
    // Adaptive Grid Layout (2 cols on iPhone, more on iPad)
    private let columns = [
        GridItem(.adaptive(minimum: 160), spacing: 16)
    ]
    
    @State private var showSettings = false
    @State private var showContent = false
    @Environment(\.accessibilityReduceMotion) var reduceMotion
    
    var body: some View {
        // No NavigationStack here (managed by ContentView / NavigationSplitView)
        ZStack {
            Color(uiColor: .systemGroupedBackground)
                .edgesIgnoringSafeArea(.all)
            
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 24) {
                    
                    VStack(alignment: .leading, spacing: 6) {
                        Text(dateString)
                            .font(.system(size: 14, weight: .bold))
                            .foregroundStyle(.secondary)
                            .tracking(1.0)
                            .textCase(.uppercase)
                        
                        Text("Revive", comment: "App Name")
                            .font(.largeTitle.weight(.bold))
                            .foregroundStyle(.primary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    .accessibilityElement(children: .combine)
                    .accessibilityLabel("Revive, \(dateString)")
                    
                    EmergencyWarningBanner()
                    
                    NavigationLink(destination: EmergencyMenuView()) {
                        HStack(alignment: .top) {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Emergency \nGuide", comment: "Hero Card Title")
                                    .font(.system(size: 32, weight: .bold))
                                    .foregroundStyle(.white)
                                    .multilineTextAlignment(.leading)
                                    .tracking(-0.5)
                                
                                Text("Start Decision Engine", comment: "Hero Card Subtitle")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundStyle(.white.opacity(0.85))
                            }
                            Spacer()
                            
                            Image(systemName: "exclamationmark.triangle.fill")
                                .font(.largeTitle)
                                    .foregroundStyle(.red)
                                    .padding(12)
                                    .background(.white)
                                    .clipShape(Circle())
                                    .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
                        }
                        .padding(24)
                        .frame(maxWidth: .infinity, minHeight: 140, alignment: .topLeading)
                        .background(
                            LinearGradient(
                                colors: [Color.red, Color(red: 0.8, green: 0.1, blue: 0.1)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
                        .shadow(color: Color.red.opacity(0.25), radius: 12, x: 0, y: 6)
                    }
                    .padding(.horizontal, 20)
                    .buttonStyle(ScalableButtonStyle())
                    .accessibilityLabel("Emergency Guide, Start Decision Engine")
                    .accessibilityAddTraits(.isButton)
                    
                    LazyVGrid(columns: columns, spacing: 16) {
                        NavigationLink(destination: GuideMainView()) {
                            FeatureCard(title: "Library", subtitle: "Survival Guide", icon: "book.fill", iconColor: .blue)
                        }
                        .buttonStyle(ScalableButtonStyle())
                        .offset(y: showContent ? 0 : 20)
                        .opacity(showContent ? 1 : 0)
                        
                        NavigationLink(destination: ToolsMenuView()) {
                            FeatureCard(title: "Tools", subtitle: "Utilities", icon: "wrench.and.screwdriver.fill", iconColor: .indigo)
                        }
                        .buttonStyle(ScalableButtonStyle())
                        .offset(y: showContent ? 0 : 20)
                        .opacity(showContent ? 1 : 0)
                        .animation(reduceMotion ? nil : .easeOut(duration: 0.5).delay(0.1), value: showContent)
                        
                        NavigationLink(destination: KitBuilderView()) {
                            FeatureCard(title: "Readiness", subtitle: "Gear Tracker", icon: "cross.case.fill", iconColor: .green)
                        }
                        .buttonStyle(ScalableButtonStyle())
                        .offset(y: showContent ? 0 : 20)
                        .opacity(showContent ? 1 : 0)
                        .animation(reduceMotion ? nil : .easeOut(duration: 0.5).delay(0.2), value: showContent)
                        
                        NavigationLink(destination: EmergencyDirectoryView()) {
                            FeatureCard(title: "Directory", subtitle: "Global Numbers", icon: "globe", iconColor: .orange)
                        }
                        .buttonStyle(ScalableButtonStyle())
                        .offset(y: showContent ? 0 : 20)
                        .opacity(showContent ? 1 : 0)
                        .animation(reduceMotion ? nil : .easeOut(duration: 0.5).delay(0.3), value: showContent)
                    }
                    .padding(.horizontal, 20)
                    
                    Button(action: {
                        NotificationCenter.default.post(name: .triggerPanic, object: nil)
                    }) {
                        HStack(spacing: 8) {
                            Image(systemName: "light.beacon.max.fill")
                                .font(.headline)
                            Text("Panic Siren")
                                .font(.headline.weight(.semibold))
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(.ultraThinMaterial)
                        .background(Color.red.opacity(0.08))
                        .foregroundStyle(.red)
                        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                        .overlay(
                            RoundedRectangle(cornerRadius: 16, style: .continuous)
                                .strokeBorder(Color.red.opacity(0.2), lineWidth: 1)
                        )
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
                    .padding(.bottom, 40)
                    .accessibilityLabel("Panic Siren, activates loud alarm and strobe")
                    .accessibilityAddTraits(.isButton)
                    .offset(y: showContent ? 0 : 20)
                    .opacity(showContent ? 1 : 0)
                    .animation(reduceMotion ? nil : .easeOut(duration: 0.5).delay(0.4), value: showContent)
                }
            }
            .onAppear {
                if reduceMotion {
                    showContent = true
                } else {
                    withAnimation(.easeOut(duration: 0.6)) {
                        showContent = true
                    }
                }
            }
            
            // Settings Button Overlay
            VStack {
                HStack {
                    Spacer()
                    Button(action: { showSettings = true }) {
                        Image(systemName: "gearshape.fill")
                            .font(.title3.weight(.semibold))
                            .foregroundStyle(.secondary)
                            .padding(10)
                            .background(.thinMaterial)
                            .clipShape(Circle())
                    }
                    .padding(.trailing, 20)
                    .padding(.top, 10)
                    .accessibilityLabel("Settings")
                    .accessibilityAddTraits(.isButton)
                }
                Spacer()
            }
        }
        .sheet(isPresented: $showSettings) {
            SettingsView()
        }
    }
}

struct FeatureCard: View {
    let title: LocalizedStringKey
    let subtitle: LocalizedStringKey
    let icon: String
    let iconColor: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(iconColor)
                .padding(10)
                .background(iconColor.opacity(0.1))
                .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(.primary)
                    .minimumScaleFactor(0.8)
                
                Text(subtitle)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(.secondary)
                    .minimumScaleFactor(0.8)
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .frame(minHeight: 140)
        .background(Color(uiColor: .secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(title), \(subtitle)")
        .accessibilityAddTraits(.isButton)
    }
}
