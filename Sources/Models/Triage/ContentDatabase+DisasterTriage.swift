import Foundation

// Rebuilt: Natural Disasters decision engine — panic-optimized, domain-pure, zero dead ends
// All technique IDs step-validated against environments.json, advanced_environments.json,
// expanded_environments.json, missing_environments.json
extension ContentDatabase {
    // =========================================================================
    // MARK: - NATURAL DISASTER TRIAGE (v2 — step-validated, env-* only)
    // =========================================================================
    func buildDisasterTriage() -> TriageNode {
        TriageNode(id: "disaster-root", question: "What disaster are you facing?", options: [

            TriageOption(id: "dis-cat-weather", label: "Weather / Storms", icon: "cloud.bolt.rain.fill", destination: .nextQuestion(
                TriageNode(id: "dis-weather-q", question: "What type of storm?", options: [
                    TriageOption(id: "dis-tornado", label: "Tornado", icon: "tornado", destination: .nextQuestion(
                        TriageNode(id: "dis-tor-q", question: "Where are you?", options: [
                            TriageOption(id: "dis-tor-building", label: "In a Building", icon: "building.2.fill", destination: .technique("env-tornado-shelter")),
                            TriageOption(id: "dis-tor-mobile", label: "Mobile Home", icon: "house.fill", destination: .technique("env-tornado-mobile")),
                            TriageOption(id: "dis-tor-veh-evade", label: "Vehicle — Drive Away", icon: "arrow.turn.up.right", destination: .technique("env-tornado-drive")),
                            TriageOption(id: "dis-tor-veh-close", label: "Vehicle — Too Close (Ditch)", icon: "exclamationmark.triangle.fill", destination: .technique("env-tornado-ditch")),
                            TriageOption(id: "dis-tor-field", label: "Open Field / Outdoors", icon: "figure.walk", destination: .techniqueList(["env-tornado-field", "env-tornado-shelter-field", "env-tornado-field"]))
                        ])
                    )),
                    TriageOption(id: "dis-hurricane", label: "Hurricane / Cyclone", icon: "hurricane", destination: .nextQuestion(
                        TriageNode(id: "dis-hurr-q", question: "What stage?", options: [
                            TriageOption(id: "dis-hurr-prep", label: "Approaching — Prepare Now", icon: "clock.fill", destination: .technique("env-hurricane-preparation")),
                            TriageOption(id: "dis-hurr-during", label: "During the Storm", icon: "wind", destination: .techniqueList(["env-hurricane", "env-hurricane-shelter-protocol"])),
                            TriageOption(id: "dis-hurr-coastal", label: "Coastal / Storm Surge", icon: "water.waves", destination: .technique("env-coastal-storm"))
                        ])
                    )),
                    TriageOption(id: "dis-cold", label: "Blizzard / Extreme Cold", icon: "snowflake", destination: .nextQuestion(
                        TriageNode(id: "dis-cold-q", question: "What's your situation?", options: [
                            TriageOption(id: "dis-cold-exposed", label: "Stranded / Caught Outdoors", icon: "figure.walk", destination: .technique("env-blizzard")),
                            TriageOption(id: "dis-cold-home", label: "At Home — No Power", icon: "house.fill", destination: .technique("env-ice-storm-outage")),
                            TriageOption(id: "dis-cold-whiteout", label: "Whiteout — Can't See", icon: "eye.slash.fill", destination: .technique("env-whiteout-navigation")),
                            TriageOption(id: "dis-cold-ice", label: "Fell Through Ice", icon: "bolt.fill", destination: .technique("env-ice-fall-through")),
                            TriageOption(id: "dis-cold-water", label: "In Cold Water", icon: "snowflake", destination: .techniqueList(["env-cold-water-immersion", "env-cold-water-swimming-technique"])),
                            TriageOption(id: "dis-cold-cross", label: "Need to Cross Ice", icon: "arrow.left.and.right", destination: .technique("env-ice-travel-safety"))
                        ])
                    )),
                    TriageOption(id: "dis-lightning", label: "Lightning Storm", icon: "cloud.bolt.fill", destination: .nextQuestion(
                        TriageNode(id: "dis-light-q", question: "Where are you?", options: [
                            TriageOption(id: "dis-light-open", label: "Open / Exposed Area", icon: "figure.walk", destination: .technique("env-lightning-crouch")),
                            TriageOption(id: "dis-light-mtn", label: "Mountain / Ridge", icon: "mountain.2.fill", destination: .technique("env-mountain-lightning")),
                            TriageOption(id: "dis-light-trees", label: "Forest / Near Trees", icon: "tree.fill", destination: .technique("env-lightning-safety")),
                            TriageOption(id: "dis-light-dist", label: "Calculate Storm Distance", icon: "stopwatch.fill", destination: .technique("env-lightning-dist")),
                            TriageOption(id: "dis-light-rules", label: "30/30 Rule & Safety", icon: "list.bullet.clipboard.fill", destination: .techniqueList(["env-lightning-safety", "env-thunderstorm-safety"]))
                        ])
                    )),
                    TriageOption(id: "dis-weather", label: "Severe Weather (Dust/Hail/Fog)", icon: "cloud.bolt.rain.fill", destination: .nextQuestion(
                        TriageNode(id: "dis-wx-q", question: "What type?", options: [
                            TriageOption(id: "dis-wx-sand", label: "Sandstorm / Dust", icon: "wind", destination: .techniqueList(["env-sandstorm", "env-sandstorm-survival", "env-dust-storm-response", "env-dust-storm-health"])),
                            TriageOption(id: "dis-wx-hail", label: "Hailstorm — Take Cover", icon: "cloud.hail.fill", destination: .technique("env-hailstorm-shelter")),
                            TriageOption(id: "dis-wx-fog", label: "Dense Fog — Can't Navigate", icon: "cloud.fog.fill", destination: .technique("env-fog-navigation"))
                        ])
                    )),
                    TriageOption(id: "dis-avalanche", label: "Avalanche", icon: "mountain.2.fill", destination: .nextQuestion(
                        TriageNode(id: "dis-aval-q", question: "What's happening?", options: [
                            TriageOption(id: "dis-aval-now", label: "Caught in Avalanche NOW", icon: "exclamationmark.triangle.fill", destination: .techniqueList(["env-avalanche-swim", "env-avalanche"])),
                            TriageOption(id: "dis-aval-buried", label: "Buried Under Snow", icon: "snowflake", destination: .techniqueList(["env-avalanche-burial-survival", "env-avalanche"]))
                        ])
                    ))
                ])
            )),

            TriageOption(id: "dis-cat-earth", label: "Earthquake & Ground", icon: "waveform.path.ecg", destination: .nextQuestion(
                TriageNode(id: "dis-earth-q", question: "What disaster?", options: [
                    TriageOption(id: "dis-earthquake", label: "Earthquake", icon: "waveform.path.ecg", destination: .nextQuestion(
                        TriageNode(id: "dis-eq-q", question: "What's happening?", options: [
                            TriageOption(id: "dis-eq-during", label: "Shaking Right Now", icon: "exclamationmark.triangle.fill", destination: .technique("env-earthquake-during")),
                            TriageOption(id: "dis-eq-indoor", label: "I'm Indoors", icon: "building.2.fill", destination: .technique("env-earthquake-indoor")),
                            TriageOption(id: "dis-eq-outdoor", label: "I'm Outdoors", icon: "tree.fill", destination: .technique("env-earthquake-outdoor")),
                            TriageOption(id: "dis-eq-after", label: "Earthquake Over — Now What?", icon: "checkmark.circle", destination: .technique("env-earthquake"))
                        ])
                    )),
                    TriageOption(id: "dis-landslide", label: "Landslide / Mudslide", icon: "triangle.fill", destination: .nextQuestion(
                        TriageNode(id: "dis-land-q", question: "What's your situation?", options: [
                            TriageOption(id: "dis-land-indoor", label: "Inside a Building", icon: "building.2.fill", destination: .technique("env-landslide-indoor")),
                            TriageOption(id: "dis-land-outdoor", label: "I'm Outdoors", icon: "figure.walk", destination: .technique("env-landslide-outdoor")),
                            TriageOption(id: "dis-land-vehicle", label: "In a Vehicle", icon: "car.fill", destination: .technique("env-landslide-vehicle")),
                            TriageOption(id: "dis-land-trapped", label: "Trapped Under Debris", icon: "rectangle.compress.vertical", destination: .techniqueList(["env-landslide-trapped", "env-landslide-entrapment-survival"])),
                            TriageOption(id: "dis-land-moving", label: "Moving Debris / Mud", icon: "figure.run", destination: .techniqueList(["env-landslide-debris-flow-escape", "env-mudslide-survival"]))
                        ])
                    )),
                    TriageOption(id: "dis-volcano", label: "Volcanic Eruption", icon: "smoke.fill", destination: .nextQuestion(
                        TriageNode(id: "dis-volc-q", question: "What is the hazard?", options: [
                            TriageOption(id: "dis-volc-ash", label: "Ashfall — Hard to Breathe", icon: "lungs.fill", destination: .techniqueList(["env-volcanic-ashfall", "env-volcanic-ash"])),
                            TriageOption(id: "dis-volc-lava", label: "Lava / Pyroclastic Flow", icon: "flame", destination: .technique("env-volcanic-eruption")),
                            TriageOption(id: "dis-volc-response", label: "Eruption — What To Do", icon: "figure.run", destination: .technique("env-volcano-eruption-response")),
                            TriageOption(id: "dis-volc-shelter", label: "Sheltering from Ashfall", icon: "house.fill", destination: .technique("env-volcanic-ash-survival"))
                        ])
                    )),
                    TriageOption(id: "dis-ground", label: "Quicksand / Sinkholes", icon: "arrow.down.circle.fill", destination: .nextQuestion(
                        TriageNode(id: "dis-gnd-q", question: "What happened?", options: [
                            TriageOption(id: "dis-gnd-quick", label: "Stuck in Quicksand / Mud", icon: "figure.walk", destination: .techniqueList(["env-quicksand", "env-quicksand"])),
                            TriageOption(id: "dis-gnd-sink", label: "Sinkhole — Ground Collapsed", icon: "arrow.down", destination: .techniqueList(["env-sinkhole-response", "env-sinkhole-escape"])),
                            TriageOption(id: "dis-gnd-rock", label: "Rocks Falling Above Me", icon: "mountain.2.fill", destination: .technique("env-rockfall-evasion")),
                            TriageOption(id: "dis-gnd-mine", label: "Near Abandoned Mine", icon: "exclamationmark.triangle.fill", destination: .technique("env-mine-shaft-safety"))
                        ])
                    ))
                ])
            )),

            TriageOption(id: "dis-cat-water", label: "Floods & Ocean", icon: "water.waves", destination: .nextQuestion(
                TriageNode(id: "dis-water-q", question: "What happening?", options: [
                    TriageOption(id: "dis-flood", label: "Flood / Flash Flood", icon: "water.waves", destination: .nextQuestion(
                        TriageNode(id: "dis-flood-q", question: "What's your situation?", options: [
                            TriageOption(id: "dis-flood-flash", label: "Flash Flood — Act NOW", icon: "exclamationmark.triangle.fill", destination: .techniqueList(["env-flash-flood-survival", "env-flash-flood-adv"])),
                            TriageOption(id: "dis-flood-rising", label: "Water Rising Indoors", icon: "arrow.up", destination: .techniqueList(["env-flood-rooftop-escape", "env-cave-flood-response"])),
                            TriageOption(id: "dis-flood-swept", label: "Swept into Water", icon: "figure.wave", destination: .techniqueList(["env-flood-swiftwater-swim", "env-swiftwater-swimming"])),
                            TriageOption(id: "dis-flood-vehicle", label: "Vehicle in Floodwater", icon: "car.fill", destination: .techniqueList(["env-flood-vehicle-submergence", "env-flash-flood-vehicle"])),
                            TriageOption(id: "dis-flood-after", label: "After the Flood", icon: "checkmark.circle", destination: .techniqueList(["env-flood-water-sanitation", "env-flood-waterborne-disease", "env-post-flood", "env-flood-structural-diagnostics", "env-flood-chem-triage"]))
                        ])
                    )),
                    TriageOption(id: "dis-tsunami", label: "Tsunami", icon: "water.waves.and.arrow.up", destination: .nextQuestion(
                        TriageNode(id: "dis-tsu-q", question: "What's happening?", options: [
                            TriageOption(id: "dis-tsu-warning", label: "Warning Signs / Siren", icon: "speaker.wave.3.fill", destination: .technique("env-tsunami-warning-signs")),
                            TriageOption(id: "dis-tsu-quake", label: "Earthquake Near Coast", icon: "waveform.path.ecg", destination: .technique("env-tsunami-response")),
                            TriageOption(id: "dis-tsu-wave", label: "Wave Incoming / Hitting", icon: "water.waves", destination: .techniqueList(["env-tsunami-vertical", "env-tsunami"])),
                            TriageOption(id: "dis-tsu-general", label: "Tsunami Survival Basics", icon: "info.circle.fill", destination: .technique("env-tsunami-survival"))
                        ])
                    )),
                    TriageOption(id: "dis-ocean", label: "Ocean / Coastal Emergency", icon: "sailboat.fill", destination: .nextQuestion(
                        TriageNode(id: "dis-sea-q", question: "What's happening?", options: [
                            TriageOption(id: "dis-sea-adrift", label: "Adrift at Sea", icon: "sailboat.fill", destination: .techniqueList(["env-ocean-survival", "env-ocean-adrift", "env-open-ocean-survival"])),
                            TriageOption(id: "dis-sea-raft", label: "On a Life Raft", icon: "shield.fill", destination: .techniqueList(["env-sea-survival-raft", "env-sea-water-discipline", "env-sea-raft-repair"])),
                            TriageOption(id: "dis-sea-rip", label: "Caught in Rip Current", icon: "arrow.right", destination: .techniqueList(["env-rip-current-escape", "env-rip-current"])),
                            TriageOption(id: "dis-sea-marine", label: "Marine Hazard (Shark, Jellyfish)", icon: "fish.fill", destination: .techniqueList(["env-sea-shark-deterrent", "env-jellyfish-swarm-navigation", "env-jellyfish", "env-sea-seasickness-pressure"])),
                            TriageOption(id: "dis-sea-tidal", label: "Tidal / Coastal Hazard", icon: "water.waves", destination: .techniqueList(["env-coastal-tidal", "env-coastal-tidal-adv"]))
                        ])
                    ))
                ])
            )),

            TriageOption(id: "dis-cat-fire", label: "Fire & Extreme Heat", icon: "flame", destination: .nextQuestion(
                TriageNode(id: "dis-fireheat-q", question: "What disaster?", options: [
                    TriageOption(id: "dis-wildfire", label: "Wildfire", icon: "flame", destination: .nextQuestion(
                        TriageNode(id: "dis-fire-q", question: "How close is the fire?", options: [
                            TriageOption(id: "dis-fire-evac", label: "Evacuating NOW", icon: "car.fill", destination: .technique("env-wildfire-evac")),
                            TriageOption(id: "dis-fire-close", label: "Fire Approaching — Escape", icon: "figure.run", destination: .technique("env-wildfire-escape")),
                            TriageOption(id: "dis-fire-trapped", label: "Trapped / No Escape Route", icon: "exclamationmark.triangle.fill", destination: .techniqueList(["env-wildfire", "env-wildfire-survival"])),
                            TriageOption(id: "dis-fire-vehicle", label: "Trapped in Vehicle", icon: "car.fill", destination: .technique("env-wildfire-vehicle")),
                            TriageOption(id: "dis-fire-smoke", label: "Choking on Smoke", icon: "smoke.fill", destination: .technique("env-wildfire-smoke")),
                            TriageOption(id: "dis-fire-monitor", label: "Far Away — Assess Path", icon: "binoculars.fill", destination: .techniqueList(["env-wildfire-monitor", "env-forest-fire-approach"]))
                        ])
                    )),
                    TriageOption(id: "dis-heat", label: "Extreme Heat", icon: "sun.max.fill", destination: .nextQuestion(
                        TriageNode(id: "dis-heat-q", question: "Any symptoms?", options: [
                            TriageOption(id: "dis-heat-cramp", label: "Sweating / Cramps / Weak", icon: "drop.fill", destination: .techniqueList(["env-extreme-heat", "env-heat-exhaustion-treatment"])),
                            TriageOption(id: "dis-heat-stroke", label: "No Sweat / Confusion / Hot", icon: "exclamationmark.triangle.fill", destination: .technique("env-heat-exhaustion")),
                            TriageOption(id: "dis-heat-general", label: "Staying Alive in Heat", icon: "sun.max.fill", destination: .technique("env-extreme-heat"))
                        ])
                    ))
                ])
            )),

            TriageOption(id: "dis-cat-manmade", label: "Man-Made / Unrest", icon: "exclamationmark.triangle.fill", destination: .nextQuestion(
                TriageNode(id: "dis-man-q", question: "What is the threat?", options: [
                    TriageOption(id: "dis-nuclear", label: "Nuclear / HAZMAT", icon: "radio", destination: .nextQuestion(
                        TriageNode(id: "dis-nuc-q", question: "What is the threat?", options: [
                            TriageOption(id: "dis-nuc-fallout", label: "Nuclear Fallout — Shelter", icon: "house.fill", destination: .technique("env-nuclear-fallout-shelter")),
                            TriageOption(id: "dis-nuc-quick", label: "Quick Fallout Protection", icon: "smoke.fill", destination: .technique("env-nuclear-fallout")),
                            TriageOption(id: "dis-nuc-hazmat", label: "Chemical / HAZMAT Spill", icon: "wind", destination: .technique("env-hazmat-evac"))
                        ])
                    )),
                    TriageOption(id: "dis-unrest", label: "Civil Unrest / Riots", icon: "person.3.fill", destination: .nextQuestion(
                        TriageNode(id: "dis-unr-q", question: "Your situation?", options: [
                            TriageOption(id: "dis-unr-home", label: "Sheltering at Home", icon: "house.fill", destination: .techniqueList(["env-door-barricade", "env-urban-disaster"])),
                            TriageOption(id: "dis-unr-move", label: "Need to Move Unseen", icon: "figure.walk", destination: .techniqueList(["env-urban-grayman", "env-anti-tracking"])),
                            TriageOption(id: "dis-unr-vehicle", label: "In a Vehicle — Mob", icon: "car.fill", destination: .technique("env-vehicle-riot-evasion")),
                            TriageOption(id: "dis-unr-detained", label: "Detained / Restrained", icon: "lock.fill", destination: .technique("env-ziptie-escape"))
                        ])
                    ))
                ])
            ))
        ])
    }
}
