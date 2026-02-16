import SwiftUI

struct LegalView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Group {
                        Text("Liability Disclaimer")
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        Text("The content provided in Revive is for **informational and educational purposes only**. It is not a substitute for professional medical advice, diagnosis, or treatment.")
                        
                        Text("Always seek the advice of your physician or other qualified health provider with any questions you may have regarding a medical condition. **Never disregard professional medical advice or delay in seeking it because of something you have read in this application.**")
                        
                        Text("Reliance on any information provided by this application is solely at your own risk. The developers of Revive assume no liability for injury or damage resulting from the use of this information.")
                        
                        Text("IN A MEDICAL EMERGENCY, CALL YOUR LOCAL EMERGENCY SERVICES IMMEDIATELY.")
                            .fontWeight(.bold)
                            .foregroundColor(.red)
                    }
                    .font(.body)
                    .foregroundColor(.primary)
                }
                .padding(24)
            }
            .navigationTitle("Legal & Safety")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}
