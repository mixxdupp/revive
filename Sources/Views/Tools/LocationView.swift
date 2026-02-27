import SwiftUI
import CoreLocation
import UIKit

struct LocationView: View {
    @StateObject private var locationManager = LocationManager()
    @State private var copied = false
    
    var body: some View {
        List {
            // MARK: - Status
            Section {
                HStack {
                    Text("Signal")
                    Spacer()
                    HStack(spacing: 8) {
                        Circle()
                            .fill(locationManager.location != nil ? Color.green : Color.red)
                            .frame(width: 8, height: 8)
                        
                        Text(locationManager.location != nil ? "GPS Locked" : "Acquiring")
                            .font(.subheadline.weight(.semibold))
                            .foregroundStyle(locationManager.location != nil ? .green : .red)
                    }
                }
            }
            
            // MARK: - Coordinates
            Section("Coordinates") {
                VStack(alignment: .leading, spacing: 4) {
                    Text("LATITUDE")
                        .font(.caption2.weight(.semibold))
                        .foregroundStyle(.secondary)
                    
                    if let loc = locationManager.location {
                        Text(formatCoord(loc.coordinate.latitude))
                            .font(.system(size: 28, weight: .medium, design: .rounded).monospacedDigit())
                            .contentTransition(.numericText())
                    } else {
                        Text("—.—————")
                            .font(.system(size: 28, weight: .medium, design: .rounded).monospacedDigit())
                            .foregroundStyle(.tertiary)
                    }
                }
                .padding(.vertical, 4)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("LONGITUDE")
                        .font(.caption2.weight(.semibold))
                        .foregroundStyle(.secondary)
                    
                    if let loc = locationManager.location {
                        Text(formatCoord(loc.coordinate.longitude))
                            .font(.system(size: 28, weight: .medium, design: .rounded).monospacedDigit())
                            .contentTransition(.numericText())
                    } else {
                        Text("—.—————")
                            .font(.system(size: 28, weight: .medium, design: .rounded).monospacedDigit())
                            .foregroundStyle(.tertiary)
                    }
                }
                .padding(.vertical, 4)
            }
            
            // MARK: - Telemetry
            Section("Telemetry") {
                TelemetryRow(
                    title: "Altitude",
                    icon: "arrow.up.and.down",
                    color: .blue,
                    value: locationManager.location.map { "\(Int($0.altitude))" } ?? "—",
                    unit: "m"
                )
                
                TelemetryRow(
                    title: "Speed",
                    icon: "speedometer",
                    color: .orange,
                    value: locationManager.location.map { $0.speed > 0 ? String(format: "%.1f", $0.speed * 3.6) : "0.0" } ?? "—",
                    unit: "km/h"
                )
                
                TelemetryRow(
                    title: "Accuracy",
                    icon: "scope",
                    color: .green,
                    value: locationManager.location.map { "±\(Int($0.horizontalAccuracy))" } ?? "—",
                    unit: "m"
                )
                
                TelemetryRow(
                    title: "Course",
                    icon: "location.north.line.fill",
                    color: .purple,
                    value: locationManager.location.map { $0.course >= 0 ? "\(Int($0.course))°" : "—°" } ?? "—°",
                    unit: "True"
                )
            }
            
            // MARK: - Actions
            Section {
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
                    HStack {
                        Image(systemName: copied ? "checkmark.circle.fill" : "doc.on.doc")
                            .foregroundStyle(copied ? .green : .accentColor)
                        Text(copied ? "Copied to Clipboard" : "Copy Coordinates")
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                }
                .disabled(locationManager.location == nil)
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
                .frame(width: 28, alignment: .leading)
            
            Text(title)
            
            Spacer()
            
            HStack(alignment: .firstTextBaseline, spacing: 4) {
                Text(value)
                    .font(.body.weight(.medium).monospacedDigit())
                    .contentTransition(.numericText())
                
                Text(unit)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
    }
}
