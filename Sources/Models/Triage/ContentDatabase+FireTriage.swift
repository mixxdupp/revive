import Foundation

// Auto-generated: buildFireTriage extracted from ContentDatabase.swift
extension ContentDatabase {
    // =========================================================================
    // MARK: - NEED FIRE (5 levels deep)
    // =========================================================================
    func buildFireTriage() -> TriageNode {
        TriageNode(id: "fire-root", question: "What fire-starting tools do you have?", options: [

            // Lighter / Matches
            TriageOption(id: "fire-lighter", label: "Lighter or Matches", icon: "flame", destination: .nextQuestion(
                TriageNode(id: "fire-cond", question: "Do you have a kit?", options: [
                    TriageOption(id: "fire-kit-yes", label: "Yes — Waterproof Kit", icon: "archivebox.fill", destination: .technique("fire-waterproof-kit")), // Added orphan
                    TriageOption(id: "fire-kit-no", label: "No — Standard Lighter", icon: "flame", destination: .nextQuestion(
                        TriageNode(id: "fire-standard-cond", question: "Current Conditions?", options: [
                            TriageOption(id: "fire-dry", label: "Dry Conditions", icon: "sun.max.fill", destination: .nextQuestion(
                                TriageNode(id: "fire-goal", question: "What's your goal?", options: [
                                    TriageOption(id: "fire-lay-log", label: "Log Cabin (Long Burn)", icon: "square.grid.2x2.fill", destination: .techniqueList(["fire-log-cabin", "fire-upside-down"])), // Added orphan
                                    TriageOption(id: "fire-lay-star", label: "Star Fire (Efficient)", icon: "star.fill", destination: .technique("fire-star-fire")), // Added orphan
                                    TriageOption(id: "fire-lay-lean", label: "Lean-To (Windy)", icon: "arrow.up.right", destination: .technique("fire-lean-to")),
                                    TriageOption(id: "fire-stealth", label: "Low Smoke / Tactical", icon: "eye.slash.fill", destination: .technique("fire-dakota-hole")),
                                    TriageOption(id: "fire-signal", label: "Signal Fire", icon: "antenna.radiowaves.left.and.right", destination: .technique("rescue-signal-fire")),
                                    TriageOption(id: "fire-goal-bug", label: "Repel Insects", icon: "ant.fill", destination: .technique("fire-insect-repellent")) // Added orphan
                                ])
                            )),
                            TriageOption(id: "fire-wet", label: "Raining / Wet Wood", icon: "cloud.rain.fill", destination: .technique("fire-wet-conditions")),
                        ])
                    ))
                ])
            )),

            // Ferro Rod
            TriageOption(id: "fire-ferro", label: "Ferro Rod / Firesteel", icon: "sparkle", destination: .nextQuestion(
                TriageNode(id: "fire-ferro-tinder", question: "Do you have good tinder?", options: [
                    TriageOption(id: "fire-ferro-good", label: "Birch Bark / Lint / Dry Grass", icon: "leaf.fill", destination: .nextQuestion(
                         TriageNode(id: "fire-tinder-type", question: "What kind?", options: [
                            TriageOption(id: "fire-tinder-natural", label: "Natural (Bark/Grass)", icon: "leaf.fill", destination: .techniqueList(["fire-ferrorod", "fire-birch-bark"])), // Added orphan
                            TriageOption(id: "fire-tinder-man", label: "Man-Made (Lint/Paper/Jute)", icon: "doc.text.fill", destination: .techniqueList(["fire-ferrorod", "fire-jute-twine"])) // Added orphan
                         ])
                    )),
                    TriageOption(id: "fire-ferro-none", label: "No Tinder Available", icon: "xmark.circle.fill", destination: .nextQuestion(
                        TriageNode(id: "fire-tinder-make", question: "Can you make tinder?", options: [
                            TriageOption(id: "fire-feather", label: "Have Knife + Dry Wood", icon: "knife.fill", destination: .technique("fire-feather-stick")),
                            TriageOption(id: "fire-charcloth", label: "Cotton + Existing Ember", icon: "tshirt.fill", destination: .technique("fire-charcloth")),
                            TriageOption(id: "fire-carry", label: "Already Have Ember to Transport", icon: "flame", destination: .technique("fire-ember-carrier"))
                        ])
                    ))
                ])
            )),

            // Flint + Steel
            TriageOption(id: "fire-flint", label: "Knife + Flint / Quartz", icon: "bolt.fill", destination: .nextQuestion(
                TriageNode(id: "fire-flint-q", question: "Do you have charcloth or dry fungus?", options: [
                    TriageOption(id: "fire-flint-yes", label: "Yes — Have Char Material", icon: "checkmark.circle.fill", destination: .technique("fire-flint-steel")),
                ])
            )),

            // Battery
            TriageOption(id: "fire-battery", label: "Battery + Steel Wool / Gum Wrapper", icon: "battery.75percent", destination: .technique("fire-battery")),

            // Chemical
            TriageOption(id: "fire-chemical", label: "Potassium Permanganate + Glycerin", icon: "flask.fill", destination: .technique("fire-chemical")),

            // Compression (Piston)
            TriageOption(id: "fire-piston", label: "Fire Piston", icon: "cylinder.split.1x2.fill", destination: .technique("fire-piston")), // Orphan

            // Pet Jelly
            TriageOption(id: "fire-vaseline", label: "Cotton Balls + Vaseline", icon: "cross.vial.fill", destination: .technique("fire-vaseline-cotton")), // Orphan

            // NOTHING — Primitive
            TriageOption(id: "fire-nothing", label: "Nothing — No Tools", icon: "xmark.circle.fill", destination: .nextQuestion(
                TriageNode(id: "fire-sun-q", question: "Is the sun visible?", options: [
                    TriageOption(id: "fire-sun-yes", label: "Yes — Sunny", icon: "sun.max.fill", destination: .nextQuestion(
                        TriageNode(id: "fire-solar", question: "Do you have anything to focus light?", options: [
                            TriageOption(id: "fire-solar-can", label: "Soda Can / Reflector", icon: "circle.fill", destination: .technique("fire-chocolate-can")), // Added orphan
                            TriageOption(id: "fire-ice-avail", label: "Clear Ice Available", icon: "snowflake", destination: .technique("fire-ice-lens")),
                        ])
                    )),
                    TriageOption(id: "fire-sun-no", label: "No — Cloudy or Night", icon: "cloud.fill", destination: .nextQuestion(
                        TriageNode(id: "fire-friction", question: "What wood is available?", options: [
                            TriageOption(id: "fire-bamboo-avail", label: "Bamboo Available", icon: "leaf.fill", destination: .technique("fire-firesaw")),
                            TriageOption(id: "fire-handdrill-avail", label: "Cattail / Mullein Stalks", icon: "wand.and.stars", destination: .techniqueList(["fire-handdrill", "tools-hand-drill-improvement"])), // Added orphan
                            TriageOption(id: "fire-plow-avail", label: "Flat Board + Hard Stick", icon: "rectangle.fill", destination: .technique("fire-fire-plow"))
                        ])
                    ))
                ])
            )),

            // 8. HOUSEHOLD HACKS (Phase 5)
            TriageOption(id: "fire-hacks", label: "Household Hacks", icon: "lightbulb.fill", destination: .nextQuestion(
                TriageNode(id: "fire-hacks-q", question: "What do you have?", options: [
                    TriageOption(id: "fire-hack-batt", label: "Battery & Wrapper", icon: "battery.100", destination: .technique("fire-battery-gum")),
                    TriageOption(id: "fire-hack-wool", label: "Steel Wool & 9V", icon: "bolt.fill", destination: .technique("fire-steel-wool")),
                ])
            )),

            // 9. FIRE MAINTENANCE (Keep It Going)
            TriageOption(id: "fire-maintain", label: "Fire Maintenance", icon: "flame", destination: .nextQuestion(
                TriageNode(id: "fire-maint-q", question: "What do you need?", options: [
                    TriageOption(id: "fire-fuel", label: "Fuel Stages (Tinder→Kindling→Fuel)", icon: "arrow.up.right", destination: .technique("fire-fuel-stages")),
                    TriageOption(id: "fire-reflect", label: "Reflector Wall (Direct Heat)", icon: "rectangle.split.3x1.fill", destination: .technique("fire-reflector-wall")),
                    TriageOption(id: "fire-safety-opt", label: "Safety Perimeter", icon: "shield.fill", destination: .technique("fire-safety-perimeter")),
                    TriageOption(id: "fire-extinguish-opt", label: "Extinguishing Safely", icon: "drop.fill", destination: .technique("fire-extinguish")),
                    TriageOption(id: "fire-sig-maint", label: "Signal Fire Maintenance", icon: "antenna.radiowaves.left.and.right", destination: .technique("fire-signal-maintenance")),
                    TriageOption(id: "fire-torch", label: "Make a Torch (Portable Light)", icon: "flashlight.on.fill", destination: .technique("fire-pine-torch"))
                ])
            )),

            // 10. SPECIALTY FIRE TYPES
            TriageOption(id: "fire-specialty", label: "Specialty Fire Types", icon: "square.grid.3x3.fill", destination: .nextQuestion(
                TriageNode(id: "fire-spec-q", question: "What's the purpose?", options: [
                    TriageOption(id: "fire-keyhole", label: "Keyhole Fire (Cook + Warm)", icon: "key.fill", destination: .technique("fire-keyhole-fire")),
                    TriageOption(id: "fire-trench-opt", label: "Trench Fire (Wind / Low Smoke)", icon: "arrow.down.to.line", destination: .technique("fire-trench-fire")),
                    TriageOption(id: "fire-conceal", label: "Concealed Fire (No Visibility)", icon: "eye.slash.fill", destination: .technique("fire-concealed"))
                ])
            )),

            // 11. FIRE IN BAD CONDITIONS
            TriageOption(id: "fire-conditions", label: "Fire in Bad Conditions", icon: "cloud.rain.fill", destination: .nextQuestion(
                TriageNode(id: "fire-bad-q", question: "What's the problem?", options: [
                    TriageOption(id: "fire-cond-snow", label: "Snow / Ice on Ground", icon: "snowflake", destination: .technique("fire-in-snow")),
                    TriageOption(id: "fire-cond-wind-opt", label: "High Wind", icon: "wind", destination: .technique("fire-in-wind")),
                ])
            )),

            // 12. TINDER & FUEL PREPARATION
            TriageOption(id: "fire-tinder-prep", label: "Tinder & Fuel Prep", icon: "leaf.fill", destination: .nextQuestion(
                TriageNode(id: "fire-prep-q", question: "What are you preparing?", options: [
                    TriageOption(id: "fire-prep-fatwood", label: "Find Fatwood / Resin Wood", icon: "tree.fill", destination: .technique("fire-fatwood-id")),
                    TriageOption(id: "fire-prep-charrope", label: "Make Char Rope", icon: "line.diagonal", destination: .technique("fire-char-rope")),
                    TriageOption(id: "fire-prep-bundle", label: "Fire Bundle (Transport Ember)", icon: "basket.fill", destination: .technique("fire-fire-bundle")),
                    TriageOption(id: "fire-prep-sanitizer", label: "Hand Sanitizer (Accelerant)", icon: "drop.fill", destination: .technique("fire-hand-sanitizer")),
                    TriageOption(id: "fire-prep-bamsaw", label: "Bamboo Fire Saw", icon: "leaf.fill", destination: .technique("fire-bamboo-fire-saw")),
                    TriageOption(id: "fire-prep-saw", label: "Wire / Friction Saw", icon: "scissors", destination: .technique("fire-saw")),
                    TriageOption(id: "fire-prep-plow", label: "Fire Plow (Flat Board)", icon: "rectangle.fill", destination: .technique("fire-plow"))
                ])
            )),

            // 📚 LEARN MORE
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

            TriageOption(id: "g168", label: "Fire Layouts", icon: "flame.fill", destination: .nextQuestion(
                TriageNode(id: "g168-q", question: "Which best matches?", options: [
                    TriageOption(id: "g169", label: "High-efficiency tin can stove", icon: "cross.case.fill", destination: .technique("fire-wood-gasifier")),
                    TriageOption(id: "g170", label: "Build a concealed, efficient fire below ground", icon: "flame.fill", destination: .technique("fire-underground-fire"))
                ])
            )),

            TriageOption(id: "g171", label: "Friction Fire", icon: "flame.fill", destination: .nextQuestion(
                TriageNode(id: "g171-q", question: "What specifically?", options: [
                TriageOption(id: "g172", label: "Willow", icon: "leaf.fill", destination: .nextQuestion(
                    TriageNode(id: "g172-q", question: "Select:", options: [
                        TriageOption(id: "g173", label: "Friction fire from scratch — the most important primiti", icon: "leaf.fill", destination: .technique("fire-bow-drill-mastery")),
                        TriageOption(id: "g174", label: "Executing the bow drill technique utilizing willow mate", icon: "heart.fill", destination: .technique("fire-encyclopedia-friction-bow-willow")),
                        TriageOption(id: "g175", label: "Friction fire by rubbing a stick in a groove", icon: "bandage.fill", destination: .technique("fire-fire-plough")),
                        TriageOption(id: "g176", label: "Executing the fire plow technique utilizing willow mate", icon: "heart.fill", destination: .technique("fire-encyclopedia-friction-fire-willow")),
                        TriageOption(id: "g177", label: "Executing the pump drill technique utilizing willow mat", icon: "heart.fill", destination: .technique("fire-encyclopedia-friction-pump-willow"))
                    ])
                )),
                TriageOption(id: "g178", label: "Cedar", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g178-q", question: "Select:", options: [
                        TriageOption(id: "g179", label: "Executing the bow drill technique utilizing cedar mater", icon: "heart.fill", destination: .technique("fire-encyclopedia-friction-bow-cedar")),
                        TriageOption(id: "g180", label: "Executing the fire plow technique utilizing cedar mater", icon: "heart.fill", destination: .technique("fire-encyclopedia-friction-fire-cedar")),
                        TriageOption(id: "g181", label: "Executing the pump drill technique utilizing cedar mate", icon: "heart.fill", destination: .technique("fire-encyclopedia-friction-pump-cedar"))
                    ])
                )),
                TriageOption(id: "g182", label: "Hand", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g182-q", question: "Select:", options: [
                        TriageOption(id: "g183", label: "The most primitive friction fire method", icon: "flame.fill", destination: .technique("fire-hand-drill")),
                        TriageOption(id: "g184", label: "Friction fire with no cordage — just your hands and woo", icon: "flame.fill", destination: .technique("fire-hand-drill-technique")),
                        TriageOption(id: "g185", label: "Executing the hand drill technique utilizing basswood m", icon: "heart.fill", destination: .technique("fire-encyclopedia-friction-hand-basswood")),
                        TriageOption(id: "g186", label: "Executing the hand drill technique utilizing cottonwood", icon: "heart.fill", destination: .technique("fire-encyclopedia-friction-hand-cottonwood")),
                        TriageOption(id: "g187", label: "Executing the hand drill technique utilizing yucca stal", icon: "heart.fill", destination: .technique("fire-encyclopedia-friction-hand-yucca"))
                    ])
                )),
                TriageOption(id: "g188", label: "Stalk", icon: "scope", destination: .nextQuestion(
                    TriageNode(id: "g188-q", question: "Select:", options: [
                        TriageOption(id: "g189", label: "Executing the bow drill technique utilizing yucca stalk", icon: "heart.fill", destination: .technique("fire-encyclopedia-friction-bow-yucca")),
                        TriageOption(id: "g190", label: "Executing the fire plow technique utilizing yucca stalk", icon: "heart.fill", destination: .technique("fire-encyclopedia-friction-fire-yucca")),
                        TriageOption(id: "g191", label: "Executing the pump drill technique utilizing yucca stal", icon: "heart.fill", destination: .technique("fire-encyclopedia-friction-pump-yucca"))
                    ])
                )),
                TriageOption(id: "g192", label: "Long", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g192-q", question: "Select:", options: [
                        TriageOption(id: "g193", label: "The most reliable primitive friction fire method", icon: "flame.fill", destination: .technique("fire-bow-drill")),
                        TriageOption(id: "g194", label: "Spin-driven friction fire using weighted flywheel", icon: "flame.fill", destination: .technique("fire-pump-drill"))
                    ])
                )),
                TriageOption(id: "g195", label: "Drill", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g195-q", question: "Select:", options: [
                        TriageOption(id: "g196", label: "Executing the bow drill technique utilizing basswood ma", icon: "heart.fill", destination: .technique("fire-encyclopedia-friction-bow-basswood")),
                        TriageOption(id: "g197", label: "Executing the bow drill technique utilizing cottonwood ", icon: "heart.fill", destination: .technique("fire-encyclopedia-friction-bow-cottonwood")),
                        TriageOption(id: "g198", label: "Friction fire by sawing a flexible strip through a groo", icon: "flame.fill", destination: .technique("fire-fire-saw")),
                        TriageOption(id: "g199", label: "Executing the pump drill technique utilizing cottonwood", icon: "heart.fill", destination: .technique("fire-encyclopedia-friction-pump-cottonwood")),
                        TriageOption(id: "g200", label: "Cooperative friction fire for easier ignition", icon: "flame.fill", destination: .technique("fire-two-person-bow-drill"))
                    ])
                )),
                TriageOption(id: "g201", label: "Basswood", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g201-q", question: "Select:", options: [
                        TriageOption(id: "g202", label: "Executing the fire plow technique utilizing basswood ma", icon: "heart.fill", destination: .technique("fire-encyclopedia-friction-fire-basswood")),
                        TriageOption(id: "g203", label: "Executing the fire saw technique utilizing cottonwood r", icon: "heart.fill", destination: .technique("fire-encyclopedia-friction-fire-cottonwood")),
                        TriageOption(id: "g204", label: "Executing the pump drill technique utilizing basswood m", icon: "heart.fill", destination: .technique("fire-encyclopedia-friction-pump-basswood"))
                    ])
                ))
                ])
            )),

            TriageOption(id: "g205", label: "Managing Fire", icon: "flame.fill", destination: .nextQuestion(
                TriageNode(id: "g205-q", question: "What specifically?", options: [
                TriageOption(id: "g206", label: "Coal", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g206-q", question: "Select:", options: [
                        TriageOption(id: "g207", label: "Preserving coals through the night", icon: "flame.fill", destination: .technique("fire-bank-fire-overnight")),
                        TriageOption(id: "g208", label: "Transport a live ember over long distances", icon: "figure.walk.motion", destination: .technique("fire-fire-bundle-carry")),
                        TriageOption(id: "g209", label: "Wrapping a live coal for extended transport", icon: "figure.walk.motion", destination: .technique("fire-coal-extender")),
                        TriageOption(id: "g210", label: "Hollow wood using hot coals to make bowls and tools", icon: "flame.fill", destination: .technique("fire-coal-burning-container")),
                        TriageOption(id: "g211", label: "Maintain fire through the night for warmth", icon: "flame.fill", destination: .technique("fire-night-fire-management"))
                    ])
                )),
                TriageOption(id: "g212", label: "Build", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g212-q", question: "Select:", options: [
                        TriageOption(id: "g213", label: "Keep a fire burning during wet weather", icon: "flame.fill", destination: .technique("fire-rain-fire-management")),
                        TriageOption(id: "g214", label: "Double your fire's heat output directed at your shelter", icon: "flame.fill", destination: .technique("fire-fire-reflector-wall")),
                        TriageOption(id: "g215", label: "Ultra-efficient cooking fire that uses 80% less wood", icon: "flame.fill", destination: .technique("fire-rocket-stove"))
                    ])
                )),
                TriageOption(id: "g216", label: "Wood", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g216-q", question: "Select:", options: [
                        TriageOption(id: "g217", label: "Carrying fire between camps using charred material", icon: "figure.walk.motion", destination: .technique("fire-ember-extension")),
                        TriageOption(id: "g218", label: "Create a long-burning torch from resin-soaked wood", icon: "flame.fill", destination: .technique("fire-pine-pitch-torch")),
                        TriageOption(id: "g219", label: "Overcome moisture when everything is damp", icon: "flame.fill", destination: .technique("fire-wet-wood-fire"))
                    ])
                )),
                TriageOption(id: "g220", label: "Logs", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g220-q", question: "Select:", options: [
                        TriageOption(id: "g221", label: "Self-feeding fire that requires no tending for hours", icon: "flame.fill", destination: .technique("fire-upside-down-fire")),
                        TriageOption(id: "g222", label: "Building a fire base on snow, mud, or wet ground", icon: "flame.fill", destination: .technique("fire-platform-base"))
                    ])
                )),
                TriageOption(id: "g223", label: "Configuration", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g223-q", question: "Select:", options: [
                        TriageOption(id: "g224", label: "Constructing a Lean-To configuration for specific therm", icon: "flame.fill", destination: .technique("fire-encyclopedia-geometry-lean-to")),
                        TriageOption(id: "g225", label: "Constructing a Log Cabin configuration for specific the", icon: "flame.fill", destination: .technique("fire-encyclopedia-geometry-log-cabin")),
                        TriageOption(id: "g226", label: "Constructing a Parallel/Trench configuration for specif", icon: "flame.fill", destination: .technique("fire-encyclopedia-geometry-parallel-trench")),
                        TriageOption(id: "g227", label: "Constructing a Star Fire configuration for specific the", icon: "flame.fill", destination: .technique("fire-encyclopedia-geometry-star-fire")),
                        TriageOption(id: "g228", label: "Constructing a Teepee configuration for specific therma", icon: "flame.fill", destination: .technique("fire-encyclopedia-geometry-teepee")),
                        TriageOption(id: "g229", label: "Constructing a Upside Down (Top-Lit) configuration for ", icon: "flame.fill", destination: .technique("fire-encyclopedia-geometry-upside-down-(top-lit)"))
                    ])
                )),
                TriageOption(id: "g230", label: "Fire", icon: "flame.fill", destination: .nextQuestion(
                    TriageNode(id: "g230-q", question: "Select:", options: [
                        TriageOption(id: "g231", label: "Prevent uncontrolled fire spread at camp", icon: "scissors", destination: .technique("fire-fire-safety-camp")),
                        TriageOption(id: "g232", label: "Transporting a live ember using fungal tinder", icon: "figure.walk.motion", destination: .technique("fire-coal-carry-fungus")),
                        TriageOption(id: "g233", label: "Create heat-resistant mortar for fire structures", icon: "flame.fill", destination: .technique("fire-fire-cement")),
                        TriageOption(id: "g234", label: "Making a rope that smolders for hours to carry fire bet", icon: "flame.fill", destination: .technique("fire-slow-match")),
                        TriageOption(id: "g235", label: "Self-contained cooking fire from a single log", icon: "flame.fill", destination: .technique("fire-swedish-torch"))
                    ])
                )),
                TriageOption(id: "g236", label: "Fire (2)", icon: "flame.fill", destination: .nextQuestion(
                    TriageNode(id: "g236-q", question: "Select:", options: [
                        TriageOption(id: "g237", label: "Concealed, windproof, high-efficiency fire", icon: "flame.fill", destination: .technique("fire- Dakota-hole")),
                        TriageOption(id: "g238", label: "Match your fire structure to your purpose", icon: "flame.fill", destination: .technique("fire-fire-lay-types")),
                        TriageOption(id: "g239", label: "Utilizing Oak for sustained fire building.", icon: "flame.fill", destination: .technique("fire-encyclopedia-fuel-oak-hardwood")),
                        TriageOption(id: "g240", label: "Creating visible smoke in different conditions", icon: "flame.fill", destination: .technique("fire-signal-smoke-colors")),
                        TriageOption(id: "g241", label: "Channeling heat beneath a sleeping platform", icon: "moon.fill", destination: .technique("fire-underground-flue"))
                    ])
                )),
                TriageOption(id: "g242", label: "Fuel", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g242-q", question: "Select:", options: [
                        TriageOption(id: "g243", label: "Utilizing Ash for sustained fire building.", icon: "flame.fill", destination: .technique("fire-encyclopedia-fuel-ash-hardwood")),
                        TriageOption(id: "g244", label: "Utilizing Cedar for sustained fire building.", icon: "flame.fill", destination: .technique("fire-encyclopedia-fuel-cedar-softwood")),
                        TriageOption(id: "g245", label: "Utilizing Hickory for sustained fire building.", icon: "flame.fill", destination: .technique("fire-encyclopedia-fuel-hickory-hardwood")),
                        TriageOption(id: "g246", label: "Utilizing Maple for sustained fire building.", icon: "flame.fill", destination: .technique("fire-encyclopedia-fuel-maple-hardwood")),
                        TriageOption(id: "g247", label: "Utilizing Pine for sustained fire building.", icon: "flame.fill", destination: .technique("fire-encyclopedia-fuel-pine-softwood"))
                    ])
                )),
                TriageOption(id: "g248", label: "Fuel (2)", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g248-q", question: "Select:", options: [
                        TriageOption(id: "g249", label: "Utilizing Birch for sustained fire building.", icon: "flame.fill", destination: .technique("fire-encyclopedia-fuel-birch")),
                        TriageOption(id: "g250", label: "Utilizing Poplar/Aspen for sustained fire building.", icon: "flame.fill", destination: .technique("fire-encyclopedia-fuel-poplar-aspen")),
                        TriageOption(id: "g251", label: "Utilizing Spruce for sustained fire building.", icon: "flame.fill", destination: .technique("fire-encyclopedia-fuel-spruce-softwood")),
                        TriageOption(id: "g252", label: "Utilizing Willow for sustained fire building.", icon: "leaf.fill", destination: .technique("fire-encyclopedia-fuel-willow"))
                    ])
                ))
                ])
            )),

            TriageOption(id: "g253", label: "Solar & Chemical", icon: "sun.max.fill", destination: .nextQuestion(
                TriageNode(id: "g253-q", question: "Which best matches?", options: [
                    TriageOption(id: "g254", label: "Focus sunlight through shaped ice to ignite tinder", icon: "flame.fill", destination: .technique("fire-fire-from-ice")),
                    TriageOption(id: "g255", label: "Focus sunlight through a lens to ignite tinder", icon: "eye.fill", destination: .technique("fire-magnifying-glass")),
                    TriageOption(id: "g256", label: "Spontaneous chemical combustion", icon: "drop.fill", destination: .technique("fire-chemical-permanganate")),
                    TriageOption(id: "g257", label: "Chemical delayed ignition", icon: "flame.fill", destination: .technique("fire-chemical-brake-fluid"))
                ])
            )),

            TriageOption(id: "g258", label: "Spark & Electrical", icon: "bolt.fill", destination: .nextQuestion(
                TriageNode(id: "g258-q", question: "What specifically?", options: [
                TriageOption(id: "g259", label: "Wool", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g259-q", question: "Select:", options: [
                        TriageOption(id: "g260", label: "Starting a fire using electrical short-circuiting", icon: "flame.fill", destination: .technique("fire-battery-steel-wool")),
                        TriageOption(id: "g261", label: "Create sparks or heat from batteries and wire", icon: "bandage.fill", destination: .technique("fire-fire-from-battery")),
                        TriageOption(id: "g262", label: "Ignite tinder using steel wool and a battery", icon: "flame.fill", destination: .technique("fire-steel-wool-battery"))
                    ])
                )),
                TriageOption(id: "g263", label: "Obtain", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g263-q", question: "Select:", options: [
                        TriageOption(id: "g264", label: "Striking sparks using carbon steel on sharp flint", icon: "figure.stand", destination: .technique("fire-flint-steel-traditional")),
                        TriageOption(id: "g265", label: "Ancient fire-making using high-carbon steel", icon: "flame.fill", destination: .technique("fire-flint-and-steel"))
                    ])
                )),
                TriageOption(id: "g266", label: "Ignition", icon: "flame.fill", destination: .nextQuestion(
                    TriageNode(id: "g266-q", question: "Select:", options: [
                        TriageOption(id: "g267", label: "Finding resin-saturated ignition material", icon: "ant.fill", destination: .technique("fire-fatwood-harvesting")),
                        TriageOption(id: "g268", label: "Pneumatic compression fire starting", icon: "flame.fill", destination: .technique("fire-fire-piston")),
                        TriageOption(id: "g269", label: "The ultimate natural waterproof tinder.", icon: "flame.fill", destination: .technique("fire-fire-birch-bark-prep"))
                    ])
                )),
                TriageOption(id: "g270", label: "Select", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g270-q", question: "Select:", options: [
                        TriageOption(id: "g271", label: "Creating massive surface area on wet wood.", icon: "cloud.rain.fill", destination: .technique("fire-fire-feather-stick")),
                        TriageOption(id: "g272", label: "Friction fire without a spindle or bow", icon: "flame.fill", destination: .technique("fire-fire-plow-technique"))
                    ])
                )),
                TriageOption(id: "g273", label: "Cotton", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g273-q", question: "Select:", options: [
                        TriageOption(id: "g274", label: "Manufacturing optimal tinder from cotton", icon: "flame.fill", destination: .technique("fire-char-cloth-production")),
                        TriageOption(id: "g275", label: "Maximizing sparks from ferrocerium rods", icon: "bolt.fill", destination: .technique("fire-ferro-rod-technique"))
                    ])
                ))
                ])
            )),

            TriageOption(id: "g276", label: "Tinder & Fuel", icon: "flame.fill", destination: .nextQuestion(
                TriageNode(id: "g276-q", question: "What specifically?", options: [
                TriageOption(id: "g277", label: "Natural", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g277-q", question: "Select:", options: [
                        TriageOption(id: "g278", label: "Converting cotton into the ultimate spark-catcher", icon: "bolt.fill", destination: .technique("fire-char-cloth")),
                        TriageOption(id: "g279", label: "Harvest natural fire-starting adhesive from conifers", icon: "flame.fill", destination: .technique("fire-resin-collection"))
                    ])
                )),
                TriageOption(id: "g280", label: "Squares", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g280-q", question: "Select:", options: [
                        TriageOption(id: "g281", label: "Create the best spark-catching material from cotton", icon: "bolt.fill", destination: .technique("fire-char-cloth-making")),
                        TriageOption(id: "g282", label: "Create charred tinder for spark-catching", icon: "bolt.fill", destination: .technique("fire-char-material"))
                    ])
                )),
                TriageOption(id: "g283", label: "Wood", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g283-q", question: "Select:", options: [
                        TriageOption(id: "g284", label: "Nature's firestarter — resin-saturated wood that lights", icon: "ant.fill", destination: .technique("fire-fatwood-finding")),
                        TriageOption(id: "g285", label: "Extract dry fuel from wet wood", icon: "cross.case.fill", destination: .technique("fire-wet-wood-processing"))
                    ])
                )),
                TriageOption(id: "g286", label: "Even", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g286-q", question: "Select:", options: [
                        TriageOption(id: "g287", label: "Nature's best fire starter — burns even when wet", icon: "flame.fill", destination: .technique("fire-birch-bark-fire")),
                        TriageOption(id: "g288", label: "Maximize birch bark as fire-starting material", icon: "flame.fill", destination: .technique("fire-birch-bark-uses"))
                    ])
                )),
                TriageOption(id: "g289", label: "Best", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g289-q", question: "Select:", options: [
                        TriageOption(id: "g290", label: "Know the best tinders for every environment", icon: "flame.fill", destination: .technique("fire-tinder-collection"))
                    ])
                ))
                ])
            )),
        ])
    }

}
