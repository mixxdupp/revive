import SwiftUI

struct EmergencyBanner: View {
    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.title3)
                .foregroundStyle(.yellow)
            Text("Call Emergency Services if someone is unresponsive or not breathing.")
                .font(.subheadline.weight(.medium))
                .foregroundStyle(.white)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(12) // Reduced inner padding (was 16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.red.opacity(0.85))
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous)) // Reduced corner radius slightly
        .padding(.horizontal, 24)
        // Removed outer vertical padding to reduce gap
    }
}

#Preview {
    ZStack {
        Color(uiColor: .systemGroupedBackground)
        EmergencyBanner()
    }
}
