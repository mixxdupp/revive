import SwiftUI

struct Animations {
    static let microsInteraction = Animation.spring(response: 0.3, dampingFraction: 0.7)
    static let cardRelease = Animation.spring(response: 0.35, dampingFraction: 0.72)
    static let slideTransition = Animation.spring(response: 0.4, dampingFraction: 0.8)
    static let pulse = Animation.easeInOut(duration: 1.0).repeatForever(autoreverses: true)
}
