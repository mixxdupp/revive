import Foundation

// Auto-generated: buildChemicalTriage extracted from ContentDatabase.swift
extension ContentDatabase {
    // =========================================================================
    // MARK: - CHEMICAL / HAZMAT (NEW)
    // =========================================================================
    func buildChemicalTriage() -> TriageNode {
        TriageNode(id: "chem-em-root", question: "What is the exposure?", options: [
            TriageOption(id: "chem-air", label: "Airborne Gas / Smoke", icon: "wind", destination: .nextQuestion(
                TriageNode(id: "chem-air-q", question: "Can you evacuate?", options: [
                    TriageOption(id: "chem-run", label: "Yes — Move Crosswind", icon: "arrow.up.right", destination: .technique("env-hazmat-evac")), // Placeholder
                    TriageOption(id: "chem-shelter", label: "No — Shelter in Place", icon: "house.fill", destination: .technique("shelter-seal-room")) // Placeholder
                ])
            )),
            TriageOption(id: "chem-contact", label: "Skin Contact / Spill", icon: "drop.fill", destination: .nextQuestion(
                TriageNode(id: "chem-skin-q", question: "What substance?", options: [
                    TriageOption(id: "chem-acid", label: "Acid / Corrosive", icon: "exclamationmark.triangle.fill", destination: .technique("firstaid-chem-burn")),
                    TriageOption(id: "chem-unk", label: "Unknown Powder/Liquid", icon: "questionmark.circle", destination: .technique("firstaid-decon")) // Placeholder
                ])
            )),
            TriageOption(id: "chem-radio", label: "Radiation / Nuclear", icon: "atom", destination: .technique("env-nuclear-fallout")), // Placeholder
            
            // Learn More
            TriageOption(id: "chem-learn", label: "Learn More", icon: "book.fill", destination: .nextQuestion(
                TriageNode(id: "chem-learn-q", question: "Hazmat safety topics?", options: [
                    TriageOption(id: "chem-art-decon", label: "Decontamination", icon: "shower.fill", destination: .article("firstaid-article-environmental")), // Placeholder
                    TriageOption(id: "chem-art-shelter", label: "Sheltering in Place", icon: "house.fill", destination: .article("shelter-article-urban")) // Placeholder
                ])
            ))
        ])
    }

}
