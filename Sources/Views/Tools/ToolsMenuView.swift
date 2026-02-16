import SwiftUI

struct ToolsMenuView: View {
    var body: some View {
        ZStack {
            // MARK: - Ambient Background
            DesignSystem.backgroundPrimary
                .ignoresSafeArea()
            
            // Subtle Mesh Gradient Simulation
            GeometryReader { proxy in
                ZStack {
                    Circle()
                        .fill(Color.purple.opacity(0.1))
                        .frame(width: 300, height: 300)
                        .blur(radius: 60)
                        .offset(x: -100, y: -100)
                    
                    Circle()
                        .fill(Color.indigo.opacity(0.1))
                        .frame(width: 300, height: 300)
                        .blur(radius: 60)
                        .offset(x: 200, y: 100)
                }
                .frame(width: proxy.size.width, height: proxy.size.height)
            }
            .ignoresSafeArea()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 32) {

                    // MARK: - Banner
                    EmergencyBanner()
                        .padding(.horizontal, 24)
                        .padding(.top, 16) // Top Spacing

                    // MARK: - Header
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Tools", comment: "Section Title")
                            .font(.system(size: 42, weight: .black, design: .serif))
                            .foregroundStyle(DesignSystem.textPrimary)
                            .tracking(-0.5)
                        
                        Text("Offline Survival Utilities", comment: "Section Subtitle")
                            .font(.system(size: 20, weight: .medium, design: .serif))
                            .foregroundStyle(DesignSystem.textSecondary)
                    }
                    .padding(.horizontal, 24)

                    // MARK: - Tool Cards
                    VStack(spacing: 16) {
                        // MARK: - Hardware Tools
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

                        NavigationLink(destination: EmergencyDirectoryView()) {
                            GlassToolCard(
                                icon: "phone.circle.fill",
                                title: "Emergency Directory",
                                subtitle: "Global ambulance/police numbers",
                                color: .green
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

                        NavigationLink(destination: CPRMetronomeView()) {
                            GlassToolCard(
                                icon: "heart.fill",
                                title: "CPR Metronome",
                                subtitle: "110 BPM chest compression pacer",
                                color: .red
                            )
                        }
                        .buttonStyle(ScalableButtonStyle())

                        NavigationLink(destination: EmergencySirenView()) {
                            GlassToolCard(
                                icon: "speaker.wave.3.fill",
                                title: "Emergency Siren",
                                subtitle: "Max-volume distress signal",
                                color: .purple
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
            // Glass Background
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(.ultraThinMaterial)
                .overlay(
                    LinearGradient(
                        colors: [
                            color.opacity(0.1),
                            color.opacity(0.02)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 24, style: .continuous)
                        .stroke(color.opacity(0.2), lineWidth: 1)
                )

            HStack(spacing: 16) {
                // Icon Box
                ZStack {
                    Circle()
                        .fill(color.opacity(0.15))
                        .frame(width: 56, height: 56)
                    
                    Image(systemName: icon)
                        .font(.system(size: 26))
                        .foregroundStyle(color)
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                        .foregroundStyle(DesignSystem.textPrimary)
                        .minimumScaleFactor(0.8)
                    
                    Text(subtitle)
                        .font(.subheadline)
                        .foregroundStyle(DesignSystem.textSecondary)
                        .lineLimit(1)
                        .minimumScaleFactor(0.9)
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundStyle(DesignSystem.textSecondary.opacity(0.5))
            }
            .padding(20)
        }
        .frame(minHeight: 96)
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
        .accessibilityElement(children: .combine)
        .accessibilityAddTraits(.isButton)
    }
}
