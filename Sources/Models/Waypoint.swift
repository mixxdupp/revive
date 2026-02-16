import Foundation
import CoreLocation

struct Waypoint: Identifiable, Codable, Hashable {
    let id: UUID
    var name: String
    let latitude: Double
    let longitude: Double
    var icon: String // SF Symbol name
    var color: String // Hex or asset name, simplifying to string for now, could be enum
    let timestamp: Date
    
    init(id: UUID = UUID(), name: String, location: CLLocation, icon: String = "mappin.circle.fill", color: String = "red") {
        self.id = id
        self.name = name
        self.latitude = location.coordinate.latitude
        self.longitude = location.coordinate.longitude
        self.icon = icon
        self.color = color
        self.timestamp = Date()
    }
    
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    var location: CLLocation {
        CLLocation(latitude: latitude, longitude: longitude)
    }
}
