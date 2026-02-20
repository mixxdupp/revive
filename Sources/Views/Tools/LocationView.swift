import SwiftUI
import CoreLocation
import UIKit

struct LocationView: View {
    @StateObject private var locationManager = LocationManager()
    @State private var isAnimating = false
    
    var body: some View {
        ZStack(alignment: .top) {
            // MARK: - Ambient Deep Sea Background
            DesignSystem.backgroundPrimary.ignoresSafeArea()
            
            GeometryReader { proxy in
                ZStack {
                    Circle()
                        .fill(Color.blue.opacity(0.15))
                        .frame(width: 400, height: 400)
                        .blur(radius: 80)
                        .offset(x: isAnimating ? -100 : 150, y: isAnimating ? -50 : 200)
                    
                    Circle()
                        .fill(Color.indigo.opacity(0.2))
                        .frame(width: 300, height: 300)
                        .blur(radius: 60)
                        .offset(x: isAnimating ? 200 : -100, y: isAnimating ? 300 : -50)
                }
                .frame(width: proxy.size.width, height: proxy.size.height)
                .onAppear {
                    withAnimation(.easeInOut(duration: 8.0).repeatForever(autoreverses: true)) {
                        isAnimating = true
                    }
                }
            }
            .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // MARK: - Header
                HStack(alignment: .lastTextBaseline) {
                    Text("GPS Data")
                        .font(.system(size: 34, weight: .black, design: .rounded))
                        .foregroundStyle(DesignSystem.textPrimary)
                    
                    Spacer()
                    
                    // Signal Indicator
                    HStack(spacing: 6) {
                        Circle()
                            .fill(locationManager.location != nil ? Color.green : Color.red)
                            .frame(width: 8, height: 8)
                            .shadow(color: (locationManager.location != nil ? Color.green : Color.red).opacity(0.5), radius: 4)
                            .symbolEffect(.pulse.byLayer, isActive: locationManager.location == nil)
                        
                        Text(locationManager.location != nil ? "LOCKED" : "SEARCHING")
                            .font(.system(size: 12, weight: .bold, design: .monospaced))
                            .foregroundStyle(locationManager.location != nil ? .green : .red)
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(.ultraThinMaterial)
                    .clipShape(Capsule())
                }
                .padding(.horizontal, 24)
                .padding(.top, 20)
                .padding(.bottom, 24)
                
                ScrollView {
                    VStack(spacing: 16) {
                        // MARK: - Primary Coordinates
                        VStack(spacing: 0) {
                            HStack {
                                Image(systemName: "location.viewfinder")
                                    .foregroundStyle(.blue)
                                Text("LATITUDE")
                                    .font(.system(size: 12, weight: .bold, design: .monospaced))
                                    .foregroundStyle(DesignSystem.textSecondary)
                                    .tracking(2)
                                Spacer()
                            }
                            .padding(.bottom, 8)
                            
                            HStack {
                                if let loc = locationManager.location {
                                    Text(formatCoord(loc.coordinate.latitude))
                                        .font(.system(size: 42, weight: .heavy, design: .monospaced))
                                        .foregroundStyle(DesignSystem.textPrimary)
                                        .contentTransition(.numericText())
                                        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: loc.coordinate.latitude)
                                } else {
                                    Text("--.-----")
                                        .font(.system(size: 42, weight: .heavy, design: .monospaced))
                                        .foregroundStyle(DesignSystem.textSecondary.opacity(0.3))
                                }
                                Spacer()
                            }
                            
                            Divider()
                                .overlay(Color.white.opacity(0.1))
                                .padding(.vertical, 16)
                            
                            HStack {
                                Image(systemName: "location.viewfinder")
                                    .foregroundStyle(.blue)
                                Text("LONGITUDE")
                                    .font(.system(size: 12, weight: .bold, design: .monospaced))
                                    .foregroundStyle(DesignSystem.textSecondary)
                                    .tracking(2)
                                Spacer()
                            }
                            .padding(.bottom, 8)
                            
                            HStack {
                                if let loc = locationManager.location {
                                    Text(formatCoord(loc.coordinate.longitude))
                                        .font(.system(size: 42, weight: .heavy, design: .monospaced))
                                        .foregroundStyle(DesignSystem.textPrimary)
                                        .contentTransition(.numericText())
                                        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: loc.coordinate.longitude)
                                } else {
                                    Text("--.-----")
                                        .font(.system(size: 42, weight: .heavy, design: .monospaced))
                                        .foregroundStyle(DesignSystem.textSecondary.opacity(0.3))
                                }
                                Spacer()
                            }
                        }
                        .padding(24)
                        .background(.ultraThinMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
                        .overlay(
                            RoundedRectangle(cornerRadius: 24, style: .continuous)
                                .stroke(Color.white.opacity(0.15), lineWidth: 1)
                        )
                        .padding(.horizontal, 20)
                        
                        // MARK: - 2x2 Telemetry Grid
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                            
                            // Altitude
                            TelemetryTile(
                                title: "ALTITUDE",
                                icon: "arrow.up.circle.fill",
                                color: .teal,
                                value: locationManager.location.map { "\(Int($0.altitude))" } ?? "--",
                                unit: "METERS"
                            )
                            
                            // Speed
                            TelemetryTile(
                                title: "SPEED",
                                icon: "speedometer",
                                color: .orange,
                                value: locationManager.location.map { $0.speed > 0 ? String(format: "%.1f", $0.speed * 3.6) : "0.0" } ?? "--",
                                unit: "KM/H"
                            )
                            
                            // Accuracy
                            TelemetryTile(
                                title: "ACCURACY",
                                icon: "scope",
                                color: .green,
                                value: locationManager.location.map { "±\(Int($0.horizontalAccuracy))" } ?? "--",
                                unit: "METERS"
                            )
                            
                            // Heading / Bearing
                            TelemetryTile(
                                title: "COURSE",
                                icon: "location.north.line.fill",
                                color: .purple,
                                value: locationManager.location.map { $0.course >= 0 ? "\(Int($0.course))°" : "--°" } ?? "--°",
                                unit: "TRUE"
                            )
                            
                        }
                        .padding(.horizontal, 20)
                    }
                    .padding(.bottom, 120) // Space for floating button
                }
            }
            .padding(.top, 40) // Clearance for nav bar
            
            // MARK: - Floating Action Button
            VStack {
                Spacer()
                
                Button(action: {
                    if let loc = locationManager.location {
                        let text = "My Location: \(loc.coordinate.latitude), \(loc.coordinate.longitude)"
                        UIPasteboard.general.string = text
                        HapticsService.shared.playNotification(type: .success)
                    }
                }) {
                    HStack(spacing: 8) {
                        Image(systemName: "doc.on.doc.fill")
                        Text("Copy Fix")
                            .font(.system(size: 18, weight: .bold, design: .rounded))
                    }
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 18)
                    .background(locationManager.location != nil ? Color.blue : Color.gray.opacity(0.3))
                    .clipShape(Capsule())
                    .shadow(color: locationManager.location != nil ? Color.blue.opacity(0.4) : Color.clear, radius: 10, x: 0, y: 5)
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 40)
                .disabled(locationManager.location == nil)
                .animation(.easeInOut, value: locationManager.location)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
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

// MARK: - Components
struct TelemetryTile: View {
    let title: String
    let icon: String
    let color: Color
    let value: String
    let unit: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: icon)
                    .foregroundStyle(color)
                    .font(.system(size: 14, weight: .semibold))
                
                Text(title)
                    .font(.system(size: 12, weight: .bold, design: .monospaced))
                    .foregroundStyle(DesignSystem.textSecondary)
                    .tracking(1)
                
                Spacer()
            }
            
            HStack(alignment: .firstTextBaseline, spacing: 4) {
                Text(value)
                    .font(.system(size: 28, weight: .black, design: .monospaced))
                    .foregroundStyle(DesignSystem.textPrimary)
                    .contentTransition(.numericText())
                    .animation(.spring(response: 0.3, dampingFraction: 0.7), value: value)
                
                Text(unit)
                    .font(.system(size: 10, weight: .bold, design: .monospaced))
                    .foregroundStyle(DesignSystem.textSecondary)
            }
        }
        .padding(16)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .stroke(Color.white.opacity(0.15), lineWidth: 1)
        )
    }
}
