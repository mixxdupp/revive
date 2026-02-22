import SwiftUI

struct ToolsMenuView: View {
    var body: some View {
        ZStack(alignment: .top) {
            DesignSystem.backgroundPrimary
                .ignoresSafeArea()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    
                    // MARK: - Subtitle
                    Text("Offline Survival Utilities", comment: "Section Subtitle")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundStyle(DesignSystem.textSecondary)
                        .padding(.horizontal, 16)

                    // MARK: - Widget Dashboard Grid
                    LazyVGrid(columns: [GridItem(.flexible(), spacing: 16), GridItem(.flexible(), spacing: 16)], spacing: 16) {
                        
                        // MARK: - Priority: Emergency & Signaling
                        NavigationLink(destination: EmergencySirenView()) {
                            GlassWidgetSquare(
                                icon: "speaker.wave.3.fill",
                                title: "Emergency Siren",
                                subtitle: "Max-volume signal",
                                color: .purple
                            )
                        }
                        .buttonStyle(ScalableButtonStyle())

                        NavigationLink(destination: SOSFlashlightView()) {
                            GlassWidgetSquare(
                                icon: "flashlight.on.fill",
                                title: "SOS Flashlight",
                                subtitle: "Morse code strobe",
                                color: .orange
                            )
                        }
                        .buttonStyle(ScalableButtonStyle())

                        // MARK: - Priority: Navigation
                        NavigationLink(destination: CompassView()) {
                            GlassWidgetSquare(
                                icon: "location.north.circle.fill",
                                title: "Tactical Compass",
                                subtitle: "Magnetic heading",
                                color: .red
                            )
                        }
                        .buttonStyle(ScalableButtonStyle())

                        NavigationLink(destination: LocationView()) {
                            GlassWidgetSquare(
                                icon: "location.fill",
                                title: "GPS Dashboard",
                                subtitle: "Offline mapping",
                                color: .blue
                            )
                        }
                        .buttonStyle(ScalableButtonStyle())

                        NavigationLink(destination: WaypointsListView(locationManager: LocationManager())) {
                            GlassWidgetSquare(
                                icon: "map.fill",
                                title: "Waypoints",
                                subtitle: "Save locations",
                                color: .indigo
                            )
                        }
                        .buttonStyle(ScalableButtonStyle())
                        
                        // MARK: - Priority: Medical & Utility
                        NavigationLink(destination: CPRMetronomeView()) {
                            GlassWidgetSquare(
                                icon: "heart.fill",
                                title: "CPR Metronome",
                                subtitle: "110 BPM pacer",
                                color: .red
                            )
                        }
                        .buttonStyle(ScalableButtonStyle())

                        NavigationLink(destination: InclinometerView()) {
                            GlassWidgetSquare(
                                icon: "level.fill",
                                title: "Inclinometer",
                                subtitle: "Slope angle",
                                color: .teal
                            )
                        }
                        .buttonStyle(ScalableButtonStyle())

                        NavigationLink(destination: GlossaryView()) {
                            GlassWidgetSquare(
                                icon: "text.book.closed.fill",
                                title: "Survival Glossary",
                                subtitle: "Key definitions",
                                color: .brown
                            )
                        }
                        .buttonStyle(ScalableButtonStyle())

                        NavigationLink(destination: EmergencyDirectoryView()) {
                            GlassWidgetSquare(
                                icon: "phone.circle.fill",
                                title: "Emergency Directory",
                                subtitle: "Global numbers",
                                color: .green
                            )
                        }
                        .buttonStyle(ScalableButtonStyle())

                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 40)
                }
            }
        }
        .navigationTitle("Tools")
        .navigationBarTitleDisplayMode(.large)
    }
}

// MARK: - Widget Components

struct GlassWidgetSquare: View {
    let icon: String
    let title: LocalizedStringKey
    let subtitle: LocalizedStringKey
    let color: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            ZStack {
                Circle()
                    .fill(color.gradient.opacity(0.15))
                    .frame(width: 44, height: 44)
                Image(systemName: icon)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(color)
            }
            
            Spacer(minLength: 0)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(DesignSystem.textPrimary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
                
                Text(subtitle)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(DesignSystem.textSecondary)
                    .lineLimit(1)
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .frame(height: 140)
        .background(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(.ultraThinMaterial)
                .overlay(
                    LinearGradient(
                        colors: [
                            color.opacity(0.15),
                            color.opacity(0.02)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
        )
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .strokeBorder(Color.white.opacity(0.15), lineWidth: 0.5)
        )
        .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
    }
}
