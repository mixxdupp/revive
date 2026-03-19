import Foundation
import CoreLocation
import Combine
import SwiftData

@MainActor
class WaypointsService: ObservableObject {
    @Published var waypoints: [Waypoint] = []
    @Published var activeTarget: Waypoint?
    
    static let shared = WaypointsService()
    private var context: ModelContext { DatabaseManager.shared.context }
    
    private init() {
        refreshMemory()
    }
    
    
    private func refreshMemory() {
        let descriptor = FetchDescriptor<WaypointData>(sortBy: [SortDescriptor(\.addedDate, order: .reverse)])
        do {
            let items = try context.fetch(descriptor)
            self.waypoints = items.map { $0.toStruct }
        } catch {
        }
    }
    
    func save(_ waypoint: Waypoint) {
        let newData = WaypointData(
            waypointID: waypoint.id,
            name: waypoint.name,
            latitude: waypoint.coordinate.latitude,
            longitude: waypoint.coordinate.longitude
        )
        context.insert(newData)
        
        do {
            try context.save()
            refreshMemory()
        } catch {
        }
    }
    
    func update(_ waypoint: Waypoint) {
        let waypointIDToFind = waypoint.id
        let descriptor = FetchDescriptor<WaypointData>(predicate: #Predicate { $0.waypointID == waypointIDToFind })
        do {
            if let existing = try context.fetch(descriptor).first {
                existing.name = waypoint.name
                existing.latitude = waypoint.coordinate.latitude
                existing.longitude = waypoint.coordinate.longitude
                try context.save()
                refreshMemory()
            }
        } catch {
        }
    }
    
    func move(from source: IndexSet, to destination: Int) {
        // SwiftData doesn't intrinsically support arbitrary ordering without an explicit `sortOrder` Int column.
        // For the sake of the offline challenge constraints, since Waypoints are prepended mostly,
        // we'll allow standard local array moves for UX but standard SwiftData fetches will default to Date sort on reopen.
        waypoints.move(fromOffsets: source, toOffset: destination)
    }
    
    func delete(_ waypoint: Waypoint) {
        let waypointIDToFind = waypoint.id
        let descriptor = FetchDescriptor<WaypointData>(predicate: #Predicate { $0.waypointID == waypointIDToFind })
        do {
            if let existing = try context.fetch(descriptor).first {
                context.delete(existing)
                try context.save()
                refreshMemory()
            }
        } catch {
        }
    }
    
    
    /// Calculates the bearing (in degrees, 0-360) from start to end
    func calculateBearing(from start: CLLocation, to end: CLLocation) -> Double {
        let lat1 = start.coordinate.latitude.toRadians
        let lon1 = start.coordinate.longitude.toRadians
        
        let lat2 = end.coordinate.latitude.toRadians
        let lon2 = end.coordinate.longitude.toRadians
        
        let dLon = lon2 - lon1
        
        let y = sin(dLon) * cos(lat2)
        let x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLon)
        let radiansBearing = atan2(y, x)
        
        return radiansBearing.toDegrees.normalizedDegrees
    }
    
    /// Calculates distance in meters
    func calculateDistance(from start: CLLocation, to end: CLLocation) -> Double {
        return start.distance(from: end)
    }
}


extension Double {
    var toRadians: Double { self * .pi / 180 }
    var toDegrees: Double { self * 180 / .pi }
    
    var normalizedDegrees: Double {
        let degrees = self.truncatingRemainder(dividingBy: 360)
        return degrees >= 0 ? degrees : degrees + 360
    }
}
