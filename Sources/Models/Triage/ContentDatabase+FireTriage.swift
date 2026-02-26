import Foundation

extension ContentDatabase {
    // =========================================================================
    // MARK: - NEED FIRE — SSC Rebuilt
    // =========================================================================
    func buildFireTriage() -> TriageNode {
        TriageNode(id: "fire-root", question: "What do you have to start a fire?", options: [

            // ── 1. LIGHTER / MATCHES ────────────────────────────────────
            TriageOption(id: "fire-lighter", label: "I Have a Lighter or Matches", icon: "flame", destination: .nextQuestion(
                TriageNode(id: "fire-lighter-q", question: "What's your situation?", options: [
                    TriageOption(id: "fire-lighter-dry", label: "Dry Conditions", icon: "sun.max.fill", destination: .techniqueList(["fire-log-cabin", "fire-star-fire", "fire-lean-to", "fire-upside-down"])),
                    TriageOption(id: "fire-lighter-wet", label: "Everything Is Wet", icon: "cloud.rain.fill", destination: .technique("fire-wet-conditions")),
                    TriageOption(id: "fire-lighter-stealth", label: "I Need Low Smoke", icon: "eye.slash.fill", destination: .technique("fire-dakota-hole")),
                    TriageOption(id: "fire-lighter-signal", label: "I Need a Signal Fire", icon: "antenna.radiowaves.left.and.right", destination: .technique("rescue-signal-fire")),
                    TriageOption(id: "fire-lighter-kit", label: "I Have a Waterproof Kit", icon: "archivebox.fill", destination: .technique("fire-waterproof-kit")),
                    TriageOption(id: "fire-lighter-bugs", label: "Repel Insects", icon: "ant.fill", destination: .technique("fire-insect-repellent"))
                ])
            )),

            // ── 2. FERRO ROD ────────────────────────────────────────────
            TriageOption(id: "fire-ferro", label: "I Have a Ferro Rod", icon: "sparkle", destination: .nextQuestion(
                TriageNode(id: "fire-ferro-q", question: "Do you have tinder?", options: [
                    TriageOption(id: "fire-ferro-natural", label: "Natural Tinder (Bark / Grass)", icon: "leaf.fill", destination: .techniqueList(["fire-ferrorod", "fire-birch-bark"])),
                    TriageOption(id: "fire-ferro-manmade", label: "Man-Made Tinder (Lint / Jute)", icon: "doc.text.fill", destination: .techniqueList(["fire-ferrorod", "fire-jute-twine"])),
                    TriageOption(id: "fire-ferro-none", label: "No Tinder at All", icon: "xmark.circle.fill", destination: .techniqueList(["fire-feather-stick", "fire-charcloth", "fire-fatwood-id"]))
                ])
            )),

            // ── 3. FLINT / QUARTZ ───────────────────────────────────────
            TriageOption(id: "fire-flint", label: "I Have Flint or Quartz", icon: "bolt.fill", destination: .nextQuestion(
                TriageNode(id: "fire-flint-q", question: "Do you have charcloth or dry fungus?", options: [
                    TriageOption(id: "fire-flint-yes", label: "Yes — Have Char Material", icon: "checkmark.circle.fill", destination: .technique("fire-flint-steel")),
                    TriageOption(id: "fire-flint-no", label: "No — Need to Make Some", icon: "xmark.circle.fill", destination: .techniqueList(["fire-charcloth", "fire-feather-stick"]))
                ])
            )),

            // ── 4. BATTERY ──────────────────────────────────────────────
            TriageOption(id: "fire-battery-opt", label: "I Have a Battery", icon: "battery.75percent", destination: .techniqueList(["fire-battery", "fire-battery-gum", "fire-steel-wool"])),

            // ── 5. CHEMICALS ────────────────────────────────────────────
            TriageOption(id: "fire-chemical-opt", label: "I Have Chemicals", icon: "flask.fill", destination: .technique("fire-chemical")),

            // ── 6. NOTHING — PRIMITIVE ──────────────────────────────────
            TriageOption(id: "fire-nothing", label: "I Have Nothing", icon: "xmark.circle.fill", destination: .nextQuestion(
                TriageNode(id: "fire-nothing-q", question: "Is the sun visible?", options: [
                    TriageOption(id: "fire-sun-yes", label: "Yes — Sunny", icon: "sun.max.fill", destination: .techniqueList(["fire-chocolate-can", "fire-ice-lens"])),
                    TriageOption(id: "fire-sun-no", label: "No Sun — Friction Methods", icon: "cloud.fill", destination: .techniqueList(["fire-bow-drill", "fire-handdrill", "fire-firesaw", "fire-fire-plow"]))
                ])
            )),

            // ── 7. KEEP FIRE GOING ──────────────────────────────────────
            TriageOption(id: "fire-maintain", label: "Keep My Fire Going", icon: "flame", destination: .nextQuestion(
                TriageNode(id: "fire-maintain-q", question: "What do you need?", options: [
                    TriageOption(id: "fire-maintain-fuel", label: "Fuel & Structure", icon: "arrow.up.right", destination: .techniqueList(["fire-fuel-stages", "fire-reflector-wall", "fire-log-cabin"])),
                    TriageOption(id: "fire-maintain-carry", label: "Carry Fire to New Camp", icon: "figure.walk.motion", destination: .technique("fire-ember-carrier")),
                    TriageOption(id: "fire-maintain-night", label: "Fire Through the Night", icon: "moon.fill", destination: .techniqueList(["fire-upside-down", "fire-reflector-wall"])),
                    TriageOption(id: "fire-maintain-out", label: "Extinguish Safely", icon: "drop.fill", destination: .technique("fire-extinguish")),
                    TriageOption(id: "fire-maintain-signal", label: "Signal Fire Maintenance", icon: "antenna.radiowaves.left.and.right", destination: .technique("fire-signal-maintenance")),
                    TriageOption(id: "fire-maintain-torch", label: "Make a Torch", icon: "flashlight.on.fill", destination: .technique("fire-pine-torch"))
                ])
            )),

            // ── 8. FIRE IN BAD CONDITIONS ───────────────────────────────
            TriageOption(id: "fire-conditions", label: "Fire in Bad Conditions", icon: "cloud.rain.fill", destination: .nextQuestion(
                TriageNode(id: "fire-conditions-q", question: "What's the problem?", options: [
                    TriageOption(id: "fire-cond-rain", label: "Rain / Wet Wood", icon: "cloud.rain.fill", destination: .technique("fire-wet-conditions")),
                    TriageOption(id: "fire-cond-snow", label: "Snow / Ice on Ground", icon: "snowflake", destination: .techniqueList(["fire-in-snow", "fire-platform-base"])),
                    TriageOption(id: "fire-cond-wind", label: "High Wind", icon: "wind", destination: .techniqueList(["fire-in-wind", "fire-trench-fire", "fire-dakota-hole"])),
                    TriageOption(id: "fire-cond-bugs", label: "Repel Insects", icon: "ant.fill", destination: .technique("fire-insect-repellent"))
                ])
            )),

            // ── 9. SPECIALTY FIRES ──────────────────────────────────────
            TriageOption(id: "fire-specialty", label: "Specialty Fires", icon: "square.grid.3x3.fill", destination: .nextQuestion(
                TriageNode(id: "fire-specialty-q", question: "What's the purpose?", options: [
                    TriageOption(id: "fire-spec-cook", label: "Cooking Fire", icon: "frying.pan.fill", destination: .techniqueList(["fire-keyhole-fire", "fire-rocket-stove", "fire-swedish-torch"])),
                    TriageOption(id: "fire-spec-stealth", label: "Concealed / Stealth", icon: "eye.slash.fill", destination: .techniqueList(["fire-trench-fire", "fire-dakota-hole", "fire-concealed"])),
                    TriageOption(id: "fire-spec-torch", label: "Portable Torch", icon: "flashlight.on.fill", destination: .technique("fire-pine-torch")),
                    TriageOption(id: "fire-spec-safety", label: "Safety Perimeter", icon: "shield.fill", destination: .technique("fire-safety-perimeter"))
                ])
            )),

            // ── 10. TINDER & FUEL PREP ──────────────────────────────────
            TriageOption(id: "fire-tinder-prep", label: "Tinder & Fuel Prep", icon: "leaf.fill", destination: .nextQuestion(
                TriageNode(id: "fire-tinder-q", question: "What are you preparing?", options: [
                    TriageOption(id: "fire-prep-find", label: "Find Natural Tinder", icon: "tree.fill", destination: .techniqueList(["fire-fatwood-id", "fire-birch-bark", "fire-tinder-collection"])),
                    TriageOption(id: "fire-prep-make", label: "Make Tinder", icon: "knife.fill", destination: .techniqueList(["fire-feather-stick", "fire-charcloth", "fire-char-rope"])),
                    TriageOption(id: "fire-prep-accel", label: "Accelerants", icon: "drop.fill", destination: .techniqueList(["fire-hand-sanitizer", "fire-vaseline-cotton", "fire-resin-collection"]))
                ])
            )),

            // ── 11. LEARN MORE ──────────────────────────────────────────
            TriageOption(id: "fire-learn", label: "Learn More", icon: "book.fill", destination: .nextQuestion(
                TriageNode(id: "fire-learn-q", question: "What would you like to read about?", options: [
                    TriageOption(id: "fire-art-methods", label: "Fire-Starting Methods", icon: "flame", destination: .article("fire-article-methods")),
                    TriageOption(id: "fire-art-primitive", label: "Primitive Fire Techniques", icon: "leaf.fill", destination: .article("fire-article-primitive")),
                    TriageOption(id: "fire-art-fuel", label: "Fuel Selection & Preparation", icon: "tree.fill", destination: .article("fire-article-fuel")),
                    TriageOption(id: "fire-art-wet", label: "Fire in Wet Conditions", icon: "cloud.rain.fill", destination: .articleList(["fire-article-wet", "fire-article-wet-weather"])),
                    TriageOption(id: "fire-art-maint", label: "Fire Maintenance", icon: "flame", destination: .article("fire-article-maintenance")),
                    TriageOption(id: "fire-art-cooking", label: "Cooking with Fire", icon: "frying.pan.fill", destination: .article("fire-article-cooking")),
                    TriageOption(id: "fire-art-signal", label: "Signal Fires", icon: "smoke.fill", destination: .article("fire-article-signaling")),
                    TriageOption(id: "fire-art-biomes", label: "Fire by Biome", icon: "globe.americas.fill", destination: .article("fire-article-biomes")),
                    TriageOption(id: "fire-art-wood", label: "Wood Identification", icon: "tree.circle.fill", destination: .article("fire-article-wood-id")),
                    TriageOption(id: "fire-art-chem", label: "Chemical Fire Starters", icon: "flask.fill", destination: .article("fire-article-chemical")),
                    TriageOption(id: "fire-art-psych", label: "Psychology of Fire", icon: "brain.head.profile", destination: .article("fire-article-psychology")),
                    TriageOption(id: "fire-art-safety", label: "Fire Safety", icon: "exclamationmark.triangle.fill", destination: .article("fire-article-safety"))
                ])
            )),
        ])
    }
}
