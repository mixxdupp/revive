import Foundation

// Auto-generated: buildHeatTriage extracted from ContentDatabase.swift
extension ContentDatabase {
    // =========================================================================
    // MARK: - EXTREME HEAT (NEW)
    // =========================================================================
    func buildHeatTriage() -> TriageNode {
        TriageNode(id: "heat-em-root", question: "What is the heat emergency?", options: [
            TriageOption(id: "heat-illness", label: "Feeling Sick / Dizzy", icon: "thermometer.sun.fill", destination: .nextQuestion(
                TriageNode(id: "heat-illness-q", question: "Symptoms?", options: [
                    TriageOption(id: "heat-exhaustion", label: "Heavy Sweating / Pale / Weak", icon: "drop.fill", destination: .technique("firstaid-heat-exhaustion")),
                    TriageOption(id: "heat-stroke", label: "Hot Dry Skin / Confusion / No Sweat", icon: "exclamationmark.triangle.fill", destination: .technique("firstaid-heatstroke")),
                    TriageOption(id: "heat-cramps", label: "Muscle Cramps / Spasms", icon: "bolt.fill", destination: .technique("firstaid-heat-cramps"))
                ])
            )),
            TriageOption(id: "heat-burn", label: "Sunburn / Burns", icon: "flame", destination: .nextQuestion(
                TriageNode(id: "heat-burn-q", question: "Severity?", options: [
                    TriageOption(id: "heat-sunburn", label: "Red / Painful (Sunburn)", icon: "sun.max.fill", destination: .technique("firstaid-sunburn")),
                    TriageOption(id: "heat-burn-blister", label: "Blistered / Charred", icon: "flame", destination: .technique("firstaid-burn-treat"))
                ])
            )),
            TriageOption(id: "heat-water", label: "Dehydration / No Water", icon: "drop.triangle.fill", destination: .technique("firstaid-dehydration")),
            
            // Learn More
            TriageOption(id: "heat-learn", label: "Learn More", icon: "book.fill", destination: .nextQuestion(
                TriageNode(id: "heat-learn-q", question: "Read about heat safety?", options: [
                    TriageOption(id: "heat-art-illness", label: "Heat Illnesses", icon: "thermometer.sun.fill", destination: .article("firstaid-article-environmental")),
                    TriageOption(id: "heat-art-water", label: "Water Needs", icon: "drop.fill", destination: .article("water-article-rationing"))
                ])
            )),

            TriageOption(id: "g927", label: "Air Quality", icon: "cross.case.fill", destination: .nextQuestion(
                TriageNode(id: "g927-q", question: "Which best matches?", options: [
                    TriageOption(id: "g928", label: "Manage respiratory and eye protection during extended d", icon: "eye.fill", destination: .technique("env-dust-storm-health"))
                ])
            )),

            TriageOption(id: "g929", label: "Desert & Heat", icon: "sun.max.fill", destination: .nextQuestion(
                TriageNode(id: "g929-q", question: "What specifically?", options: [
                TriageOption(id: "g930", label: "Extreme", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g930-q", question: "Select:", options: [
                        TriageOption(id: "g931", label: "Navigate safely when the sun is down", icon: "sun.max.fill", destination: .technique("env-desert-night-adv")),
                        TriageOption(id: "g932", label: "The physiological truth about rationing water in extrem", icon: "sun.max.fill", destination: .technique("env-desert-water-rationing"))
                    ])
                )),
                TriageOption(id: "g933", label: "Shelter", icon: "house.fill", destination: .nextQuestion(
                    TriageNode(id: "g933-q", question: "Select:", options: [
                        TriageOption(id: "g934", label: "Shade is survival in the desert", icon: "house.fill", destination: .technique("env-desert-shelter-adv")),
                        TriageOption(id: "g935", label: "Protecting yourself in a desert sandstorm", icon: "house.fill", destination: .technique("env-sandstorm-survival"))
                    ])
                )),
                TriageOption(id: "g936", label: "Water", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g936-q", question: "Select:", options: [
                        TriageOption(id: "g937", label: "Managing hydration when water is critically limited", icon: "sun.max.fill", destination: .technique("env-desert-water-strategy")),
                        TriageOption(id: "g938", label: "Desert water sources that most people miss", icon: "sun.max.fill", destination: .technique("env-desert-water-adv"))
                    ])
                )),
                TriageOption(id: "g939", label: "Heat", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g939-q", question: "Select:", options: [
                        TriageOption(id: "g940", label: "Differentiating the two stages before it becomes fatal", icon: "brain.head.profile", destination: .technique("env-heat-exhaustion"))
                    ])
                ))
                ])
            )),
        ])
    }

}
