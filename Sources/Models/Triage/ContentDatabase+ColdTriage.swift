import Foundation

extension ContentDatabase {
    // =========================================================================
    // MARK: - COLD / HYPOTHERMIA — SSC Rebuilt (≤3 taps)
    // =========================================================================
    func buildColdTriage() -> TriageNode {
        TriageNode(id: "cold-root", question: "What do you need?", options: [

            // ── BUILD SHELTER (NO SHELTER) ──
            TriageOption(id: "cold-no-shelter", label: "Build Shelter (No Shelter)", icon: "tent.fill", destination: .nextQuestion(
                TriageNode(id: "cold-env", question: "What environment?", options: [
                    TriageOption(id: "cold-forest-tarp", label: "Forest — Have Tarp", icon: "square.fill", destination: .techniqueList(["shelter-tarp-aframe", "shelter-tarp-leanto", "shelter-tarp-cfly"])),
                    TriageOption(id: "cold-forest-nothing", label: "Forest — No Materials", icon: "leaf.fill", destination: .techniqueList(["shelter-debris-aframe", "shelter-debris-round"])),
                    TriageOption(id: "cold-snow-deep", label: "Deep Snow — Can Dig", icon: "snowflake", destination: .techniqueList(["shelter-quinzhee", "shelter-snow-cave"])),
                    TriageOption(id: "cold-snow-surface", label: "Snow — Surface Only", icon: "snowflake", destination: .technique("shelter-snow-trench")),
                    TriageOption(id: "cold-mountain", label: "Mountain / Exposed Ridge", icon: "mountain.2.fill", destination: .techniqueList(["env-cave-survival", "shelter-emergency-bivy"])),
                    TriageOption(id: "cold-urban-out", label: "Urban / Outdoors", icon: "building.2.fill", destination: .technique("shelter-emergency-bivy"))
                ])
            )),

            // ── START FIRE ──
            TriageOption(id: "cold-need-fire", label: "Start a Fire", icon: "flame", destination: .nextQuestion(
                TriageNode(id: "cold-fire-q", question: "What do you have?", options: [
                    TriageOption(id: "cold-lighter", label: "Lighter / Matches", icon: "flame", destination: .techniqueList(["fire-teepee", "fire-long-fire", "fire-log-cabin"])),
                    TriageOption(id: "cold-ferro", label: "Ferro Rod", icon: "sparkle", destination: .technique("fire-ferrorod")),
                    TriageOption(id: "cold-sun-lens", label: "Sun + Lens / Bottle", icon: "sun.max.fill", destination: .technique("fire-magnifying")),
                    TriageOption(id: "cold-no-tools", label: "Nothing — No Tools", icon: "xmark.circle.fill", destination: .technique("fire-bowdrill"))
                ])
            )),

            // ── MEDICAL & WET CLOTHES ──
            TriageOption(id: "cold-med-wet", label: "Hypothermia / Wet Clothes", icon: "thermometer.snowflake", destination: .nextQuestion(
                TriageNode(id: "cold-med-wet-q", question: "What is your status?", options: [
                    TriageOption(id: "cold-shivering", label: "Shivering / Still Alert", icon: "exclamationmark.circle", destination: .technique("firstaid-hypothermia")),
                    TriageOption(id: "cold-severe", label: "No Shivering / Confused", icon: "exclamationmark.triangle.fill", destination: .techniqueList(["firstaid-hypothermia", "firstaid-recovery-position"])),
                    TriageOption(id: "cold-frostbite", label: "Numbness / Frostbite", icon: "hand.raised.fill", destination: .technique("env-arctic-frostbite")),
                    TriageOption(id: "cold-wet-yes", label: "Wet Clothes — Can Make Fire", icon: "flame", destination: .techniqueList(["fire-teepee", "shelter-fire-reflector"])),
                    TriageOption(id: "cold-wet-no", label: "Wet Clothes — No Fire", icon: "xmark.circle", destination: .techniqueList(["shelter-mylar-wrap", "firstaid-hypothermia"])),
                    TriageOption(id: "cold-trenchfoot", label: "Wet Painful Feet", icon: "drop.fill", destination: .technique("firstaid-trench-foot"))
                ])
            )),

            // ── IMPROVE EXISTING SHELTER ──
            TriageOption(id: "cold-improve", label: "Improve Existing Shelter", icon: "wrench.fill", destination: .nextQuestion(
                TriageNode(id: "cold-imp-q", question: "What improvement?", options: [
                    TriageOption(id: "cold-imp-bed", label: "Heated Sleeping Platform", icon: "flame", destination: .technique("shelter-heated-bed")),
                    TriageOption(id: "cold-imp-reflect", label: "Fire Reflector Wall", icon: "rectangle.split.3x1.fill", destination: .technique("shelter-fire-reflector")),
                    TriageOption(id: "cold-imp-vent", label: "Ventilation (Prevent CO)", icon: "wind", destination: .technique("shelter-ventilation")),
                    TriageOption(id: "cold-imp-wall", label: "Snow Wall Windbreak", icon: "square.stack.fill", destination: .technique("shelter-snow-wall")),
                    TriageOption(id: "cold-imp-door", label: "Door / Entrance Block", icon: "door.left.hand.closed", destination: .technique("shelter-door-construction")),
                    TriageOption(id: "cold-imp-insul", label: "Insulation (Mylar/Leaves)", icon: "leaf.fill", destination: .techniqueList(["shelter-ground-insulation", "shelter-mylar-wrap"]))
                ])
            )),

            // ── TRAVEL & MENTAL ──
            TriageOption(id: "cold-travel-mental", label: "Travel & Mindset", icon: "figure.walk", destination: .nextQuestion(
                TriageNode(id: "cold-travel-mental-q", question: "What do you need?", options: [
                    TriageOption(id: "cold-arctic", label: "Travel on Snow / Ice", icon: "snowflake", destination: .techniqueList(["env-arctic-travel", "env-tundra-travel", "nav-snow-navigation"])),
                    TriageOption(id: "cold-goggles", label: "Snow Blindness Prevention", icon: "eyeglasses", destination: .technique("tools-snow-goggles")),
                    TriageOption(id: "cold-calm", label: "Calming Breath / Panic", icon: "wind", destination: .technique("psych-box-breathing")),
                    TriageOption(id: "cold-decide", label: "Can't Decide What to Do", icon: "questionmark.circle.fill", destination: .technique("psych-ooda-loop")),
                    TriageOption(id: "cold-alone", label: "Feeling Depressed / Alone", icon: "person.fill", destination: .technique("psych-loneliness"))
                ])
            )),

            // 📚 LEARN MORE
            TriageOption(id: "cold-learn", label: "Learn More", icon: "book.fill", destination: .nextQuestion(
                TriageNode(id: "cold-learn-q", question: "What would you like to read about?", options: [
                    TriageOption(id: "cold-art-insulation", label: "Insulation Science", icon: "thermometer.snowflake", destination: .articleList(["shelter-article-insulation", "shelter-article-insulation-values"])),
                    TriageOption(id: "cold-art-snow", label: "Snow Insulation", icon: "snowflake", destination: .article("shelter-article-snow-insulation")),
                    TriageOption(id: "cold-art-arctic", label: "Arctic Survival Guide", icon: "globe", destination: .article("env-article-arctic")),
                    TriageOption(id: "cold-art-water", label: "Winter Water Sources", icon: "drop.fill", destination: .articleList(["water-article-ice-snow", "water-article-winter"])),
                    TriageOption(id: "cold-art-bedding", label: "Bedding & Ground", icon: "bed.double.fill", destination: .articleList(["shelter-article-bedding", "shelter-article-ground"]))
                ])
            ))
        ])
    }
}
