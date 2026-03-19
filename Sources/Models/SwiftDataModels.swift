import Foundation
import SwiftData
import CoreLocation

// Note: RecentItem and FavoriteItem were removed and migrated to UserDefaults
// due to unresolved iOS 17 SwiftData unique constraint and initialization bugs.

@Model
final class WaypointData {
    var waypointID: UUID
    var name: String
    var latitude: Double
    var longitude: Double
    var addedDate: Date
    
    init(waypointID: UUID = UUID(), name: String, latitude: Double, longitude: Double) {
        self.waypointID = waypointID
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
        self.addedDate = Date()
    }
    
    var toStruct: Waypoint {
        return Waypoint(
            id: waypointID,
            name: name,
            location: CLLocation(latitude: latitude, longitude: longitude)
        )
    }
}


