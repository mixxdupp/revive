import Foundation

extension ContentDatabase {
    // =========================================================================
    // MARK: - IN WATER — SSC Rebuilt (≤3 taps)
    // =========================================================================
    func buildInWaterTriage() -> TriageNode {
        TriageNode(id: "water-em-root", question: "What do you need?", options: [

            // ── DROWNING / SWIMMING ──
            TriageOption(id: "wet-swim", label: "Struggling to Swim", icon: "figure.pool.swim", destination: .nextQuestion(
                TriageNode(id: "wet-swim-q", question: "What's happening?", options: [
                    TriageOption(id: "wet-exhaust", label: "Exhausted / Going Under", icon: "battery.0", destination: .techniqueList(["rescue-improvised-flotation", "rescue-navy-drownproofing"])),
                    TriageOption(id: "wet-cramp-leg", label: "Leg / Calf Cramp", icon: "bolt.fill", destination: .technique("rescue-navy-drownproofing")),
                    TriageOption(id: "wet-cramp-multi", label: "Multiple Cramps", icon: "figure.pool.swim", destination: .technique("rescue-help-huddle-position")),
                    TriageOption(id: "wet-rescue-near", label: "Rescuing Someone — Nearby", icon: "hand.raised.fill", destination: .technique("rescue-throw-bag")),
                    TriageOption(id: "wet-rescue-far", label: "Rescuing Someone — Far", icon: "arrow.right", destination: .techniqueList(["rescue-throw-bag", "rescue-throw-line"])),
                    TriageOption(id: "wet-post-rescue", label: "After Rescue / Recovery", icon: "cross.fill", destination: .techniqueList(["firstaid-drowning-rescue", "firstaid-drowning"]))
                ])
            )),

            // ── COLD WATER ──
            TriageOption(id: "wet-cold", label: "Cold Water Immersion", icon: "snowflake", destination: .nextQuestion(
                TriageNode(id: "wet-cold-q", question: "How long in water?", options: [
                    TriageOption(id: "wet-shock", label: "Just Fell In (Cold Shock)", icon: "exclamationmark.triangle.fill", destination: .techniqueList(["rescue-cold-water-self", "rescue-help-huddle-position"])),
                    TriageOption(id: "wet-hypo-shiver", label: "Been In — Shivering / Numb", icon: "thermometer.snowflake", destination: .techniqueList(["rescue-cold-water-self", "firstaid-hypothermia"])),
                    TriageOption(id: "wet-hypo-severe", label: "Confused / Can't Move", icon: "brain.head.profile", destination: .techniqueList(["firstaid-hypothermia", "rescue-help-huddle-position"])),
                    TriageOption(id: "wet-ice", label: "Fell Through Ice", icon: "snowflake", destination: .technique("env-ice-fall-through")),
                    TriageOption(id: "wet-improv-float", label: "Need Flotation — Nothing", icon: "drop.fill", destination: .techniqueList(["rescue-pants-flotation", "rescue-flotation-improvised"]))
                ])
            )),

            // ── CAUGHT IN CURRENT ──
            TriageOption(id: "wet-current", label: "Caught in Current", icon: "water.waves", destination: .nextQuestion(
                TriageNode(id: "wet-curr-q", question: "Where?", options: [
                    TriageOption(id: "wet-rip", label: "Ocean Rip Current", icon: "water.waves", destination: .technique("env-rip-current")),
                    TriageOption(id: "wet-river-rapids", label: "River — Rapids / Rocks", icon: "exclamationmark.triangle.fill", destination: .technique("rescue-river-self")),
                    TriageOption(id: "wet-river-calm", label: "River — No Rapids", icon: "arrow.right", destination: .techniqueList(["rescue-river-self", "nav-river-reading"]))
                ])
            )),

            // ── BOAT CAPSIZED / SINKING ──
            TriageOption(id: "wet-boat", label: "Boat Capsized / Sinking", icon: "sailboat.fill", destination: .nextQuestion(
                TriageNode(id: "wet-boat-q", question: "What's the situation?", options: [
                    TriageOption(id: "wet-boat-jacket", label: "Have Life Jacket — In Water", icon: "checkmark.circle", destination: .technique("rescue-help-huddle-position")),
                    TriageOption(id: "wet-boat-nojacket", label: "No Life Jacket — Need to Float", icon: "xmark.circle", destination: .techniqueList(["rescue-pants-flotation", "rescue-flotation-improvised", "rescue-navy-drownproofing"])),
                    TriageOption(id: "wet-boat-signal", label: "Need to Signal for Help", icon: "antenna.radiowaves.left.and.right", destination: .techniqueList(["rescue-signal-mirror", "rescue-whistle", "rescue-phone-emergency"]))
                ])
            )),

            // ── SIGNALING ──
            TriageOption(id: "wet-signal", label: "Signal for Rescue", icon: "antenna.radiowaves.left.and.right", destination: .nextQuestion(
                TriageNode(id: "wet-sig-q", question: "What method?", options: [
                    TriageOption(id: "wet-sig-mirror", label: "Signal Mirror", icon: "sun.max.fill", destination: .technique("rescue-signal-mirror")),
                    TriageOption(id: "wet-sig-night", label: "Night Signaling", icon: "moon.fill", destination: .technique("rescue-night-signaling")),
                    TriageOption(id: "wet-sig-sat", label: "PLB / Satellite", icon: "antenna.radiowaves.left.and.right", destination: .technique("rescue-satellite-messenger")),
                    TriageOption(id: "wet-sig-vhf", label: "VHF Radio", icon: "radio.fill", destination: .technique("rescue-vhf-radio")),
                    TriageOption(id: "wet-sig-heli", label: "Helicopter Approaching", icon: "helicopter", destination: .techniqueList(["rescue-helicopter", "rescue-helicopter-approach"])),
                    TriageOption(id: "wet-sig-smoke", label: "Smoke Signal", icon: "smoke.fill", destination: .technique("rescue-smoke-timing"))
                ])
            )),

            // 📚 LEARN MORE
            TriageOption(id: "wet-learn", label: "Learn More", icon: "book.fill", destination: .nextQuestion(
                TriageNode(id: "wet-learn-q", question: "What topic?", options: [
                    TriageOption(id: "wet-learn-rescue", label: "Water Rescue", icon: "figure.water.fitness", destination: .nextQuestion(
                        TriageNode(id: "wet-learn-res-q", question: "Select article:", options: [
                            TriageOption(id: "wet-art-water", label: "Water Rescue Principles", icon: "figure.water.fitness", destination: .articleList(["rescue-article-water-rescue", "rescue-article-water-principles"])),
                            TriageOption(id: "wet-art-search", label: "Search & Rescue Ops", icon: "binoculars.fill", destination: .article("rescue-article-search")),
                            TriageOption(id: "wet-art-group", label: "Group Rescue", icon: "person.3.fill", destination: .article("rescue-article-group-rescue")),
                            TriageOption(id: "wet-art-selfrescue", label: "Self-Rescue Navigation", icon: "location.fill", destination: .article("rescue-article-self-rescue-nav")),
                            TriageOption(id: "wet-art-ocean", label: "Ocean Survival Guide", icon: "water.waves", destination: .article("water-article-oceansurv"))
                        ])
                    )),
                    TriageOption(id: "wet-learn-signal", label: "Signaling & Comms", icon: "antenna.radiowaves.left.and.right", destination: .nextQuestion(
                        TriageNode(id: "wet-learn-sig-q", question: "Select article:", options: [
                            TriageOption(id: "wet-art-signaling", label: "Signaling Science", icon: "antenna.radiowaves.left.and.right", destination: .articleList(["rescue-article-signaling", "rescue-article-signaling-science"])),
                            TriageOption(id: "wet-art-night", label: "Night Rescue", icon: "moon.fill", destination: .article("rescue-article-night-rescue")),
                            TriageOption(id: "wet-art-phone", label: "Emergency Phone Use", icon: "phone.fill", destination: .article("rescue-article-phone")),
                            TriageOption(id: "wet-art-plb", label: "PLB & Beacons", icon: "antenna.radiowaves.left.and.right", destination: .article("rescue-article-plb"))
                        ])
                    ))
                ])
            ))
        ])
    }

}
