import Foundation
import CoreLocation
import Combine
import UIKit

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let manager = CLLocationManager()
    
    @Published var heading: CLHeading?
    @Published var location: CLLocation?
    @Published var authorizationStatus: CLAuthorizationStatus = .notDetermined
    
    // Compass Features
    @Published var trueNorth: Double = 0
    @Published var magneticNorth: Double = 0
    @Published var isLocked: Bool = false
    @Published var lockedBearing: Double = 0
    
    // Waypoint Navigation
    @Published var activeTarget: Waypoint?
    @Published var distanceToTarget: Double?
    @Published var targetBearing: Double?
    
    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.distanceFilter = kCLDistanceFilterNone
        manager.headingFilter = 1 // Update every degree
        
        // Check current status
        self.authorizationStatus = manager.authorizationStatus
        
        // Sync with WaypointsService
        WaypointsService.shared.$activeTarget
            .receive(on: RunLoop.main)
            .sink { [weak self] target in
                self?.activeTarget = target
                // Trigger calculation update
                if let location = self?.location {
                    self?.locationManager(self!.manager, didUpdateLocations: [location])
                }
            }
            .store(in: &cancellables)
    }
    
    private var cancellables = Set<AnyCancellable>()
    
    func requestPermission() {
        manager.requestWhenInUseAuthorization()
    }
    
    func startUpdating() {
        manager.startUpdatingHeading()
        manager.startUpdatingLocation()
    }
    
    func stopUpdating() {
        manager.stopUpdatingHeading()
        manager.stopUpdatingLocation()
    }
    
    // MARK: - Delegate Methods
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        self.authorizationStatus = manager.authorizationStatus
        if manager.authorizationStatus == .authorizedWhenInUse || manager.authorizationStatus == .authorizedAlways {
            startUpdating()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        // Use true heading if valid (requires location), otherwise magnetic
        self.heading = newHeading
        self.magneticNorth = newHeading.magneticHeading
        self.trueNorth = newHeading.trueHeading > 0 ? newHeading.trueHeading : newHeading.magneticHeading
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        self.location = location
        
        // Update Navigation
        if let target = activeTarget {
            let targetLoc = CLLocation(latitude: target.latitude, longitude: target.longitude)
            self.distanceToTarget = location.distance(from: targetLoc)
            self.targetBearing = WaypointsService.shared.calculateBearing(from: location, to: targetLoc)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("LocationManager Error: \(error.localizedDescription)")
    }
    
    // MARK: - Features
    
    func toggleLock() {
        if isLocked {
            isLocked = false
        } else {
            lockedBearing = trueNorth // Lock to current True North
            isLocked = true
            
            // Haptic Feedback
            let generator = UIImpactFeedbackGenerator(style: .heavy)
            generator.impactOccurred()
        }
    }
    
    // MARK: - Navigation Control
    
    func setTarget(_ waypoint: Waypoint) {
        WaypointsService.shared.activeTarget = waypoint
    }
    
    func clearTarget() {
        WaypointsService.shared.activeTarget = nil
    }
}
