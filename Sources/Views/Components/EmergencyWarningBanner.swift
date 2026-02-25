import SwiftUI

/// A red warning banner displayed at the top of StepCardPager for life-threatening techniques.
/// Uses generic "Call Emergency Services" messaging for global audience.
struct EmergencyWarningBanner: View {
    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.white)
            .accessibilityHidden(true)
            
            VStack(alignment: .leading, spacing: 2) {
                Text("CALL EMERGENCY SERVICES FIRST")
                    .font(.system(size: 13, weight: .heavy))
                    .foregroundColor(.white)
                
                Text("Life-threatening condition. Call your local emergency number immediately.")
                    .font(.system(size: 11, weight: .medium))
                    .foregroundColor(.white.opacity(0.9))
                    .lineLimit(2)
            }
            
            Spacer(minLength: 0)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 10)
        .background(
            LinearGradient(
                colors: [Color.red, Color.red.opacity(0.85)],
                startPoint: .leading,
                endPoint: .trailing
            )
        )
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .padding(.horizontal, Layout.screenPadding)
    }
}
