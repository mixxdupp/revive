import Foundation
import CoreLocation
import Combine

class WaypointsService: ObservableObject {
    @Published var waypoints: [Waypoint] = []
    @Published var activeTarget: Waypoint?
    
    private let saveKey = "revive_waypoints_v1"
    
    static let shared = WaypointsService()
    
    private init() {
        loadWithDefaults()
    }
    
    // MARK: - Persistence
    
    private func loadWithDefaults() {
        if let data = UserDefaults.standard.data(forKey: saveKey),
           let decoded = try? JSONDecoder().decode([Waypoint].self, from: data) {
            self.waypoints = decoded.sorted(by: { $0.timestamp > $1.timestamp })
        } else {
             self.waypoints = []
        }
    }
    
    func save(_ waypoint: Waypoint) {
        waypoints.append(waypoint) // Add to memory
        waypoints.sort(by: { $0.timestamp > $1.timestamp }) // Sort new first
        persist()
    }
    
    func delete(_ waypoint: Waypoint) {
        waypoints.removeAll { $0.id == waypoint.id }
        persist()
    }
    
    private func persist() {
        if let encoded = try? JSONEncoder().encode(waypoints) {
            UserDefaults.standard.set(encoded, forKey: saveKey)
        }
    }
    
    // MARK: - Navigation Math
    
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

// MARK: - Helpers

extension Double {
    var toRadians: Double { self * .pi / 180 }
    var toDegrees: Double { self * 180 / .pi }
    
    var normalizedDegrees: Double {
        let degrees = self.truncatingRemainder(dividingBy: 360)
        return degrees >= 0 ? degrees : degrees + 360
    }
}
