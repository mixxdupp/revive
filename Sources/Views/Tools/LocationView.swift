import SwiftUI
import CoreLocation
import UIKit

struct LocationView: View {
    @StateObject private var locationManager = LocationManager()
    @State private var copied = false
    
    // Signal color
    private var signalColor: Color {
        locationManager.location != nil ? .green : Color(red: 1.0, green: 0.3, blue: 0.2)
    }
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    // MARK: - Header
                    HStack(spacing: 8) {
                        Circle()
                            .fill(signalColor)
                            .frame(width: 8, height: 8)
                        
                        Text(locationManager.location != nil ? "GPS LOCKED" : "ACQUIRING SIGNAL")
                            .font(.system(size: 13, weight: .bold, design: .rounded))
                            .foregroundStyle(signalColor)
                            .kerning(1.5)
                    }
                    .padding(.top, 24)
                    .padding(.bottom, 40)
                    
                    // MARK: - Coordinate Display
                    VStack(spacing: 32) {
                        // Latitude
                        VStack(spacing: 4) {
                            Text("LATITUDE")
                                .font(.system(size: 13, weight: .bold, design: .rounded))
                                .foregroundStyle(Color(white: 0.4))
                                .kerning(1.5)
                            
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
                        VStack(spacing: 4) {
                            Text("LONGITUDE")
                                .font(.system(size: 13, weight: .bold, design: .rounded))
                                .foregroundStyle(Color(white: 0.4))
                                .kerning(1.5)
                            
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
                    }
                    .padding(.bottom, 48)
                    
                    // MARK: - Telemetry Grid
                    LazyVGrid(columns: [GridItem(.flexible(), spacing: 12), GridItem(.flexible(), spacing: 12)], spacing: 12) {
                        GPSTelemetryCard(
                            title: "ALTITUDE",
                            value: locationManager.location.map { "\(Int($0.altitude))" } ?? "—",
                            unit: "m",
                            icon: "arrow.up.and.down",
                            color: Color(red: 0.3, green: 0.6, blue: 1.0)
                        )
                        
                        GPSTelemetryCard(
                            title: "SPEED",
                            value: locationManager.location.map { $0.speed > 0 ? String(format: "%.1f", $0.speed * 3.6) : "0.0" } ?? "—",
                            unit: "km/h",
                            icon: "speedometer",
                            color: Color(red: 1.0, green: 0.6, blue: 0.0)
                        )
                        
                        GPSTelemetryCard(
                            title: "ACCURACY",
                            value: locationManager.location.map { "±\(Int($0.horizontalAccuracy))" } ?? "—",
                            unit: "m",
                            icon: "scope",
                            color: .green
                        )
                        
                        GPSTelemetryCard(
                            title: "COURSE",
                            value: locationManager.location.map { $0.course >= 0 ? "\(Int($0.course))°" : "—°" } ?? "—°",
                            unit: "True",
                            icon: "location.north.line.fill",
                            color: Color(red: 0.7, green: 0.4, blue: 1.0)
                        )
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 32)
                    
                    // MARK: - Copy Action
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
                        HStack(spacing: 12) {
                            Image(systemName: copied ? "checkmark" : "doc.on.doc")
                                .font(.system(size: 20, weight: .black))
                            
                            Text(copied ? "COPIED" : "COPY COORDINATES")
                                .font(.system(size: 18, weight: .heavy, design: .rounded))
                                .kerning(1)
                        }
                        .foregroundStyle(.black)
                        .frame(maxWidth: .infinity)
                        .frame(height: 72)
                        .background(
                            Capsule()
                                .fill(Color.white)
                        )
                    }
                    .disabled(locationManager.location == nil)
                    .opacity(locationManager.location == nil ? 0.3 : 1.0)
                    .padding(.horizontal, 24)
                    .padding(.bottom, 24)
                }
            }
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.hidden, for: .navigationBar)
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

// MARK: - Telemetry Metric Card
private struct GPSTelemetryCard: View {
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
                    .font(.system(size: 13, weight: .bold, design: .rounded))
                    .foregroundStyle(Color(white: 0.5))
                    .kerning(0.5)
            }
            
            HStack(alignment: .firstTextBaseline, spacing: 4) {
                Text(value)
                    .font(.system(size: 26, weight: .bold, design: .rounded).monospacedDigit())
                    .foregroundStyle(.white)
                    .contentTransition(.numericText())
                
                Text(unit)
                    .font(.system(size: 14, weight: .semibold, design: .rounded))
                    .foregroundStyle(Color(white: 0.4))
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(18)
        .background(Color(white: 0.1))
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
    }
}
