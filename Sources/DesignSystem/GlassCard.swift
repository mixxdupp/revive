import SwiftUI

struct GlassCardModifier: ViewModifier {
    let material: Material
    let cornerRadius: CGFloat
    
    func body(content: Content) -> some View {
        content
            .background(material)
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
            .shadow(color: Color.black.opacity(0.15), radius: 15, x: 0, y: 5)
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .stroke(.white.opacity(0.1), lineWidth: 1)
            )
    }
}

extension View {
    func glassCard(_ material: Material = .ultraThin, cornerRadius: CGFloat = 20) -> some View {
        self.modifier(GlassCardModifier(material: material, cornerRadius: cornerRadius))
    }
}
