import SwiftUI

struct ToolsMenuView: View {
    @State private var isAnimating = false

    var body: some View {
        ZStack(alignment: .top) {
            // MARK: - Ambient Background
            DesignSystem.backgroundPrimary
                .ignoresSafeArea()
            
            // Subtle Animated Mesh Gradient Simulation
            GeometryReader { proxy in
                ZStack {
                    Circle()
                        .fill(Color.purple.opacity(0.12))
                        .frame(width: 350, height: 350)
                        .blur(radius: 60)
                        .offset(x: isAnimating ? -50 : -150, y: isAnimating ? -50 : -150)
                    
                    Circle()
                        .fill(Color.indigo.opacity(0.12))
                        .frame(width: 300, height: 300)
                        .blur(radius: 60)
                        .offset(x: isAnimating ? 150 : 250, y: isAnimating ? 50 : 150)

                    Circle()
                        .fill(Color.blue.opacity(0.08))
                        .frame(width: 400, height: 400)
                        .blur(radius: 80)
                        .offset(x: isAnimating ? -100 : 100, y: isAnimating ? 300 : 400)
                }
                .frame(width: proxy.size.width, height: proxy.size.height)
                .onAppear {
                    withAnimation(.easeInOut(duration: 8.0).repeatForever(autoreverses: true)) {
                        isAnimating = true
                    }
                }
            }
            .ignoresSafeArea()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {

                    // MARK: - Header
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Tools", comment: "Section Title")
                            .font(.system(size: 42, weight: .bold))
                            .foregroundStyle(DesignSystem.textPrimary)
                            .tracking(-0.5)
                        
                        Text("Offline Survival Utilities", comment: "Section Subtitle")
                            .font(.system(size: 20, weight: .medium))
                            .foregroundStyle(DesignSystem.textSecondary)
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 16)

                    // MARK: - Tool Cards
                    VStack(spacing: 16) {
                        // MARK: - Priority: Emergency & Signaling
                        NavigationLink(destination: EmergencySirenView()) {
                            GlassToolCard(
                                icon: "speaker.wave.3.fill",
                                title: "Emergency Siren",
                                subtitle: "Max-volume distress signal",
                                color: .purple
                            )
                        }
                        .buttonStyle(ScalableButtonStyle())

                        NavigationLink(destination: SOSFlashlightView()) {
                            GlassToolCard(
                                icon: "flashlight.on.fill",
                                title: "SOS Flashlight",
                                subtitle: "Morse code SOS via camera flash",
                                color: .orange
                            )
                        }
                        .buttonStyle(ScalableButtonStyle())

                        // MARK: - Priority: Navigation
                        NavigationLink(destination: CompassView()) {
                            GlassToolCard(
                                icon: "location.north.circle.fill",
                                title: "Tactical Compass",
                                subtitle: "Magnetic heading & bearing lock",
                                color: .red
                            )
                        }
                        .buttonStyle(ScalableButtonStyle())

                        NavigationLink(destination: LocationView()) {
                            GlassToolCard(
                                icon: "location.fill",
                                title: "GPS Dashboard",
                                subtitle: "Coords, Altitude, Speed (Offline)",
                                color: .blue
                            )
                        }
                        .buttonStyle(ScalableButtonStyle())

                        NavigationLink(destination: WaypointsListView(locationManager: LocationManager())) {
                            GlassToolCard(
                                icon: "map.fill",
                                title: "Waypoints",
                                subtitle: "Save locations & navigate back",
                                color: .indigo
                            )
                        }
                        .buttonStyle(ScalableButtonStyle())
                        
                        // MARK: - Priority: Medical & Utility
                        NavigationLink(destination: CPRMetronomeView()) {
                            GlassToolCard(
                                icon: "heart.fill",
                                title: "CPR Metronome",
                                subtitle: "110 BPM chest compression pacer",
                                color: .red
                            )
                        }
                        .buttonStyle(ScalableButtonStyle())

                        NavigationLink(destination: InclinometerView()) {
                            GlassToolCard(
                                icon: "level.fill",
                                title: "Inclinometer",
                                subtitle: "Slope angle & bubble level",
                                color: .teal
                            )
                        }
                        .buttonStyle(ScalableButtonStyle())

                        NavigationLink(destination: SurvivalChartsView()) {
                            GlassToolCard(
                                icon: "chart.xyaxis.line",
                                title: "Survival Stats",
                                subtitle: "Hypothermia & Water Data",
                                color: .pink
                            )
                        }
                        .buttonStyle(ScalableButtonStyle())

                        NavigationLink(destination: GlossaryView()) {
                            GlassToolCard(
                                icon: "text.book.closed.fill",
                                title: "Survival Glossary",
                                subtitle: "Terminology & Definitions",
                                color: .brown
                            )
                        }
                        .buttonStyle(ScalableButtonStyle())

                        NavigationLink(destination: EmergencyDirectoryView()) {
                            GlassToolCard(
                                icon: "phone.circle.fill",
                                title: "Emergency Directory",
                                subtitle: "Global ambulance/police numbers",
                                color: .green
                            )
                        }
                        .buttonStyle(ScalableButtonStyle())

                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 40)
                }
            }
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Glass Tool Card Component
struct GlassToolCard: View {
    let icon: String
    let title: LocalizedStringKey
    let subtitle: LocalizedStringKey
    let color: Color

    var body: some View {
        ZStack(alignment: .leading) {
            // Glass Background - Clean, uncolored ultraThinMaterial
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .strokeBorder(Color.white.opacity(0.1), lineWidth: 0.5)
                )

            HStack(spacing: 16) {
                // Icon Box
                ZStack {
                    Circle()
                        .fill(color.opacity(0.12))
                        .frame(width: 44, height: 44)
                    
                    Image(systemName: icon)
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundStyle(color)
                }

                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.system(size: 17, weight: .semibold, design: .default))
                        .foregroundStyle(DesignSystem.textPrimary)
                        .minimumScaleFactor(0.85)
                    
                    Text(subtitle)
                        .font(.system(size: 13, weight: .medium))
                        .foregroundStyle(DesignSystem.textSecondary.opacity(0.8))
                        .lineLimit(1)
                        .minimumScaleFactor(0.9)
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(DesignSystem.textSecondary.opacity(0.4))
            }
            .padding(16)
        }
        .frame(minHeight: 80)
        .contentShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .shadow(color: Color.black.opacity(0.15), radius: 10, x: 0, y: 5)
        .accessibilityElement(children: .combine)
        .accessibilityAddTraits(.isButton)
    }
}
