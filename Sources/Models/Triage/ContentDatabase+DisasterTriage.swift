import Foundation

// Auto-generated: buildDisasterTriage extracted from ContentDatabase.swift
extension ContentDatabase {
    // =========================================================================
    // MARK: - NATURAL DISASTER (5 levels deep)
    // =========================================================================
    func buildDisasterTriage() -> TriageNode {
        TriageNode(id: "disaster-root", question: "What disaster are you facing?", options: [

            // --- EARTHQUAKE ---
            TriageOption(id: "dis-earthquake", label: "Earthquake", icon: "waveform.path.ecg", destination: .nextQuestion(
                TriageNode(id: "dis-eq-q", question: "Where are you?", options: [
                    TriageOption(id: "dis-eq-indoor", label: "Indoors", icon: "building.2.fill", destination: .technique("env-earthquake-indoor")),
                    TriageOption(id: "dis-eq-outdoor", label: "Outdoors", icon: "tree.fill", destination: .technique("env-earthquake-outdoor")),
                    TriageOption(id: "dis-eq-after", label: "Earthquake Over — Now What?", icon: "checkmark.circle", destination: .nextQuestion(
                        TriageNode(id: "dis-eq-after-q", question: "What's your situation?", options: [
                            TriageOption(id: "dis-eq-injured", label: "Injured", icon: "cross.case.fill", destination: .techniqueList(["firstaid-wound-cleaning", "firstaid-crush-injury", "firstaid-shock"])),
                            TriageOption(id: "dis-eq-trapped", label: "Trapped Under Debris", icon: "rectangle.compress.vertical", destination: .techniqueList(["rescue-morse-code", "rescue-whistle", "rescue-phone-emergency"])),
                            TriageOption(id: "dis-eq-safe", label: "Safe — Need Shelter", icon: "house.fill", destination: .techniqueList(["shelter-poncho", "shelter-vehicle", "shelter-emergency-bivy"]))
                        ])
                    ))
                ])
            )),

            // --- TORNADO ---
            TriageOption(id: "dis-tornado", label: "Tornado", icon: "tornado", destination: .nextQuestion(
                TriageNode(id: "dis-tor-q", question: "Where are you?", options: [
                    TriageOption(id: "dis-tor-building", label: "In a House/Building", icon: "building.2.fill", destination: .technique("env-tornado-shelter")),
                    TriageOption(id: "dis-tor-mobile", label: "Mobile Home", icon: "house.fill", destination: .technique("env-tornado-mobile")), 
                    TriageOption(id: "dis-tor-vehicle", label: "In a Vehicle", icon: "car.fill", destination: .nextQuestion(
                        TriageNode(id: "dis-tor-drive-q", question: "Can you see its path?", options: [
                            TriageOption(id: "dis-tor-drive-evade", label: "Yes — Evade", icon: "arrow.turn.up.right", destination: .technique("env-tornado-drive")),
                            TriageOption(id: "dis-tor-drive-trap", label: "Trapped / Close", icon: "exclamationmark.triangle.fill", destination: .technique("env-tornado-ditch"))
                        ])
                    )),
                ])
            )),

            // --- WILDFIRE ---
            TriageOption(id: "dis-wildfire", label: "Wildfire", icon: "flame", destination: .nextQuestion(
                TriageNode(id: "dis-fire-q", question: "How close is the fire?", options: [
                    TriageOption(id: "dis-fire-far", label: "Visible but Far", icon: "arrow.right", destination: .nextQuestion(
                         TriageNode(id: "dis-fire-wind", question: "Monitor the wind!", options: [
                            TriageOption(id: "dis-fire-monitor", label: "Watch & Prepare", icon: "wind", destination: .technique("env-wildfire-monitor")),
                            TriageOption(id: "dis-fire-evac-early", label: "Evacuating Now", icon: "car.fill", destination: .technique("env-wildfire-evac"))
                         ])
                    )),
                    TriageOption(id: "dis-fire-vehicle", label: "Trapped in Vehicle", icon: "car.fill", destination: .technique("env-wildfire-vehicle")),
                    TriageOption(id: "dis-fire-house", label: "Trapped in House", icon: "house.fill", destination: .technique("env-wildfire-survival")),
                ])
            )),

            // --- FLOOD ---
            TriageOption(id: "dis-flood", label: "Flood / Flash Flood", icon: "water.waves", destination: .nextQuestion(
                TriageNode(id: "dis-flood-q", question: "Where are you?", options: [
                    TriageOption(id: "dis-flood-indoor", label: "Indoors", icon: "house.fill", destination: .technique("env-flood-survival")),
                    TriageOption(id: "dis-flood-outdoor", label: "Outdoors / Swept Away", icon: "figure.wave", destination: .techniqueList(["env-flood-survival", "rescue-self-rescue"])),
                    TriageOption(id: "dis-flood-after", label: "Water Receding", icon: "arrow.down", destination: .technique("water-boiling")) // Disease risk
                ])
            )),

            // --- HURRICANE ---
            TriageOption(id: "dis-hurricane", label: "Hurricane / Cyclone", icon: "hurricane", destination: .nextQuestion(
                TriageNode(id: "dis-hurr-q", question: "What stage?", options: [
                    TriageOption(id: "dis-hurr-prep", label: "Approaching (Pre-Storm)", icon: "clock.fill", destination: .technique("env-coastal-storm")),
                    TriageOption(id: "dis-hurr-during", label: "During the Storm", icon: "wind", destination: .technique("env-hurricane")),
                ])
            )),

            // --- BLIZZARD ---
            TriageOption(id: "dis-blizzard", label: "Blizzard / Whiteout", icon: "snowflake", destination: .nextQuestion(
                TriageNode(id: "dis-blizz-q", question: "Where are you?", options: [
                    TriageOption(id: "dis-blizz-car", label: "Stranded in Car", icon: "car.fill", destination: .technique("env-blizzard")),
                    TriageOption(id: "dis-blizz-outdoor", label: "Caught Outdoors", icon: "figure.walk", destination: .techniqueList(["env-blizzard", "shelter-snow-trench"])),
                    TriageOption(id: "dis-blizz-home", label: "At Home (No Power)", icon: "house.fill", destination: .nextQuestion(
                        TriageNode(id: "dis-blizz-home-q", question: "What is your main concern?", options: [
                            TriageOption(id: "dis-blizz-heat", label: "Staying Warm", icon: "flame", destination: .nextQuestion(
                                TriageNode(id: "dis-blizz-heat-q", question: "Do you have a fireplace?", options: [
                                    TriageOption(id: "dis-blizz-no-fire", label: "No — Electric Only", icon: "xmark.circle.fill", destination: .techniqueList(["shelter-mylar-wrap", "firstaid-hypothermia", "shelter-insulation-techniques"])) // Added orphan
                                ])
                            )),
                            TriageOption(id: "dis-blizz-water", label: "Safe Drinking Water", icon: "drop.fill", destination: .technique("water-snow-ice")),
                            TriageOption(id: "dis-blizz-pipe", label: "Pipes Frozen / Burst", icon: "wrench.fill", destination: .technique("water-rationing"))
                        ])
                    ))
                ])
            )),

            // --- LIGHTNING ---
            TriageOption(id: "dis-lightning", label: "Lightning / Thunderstorm", icon: "cloud.bolt.fill", destination: .nextQuestion(
                TriageNode(id: "dis-light-q", question: "Where are you?", options: [
                    TriageOption(id: "dis-light-exposed", label: "Open / Exposed Area", icon: "figure.walk", destination: .technique("env-lightning-position")),
                    TriageOption(id: "dis-light-mtn", label: "Mountain Ridge / Peak", icon: "mountain.2.fill", destination: .technique("env-mountain-lightning")),
                    TriageOption(id: "dis-light-forest", label: "Forest / Near Trees", icon: "tree.fill", destination: .technique("env-lightning-safety")),
                    TriageOption(id: "dis-light-dist", label: "Calculating Distance", icon: "stopwatch.fill", destination: .technique("env-lightning-dist"))
                ])
            )),

            // --- AVALANCHE ---
            TriageOption(id: "dis-avalanche", label: "Avalanche", icon: "mountain.2.fill", destination: .nextQuestion(
                TriageNode(id: "dis-aval-q", question: "What's your situation?", options: [
                    TriageOption(id: "dis-aval-imminent", label: "Avalanche Starting — Act NOW", icon: "exclamationmark.triangle.fill", destination: .technique("env-avalanche")),
                ])
            )),

            // --- VOLCANO ---
            TriageOption(id: "dis-volcano", label: "Volcanic Eruption", icon: "smoke.fill", destination: .nextQuestion(
                TriageNode(id: "dis-volc-q", question: "What are the hazards?", options: [
                    TriageOption(id: "dis-volc-ash", label: "Ashfall (Breathing)", icon: "lungs.fill", destination: .technique("env-volcanic-ash")),
                    TriageOption(id: "dis-volc-flow", label: "Lava / Pyroclastic Flow", icon: "flame", destination: .technique("env-volcanic-eruption")),
                    TriageOption(id: "dis-volc-shelter", label: "Sheltering in Place", icon: "house.fill", destination: .technique("env-volcanic-ashfall"))
                ])
            )),

            // --- TSUNAMI ---
            TriageOption(id: "dis-tsunami", label: "Tsunami", icon: "water.waves.and.arrow.up", destination: .nextQuestion(
                TriageNode(id: "dis-tsu-q", question: "What's happening?", options: [
                    TriageOption(id: "dis-tsu-warning", label: "Earthquake / Warning Siren", icon: "speaker.wave.3.fill", destination: .technique("env-tsunami-response")),
                    TriageOption(id: "dis-tsu-wave", label: "Wave Incoming / Hitting", icon: "water.waves", destination: .technique("env-tsunami")),
                ])
            )),

            // --- EXTREME HEAT ---
            TriageOption(id: "dis-heat", label: "Extreme Heat / Heat Wave", icon: "sun.max.fill", destination: .nextQuestion(
                TriageNode(id: "dis-heat-q", question: "Any symptoms?", options: [
                    TriageOption(id: "dis-heat-cramp", label: "Cramps / Heavy Sweating", icon: "drop.fill", destination: .technique("env-extreme-heat")),
                    TriageOption(id: "dis-heat-stroke", label: "No Sweat / Confusion / Hot Skin", icon: "exclamationmark.triangle.fill", destination: .technique("firstaid-heat-stroke")),
                    TriageOption(id: "dis-heat-water", label: "Need Water Source", icon: "waterbottle.fill", destination: .technique("water-vegetation-indicators"))
                ])
            )),

            // --- SANDSTORM ---
            TriageOption(id: "dis-sandstorm", label: "Sandstorm", icon: "wind", destination: .technique("env-sandstorm")),

            // --- QUICKSAND ---
            TriageOption(id: "dis-quicksand", label: "Quicksand / Mud", icon: "arrow.down.circle.fill", destination: .technique("env-quicksand")),

            // --- LIGHTNING ---
            TriageOption(id: "dis-lightning", label: "Lightning Storm", icon: "bolt.fill", destination: .nextQuestion(
                TriageNode(id: "dis-light-dist", question: "Count seconds: Flash to Bang", options: [
                    TriageOption(id: "light-far", label: "Over 30 Seconds", icon: "checkmark.circle", destination: .nextQuestion(
                        TriageNode(id: "dis-light-q", question: "Where are you?", options: [
                            TriageOption(id: "dis-light-struck", label: "Someone Was Struck", icon: "bolt.heart.fill", destination: .techniqueList(["env-lightning-safety", "firstaid-cpr"]))
                        ])
                    ))
                ])
            )),

            // --- NUCLEAR / RADIOLOGICAL ---
            TriageOption(id: "dis-nuclear", label: "Nuclear / Radiological", icon: "exclamationmark.triangle.fill", destination: .nextQuestion(
                TriageNode(id: "dis-nuc-q", question: "What is the threat?", options: [
                    TriageOption(id: "nuc-fallout", label: "Fallout Warning", icon: "smoke.fill", destination: .nextQuestion(
                        TriageNode(id: "nuc-fallout-q", question: "Where is shelter?", options: [
                            TriageOption(id: "nuc-shelter-under", label: "Underground / Basement", icon: "house.fill", destination: .technique("shelter-underground")), // NOTE: Mapped to shelter-vehicle if underground missing
                        ])
                    )),
                    TriageOption(id: "nuc-water", label: "Concerned About Water", icon: "drop.fill", destination: .technique("water-filter-sock")) // Best proxy for purification
                ])
            )),

            // --- PANDEMIC / BIOHAZARD ---
            TriageOption(id: "dis-bio", label: "Pandemic / Biohazard", icon: "allergens.fill", destination: .nextQuestion(
                TriageNode(id: "dis-bio-q", question: "Immediate need?", options: [
                    TriageOption(id: "bio-isolate", label: "Isolation / Quarantine Area", icon: "house.fill", destination: .technique("shelter-urban-debris")),
                ])
            )),

            // --- CIVIL UNREST ---
            TriageOption(id: "dis-unrest", label: "Civil Unrest / Riots", icon: "person.3.fill", destination: .nextQuestion(
                TriageNode(id: "dis-unrest-q", question: "Your situation?", options: [
                    TriageOption(id: "unrest-home", label: "Sheltering at Home", icon: "house.fill", destination: .techniqueList(["env-door-barricade", "env-urban-disaster"])),
                    TriageOption(id: "unrest-move", label: "Need to Move / Evade", icon: "figure.walk", destination: .techniqueList(["env-urban-grayman", "env-anti-tracking", "env-vehicle-entry"])),
                    TriageOption(id: "unrest-detained", label: "Detained / Restrained", icon: "lock.fill", destination: .technique("env-ziptie-escape")),
                    TriageOption(id: "unrest-crowd", label: "Caught in Crowd", icon: "exclamationmark.triangle.fill", destination: .article("psych-article-panic")) // Fixed ID
                ])
            )),

            // --- CYBER / GRID DOWN ---
            TriageOption(id: "dis-cyber", label: "Solar Flare / Cyber Attack", icon: "bolt.slash.fill", destination: .nextQuestion(
                TriageNode(id: "dis-cyber-q", question: "Main challenge?", options: [
                    TriageOption(id: "cyber-comms", label: "No Communications", icon: "antenna.radiowaves.left.and.right.slash", destination: .technique("rescue-cd-mirror")),
                    TriageOption(id: "cyber-supply", label: "Supply Chain / Food", icon: "cart.fill", destination: .technique("food-rationing"))
                ])
            )),

            // --- REBUILDING CIVILIZATION ---
            TriageOption(id: "dis-rebuild", label: "Long Term / Rebuilding", icon: "hammer.fill", destination: .nextQuestion(
                TriageNode(id: "dis-rebuild-q", question: "What do you need to produce?", options: [
                    TriageOption(id: "rebuild-hygiene", label: "Soap & Hygiene", icon: "hands.sparkles.fill", destination: .techniqueList(["hygiene-soap-making", "hygiene-charcoal-toothpaste"])),
                    TriageOption(id: "rebuild-agri", label: "Agriculture (Farming)", icon: "leaf.fill", destination: .techniqueList(["agri-three-sisters", "agri-seed-saving", "agri-composting"])),
                    TriageOption(id: "rebuild-industry", label: "Industry (Leather/Weaving)", icon: "gearshape.2.fill", destination: .techniqueList(["industry-tanning", "industry-basketry"]))
                ])
            )),

            // --- FLASH FLOOD ---
            TriageOption(id: "dis-flash-flood", label: "Flash Flood", icon: "cloud.heavyrain.fill", destination: .nextQuestion(
                TriageNode(id: "dis-flash-q", question: "Where are you?", options: [
                    TriageOption(id: "dis-flash-canyon", label: "Canyon / Ravine", icon: "mountain.2.fill", destination: .technique("env-flash-flood")),
                    TriageOption(id: "dis-flash-road", label: "Road / Vehicle", icon: "car.fill", destination: .technique("env-flash-flood-response")),
                ])
            )),

            // --- OCEAN / COASTAL ---
            TriageOption(id: "dis-ocean", label: "Ocean / Coastal Emergency", icon: "water.waves", destination: .nextQuestion(
                TriageNode(id: "dis-ocean-q", question: "What's happening?", options: [
                    TriageOption(id: "dis-ocean-survive", label: "Adrift at Sea", icon: "sailboat.fill", destination: .technique("env-ocean-survival")),
                    TriageOption(id: "dis-coastal-tidal", label: "Tidal / Coastal Hazard", icon: "water.waves", destination: .technique("env-coastal-tidal")),
                ])
            )),

            // --- GENERAL DISASTER GUIDES ---
            TriageOption(id: "dis-general", label: "General Disaster Guides", icon: "book.fill", destination: .nextQuestion(
                TriageNode(id: "dis-gen-q", question: "Which disaster?", options: [
                    TriageOption(id: "dis-gen-quake", label: "Earthquake (General)", icon: "waveform.path.ecg", destination: .technique("env-earthquake")),
                    TriageOption(id: "dis-gen-tornado", label: "Tornado (General)", icon: "tornado", destination: .technique("env-tornado")),
                    TriageOption(id: "dis-gen-wildfire", label: "Wildfire (General)", icon: "flame", destination: .technique("env-wildfire")),
                    TriageOption(id: "dis-gen-lightning", label: "Lightning (General)", icon: "bolt.fill", destination: .technique("env-lightning"))
                ])
            )),

            // 📚 LEARN MORE
            TriageOption(id: "dis-learn", label: "Learn More", icon: "book.fill", destination: .nextQuestion(
                TriageNode(id: "dis-learn-q", question: "What would you like to read about?", options: [
                    TriageOption(id: "dis-art-multihazard", label: "Multi-Hazard Preparedness", icon: "exclamationmark.shield.fill", destination: .article("env-article-multihazard")),
                    TriageOption(id: "dis-art-flood", label: "Flood Science", icon: "water.waves", destination: .articleList(["env-article-flood", "env-article-flash-flood-science"])),
                    TriageOption(id: "dis-art-wildfire", label: "Wildfire Behavior", icon: "flame", destination: .article("env-article-wildfire-behavior")),
                    TriageOption(id: "dis-art-urban", label: "Urban Disaster Survival", icon: "building.2.fill", destination: .article("env-article-urban-disaster")),
                    TriageOption(id: "dis-art-mountain", label: "Mountain Hazards", icon: "mountain.2.fill", destination: .article("env-article-mountain")),
                    TriageOption(id: "dis-art-altitude", label: "Altitude Sickness", icon: "arrow.up.to.line", destination: .article("env-article-altitude")),
                    TriageOption(id: "dis-art-climate", label: "Climate & Weather Patterns", icon: "cloud.sun.fill", destination: .article("env-article-climate")),
                    TriageOption(id: "dis-art-desert", label: "Desert Survival Guide", icon: "sun.max.fill", destination: .article("env-article-desert")),
                    TriageOption(id: "dis-art-jungle", label: "Jungle Survival", icon: "leaf.fill", destination: .articleList(["env-article-jungle", "env-article-jungle-medicine"])),
                    TriageOption(id: "dis-art-ocean", label: "Ocean Hazards", icon: "water.waves", destination: .article("env-article-ocean")),
                    TriageOption(id: "dis-art-cave", label: "Cave Safety", icon: "mountain.2.circle.fill", destination: .article("env-article-cave-guide")),
                    TriageOption(id: "dis-art-arctic", label: "Arctic Conditions", icon: "snowflake", destination: .article("env-article-arctic"))
                ])
            )),

            TriageOption(id: "g32", label: "CBRN", icon: "exclamationmark.triangle.fill", destination: .nextQuestion(
                TriageNode(id: "g32-q", question: "Which best matches?", options: [
                    TriageOption(id: "g33", label: "Maximize shielding from radioactive fallout", icon: "house.fill", destination: .technique("env-nuclear-fallout-shelter"))
                ])
            )),

            TriageOption(id: "g34", label: "Cold Weather", icon: "cloud.fill", destination: .nextQuestion(
                TriageNode(id: "g34-q", question: "Which best matches?", options: [
                    TriageOption(id: "g35", label: "Create an air pocket and orient yourself", icon: "brain.head.profile", destination: .technique("env-avalanche-survival")),
                    TriageOption(id: "g36", label: "Determine if ice is safe to cross — thickness and quali", icon: "list.bullet.clipboard.fill", destination: .technique("env-ice-travel-safety")),
                    TriageOption(id: "g37", label: "Protecting the retinas from severe UV burns.", icon: "flame.fill", destination: .technique("env-arctic-snow-blindness-prevention"))
                ])
            )),

            TriageOption(id: "g38", label: "Earthquake", icon: "waveform.path", destination: .nextQuestion(
                TriageNode(id: "g38-q", question: "What specifically?", options: [
                TriageOption(id: "g39", label: "Surviving", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g39-q", question: "Select:", options: [
                        TriageOption(id: "g40", label: "Surviving a direct hurricane hit", icon: "house.fill", destination: .technique("env-hurricane-shelter-protocol")),
                        TriageOption(id: "g41", label: "Recognizing and surviving tidal waves", icon: "water.waves", destination: .technique("env-tsunami-survival")),
                        TriageOption(id: "g42", label: "Surviving the lethal surge zone", icon: "figure.walk.motion", destination: .technique("env-tsunami-vertical"))
                    ])
                )),
                TriageOption(id: "g43", label: "Landslide", icon: "triangle.fill", destination: .nextQuestion(
                    TriageNode(id: "g43-q", question: "Select:", options: [
                        TriageOption(id: "g44", label: "Survive a debris flow inside a structure", icon: "triangle.fill", destination: .technique("env-landslide-indoor")),
                        TriageOption(id: "g45", label: "Evasive action for ground-level debris flows", icon: "triangle.fill", destination: .technique("env-landslide-outdoor")),
                        TriageOption(id: "g46", label: "Respond to a mudslide while driving", icon: "triangle.fill", destination: .technique("env-landslide-vehicle"))
                    ])
                )),
                TriageOption(id: "g47", label: "Immediately", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g47-q", question: "Select:", options: [
                        TriageOption(id: "g48", label: "Survive rapidly rising indoor water", icon: "scissors", destination: .technique("env-flood-rooftop-escape")),
                        TriageOption(id: "g49", label: "Survive sudden ground subsidence", icon: "eye.slash.fill", destination: .technique("env-sinkhole-escape"))
                    ])
                )),
                TriageOption(id: "g50", label: "Flood", icon: "water.waves", destination: .nextQuestion(
                    TriageNode(id: "g50-q", question: "Select:", options: [
                        TriageOption(id: "g51", label: "Detect and evade charged water", icon: "water.waves", destination: .technique("env-flood-electrocution")),
                        TriageOption(id: "g52", label: "Treat contaminated floodwater exposure", icon: "cross.case.fill", destination: .technique("env-flood-waterborne-disease"))
                    ])
                )),
                TriageOption(id: "g53", label: "Shelter", icon: "house.fill", destination: .nextQuestion(
                    TriageNode(id: "g53-q", question: "Select:", options: [
                        TriageOption(id: "g54", label: "When you can't reach a building", icon: "house.fill", destination: .technique("env-tornado-field-survival")),
                        TriageOption(id: "g55", label: "Protecting yourself from volcanic ashfall", icon: "house.fill", destination: .technique("env-volcanic-ash-survival"))
                    ])
                )),
                TriageOption(id: "g56", label: "Swimming", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g56-q", question: "Select:", options: [
                        TriageOption(id: "g57", label: "Survive sudden rock descents on steep terrain", icon: "cloud.rain.fill", destination: .technique("env-rockfall-evasion")),
                        TriageOption(id: "g58", label: "Defensive posture in fast currents", icon: "cross.case.fill", destination: .technique("env-flood-swiftwater-swim")),
                        TriageOption(id: "g59", label: "Maximize survival odds inside a void", icon: "target", destination: .technique("env-landslide-trapped"))
                    ])
                ))
                ])
            )),

            TriageOption(id: "g60", label: "Flood & Tsunami", icon: "water.waves", destination: .nextQuestion(
                TriageNode(id: "g60-q", question: "What specifically?", options: [
                TriageOption(id: "g61", label: "Response", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g61-q", question: "Select:", options: [
                        TriageOption(id: "g62", label: "Drop, Cover, Hold On — do not run outside", icon: "waveform.path", destination: .technique("env-earthquake-during")),
                        TriageOption(id: "g63", label: "Natural warnings that give you minutes to act", icon: "waveform.path", destination: .technique("env-tsunami-warning-signs")),
                        TriageOption(id: "g64", label: "Survive lava flows, pyroclastic flows, and lahars", icon: "cloud.fill", destination: .technique("env-volcano-eruption-response"))
                    ])
                )),
                TriageOption(id: "g65", label: "Signs", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g65-q", question: "Select:", options: [
                        TriageOption(id: "g66", label: "React in seconds — 6 inches of water knocks you down", icon: "link", destination: .technique("env-flash-flood-survival")),
                        TriageOption(id: "g67", label: "Seconds of warning can save your life", icon: "drop.fill", destination: .technique("env-landslide-warning"))
                    ])
                )),
                TriageOption(id: "g68", label: "Trapped", icon: "target", destination: .nextQuestion(
                    TriageNode(id: "g68-q", question: "Select:", options: [
                        TriageOption(id: "g69", label: "Escape a car trapped in floodwater", icon: "target", destination: .technique("env-flood-vehicle-submergence")),
                        TriageOption(id: "g70", label: "Last resort when trapped by a fast-moving grass or fore", icon: "flame.fill", destination: .technique("env-wildfire-entrapment"))
                    ])
                )),
                TriageOption(id: "g71", label: "Fill", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g71-q", question: "Select:", options: [
                        TriageOption(id: "g72", label: "Create an effective flood barrier", icon: "water.waves", destination: .technique("env-flood-sandbagging")),
                        TriageOption(id: "g73", label: "72-hour advance preparation protocol", icon: "cloud.fill", destination: .technique("env-hurricane-preparation"))
                    ])
                )),
                TriageOption(id: "g74", label: "Survive", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g74-q", question: "Select:", options: [
                        TriageOption(id: "g75", label: "Survive the toxic slurry of urban flooding", icon: "exclamationmark.triangle.fill", destination: .technique("env-flood-chem-triage")),
                        TriageOption(id: "g76", label: "Survive massive water contamination", icon: "water.waves", destination: .technique("env-flood-water-sanitation")),
                        TriageOption(id: "g77", label: "Survive a tornado with no building nearby", icon: "fish.fill", destination: .technique("env-tornado-shelter-field"))
                    ])
                )),
                TriageOption(id: "g78", label: "Flood", icon: "water.waves", destination: .nextQuestion(
                    TriageNode(id: "g78-q", question: "Select:", options: [
                        TriageOption(id: "g79", label: "Read water flow to avoid sweepers and strainers", icon: "cloud.rain.fill", destination: .technique("env-flood-hydrology")),
                        TriageOption(id: "g80", label: "Assess building collapse risk during inundation", icon: "list.bullet.clipboard.fill", destination: .technique("env-flood-structural-diagnostics")),
                        TriageOption(id: "g81", label: "Determine if a wildfire threatens your position", icon: "list.bullet.clipboard.fill", destination: .technique("env-forest-fire-approach"))
                    ])
                ))
                ])
            )),

            TriageOption(id: "g82", label: "Hazards", icon: "cross.case.fill", destination: .nextQuestion(
                TriageNode(id: "g82-q", question: "Which best matches?", options: [
                    TriageOption(id: "g83", label: "Navigate hazards of abandoned mines", icon: "cross.case.fill", destination: .technique("env-mine-shaft-safety"))
                ])
            )),

            TriageOption(id: "g84", label: "Landslide", icon: "triangle.fill", destination: .nextQuestion(
                TriageNode(id: "g84-q", question: "Which best matches?", options: [
                    TriageOption(id: "g85", label: "Survive a fast-moving mudslide", icon: "figure.walk.motion", destination: .technique("env-landslide-debris-flow-escape")),
                    TriageOption(id: "g86", label: "Recognize the invisible signs of a slide", icon: "triangle.fill", destination: .technique("env-landslide-early-warning")),
                    TriageOption(id: "g87", label: "Identify earth failure tension cracks", icon: "triangle.fill", destination: .technique("env-landslide-geotech-analysis")),
                    TriageOption(id: "g88", label: "Maximize air when buried by debris", icon: "drop.fill", destination: .technique("env-landslide-entrapment-survival"))
                ])
            )),

            TriageOption(id: "g89", label: "Severe Weather", icon: "cloud.fill", destination: .nextQuestion(
                TriageNode(id: "g89-q", question: "What specifically?", options: [
                TriageOption(id: "g90", label: "Ground", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g90-q", question: "Select:", options: [
                        TriageOption(id: "g91", label: "Survive sudden flooding — seconds matter", icon: "link", destination: .technique("env-flash-flood-adv")),
                        TriageOption(id: "g92", label: "Emergency response when caught in rising water", icon: "link", destination: .technique("env-flood-vertical")),
                        TriageOption(id: "g93", label: "Survive and evade a mudslide or debris flow", icon: "cross.case.fill", destination: .technique("env-mudslide-survival")),
                        TriageOption(id: "g94", label: "Free yourself from quicksand or saturated ground", icon: "cross.case.fill", destination: .technique("env-quicksand-response")),
                        TriageOption(id: "g95", label: "React safely to sudden ground collapse", icon: "star.fill", destination: .technique("env-sinkhole-response"))
                    ])
                )),
                TriageOption(id: "g96", label: "Survive", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g96-q", question: "Select:", options: [
                        TriageOption(id: "g97", label: "Survive a sandstorm or dust storm", icon: "cloud.fill", destination: .technique("env-dust-storm-response")),
                        TriageOption(id: "g98", label: "Survive extended power loss during ice storms", icon: "cloud.fill", destination: .technique("env-ice-storm-outage")),
                        TriageOption(id: "g99", label: "Survive exposure to wildfire smoke", icon: "flame.fill", destination: .technique("env-wildfire-smoke"))
                    ])
                )),
                TriageOption(id: "g100", label: "Dangerous", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g100-q", question: "Select:", options: [
                        TriageOption(id: "g101", label: "Specific SAS protocol for managing Dangerous Flora Veri", icon: "mountain.2.fill", destination: .technique("env-encyclopedia-mitigation-alpine-dangerous")),
                        TriageOption(id: "g102", label: "Specific SAS protocol for managing Dangerous Flora Veri", icon: "snowflake", destination: .technique("env-encyclopedia-mitigation-arctic-dangerous")),
                        TriageOption(id: "g103", label: "Specific SAS protocol for managing Dangerous Flora Veri", icon: "sun.max.fill", destination: .technique("env-encyclopedia-mitigation-desert-dangerous")),
                        TriageOption(id: "g104", label: "Protect yourself from dangerous hail", icon: "house.fill", destination: .technique("env-hailstorm-shelter")),
                        TriageOption(id: "g105", label: "Specific SAS protocol for managing Dangerous Flora Veri", icon: "leaf.fill", destination: .technique("env-encyclopedia-mitigation-jungle-dangerous"))
                    ])
                )),
                TriageOption(id: "g106", label: "Shelter", icon: "house.fill", destination: .nextQuestion(
                    TriageNode(id: "g106-q", question: "Select:", options: [
                        TriageOption(id: "g107", label: "Minimizing strike probability in open terrain", icon: "cloud.rain.fill", destination: .technique("env-lightning-crouch")),
                        TriageOption(id: "g108", label: "30/30 rule and position of last resort", icon: "house.fill", destination: .technique("env-lightning-safety-rules")),
                        TriageOption(id: "g109", label: "Systematic threat assessment and protective actions", icon: "list.bullet.clipboard.fill", destination: .technique("env-thunderstorm-safety")),
                        TriageOption(id: "g110", label: "Last-resort positioning when caught without shelter", icon: "house.fill", destination: .technique("env-tornado-field"))
                    ])
                )),
                TriageOption(id: "g111", label: "Severe", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g111-q", question: "Select:", options: [
                        TriageOption(id: "g112", label: "Specific SAS protocol for managing Severe Dehydration i", icon: "sun.max.fill", destination: .technique("env-encyclopedia-mitigation-alpine-severe")),
                        TriageOption(id: "g113", label: "Specific SAS protocol for managing Severe Dehydration i", icon: "sun.max.fill", destination: .technique("env-encyclopedia-mitigation-arctic-severe")),
                        TriageOption(id: "g114", label: "Specific SAS protocol for managing Severe Dehydration i", icon: "sun.max.fill", destination: .technique("env-encyclopedia-mitigation-desert-severe")),
                        TriageOption(id: "g115", label: "Specific SAS protocol for managing Severe Dehydration i", icon: "sun.max.fill", destination: .technique("env-encyclopedia-mitigation-jungle-severe")),
                        TriageOption(id: "g116", label: "Specific SAS protocol for managing Severe Dehydration i", icon: "sun.max.fill", destination: .technique("env-encyclopedia-mitigation-oceanic-severe"))
                    ])
                )),
                TriageOption(id: "g117", label: "Desert", icon: "sun.max.fill", destination: .nextQuestion(
                    TriageNode(id: "g117-q", question: "Select:", options: [
                        TriageOption(id: "g118", label: "Respond to rising water inside a cave", icon: "cloud.rain.fill", destination: .technique("env-cave-flood-response")),
                        TriageOption(id: "g119", label: "Specific SAS protocol for managing Hyperthermia (Heat S", icon: "brain.head.profile", destination: .technique("env-encyclopedia-mitigation-desert-hyperthermia")),
                        TriageOption(id: "g120", label: "Specific SAS protocol for managing Hypothermia in a Des", icon: "snowflake", destination: .technique("env-encyclopedia-mitigation-desert-hypothermia")),
                        TriageOption(id: "g121", label: "Navigate safely in dense fog", icon: "cross.case.fill", destination: .technique("env-fog-navigation")),
                        TriageOption(id: "g122", label: "Hazards after floodwaters recede", icon: "water.waves", destination: .technique("env-post-flood"))
                    ])
                )),
                TriageOption(id: "g123", label: "Desert (2)", icon: "sun.max.fill", destination: .nextQuestion(
                    TriageNode(id: "g123-q", question: "Select:", options: [
                        TriageOption(id: "g124", label: "Specific SAS protocol for managing Disorientation/Mirag", icon: "location.north.fill", destination: .technique("env-encyclopedia-mitigation-desert-disorientation-mirages")),
                        TriageOption(id: "g125", label: "Specific SAS protocol for managing Flash Flooding in a ", icon: "link", destination: .technique("env-encyclopedia-mitigation-desert-flash")),
                        TriageOption(id: "g126", label: "Specific SAS protocol for managing Frostbite/Immersion ", icon: "ant.fill", destination: .technique("env-encyclopedia-mitigation-desert-frostbite-immersion")),
                        TriageOption(id: "g127", label: "Specific SAS protocol for managing Predator Evasion in ", icon: "eye.slash.fill", destination: .technique("env-encyclopedia-mitigation-desert-predator")),
                        TriageOption(id: "g128", label: "Specific SAS protocol for managing Tidal Shifts in a De", icon: "sun.max.fill", destination: .technique("env-encyclopedia-mitigation-desert-tidal"))
                    ])
                )),
                TriageOption(id: "g129", label: "Arctic", icon: "snowflake", destination: .nextQuestion(
                    TriageNode(id: "g129-q", question: "Select:", options: [
                        TriageOption(id: "g130", label: "Specific SAS protocol for managing Disorientation/Mirag", icon: "location.north.fill", destination: .technique("env-encyclopedia-mitigation-arctic-disorientation-mirages")),
                        TriageOption(id: "g131", label: "Specific SAS protocol for managing Flash Flooding in a ", icon: "link", destination: .technique("env-encyclopedia-mitigation-arctic-flash")),
                        TriageOption(id: "g132", label: "Specific SAS protocol for managing Frostbite/Immersion ", icon: "ant.fill", destination: .technique("env-encyclopedia-mitigation-arctic-frostbite-immersion")),
                        TriageOption(id: "g133", label: "Specific SAS protocol for managing Hypothermia in a Arc", icon: "snowflake", destination: .technique("env-encyclopedia-mitigation-arctic-hypothermia")),
                        TriageOption(id: "g134", label: "Specific SAS protocol for managing Predator Evasion in ", icon: "eye.slash.fill", destination: .technique("env-encyclopedia-mitigation-arctic-predator"))
                    ])
                )),
                TriageOption(id: "g135", label: "Jungle", icon: "leaf.fill", destination: .nextQuestion(
                    TriageNode(id: "g135-q", question: "Select:", options: [
                        TriageOption(id: "g136", label: "Specific SAS protocol for managing Avalanche Terrain in", icon: "cloud.rain.fill", destination: .technique("env-encyclopedia-mitigation-arctic-avalanche")),
                        TriageOption(id: "g137", label: "Specific SAS protocol for managing Tidal Shifts in a Ar", icon: "snowflake", destination: .technique("env-encyclopedia-mitigation-arctic-tidal")),
                        TriageOption(id: "g138", label: "Specific SAS protocol for managing Disorientation/Mirag", icon: "location.north.fill", destination: .technique("env-encyclopedia-mitigation-jungle-disorientation-mirages")),
                        TriageOption(id: "g139", label: "Specific SAS protocol for managing Hyperthermia (Heat S", icon: "brain.head.profile", destination: .technique("env-encyclopedia-mitigation-jungle-hyperthermia")),
                        TriageOption(id: "g140", label: "Specific SAS protocol for managing Hypothermia in a Jun", icon: "snowflake", destination: .technique("env-encyclopedia-mitigation-jungle-hypothermia"))
                    ])
                )),
                TriageOption(id: "g141", label: "Jungle (2)", icon: "leaf.fill", destination: .nextQuestion(
                    TriageNode(id: "g141-q", question: "Select:", options: [
                        TriageOption(id: "g142", label: "Specific SAS protocol for managing Hypothermia in a Alp", icon: "snowflake", destination: .technique("env-encyclopedia-mitigation-alpine-hypothermia")),
                        TriageOption(id: "g143", label: "Specific SAS protocol for managing Avalanche Terrain in", icon: "cloud.rain.fill", destination: .technique("env-encyclopedia-mitigation-jungle-avalanche")),
                        TriageOption(id: "g144", label: "Specific SAS protocol for managing Flash Flooding in a ", icon: "link", destination: .technique("env-encyclopedia-mitigation-jungle-flash")),
                        TriageOption(id: "g145", label: "Specific SAS protocol for managing Predator Evasion in ", icon: "eye.slash.fill", destination: .technique("env-encyclopedia-mitigation-jungle-predator")),
                        TriageOption(id: "g146", label: "Specific SAS protocol for managing Tidal Shifts in a Ju", icon: "leaf.fill", destination: .technique("env-encyclopedia-mitigation-jungle-tidal"))
                    ])
                )),
                TriageOption(id: "g147", label: "Alpine", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g147-q", question: "Select:", options: [
                        TriageOption(id: "g148", label: "Specific SAS protocol for managing Disorientation/Mirag", icon: "mountain.2.fill", destination: .technique("env-encyclopedia-mitigation-alpine-disorientation-mirages")),
                        TriageOption(id: "g149", label: "Specific SAS protocol for managing Flash Flooding in a ", icon: "mountain.2.fill", destination: .technique("env-encyclopedia-mitigation-alpine-flash")),
                        TriageOption(id: "g150", label: "Specific SAS protocol for managing Frostbite/Immersion ", icon: "ant.fill", destination: .technique("env-encyclopedia-mitigation-alpine-frostbite-immersion")),
                        TriageOption(id: "g151", label: "Specific SAS protocol for managing Predator Evasion in ", icon: "mountain.2.fill", destination: .technique("env-encyclopedia-mitigation-alpine-predator")),
                        TriageOption(id: "g152", label: "Specific SAS protocol for managing Tidal Shifts in a Al", icon: "mountain.2.fill", destination: .technique("env-encyclopedia-mitigation-alpine-tidal"))
                    ])
                )),
                TriageOption(id: "g153", label: "Oceanic", icon: "water.waves", destination: .nextQuestion(
                    TriageNode(id: "g153-q", question: "Select:", options: [
                        TriageOption(id: "g154", label: "Specific SAS protocol for managing Avalanche Terrain in", icon: "mountain.2.fill", destination: .technique("env-encyclopedia-mitigation-alpine-avalanche")),
                        TriageOption(id: "g155", label: "Specific SAS protocol for managing Disorientation/Mirag", icon: "location.north.fill", destination: .technique("env-encyclopedia-mitigation-oceanic-disorientation-mirages")),
                        TriageOption(id: "g156", label: "Specific SAS protocol for managing Hyperthermia (Heat S", icon: "brain.head.profile", destination: .technique("env-encyclopedia-mitigation-oceanic-hyperthermia")),
                        TriageOption(id: "g157", label: "Specific SAS protocol for managing Hypothermia in a Oce", icon: "snowflake", destination: .technique("env-encyclopedia-mitigation-oceanic-hypothermia")),
                        TriageOption(id: "g158", label: "Specific SAS protocol for managing Predator Evasion in ", icon: "eye.slash.fill", destination: .technique("env-encyclopedia-mitigation-oceanic-predator"))
                    ])
                )),
                TriageOption(id: "g159", label: "Oceanic (2)", icon: "water.waves", destination: .nextQuestion(
                    TriageNode(id: "g159-q", question: "Select:", options: [
                        TriageOption(id: "g160", label: "Specific SAS protocol for managing Flash Flooding in a ", icon: "link", destination: .technique("env-encyclopedia-mitigation-oceanic-flash")),
                        TriageOption(id: "g161", label: "Specific SAS protocol for managing Tidal Shifts in a Oc", icon: "water.waves", destination: .technique("env-encyclopedia-mitigation-oceanic-tidal"))
                    ])
                ))
                ])
            )),

            TriageOption(id: "g162", label: "Terrain Hazard", icon: "cloud.rain.fill", destination: .nextQuestion(
                TriageNode(id: "g162-q", question: "Which best matches?", options: [
                    TriageOption(id: "g163", label: "Identify at-risk terrain before the ground collapses", icon: "cloud.rain.fill", destination: .technique("env-sinkhole-avoidance"))
                ])
            )),

            TriageOption(id: "g164", label: "Water Hazard", icon: "cross.case.fill", destination: .nextQuestion(
                TriageNode(id: "g164-q", question: "Which best matches?", options: [
                    TriageOption(id: "g165", label: "Cross water safely when jellyfish are present", icon: "fish.fill", destination: .technique("env-jellyfish-swarm-navigation"))
                ])
            )),

            TriageOption(id: "g166", label: "Wildfire", icon: "flame.fill", destination: .nextQuestion(
                TriageNode(id: "g166-q", question: "Which best matches?", options: [
                    TriageOption(id: "g167", label: "Surviving entrapment in a fast-moving brush fire", icon: "flame.fill", destination: .technique("env-wildfire-escape"))
                ])
            )),
        ])
    }

}
