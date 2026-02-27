import Foundation

// Auto-generated: buildHeatTriage extracted from ContentDatabase.swift
extension ContentDatabase {
    // =========================================================================
    // MARK: - EXTREME HEAT
    // =========================================================================
    func buildHeatTriage() -> TriageNode {
        TriageNode(id: "heat-em-root", question: "What do you need?", options: [

            // ── HEAT ILLNESS ──
            TriageOption(id: "heat-illness", label: "Feeling Sick / Dizzy", icon: "thermometer.sun.fill", destination: .nextQuestion(
                TriageNode(id: "heat-illness-q", question: "Symptoms?", options: [
                    TriageOption(id: "heat-cramps", label: "Muscle Cramps / Spasms", icon: "bolt.fill", destination: .technique("firstaid-heat-cramp-field")),
                    TriageOption(id: "heat-exhaust", label: "Heavy Sweating / Pale / Weak", icon: "drop.fill", destination: .techniqueList(["firstaid-heat-exhaustion", "env-heat-exhaustion-treatment"])),
                    TriageOption(id: "heat-stroke", label: "Hot Dry Skin / Confusion / No Sweat", icon: "exclamationmark.triangle.fill", destination: .techniqueList(["firstaid-heatstroke", "firstaid-heat-stroke", "firstaid-heatstroke-tarp-cooling"])),
                    TriageOption(id: "heat-not-sure", label: "Not Sure — Is it Exhaustion or Stroke?", icon: "questionmark.circle", destination: .technique("firstaid-heat-exhaustion-stroke")),
                    TriageOption(id: "heat-child", label: "Child / Infant Dehydrated", icon: "figure.and.child.holdinghands", destination: .technique("firstaid-pediatric-dehydration"))
                ])
            )),

            // ── SUNBURN / BURNS ──
            TriageOption(id: "heat-burn", label: "Sunburn / Burns", icon: "flame", destination: .nextQuestion(
                TriageNode(id: "heat-burn-q", question: "Severity?", options: [
                    TriageOption(id: "heat-sunburn", label: "Red / Painful (Sunburn)", icon: "sun.max.fill", destination: .technique("firstaid-sunburn")),
                    TriageOption(id: "heat-burn-blister", label: "Blistered / Charred", icon: "flame", destination: .technique("firstaid-burn-treat"))
                ])
            )),

            // ── DEHYDRATION ──
            TriageOption(id: "heat-dehydration", label: "Dehydration / No Water", icon: "drop.triangle.fill", destination: .nextQuestion(
                TriageNode(id: "heat-dehydration-q", question: "How bad?", options: [
                    TriageOption(id: "heat-dehydr-mild", label: "Thirsty / Dry Mouth / Dark Urine", icon: "drop.fill", destination: .technique("firstaid-dehydration")),
                    TriageOption(id: "heat-dehydr-severe", label: "Dizzy / Confused / No Urine", icon: "exclamationmark.triangle.fill", destination: .techniqueList(["firstaid-dehydration", "firstaid-heat-exhaustion"])),
                    TriageOption(id: "heat-find-water", label: "Need to Find Water", icon: "magnifyingglass", destination: .techniqueList(["env-desert-water", "env-desert-water-strategy", "env-desert-water-adv"]))
                ])
            )),

            // ── DESERT STRATEGY ──
            TriageOption(id: "heat-desert", label: "Desert Survival Strategy", icon: "sun.max.fill", destination: .nextQuestion(
                TriageNode(id: "heat-desert-q", question: "What do you need?", options: [
                    TriageOption(id: "heat-desert-shade", label: "Shade / Shelter from Sun", icon: "tent.fill", destination: .techniqueList(["env-desert-shelter", "env-desert-shelter-adv"])),
                    TriageOption(id: "heat-desert-travel", label: "Travel Strategy (When / How)", icon: "figure.walk", destination: .techniqueList(["env-desert-travel", "env-desert-night-adv"])),
                    TriageOption(id: "heat-desert-water", label: "Water Rationing", icon: "drop.fill", destination: .technique("env-desert-water-rationing")),
                    TriageOption(id: "heat-desert-general", label: "General Extreme Heat Tips", icon: "thermometer.sun.fill", destination: .technique("env-extreme-heat"))
                ])
            )),

            // 📚 LEARN MORE
            TriageOption(id: "heat-learn", label: "Learn More", icon: "book.fill", destination: .nextQuestion(
                TriageNode(id: "heat-learn-q", question: "Read about heat safety?", options: [
                    TriageOption(id: "heat-art-illness", label: "Heat Illnesses", icon: "thermometer.sun.fill", destination: .article("firstaid-article-environmental")),
                    TriageOption(id: "heat-art-water", label: "Water Needs", icon: "drop.fill", destination: .article("water-article-rationing")),
                    TriageOption(id: "heat-art-desert", label: "Desert Survival", icon: "sun.max.fill", destination: .article("env-article-desert"))
                ])
            ))
        ])
    }

}
