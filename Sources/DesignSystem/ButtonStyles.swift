import SwiftUI

// Shared Touch-Down Scale Animation
struct ScalableButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .contentShape(Rectangle()) // Ensure entire area is tappable
            .scaleEffect(configuration.isPressed ? 0.96 : 1.0)
            .animation(Animations.cardRelease, value: configuration.isPressed)
    }
}
