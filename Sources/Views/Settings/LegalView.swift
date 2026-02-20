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
                        
                        Text("1. NO MEDICAL ADVICE (INFORMATIONAL ONLY)")
                            .font(.headline)
                            .foregroundStyle(.red)
                        Text("The content of this app is for educational and reference purposes only. It is NOT a substitute for professional medical advice, diagnosis, or treatment. NEVER disregard professional medical advice or delay seeking it because of something you have read in this app. ALWAYS CALL EMERGENCY SERVICES (911/112/999) IN A MEDICAL EMERGENCY.")
                        
                        Text("2. COMPLETE WAIVER OF LIABILITY")
                            .font(.headline)
                            .foregroundStyle(.red)
                        Text("By using this app, you AUTOMATICALLY AND COMPLETELY WAIVE ANY AND ALL RIGHTS TO HOLD THE DEVELOPERS, CREATORS, OR CONTRIBUTORS LIABLE for any injury, loss, property damage, or death resulting from the use or misuse of the information provided herein. YOU USE THIS APP ENTIRELY AT YOUR OWN RISK.")
                        
                        Text("3. ASSUMPTION OF RISK & NO WARRANTY")
                            .font(.headline)
                        Text("Survival and medical emergencies are inherently dangerous. The developers make NO WARRANTIES, express or implied, regarding the accuracy, completeness, or effectiveness of the information provided. The app is provided 'AS IS'.")
                        
                        Text("4. OFFLINE USE & PRIVACY")
                            .font(.headline)
                        Text("This app is designed to function offline. Location services are processed entirely on-device for the Compass/GPS tools. Revive does not collect, transmit, or store personal data.")
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
