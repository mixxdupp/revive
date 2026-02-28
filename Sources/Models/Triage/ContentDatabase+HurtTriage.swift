import Foundation

extension ContentDatabase {
    // =========================================================================
    // MARK: - FIRST AID / HURT (Precision Normalization V13)
    // =========================================================================
    func buildHurtTriage() -> TriageNode {
        return TriageNode(id: "hurt-nq-0-136", question: "Select Equipment Status:", options: [
        TriageOption(id: "fa-fin-1", label: "Low / Improvised Equipment", icon: "hammer.fill", destination: .nextQuestion(
            TriageNode(id: "hurt-nq-1-10", question: "Identify Primary Threat/Condition:", options: [
        TriageOption(id: "fa-fin-2", label: "Natural Remedies (Non-Life Threatening)", icon: "leaf.fill", destination: .nextQuestion(
            TriageNode(id: "hurt-nq-2-6", question: "What is the primary condition or requirement?", options: [
        TriageOption(id: "fa-fin-3", label: "Insect Prevention (Repellent)", icon: "ant.fill", destination: .technique("firstaid-insect-repellent-natural")),
        TriageOption(id: "fa-fin-4", label: "Oral Pain/Fever Relief (Willow, Infusions)", icon: "leaf.fill", destination: TriageDestination.rankedTechniqueList([RankedTechnique(id: "firstaid-pine-needle-tea-vitamincC", role: TriageTechniqueRole.primary), RankedTechnique(id: "firstaid-willow-bark", role: TriageTechniqueRole.adjunct)], confidence: TriageLeafConfidence.rankedPrimaryBackup)),
        TriageOption(id: "fa-fin-5", label: "Topical Wound Care (Poultice)", icon: "drop.fill", destination: TriageDestination.rankedTechniqueList([RankedTechnique(id: "firstaid-med-yarrow-styptic", role: TriageTechniqueRole.primary), RankedTechnique(id: "firstaid-plantain-poultice", role: TriageTechniqueRole.adjunct)], confidence: TriageLeafConfidence.rankedPrimaryBackup)),
        TriageOption(id: "fa-fin-6", label: "Topical Cleaning (Astringent, Honey)", icon: "leaf.fill", destination: .technique("firstaid-honey-wound"))
    ])
        )),
        TriageOption(id: "fa-fin-7", label: "Transport / Improvised Evacuation", icon: "figure.walk", destination: .technique("firstaid-improvised-stretcher"))
    ])
        )),
        TriageOption(id: "fa-fin-11", label: "Well-Equipped (Trauma/Med Kit Available)", icon: "cross.case.fill", destination: .nextQuestion(
            TriageNode(id: "hurt-nq-1-136", question: "Identify Primary Threat/Condition:", options: [
        TriageOption(id: "fa-fin-12", label: "Immediate Life Threats (< 2 Min)", icon: "cross.case.fill", destination: .nextQuestion(
            TriageNode(id: "hurt-nq-2-22", question: "What is the emergency?", options: [
        TriageOption(id: "fa-fin-13", label: "Bleeding: Spurting Arterial Flow", icon: "hammer.fill", destination: .nextQuestion(
            TriageNode(id: "hurt-nq-3-15", question: "What is the primary condition or requirement?", options: [
        TriageOption(id: "fa-fin-14", label: "Junctional (Neck/Groin/Armpit)", icon: "cross.case.fill", destination: TriageDestination.rankedTechniqueList([RankedTechnique(id: "firstaid-hemostatic-packing", role: TriageTechniqueRole.primary), RankedTechnique(id: "firstaid-hemostatic-agents", role: TriageTechniqueRole.adjunct)], confidence: TriageLeafConfidence.rankedPrimaryBackup)),
        TriageOption(id: "fa-fin-15", label: "Arm or Leg Bleed", icon: "drop.fill", destination: TriageDestination.rankedTechniqueList([RankedTechnique(id: "firstaid-tourniquet", role: TriageTechniqueRole.primary), RankedTechnique(id: "firstaid-hemostatic-tourniquet-high-tight", role: TriageTechniqueRole.adjunct)], confidence: TriageLeafConfidence.rankedPrimaryBackup))
    ])
        )),
        TriageOption(id: "fa-fin-16", label: "Airway: Completely Blocked (Choking)", icon: "lungs.fill", destination: .nextQuestion(
            TriageNode(id: "hurt-nq-3-19", question: "What is the primary condition or requirement?", options: [
        TriageOption(id: "fa-fin-17", label: "Unconscious Patient", icon: "staroflife.fill", destination: .technique("firstaid-choking-complete")),
        TriageOption(id: "fa-fin-18", label: "Conscious Adult/Child", icon: "cross.case.fill", destination: .technique("firstaid-choking-response")),
        TriageOption(id: "fa-fin-19", label: "Conscious Infant (< 1 Yr)", icon: "cross.case.fill", destination: .technique("firstaid-choking-infant"))
    ])
        )),
        TriageOption(id: "fa-fin-20", label: "Allergic: Throat Swelling / Anaphylaxis", icon: "figure.run", destination: .technique("firstaid-anaphylaxis-management")),
        TriageOption(id: "fa-fin-21", label: "Bleeding: pooling in deep chest/abdomen", icon: "lungs.fill", destination: .technique("firstaid-combat-gauze-packing")),
        TriageOption(id: "fa-fin-22", label: "Breathing: Absent or Gasping", icon: "lungs.fill", destination: TriageDestination.rankedTechniqueList([RankedTechnique(id: "firstaid-cpr", role: TriageTechniqueRole.primary), RankedTechnique(id: "firstaid-drowning-management", role: TriageTechniqueRole.adjunct)], confidence: TriageLeafConfidence.rankedPrimaryBackup))
    ])
        )),
        TriageOption(id: "fa-fin-23", label: "Deep Lacerations / Heavy Bleeding", icon: "drop.fill", destination: .nextQuestion(
            TriageNode(id: "hurt-nq-2-31", question: "What is the primary condition or requirement?", options: [
        TriageOption(id: "fa-fin-24", label: "Postpartum / Vaginal hemorrhage", icon: "cross.case.fill", destination: TriageDestination.rankedTechniqueList([RankedTechnique(id: "firstaid-tampon-dressing", role: TriageTechniqueRole.primary), RankedTechnique(id: "firstaid-postpartum-hemorrhage", role: TriageTechniqueRole.adjunct)], confidence: TriageLeafConfidence.rankedPrimaryBackup)),
        TriageOption(id: "fa-fin-25", label: "Abdominal organ protrusion", icon: "cross.case.fill", destination: TriageDestination.rankedTechniqueList([RankedTechnique(id: "firstaid-abdominal-injury", role: TriageTechniqueRole.primary), RankedTechnique(id: "firstaid-abdominal-evisceration", role: TriageTechniqueRole.adjunct)], confidence: TriageLeafConfidence.rankedPrimaryBackup)),
        TriageOption(id: "fa-fin-26", label: "Wound contains debris", icon: "cross.case.fill", destination: TriageDestination.rankedTechniqueList([RankedTechnique(id: "firstaid-wound-vac-improvised", role: TriageTechniqueRole.primary), RankedTechnique(id: "firstaid-wound-irrigation", role: TriageTechniqueRole.adjunct)], confidence: TriageLeafConfidence.rankedPrimaryBackup)),
        TriageOption(id: "fa-fin-27", label: "Deep cut needing closure", icon: "cross.vial.fill", destination: TriageDestination.rankedTechniqueList([RankedTechnique(id: "firstaid-duct-tape-butterfly", role: TriageTechniqueRole.primary), RankedTechnique(id: "firstaid-superglue-suture", role: TriageTechniqueRole.adjunct)], confidence: TriageLeafConfidence.rankedPrimaryBackup)),
        TriageOption(id: "fa-fin-28", label: "Continuous severe nosebleed", icon: "drop.fill", destination: .technique("firstaid-nosebleed-field")),
        TriageOption(id: "fa-fin-29", label: "Steady Heavy Flow", icon: "drop.fill", destination: .nextQuestion(
            TriageNode(id: "hurt-nq-3-31", question: "What is the primary condition or requirement?", options: [
        TriageOption(id: "fa-fin-30", label: "Amputated part", icon: "cross.case.fill", destination: TriageDestination.rankedTechniqueList([RankedTechnique(id: "firstaid-traumatic-amputation", role: TriageTechniqueRole.primary), RankedTechnique(id: "firstaid-finger-amputation", role: TriageTechniqueRole.adjunct), RankedTechnique(id: "firstaid-field-amputation-care", role: TriageTechniqueRole.contextual)], confidence: TriageLeafConfidence.rankedPrimaryBackup)),
        TriageOption(id: "fa-fin-31", label: "Limb / Torso laceration", icon: "cross.case.fill", destination: .technique("firstaid-bleeding-control-advanced"))
    ])
        ))
    ])
        )),
        TriageOption(id: "fa-fin-32", label: "Chest Trauma", icon: "lungs.fill", destination: .nextQuestion(
            TriageNode(id: "hurt-nq-2-35", question: "What is the primary condition or requirement?", options: [
        TriageOption(id: "fa-fin-33", label: "Trachea Shifted / Severe Dyspnea", icon: "cross.case.fill", destination: .technique("firstaid-tension-pneumo-recognition")),
        TriageOption(id: "fa-fin-34", label: "Bubbling / Sucking sound", icon: "cross.case.fill", destination: TriageDestination.rankedTechniqueList([RankedTechnique(id: "firstaid-chest-seal", role: TriageTechniqueRole.primary), RankedTechnique(id: "firstaid-chest-seal-improvised", role: TriageTechniqueRole.contextual)], confidence: TriageLeafConfidence.rankedPrimaryBackup)),
        TriageOption(id: "fa-fin-35", label: "Chest collapsing paradoxically", icon: "lungs.fill", destination: TriageDestination.rankedTechniqueList([RankedTechnique(id: "firstaid-rib-fracture", role: TriageTechniqueRole.primary), RankedTechnique(id: "firstaid-flail-chest-management", role: TriageTechniqueRole.adjunct)], confidence: TriageLeafConfidence.rankedPrimaryBackup))
    ])
        )),
        TriageOption(id: "fa-fin-36", label: "Medical Emergencies", icon: "cross.case.fill", destination: .nextQuestion(
            TriageNode(id: "hurt-nq-2-50", question: "What is the primary condition or requirement?", options: [
        TriageOption(id: "fa-fin-37", label: "Diabetic Emergency", icon: "cross.case.fill", destination: TriageDestination.rankedTechniqueList([RankedTechnique(id: "firstaid-expert-hypoglycemia-field", role: TriageTechniqueRole.primary), RankedTechnique(id: "firstaid-diabetic-emergency", role: TriageTechniqueRole.adjunct)], confidence: TriageLeafConfidence.rankedPrimaryBackup)),
        TriageOption(id: "fa-fin-38", label: "Asthma Attack (Wheezing but breathing)", icon: "lungs.fill", destination: .technique("firstaid-asthma")),
        TriageOption(id: "fa-fin-40", label: "Heat Stroke (Hot, Confused, Red Skin)", icon: "cross.case.fill", destination: .technique("firstaid-heat-stroke-cooling")),
        TriageOption(id: "fa-fin-44", label: "Post-Seizure Recovery", icon: "bed.double.fill", destination: .technique("firstaid-seizure-response")),
        TriageOption(id: "fa-fin-47", label: "Toxic Exposure / Overdose", icon: "cross.case.fill", destination: TriageDestination.rankedTechniqueList([RankedTechnique(id: "firstaid-poison-response", role: TriageTechniqueRole.primary), RankedTechnique(id: "firstaid-charcoal-ingestion", role: TriageTechniqueRole.adjunct), RankedTechnique(id: "firstaid-overdose-response", role: TriageTechniqueRole.contextual)], confidence: TriageLeafConfidence.rankedPrimaryBackup)),
        TriageOption(id: "fa-fin-50", label: "Mild Allergic Reaction (Rash/Itch)", icon: "allergens", destination: .technique("firstaid-allergic-reaction-mild"))
    ])
        )),
        TriageOption(id: "fa-fin-51", label: "Head & Spine Trauma", icon: "figure.stand", destination: .nextQuestion(
            TriageNode(id: "hurt-nq-2-54", question: "What is the primary condition or requirement?", options: [
        TriageOption(id: "fa-fin-52", label: "Unconscious with suspected spine injury", icon: "figure.stand", destination: .technique("firstaid-log-roll")),
        TriageOption(id: "fa-fin-53", label: "Head Injury / Confusion only", icon: "cross.case.fill", destination: .technique("firstaid-concussion")),
        TriageOption(id: "fa-fin-54", label: "Conscious but neck pain", icon: "cross.case.fill", destination: TriageDestination.rankedTechniqueList([RankedTechnique(id: "firstaid-cervical-collar", role: TriageTechniqueRole.primary), RankedTechnique(id: "firstaid-spine-clearing-field", role: TriageTechniqueRole.contextual), RankedTechnique(id: "firstaid-spinal-immobilization", role: TriageTechniqueRole.contextual)], confidence: TriageLeafConfidence.rankedPrimaryBackup))
    ])
        )),
        TriageOption(id: "fa-fin-55", label: "Infection / Fevers", icon: "thermometer", destination: .nextQuestion(
            TriageNode(id: "hurt-nq-2-61", question: "What is the primary condition or requirement?", options: [
        TriageOption(id: "fa-fin-56", label: "Localized wound red/swollen/pus", icon: "cross.case.fill", destination: TriageDestination.rankedTechniqueList([RankedTechnique(id: "firstaid-garlic-antibiotic", role: TriageTechniqueRole.primary), RankedTechnique(id: "firstaid-infection-management", role: TriageTechniqueRole.adjunct)], confidence: TriageLeafConfidence.rankedPrimaryBackup)),
        TriageOption(id: "fa-fin-59", label: "General Adult Fever", icon: "thermometer", destination: .technique("firstaid-fever")),
        TriageOption(id: "fa-fin-60", label: "Pediatric (Infant/Child) High Fever", icon: "thermometer", destination: .technique("firstaid-pediatric-fever")),
        TriageOption(id: "fa-fin-61", label: "Painful urination / Flank pain", icon: "cross.case.fill", destination: .technique("firstaid-urinary-tract-infection"))
    ])
        )),
        TriageOption(id: "fa-fin-62", label: "Sudden Illness (Stomach)", icon: "pills.fill", destination: .nextQuestion(
            TriageNode(id: "hurt-nq-2-66", question: "What is the primary condition or requirement?", options: [
        TriageOption(id: "fa-fin-63", label: "Kidney Stone / Severe Flank Pain", icon: "cross.case.fill", destination: .technique("firstaid-kidney-stone-field")),
        TriageOption(id: "fa-fin-65", label: "Waterborne GI Illness (Giardia)", icon: "pills.fill", destination: .technique("firstaid-expert-giardiasis-management")),
        TriageOption(id: "fa-fin-66", label: "Severe Constipation", icon: "cross.case.fill", destination: .technique("firstaid-constipation-field"))
    ])
        )),
        TriageOption(id: "fa-fin-67", label: "Fractures / Dislocations", icon: "figure.walk", destination: .nextQuestion(
            TriageNode(id: "hurt-nq-2-74", question: "What is the primary condition or requirement?", options: [
        TriageOption(id: "fa-fin-68", label: "Pelvis or Hip Pain", icon: "figure.walk", destination: TriageDestination.rankedTechniqueList([RankedTechnique(id: "firstaid-pelvic-fracture", role: TriageTechniqueRole.primary), RankedTechnique(id: "firstaid-pelvic-binder-sheet", role: TriageTechniqueRole.adjunct)], confidence: TriageLeafConfidence.rankedPrimaryBackup)),
        TriageOption(id: "fa-fin-69", label: "Upper Leg Deformity (Femur)", icon: "figure.walk", destination: TriageDestination.rankedTechniqueList([RankedTechnique(id: "firstaid-femur-traction", role: TriageTechniqueRole.primary), RankedTechnique(id: "firstaid-kendrick-traction-device", role: TriageTechniqueRole.adjunct)], confidence: TriageLeafConfidence.rankedPrimaryBackup)),
        TriageOption(id: "fa-fin-70", label: "Bone protruding through skin (Open)", icon: "figure.walk", destination: .technique("firstaid-open-fracture-management")),
        TriageOption(id: "fa-fin-71", label: "Arm or Wrist Deformity", icon: "figure.walk", destination: TriageDestination.rankedTechniqueList([RankedTechnique(id: "firstaid-arm-splint", role: TriageTechniqueRole.primary), RankedTechnique(id: "firstaid-finger-dislocation", role: TriageTechniqueRole.adjunct)], confidence: TriageLeafConfidence.rankedPrimaryBackup)),
        TriageOption(id: "fa-fin-72", label: "Lower Leg or Knee Deformity", icon: "figure.walk", destination: TriageDestination.rankedTechniqueList([RankedTechnique(id: "firstaid-leg-splint", role: TriageTechniqueRole.primary), RankedTechnique(id: "firstaid-knee-injury", role: TriageTechniqueRole.adjunct)], confidence: TriageLeafConfidence.rankedPrimaryBackup)),
        TriageOption(id: "fa-fin-74", label: "Shoulder / General Support", icon: "cross.case.fill", destination: TriageDestination.rankedTechniqueList([RankedTechnique(id: "firstaid-shoulder-reduction", role: TriageTechniqueRole.primary), RankedTechnique(id: "firstaid-splint-basics", role: TriageTechniqueRole.adjunct), RankedTechnique(id: "firstaid-sling", role: TriageTechniqueRole.contextual), RankedTechnique(id: "firstaid-cravat-sling", role: TriageTechniqueRole.contextual)], confidence: TriageLeafConfidence.complexContextual))
    ])
        )),
        TriageOption(id: "fa-fin-75", label: "Heat Burns / Chemical / Electrical", icon: "flame.fill", destination: .nextQuestion(
            TriageNode(id: "hurt-nq-2-79", question: "What is the primary condition or requirement?", options: [
        TriageOption(id: "fa-fin-76", label: "Burn Size < 20% of body", icon: "flame.fill", destination: .technique("firstaid-burn")),
        TriageOption(id: "fa-fin-77", label: "Burn Size > 20% of body", icon: "flame.fill", destination: .technique("firstaid-burn-escharotomy-signs")),
        TriageOption(id: "fa-fin-78", label: "Chemical exposure (Dry/Wet powder)", icon: "exclamationmark.triangle.fill", destination: TriageDestination.rankedTechniqueList([RankedTechnique(id: "firstaid-chem-dry-decon", role: TriageTechniqueRole.primary), RankedTechnique(id: "firstaid-chem-wet-decon", role: TriageTechniqueRole.adjunct), RankedTechnique(id: "firstaid-tear-gas-recovery", role: TriageTechniqueRole.contextual)], confidence: TriageLeafConfidence.rankedPrimaryBackup)),
        TriageOption(id: "fa-fin-79", label: "Electrical / Lightning shock", icon: "bolt.fill", destination: .technique("firstaid-lightning-strike"))
    ])
        )),
        TriageOption(id: "fa-fin-80", label: "Support Joint", icon: "figure.run", destination: TriageDestination.rankedTechniqueList([RankedTechnique(id: "firstaid-figure-8-bandage", role: TriageTechniqueRole.primary), RankedTechnique(id: "firstaid-sprain", role: TriageTechniqueRole.adjunct)], confidence: TriageLeafConfidence.rankedPrimaryBackup)),
        TriageOption(id: "fa-fin-81", label: "Minor Injuries (Punctures, Eyes, Dental)", icon: "mouth", destination: .nextQuestion(
            TriageNode(id: "hurt-nq-2-94", question: "What is the primary condition or requirement?", options: [
        TriageOption(id: "fa-fin-82a", label: "Eye Injuries", icon: "eye.fill", destination: .nextQuestion(
            TriageNode(id: "hurt-nq-3-eyes", question: "What is the primary condition or requirement?", options: [
        TriageOption(id: "fa-fin-82", label: "Chemical splash / debris", icon: "exclamationmark.triangle.fill", destination: .technique("firstaid-eye-irrigation")),
        TriageOption(id: "fa-fin-85", label: "Flash blind / Glare", icon: "eye.fill", destination: .technique("firstaid-snow-blindness")),
        TriageOption(id: "fa-fin-86", label: "Foreign body / General", icon: "eye.fill", destination: TriageDestination.rankedTechniqueList([RankedTechnique(id: "firstaid-eye-foreign-body", role: TriageTechniqueRole.primary), RankedTechnique(id: "firstaid-eye-field", role: TriageTechniqueRole.contextual)], confidence: TriageLeafConfidence.rankedPrimaryBackup)),
        TriageOption(id: "fa-fin-87", label: "Penetrating object", icon: "eye.fill", destination: .technique("firstaid-eye-shield-improvised"))
    ])
        )),
        TriageOption(id: "fa-fin-88a", label: "Dental / Tooth", icon: "mouth", destination: .nextQuestion(
            TriageNode(id: "hurt-nq-3-dental", question: "What is the primary condition or requirement?", options: [
        TriageOption(id: "fa-fin-88", label: "Toothache / missing filling", icon: "mouth", destination: TriageDestination.rankedTechniqueList([RankedTechnique(id: "firstaid-dental-temporary-filling", role: TriageTechniqueRole.primary), RankedTechnique(id: "firstaid-dental", role: TriageTechniqueRole.adjunct), RankedTechnique(id: "firstaid-toothache-field", role: TriageTechniqueRole.contextual)], confidence: TriageLeafConfidence.rankedPrimaryBackup)),
        TriageOption(id: "fa-fin-89", label: "Avulsed (Knocked-out) tooth", icon: "mouth", destination: .technique("firstaid-dental-avulsion"))
    ])
        )),
        TriageOption(id: "fa-fin-83", label: "Splinter / Cactus thorn", icon: "pin.fill", destination: TriageDestination.rankedTechniqueList([RankedTechnique(id: "firstaid-splinter", role: TriageTechniqueRole.primary), RankedTechnique(id: "firstaid-nail-bed-injury", role: TriageTechniqueRole.adjunct)], confidence: TriageLeafConfidence.rankedPrimaryBackup)),
        TriageOption(id: "fa-fin-84", label: "Blisters / Scrapes", icon: "bandage", destination: .technique("firstaid-blister")),
        TriageOption(id: "fa-fin-91", label: "Embedded Fish Hook", icon: "pin.fill", destination: .technique("firstaid-fishhook-removal")),
        TriageOption(id: "fa-fin-92", label: "Impaled object (Left in place)", icon: "pin.fill", destination: .technique("firstaid-impaled-object-stabilize")),
        TriageOption(id: "fa-fin-93", label: "Visible object in Ear/Nose", icon: "ear.fill", destination: .technique("firstaid-foreign-body-ear")),
        TriageOption(id: "fa-fin-94", label: "Pressure change / Dive ear pain", icon: "ear.fill", destination: .technique("firstaid-barotrauma-ear"))
    ])
        )),
        TriageOption(id: "fa-fin-95", label: "Bites & Stings", icon: "ant.fill", destination: .nextQuestion(
            TriageNode(id: "hurt-nq-2-108", question: "What bit or stung you?", options: [
        TriageOption(id: "fa-fin-96", label: "Marine Stings (Stingray, Urchin, Jellyfish)", icon: "figure.stand", destination: TriageDestination.rankedTechniqueList([RankedTechnique(id: "firstaid-stingray-hot-water", role: TriageTechniqueRole.primary), RankedTechnique(id: "firstaid-sting-treat", role: TriageTechniqueRole.adjunct), RankedTechnique(id: "firstaid-jellyfish-vinegar", role: TriageTechniqueRole.contextual), RankedTechnique(id: "firstaid-cone-snail", role: TriageTechniqueRole.contextual), RankedTechnique(id: "firstaid-blue-ring-octopus", role: TriageTechniqueRole.contextual), RankedTechnique(id: "firstaid-sea-urchin", role: TriageTechniqueRole.contextual)], confidence: TriageLeafConfidence.complexContextual)),
        TriageOption(id: "fa-fin-98", label: "Insect Stings (Bee, Wasp, Centipede)", icon: "ant.fill", destination: TriageDestination.rankedTechniqueList([RankedTechnique(id: "firstaid-bee-sting", role: TriageTechniqueRole.primary), RankedTechnique(id: "firstaid-centipede-bite", role: TriageTechniqueRole.adjunct)], confidence: TriageLeafConfidence.rankedPrimaryBackup)),
        TriageOption(id: "fa-fin-101", label: "Snakebite", icon: "bolt.fill", destination: TriageDestination.rankedTechniqueList([RankedTechnique(id: "firstaid-snake-bite-pressure-immobilization", role: TriageTechniqueRole.primary), RankedTechnique(id: "firstaid-snakebite-pit-viper", role: TriageTechniqueRole.adjunct), RankedTechnique(id: "firstaid-snakebite-coral", role: TriageTechniqueRole.contextual)], confidence: TriageLeafConfidence.rankedPrimaryBackup)),
        TriageOption(id: "fa-fin-104", label: "Spider / Scorpion", icon: "ladybug.fill", destination: TriageDestination.rankedTechniqueList([RankedTechnique(id: "firstaid-black-widow-bite", role: TriageTechniqueRole.primary), RankedTechnique(id: "firstaid-spider-bite-recluse", role: TriageTechniqueRole.adjunct), RankedTechnique(id: "firstaid-scorpion-sting", role: TriageTechniqueRole.contextual)], confidence: TriageLeafConfidence.rankedPrimaryBackup)),
        TriageOption(id: "fa-fin-107", label: "Mammal Bite (Dog, Bat, Rabies)", icon: "pawprint.fill", destination: .technique("firstaid-expert-rabies-exposure"))
    ])
        )),
        TriageOption(id: "fa-fin-109", label: "Environmental Extremes", icon: "cross.case.fill", destination: .nextQuestion(
            TriageNode(id: "hurt-nq-2-119", question: "What is the primary condition or requirement?", options: [
        TriageOption(id: "fa-fin-110", label: "Altitude Illness (AMS, HAPE, HACE)", icon: "mountain.2.fill", destination: TriageDestination.rankedTechniqueList([RankedTechnique(id: "firstaid-altitude-sickness-ams", role: TriageTechniqueRole.primary), RankedTechnique(id: "firstaid-hape-treatment", role: TriageTechniqueRole.adjunct), RankedTechnique(id: "firstaid-hace-treatment", role: TriageTechniqueRole.contextual), RankedTechnique(id: "firstaid-altitude", role: TriageTechniqueRole.contextual)], confidence: TriageLeafConfidence.complexContextual)),
        TriageOption(id: "fa-fin-111", label: "Mild Hypothermia (Shivering / Alert)", icon: "snowflake", destination: .technique("firstaid-hypothermia-mild-self")),
        TriageOption(id: "fa-fin-112", label: "Severe Hypothermia (No Shivering)", icon: "snowflake", destination: TriageDestination.rankedTechniqueList([RankedTechnique(id: "firstaid-hypothermia-active-warming", role: TriageTechniqueRole.primary), RankedTechnique(id: "firstaid-hypothermia-wrap", role: TriageTechniqueRole.adjunct), RankedTechnique(id: "firstaid-cold-water-immersion", role: TriageTechniqueRole.contextual)], confidence: TriageLeafConfidence.rankedPrimaryBackup)),
        TriageOption(id: "fa-fin-115", label: "Frostbite / Trench Foot", icon: "snowflake", destination: TriageDestination.rankedTechniqueList([RankedTechnique(id: "firstaid-frostbite-thaw-decision", role: TriageTechniqueRole.primary), RankedTechnique(id: "firstaid-frostbite-rapid-rewarm", role: TriageTechniqueRole.adjunct), RankedTechnique(id: "firstaid-trench-foot", role: TriageTechniqueRole.contextual), RankedTechnique(id: "firstaid-chilblains", role: TriageTechniqueRole.contextual), RankedTechnique(id: "firstaid-immersion-foot", role: TriageTechniqueRole.contextual)], confidence: TriageLeafConfidence.complexContextual)),
        TriageOption(id: "fa-fin-118", label: "Salt Imbalance / Dehydration", icon: "cross.case.fill", destination: TriageDestination.rankedTechniqueList([RankedTechnique(id: "firstaid-dehydration-response", role: TriageTechniqueRole.primary), RankedTechnique(id: "firstaid-hyponatremia", role: TriageTechniqueRole.adjunct), RankedTechnique(id: "firstaid-pediatric-dehydration", role: TriageTechniqueRole.contextual)], confidence: TriageLeafConfidence.rankedPrimaryBackup)),
        TriageOption(id: "fa-fin-119", label: "Heat Exhaustion (Cool / Rest / Fluids)", icon: "flame.fill", destination: .technique("firstaid-heat-exhaustion-stroke"))
    ])
        )),
        TriageOption(id: "fa-fin-120", label: "Assessment / Triage Check", icon: "stethoscope", destination: .nextQuestion(
            TriageNode(id: "hurt-nq-2-125", question: "What is the primary condition or requirement?", options: [
        TriageOption(id: "fa-fin-121", label: "Mass Casualty Incident Sorting", icon: "cross.case.fill", destination: TriageDestination.rankedTechniqueList([RankedTechnique(id: "firstaid-mass-casualty-start", role: TriageTechniqueRole.primary), RankedTechnique(id: "firstaid-salt-triage", role: TriageTechniqueRole.adjunct)], confidence: TriageLeafConfidence.rankedPrimaryBackup)),
        TriageOption(id: "fa-fin-122", label: "Checking Vitals", icon: "stethoscope", destination: TriageDestination.rankedTechniqueList([RankedTechnique(id: "firstaid-blood-pressure-field", role: TriageTechniqueRole.primary), RankedTechnique(id: "firstaid-nerve-assessment", role: TriageTechniqueRole.adjunct), RankedTechnique(id: "firstaid-drowning-aftercare", role: TriageTechniqueRole.contextual), RankedTechnique(id: "firstaid-vital-signs", role: TriageTechniqueRole.contextual)], confidence: TriageLeafConfidence.complexContextual)),
        TriageOption(id: "fa-fin-123", label: "Pediatric PAT Assessment", icon: "stethoscope", destination: .technique("firstaid-pediatric-assessment-triangle")),
        TriageOption(id: "fa-fin-124", label: "Secondary Head-to-Toe Survey", icon: "stethoscope", destination: TriageDestination.rankedTechniqueList([RankedTechnique(id: "firstaid-abdominal-assessment", role: TriageTechniqueRole.primary), RankedTechnique(id: "firstaid-secondary-survey", role: TriageTechniqueRole.adjunct)], confidence: TriageLeafConfidence.rankedPrimaryBackup)),
        TriageOption(id: "fa-fin-125", label: "Primary ABCDE Survey", icon: "stethoscope", destination: TriageDestination.rankedTechniqueList([RankedTechnique(id: "firstaid-primary-survey", role: TriageTechniqueRole.primary), RankedTechnique(id: "firstaid-rapid-trauma-survey", role: TriageTechniqueRole.adjunct)], confidence: TriageLeafConfidence.rankedPrimaryBackup))
    ])
        )),
        TriageOption(id: "fa-fin-126", label: "Advanced Emergency Procedures", icon: "cross.case.fill", destination: .nextQuestion(
            TriageNode(id: "hurt-nq-2-136", question: "What is the primary condition or requirement?", options: [
        TriageOption(id: "fa-fin-127", label: "Chest Procedures (Needle Decomp, Dressing)", icon: "lungs.fill", destination: TriageDestination.rankedTechniqueList([RankedTechnique(id: "firstaid-needle-decompression", role: TriageTechniqueRole.primary), RankedTechnique(id: "firstaid-sucking-chest-dressing", role: TriageTechniqueRole.adjunct)], confidence: TriageLeafConfidence.rankedPrimaryBackup)),
        TriageOption(id: "fa-fin-129", label: "Breathing: Panic / Hyperventilation", icon: "lungs.fill", destination: TriageDestination.rankedTechniqueList([RankedTechnique(id: "firstaid-hyperventilation", role: TriageTechniqueRole.primary), RankedTechnique(id: "firstaid-panic-attack", role: TriageTechniqueRole.adjunct)], confidence: TriageLeafConfidence.rankedPrimaryBackup)),
        TriageOption(id: "fa-fin-130", label: "Advanced Airway Insertion", icon: "lungs.fill", destination: TriageDestination.rankedTechniqueList([RankedTechnique(id: "firstaid-nasopharyngeal-airway", role: TriageTechniqueRole.primary), RankedTechnique(id: "firstaid-airway-jaw-thrust", role: TriageTechniqueRole.adjunct)], confidence: TriageLeafConfidence.rankedPrimaryBackup)),
        TriageOption(id: "fa-fin-131", label: "Cardiac / Shock / Blood", icon: "heart.fill", destination: TriageDestination.rankedTechniqueList([RankedTechnique(id: "firstaid-pericardiocentesis-signs", role: TriageTechniqueRole.primary), RankedTechnique(id: "firstaid-shock-treatment", role: TriageTechniqueRole.adjunct), RankedTechnique(id: "firstaid-field-blood-transfusion-prep", role: TriageTechniqueRole.contextual)], confidence: TriageLeafConfidence.complexContextual)),
        TriageOption(id: "fa-fin-132", label: "Diver Pressure Injury Prep", icon: "water.waves", destination: .technique("firstaid-decompression-sickness")),
        TriageOption(id: "fa-fin-133", label: "Emergency Childbirth", icon: "figure.and.child.holdinghands", destination: .technique("firstaid-emergency-childbirth")),
        TriageOption(id: "fa-fin-134", label: "Crush / Blast / Compartment Injury", icon: "exclamationmark.triangle.fill", destination: TriageDestination.rankedTechniqueList([RankedTechnique(id: "firstaid-crush-syndrome-management", role: TriageTechniqueRole.primary), RankedTechnique(id: "firstaid-compartment-syndrome", role: TriageTechniqueRole.adjunct), RankedTechnique(id: "firstaid-blast-injury-primary", role: TriageTechniqueRole.contextual)], confidence: TriageLeafConfidence.rankedPrimaryBackup))
    ])
        ))
    ])
        ))
    ])
    }
}
