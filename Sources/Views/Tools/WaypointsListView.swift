import SwiftUI
import CoreLocation

struct WaypointsListView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var waypointsService = WaypointsService.shared
    @ObservedObject var locationManager: LocationManager
    
    @State private var showingAddSheet = false
    @State private var newPointName = ""
    @State private var selectedIcon = "mappin.circle.fill"
    
    let icons = ["mappin.circle.fill", "tent.fill", "drop.fill", "car.fill", "cross.case.fill", "house.fill", "flag.fill", "figure.walk"]
    
    var body: some View {
        NavigationView {
            ZStack {
                DesignSystem.backgroundPrimary.ignoresSafeArea()
                
                if waypointsService.waypoints.isEmpty {
                    VStack(spacing: 20) {
                        Image(systemName: "location.slash.circle.fill")
                            .font(.system(size: 80))
                            .foregroundStyle(Color.gray.opacity(0.3))
                        Text("No Orbit Points")
                            .font(.title2.bold())
                            .foregroundStyle(DesignSystem.textSecondary)
                        Text("Save your current location to navigate back later.")
                            .font(.subheadline)
                            .foregroundStyle(DesignSystem.textSecondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }
                } else {
                    List {
                        ForEach(waypointsService.waypoints) { waypoint in
                            HStack(spacing: 16) {
                                // Icon
                                Image(systemName: waypoint.icon)
                                    .font(.title2)
                                    .foregroundStyle(Color.teal)
                                    .frame(width: 40, height: 40)
                                    .background(Color.teal.opacity(0.1))
                                    .clipShape(Circle())
                                
                                // Details
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(waypoint.name)
                                        .font(.headline)
                                        .foregroundStyle(DesignSystem.textPrimary)
                                    
                                    HStack(spacing: 8) {
                                        Text(String(format: "%.4f, %.4f", waypoint.latitude, waypoint.longitude))
                                            .font(.caption2)
                                            .foregroundStyle(DesignSystem.textSecondary)
                                    }
                                }
                                
                                Spacer()
                                
                                // Live Distance & Bearing (if location available)
                                if let current = locationManager.location {
                                    let distance = waypointsService.calculateDistance(from: current, to: waypoint.location)
                                    let bearing = waypointsService.calculateBearing(from: current, to: waypoint.location)
                                    
                                    VStack(alignment: .trailing, spacing: 2) {
                                        Text(formatDistance(distance))
                                            .font(.system(size: 14, weight: .bold, design: .monospaced))
                                            .foregroundStyle(DesignSystem.textPrimary)
                                        
                                        HStack(spacing: 2) {
                                            Image(systemName: "location.north.fill")
                                                .rotationEffect(.degrees(bearing - (locationManager.heading?.trueHeading ?? 0)))
                                                .font(.caption2)
                                            Text("\(Int(bearing))°")
                                                .font(.caption2)
                                        }
                                        .foregroundStyle(DesignSystem.textSecondary)
                                    }
                                }
                                
                                // Navigate Action
                                Button {
                                    locationManager.setTarget(waypoint)
                                    dismiss()
                                } label: {
                                    Image(systemName: "arrow.triangle.turn.up.right.circle.fill")
                                        .font(.title2)
                                        .foregroundStyle(Color.green)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                            .padding(.vertical, 4)
                            .listRowBackground(Color.clear)
                        }
                        .onDelete { indexSet in
                            indexSet.forEach { index in
                                let point = waypointsService.waypoints[index]
                                waypointsService.delete(point)
                                if locationManager.activeTarget?.id == point.id {
                                    locationManager.clearTarget()
                                }
                            }
                        }
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("Waypoints")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Close") { dismiss() }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        newPointName = "Waypoint \(waypointsService.waypoints.count + 1)"
                        showingAddSheet = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddSheet) {
                if let location = locationManager.location {
                    NavigationView {
                        Form {
                            Section("Details") {
                                TextField("Name", text: $newPointName)
                                Picker("Icon", selection: $selectedIcon) {
                                    ForEach(icons, id: \.self) { icon in
                                        Image(systemName: icon).tag(icon)
                                    }
                                }
                                .pickerStyle(.segmented)
                            }
                            
                            Section("Location") {
                                LabeledContent("Latitude", value: String(format: "%.6f", location.coordinate.latitude))
                                LabeledContent("Longitude", value: String(format: "%.6f", location.coordinate.longitude))
                                LabeledContent("Altitude", value: String(format: "%.1f m", location.altitude))
                            }
                        }
                        .navigationTitle("New Waypoint")
                        .toolbar {
                            ToolbarItem(placement: .cancellationAction) {
                                Button("Cancel") { showingAddSheet = false }
                            }
                            ToolbarItem(placement: .confirmationAction) {
                                Button("Save") {
                                    let newPoint = Waypoint(
                                        name: newPointName,
                                        location: location,
                                        icon: selectedIcon
                                    )
                                    waypointsService.save(newPoint)
                                    showingAddSheet = false
                                }
                            }
                        }
                    }
                    .presentationDetents([.medium])
                } else {
                    ContentUnavailableView("Location Unavailable", systemImage: "location.slash", description: Text("Can't save waypoint without GPS signal."))
                        .presentationDetents([.medium])
                }
            }
        }
    }
    
    private func formatDistance(_ meters: Double) -> String {
        if meters < 1000 {
            return String(format: "%.0f m", meters)
        } else {
            return String(format: "%.1f km", meters / 1000)
        }
    }
}
