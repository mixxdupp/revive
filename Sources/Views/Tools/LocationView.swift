import SwiftUI
import CoreLocation

struct LocationView: View {
    @StateObject private var locationManager = LocationManager()
    
    var body: some View {
        ZStack {
            DesignSystem.backgroundPrimary.ignoresSafeArea()
            
            VStack(spacing: 24) {
                // Header
                Text("GPS Data")
                    .font(.system(size: 32, weight: .black, design: .serif))
                    .foregroundStyle(DesignSystem.textPrimary)
                    .padding(.top, 20)
                
                // Coordinates Card
                GlassDataCard(title: "Coordinates", icon: "location.circle.fill", color: .blue) {
                    VStack(spacing: 12) {
                        if let loc = locationManager.location {
                            DataRow(label: "Latitude", value: formatCoord(loc.coordinate.latitude))
                            Divider()
                            DataRow(label: "Longitude", value: formatCoord(loc.coordinate.longitude))
                        } else {
                            Text("Acquiring Signal...")
                                .font(.title3)
                                .foregroundStyle(DesignSystem.textSecondary)
                                .padding()
                        }
                    }
                }
                
                // Altitude & Speed
                HStack(spacing: 16) {
                    GlassDataCard(title: "Altitude", icon: "arrow.up.circle.fill", color: .teal) {
                        if let loc = locationManager.location {
                            Text("\(Int(loc.altitude)) m")
                                .font(.system(size: 28, weight: .bold, design: .monospaced))
                            Text("\(Int(loc.altitude * 3.28084)) ft")
                                .font(.caption)
                                .foregroundStyle(DesignSystem.textSecondary)
                        } else {
                            Text("--")
                        }
                    }
                    
                    GlassDataCard(title: "Speed", icon: "speedometer", color: .orange) {
                        if let loc = locationManager.location, loc.speed > 0 {
                            Text("\(String(format: "%.1f", loc.speed * 3.6)) km/h")
                                .font(.system(size: 24, weight: .bold, design: .monospaced))
                        } else {
                            Text("0.0 km/h")
                                .font(.system(size: 24, weight: .bold, design: .monospaced))
                        }
                    }
                }
                
                // Copy Button
                Button(action: {
                    if let loc = locationManager.location {
                        let text = "My Location: \(loc.coordinate.latitude), \(loc.coordinate.longitude)"
                        UIPasteboard.general.string = text
                        let generator = UINotificationFeedbackGenerator()
                        generator.notificationOccurred(.success)
                    }
                }) {
                    HStack {
                        Image(systemName: "doc.on.doc.fill")
                        Text("Copy Coordinates")
                    }
                    .font(.headline)
                    .foregroundStyle(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(12)
                }
                .padding(.horizontal, 24)
                .disabled(locationManager.location == nil)
                
                Spacer()
            }
            .padding()
        }
        .onAppear {
            locationManager.requestPermission()
            locationManager.startUpdating()
        }
        .onDisappear {
            locationManager.stopUpdating()
        }
    }
    
    func formatCoord(_ val: Double) -> String {
        return String(format: "%.5f", val)
    }
}

// Helper Components
struct GlassDataCard<Content: View>: View {
    let title: String
    let icon: String
    let color: Color
    @ViewBuilder let content: Content
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Image(systemName: icon)
                    .foregroundStyle(color)
                    .font(.title2)
                Text(title)
                    .font(.headline)
                    .foregroundStyle(DesignSystem.textSecondary)
                Spacer()
            }
            content
        }
        .padding()
        .background(.ultraThinMaterial)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(color.opacity(0.3), lineWidth: 1)
        )
    }
}

struct DataRow: View {
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Text(label)
                .foregroundStyle(DesignSystem.textSecondary)
            Spacer()
            Text(value)
                .font(.system(.title3, design: .monospaced))
                .fontWeight(.bold)
                .foregroundStyle(DesignSystem.textPrimary)
        }
    }
}
