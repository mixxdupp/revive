import SwiftUI

struct SearchBar: View {
    @Binding var text: String
    var placeholder: String = "Search techniques..."
    
    var body: some View {
        HStack {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(DesignSystem.textSecondary)
                .accessibilityHidden(true)
                
                TextField(placeholder, text: $text)
                    .foregroundColor(DesignSystem.textPrimary)
                    .disableAutocorrection(true)
                
                if !text.isEmpty {
                    Button(action: {
                        text = ""
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(DesignSystem.textSecondary)
                        .accessibilityHidden(true)
                    }
                }
            }
            .padding(12)
            .background(DesignSystem.backgroundSecondary)
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
            
            if !text.isEmpty {
                Button("Cancel") {
                    UIApplication.shared.endEditing()
                    text = ""
                }
                .foregroundColor(DesignSystem.textPrimary)
                .transition(.move(edge: .trailing))
                .animation(.default, value: text.isEmpty)
            }
        }
    }
}

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
