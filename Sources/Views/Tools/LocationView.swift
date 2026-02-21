import SwiftUI
import CoreLocation
import UIKit

struct LocationView: View {
    @StateObject private var locationManager = LocationManager()
    
    var body: some View {
        List {
            // MARK: - Status Header
            Section {
                HStack {
                    Text("Signal Status")
                        .foregroundStyle(DesignSystem.textPrimary)
                    
                    Spacer()
                    
                    HStack(spacing: 6) {
                        Circle()
                            .fill(locationManager.location != nil ? Color.green : Color.red)
                            .frame(width: 8, height: 8)
                            .symbolEffect(.pulse.byLayer, isActive: locationManager.location == nil)
                        
                        Text(locationManager.location != nil ? "Locked" : "Searching")
                            .font(.subheadline.bold())
                            .foregroundStyle(locationManager.location != nil ? .green : .red)
                    }
                }
            }
            
            // MARK: - Primary Coordinates
            Section(header: Text("Coordinates")) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Latitude")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    
                    if let loc = locationManager.location {
                        Text(formatCoord(loc.coordinate.latitude))
                            .font(.title2.weight(.semibold).monospacedDigit())
                            .foregroundStyle(DesignSystem.textPrimary)
                            .contentTransition(.numericText())
                            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: loc.coordinate.latitude)
                    } else {
                        Text("--.-----")
                            .font(.title2.weight(.semibold).monospacedDigit())
                            .foregroundStyle(.secondary)
                    }
                }
                .padding(.vertical, 4)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Longitude")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    
                    if let loc = locationManager.location {
                        Text(formatCoord(loc.coordinate.longitude))
                            .font(.title2.weight(.semibold).monospacedDigit())
                            .foregroundStyle(DesignSystem.textPrimary)
                            .contentTransition(.numericText())
                            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: loc.coordinate.longitude)
                    } else {
                        Text("--.-----")
                            .font(.title2.weight(.semibold).monospacedDigit())
                            .foregroundStyle(.secondary)
                    }
                }
                .padding(.vertical, 4)
            }
            
            // MARK: - Telemetry Data
            Section(header: Text("Telemetry")) {
                TelemetryRow(
                    title: "Altitude",
                    icon: "arrow.up.and.down",
                    color: .blue,
                    value: locationManager.location.map { "\(Int($0.altitude))" } ?? "--",
                    unit: "m"
                )
                
                TelemetryRow(
                    title: "Speed",
                    icon: "speedometer",
                    color: .orange,
                    value: locationManager.location.map { $0.speed > 0 ? String(format: "%.1f", $0.speed * 3.6) : "0.0" } ?? "--",
                    unit: "km/h"
                )
                
                TelemetryRow(
                    title: "Accuracy",
                    icon: "scope",
                    color: .green,
                    value: locationManager.location.map { "±\(Int($0.horizontalAccuracy))" } ?? "--",
                    unit: "m"
                )
                
                TelemetryRow(
                    title: "Course",
                    icon: "location.north.line.fill",
                    color: .purple,
                    value: locationManager.location.map { $0.course >= 0 ? "\(Int($0.course))°" : "--°" } ?? "--°",
                    unit: "True"
                )
            }
            
            // MARK: - Actions
            Section {
                Button(action: {
                    if let loc = locationManager.location {
                        let text = "My Location: \(loc.coordinate.latitude), \(loc.coordinate.longitude)"
                        UIPasteboard.general.string = text
                        HapticsService.shared.playNotification(type: .success)
                    }
                }) {
                    HStack {
                        Image(systemName: "doc.on.doc")
                        Text("Copy Coordinates")
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                }
                .disabled(locationManager.location == nil)
                // In iOS 18 native lists, action buttons are often blue if generic, or rely on tint.
                .foregroundStyle(locationManager.location != nil ? .blue : .gray)
            }
        }
        .listStyle(.insetGrouped)
        .navigationTitle("GPS Data")
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
struct TelemetryRow: View {
    let title: String
    let icon: String
    let color: Color
    let value: String
    let unit: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundStyle(color)
                .frame(width: 24, alignment: .center)
            
            Text(title)
                .foregroundStyle(DesignSystem.textPrimary)
            
            Spacer()
            
            HStack(alignment: .firstTextBaseline, spacing: 4) {
                Text(value)
                    .font(.body.monospacedDigit())
                    .foregroundStyle(DesignSystem.textPrimary)
                    .contentTransition(.numericText())
                    .animation(.spring(response: 0.3, dampingFraction: 0.7), value: value)
                
                Text(unit)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
    }
}
