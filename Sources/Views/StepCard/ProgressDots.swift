import SwiftUI

struct ProgressDots: View {
    let total: Int
    let current: Int // 0-indexed
    let activeColor: Color
    
    var body: some View {
        HStack(spacing: 8) {
            ForEach(0..<total, id: \.self) { index in
                Circle()
                    .fill(index == current ? activeColor : Color.white.opacity(0.4))
                    .frame(width: index == current ? 10 : 6, height: index == current ? 10 : 6) // Scale effect
                    .animation(Animations.microsInteraction, value: current)
            }
        }
        .padding(.vertical, 20)
    }
}
