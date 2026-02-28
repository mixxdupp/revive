import SwiftUI
import CoreLocation
import UIKit

struct LocationView: View {
    @StateObject private var locationManager = LocationManager()
    @State private var copied = false
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack(spacing: 0) {
                Spacer()
                
                // MARK: - Hero Coordinates
                VStack(spacing: 24) {
                    // Latitude
                    VStack(spacing: 8) {
                        Text("LATITUDE")
                            .font(.system(size: 13, weight: .medium, design: .rounded))
                            .foregroundStyle(Color(white: 0.45))
                            .kerning(2)
                        
                        if let loc = locationManager.location {
                            Text(formatCoord(loc.coordinate.latitude))
                                .font(.system(size: 48, weight: .light, design: .rounded).monospacedDigit())
                                .foregroundStyle(.white)
                                .contentTransition(.numericText())
                        } else {
                            Text("—.—————")
                                .font(.system(size: 48, weight: .light, design: .rounded).monospacedDigit())
                                .foregroundStyle(Color(white: 0.2))
                        }
                    }
                    
                    // Longitude
                    VStack(spacing: 8) {
                        Text("LONGITUDE")
                            .font(.system(size: 13, weight: .medium, design: .rounded))
                            .foregroundStyle(Color(white: 0.45))
                            .kerning(2)
                        
                        if let loc = locationManager.location {
                            Text(formatCoord(loc.coordinate.longitude))
                                .font(.system(size: 48, weight: .light, design: .rounded).monospacedDigit())
                                .foregroundStyle(.white)
                                .contentTransition(.numericText())
                        } else {
                            Text("—.—————")
                                .font(.system(size: 48, weight: .light, design: .rounded).monospacedDigit())
                                .foregroundStyle(Color(white: 0.2))
                        }
                    }
                    
                    // Signal status
                    HStack(spacing: 6) {
                        Circle()
                            .fill(locationManager.location != nil ? Color.green : Color.red)
                            .frame(width: 6, height: 6)
                        Text(locationManager.location != nil ? "GPS Locked" : "Acquiring")
                            .font(.system(size: 13, weight: .medium, design: .rounded))
                            .foregroundStyle(locationManager.location != nil ? Color.green : Color.red)
                    }
                }
                
                Spacer()
                
                // MARK: - Telemetry Grid
                HStack(spacing: 12) {
                    GPSMetricCard(
                        title: "ALT",
                        value: locationManager.location.map { "\(Int($0.altitude))" } ?? "—",
                        unit: "m",
                        icon: "arrow.up.and.down",
                        color: .blue
                    )
                    GPSMetricCard(
                        title: "SPEED",
                        value: locationManager.location.map { $0.speed > 0 ? String(format: "%.1f", $0.speed * 3.6) : "0.0" } ?? "—",
                        unit: "km/h",
                        icon: "speedometer",
                        color: .orange
                    )
                }
                .padding(.horizontal, 24)
                
                HStack(spacing: 12) {
                    GPSMetricCard(
                        title: "ACCURACY",
                        value: locationManager.location.map { "±\(Int($0.horizontalAccuracy))" } ?? "—",
                        unit: "m",
                        icon: "scope",
                        color: .green
                    )
                    GPSMetricCard(
                        title: "COURSE",
                        value: locationManager.location.map { $0.course >= 0 ? "\(Int($0.course))°" : "—" } ?? "—",
                        unit: "True",
                        icon: "location.north.line.fill",
                        color: .purple
                    )
                }
                .padding(.horizontal, 24)
                .padding(.top, 12)
                .padding(.bottom, 24)
                
                // MARK: - Copy Button
                Button(action: {
                    let generator = UIImpactFeedbackGenerator(style: .rigid)
                    generator.impactOccurred()
                    
                    if let loc = locationManager.location {
                        let text = "\(loc.coordinate.latitude), \(loc.coordinate.longitude)"
                        UIPasteboard.general.string = text
                        HapticsService.shared.playNotification(type: .success)
                        copied = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            copied = false
                        }
                    }
                }) {
                    HStack(spacing: 6) {
                        Image(systemName: copied ? "checkmark" : "doc.on.doc")
                            .font(.system(size: 13, weight: .semibold))
                        Text(copied ? "Copied" : "Copy Coordinates")
                            .font(.system(size: 14, weight: .medium, design: .rounded))
                    }
                    .foregroundStyle(copied ? .green : Color(white: 0.6))
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)
                    .background(Color(white: 0.1))
                    .clipShape(Capsule())
                }
                .disabled(locationManager.location == nil)
                .opacity(locationManager.location == nil ? 0.3 : 1.0)
                .padding(.bottom, 32)
            }
        }
        .navigationTitle("GPS Data")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            locationManager.requestPermission()
            locationManager.startUpdating()
            UIApplication.shared.isIdleTimerDisabled = true
        }
        .onDisappear {
            locationManager.stopUpdating()
            UIApplication.shared.isIdleTimerDisabled = false
        }
    }
    
    func formatCoord(_ val: Double) -> String {
        return String(format: "%.5f", val)
    }
}

// MARK: - Metric Card
private struct GPSMetricCard: View {
    let title: String
    let value: String
    let unit: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.system(size: 12, weight: .bold))
                    .foregroundStyle(color)
                Text(title)
                    .font(.system(size: 13, weight: .medium, design: .rounded))
                    .foregroundStyle(Color(white: 0.45))
                    .kerning(1)
            }
            
            HStack(alignment: .firstTextBaseline, spacing: 4) {
                Text(value)
                    .font(.system(size: 26, weight: .light, design: .rounded).monospacedDigit())
                    .foregroundStyle(.white)
                    .contentTransition(.numericText())
                Text(unit)
                    .font(.system(size: 13, weight: .medium, design: .rounded))
                    .foregroundStyle(Color(white: 0.4))
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(18)
        .background(Color(white: 0.08))
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }
}
