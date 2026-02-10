import SwiftUI

struct BodyOutlineView: View {
    @Environment(\.dismiss) var dismiss
    
    let bodyParts: [(name: String, icon: String, techniqueIDs: [String])] = [
        ("Head", "brain.head.profile", ["firstaid-wound-cleaning", "firstaid-spinal-immobilization", "firstaid-seizure", "firstaid-nosebleed", "firstaid-stroke"]),
        ("Eye", "eye.fill", ["firstaid-eye-injury"]),
        ("Mouth / Throat", "mouth.fill", ["firstaid-heimlich", "firstaid-dental", "firstaid-poison", "firstaid-choking-infant", "firstaid-asthma"]),
        ("Chest / Torso", "heart.fill", ["firstaid-cpr", "firstaid-pressure-bandage", "firstaid-heimlich", "firstaid-impaled-object", "firstaid-electrocution", "firstaid-heart-attack", "firstaid-asthma"]),
        ("Arm / Shoulder", "figure.arms.open", ["firstaid-arm-splint", "firstaid-sling", "firstaid-tourniquet", "firstaid-dislocated-joint"]),
        ("Abdomen", "pills.fill", ["firstaid-cpr", "firstaid-heimlich", "firstaid-poison", "firstaid-childbirth"]),
        ("Hand / Wrist", "hand.raised.fill", ["firstaid-burn", "firstaid-frostbite", "firstaid-snake-bite", "firstaid-spider-bite", "firstaid-splinter"]),
        ("Leg / Knee", "figure.walk", ["firstaid-leg-splint", "firstaid-sprain", "firstaid-knee-injury", "firstaid-femur-traction"]),
        ("Foot / Ankle", "shoe.fill", ["firstaid-blister", "firstaid-trench-foot", "firstaid-sprained-ankle"]),
        ("Full Body", "figure.stand", ["firstaid-hypothermia", "firstaid-heatstroke", "firstaid-shock", "firstaid-dehydration", "firstaid-seizure", "firstaid-fever", "firstaid-allergic-reaction", "firstaid-diabetic-emergency", "firstaid-electrocution", "firstaid-drowning", "firstaid-recovery-position", "firstaid-childbirth"])
    ]
    
    let columns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]
    
    var body: some View {
        ZStack {
            DesignSystem.backgroundPrimary.edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 0) {
                // Nav Bar
                HStack {
                    Button(action: { dismiss() }) {
                        HStack(spacing: 4) {
                            Image(systemName: "chevron.left")
                            Text("Back")
                        }
                        .font(Typography.button)
                        .foregroundColor(DesignSystem.textSecondary)
                    }
                    Spacer()
                }
                .padding(.horizontal, Layout.screenPadding)
                .padding(.top, 20)
                .padding(.bottom, 10)
                
                Text("Where does it hurt?")
                    .font(Typography.emergencyTitle)
                    .foregroundColor(DesignSystem.textPrimary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, Layout.screenPadding)
                    .padding(.bottom, 20)
                
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 12) {
                        ForEach(bodyParts, id: \.name) { part in
                            NavigationLink(destination: InjuryTypeView(bodyPart: part.name, suggestedTechniqueIDs: part.techniqueIDs)) {
                                VStack(spacing: 12) {
                                    Image(systemName: part.icon)
                                        .font(.system(size: 32))
                                        .foregroundColor(.white)
                                        .frame(width: 56, height: 56)
                                        .background(
                                            LinearGradient(
                                                colors: [DesignSystem.emergencyRed, DesignSystem.emergencyRed.opacity(0.7)],
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            )
                                        )
                                        .clipShape(RoundedRectangle(cornerRadius: 14))
                                    
                                    Text(part.name)
                                        .font(Typography.headline)
                                        .foregroundColor(DesignSystem.textPrimary)
                                        .multilineTextAlignment(.center)
                                        .lineLimit(2)
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 20)
                                .padding(.horizontal, 8)
                                .background(DesignSystem.backgroundSecondary)
                                .clipShape(RoundedRectangle(cornerRadius: 16))
                            }
                            .buttonStyle(ScalableButtonStyle())
                        }
                    }
                    .padding(.horizontal, Layout.screenPadding)
                    .padding(.bottom, 30)
                }
            }
        }
        .navigationBarHidden(true)
    }
}
