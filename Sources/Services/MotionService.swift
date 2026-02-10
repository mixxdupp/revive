import CoreMotion
import Combine
import UIKit

class MotionService: ObservableObject {
    static let shared = MotionService()
    
    // We can use CMMotionManager for more complex motion, but for "Shake", 
    // UIWindow's motionEnded is often simpler in UIKit. 
    // Since we are in SwiftUI, we can try a different approach or bridge it.
    // However, for a Playground, we can use CMMotionManager to detect significant acceleration changes.
    
    private let motionManager = CMMotionManager()
    @Published var isShaking = false
    
    private init() {
        startMonitoring()
    }
    
    func startMonitoring() {
        guard motionManager.isAccelerometerAvailable else { return }
        
        motionManager.accelerometerUpdateInterval = 0.2
        motionManager.startAccelerometerUpdates(to: .main) { [weak self] (data, error) in
            guard let data = data else { return }
            
            let acceleration = data.acceleration
            let threshold = 2.5 // G-force threshold for shake
            
            if abs(acceleration.x) > threshold || 
               abs(acceleration.y) > threshold || 
               abs(acceleration.z) > threshold {
                
                DispatchQueue.main.async {
                    self?.isShaking = true
                    // Reset after a short delay so it doesn't stay true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        self?.isShaking = false
                    }
                }
            }
        }
    }
    
    func stopMonitoring() {
        motionManager.stopAccelerometerUpdates()
    }
}
