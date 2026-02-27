import Foundation

extension ContentDatabase {
    // =========================================================================
    // MARK: - NEED FIRE — SSC Rebuilt
    // =========================================================================
    func buildFireTriage() -> TriageNode {
        TriageNode(id: "fire-root", question: "What do you need?", options: [

            // ── 1. START A FIRE ──────────────────────────────────────────
            TriageOption(id: "fire-start-group", label: "Start a Fire", icon: "flame.fill", destination: .nextQuestion(
                TriageNode(id: "fire-start-q", question: "What tool do you have?", options: [
                    TriageOption(id: "fire-lighter", label: "Lighter or Matches", icon: "flame", destination: .nextQuestion(
                        TriageNode(id: "fire-lighter-q", question: "What's your situation?", options: [
                            TriageOption(id: "fire-lighter-dry", label: "Dry Conditions", icon: "sun.max.fill", destination: .techniqueList(["fire-log-cabin", "fire-star-fire", "fire-lean-to", "fire-upside-down"])),
                            TriageOption(id: "fire-lighter-wet", label: "Everything Is Wet", icon: "cloud.rain.fill", destination: .technique("fire-wet-conditions")),
                            TriageOption(id: "fire-lighter-stealth", label: "Need Low Smoke", icon: "eye.slash.fill", destination: .technique("fire-dakota-hole")),
                            TriageOption(id: "fire-lighter-signal", label: "Signal Fire", icon: "antenna.radiowaves.left.and.right", destination: .technique("rescue-signal-fire"))
                        ])
                    )),
                    TriageOption(id: "fire-ferro", label: "Ferro Rod", icon: "sparkle", destination: .nextQuestion(
                        TriageNode(id: "fire-ferro-q", question: "Do you have tinder?", options: [
                            TriageOption(id: "fire-ferro-natural", label: "Natural Tinder (Bark)", icon: "leaf.fill", destination: .techniqueList(["fire-ferrorod", "fire-birch-bark"])),
                            TriageOption(id: "fire-ferro-manmade", label: "Man-Made (Lint/Jute)", icon: "doc.text.fill", destination: .techniqueList(["fire-ferrorod", "fire-jute-twine"])),
                            TriageOption(id: "fire-ferro-none", label: "No Tinder / Wet", icon: "xmark.circle.fill", destination: .techniqueList(["fire-feather-stick", "fire-fatwood-id"]))
                        ])
                    )),
                    TriageOption(id: "fire-flint", label: "Flint/Quartz & Steel", icon: "bolt.fill", destination: .nextQuestion(
                        TriageNode(id: "fire-flint-q", question: "Do you have charcloth?", options: [
                            TriageOption(id: "fire-flint-yes", label: "Yes — Have Char", icon: "checkmark.circle.fill", destination: .technique("fire-flint-steel")),
                            TriageOption(id: "fire-flint-no", label: "No — Make Some", icon: "xmark.circle.fill", destination: .techniqueList(["fire-charcloth", "fire-feather-stick"]))
                        ])
                    )),
                    TriageOption(id: "fire-batt-chem", label: "Battery or Chemicals", icon: "battery.100", destination: .nextQuestion(
                        TriageNode(id: "fire-bc-q", question: "Which one?", options: [
                            TriageOption(id: "fire-battery-opt", label: "Battery (Gum / Steel Wool)", icon: "battery.75percent", destination: .techniqueList(["fire-battery", "fire-battery-gum", "fire-steel-wool"])),
                            TriageOption(id: "fire-chemical-opt", label: "Chemical Mix", icon: "flask.fill", destination: .technique("fire-chemical"))
                        ])
                    )),
                    TriageOption(id: "fire-nothing", label: "Nothing / Primitive", icon: "xmark.circle.fill", destination: .nextQuestion(
                        TriageNode(id: "fire-nothing-q", question: "Is the sun visible?", options: [
                            TriageOption(id: "fire-sun-yes", label: "Yes — Sunny (Lens)", icon: "sun.max.fill", destination: .techniqueList(["fire-chocolate-can", "fire-ice-lens"])),
                            TriageOption(id: "fire-sun-no", label: "No Sun — Friction", icon: "cloud.fill", destination: .techniqueList(["fire-bowdrill", "fire-handdrill", "fire-firesaw", "fire-fire-plow"]))
                        ])
                    ))
                ])
            )),

            // ── 2. MAINTAIN & ADAPT ──────────────────────────────────────
            TriageOption(id: "fire-maintain-group", label: "Maintain / Adapt Fire", icon: "flame", destination: .nextQuestion(
                TriageNode(id: "fire-ma-q", question: "What do you need?", options: [
                    TriageOption(id: "fire-maintain", label: "Keep Fire Going", icon: "arrow.up.right", destination: .nextQuestion(
                        TriageNode(id: "fire-maintain-q", question: "What is the goal?", options: [
                            TriageOption(id: "f-m-fuel", label: "Add Fuel / Build", icon: "tree.fill", destination: .techniqueList(["fire-fuel-stages", "fire-log-cabin"])),
                            TriageOption(id: "f-m-night", label: "Burn All Night", icon: "moon.fill", destination: .techniqueList(["fire-upside-down", "fire-reflector-wall"])),
                            TriageOption(id: "f-m-out", label: "Extinguish Safely", icon: "drop.fill", destination: .technique("fire-extinguish"))
                        ])
                    )),
                    TriageOption(id: "fire-conditions", label: "Bad Conditions (Wet/Wind)", icon: "cloud.rain.fill", destination: .nextQuestion(
                        TriageNode(id: "fire-conditions-q", question: "What's the problem?", options: [
                            TriageOption(id: "fire-cond-rain", label: "Rain / Wet Wood", icon: "cloud.rain.fill", destination: .technique("fire-wet-conditions")),
                            TriageOption(id: "fire-cond-snow", label: "Snow / Ice on Ground", icon: "snowflake", destination: .techniqueList(["fire-in-snow", "fire-platform-base"])),
                            TriageOption(id: "fire-cond-wind", label: "High Wind", icon: "wind", destination: .techniqueList(["fire-in-wind", "fire-trench-fire", "fire-dakota-hole"]))
                        ])
                    )),
                    TriageOption(id: "fire-specialty", label: "Specialty Fires (Cooking/Stealth)", icon: "square.grid.3x3.fill", destination: .nextQuestion(
                        TriageNode(id: "fire-specialty-q", question: "What's the purpose?", options: [
                            TriageOption(id: "fire-spec-cook", label: "Cooking", icon: "frying.pan.fill", destination: .techniqueList(["fire-keyhole-fire", "fire-rocket-stove", "fire-swedish-torch"])),
                            TriageOption(id: "fire-spec-stealth", label: "Stealth / Concealed", icon: "eye.slash.fill", destination: .techniqueList(["fire-dakota-hole", "fire-concealed"])),
                            TriageOption(id: "fire-spec-torch", label: "Portable Torch", icon: "flashlight.on.fill", destination: .technique("fire-pine-torch"))
                        ])
                    ))
                ])
            )),

            // ── 3. TINDER & FUEL PREP ────────────────────────────────────
            TriageOption(id: "fire-tinder-prep", label: "Tinder & Fuel Prep", icon: "leaf.fill", destination: .nextQuestion(
                TriageNode(id: "fire-tinder-q", question: "What are you preparing?", options: [
                    TriageOption(id: "fire-prep-find", label: "Find Natural Tinder", icon: "tree.fill", destination: .techniqueList(["fire-fatwood-id", "fire-birch-bark", "fire-tinder-collection"])),
                    TriageOption(id: "fire-prep-make", label: "Make Tinder (Charcloth)", icon: "knife.fill", destination: .techniqueList(["fire-feather-stick", "fire-charcloth", "fire-char-rope"])),
                    TriageOption(id: "fire-prep-accel", label: "Accelerants (Vaseline/Sap)", icon: "drop.fill", destination: .techniqueList(["fire-hand-sanitizer", "fire-vaseline-cotton", "fire-resin-collection"]))
                ])
            )),

            // ── 4. LEARN MORE ────────────────────────────────────────────
            TriageOption(id: "fire-learn", label: "Learn More", icon: "book.fill", destination: .nextQuestion(
                TriageNode(id: "fire-learn-q", question: "What would you like to read about?", options: [
                    TriageOption(id: "fire-art-methods", label: "Starts: Methods/Primitive", icon: "flame", destination: .articleList(["fire-article-methods", "fire-article-primitive", "fire-article-chemical"])),
                    TriageOption(id: "fire-art-fuel", label: "Fuel: Selection/Wood ID", icon: "tree.fill", destination: .articleList(["fire-article-fuel", "fire-article-wood-id"])),
                    TriageOption(id: "fire-art-wet", label: "Weather: Wet Conditions", icon: "cloud.rain.fill", destination: .articleList(["fire-article-wet", "fire-article-wet-weather", "fire-article-biomes"])),
                    TriageOption(id: "fire-art-maint", label: "Maintenance & Cooking", icon: "frying.pan.fill", destination: .articleList(["fire-article-maintenance", "fire-article-cooking", "fire-article-signaling"])),
                    TriageOption(id: "fire-art-psych", label: "Psychology & Safety", icon: "brain.head.profile", destination: .articleList(["fire-article-psychology", "fire-article-safety"]))
                ])
            ))
        ])
    }
}
