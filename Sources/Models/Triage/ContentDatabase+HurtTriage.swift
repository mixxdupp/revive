import Foundation

// Auto-generated: buildHurtTriage extracted from ContentDatabase.swift
extension ContentDatabase {
    // =========================================================================
    // MARK: - FIRST AID / HURT (New - Phase 2)
    // =========================================================================
    func buildHurtTriage() -> TriageNode {
        TriageNode(id: "hurt-root", question: "What is the primary injury?", options: [

            // 1. BLEEDING
            TriageOption(id: "hurt-bleeding", label: "Bleeding (Severe)", icon: "drop.fill", destination: .nextQuestion(
                TriageNode(id: "hurt-bleed-q", question: "Is it life-threatening?", options: [
                    TriageOption(id: "bleed-limb", label: "Spurting from Arm/Leg", icon: "exclamationmark.triangle.fill", destination: .technique("firstaid-tourniquet")),
                    TriageOption(id: "bleed-torso", label: "Chest / Abdomen / Neck", icon: "shield.fill", destination: .technique("firstaid-wound-packing")), // Orphan
                    TriageOption(id: "bleed-clot", label: "Won't Stop Bleeding", icon: "bandage.fill", destination: .technique("firstaid-pressure-bandage"))
                ])
            )),

            // 2.5 HEAD INJURY
            TriageOption(id: "hurt-head", label: "Head / Eye / Mouth", icon: "brain.head.profile", destination: .nextQuestion(
                TriageNode(id: "hurt-head-q", question: "What is the issue?", options: [
                    TriageOption(id: "head-concussion", label: "Hit Head / Dizziness", icon: "brain.head.profile", destination: .technique("firstaid-concussion")),
                    TriageOption(id: "head-tooth", label: "Toothache / Broken Tooth", icon: "mouth.fill", destination: .technique("firstaid-tooth-emergency")), // Added orphan
                    TriageOption(id: "head-eye", label: "Eye Injury", icon: "eye.fill", destination: .technique("firstaid-eye-injury"))
                ])
            )),

            // 2. BREATHING / CHOKING
            TriageOption(id: "hurt-airway", label: "Breathing / Choking", icon: "lungs.fill", destination: .nextQuestion(
                TriageNode(id: "hurt-choke-q", question: "Is the airway blocked?", options: [
                    TriageOption(id: "choke-adult", label: "Choking (Adult/Child)", icon: "figure.stand", destination: .technique("firstaid-heimlich")), // Orphan
                    TriageOption(id: "choke-infant", label: "Choking (Infant)", icon: "figure.baby", destination: .technique("firstaid-choking-infant")),
                ])
            )),

            // 3. FRACTURES / SPRAINS
            TriageOption(id: "hurt-bone", label: "Broken Bone / Sprain", icon: "cross.case.fill", destination: .nextQuestion(
                TriageNode(id: "hurt-bone-q", question: "Which body part?", options: [
                    TriageOption(id: "bone-leg", label: "Upper Leg / Thigh (Femur)", icon: "figure.walk", destination: .technique("firstaid-femur-traction")), // Orphan
                    TriageOption(id: "bone-arm", label: "Arm / Wrist", icon: "hand.raised.fill", destination: .technique("firstaid-arm-splint")),
                    TriageOption(id: "bone-leg-lower", label: "Lower Leg / Ankle", icon: "figure.walk", destination: .technique("firstaid-leg-splint")),
                    TriageOption(id: "bone-neck", label: "Neck / Back (Spine)", icon: "figure.stand", destination: .technique("firstaid-spinal-immobilization"))
                ])
            )),

            // 4. BITES & STINGS
            TriageOption(id: "hurt-bite", label: "Bite or Sting", icon: "ant.fill", destination: .nextQuestion(
                TriageNode(id: "hurt-bite-q", question: "What bit you?", options: [
                    TriageOption(id: "bite-snake", label: "Snake Bite", icon: "exclamationmark.triangle.fill", destination: .technique("firstaid-snake-bite")),
                    TriageOption(id: "bite-tick", label: "Tick Attached", icon: "circle.circle.fill", destination: .technique("firstaid-tick-removal")),
                ])
            )),
            
            // 5. POISON / SICKNESS
            TriageOption(id: "hurt-sick", label: "Poison / Sickness", icon: "flask.fill", destination: .nextQuestion(
                TriageNode(id: "hurt-sick-q", question: "What happened?", options: [
                    TriageOption(id: "sick-poison", label: "Swallowed Poison", icon: "skull.fill", destination: .techniqueList(["firstaid-poison", "firstaid-poison-response"])), // Added orphan
                    TriageOption(id: "sick-fever", label: "High Fever / Infection", icon: "thermometer", destination: .technique("firstaid-fever")), // Added orphan
                ])
            )),

            // 6. BURNS
            TriageOption(id: "hurt-burns", label: "Burns", icon: "flame", destination: .technique("firstaid-burn")),

            // 7. EXTREME / SURGICAL
            TriageOption(id: "hurt-extreme", label: "Extreme Measures (Last Resort)", icon: "exclamationmark.shield.fill", destination: .nextQuestion(
                TriageNode(id: "hurt-extreme-q", question: "What is the critical failure?", options: [
                    TriageOption(id: "ext-shoulder", label: "Dislocated Shoulder", icon: "figure.arms.open", destination: .technique("firstaid-shoulder-reduction")),
                    TriageOption(id: "ext-abscess", label: "Dental Abscess / Infection", icon: "mouth.fill", destination: .technique("firstaid-dental-abscess")),
                    TriageOption(id: "ext-suture", label: "Wound Needs Closing", icon: "pencil.line", destination: .technique("firstaid-superglue-suture")),
                    TriageOption(id: "ext-hack-tampon", label: "Tampon Dressing", icon: "capsule.fill", destination: .technique("firstaid-tampon-dressing")), // Phase 5
                    TriageOption(id: "ext-hack-tape", label: "Duct Tape Stitch", icon: "tape", destination: .technique("firstaid-duct-tape-butterfly")), // Phase 5
                    TriageOption(id: "ext-fishhook", label: "Fishhook Embedded", icon: "hook", destination: .technique("firstaid-fishhook-removal")),
                    TriageOption(id: "ext-amputate", label: "Trapped Limb (Amputation)", icon: "scissors", destination: .technique("firstaid-finger-amputation"))
                ])
            )),

            // 8. CHOKING (Additional)
            TriageOption(id: "hurt-choking-resp", label: "Choking Response Guide", icon: "person.fill.xmark", destination: .technique("firstaid-choking-response")),

            // 9. SEIZURE / CONVULSION
            TriageOption(id: "hurt-seizure", label: "Seizure / Convulsion", icon: "brain.fill", destination: .technique("firstaid-seizure")),

            // 9. NOSEBLEED
            TriageOption(id: "hurt-nosebleed", label: "Nosebleed", icon: "drop.fill", destination: .technique("firstaid-nosebleed")),

            // 10. HEAT ILLNESS / DEHYDRATION
            TriageOption(id: "hurt-heat", label: "Heat Illness / Dehydration", icon: "sun.max.fill", destination: .nextQuestion(
                TriageNode(id: "hurt-heat-q", question: "What are the symptoms?", options: [
                ])
            )),

            // 11. ALTITUDE SICKNESS
            TriageOption(id: "hurt-altitude", label: "Altitude Sickness", icon: "mountain.2.fill", destination: .nextQuestion(
                TriageNode(id: "hurt-alt-q", question: "How severe?", options: [
                    TriageOption(id: "alt-mild", label: "Headache / Nausea / Fatigue", icon: "exclamationmark.circle", destination: .technique("firstaid-altitude")),
                    TriageOption(id: "alt-moderate", label: "Severe Headache / Vomiting", icon: "exclamationmark.triangle.fill", destination: .technique("env-altitude-sickness")),
                    TriageOption(id: "alt-severe", label: "Confusion / Ataxia (HACE)", icon: "brain.head.profile", destination: .techniqueList(["env-mountain-altitude", "firstaid-altitude"])),
                    TriageOption(id: "alt-pulm", label: "Breathless at Rest (HAPE)", icon: "lungs.fill", destination: .techniqueList(["env-altitude-sickness", "firstaid-altitude"]))
                ])
            )),

            // 12. DIABETIC EMERGENCY
            TriageOption(id: "hurt-diabetic", label: "Diabetic Emergency", icon: "cross.vial.fill", destination: .technique("firstaid-diabetic-emergency")),

            // 13. MINOR / SURFACE INJURIES
            TriageOption(id: "hurt-minor", label: "Minor / Surface Injury", icon: "bandage.fill", destination: .nextQuestion(
                TriageNode(id: "hurt-minor-q", question: "What happened?", options: [
                    TriageOption(id: "minor-splinter", label: "Splinter / Foreign Object", icon: "pin.fill", destination: .technique("firstaid-splinter")),
                    TriageOption(id: "minor-blister", label: "Blister (Foot / Hand)", icon: "circle.fill", destination: .technique("firstaid-blister")),
                    TriageOption(id: "minor-sprain", label: "Sprain / Twisted Joint", icon: "bandage.fill", destination: .technique("firstaid-sprain")),
                    TriageOption(id: "minor-knee", label: "Knee Injury", icon: "figure.walk", destination: .technique("firstaid-knee-injury")),
                    TriageOption(id: "minor-bee", label: "Bee / Wasp Sting", icon: "ant.fill", destination: .technique("firstaid-bee-sting")),
                    TriageOption(id: "minor-dental", label: "Dental Pain / Broken Tooth", icon: "mouth.fill", destination: .technique("firstaid-dental"))
                ])
            )),

            // 14. PATIENT TRANSPORT
            TriageOption(id: "hurt-transport", label: "Moving an Injured Person", icon: "figure.2.arms.open", destination: .nextQuestion(
                TriageNode(id: "hurt-transport-q", question: "What do you need?", options: [
                    TriageOption(id: "transport-stretcher", label: "Improvised Stretcher", icon: "bed.double.fill", destination: .technique("firstaid-improvised-stretcher")),
                    TriageOption(id: "transport-litter", label: "Improvised Litter (Poles)", icon: "rectangle.fill", destination: .technique("rescue-improvised-litter")),
                    TriageOption(id: "transport-sling", label: "Arm Sling", icon: "hand.raised.fill", destination: .technique("firstaid-sling")),
                    TriageOption(id: "transport-nerve", label: "Check Nerve / Circulation", icon: "waveform.path.ecg", destination: .technique("firstaid-nerve-assessment")),
                    TriageOption(id: "transport-bleed-adv", label: "Advanced Bleeding Control", icon: "cross.case.fill", destination: .technique("firstaid-bleeding-control-advanced"))
                ])
            )),

            // 15. ABDOMINAL INJURY
            TriageOption(id: "hurt-abdomen", label: "Abdominal Injury", icon: "figure.arms.open", destination: .technique("firstaid-abdominal-injury")),

            // 16. PSYCHOLOGICAL CRISIS
            TriageOption(id: "hurt-psych", label: "Psychological Crisis", icon: "brain.head.profile", destination: .nextQuestion(
                TriageNode(id: "hurt-psych-q", question: "What's happening?", options: [
                    TriageOption(id: "psych-crisis-panic", label: "Panic Attack", icon: "wind", destination: .techniqueList(["psych-combat-breathing", "firstaid-hyperventilation"])),
                    TriageOption(id: "psych-crisis-fear", label: "Paralyzed by Fear", icon: "exclamationmark.circle", destination: .technique("psych-fear-management")),
                    TriageOption(id: "psych-crisis-aid", label: "Helping Someone in Crisis", icon: "person.2.fill", destination: .technique("firstaid-psychological-aid")),
                    TriageOption(id: "psych-crisis-will", label: "Giving Up / Loss of Will", icon: "heart.slash.fill", destination: .technique("psych-will-to-live"))
                ])
            )),

            // 17. WOUND INFECTION
            TriageOption(id: "hurt-infection", label: "Wound Infection (Red/Swollen)", icon: "exclamationmark.triangle.fill", destination: .technique("firstaid-infection-management")),

            // 18. RIB INJURY
            TriageOption(id: "hurt-rib", label: "Rib Injury / Chest Pain", icon: "lungs.fill", destination: .technique("firstaid-rib-fracture")),

            // 19. DENTAL EMERGENCY
            TriageOption(id: "hurt-dental-emerg", label: "Dental Emergency", icon: "mouth.fill", destination: .technique("firstaid-dental-emergency")),

            // 20. TRENCH FOOT

            // 21. EYE INJURY

            // 📚 LEARN MORE
            TriageOption(id: "hurt-learn", label: "Learn More", icon: "book.fill", destination: .nextQuestion(
                TriageNode(id: "hurt-learn-q", question: "What would you like to read about?", options: [
                    TriageOption(id: "hurt-art-priorities", label: "First Aid Priorities", icon: "list.number", destination: .article("firstaid-article-priorities")),
                    TriageOption(id: "hurt-art-trauma", label: "Trauma Assessment", icon: "stethoscope", destination: .article("firstaid-article-trauma-assessment")),
                    TriageOption(id: "hurt-art-bleeding", label: "Bleeding Control", icon: "drop.fill", destination: .article("firstaid-article-bleeding")),
                    TriageOption(id: "hurt-art-airway", label: "Airway Management", icon: "wind", destination: .article("firstaid-article-airway")),
                    TriageOption(id: "hurt-art-cpr", label: "CPR Basics", icon: "heart.fill", destination: .article("firstaid-article-cpr-basics")),
                    TriageOption(id: "hurt-art-fractures", label: "Fractures & Splinting", icon: "bandage.fill", destination: .article("firstaid-article-fractures")),
                    TriageOption(id: "hurt-art-burns", label: "Burns Treatment", icon: "flame", destination: .article("firstaid-article-burns")),
                    TriageOption(id: "hurt-art-bites", label: "Bites & Stings", icon: "ant.fill", destination: .article("firstaid-article-bites")),
                    TriageOption(id: "hurt-art-anaphylaxis", label: "Anaphylaxis", icon: "exclamationmark.triangle.fill", destination: .article("firstaid-article-anaphylaxis")),
                    TriageOption(id: "hurt-art-crush", label: "Crush Syndrome", icon: "rectangle.compress.vertical", destination: .article("firstaid-article-crush-syndrome")),
                    TriageOption(id: "hurt-art-env", label: "Environmental Emergencies", icon: "thermometer.sun.fill", destination: .articleList(["firstaid-article-environmental", "firstaid-article-environmental-emergencies"])),
                    TriageOption(id: "hurt-art-infection", label: "Infection Prevention", icon: "microbe.fill", destination: .article("firstaid-article-infection")),
                    TriageOption(id: "hurt-art-improvised", label: "Improvised Medical Supplies", icon: "cross.case.fill", destination: .article("firstaid-article-improvised")),
                    TriageOption(id: "hurt-art-kit", label: "First Aid Kit Building", icon: "bag.fill", destination: .article("firstaid-article-kit")),
                    TriageOption(id: "hurt-art-field-pharm", label: "Field Pharmacy", icon: "pills.fill", destination: .article("firstaid-article-field-pharmacy")),
                    TriageOption(id: "hurt-art-pediatric", label: "Pediatric First Aid", icon: "figure.and.child.holdinghands", destination: .article("firstaid-article-pediatric"))
                ])
            )),

            TriageOption(id: "g941", label: "Assessment", icon: "list.bullet.clipboard.fill", destination: .nextQuestion(
                TriageNode(id: "g941-q", question: "What specifically?", options: [
                TriageOption(id: "g942", label: "Wound", icon: "drop.fill", destination: .nextQuestion(
                    TriageNode(id: "g942-q", question: "Select:", options: [
                        TriageOption(id: "g943", label: "Auerbach protocols for managing a black widow spider bi", icon: "drop.fill", destination: .technique("firstaid-encyclopedia-arid-black")),
                        TriageOption(id: "g944", label: "Auerbach protocols for managing a brown recluse bite in", icon: "drop.fill", destination: .technique("firstaid-encyclopedia-arid-brown")),
                        TriageOption(id: "g945", label: "Auerbach protocols for managing a cactus spine embedded", icon: "drop.fill", destination: .technique("firstaid-encyclopedia-arid-cactus")),
                        TriageOption(id: "g946", label: "Auerbach protocols for managing a flash flood laceratio", icon: "drop.fill", destination: .technique("firstaid-encyclopedia-arid-flash")),
                        TriageOption(id: "g947", label: "Auerbach protocols for managing a scorpion sting in the", icon: "drop.fill", destination: .technique("firstaid-encyclopedia-arid-scorpion"))
                    ])
                )),
                TriageOption(id: "g948", label: "Assessment", icon: "list.bullet.clipboard.fill", destination: .nextQuestion(
                    TriageNode(id: "g948-q", question: "Select:", options: [
                        TriageOption(id: "g949", label: "Rapid systematic assessment of a critically injured pat", icon: "lungs.fill", destination: .technique("firstaid-primary-survey")),
                        TriageOption(id: "g950", label: "Evaluate abdominal injury severity in the field", icon: "list.bullet.clipboard.fill", destination: .technique("firstaid-abdominal-assessment")),
                        TriageOption(id: "g951", label: "Assess hypothermia or hyperthermia severity without a t", icon: "snowflake", destination: .technique("firstaid-rectal-temp-assessment")),
                        TriageOption(id: "g952", label: "Estimate blood pressure without equipment", icon: "list.bullet.clipboard.fill", destination: .technique("firstaid-blood-pressure-field")),
                        TriageOption(id: "g953", label: "Determine if spinal immobilization is needed", icon: "list.bullet.clipboard.fill", destination: .technique("firstaid-spine-clearing-field")),
                        TriageOption(id: "g954", label: "Systematic trauma assessment in the field", icon: "drop.fill", destination: .technique("firstaid-rapid-trauma-survey"))
                    ])
                )),
                TriageOption(id: "g955", label: "Check", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g955-q", question: "Select:", options: [
                        TriageOption(id: "g956", label: "The critical diagnostic line separating rest and immedi", icon: "brain.head.profile", destination: .technique("firstaid-heat-exhaustion-stroke")),
                        TriageOption(id: "g957", label: "Accurate hypothermia staging via core temp", icon: "snowflake", destination: .technique("firstaid-rectal-thermometer-field"))
                    ])
                )),
                TriageOption(id: "g958", label: "Walk", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g958-q", question: "Select:", options: [
                        TriageOption(id: "g959", label: "Advanced mass casualty sorting — wave method", icon: "list.bullet.clipboard.fill", destination: .technique("firstaid-salt-triage")),
                        TriageOption(id: "g960", label: "Simple Triage and Rapid Treatment for multiple victims", icon: "list.bullet.clipboard.fill", destination: .technique("firstaid-mass-casualty-start")),
                        TriageOption(id: "g961", label: "Sort multiple casualties in 30 seconds each", icon: "drop.fill", destination: .technique("firstaid-start-triage"))
                    ])
                )),
                TriageOption(id: "g962", label: "Heat", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g962-q", question: "Select:", options: [
                        TriageOption(id: "g963", label: "Clinical presentation and field management for heat cra", icon: "cross.case.fill", destination: .technique("firstaid-encyclopedia-heat-heat")),
                        TriageOption(id: "g964", label: "Clinical presentation and field management for sunburn.", icon: "flame.fill", destination: .technique("firstaid-encyclopedia-heat-sunburn"))
                    ])
                )),
                TriageOption(id: "g965", label: "Survey", icon: "list.bullet.clipboard.fill", destination: .nextQuestion(
                    TriageNode(id: "g965-q", question: "Select:", options: [
                        TriageOption(id: "g966", label: "Resuscitation protocol for extricated avalanche victims", icon: "lungs.fill", destination: .technique("firstaid-avalanche-burial-recovery")),
                        TriageOption(id: "g967", label: "Taking and recording vital signs in the field", icon: "heart.fill", destination: .technique("firstaid-vital-signs")),
                        TriageOption(id: "g968", label: "The critical NOLS decision matrix for freezing tissue.", icon: "ant.fill", destination: .technique("firstaid-frostbite-thaw-decision")),
                        TriageOption(id: "g969", label: "Plants and techniques that deter mosquitoes and ticks", icon: "leaf.fill", destination: .technique("firstaid-insect-repellent-natural")),
                        TriageOption(id: "g970", label: "Systematic physical examination after primary survey is", icon: "list.bullet.clipboard.fill", destination: .technique("firstaid-secondary-survey"))
                    ])
                )),
                TriageOption(id: "g971", label: "Viper", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g971-q", question: "Select:", options: [
                        TriageOption(id: "g972", label: "Managing bites from Rattlesnakes, Copperheads, and Cott", icon: "ant.fill", destination: .technique("firstaid-pit-viper-bite")),
                        TriageOption(id: "g973", label: "Treating massive sodium depletion from extreme sweating", icon: "exclamationmark.triangle.fill", destination: .technique("firstaid-hyponatremia"))
                    ])
                ))
                ])
            )),

            TriageOption(id: "g974", label: "Bites & Stings", icon: "ant.fill", destination: .nextQuestion(
                TriageNode(id: "g974-q", question: "What specifically?", options: [
                TriageOption(id: "g975", label: "Venom", icon: "ant.fill", destination: .nextQuestion(
                    TriageNode(id: "g975-q", question: "Select:", options: [
                        TriageOption(id: "g976", label: "Neurotoxic venom management", icon: "ant.fill", destination: .technique("firstaid-spider-bite-widow")),
                        TriageOption(id: "g977", label: "Cytotoxic venom management", icon: "ant.fill", destination: .technique("firstaid-spider-bite-recluse")),
                        TriageOption(id: "g978", label: "Neurotoxic venom — different protocol from pit vipers", icon: "ant.fill", destination: .technique("firstaid-snakebite-coral")),
                        TriageOption(id: "g979", label: "Apply pressure immobilization for neurotoxic snake bite", icon: "drop.fill", destination: .technique("firstaid-snake-bite-pressure-immobilization")),
                        TriageOption(id: "g980", label: "Neutralize marine venom using extreme heat", icon: "ant.fill", destination: .technique("firstaid-stingray-hot-water"))
                    ])
                )),
                TriageOption(id: "g981", label: "Jellyfish", icon: "fish.fill", destination: .nextQuestion(
                    TriageNode(id: "g981-q", question: "Select:", options: [
                        TriageOption(id: "g982", label: "Clinical protocol for the diagnosis phase of Jellyfish ", icon: "ant.fill", destination: .technique("firstaid-encyclopedia-jellyfish-envenomation-nematocysts-diagnosis")),
                        TriageOption(id: "g983", label: "Clinical protocol for the evacuation criteria phase of ", icon: "ant.fill", destination: .technique("firstaid-encyclopedia-jellyfish-envenomation-nematocysts-evacuation-criteria")),
                        TriageOption(id: "g984", label: "Clinical protocol for the field treatment phase of Jell", icon: "ant.fill", destination: .technique("firstaid-encyclopedia-jellyfish-envenomation-nematocysts-field-treatment")),
                        TriageOption(id: "g985", label: "Clinical protocol for the initial stabilization phase o", icon: "ant.fill", destination: .technique("firstaid-encyclopedia-jellyfish-envenomation-nematocysts-initial-stabilization")),
                        TriageOption(id: "g986", label: "Deactivate nematocysts with acid", icon: "ant.fill", destination: .technique("firstaid-jellyfish-vinegar"))
                    ])
                )),
                TriageOption(id: "g987", label: "Identify", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g987-q", question: "Select:", options: [
                        TriageOption(id: "g988", label: "Managing severe neurotoxic spider bites", icon: "ant.fill", destination: .technique("firstaid-black-widow-bite")),
                        TriageOption(id: "g989", label: "Immediate actions following a bite from a high-risk mam", icon: "ant.fill", destination: .technique("firstaid-expert-rabies-exposure"))
                    ])
                )),
                TriageOption(id: "g990", label: "Recluse", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g990-q", question: "Select:", options: [
                        TriageOption(id: "g991", label: "Clinical protocol for the diagnosis phase of Brown Recl", icon: "ant.fill", destination: .technique("firstaid-encyclopedia-brown-recluse-bite-diagnosis")),
                        TriageOption(id: "g992", label: "Clinical protocol for the evacuation criteria phase of ", icon: "ant.fill", destination: .technique("firstaid-encyclopedia-brown-recluse-bite-evacuation-criteria")),
                        TriageOption(id: "g993", label: "Clinical protocol for the field treatment phase of Brow", icon: "ant.fill", destination: .technique("firstaid-encyclopedia-brown-recluse-bite-field-treatment")),
                        TriageOption(id: "g994", label: "Clinical protocol for the initial stabilization phase o", icon: "ant.fill", destination: .technique("firstaid-encyclopedia-brown-recluse-bite-initial-stabilization"))
                    ])
                )),
                TriageOption(id: "g995", label: "Scorpion", icon: "ant.fill", destination: .nextQuestion(
                    TriageNode(id: "g995-q", question: "Select:", options: [
                        TriageOption(id: "g996", label: "Clinical protocol for the diagnosis phase of Scorpion S", icon: "ant.fill", destination: .technique("firstaid-encyclopedia-scorpion-sting-centruroides-diagnosis")),
                        TriageOption(id: "g997", label: "Clinical protocol for the evacuation criteria phase of ", icon: "ant.fill", destination: .technique("firstaid-encyclopedia-scorpion-sting-centruroides-evacuation-criteria")),
                        TriageOption(id: "g998", label: "Clinical protocol for the field treatment phase of Scor", icon: "ant.fill", destination: .technique("firstaid-encyclopedia-scorpion-sting-centruroides-field-treatment")),
                        TriageOption(id: "g999", label: "Clinical protocol for the initial stabilization phase o", icon: "ant.fill", destination: .technique("firstaid-encyclopedia-scorpion-sting-centruroides-initial-stabilization")),
                        TriageOption(id: "g1000", label: "Field management of scorpion envenomation", icon: "ant.fill", destination: .technique("firstaid-scorpion-sting"))
                    ])
                )),
                TriageOption(id: "g1001", label: "Envenomation", icon: "ant.fill", destination: .nextQuestion(
                    TriageNode(id: "g1001-q", question: "Select:", options: [
                        TriageOption(id: "g1002", label: "Using charcoal to absorb ingested toxins", icon: "exclamationmark.triangle.fill", destination: .technique("firstaid-charcoal-ingestion")),
                        TriageOption(id: "g1003", label: "Emergency response to tetrodotoxin envenomation", icon: "ant.fill", destination: .technique("firstaid-blue-ring-octopus")),
                        TriageOption(id: "g1004", label: "Managing the painful envenomation from large centipedes", icon: "ant.fill", destination: .technique("firstaid-centipede-bite")),
                        TriageOption(id: "g1005", label: "Emergency treatment for cone snail stings", icon: "ant.fill", destination: .technique("firstaid-cone-snail")),
                        TriageOption(id: "g1006", label: "Extracting embedded spines from hands and feet", icon: "figure.stand", destination: .technique("firstaid-sea-urchin"))
                    ])
                )),
                TriageOption(id: "g1007", label: "Viper", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g1007-q", question: "Select:", options: [
                        TriageOption(id: "g1008", label: "The definitive treatment for life-threatening allergic ", icon: "bolt.fill", destination: .technique("firstaid-expert-anaphylaxis-epinephrine")),
                        TriageOption(id: "g1009", label: "Clinical protocol for the diagnosis phase of Pit Viper ", icon: "ant.fill", destination: .technique("firstaid-encyclopedia-pit-viper-envenomation-diagnosis")),
                        TriageOption(id: "g1010", label: "Clinical protocol for the field treatment phase of Pit ", icon: "ant.fill", destination: .technique("firstaid-encyclopedia-pit-viper-envenomation-field-treatment")),
                        TriageOption(id: "g1011", label: "Clinical protocol for the initial stabilization phase o", icon: "ant.fill", destination: .technique("firstaid-encyclopedia-pit-viper-envenomation-initial-stabilization")),
                        TriageOption(id: "g1012", label: "North American venomous snake protocol", icon: "ant.fill", destination: .technique("firstaid-snakebite-pit-viper"))
                    ])
                )),
                TriageOption(id: "g1013", label: "Poison", icon: "exclamationmark.triangle.fill", destination: .nextQuestion(
                    TriageNode(id: "g1013-q", question: "Select:", options: [
                        TriageOption(id: "g1014", label: "Clinical protocol for the evacuation criteria phase of ", icon: "ant.fill", destination: .technique("firstaid-encyclopedia-pit-viper-envenomation-evacuation-criteria")),
                        TriageOption(id: "g1015", label: "Clinical protocol for the diagnosis phase of Poison Ivy", icon: "exclamationmark.triangle.fill", destination: .technique("firstaid-encyclopedia-poison-ivy-oak-sumac-diagnosis")),
                        TriageOption(id: "g1016", label: "Clinical protocol for the evacuation criteria phase of ", icon: "figure.walk.motion", destination: .technique("firstaid-encyclopedia-poison-ivy-oak-sumac-evacuation-criteria")),
                        TriageOption(id: "g1017", label: "Clinical protocol for the field treatment phase of Pois", icon: "exclamationmark.triangle.fill", destination: .technique("firstaid-encyclopedia-poison-ivy-oak-sumac-field-treatment")),
                        TriageOption(id: "g1018", label: "Clinical protocol for the initial stabilization phase o", icon: "exclamationmark.triangle.fill", destination: .technique("firstaid-encyclopedia-poison-ivy-oak-sumac-initial-stabilization"))
                    ])
                ))
                ])
            )),

            TriageOption(id: "g1019", label: "Bleeding & Wounds", icon: "drop.fill", destination: .nextQuestion(
                TriageNode(id: "g1019-q", question: "What specifically?", options: [
                TriageOption(id: "g1020", label: "Management", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g1020-q", question: "Select:", options: [
                        TriageOption(id: "g1021", label: "Handle exposed abdominal organs in the field", icon: "cross.case.fill", destination: .technique("firstaid-abdominal-evisceration")),
                        TriageOption(id: "g1022", label: "Preventing renal failure after prolonged entrapment", icon: "list.bullet.clipboard.fill", destination: .technique("firstaid-crush-syndrome-management")),
                        TriageOption(id: "g1023", label: "Stabilize a segment of broken ribs", icon: "bandage.fill", destination: .technique("firstaid-flail-chest")),
                        TriageOption(id: "g1024", label: "Axilla, groin, and neck bleed management", icon: "drop.fill", destination: .technique("firstaid-hemostatic-junctional")),
                        TriageOption(id: "g1025", label: "Stabilize a suspected broken pelvis", icon: "bandage.fill", destination: .technique("firstaid-pelvic-fracture"))
                    ])
                )),
                TriageOption(id: "g1026", label: "Groin", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g1026-q", question: "Select:", options: [
                        TriageOption(id: "g1027", label: "Control severe leg bleeding using pressure points", icon: "drop.fill", destination: .technique("firstaid-femoral-pressure")),
                        TriageOption(id: "g1028", label: "Stabilize a pelvic fracture — prevent lethal internal h", icon: "drop.fill", destination: .technique("firstaid-pelvic-fracture-wrap")),
                        TriageOption(id: "g1029", label: "Bleeding at neck, armpit, or groin — can't tourniquet t", icon: "drop.fill", destination: .technique("firstaid-junctional-hemorrhage"))
                    ])
                )),
                TriageOption(id: "g1030", label: "Clean", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g1030-q", question: "Select:", options: [
                        TriageOption(id: "g1031", label: "Closing a laceration without sutures", icon: "drop.fill", destination: .technique("firstaid-wound-closure-strips")),
                        TriageOption(id: "g1032", label: "Close wounds using butterfly strips or improvised sutur", icon: "drop.fill", destination: .technique("firstaid-field-sutures")),
                        TriageOption(id: "g1033", label: "Creating suction wound closure in the field", icon: "drop.fill", destination: .technique("firstaid-wound-vac-improvised")),
                        TriageOption(id: "g1034", label: "Pressure-flush debris from wounds", icon: "drop.fill", destination: .technique("firstaid-wound-irrigation"))
                    ])
                )),
                TriageOption(id: "g1035", label: "Severe", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g1035-q", question: "Select:", options: [
                        TriageOption(id: "g1036", label: "Combat gauze and clotting agent use for severe bleeding", icon: "drop.fill", destination: .technique("firstaid-hemostatic-agents")),
                        TriageOption(id: "g1037", label: "Stopping epistaxis in the field", icon: "drop.fill", destination: .technique("firstaid-nosebleed-field")),
                        TriageOption(id: "g1038", label: "Life-threatening air pressure buildup in chest — recogn", icon: "lungs.fill", destination: .technique("firstaid-tension-pneumo-recognition")),
                        TriageOption(id: "g1039", label: "Manage a severed body part in the field", icon: "drop.fill", destination: .technique("firstaid-traumatic-amputation"))
                    ])
                )),
                TriageOption(id: "g1040", label: "Pneumothorax", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g1040-q", question: "Select:", options: [
                        TriageOption(id: "g1041", label: "Burping a vented chest seal", icon: "lungs.fill", destination: .technique("firstaid-chest-seal-burp")),
                        TriageOption(id: "g1042", label: "Open pneumothorax — seal with occlusive dressing", icon: "drop.fill", destination: .technique("firstaid-sucking-chest-wound")),
                        TriageOption(id: "g1043", label: "Identifying a lethal collapsed lung building pressure i", icon: "lungs.fill", destination: .technique("firstaid-expert-tension-pneumothorax")),
                        TriageOption(id: "g1044", label: "Identify life-threatening air pressure in the chest", icon: "lungs.fill", destination: .technique("firstaid-tension-pneumo"))
                    ])
                )),
                TriageOption(id: "g1045", label: "Wound", icon: "drop.fill", destination: .nextQuestion(
                    TriageNode(id: "g1045-q", question: "Select:", options: [
                        TriageOption(id: "g1046", label: "Immobilize any fracture with available materials", icon: "bandage.fill", destination: .technique("firstaid-splint-basics")),
                        TriageOption(id: "g1047", label: "Immobilize a knee injury in the field", icon: "bandage.fill", destination: .technique("firstaid-knee-stabilization")),
                        TriageOption(id: "g1048", label: "Handle torn or lost fingernails and toenails", icon: "cross.case.fill", destination: .technique("firstaid-nail-bed-injury")),
                        TriageOption(id: "g1049", label: "Seal an open chest wound to restore breathing", icon: "drop.fill", destination: .technique("firstaid-sucking-chest-dressing")),
                        TriageOption(id: "g1050", label: "Identify and manage wound infections early", icon: "drop.fill", destination: .technique("firstaid-infection-signs"))
                    ])
                )),
                TriageOption(id: "g1051", label: "Wound (2)", icon: "drop.fill", destination: .nextQuestion(
                    TriageNode(id: "g1051-q", question: "Select:", options: [
                        TriageOption(id: "g1052", label: "Prevent wound infections without medical supplies", icon: "drop.fill", destination: .technique("firstaid-infection-prevention-field")),
                        TriageOption(id: "g1053", label: "Stopping massive arterial hemorrhage with field materia", icon: "drop.fill", destination: .technique("firstaid-tourniquet-field")),
                        TriageOption(id: "g1054", label: "Remove an embedded barbed fish hook", icon: "fish.fill", destination: .technique("firstaid-fishhook-string-yank")),
                        TriageOption(id: "g1055", label: "Sealing a penetrating chest injury to prevent lung coll", icon: "drop.fill", destination: .technique("firstaid-sucking-chest-seal")),
                        TriageOption(id: "g1056", label: "Stop bleeding with natural clotting materials", icon: "drop.fill", destination: .technique("firstaid-blood-clotting-agents"))
                    ])
                )),
                TriageOption(id: "g1057", label: "Wound (3)", icon: "drop.fill", destination: .nextQuestion(
                    TriageNode(id: "g1057-q", question: "Select:", options: [
                        TriageOption(id: "g1058", label: "Primary, secondary, tertiary blast injury triage", icon: "list.bullet.clipboard.fill", destination: .technique("firstaid-blast-injury-primary")),
                        TriageOption(id: "g1059", label: "Hemostatic gauze application for deep wounds", icon: "drop.fill", destination: .technique("firstaid-combat-gauze-packing")),
                        TriageOption(id: "g1060", label: "Stop massive junctional hemorrhage", icon: "drop.fill", destination: .technique("firstaid-hemostatic-packing")),
                        TriageOption(id: "g1061", label: "Securing penetrating objects in place", icon: "fish.fill", destination: .technique("firstaid-impaled-object-stabilize")),
                        TriageOption(id: "g1062", label: "Stabilize a shattered pelvis", icon: "bandage.fill", destination: .technique("firstaid-pelvic-binder-improvised"))
                    ])
                )),
                TriageOption(id: "g1063", label: "Chest", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g1063-q", question: "Select:", options: [
                        TriageOption(id: "g1064", label: "Catastrophic limb hemorrhage — apply before assessing w", icon: "drop.fill", destination: .technique("firstaid-hemostatic-tourniquet-high-tight")),
                        TriageOption(id: "g1065", label: "Emergency blood typing for buddy transfusion", icon: "cross.case.fill", destination: .technique("firstaid-field-blood-transfusion-prep")),
                        TriageOption(id: "g1066", label: "Multiple rib fractures with paradoxical breathing", icon: "bandage.fill", destination: .technique("firstaid-flail-chest-management")),
                        TriageOption(id: "g1067", label: "Seal penetrating chest wound with everyday items", icon: "drop.fill", destination: .technique("firstaid-chest-seal-improvised")),
                        TriageOption(id: "g1068", label: "Manage a severed body part and the patient", icon: "drop.fill", destination: .technique("firstaid-field-amputation-care"))
                    ])
                )),
                TriageOption(id: "g1069", label: "Bleeding", icon: "drop.fill", destination: .nextQuestion(
                    TriageNode(id: "g1069-q", question: "Select:", options: [
                        TriageOption(id: "g1070", label: "Correct deployment for massive extremity hemorrhage.", icon: "drop.fill", destination: .technique("firstaid-expert-tourniquet-application")),
                        TriageOption(id: "g1071", label: "Managing paradoxical chest wall movement from multiple ", icon: "bandage.fill", destination: .technique("firstaid-expert-flail-chest")),
                        TriageOption(id: "g1072", label: "Clinical protocol for the diagnosis phase of Laceration", icon: "drop.fill", destination: .technique("firstaid-encyclopedia-laceration-with-heavy-bleeding-diagnosis")),
                        TriageOption(id: "g1073", label: "Clinical protocol for the field treatment phase of Lace", icon: "drop.fill", destination: .technique("firstaid-encyclopedia-laceration-with-heavy-bleeding-field-treatment")),
                        TriageOption(id: "g1074", label: "Clinical protocol for the initial stabilization phase o", icon: "drop.fill", destination: .technique("firstaid-encyclopedia-laceration-with-heavy-bleeding-initial-stabilization"))
                    ])
                )),
                TriageOption(id: "g1075", label: "Puncture", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g1075-q", question: "Select:", options: [
                        TriageOption(id: "g1076", label: "Clinical protocol for the evacuation criteria phase of ", icon: "drop.fill", destination: .technique("firstaid-encyclopedia-laceration-with-heavy-bleeding-evacuation-criteria")),
                        TriageOption(id: "g1077", label: "Clinical protocol for the diagnosis phase of Puncture W", icon: "drop.fill", destination: .technique("firstaid-encyclopedia-puncture-wound-nail-thorn-diagnosis")),
                        TriageOption(id: "g1078", label: "Clinical protocol for the evacuation criteria phase of ", icon: "drop.fill", destination: .technique("firstaid-encyclopedia-puncture-wound-nail-thorn-evacuation-criteria")),
                        TriageOption(id: "g1079", label: "Clinical protocol for the field treatment phase of Punc", icon: "drop.fill", destination: .technique("firstaid-encyclopedia-puncture-wound-nail-thorn-field-treatment")),
                        TriageOption(id: "g1080", label: "Clinical protocol for the initial stabilization phase o", icon: "drop.fill", destination: .technique("firstaid-encyclopedia-puncture-wound-nail-thorn-initial-stabilization"))
                    ])
                )),
                TriageOption(id: "g1081", label: "Infected", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g1081-q", question: "Select:", options: [
                        TriageOption(id: "g1082", label: "Clinical protocol for the diagnosis phase of Fish Hook ", icon: "fish.fill", destination: .technique("firstaid-encyclopedia-fish-hook-removal-diagnosis")),
                        TriageOption(id: "g1083", label: "Clinical protocol for the diagnosis phase of Infected A", icon: "cross.case.fill", destination: .technique("firstaid-encyclopedia-infected-abscess-diagnosis")),
                        TriageOption(id: "g1084", label: "Clinical protocol for the evacuation criteria phase of ", icon: "cross.case.fill", destination: .technique("firstaid-encyclopedia-infected-abscess-evacuation-criteria")),
                        TriageOption(id: "g1085", label: "Clinical protocol for the field treatment phase of Infe", icon: "cross.case.fill", destination: .technique("firstaid-encyclopedia-infected-abscess-field-treatment")),
                        TriageOption(id: "g1086", label: "Clinical protocol for the initial stabilization phase o", icon: "cross.case.fill", destination: .technique("firstaid-encyclopedia-infected-abscess-initial-stabilization"))
                    ])
                )),
                TriageOption(id: "g1087", label: "Stabilization", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g1087-q", question: "Select:", options: [
                        TriageOption(id: "g1088", label: "Clinical protocol for the evacuation criteria phase of ", icon: "figure.walk.motion", destination: .technique("firstaid-encyclopedia-fish-hook-removal-evacuation-criteria")),
                        TriageOption(id: "g1089", label: "Clinical protocol for the field treatment phase of Fish", icon: "fish.fill", destination: .technique("firstaid-encyclopedia-fish-hook-removal-field-treatment")),
                        TriageOption(id: "g1090", label: "Clinical protocol for the initial stabilization phase o", icon: "fish.fill", destination: .technique("firstaid-encyclopedia-fish-hook-removal-initial-stabilization")),
                        TriageOption(id: "g1091", label: "Clinical protocol for the diagnosis phase of Impaled Ob", icon: "cross.case.fill", destination: .technique("firstaid-encyclopedia-impaled-object-stabilization-diagnosis")),
                        TriageOption(id: "g1092", label: "Clinical protocol for the initial stabilization phase o", icon: "cross.case.fill", destination: .technique("firstaid-encyclopedia-impaled-object-stabilization-initial-stabilization"))
                    ])
                )),
                TriageOption(id: "g1093", label: "Impaled", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g1093-q", question: "Select:", options: [
                        TriageOption(id: "g1094", label: "Clinical protocol for the evacuation criteria phase of ", icon: "figure.walk.motion", destination: .technique("firstaid-encyclopedia-impaled-object-stabilization-evacuation-criteria")),
                        TriageOption(id: "g1095", label: "Clinical protocol for the field treatment phase of Impa", icon: "cross.case.fill", destination: .technique("firstaid-encyclopedia-impaled-object-stabilization-field-treatment"))
                    ])
                ))
                ])
            )),

            TriageOption(id: "g1096", label: "Breathing Problems", icon: "lungs.fill", destination: .nextQuestion(
                TriageNode(id: "g1096-q", question: "What specifically?", options: [
                TriageOption(id: "g1097", label: "Breathing", icon: "lungs.fill", destination: .nextQuestion(
                    TriageNode(id: "g1097-q", question: "Select:", options: [
                        TriageOption(id: "g1098", label: "Open an obstructed airway manually", icon: "lungs.fill", destination: .technique("firstaid-cricothyrotomy-prep")),
                        TriageOption(id: "g1099", label: "Managing circulatory shock in the field", icon: "bolt.fill", destination: .technique("firstaid-shock-treatment"))
                    ])
                )),
                TriageOption(id: "g1100", label: "Victim", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g1100-q", question: "Select:", options: [
                        TriageOption(id: "g1101", label: "Open airway without spinal movement", icon: "lungs.fill", destination: .technique("firstaid-airway-jaw-thrust")),
                        TriageOption(id: "g1102", label: "Abdominal thrusts for a conscious choking victim", icon: "lungs.fill", destination: .technique("firstaid-choking-heimlich"))
                    ])
                )),
                TriageOption(id: "g1103", label: "Unconscious", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g1103-q", question: "Select:", options: [
                        TriageOption(id: "g1104", label: "NPA insertion for unconscious patients", icon: "lungs.fill", destination: .technique("firstaid-nasopharyngeal-airway")),
                        TriageOption(id: "g1105", label: "Maintaining airway in unconscious patients", icon: "lungs.fill", destination: .technique("firstaid-opa-insertion"))
                    ])
                )),
                TriageOption(id: "g1106", label: "Decompression", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g1106-q", question: "Select:", options: [
                        TriageOption(id: "g1107", label: "Emergency chest decompression without needle", icon: "scissors", destination: .technique("firstaid-finger-thoracostomy")),
                        TriageOption(id: "g1108", label: "Emergency tension pneumothorax relief", icon: "scissors", destination: .technique("firstaid-needle-decompression"))
                    ])
                )),
                TriageOption(id: "g1109", label: "Tamponade", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g1109-q", question: "Select:", options: [
                        TriageOption(id: "g1110", label: "Manage bronchospasm without medication", icon: "lungs.fill", destination: .technique("firstaid-asthma-field")),
                        TriageOption(id: "g1111", label: "Beck's Triad identification in trauma", icon: "heart.fill", destination: .technique("firstaid-pericardiocentesis-signs")),
                        TriageOption(id: "g1112", label: "Creating a flutter valve for open pneumothorax", icon: "bandage.fill", destination: .technique("firstaid-sucking-chest-3sided"))
                    ])
                ))
                ])
            )),

            TriageOption(id: "g1113", label: "Broken Bones", icon: "bandage.fill", destination: .nextQuestion(
                TriageNode(id: "g1113-q", question: "What specifically?", options: [
                TriageOption(id: "g1114", label: "Shoulder", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g1114-q", question: "Select:", options: [
                        TriageOption(id: "g1115", label: "Clinical protocol for the diagnosis phase of Shoulder D", icon: "bandage.fill", destination: .technique("firstaid-encyclopedia-shoulder-dislocation-anterior-diagnosis")),
                        TriageOption(id: "g1116", label: "Clinical protocol for the evacuation criteria phase of ", icon: "bandage.fill", destination: .technique("firstaid-encyclopedia-shoulder-dislocation-anterior-evacuation-criteria")),
                        TriageOption(id: "g1117", label: "Clinical protocol for the field treatment phase of Shou", icon: "bandage.fill", destination: .technique("firstaid-encyclopedia-shoulder-dislocation-anterior-field-treatment")),
                        TriageOption(id: "g1118", label: "Clinical protocol for the initial stabilization phase o", icon: "bandage.fill", destination: .technique("firstaid-encyclopedia-shoulder-dislocation-anterior-initial-stabilization")),
                        TriageOption(id: "g1119", label: "Relocating a dislocated shoulder using the Cunningham t", icon: "bandage.fill", destination: .technique("firstaid-dislocated-shoulder"))
                    ])
                )),
                TriageOption(id: "g1120", label: "Femur", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g1120-q", question: "Select:", options: [
                        TriageOption(id: "g1121", label: "Clinical protocol for the diagnosis phase of Femur Frac", icon: "bandage.fill", destination: .technique("firstaid-encyclopedia-femur-fracture-diagnosis")),
                        TriageOption(id: "g1122", label: "Clinical protocol for the evacuation criteria phase of ", icon: "bandage.fill", destination: .technique("firstaid-encyclopedia-femur-fracture-evacuation-criteria")),
                        TriageOption(id: "g1123", label: "Clinical protocol for the field treatment phase of Femu", icon: "bandage.fill", destination: .technique("firstaid-encyclopedia-femur-fracture-field-treatment")),
                        TriageOption(id: "g1124", label: "Clinical protocol for the initial stabilization phase o", icon: "bandage.fill", destination: .technique("firstaid-encyclopedia-femur-fracture-initial-stabilization")),
                        TriageOption(id: "g1125", label: "Femur fracture traction using improvised materials", icon: "bandage.fill", destination: .technique("firstaid-kendrick-traction-device"))
                    ])
                )),
                TriageOption(id: "g1126", label: "Ankle", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g1126-q", question: "Select:", options: [
                        TriageOption(id: "g1127", label: "Clinical protocol for the diagnosis phase of Ankle Spra", icon: "cloud.rain.fill", destination: .technique("firstaid-encyclopedia-ankle-sprain-grade-ii-diagnosis")),
                        TriageOption(id: "g1128", label: "Clinical protocol for the evacuation criteria phase of ", icon: "figure.walk.motion", destination: .technique("firstaid-encyclopedia-ankle-sprain-grade-ii-evacuation-criteria")),
                        TriageOption(id: "g1129", label: "Clinical protocol for the field treatment phase of Ankl", icon: "cloud.rain.fill", destination: .technique("firstaid-encyclopedia-ankle-sprain-grade-ii-field-treatment")),
                        TriageOption(id: "g1130", label: "Clinical protocol for the initial stabilization phase o", icon: "cloud.rain.fill", destination: .technique("firstaid-encyclopedia-ankle-sprain-grade-ii-initial-stabilization")),
                        TriageOption(id: "g1131", label: "Properly wrap a sprained ankle for support", icon: "bandage.fill", destination: .technique("firstaid-figure-8-bandage"))
                    ])
                )),
                TriageOption(id: "g1132", label: "Diagnosis", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g1132-q", question: "Select:", options: [
                        TriageOption(id: "g1133", label: "Clinical protocol for the diagnosis phase of Clavicle F", icon: "bandage.fill", destination: .technique("firstaid-encyclopedia-clavicle-fracture-diagnosis")),
                        TriageOption(id: "g1134", label: "Clinical protocol for the diagnosis phase of Patellar D", icon: "bandage.fill", destination: .technique("firstaid-encyclopedia-patellar-dislocation-diagnosis")),
                        TriageOption(id: "g1135", label: "Clinical protocol for the diagnosis phase of Radius/Uln", icon: "bandage.fill", destination: .technique("firstaid-encyclopedia-radius-ulna-fracture-diagnosis"))
                    ])
                )),
                TriageOption(id: "g1136", label: "Ensure", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g1136-q", question: "Select:", options: [
                        TriageOption(id: "g1137", label: "Clinical protocol for the initial stabilization phase o", icon: "bandage.fill", destination: .technique("firstaid-encyclopedia-clavicle-fracture-initial-stabilization")),
                        TriageOption(id: "g1138", label: "Clinical protocol for the initial stabilization phase o", icon: "bandage.fill", destination: .technique("firstaid-encyclopedia-patellar-dislocation-initial-stabilization")),
                        TriageOption(id: "g1139", label: "Clinical protocol for the initial stabilization phase o", icon: "bandage.fill", destination: .technique("firstaid-encyclopedia-radius-ulna-fracture-initial-stabilization"))
                    ])
                )),
                TriageOption(id: "g1140", label: "Bandage", icon: "bandage.fill", destination: .nextQuestion(
                    TriageNode(id: "g1140-q", question: "Select:", options: [
                        TriageOption(id: "g1141", label: "Use a triangular bandage for arm support", icon: "bandage.fill", destination: .technique("firstaid-cravat-sling")),
                        TriageOption(id: "g1142", label: "Building a neck stabilizer from field materials", icon: "building.2.fill", destination: .technique("firstaid-cervical-collar")),
                        TriageOption(id: "g1143", label: "Mold a sleeping pad into a custom fracture splint", icon: "bandage.fill", destination: .technique("firstaid-improvised-sam-splint")),
                        TriageOption(id: "g1144", label: "Advanced blister prevention and treatment", icon: "cross.case.fill", destination: .technique("firstaid-leukotape-blister")),
                        TriageOption(id: "g1145", label: "Safely rolling a supine patient for examination or tran", icon: "figure.stand", destination: .technique("firstaid-log-roll"))
                    ])
                )),
                TriageOption(id: "g1146", label: "Finger", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g1146-q", question: "Select:", options: [
                        TriageOption(id: "g1147", label: "Identifying limb-threatening pressure buildup", icon: "bandage.fill", destination: .technique("firstaid-compartment-syndrome")),
                        TriageOption(id: "g1148", label: "Relocate a dislocated finger — common wilderness injury", icon: "bandage.fill", destination: .technique("firstaid-finger-dislocation")),
                        TriageOption(id: "g1149", label: "Using a bedsheet to stabilize pelvic fractures", icon: "bandage.fill", destination: .technique("firstaid-pelvic-binder-sheet")),
                        TriageOption(id: "g1150", label: "Managing bone protruding through skin", icon: "drop.fill", destination: .technique("firstaid-open-fracture-management")),
                        TriageOption(id: "g1151", label: "Stabilizing a broken bone protruding through the skin.", icon: "drop.fill", destination: .technique("firstaid-expert-open-fracture-management"))
                    ])
                )),
                TriageOption(id: "g1152", label: "Fracture", icon: "bandage.fill", destination: .nextQuestion(
                    TriageNode(id: "g1152-q", question: "Select:", options: [
                        TriageOption(id: "g1153", label: "Clinical protocol for the evacuation criteria phase of ", icon: "bandage.fill", destination: .technique("firstaid-encyclopedia-clavicle-fracture-evacuation-criteria")),
                        TriageOption(id: "g1154", label: "Clinical protocol for the field treatment phase of Clav", icon: "bandage.fill", destination: .technique("firstaid-encyclopedia-clavicle-fracture-field-treatment")),
                        TriageOption(id: "g1155", label: "Identifying pressure buildup within muscle tissue.", icon: "cross.case.fill", destination: .technique("firstaid-expert-compartment-syndrome")),
                        TriageOption(id: "g1156", label: "Clinical protocol for the evacuation criteria phase of ", icon: "bandage.fill", destination: .technique("firstaid-encyclopedia-radius-ulna-fracture-evacuation-criteria")),
                        TriageOption(id: "g1157", label: "Clinical protocol for the field treatment phase of Radi", icon: "bandage.fill", destination: .technique("firstaid-encyclopedia-radius-ulna-fracture-field-treatment"))
                    ])
                )),
                TriageOption(id: "g1158", label: "Patellar", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g1158-q", question: "Select:", options: [
                        TriageOption(id: "g1159", label: "Clinical protocol for the evacuation criteria phase of ", icon: "bandage.fill", destination: .technique("firstaid-encyclopedia-patellar-dislocation-evacuation-criteria")),
                        TriageOption(id: "g1160", label: "Clinical protocol for the field treatment phase of Pate", icon: "bandage.fill", destination: .technique("firstaid-encyclopedia-patellar-dislocation-field-treatment"))
                    ])
                ))
                ])
            )),

            TriageOption(id: "g1161", label: "Burns", icon: "flame.fill", destination: .nextQuestion(
                TriageNode(id: "g1161-q", question: "Which best matches?", options: [
                    TriageOption(id: "g1162", label: "Identifying compartment syndrome in burns", icon: "flame.fill", destination: .technique("firstaid-burn-escharotomy-signs"))
                ])
            )),

            TriageOption(id: "g1163", label: "Cold & Heat Injuries", icon: "cross.case.fill", destination: .nextQuestion(
                TriageNode(id: "g1163-q", question: "What specifically?", options: [
                TriageOption(id: "g1164", label: "Exhaustion", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g1164-q", question: "Select:", options: [
                        TriageOption(id: "g1165", label: "Clinical protocol for the diagnosis phase of Heat Exhau", icon: "sun.max.fill", destination: .technique("firstaid-encyclopedia-heat-exhaustion-diagnosis")),
                        TriageOption(id: "g1166", label: "Clinical protocol for the evacuation criteria phase of ", icon: "figure.walk.motion", destination: .technique("firstaid-encyclopedia-heat-exhaustion-evacuation-criteria")),
                        TriageOption(id: "g1167", label: "Clinical protocol for the field treatment phase of Heat", icon: "sun.max.fill", destination: .technique("firstaid-encyclopedia-heat-exhaustion-field-treatment")),
                        TriageOption(id: "g1168", label: "Clinical protocol for the initial stabilization phase o", icon: "sun.max.fill", destination: .technique("firstaid-encyclopedia-heat-exhaustion-initial-stabilization")),
                        TriageOption(id: "g1169", label: "Recognize and treat heat cramps → exhaustion → stroke", icon: "brain.head.profile", destination: .technique("firstaid-heat-illness-spectrum"))
                    ])
                )),
                TriageOption(id: "g1170", label: "Chilblains", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g1170-q", question: "Select:", options: [
                        TriageOption(id: "g1171", label: "Manage cold-induced skin inflammation", icon: "flame.fill", destination: .technique("firstaid-chilblains")),
                        TriageOption(id: "g1172", label: "Clinical protocol for the diagnosis phase of Chilblains", icon: "cross.case.fill", destination: .technique("firstaid-encyclopedia-chilblains-diagnosis")),
                        TriageOption(id: "g1173", label: "Clinical protocol for the evacuation criteria phase of ", icon: "figure.walk.motion", destination: .technique("firstaid-encyclopedia-chilblains-evacuation-criteria")),
                        TriageOption(id: "g1174", label: "Clinical protocol for the field treatment phase of Chil", icon: "cross.case.fill", destination: .technique("firstaid-encyclopedia-chilblains-field-treatment")),
                        TriageOption(id: "g1175", label: "Clinical protocol for the initial stabilization phase o", icon: "cross.case.fill", destination: .technique("firstaid-encyclopedia-chilblains-initial-stabilization"))
                    ])
                )),
                TriageOption(id: "g1176", label: "Strike", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g1176-q", question: "Select:", options: [
                        TriageOption(id: "g1177", label: "Clinical protocol for the diagnosis phase of Lightning ", icon: "bolt.fill", destination: .technique("firstaid-encyclopedia-lightning-strike-aftermath-diagnosis")),
                        TriageOption(id: "g1178", label: "Clinical protocol for the evacuation criteria phase of ", icon: "figure.walk.motion", destination: .technique("firstaid-encyclopedia-lightning-strike-aftermath-evacuation-criteria")),
                        TriageOption(id: "g1179", label: "Clinical protocol for the field treatment phase of Ligh", icon: "bolt.fill", destination: .technique("firstaid-encyclopedia-lightning-strike-aftermath-field-treatment")),
                        TriageOption(id: "g1180", label: "Clinical protocol for the initial stabilization phase o", icon: "bolt.fill", destination: .technique("firstaid-encyclopedia-lightning-strike-aftermath-initial-stabilization")),
                        TriageOption(id: "g1181", label: "Respond to a lightning strike victim", icon: "bolt.fill", destination: .technique("firstaid-lightning-strike"))
                    ])
                )),
                TriageOption(id: "g1182", label: "Mild", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g1182-q", question: "Select:", options: [
                        TriageOption(id: "g1183", label: "Recognize and treat your own early hypothermia", icon: "snowflake", destination: .technique("firstaid-hypothermia-mild-self")),
                        TriageOption(id: "g1184", label: "Clinical protocol for the diagnosis phase of Mild Hypot", icon: "snowflake", destination: .technique("firstaid-encyclopedia-mild-hypothermia-diagnosis")),
                        TriageOption(id: "g1185", label: "Clinical protocol for the evacuation criteria phase of ", icon: "figure.walk.motion", destination: .technique("firstaid-encyclopedia-mild-hypothermia-evacuation-criteria")),
                        TriageOption(id: "g1186", label: "Clinical protocol for the field treatment phase of Mild", icon: "snowflake", destination: .technique("firstaid-encyclopedia-mild-hypothermia-field-treatment")),
                        TriageOption(id: "g1187", label: "Clinical protocol for the initial stabilization phase o", icon: "snowflake", destination: .technique("firstaid-encyclopedia-mild-hypothermia-initial-stabilization"))
                    ])
                )),
                TriageOption(id: "g1188", label: "Recognize", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g1188-q", question: "Select:", options: [
                        TriageOption(id: "g1189", label: "Core temp >104°F — cool AGGRESSIVELY or brain damage oc", icon: "brain.head.profile", destination: .technique("firstaid-heat-stroke-cooling")),
                        TriageOption(id: "g1190", label: "Tarp-Assisted Cold Water Immersion", icon: "brain.head.profile", destination: .technique("firstaid-heatstroke-tarp-cooling")),
                        TriageOption(id: "g1191", label: "Preventing and treating non-freezing cold injury", icon: "snowflake", destination: .technique("firstaid-immersion-foot"))
                    ])
                )),
                TriageOption(id: "g1192", label: "Rewarming", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g1192-q", question: "Select:", options: [
                        TriageOption(id: "g1193", label: "Warm a hypothermia patient using available heat sources", icon: "snowflake", destination: .technique("firstaid-hypothermia-active-warming")),
                        TriageOption(id: "g1194", label: "Use iodine or bleach to purify drinking water", icon: "drop.fill", destination: .technique("firstaid-water-purification-drops")),
                        TriageOption(id: "g1195", label: "Field rewarming of frozen tissue", icon: "ant.fill", destination: .technique("firstaid-frostbite-rewarm")),
                        TriageOption(id: "g1196", label: "Insulate a hypothermia patient for rewarming", icon: "bandage.fill", destination: .technique("firstaid-hypothermia-wrap")),
                        TriageOption(id: "g1197", label: "Post-rescue management of drowning victims", icon: "figure.walk.motion", destination: .technique("firstaid-drowning-aftercare"))
                    ])
                )),
                TriageOption(id: "g1198", label: "Frostbite", icon: "ant.fill", destination: .nextQuestion(
                    TriageNode(id: "g1198-q", question: "Select:", options: [
                        TriageOption(id: "g1199", label: "Thawing deep frostbite safely", icon: "ant.fill", destination: .technique("firstaid-frostbite-rapid-rewarm")),
                        TriageOption(id: "g1200", label: "The definitive hospital protocol adapted for the field.", icon: "ant.fill", destination: .technique("firstaid-expert-frostbite-rewarming")),
                        TriageOption(id: "g1201", label: "Controlled rewarming of frozen tissue — timing is criti", icon: "ant.fill", destination: .technique("firstaid-frostbite-rewarming")),
                        TriageOption(id: "g1202", label: "Managing exercise-associated muscle cramping", icon: "cross.case.fill", destination: .technique("firstaid-heat-cramp-field")),
                        TriageOption(id: "g1203", label: "The Hypothermia Burrito Protocol", icon: "bandage.fill", destination: .technique("firstaid-hypothermia-burrito"))
                    ])
                )),
                TriageOption(id: "g1204", label: "Heat", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g1204-q", question: "Select:", options: [
                        TriageOption(id: "g1205", label: "Clinical protocol for the diagnosis phase of Heat Strok", icon: "brain.head.profile", destination: .technique("firstaid-encyclopedia-heat-stroke-diagnosis")),
                        TriageOption(id: "g1206", label: "Clinical protocol for the evacuation criteria phase of ", icon: "brain.head.profile", destination: .technique("firstaid-encyclopedia-heat-stroke-evacuation-criteria")),
                        TriageOption(id: "g1207", label: "Clinical protocol for the field treatment phase of Heat", icon: "brain.head.profile", destination: .technique("firstaid-encyclopedia-heat-stroke-field-treatment")),
                        TriageOption(id: "g1208", label: "Clinical protocol for the initial stabilization phase o", icon: "brain.head.profile", destination: .technique("firstaid-encyclopedia-heat-stroke-initial-stabilization")),
                        TriageOption(id: "g1209", label: "Clinical protocol for the diagnosis phase of Snow Blind", icon: "cross.case.fill", destination: .technique("firstaid-encyclopedia-snow-blindness-photokeratitis-diagnosis"))
                    ])
                )),
                TriageOption(id: "g1210", label: "Snow", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g1210-q", question: "Select:", options: [
                        TriageOption(id: "g1211", label: "Rehydrate safely and effectively", icon: "sun.max.fill", destination: .technique("firstaid-dehydration-response")),
                        TriageOption(id: "g1212", label: "Clinical protocol for the evacuation criteria phase of ", icon: "figure.walk.motion", destination: .technique("firstaid-encyclopedia-snow-blindness-photokeratitis-evacuation-criteria")),
                        TriageOption(id: "g1213", label: "Clinical protocol for the field treatment phase of Snow", icon: "cross.case.fill", destination: .technique("firstaid-encyclopedia-snow-blindness-photokeratitis-field-treatment")),
                        TriageOption(id: "g1214", label: "Clinical protocol for the initial stabilization phase o", icon: "cross.case.fill", destination: .technique("firstaid-encyclopedia-snow-blindness-photokeratitis-initial-stabilization")),
                        TriageOption(id: "g1215", label: "Halting continuous cold/wet tissue necrosis.", icon: "snowflake", destination: .technique("firstaid-foot-trench-prevention"))
                    ])
                )),
                TriageOption(id: "g1216", label: "Heat (2)", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g1216-q", question: "Select:", options: [
                        TriageOption(id: "g1217", label: "Life-threatening medical emergency", icon: "brain.head.profile", destination: .technique("firstaid-heatstroke-response"))
                    ])
                ))
                ])
            )),

            TriageOption(id: "g1218", label: "Eyes & Teeth", icon: "eye.fill", destination: .nextQuestion(
                TriageNode(id: "g1218-q", question: "What specifically?", options: [
                TriageOption(id: "g1219", label: "Relief", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g1219-q", question: "Select:", options: [
                        TriageOption(id: "g1220", label: "Manage dental emergencies with field materials", icon: "mouth.fill", destination: .technique("firstaid-emergency-dental-kit")),
                        TriageOption(id: "g1221", label: "Manage severe dental pain in the field", icon: "mouth.fill", destination: .technique("firstaid-toothache-field"))
                    ])
                )),
                TriageOption(id: "g1222", label: "Clean", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g1222-q", question: "Select:", options: [
                        TriageOption(id: "g1223", label: "Seal a cavity or lost filling in the field", icon: "water.waves", destination: .technique("firstaid-dental-temporary-filling")),
                        TriageOption(id: "g1224", label: "Continuous chemical burn eye flush", icon: "flame.fill", destination: .technique("firstaid-morgan-lens-irrigation"))
                    ])
                )),
                TriageOption(id: "g1225", label: "Remove", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g1225-q", question: "Select:", options: [
                        TriageOption(id: "g1226", label: "Remove debris from the eye safely", icon: "eye.fill", destination: .technique("firstaid-eye-foreign-body")),
                        TriageOption(id: "g1227", label: "Protecting penetrating eye injuries", icon: "eye.fill", destination: .technique("firstaid-eye-shield-improvised"))
                    ])
                )),
                TriageOption(id: "g1228", label: "Snow", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g1228-q", question: "Select:", options: [
                        TriageOption(id: "g1229", label: "Relocate a dislocated jaw — field technique", icon: "bandage.fill", destination: .technique("firstaid-dental-jaw-dislocation")),
                        TriageOption(id: "g1230", label: "Reimplantation window and storage", icon: "mouth.fill", destination: .technique("firstaid-dental-avulsion")),
                        TriageOption(id: "g1231", label: "Managing ultraviolet keratitis from sun glare on snow", icon: "flame.fill", destination: .technique("firstaid-snow-blindness"))
                    ])
                ))
                ])
            )),

            TriageOption(id: "g1232", label: "Herbal Remedies", icon: "leaf.fill", destination: .nextQuestion(
                TriageNode(id: "g1232-q", question: "What specifically?", options: [
                TriageOption(id: "g1233", label: "Minor", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g1233-q", question: "Select:", options: [
                        TriageOption(id: "g1234", label: "Preparing a botanical astringent wash specifically to t", icon: "drop.fill", destination: .technique("firstaid-encyclopedia-herbal-astringent-minor")),
                        TriageOption(id: "g1235", label: "Preparing a botanical decoction (boiling roots/bark) sp", icon: "drop.fill", destination: .technique("firstaid-encyclopedia-herbal-decoction-minor")),
                        TriageOption(id: "g1236", label: "Preparing a botanical infusion (steeping leaves/flowers", icon: "drop.fill", destination: .technique("firstaid-encyclopedia-herbal-infusion-minor")),
                        TriageOption(id: "g1237", label: "Preparing a botanical poultice (crushed matter) specifi", icon: "drop.fill", destination: .technique("firstaid-encyclopedia-herbal-poultice-minor")),
                        TriageOption(id: "g1238", label: "Preparing a botanical salve (mixed with fat/oil) specif", icon: "drop.fill", destination: .technique("firstaid-encyclopedia-herbal-salve-minor"))
                    ])
                )),
                TriageOption(id: "g1239", label: "Wash", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g1239-q", question: "Select:", options: [
                        TriageOption(id: "g1240", label: "Preparing a botanical astringent wash specifically to t", icon: "leaf.fill", destination: .technique("firstaid-encyclopedia-herbal-astringent-gastrointestinal")),
                        TriageOption(id: "g1241", label: "Preparing a botanical astringent wash specifically to t", icon: "ant.fill", destination: .technique("firstaid-encyclopedia-herbal-astringent-insect")),
                        TriageOption(id: "g1242", label: "Preparing a botanical astringent wash specifically to t", icon: "cross.case.fill", destination: .technique("firstaid-encyclopedia-herbal-astringent-mild")),
                        TriageOption(id: "g1243", label: "Preparing a botanical astringent wash specifically to t", icon: "leaf.fill", destination: .technique("firstaid-encyclopedia-herbal-astringent-skin"))
                    ])
                )),
                TriageOption(id: "g1244", label: "Gastrointestinal", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g1244-q", question: "Select:", options: [
                        TriageOption(id: "g1245", label: "Preparing a botanical decoction (boiling roots/bark) sp", icon: "leaf.fill", destination: .technique("firstaid-encyclopedia-herbal-decoction-gastrointestinal")),
                        TriageOption(id: "g1246", label: "Preparing a botanical infusion (steeping leaves/flowers", icon: "leaf.fill", destination: .technique("firstaid-encyclopedia-herbal-infusion-gastrointestinal")),
                        TriageOption(id: "g1247", label: "Preparing a botanical poultice (crushed matter) specifi", icon: "leaf.fill", destination: .technique("firstaid-encyclopedia-herbal-poultice-gastrointestinal")),
                        TriageOption(id: "g1248", label: "Preparing a botanical salve (mixed with fat/oil) specif", icon: "leaf.fill", destination: .technique("firstaid-encyclopedia-herbal-salve-gastrointestinal"))
                    ])
                )),
                TriageOption(id: "g1249", label: "Mild", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g1249-q", question: "Select:", options: [
                        TriageOption(id: "g1250", label: "Preparing a botanical decoction (boiling roots/bark) sp", icon: "cross.case.fill", destination: .technique("firstaid-encyclopedia-herbal-decoction-mild")),
                        TriageOption(id: "g1251", label: "Preparing a botanical infusion (steeping leaves/flowers", icon: "cross.case.fill", destination: .technique("firstaid-encyclopedia-herbal-infusion-mild")),
                        TriageOption(id: "g1252", label: "Preparing a botanical poultice (crushed matter) specifi", icon: "cross.case.fill", destination: .technique("firstaid-encyclopedia-herbal-poultice-mild")),
                        TriageOption(id: "g1253", label: "Preparing a botanical salve (mixed with fat/oil) specif", icon: "cross.case.fill", destination: .technique("firstaid-encyclopedia-herbal-salve-mild"))
                    ])
                )),
                TriageOption(id: "g1254", label: "Dermatitis", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g1254-q", question: "Select:", options: [
                        TriageOption(id: "g1255", label: "Preparing a botanical decoction (boiling roots/bark) sp", icon: "leaf.fill", destination: .technique("firstaid-encyclopedia-herbal-decoction-skin")),
                        TriageOption(id: "g1256", label: "Preparing a botanical infusion (steeping leaves/flowers", icon: "leaf.fill", destination: .technique("firstaid-encyclopedia-herbal-infusion-skin")),
                        TriageOption(id: "g1257", label: "Preparing a botanical poultice (crushed matter) specifi", icon: "leaf.fill", destination: .technique("firstaid-encyclopedia-herbal-poultice-skin")),
                        TriageOption(id: "g1258", label: "Preparing a botanical salve (mixed with fat/oil) specif", icon: "leaf.fill", destination: .technique("firstaid-encyclopedia-herbal-salve-skin"))
                    ])
                )),
                TriageOption(id: "g1259", label: "Willow", icon: "leaf.fill", destination: .nextQuestion(
                    TriageNode(id: "g1259-q", question: "Select:", options: [
                        TriageOption(id: "g1260", label: "Using raw garlic for antimicrobial treatment", icon: "cylinder.fill", destination: .technique("firstaid-garlic-antibiotic")),
                        TriageOption(id: "g1261", label: "Using raw honey as an antimicrobial wound dressing", icon: "drop.fill", destination: .technique("firstaid-honey-wound")),
                        TriageOption(id: "g1262", label: "Using broadleaf plantain for wound care and insect stin", icon: "drop.fill", destination: .technique("firstaid-plantain-poultice")),
                        TriageOption(id: "g1263", label: "Extracting salicin from willow bark for pain and fever", icon: "cross.case.fill", destination: .technique("firstaid-willow-bark")),
                        TriageOption(id: "g1264", label: "Salicylic acid from willow bark for pain and fever", icon: "cross.case.fill", destination: .technique("firstaid-willow-bark-aspirin"))
                    ])
                )),
                TriageOption(id: "g1265", label: "Charcoal", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g1265-q", question: "Select:", options: [
                        TriageOption(id: "g1266", label: "Adsorb ingested poisons with improvised activated charc", icon: "flame.fill", destination: .technique("firstaid-charcoal-poison-treatment")),
                        TriageOption(id: "g1267", label: "Extracting salicin (natural aspirin) for pain relief.", icon: "leaf.fill", destination: .technique("firstaid-med-willow-bark-tea")),
                        TriageOption(id: "g1268", label: "Medical-grade wound treatment — antimicrobial and promo", icon: "drop.fill", destination: .technique("firstaid-honey-wound-dressing")),
                        TriageOption(id: "g1269", label: "Prevent scurvy in extended survival — massive vitamin C", icon: "scissors", destination: .technique("firstaid-pine-needle-tea-vitamincC")),
                        TriageOption(id: "g1270", label: "Stopping severe bleeding using Achillea millefolium.", icon: "drop.fill", destination: .technique("firstaid-med-yarrow-styptic"))
                    ])
                )),
                TriageOption(id: "g1271", label: "Insect", icon: "ant.fill", destination: .nextQuestion(
                    TriageNode(id: "g1271-q", question: "Select:", options: [
                        TriageOption(id: "g1272", label: "Preparing a botanical decoction (boiling roots/bark) sp", icon: "ant.fill", destination: .technique("firstaid-encyclopedia-herbal-decoction-insect")),
                        TriageOption(id: "g1273", label: "Preparing a botanical infusion (steeping leaves/flowers", icon: "ant.fill", destination: .technique("firstaid-encyclopedia-herbal-infusion-insect")),
                        TriageOption(id: "g1274", label: "Preparing a botanical poultice (crushed matter) specifi", icon: "ant.fill", destination: .technique("firstaid-encyclopedia-herbal-poultice-insect")),
                        TriageOption(id: "g1275", label: "Preparing a botanical salve (mixed with fat/oil) specif", icon: "ant.fill", destination: .technique("firstaid-encyclopedia-herbal-salve-insect"))
                    ])
                ))
                ])
            )),

            TriageOption(id: "g1276", label: "Hygiene", icon: "cross.case.fill", destination: .nextQuestion(
                TriageNode(id: "g1276-q", question: "Which best matches?", options: [
                    TriageOption(id: "g1277", label: "Building a proper long-term latrine for multi-day camps", icon: "mappin.and.ellipse", destination: .technique("firstaid-field-sanitation-latrine")),
                    TriageOption(id: "g1278", label: "Preventing disease through basic sanitation in the wild", icon: "cross.case.fill", destination: .technique("firstaid-field-hygiene")),
                    TriageOption(id: "g1279", label: "Produce soap from fat and wood ash lye — disease preven", icon: "cross.case.fill", destination: .technique("firstaid-field-soap-making")),
                    TriageOption(id: "g1280", label: "Prevent dysentery, cholera, and giardia in the field", icon: "cross.case.fill", destination: .technique("firstaid-water-borne-disease-prevention")),
                    TriageOption(id: "g1281", label: "The single most important wound care technique", icon: "drop.fill", destination: .technique("firstaid-wound-irrigation-technique"))
                ])
            )),

            TriageOption(id: "g1282", label: "Infection & Illness", icon: "cross.case.fill", destination: .nextQuestion(
                TriageNode(id: "g1282-q", question: "What specifically?", options: [
                TriageOption(id: "g1283", label: "Prevention", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g1283-q", question: "Select:", options: [
                        TriageOption(id: "g1284", label: "Clinical protocol for the diagnosis phase of Malaria Pr", icon: "cross.case.fill", destination: .technique("firstaid-encyclopedia-malaria-prevention-recognition-diagnosis")),
                        TriageOption(id: "g1285", label: "Clinical protocol for the evacuation criteria phase of ", icon: "cross.case.fill", destination: .technique("firstaid-encyclopedia-malaria-prevention-recognition-evacuation-criteria")),
                        TriageOption(id: "g1286", label: "Clinical protocol for the field treatment phase of Mala", icon: "cross.case.fill", destination: .technique("firstaid-encyclopedia-malaria-prevention-recognition-field-treatment")),
                        TriageOption(id: "g1287", label: "Clinical protocol for the initial stabilization phase o", icon: "cross.case.fill", destination: .technique("firstaid-encyclopedia-malaria-prevention-recognition-initial-stabilization")),
                        TriageOption(id: "g1288", label: "Wet feet in cold conditions can disable you", icon: "snowflake", destination: .technique("firstaid-trench-foot-adv"))
                    ])
                )),
                TriageOption(id: "g1289", label: "Response", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g1289-q", question: "Select:", options: [
                        TriageOption(id: "g1290", label: "Help someone through an acute asthma episode", icon: "lungs.fill", destination: .technique("firstaid-asthma-attack")),
                        TriageOption(id: "g1291", label: "Clear blocked airway — adult and child techniques", icon: "lungs.fill", destination: .technique("firstaid-choking-complete")),
                        TriageOption(id: "g1292", label: "Surviving sudden immersion in cold water", icon: "bolt.fill", destination: .technique("firstaid-cold-water-immersion")),
                        TriageOption(id: "g1293", label: "Emergency response to suspected overdose", icon: "exclamationmark.triangle.fill", destination: .technique("firstaid-overdose-response")),
                        TriageOption(id: "g1294", label: "Protect a seizing person from injury", icon: "brain.head.profile", destination: .technique("firstaid-seizure-response"))
                    ])
                )),
                TriageOption(id: "g1295", label: "Diagnosis", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g1295-q", question: "Select:", options: [
                        TriageOption(id: "g1296", label: "Clinical protocol for the diagnosis phase of Leptospiro", icon: "cross.case.fill", destination: .technique("firstaid-encyclopedia-leptospirosis-diagnosis")),
                        TriageOption(id: "g1297", label: "Clinical protocol for the diagnosis phase of Norovirus ", icon: "mappin.and.ellipse", destination: .technique("firstaid-encyclopedia-norovirus-outbreak-in-camp-diagnosis")),
                        TriageOption(id: "g1298", label: "Clinical protocol for the diagnosis phase of Tetanus Ri", icon: "list.bullet.clipboard.fill", destination: .technique("firstaid-encyclopedia-tetanus-risk-assessment-diagnosis")),
                        TriageOption(id: "g1299", label: "Clinical protocol for the diagnosis phase of Tick Borne", icon: "cross.case.fill", destination: .technique("firstaid-encyclopedia-tick-borne-illness-lyme-rocky-mountain-diagnosis"))
                    ])
                )),
                TriageOption(id: "g1300", label: "Ensure", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g1300-q", question: "Select:", options: [
                        TriageOption(id: "g1301", label: "Clinical protocol for the initial stabilization phase o", icon: "cross.case.fill", destination: .technique("firstaid-encyclopedia-leptospirosis-initial-stabilization")),
                        TriageOption(id: "g1302", label: "Clinical protocol for the initial stabilization phase o", icon: "mappin.and.ellipse", destination: .technique("firstaid-encyclopedia-norovirus-outbreak-in-camp-initial-stabilization")),
                        TriageOption(id: "g1303", label: "Clinical protocol for the initial stabilization phase o", icon: "list.bullet.clipboard.fill", destination: .technique("firstaid-encyclopedia-tetanus-risk-assessment-initial-stabilization")),
                        TriageOption(id: "g1304", label: "Clinical protocol for the initial stabilization phase o", icon: "cross.case.fill", destination: .technique("firstaid-encyclopedia-tick-borne-illness-lyme-rocky-mountain-initial-stabilization"))
                    ])
                )),
                TriageOption(id: "g1305", label: "Definitive", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g1305-q", question: "Select:", options: [
                        TriageOption(id: "g1306", label: "Clinical protocol for the field treatment phase of Lept", icon: "cross.case.fill", destination: .technique("firstaid-encyclopedia-leptospirosis-field-treatment")),
                        TriageOption(id: "g1307", label: "Clinical protocol for the field treatment phase of Noro", icon: "mappin.and.ellipse", destination: .technique("firstaid-encyclopedia-norovirus-outbreak-in-camp-field-treatment")),
                        TriageOption(id: "g1308", label: "Clinical protocol for the field treatment phase of Teta", icon: "list.bullet.clipboard.fill", destination: .technique("firstaid-encyclopedia-tetanus-risk-assessment-field-treatment")),
                        TriageOption(id: "g1309", label: "Clinical protocol for the field treatment phase of Tick", icon: "cross.case.fill", destination: .technique("firstaid-encyclopedia-tick-borne-illness-lyme-rocky-mountain-field-treatment"))
                    ])
                )),
                TriageOption(id: "g1310", label: "Tooth", icon: "mouth.fill", destination: .nextQuestion(
                    TriageNode(id: "g1310-q", question: "Select:", options: [
                        TriageOption(id: "g1311", label: "Flush chemicals or debris from the eye", icon: "eye.fill", destination: .technique("firstaid-eye-irrigation")),
                        TriageOption(id: "g1312", label: "Protect an injured eye in the field", icon: "eye.fill", destination: .technique("firstaid-eye-patch-technique")),
                        TriageOption(id: "g1313", label: "Protect vision when medical help is far away", icon: "eye.fill", destination: .technique("firstaid-eye-field")),
                        TriageOption(id: "g1314", label: "Manage tooth injuries in the wilderness", icon: "mouth.fill", destination: .technique("firstaid-dental-field-fix")),
                        TriageOption(id: "g1315", label: "Remove objects or insects from the ear canal", icon: "ant.fill", destination: .technique("firstaid-foreign-body-ear"))
                    ])
                )),
                TriageOption(id: "g1316", label: "Evacuation", icon: "figure.walk.motion", destination: .nextQuestion(
                    TriageNode(id: "g1316-q", question: "Select:", options: [
                        TriageOption(id: "g1317", label: "Simplified CPR for untrained bystanders", icon: "lungs.fill", destination: .technique("firstaid-chest-compressions-only-cpr")),
                        TriageOption(id: "g1318", label: "Safe removal of leeches without leaving mouthparts embe", icon: "flame.fill", destination: .technique("firstaid-leech-removal")),
                        TriageOption(id: "g1319", label: "Clinical protocol for the evacuation criteria phase of ", icon: "figure.walk.motion", destination: .technique("firstaid-encyclopedia-leptospirosis-evacuation-criteria")),
                        TriageOption(id: "g1320", label: "Clinical protocol for the evacuation criteria phase of ", icon: "figure.walk.motion", destination: .technique("firstaid-encyclopedia-norovirus-outbreak-in-camp-evacuation-criteria")),
                        TriageOption(id: "g1321", label: "Clinical protocol for the evacuation criteria phase of ", icon: "figure.walk.motion", destination: .technique("firstaid-encyclopedia-tick-borne-illness-lyme-rocky-mountain-evacuation-criteria"))
                    ])
                )),
                TriageOption(id: "g1322", label: "Risk", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g1322-q", question: "Select:", options: [
                        TriageOption(id: "g1323", label: "Clinical protocol for the evacuation criteria phase of ", icon: "figure.walk.motion", destination: .technique("firstaid-encyclopedia-tetanus-risk-assessment-evacuation-criteria"))
                    ])
                ))
                ])
            )),

            TriageOption(id: "g1324", label: "Medical Crises", icon: "cross.case.fill", destination: .nextQuestion(
                TriageNode(id: "g1324-q", question: "What specifically?", options: [
                TriageOption(id: "g1325", label: "Recognize", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g1325-q", question: "Select:", options: [
                        TriageOption(id: "g1326", label: "Severe allergic reaction — epinephrine is the ONLY trea", icon: "bolt.fill", destination: .technique("firstaid-anaphylaxis-management")),
                        TriageOption(id: "g1327", label: "Treating dangerously low blood sugar.", icon: "cross.case.fill", destination: .technique("firstaid-expert-hypoglycemia-field")),
                        TriageOption(id: "g1328", label: "Treating the most common wilderness waterborne illness.", icon: "cross.case.fill", destination: .technique("firstaid-expert-giardiasis-management")),
                        TriageOption(id: "g1329", label: "Manage excruciating flank pain without hospital access", icon: "water.waves", destination: .technique("firstaid-kidney-stone-field")),
                        TriageOption(id: "g1330", label: "Manage urinary tract infection without antibiotics", icon: "flame.fill", destination: .technique("firstaid-urinary-tract-infection"))
                    ])
                )),
                TriageOption(id: "g1331", label: "Seizure", icon: "brain.head.profile", destination: .nextQuestion(
                    TriageNode(id: "g1331-q", question: "Select:", options: [
                        TriageOption(id: "g1332", label: "Clinical protocol for the diagnosis phase of Seizure (G", icon: "brain.head.profile", destination: .technique("firstaid-encyclopedia-seizure-grand-mal-diagnosis")),
                        TriageOption(id: "g1333", label: "Clinical protocol for the evacuation criteria phase of ", icon: "brain.head.profile", destination: .technique("firstaid-encyclopedia-seizure-grand-mal-evacuation-criteria")),
                        TriageOption(id: "g1334", label: "Clinical protocol for the field treatment phase of Seiz", icon: "brain.head.profile", destination: .technique("firstaid-encyclopedia-seizure-grand-mal-field-treatment")),
                        TriageOption(id: "g1335", label: "Clinical protocol for the initial stabilization phase o", icon: "brain.head.profile", destination: .technique("firstaid-encyclopedia-seizure-grand-mal-initial-stabilization")),
                        TriageOption(id: "g1336", label: "Protect the patient during and after a seizure", icon: "brain.head.profile", destination: .technique("firstaid-seizure-management"))
                    ])
                )),
                TriageOption(id: "g1337", label: "Diagnosis", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g1337-q", question: "Select:", options: [
                        TriageOption(id: "g1338", label: "Clinical protocol for the diagnosis phase of Acute Asth", icon: "lungs.fill", destination: .technique("firstaid-encyclopedia-acute-asthma-exacerbation-diagnosis")),
                        TriageOption(id: "g1339", label: "Clinical protocol for the diagnosis phase of Diabetic K", icon: "cross.case.fill", destination: .technique("firstaid-encyclopedia-diabetic-ketoacidosis-recognition-diagnosis")),
                        TriageOption(id: "g1340", label: "Clinical protocol for the diagnosis phase of Myocardial", icon: "heart.fill", destination: .technique("firstaid-encyclopedia-myocardial-infarction-heart-attack-diagnosis")),
                        TriageOption(id: "g1341", label: "Clinical protocol for the diagnosis phase of Transient ", icon: "brain.head.profile", destination: .technique("firstaid-encyclopedia-transient-ischemic-attack-stroke-diagnosis"))
                    ])
                )),
                TriageOption(id: "g1342", label: "Ensure", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g1342-q", question: "Select:", options: [
                        TriageOption(id: "g1343", label: "Clinical protocol for the initial stabilization phase o", icon: "lungs.fill", destination: .technique("firstaid-encyclopedia-acute-asthma-exacerbation-initial-stabilization")),
                        TriageOption(id: "g1344", label: "Clinical protocol for the initial stabilization phase o", icon: "cross.case.fill", destination: .technique("firstaid-encyclopedia-diabetic-ketoacidosis-recognition-initial-stabilization")),
                        TriageOption(id: "g1345", label: "Clinical protocol for the initial stabilization phase o", icon: "heart.fill", destination: .technique("firstaid-encyclopedia-myocardial-infarction-heart-attack-initial-stabilization")),
                        TriageOption(id: "g1346", label: "Clinical protocol for the initial stabilization phase o", icon: "brain.head.profile", destination: .technique("firstaid-encyclopedia-transient-ischemic-attack-stroke-initial-stabilization"))
                    ])
                )),
                TriageOption(id: "g1347", label: "Definitive", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g1347-q", question: "Select:", options: [
                        TriageOption(id: "g1348", label: "Clinical protocol for the field treatment phase of Acut", icon: "lungs.fill", destination: .technique("firstaid-encyclopedia-acute-asthma-exacerbation-field-treatment")),
                        TriageOption(id: "g1349", label: "Clinical protocol for the field treatment phase of Diab", icon: "cross.case.fill", destination: .technique("firstaid-encyclopedia-diabetic-ketoacidosis-recognition-field-treatment")),
                        TriageOption(id: "g1350", label: "Clinical protocol for the field treatment phase of Myoc", icon: "heart.fill", destination: .technique("firstaid-encyclopedia-myocardial-infarction-heart-attack-field-treatment")),
                        TriageOption(id: "g1351", label: "Clinical protocol for the field treatment phase of Tran", icon: "brain.head.profile", destination: .technique("firstaid-encyclopedia-transient-ischemic-attack-stroke-field-treatment"))
                    ])
                )),
                TriageOption(id: "g1352", label: "Management", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g1352-q", question: "Select:", options: [
                        TriageOption(id: "g1353", label: "Common wilderness problem — dietary and mechanical solu", icon: "sun.max.fill", destination: .technique("firstaid-constipation-field")),
                        TriageOption(id: "g1354", label: "Compression-only resuscitation for cardiac arrest", icon: "lungs.fill", destination: .technique("firstaid-chest-cpr")),
                        TriageOption(id: "g1355", label: "Treating itching, hives, and swelling from stings or pl", icon: "ant.fill", destination: .technique("firstaid-allergic-mild")),
                        TriageOption(id: "g1356", label: "Hives and itching without breathing difficulty", icon: "ant.fill", destination: .technique("firstaid-allergic-reaction-mild")),
                        TriageOption(id: "g1357", label: "Stop persistent nosebleed in the field", icon: "drop.fill", destination: .technique("firstaid-nose-bleed-severe"))
                    ])
                )),
                TriageOption(id: "g1358", label: "Evacuation", icon: "figure.walk.motion", destination: .nextQuestion(
                    TriageNode(id: "g1358-q", question: "Select:", options: [
                        TriageOption(id: "g1359", label: "Clinical protocol for the evacuation criteria phase of ", icon: "figure.walk.motion", destination: .technique("firstaid-encyclopedia-acute-asthma-exacerbation-evacuation-criteria")),
                        TriageOption(id: "g1360", label: "Clinical protocol for the evacuation criteria phase of ", icon: "figure.walk.motion", destination: .technique("firstaid-encyclopedia-diabetic-ketoacidosis-recognition-evacuation-criteria")),
                        TriageOption(id: "g1361", label: "Clinical protocol for the evacuation criteria phase of ", icon: "heart.fill", destination: .technique("firstaid-encyclopedia-myocardial-infarction-heart-attack-evacuation-criteria")),
                        TriageOption(id: "g1362", label: "Clinical protocol for the evacuation criteria phase of ", icon: "brain.head.profile", destination: .technique("firstaid-encyclopedia-transient-ischemic-attack-stroke-evacuation-criteria"))
                    ])
                ))
                ])
            )),

            TriageOption(id: "g1363", label: "Patient Transport", icon: "figure.walk.motion", destination: .nextQuestion(
                TriageNode(id: "g1363-q", question: "What specifically?", options: [
                TriageOption(id: "g1364", label: "Litter", icon: "figure.walk.motion", destination: .nextQuestion(
                    TriageNode(id: "g1364-q", question: "Select:", options: [
                        TriageOption(id: "g1365", label: "NOLS protocols for initiating a improvised litter carry", icon: "figure.walk.motion", destination: .technique("firstaid-encyclopedia-evac-mild-improvised")),
                        TriageOption(id: "g1366", label: "NOLS protocols for initiating a improvised litter carry", icon: "figure.walk.motion", destination: .technique("firstaid-encyclopedia-evac-moderate-improvised")),
                        TriageOption(id: "g1367", label: "NOLS protocols for initiating a improvised litter carry", icon: "figure.walk.motion", destination: .technique("firstaid-encyclopedia-evac-severe-improvised"))
                    ])
                )),
                TriageOption(id: "g1368", label: "Severe", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g1368-q", question: "Select:", options: [
                        TriageOption(id: "g1369", label: "NOLS protocols for initiating a helicopter medevac when", icon: "snowflake", destination: .technique("firstaid-encyclopedia-evac-severe-helicopter")),
                        TriageOption(id: "g1370", label: "NOLS protocols for initiating a shelter in place when a", icon: "snowflake", destination: .technique("firstaid-encyclopedia-evac-severe-shelter"))
                    ])
                )),
                TriageOption(id: "g1371", label: "Self", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g1371-q", question: "Select:", options: [
                        TriageOption(id: "g1372", label: "NOLS protocols for initiating a self-evacuation when a ", icon: "figure.walk.motion", destination: .technique("firstaid-encyclopedia-evac-mild-self-evacuation")),
                        TriageOption(id: "g1373", label: "NOLS protocols for initiating a self-evacuation when a ", icon: "figure.walk.motion", destination: .technique("firstaid-encyclopedia-evac-moderate-self-evacuation"))
                    ])
                )),
                TriageOption(id: "g1374", label: "Mild", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g1374-q", question: "Select:", options: [
                        TriageOption(id: "g1375", label: "NOLS protocols for initiating a helicopter medevac when", icon: "snowflake", destination: .technique("firstaid-encyclopedia-evac-mild-helicopter")),
                        TriageOption(id: "g1376", label: "NOLS protocols for initiating a shelter in place when a", icon: "snowflake", destination: .technique("firstaid-encyclopedia-evac-mild-shelter"))
                    ])
                )),
                TriageOption(id: "g1377", label: "Helicopter", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g1377-q", question: "Select:", options: [
                        TriageOption(id: "g1378", label: "NOLS protocols for initiating a helicopter medevac when", icon: "snowflake", destination: .technique("firstaid-encyclopedia-evac-moderate-helicopter")),
                        TriageOption(id: "g1379", label: "NOLS protocols for initiating a helicopter medevac when", icon: "heart.fill", destination: .technique("firstaid-encyclopedia-evac-profound-helicopter"))
                    ])
                )),
                TriageOption(id: "g1380", label: "Hypothermia", icon: "snowflake", destination: .nextQuestion(
                    TriageNode(id: "g1380-q", question: "Select:", options: [
                        TriageOption(id: "g1381", label: "NOLS protocols for initiating a shelter in place when a", icon: "snowflake", destination: .technique("firstaid-encyclopedia-evac-moderate-shelter")),
                        TriageOption(id: "g1382", label: "NOLS protocols for initiating a shelter in place when a", icon: "heart.fill", destination: .technique("firstaid-encyclopedia-evac-profound-shelter"))
                    ])
                ))
                ])
            )),

            TriageOption(id: "g1383", label: "Specialty Care", icon: "car.fill", destination: .nextQuestion(
                TriageNode(id: "g1383-q", question: "What specifically?", options: [
                TriageOption(id: "g1384", label: "Dizziness", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g1384-q", question: "Select:", options: [
                        TriageOption(id: "g1385", label: "Identify and stop the progression of AMS", icon: "mountain.2.fill", destination: .technique("firstaid-altitude-sickness-ams")),
                        TriageOption(id: "g1386", label: "Recognize altitude sickness before it becomes life-thre", icon: "mountain.2.fill", destination: .technique("firstaid-ams-recognition")),
                        TriageOption(id: "g1387", label: "Recognize and manage nitrogen bubble formation after di", icon: "cross.case.fill", destination: .technique("firstaid-decompression-sickness")),
                        TriageOption(id: "g1388", label: "Pressure injury to the ear from diving or altitude chan", icon: "drop.fill", destination: .technique("firstaid-barotrauma-ear")),
                        TriageOption(id: "g1389", label: "Control life-threatening bleeding after delivery", icon: "drop.fill", destination: .technique("firstaid-postpartum-hemorrhage"))
                    ])
                )),
                TriageOption(id: "g1390", label: "Symptoms", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g1390-q", question: "Select:", options: [
                        TriageOption(id: "g1391", label: "Differentiate from medical emergency and manage", icon: "heart.fill", destination: .technique("firstaid-anxiety-attack-field")),
                        TriageOption(id: "g1392", label: "Recognizing and treating fluid in the lungs at elevatio", icon: "mountain.2.fill", destination: .technique("firstaid-high-altitude-pulmonary-edema")),
                        TriageOption(id: "g1393", label: "Emergency descent — brain swelling at altitude is fatal", icon: "mountain.2.fill", destination: .technique("firstaid-hace-treatment"))
                    ])
                )),
                TriageOption(id: "g1394", label: "Management", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g1394-q", question: "Select:", options: [
                        TriageOption(id: "g1395", label: "Species-specific sting management for box jelly, Portug", icon: "ant.fill", destination: .technique("firstaid-marine-sting-jellyfish")),
                        TriageOption(id: "g1396", label: "Post-submersion rescue breathing and monitoring", icon: "lungs.fill", destination: .technique("firstaid-drowning-management")),
                        TriageOption(id: "g1397", label: "Manage high fever in children without pharmacy access", icon: "cross.case.fill", destination: .technique("firstaid-pediatric-fever"))
                    ])
                )),
                TriageOption(id: "g1398", label: "Edema", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g1398-q", question: "Select:", options: [
                        TriageOption(id: "g1399", label: "Treating brain swelling at extreme altitude", icon: "mountain.2.fill", destination: .technique("firstaid-high-altitude-cerebral-edema")),
                        TriageOption(id: "g1400", label: "Test for lethal brain swelling at altitude", icon: "list.bullet.clipboard.fill", destination: .technique("firstaid-altitude-hace")),
                        TriageOption(id: "g1401", label: "Test for lethal fluid in the lungs at altitude", icon: "list.bullet.clipboard.fill", destination: .technique("firstaid-altitude-hape")),
                        TriageOption(id: "g1402", label: "Fluid in the lungs at altitude — descend or die", icon: "mountain.2.fill", destination: .technique("firstaid-hape-treatment"))
                    ])
                )),
                TriageOption(id: "g1403", label: "Assessment", icon: "list.bullet.clipboard.fill", destination: .nextQuestion(
                    TriageNode(id: "g1403-q", question: "Select:", options: [
                        TriageOption(id: "g1404", label: "Rapid pediatric evaluation without touching child", icon: "list.bullet.clipboard.fill", destination: .technique("firstaid-pediatric-assessment-triangle")),
                        TriageOption(id: "g1405", label: "Recognize dehydration severity in children — field sign", icon: "sun.max.fill", destination: .technique("firstaid-pediatric-dehydration"))
                    ])
                )),
                TriageOption(id: "g1406", label: "Altitude", icon: "mountain.2.fill", destination: .nextQuestion(
                    TriageNode(id: "g1406-q", question: "Select:", options: [
                        TriageOption(id: "g1407", label: "Prevent altitude sickness through proper ascent schedul", icon: "mountain.2.fill", destination: .technique("env-altitude-acclim")),
                        TriageOption(id: "g1408", label: "For unknown or reactive powders", icon: "cross.case.fill", destination: .technique("firstaid-chem-dry-decon")),
                        TriageOption(id: "g1409", label: "Help someone through acute panic", icon: "heart.fill", destination: .technique("firstaid-panic-attack")),
                        TriageOption(id: "g1410", label: "RCA (Riot Control Agent) Decon", icon: "cross.case.fill", destination: .technique("firstaid-tear-gas-recovery")),
                        TriageOption(id: "g1411", label: "For corrosive liquids and gases", icon: "cross.case.fill", destination: .technique("firstaid-chem-wet-decon"))
                    ])
                )),
                TriageOption(id: "g1412", label: "Wound", icon: "drop.fill", destination: .nextQuestion(
                    TriageNode(id: "g1412-q", question: "Select:", options: [
                        TriageOption(id: "g1413", label: "Deliver a baby when hospital is not reachable", icon: "figure.and.child.holdinghands", destination: .technique("firstaid-emergency-childbirth")),
                        TriageOption(id: "g1414", label: "Back blows and chest thrusts for choking infants", icon: "lungs.fill", destination: .technique("firstaid-pediatric-choking")),
                        TriageOption(id: "g1415", label: "Barbed wound with envenomation — heat destroys the veno", icon: "drop.fill", destination: .technique("firstaid-stingray-treatment"))
                    ])
                ))
                ])
            )),
        ])
    }

}
