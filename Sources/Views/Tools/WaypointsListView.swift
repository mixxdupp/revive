import SwiftUI
import CoreLocation

struct WaypointsListView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var waypointsService = WaypointsService.shared
    @ObservedObject var locationManager: LocationManager
    
    @State private var showingAddSheet = false
    @State private var newPointName = ""
    @State private var selectedIcon = "mappin.circle.fill"
    @State private var editingWaypoint: Waypoint?
    @State private var editName = ""
    @State private var editIcon = ""
    @State private var editMode: EditMode = .inactive
    
    let icons = ["mappin.circle.fill", "tent.fill", "drop.fill", "car.fill", "cross.case.fill", "house.fill", "flag.fill", "figure.walk"]
    
    var body: some View {
        ZStack {
                
                if waypointsService.waypoints.isEmpty {
                    VStack(spacing: 20) {
                        Image(systemName: "location.slash.circle.fill")
                            .font(.system(size: 80))
                            .foregroundStyle(Color.gray.opacity(0.3))
                        .accessibilityHidden(true)
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
                                .accessibilityHidden(true)
                                
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
                                            .font(.system(size: 14, weight: .bold).monospacedDigit())
                                            .foregroundStyle(DesignSystem.textPrimary)
                                        
                                        HStack(spacing: 2) {
                                            Image(systemName: "location.north.fill")
                                                .rotationEffect(.degrees(bearing - (locationManager.heading?.trueHeading ?? 0)))
                                                .font(.caption2)
                                            .accessibilityHidden(true)
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
                                    .accessibilityHidden(true)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                            .padding(.vertical, 4)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                editName = waypoint.name
                                editIcon = waypoint.icon
                                editingWaypoint = waypoint
                            }
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
                        .onMove { source, destination in
                            waypointsService.move(from: source, to: destination)
                        }
                    }
                    .listStyle(.insetGrouped)
                    .environment(\.editMode, $editMode)
                }
            }
            .navigationTitle("Waypoints")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    if !waypointsService.waypoints.isEmpty {
                        Button(editMode == .active ? "Done" : "Edit") {
                            editMode = editMode == .active ? .inactive : .active
                        }
                    }
                    Button {
                        newPointName = "Waypoint \(waypointsService.waypoints.count + 1)"
                        showingAddSheet = true
                    } label: {
                        Image(systemName: "plus")
                        .accessibilityHidden(true)
                    }
                }
            }
            // MARK: - Add Sheet
            .sheet(isPresented: $showingAddSheet) {
                if let location = locationManager.location {
                    NavigationView {
                        Form {
                            Section("Details") {
                                TextField("Name", text: $newPointName)
                                Picker("Icon", selection: $selectedIcon) {
                                    ForEach(icons, id: \.self) { icon in
                                        Image(systemName: icon).tag(icon)
                                        .accessibilityHidden(true)
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
            // MARK: - Edit Sheet
            .sheet(item: $editingWaypoint) { waypoint in
                NavigationView {
                    Form {
                        Section("Details") {
                            TextField("Name", text: $editName)
                            Picker("Icon", selection: $editIcon) {
                                ForEach(icons, id: \.self) { icon in
                                    Image(systemName: icon).tag(icon)
                                    .accessibilityHidden(true)
                                }
                            }
                            .pickerStyle(.segmented)
                        }
                        
                        Section("Location") {
                            LabeledContent("Latitude", value: String(format: "%.6f", waypoint.latitude))
                            LabeledContent("Longitude", value: String(format: "%.6f", waypoint.longitude))
                            
                            Button {
                                let url = URL(string: "http://maps.apple.com/?ll=\(waypoint.latitude),\(waypoint.longitude)&q=\(waypoint.name.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "Waypoint")")!
                                UIApplication.shared.open(url)
                            } label: {
                                HStack {
                                    Image(systemName: "map.fill")
                                    Text("Open in Apple Maps")
                                }
                            }
                        }
                    }
                    .navigationTitle("Edit Waypoint")
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Cancel") { editingWaypoint = nil }
                        }
                        ToolbarItem(placement: .confirmationAction) {
                            Button("Save") {
                                var updated = waypoint
                                updated.name = editName
                                updated.icon = editIcon
                                waypointsService.update(updated)
                                editingWaypoint = nil
                            }
                            .disabled(editName.trimmingCharacters(in: .whitespaces).isEmpty)
                        }
                    }
                }
                .presentationDetents([.medium])
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
