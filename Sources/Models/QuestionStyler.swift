import Foundation

// MARK: - Context-Aware Question Stems (View-Layer Only)
// Deterministic mapping from generic triage prompts to human-centered phrasing.
// No tree structure, ordering, or destination changes.
//
// Matcher order (specific → broad):
//  1. Equipment  2. Choking  3. Chest trauma  4. Burns  5. Environmental
//  6. Bites/Stings  7. Fractures  8. Sprains  9. Dental  10. Eye
// 11. Minor injury 12. Symptoms/illness 13. Life threats (narrow)
// 14. Assessment 15. Transport 16. Herbal 17. Fallback

enum QuestionStyler {
    
    // MARK: - Coverage helper
    /// Returns true if domain keywords match strictly more than half of individual labels.
    /// Prevents a single matching tile from overriding the question for all siblings.
    private static func labelCoverage(_ labels: [String], keywords: [String]) -> Bool {
        let matched = labels.filter { label in
            let l = label.lowercased()
            return keywords.contains { l.contains($0) }
        }.count
        return matched * 2 > labels.count
    }
    
    static func styledQuestion(original: String, optionLabels: [String]) -> String {
        let q = original.lowercased()
        let combined = optionLabels.joined(separator: " ").lowercased()
        
        // --- Ambiguity guard ---
        // If labels span 3+ distinct clinical domains, fall back to original.
        let domainHits = [
            combined.contains("burn"),
            combined.contains("fracture") || combined.contains("dislocation"),
            combined.contains("bite") || combined.contains("sting"),
            combined.contains("eye"),
            combined.contains("dental") || combined.contains("tooth"),
            combined.contains("bleeding") || combined.contains("laceration"),
            combined.contains("seizure") || combined.contains("stroke"),
            combined.contains("hypothermia") || combined.contains("frostbite")
        ].filter { $0 }.count
        
        if domainHits >= 3 {
            return original
        }
        
        // --- 1. Main Category gate ---
        if q.contains("equipment") || q.contains("select") ||
           combined.contains("standard first aid") || combined.contains("wilderness") {
            return "Select a First Aid category:"
        }
        
        // --- 2. Choking ---
        if (combined.contains("choking") || (combined.contains("conscious") && combined.contains("infant")))
            && labelCoverage(optionLabels, keywords: ["choking", "airway", "blocked", "conscious", "unconscious", "infant"]) {
            return "Who is choking?"
        }
        
        // --- 3. Chest trauma ---
        if combined.contains("chest") && (combined.contains("trauma") || combined.contains("pneumo") ||
           combined.contains("rib") || combined.contains("collapsing") || combined.contains("trachea"))
            && labelCoverage(optionLabels, keywords: ["chest", "pneumo", "rib", "trachea", "collaps", "suck", "bubbl", "lung"]) {
            return "What is the chest injury?"
        }
        
        // --- 4. Burns ---
        if combined.contains("burn") || (combined.contains("chemical") && combined.contains("exposure")) ||
           combined.contains("sunburn") || combined.contains("escharotomy") {
            return "What type of burn or exposure?"
        }
        
        // --- 5. Environmental ---
        if combined.contains("hypothermia") || combined.contains("frostbite") ||
           combined.contains("altitude") || combined.contains("trench foot") ||
           combined.contains("cold water immersion") ||
           (combined.contains("heat") && (combined.contains("exhaustion") || combined.contains("dehydration"))) {
            return "What is the environmental condition?"
        }
        
        // --- 6. Bites & Stings ---
        if combined.contains("snake") || combined.contains("spider") ||
           combined.contains("scorpion") || combined.contains("jellyfish") ||
           combined.contains("urchin") || combined.contains("mammal") ||
           (combined.contains("bite") && !combined.contains("frostbite")) ||
           (combined.contains("sting") && combined.contains("insect")) {
            return "What caused the bite or sting?"
        }
        
        // --- 7. Fractures ---
        // Note: removed "splint" — it's a substring of "splinter" which belongs to minor injuries.
        if (combined.contains("fracture") || combined.contains("femur") ||
           combined.contains("pelvis") || combined.contains("bone protruding") ||
           combined.contains("deformity"))
            && labelCoverage(optionLabels, keywords: ["fracture", "femur", "pelvis", "bone", "deformity", "sling", "rest"]) {
            return "Where is the suspected fracture?"
        }
        
        // --- 8. Sprains ---
        if combined.contains("sprain") || combined.contains("strain") ||
           combined.contains("ankle") || combined.contains("muscle injur") {
            return "Where is the sprain or strain?"
        }
        
        // --- 9. Dental ---
        if (combined.contains("dental") || combined.contains("tooth") ||
           combined.contains("toothache") || combined.contains("filling") ||
           combined.contains("jaw dislocation"))
            && labelCoverage(optionLabels, keywords: ["dental", "tooth", "toothache", "filling", "jaw", "avulsed", "knocked"]) {
            return "What is the dental issue?"
        }
        
        // --- 10. Eye ---
        if combined.contains("eye") && (combined.contains("shield") || combined.contains("foreign") ||
           combined.contains("flush") || combined.contains("irritat"))
            && labelCoverage(optionLabels, keywords: ["eye", "flash", "blind", "glare"]) {
            return "What is the eye issue?"
        }
        
        // --- 11. Minor injury ---
        if combined.contains("blister") || combined.contains("splinter") ||
           combined.contains("fish hook") || combined.contains("nail bed") ||
           combined.contains("puncture") || combined.contains("impaled") {
            return "What type of injury is it?"
        }
        
        // --- 12. Symptoms / illness ---
        if combined.contains("diabetic") || combined.contains("seizure") ||
           combined.contains("stroke") || combined.contains("allergic") ||
           combined.contains("infection") || combined.contains("fever") ||
           combined.contains("poison") || combined.contains("constipation") ||
           combined.contains("kidney") || combined.contains("stomach") {
            return "What best matches the situation?"
        }
        
        // --- 13. Life threats (narrow — strong signals only) ---
        let lifeThreatHits = [
            "not breathing", "cpr", "tourniquet", "spurting",
            "arterial", "amputation", "unconscious"
        ]
        let isLifeThreat = lifeThreatHits.contains { combined.contains($0) }
        if isLifeThreat
            && labelCoverage(optionLabels, keywords: ["breathing", "arterial", "spurting", "cpr", "tourniquet", "amputation", "unconscious", "choking", "bleeding", "airway"]) {
            return "Where is the life-threatening problem?"
        }
        
        // Life-threat adjacent (bleeding categories)
        if combined.contains("laceration") && combined.contains("closure") {
            return "How should the wound be closed?"
        }
        if combined.contains("hemorrhage") || combined.contains("junctional") {
            return "Where is the bleeding source?"
        }
        
        // --- 14. Assessment ---
        if combined.contains("survey") || combined.contains("triage") ||
           combined.contains("mass casualty") || combined.contains("vital") {
            return "What are you observing?"
        }
        
        // --- 15. Transport ---
        if (combined.contains("helicopter") || combined.contains("evacuation") ||
           combined.contains("stretcher") || combined.contains("litter"))
            && labelCoverage(optionLabels, keywords: ["transport", "evacuation", "litter", "carry", "helicopter", "stretcher", "shelter", "air evac"]) {
            return "What transport is available?"
        }
        
        // --- 16. Herbal ---
        if (combined.contains("herbal") || combined.contains("poultice") ||
           combined.contains("willow") || combined.contains("yarrow") ||
           combined.contains("honey") || combined.contains("remedy"))
            && labelCoverage(optionLabels, keywords: ["herbal", "poultice", "willow", "yarrow", "honey", "remedy", "tea", "infusion"]) {
            return "What type of remedy do you need?"
        }
        
        // --- 16b. Expert / Advanced Procedures ---
        if combined.contains("prep") || combined.contains("protocol") {
            let advancedKeywords = ["prep", "protocol", "insertion", "decompression", "tamponade", "barotrauma", "transfusion", "childbirth"]
            if labelCoverage(optionLabels, keywords: advancedKeywords) {
                return "What emergency procedure is needed?"
            }
        }
        
        // --- 17. Head & Spine ---
        if combined.contains("spine") || combined.contains("head injury") ||
           combined.contains("neck pain") || combined.contains("concussion") {
            return "What is the head or spine concern?"
        }
        
        // --- 18. Primary threat screen ---
        if q.contains("primary threat") || q.contains("identify primary") {
            return "What is the primary concern?"
        }
        
        // --- Fallback ---
        return original
    }
}

// MARK: - TriageNode Presentation Extension

extension TriageNode {
    /// Context-aware question for display. Maps generic prompts to human-centered phrasing.
    var displayQuestion: String {
        QuestionStyler.styledQuestion(
            original: question,
            optionLabels: options.map { $0.label }
        )
    }
}
