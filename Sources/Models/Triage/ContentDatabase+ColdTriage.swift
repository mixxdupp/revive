import Foundation

// Auto-generated: buildColdTriage extracted from ContentDatabase.swift
extension ContentDatabase {
    // =========================================================================
    // MARK: - COLD / HYPOTHERMIA (5 levels deep)
    // =========================================================================
    func buildColdTriage() -> TriageNode {
        TriageNode(id: "cold-root", question: "Do you have shelter?", options: [

            // ── NO SHELTER ──
            TriageOption(id: "cold-no-shelter", label: "No Shelter", icon: "tent.fill", destination: .nextQuestion(
                TriageNode(id: "cold-env", question: "What environment are you in?", options: [

                    // Forest
                    TriageOption(id: "cold-forest", label: "Forest / Woodland", icon: "tree.fill", destination: .nextQuestion(
                        TriageNode(id: "cold-forest-mat", question: "What materials do you have?", options: [
                            TriageOption(id: "cold-tarp-yes", label: "Tarp / Plastic Sheet", icon: "square.fill", destination: .nextQuestion(
                                TriageNode(id: "cold-tarp-weather", question: "What's the weather?", options: [
                                    TriageOption(id: "cold-tarp-rain", label: "Raining", icon: "cloud.rain.fill", destination: .technique("shelter-tarp-aframe")),
                                    TriageOption(id: "cold-tarp-snow", label: "Snowing", icon: "cloud.snow.fill", destination: .technique("shelter-tarp-leanto")),
                                    TriageOption(id: "cold-tarp-dry", label: "Dry but Cold", icon: "wind", destination: .techniqueList(["shelter-tarp-diamond", "shelter-tarp-plowpoint"])), // Added orphan
                                    TriageOption(id: "cold-tarp-wind", label: "Very Windy", icon: "wind", destination: .techniqueList(["shelter-tarp-cfly", "shelter-storm-proofing"])) // Added orphan
                                ])
                            )),
                            TriageOption(id: "cold-rope-only", label: "Rope / Cordage Only", icon: "line.diagonal", destination: .technique("shelter-lean-to")),
                            TriageOption(id: "cold-nothing", label: "Nothing at All", icon: "xmark.circle.fill", destination: .nextQuestion(
                                TriageNode(id: "cold-debris-q", question: "Is there debris on the ground?", options: [
                                    TriageOption(id: "cold-debris-yes", label: "Lots of Leaves & Branches", icon: "leaf.fill", destination: .technique("shelter-debris-aframe")),
                                    TriageOption(id: "cold-debris-round", label: "Some — Can Pile Up", icon: "circle.fill", destination: .techniqueList(["shelter-debris-round", "shelter-natural-hollow"])), // Added orphan
                                    TriageOption(id: "cold-debris-bare", label: "Bare Ground", icon: "xmark.circle", destination: .technique("shelter-tree-well"))
                                ])
                            )),
                            TriageOption(id: "cold-mylar", label: "Space Blanket / Trash Bag", icon: "sparkle", destination: .technique("shelter-mylar-wrap"))
                        ])
                    )),

                    // Snow / Arctic
                    TriageOption(id: "cold-snow", label: "Snow / Arctic", icon: "snowflake", destination: .nextQuestion(
                        TriageNode(id: "cold-snow-depth", question: "How deep is the snow?", options: [
                            TriageOption(id: "cold-snow-deep", label: "Waist-Deep or More", icon: "arrow.down.to.line", destination: .nextQuestion(
                                TriageNode(id: "cold-snow-tool", question: "Do you have a digging tool?", options: [
                                    TriageOption(id: "cold-snow-shovel", label: "Shovel / Pot / Flat Object", icon: "square.fill", destination: .technique("shelter-quinzhee")),
                                    TriageOption(id: "cold-snow-hands", label: "Bare Hands / Stick", icon: "hand.raised.fill", destination: .techniqueList(["shelter-snow-trench", "tools-digging-stick"])) // Added orphan
                                ])
                            )),
                            TriageOption(id: "cold-snow-blocks", label: "Can Cut Firm Blocks", icon: "square.stack.3d.up.fill", destination: .technique("shelter-igloo"))
                        ])
                    )),

                    // Desert / Open
                    TriageOption(id: "cold-desert", label: "Desert / Open Ground", icon: "sun.max.fill", destination: .nextQuestion(
                        TriageNode(id: "cold-desert-mat", question: "Any materials available?", options: [
                            TriageOption(id: "cold-desert-vehicle", label: "Near a Vehicle", icon: "car.fill", destination: .technique("shelter-vehicle")),
                            TriageOption(id: "cold-desert-nothing", label: "Nothing — Open Exposure", icon: "xmark.circle.fill", destination: .technique("shelter-emergency-bivy"))
                        ])
                    )),

                    // Urban
                    TriageOption(id: "cold-urban", label: "Urban / Suburban", icon: "building.2.fill", destination: .nextQuestion(
                        TriageNode(id: "cold-urban-q", question: "Can you get indoors?", options: [
                            TriageOption(id: "cold-urban-building", label: "Building Available", icon: "door.left.hand.open", destination: .technique("env-urban-disaster")),
                            TriageOption(id: "cold-urban-none", label: "Outdoors Only", icon: "xmark.circle.fill", destination: .nextQuestion(
                                TriageNode(id: "cold-urban-mat", question: "What's available?", options: [
                                ])
                            ))
                        ])
                    )),

                    // Mountain
                    TriageOption(id: "cold-mountain", label: "Mountain / Exposed Ridge", icon: "mountain.2.fill", destination: .nextQuestion(
                        TriageNode(id: "cold-mtn-q", question: "Can you descend to tree line?", options: [
                            TriageOption(id: "cold-mtn-stuck", label: "No — Stuck on Ridge", icon: "xmark.circle.fill", destination: .nextQuestion(
                                TriageNode(id: "cold-mtn-wind", question: "Is there a windbreak?", options: [
                                    TriageOption(id: "cold-mtn-rock", label: "Rock Outcrop / Boulder", icon: "triangle.fill", destination: .technique("env-cave-survival")),
                                ])
                            ))
                        ])
                    ))
                ])
            )),

            // ── HAVE SHELTER ──
            TriageOption(id: "cold-has-shelter", label: "Have Shelter", icon: "house.fill", destination: .nextQuestion(
                TriageNode(id: "cold-concern", question: "What's your main concern?", options: [

                    // Need fire
                    TriageOption(id: "cold-need-fire", label: "Need to Start Fire", icon: "flame", destination: .nextQuestion(
                        TriageNode(id: "cold-fire-tools", question: "What fire tools do you have?", options: [
                            TriageOption(id: "cold-lighter", label: "Lighter or Matches", icon: "flame", destination: .nextQuestion(
                                TriageNode(id: "cold-fire-goal", question: "What type of fire do you need?", options: [
                                    TriageOption(id: "cold-quick", label: "Quick Heat Now", icon: "flame", destination: .technique("fire-teepee")),
                                    TriageOption(id: "cold-long", label: "All-Night Warmth", icon: "moon.fill", destination: .technique("fire-long-fire")),
                                    TriageOption(id: "cold-cook", label: "Cooking Fire", icon: "frying.pan.fill", destination: .technique("fire-log-cabin"))
                                ])
                            )),
                            TriageOption(id: "cold-ferro", label: "Ferro Rod / Firesteel", icon: "sparkle", destination: .technique("fire-ferrorod")),
                            TriageOption(id: "cold-no-tools", label: "Nothing — No Tools", icon: "xmark.circle.fill", destination: .nextQuestion(
                                TriageNode(id: "cold-prim-fire", question: "Is the sun out?", options: [
                                    TriageOption(id: "cold-sun-yes", label: "Yes — Sunny", icon: "sun.max.fill", destination: .technique("fire-magnifying")),
                                    TriageOption(id: "cold-sun-no", label: "No — Overcast/Night", icon: "cloud.fill", destination: .technique("fire-bowdrill"))
                                ])
                            ))
                        ])
                    )),

                    // Hypothermia symptoms
                    TriageOption(id: "cold-hypothermia", label: "Signs of Hypothermia", icon: "thermometer.snowflake", destination: .nextQuestion(
                        TriageNode(id: "cold-hypo-who", question: "Who is affected?", options: [
                            TriageOption(id: "cold-hypo-self", label: "Myself", icon: "person.fill", destination: .nextQuestion(
                                TriageNode(id: "cold-hypo-severity", question: "How severe?", options: [
                                    TriageOption(id: "cold-mild", label: "Shivering, Still Alert", icon: "exclamationmark.circle", destination: .nextQuestion(
                                        TriageNode(id: "cold-shiver-q", question: "Shivering intensity?", options: [
                                            TriageOption(id: "cold-shiver-violent", label: "Violent Shivering", icon: "wind", destination: .technique("firstaid-hypothermia")),
                                        ])
                                    )),
                                    TriageOption(id: "cold-frostbite", label: "Numbness, White/Gray Skin", icon: "hand.raised.fill", destination: .technique("env-arctic-frostbite")),
                                    TriageOption(id: "cold-trenchfoot", label: "Wet/Soggy Feet (Painful)", icon: "drop.fill", destination: .technique("firstaid-trench-foot")) // Added orphan
                                ])
                            )),
                            TriageOption(id: "cold-hypo-other", label: "Someone Else", icon: "person.2.fill", destination: .nextQuestion(
                                TriageNode(id: "cold-hypo-other-q", question: "Are they conscious?", options: [
                                    TriageOption(id: "cold-other-uncon", label: "No — Unconscious", icon: "exclamationmark.triangle.fill", destination: .techniqueList(["firstaid-hypothermia", "firstaid-recovery-position"]))
                                ])
                            ))
                        ])
                    )),

                    // Better insulation
                    TriageOption(id: "cold-insulation", label: "Need Better Insulation", icon: "bed.double.fill", destination: .nextQuestion(
                        TriageNode(id: "cold-insul-q", question: "What's available for insulation?", options: [
                            TriageOption(id: "cold-insul-hammock", label: "Off the Ground (Hammock)", icon: "figure.mind.and.body", destination: .technique("shelter-hammock"))
                        ])
                    )),

                    // Wet clothes
                    TriageOption(id: "cold-wet-clothes", label: "Wet Clothes / Drenched", icon: "drop.fill", destination: .nextQuestion(
                        TriageNode(id: "cold-wet-q", question: "Can you make fire?", options: [
                        ])
                    )),

                    // Psychological
                    TriageOption(id: "cold-morale", label: "Losing Hope / Morale", icon: "brain.head.profile", destination: .nextQuestion(
                        TriageNode(id: "cold-morale-q", question: "What do you need?", options: [
                            TriageOption(id: "cold-calm", label: "Calm Down / Breathe", icon: "wind", destination: .technique("psych-box-breathing")),
                            TriageOption(id: "cold-decide", label: "Can't Decide What To Do", icon: "questionmark.circle.fill", destination: .technique("psych-ooda-loop")),
                            TriageOption(id: "cold-alone", label: "Feeling Alone / Isolated", icon: "person.fill", destination: .technique("psych-loneliness"))
                        ])
                    )),

                    // Shelter Improvement
                    TriageOption(id: "cold-improve", label: "Improve Existing Shelter", icon: "wrench.fill", destination: .nextQuestion(
                        TriageNode(id: "cold-improve-q", question: "What improvement?", options: [
                            TriageOption(id: "cold-heated-bed", label: "Heated Sleeping Platform", icon: "flame", destination: .technique("shelter-heated-bed")),
                            TriageOption(id: "cold-fire-reflect", label: "Fire Reflector Wall", icon: "rectangle.split.3x1.fill", destination: .technique("shelter-fire-reflector")),
                            TriageOption(id: "cold-vent", label: "Ventilation (Prevent CO)", icon: "wind", destination: .technique("shelter-ventilation")),
                            TriageOption(id: "cold-snow-wall", label: "Snow Wall Windbreak", icon: "square.stack.fill", destination: .technique("shelter-snow-wall")),
                            TriageOption(id: "cold-door-const", label: "Door / Entrance Block", icon: "door.left.hand.closed", destination: .technique("shelter-door-construction")),
                            TriageOption(id: "cold-waterproof", label: "Waterproofing", icon: "drop.fill", destination: .technique("shelter-waterproofing"))
                        ])
                    )),

                    // Arctic/Tundra Travel
                    TriageOption(id: "cold-arctic-travel", label: "Need to Travel in Cold", icon: "figure.walk", destination: .nextQuestion(
                        TriageNode(id: "cold-travel-q", question: "What terrain?", options: [
                            TriageOption(id: "cold-arctic-move", label: "Arctic / Polar", icon: "snowflake", destination: .technique("env-arctic-travel")),
                            TriageOption(id: "cold-tundra-move", label: "Tundra / Open Frozen", icon: "wind", destination: .technique("env-tundra-travel")),
                            TriageOption(id: "cold-snow-nav", label: "Snow Navigation", icon: "location.fill", destination: .technique("nav-snow-navigation")),
                            TriageOption(id: "cold-snow-goggles", label: "Snow Blindness Prevention", icon: "eyeglasses", destination: .technique("tools-snow-goggles"))
                        ])
                    ))
                ])
            )),

            // 📚 LEARN MORE
            TriageOption(id: "cold-learn", label: "Learn More", icon: "book.fill", destination: .nextQuestion(
                TriageNode(id: "cold-learn-q", question: "What would you like to read about?", options: [
                    TriageOption(id: "cold-art-insulation", label: "Insulation Science", icon: "thermometer.snowflake", destination: .articleList(["shelter-article-insulation", "shelter-article-insulation-values"])),
                    TriageOption(id: "cold-art-snow", label: "Snow Insulation", icon: "snowflake", destination: .article("shelter-article-snow-insulation")),
                    TriageOption(id: "cold-art-arctic", label: "Arctic Survival Guide", icon: "globe", destination: .article("env-article-arctic")),
                    TriageOption(id: "cold-art-winter-water", label: "Winter Water Sources", icon: "drop.fill", destination: .articleList(["water-article-ice-snow", "water-article-winter"])),
                    TriageOption(id: "cold-art-bedding", label: "Bedding & Ground Insulation", icon: "bed.double.fill", destination: .articleList(["shelter-article-bedding", "shelter-article-ground"]))
                ])
            )),

            TriageOption(id: "g17", label: "Alpine", icon: "cross.case.fill", destination: .nextQuestion(
                TriageNode(id: "g17-q", question: "Which best matches?", options: [
                    TriageOption(id: "g18", label: "Preventing altitude illness through controlled ascent", icon: "mountain.2.fill", destination: .technique("env-altitude-acclimatization")),
                    TriageOption(id: "g19", label: "Fighting to stay on the surface of a moving snow slide", icon: "bandage.fill", destination: .technique("env-avalanche-swim")),
                    TriageOption(id: "g20", label: "Manage above 15,000 feet without acclimatization", icon: "mountain.2.fill", destination: .technique("env-extreme-altitude"))
                ])
            )),

            TriageOption(id: "g21", label: "Arctic", icon: "snowflake", destination: .nextQuestion(
                TriageNode(id: "g21-q", question: "What specifically?", options: [
                TriageOption(id: "g22", label: "Arctic", icon: "snowflake", destination: .nextQuestion(
                    TriageNode(id: "g22-q", question: "Select:", options: [
                        TriageOption(id: "g23", label: "Surviving polar temperatures — snow is your insulator", icon: "house.fill", destination: .technique("env-arctic-shelter-adv")),
                        TriageOption(id: "g24", label: "Moving safely through sub-zero environments", icon: "snowflake", destination: .technique("env-arctic-movement"))
                    ])
                )),
                TriageOption(id: "g25", label: "Through", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g25-q", question: "Select:", options: [
                        TriageOption(id: "g26", label: "Catching fish through a hole in frozen lakes", icon: "fish.fill", destination: .technique("env-ice-fishing")),
                        TriageOption(id: "g27", label: "Preventing moisture from entering insulation in extreme", icon: "cross.case.fill", destination: .technique("env-vapor-barrier"))
                    ])
                )),
                TriageOption(id: "g28", label: "Hypothermia", icon: "snowflake", destination: .nextQuestion(
                    TriageNode(id: "g28-q", question: "Select:", options: [
                        TriageOption(id: "g29", label: "Actions during and after avalanche burial", icon: "triangle.fill", destination: .technique("env-avalanche-burial-survival")),
                        TriageOption(id: "g30", label: "Identifying mild, moderate, and severe hypothermia prog", icon: "snowflake", destination: .technique("env-hypothermia-stages")),
                        TriageOption(id: "g31", label: "Moving safely in zero-visibility snow conditions", icon: "cross.case.fill", destination: .technique("env-whiteout-navigation"))
                    ])
                ))
                ])
            )),
        ])
    }

}
