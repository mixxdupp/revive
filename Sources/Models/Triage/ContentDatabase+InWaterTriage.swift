import Foundation

// Auto-generated: buildInWaterTriage extracted from ContentDatabase.swift
extension ContentDatabase {
    // =========================================================================
    // MARK: - IN WATER (4 levels deep)
    // =========================================================================
    func buildInWaterTriage() -> TriageNode {
        TriageNode(id: "water-em-root", question: "What is the emergency?", options: [

            // --- DROWNING / SWIMMING ---
            TriageOption(id: "wet-swim", label: "Struggling to Swim", icon: "figure.pool.swim", destination: .nextQuestion(
                TriageNode(id: "wet-swim-q", question: "Why?", options: [
                    TriageOption(id: "wet-exhaust", label: "Exhausted", icon: "battery.0", destination: .nextQuestion(
                        TriageNode(id: "wet-exhaust-q", question: "Can you float?", options: [
                            TriageOption(id: "wet-exhaust-sinking", label: "No — Going Under", icon: "exclamationmark.triangle.fill", destination: .technique("rescue-improvised-flotation")),
                        ])
                    )),
                    TriageOption(id: "wet-cramp", label: "Muscle Cramp", icon: "bolt.fill", destination: .nextQuestion(
                        TriageNode(id: "wet-cramp-q", question: "Which body part?", options: [
                        ])
                    )),
                    TriageOption(id: "wet-drown-rescue", label: "Rescuing Drowning Person", icon: "person.2.fill", destination: .nextQuestion(
                        TriageNode(id: "wet-drown-how", question: "How far away are they?", options: [
                            TriageOption(id: "wet-drown-near", label: "Within Arm's Reach", icon: "hand.raised.fill", destination: .technique("rescue-throw-bag")),
                            TriageOption(id: "wet-drown-throw", label: "Can Throw Rope / Object", icon: "arrow.right", destination: .techniqueList(["rescue-throw-bag", "rescue-throw-line"])), // Added orphan
                            TriageOption(id: "wet-drown-rescue-tech", label: "After Rescue / Recovery", icon: "cross.fill", destination: .techniqueList(["firstaid-drowning-rescue", "firstaid-drowning"])) // Added orphans
                        ])
                    ))
                ])
            )),

            // --- COLD WATER ---
            TriageOption(id: "wet-cold", label: "Cold Water Immersion", icon: "snowflake", destination: .nextQuestion(
                TriageNode(id: "wet-cold-q", question: "How long in water?", options: [
                    TriageOption(id: "wet-shock", label: "Just Fell In (Cold Shock)", icon: "exclamationmark.triangle.fill", destination: .nextQuestion(
                        TriageNode(id: "wet-shock-q", question: "Can you grab something?", options: [
                            TriageOption(id: "wet-shock-grab", label: "Yes — Ledge / Boat / Dock", icon: "hand.raised.fill", destination: .technique("rescue-cold-water-self")),
                            TriageOption(id: "wet-shock-nothing", label: "No — Open Water", icon: "xmark.circle.fill", destination: .nextQuestion(
                                TriageNode(id: "wet-shock-float-q", question: "Focus: Control breathing first!", options: [
                                ])
                            ))
                        ])
                    )),
                    TriageOption(id: "wet-hypo", label: "Been In a While", icon: "thermometer.snowflake", destination: .nextQuestion(
                        TriageNode(id: "wet-hypo-q", question: "Symptoms?", options: [
                        ])
                    )),
                    TriageOption(id: "wet-ice", label: "Fell Through Ice", icon: "snowflake", destination: .nextQuestion(
                        TriageNode(id: "wet-ice-q", question: "Can you reach solid ice?", options: [
                            TriageOption(id: "wet-ice-reach", label: "Yes — Can Touch Edge", icon: "hand.raised.fill", destination: .technique("env-ice-fall-through")),
                        ])
                    ))
                ])
            )),

            // --- CURRENTS ---
            TriageOption(id: "wet-current", label: "Caught in Current", icon: "water.waves", destination: .nextQuestion(
                TriageNode(id: "wet-curr-q", question: "Where?", options: [
                    TriageOption(id: "wet-rip", label: "Ocean Rip Current", icon: "water.waves", destination: .nextQuestion(
                        TriageNode(id: "wet-rip-q", question: "How strong?", options: [
                            TriageOption(id: "wet-rip-swim", label: "Can Still Swim Sideways", icon: "arrow.left.and.right", destination: .technique("env-rip-current")),
                        ])
                    )),
                    TriageOption(id: "wet-river", label: "River Current", icon: "arrow.right", destination: .nextQuestion(
                        TriageNode(id: "wet-river-q", question: "What's ahead?", options: [
                            TriageOption(id: "wet-river-rapids", label: "Rapids / Rocks Ahead", icon: "exclamationmark.triangle.fill", destination: .technique("rescue-river-self")),
                            TriageOption(id: "wet-river-calm", label: "Current but No Rapids", icon: "water.waves", destination: .techniqueList(["rescue-river-self", "nav-river-navigation"])), // Added orphan
                        ])
                    ))
                ])
            )),

            // --- BOAT ---
            TriageOption(id: "wet-boat", label: "Boat Capsized / Sinking", icon: "sailboat.fill", destination: .nextQuestion(
                TriageNode(id: "wet-boat-q", question: "What's the situation?", options: [
                    TriageOption(id: "wet-boat-sinking", label: "Sinking — Abandoning", icon: "exclamationmark.triangle.fill", destination: .nextQuestion(
                        TriageNode(id: "wet-boat-sink-q", question: "Do you have a life jacket?", options: [
                        ])
                    )),
                    TriageOption(id: "wet-boat-signal", label: "Need to Signal for Help", icon: "antenna.radiowaves.left.and.right", destination: .techniqueList(["rescue-signal-mirror", "rescue-whistle", "rescue-phone-emergency"]))
                ])
            )),

            // --- OCEAN SURVIVAL (Adrift) ---

            // --- ADVANCED SIGNALING FROM WATER ---
            TriageOption(id: "wet-signal-adv", label: "Advanced Signaling", icon: "antenna.radiowaves.left.and.right", destination: .nextQuestion(
                TriageNode(id: "wet-sig-q", question: "What signaling method?", options: [
                    TriageOption(id: "wet-sig-night", label: "Night Signaling", icon: "moon.fill", destination: .technique("rescue-night-signaling")),
                    TriageOption(id: "wet-sig-sat", label: "Satellite Messenger / PLB", icon: "antenna.radiowaves.left.and.right", destination: .technique("rescue-satellite-messenger")),
                    TriageOption(id: "wet-sig-vhf", label: "VHF Radio", icon: "radio.fill", destination: .technique("rescue-vhf-radio")),
                    TriageOption(id: "wet-sig-drone", label: "Drone Awareness", icon: "airplane", destination: .technique("rescue-drone-awareness")),
                    TriageOption(id: "wet-sig-heli", label: "Helicopter Approaching", icon: "helicopter", destination: .techniqueList(["rescue-helicopter", "rescue-helicopter-approach"])),
                    TriageOption(id: "wet-sig-kite", label: "Signal Kite", icon: "wind", destination: .technique("rescue-signal-kite")),
                    TriageOption(id: "wet-sig-panel", label: "Signal Panel", icon: "square.fill", destination: .technique("rescue-signal-panel")),
                    TriageOption(id: "wet-sig-smoke-opt", label: "Smoke Timing", icon: "smoke.fill", destination: .technique("rescue-smoke-timing")),
                    TriageOption(id: "wet-sig-gps", label: "GPS Reading", icon: "location.fill", destination: .technique("rescue-gps-reading")),
                    TriageOption(id: "wet-sig-cliff", label: "Cliff / Elevated Signals", icon: "mountain.2.fill", destination: .technique("rescue-cliff-signals"))
                ])
            )),

            // 📚 LEARN MORE
            TriageOption(id: "wet-learn", label: "Learn More", icon: "book.fill", destination: .nextQuestion(
                TriageNode(id: "wet-learn-q", question: "What would you like to read about?", options: [
                    TriageOption(id: "wet-art-signaling", label: "Signaling Science", icon: "antenna.radiowaves.left.and.right", destination: .articleList(["rescue-article-signaling", "rescue-article-signaling-science"])),
                    TriageOption(id: "wet-art-water-rescue", label: "Water Rescue Principles", icon: "figure.water.fitness", destination: .articleList(["rescue-article-water-rescue", "rescue-article-water-principles"])),
                    TriageOption(id: "wet-art-search", label: "Search & Rescue Ops", icon: "binoculars.fill", destination: .article("rescue-article-search")),
                    TriageOption(id: "wet-art-group", label: "Group Rescue", icon: "person.3.fill", destination: .article("rescue-article-group-rescue")),
                    TriageOption(id: "wet-art-night", label: "Night Rescue", icon: "moon.fill", destination: .article("rescue-article-night-rescue")),
                    TriageOption(id: "wet-art-phone", label: "Emergency Phone Use", icon: "phone.fill", destination: .article("rescue-article-phone")),
                    TriageOption(id: "wet-art-plb", label: "PLB & Emergency Beacons", icon: "antenna.radiowaves.left.and.right", destination: .article("rescue-article-plb")),
                    TriageOption(id: "wet-art-selfrescue", label: "Self-Rescue Navigation", icon: "location.fill", destination: .article("rescue-article-self-rescue-nav")),
                    TriageOption(id: "wet-art-timing", label: "Rescue Timing", icon: "clock.fill", destination: .article("rescue-article-timing")),
                    TriageOption(id: "wet-art-radio", label: "Radio Communication", icon: "radio.fill", destination: .article("rescue-article-radio")),
                    TriageOption(id: "wet-art-ocean", label: "Ocean Survival Guide", icon: "water.waves", destination: .article("water-article-oceansurv"))
                ])
            )),

            TriageOption(id: "g1416", label: "Maritime", icon: "water.waves", destination: .nextQuestion(
                TriageNode(id: "g1416-q", question: "What specifically?", options: [
                TriageOption(id: "g1417", label: "Life", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g1417-q", question: "Select:", options: [
                        TriageOption(id: "g1418", label: "Patching punctures and air leaks in inflatable rafts", icon: "wrench.fill", destination: .technique("env-sea-raft-repair")),
                        TriageOption(id: "g1419", label: "Surviving days to weeks adrift in the open ocean", icon: "water.waves", destination: .technique("env-sea-survival-raft"))
                    ])
                )),
                TriageOption(id: "g1420", label: "Shark", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g1420-q", question: "Select:", options: [
                        TriageOption(id: "g1421", label: "USCG Standard protocols for mitigating shark encounter ", icon: "water.waves", destination: .technique("env-encyclopedia-ocean-shark")),
                        TriageOption(id: "g1422", label: "Reducing shark encounter risk while adrift or swimming", icon: "cross.case.fill", destination: .technique("env-sea-shark-deterrent"))
                    ])
                )),
                TriageOption(id: "g1423", label: "Raft", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g1423-q", question: "Select:", options: [
                        TriageOption(id: "g1424", label: "Scraping and eating barnacles from raft bottoms", icon: "ant.fill", destination: .technique("env-sea-barnacles")),
                        TriageOption(id: "g1425", label: "Rationing freshwater to maximize survival time at sea", icon: "water.waves", destination: .technique("env-sea-water-discipline"))
                    ])
                )),
                TriageOption(id: "g1426", label: "Vectors", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g1426-q", question: "Select:", options: [
                        TriageOption(id: "g1427", label: "USCG Standard protocols for mitigating dehydration adri", icon: "sun.max.fill", destination: .technique("env-encyclopedia-ocean-dehydration")),
                        TriageOption(id: "g1428", label: "USCG Standard protocols for mitigating hypothermia adri", icon: "snowflake", destination: .technique("env-encyclopedia-ocean-hypothermia")),
                        TriageOption(id: "g1429", label: "USCG Standard protocols for mitigating jellyfish/man-o-", icon: "fish.fill", destination: .technique("env-encyclopedia-ocean-jellyfish-man-o-war")),
                        TriageOption(id: "g1430", label: "USCG Standard protocols for mitigating sun exposure (uv", icon: "flame.fill", destination: .technique("env-encyclopedia-ocean-sun"))
                    ])
                )),
                TriageOption(id: "g1431", label: "Point", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g1431-q", question: "Select:", options: [
                        TriageOption(id: "g1432", label: "Using pressure point P6 to reduce nausea without medica", icon: "water.waves", destination: .technique("env-sea-seasickness-pressure"))
                    ])
                ))
                ])
            )),
        ])
    }

}
