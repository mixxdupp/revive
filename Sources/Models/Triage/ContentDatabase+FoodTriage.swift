import Foundation

// Auto-generated: buildFoodTriage extracted from ContentDatabase.swift
extension ContentDatabase {
    // =========================================================================
    // MARK: - NEED FOOD (5 levels deep)
    // =========================================================================
    func buildFoodTriage() -> TriageNode {
        TriageNode(id: "food-root", question: "What is your immediate situation?", options: [

            // --- STARVATION RISK ---
            TriageOption(id: "food-starve", label: "No Food for Days / Starving", icon: "exclamationmark.triangle.fill", destination: .nextQuestion(
                TriageNode(id: "food-starve-q", question: "How long without food?", options: [
                    TriageOption(id: "food-days-3", label: "1-3 Days", icon: "clock", destination: .nextQuestion(
                        TriageNode(id: "food-days3-q", question: "What can you do right now?", options: [
                            TriageOption(id: "food-3d-forage", label: "Forage for Anything Safe", icon: "leaf.fill", destination: .techniqueList(["food-dandelion", "food-cattail", "food-insect-eating"])),
                            TriageOption(id: "food-3d-trap", label: "Set Traps / Snares", icon: "circle", destination: .techniqueList(["food-snare", "food-deadfall-trap", "food-fish-trap"])),
                        ])
                    )),
                    TriageOption(id: "food-days-7", label: "4-7+ Days", icon: "clock.fill", destination: .nextQuestion(
                        TriageNode(id: "food-days7-q", question: "How are you feeling?", options: [
                            TriageOption(id: "food-7d-weak", label: "Weak but Mobile", icon: "figure.walk", destination: .nextQuestion(
                                TriageNode(id: "food-7d-weak-q", question: "Best energy source?", options: [
                                    TriageOption(id: "food-7d-broth", label: "Bone Broth (If Animal Parts)", icon: "drop.fill", destination: .technique("food-bone-broth")),
                                    TriageOption(id: "food-7d-cache", label: "Protect Food (Cache)", icon: "archivebox.fill", destination: .technique("shelter-elevated-cache")), // Added orphan
                                    TriageOption(id: "food-7d-seaweed", label: "Near Coast — Seaweed", icon: "water.waves", destination: .technique("food-seaweed"))
                                ])
                            )),
                            TriageOption(id: "food-7d-immobile", label: "Can Barely Move", icon: "bed.double.fill", destination: .techniqueList(["food-rationing", "psych-pain-management"])),
                            TriageOption(id: "food-7d-confused", label: "Confused / Dizzy", icon: "brain.head.profile", destination: .techniqueList(["food-rationing", "water-rationing", "psych-box-breathing"]))
                        ])
                    )),
                    TriageOption(id: "food-ration", label: "Have Small Amount Left", icon: "bag.fill", destination: .nextQuestion(
                        TriageNode(id: "food-ration-q", question: "How much food do you have?", options: [
                            TriageOption(id: "food-ration-supplement", label: "Need to Supplement", icon: "leaf.fill", destination: .techniqueList(["food-insect-eating", "food-dandelion", "food-cattail"]))
                        ])
                    ))
                ])
            )),

            // --- FORAGING ---
            TriageOption(id: "food-forage", label: "Foraging Plants / Fungi", icon: "leaf.fill", destination: .nextQuestion(
                TriageNode(id: "food-forage-type", question: "What's available?", options: [
                    TriageOption(id: "food-berries", label: "Berries / Fruit", icon: "leaf.fill", destination: .nextQuestion(
                        TriageNode(id: "food-berry-know", question: "Do you recognize it?", options: [
                            TriageOption(id: "food-berry-yes", label: "Yes — 100% Sure", icon: "checkmark.seal.fill", destination: .technique("food-wild-fruit")),
                            TriageOption(id: "food-berry-no", label: "No / Unsure", icon: "questionmark.circle", destination: .technique("food-universal-edibility")),
                            TriageOption(id: "food-poison-symp", label: "Poisoning Symptoms?", icon: "exclamationmark.triangle.fill", destination: .article("food-article-plant-poisoning")) // Added orphan
                        ])
                    )),
                    TriageOption(id: "food-mushrooms", label: "Mushrooms", icon: "umbrella.fill", destination: .nextQuestion(
                        TriageNode(id: "food-shroom-safety", question: "Are you an expert?", options: [
                            TriageOption(id: "food-shroom-expert", label: "Yes — 100% Sure", icon: "checkmark.seal.fill", destination: .technique("food-mushroom-safety")),
                            TriageOption(id: "food-shroom-no", label: "No / Unsure", icon: "exclamationmark.triangle.fill", destination: .technique("food-avoid-plants"))
                        ])
                    )),
                    TriageOption(id: "food-greens", label: "Greens / Leaves (Wild Garlic, etc)", icon: "leaf.arrow.circle.path", destination: .techniqueList(["food-dandelion", "food-wild-garlic"])), // Added orphan
                    TriageOption(id: "food-nuts", label: "Nuts / Acorns", icon: "circle.grid.cross.fill", destination: .technique("food-acorn-processing")),
                ])
            )),

            // --- HUNTING / TRAPPING ---
            TriageOption(id: "food-hunt", label: "Hunting & Trapping", icon: "hare.fill", destination: .nextQuestion(
                TriageNode(id: "food-hunt-method", question: "What method?", options: [
                    TriageOption(id: "food-trap-trigger", label: "Active Triggers (Deadfall)", icon: "triangle.fill", destination: .techniqueList(["food-deadfall-trap", "tools-figure4-deadfall"])), // Added orphan
                    TriageOption(id: "food-spear", label: "Spear Hunting", icon: "pencil.line", destination: .technique("food-fish-spear")),
                    TriageOption(id: "food-bird", label: "Bird Trap (Ojibwa)", icon: "bird.fill", destination: .techniqueList(["food-bird-trap", "food-bird-snare"])), // Added orphan
                ])
            )),

            // --- FISHING ---
            TriageOption(id: "food-fish", label: "Fishing", icon: "fish.fill", destination: .nextQuestion(
                TriageNode(id: "food-fish-q", question: "What gear do you have?", options: [
                    TriageOption(id: "food-fish-hook", label: "Hooks / Line", icon: "pencil.slash", destination: .technique("food-hook-line")),
                    TriageOption(id: "food-crayfish-trap", label: "Crayfish / Crawdad Trap", icon: "circle.grid.cross.fill", destination: .technique("food-crayfish-trap")), // Added orphan
                ])
            )),

            // --- PREPARATION ---
            TriageOption(id: "food-prep", label: "Cooking / Preparation", icon: "flame", destination: .nextQuestion(
                TriageNode(id: "food-prep-q", question: "What do you need to do?", options: [
                    TriageOption(id: "food-pemmican", label: "Make Pemmican (Preserve)", icon: "archivebox.fill", destination: .technique("food-pemmican-making")), // Added orphan
                    TriageOption(id: "food-cooking-rocks", label: "Boil Using Hot Rocks", icon: "drop.fill", destination: .technique("food-boiling-rocks")), // Added orphan
                    TriageOption(id: "food-clean-game", label: "Skin / Gut Small Game", icon: "hare.fill", destination: .nextQuestion(
                        TriageNode(id: "food-clean-game-q", question: "What type of game?", options: [
                            TriageOption(id: "food-clean-game-gen", label: "General Cleaning", icon: "hare.fill", destination: .technique("food-small-game-cleaning")), // Added orphan
                            TriageOption(id: "food-clean-small", label: "Small (Rabbit, Squirrel)", icon: "hare.fill", destination: .technique("food-animal-skinning")),
                            TriageOption(id: "food-clean-fish", label: "Fish", icon: "fish.fill", destination: .technique("food-cooking-fire"))
                        ])
                    )),
                    TriageOption(id: "food-cook-fire", label: "Cook on Fire", icon: "flame", destination: .nextQuestion(
                        TriageNode(id: "food-cook-method", question: "Best method for your food?", options: [
                            TriageOption(id: "food-cook-boil", label: "Boil in Container", icon: "drop.fill", destination: .techniqueList(["food-bone-broth", "food-pine-needle-tea"])), // Added orphan
                            TriageOption(id: "food-cook-earth", label: "Underground (Earth Oven)", icon: "circle.fill", destination: .technique("food-earth-oven")),
                        ])
                    )),
                    TriageOption(id: "food-preserve", label: "Preserve for Later", icon: "clock.fill", destination: .nextQuestion(
                        TriageNode(id: "food-preserve-q", question: "How do you want to preserve?", options: [
                            TriageOption(id: "food-preserve-smoke", label: "Smoke It", icon: "smoke.fill", destination: .technique("food-smoking-meat")),
                            TriageOption(id: "food-preserve-jerk", label: "Sun Dry / Jerky", icon: "sun.max.fill", destination: .technique("food-jerky-no-salt")),
                            TriageOption(id: "food-preserve-pemm", label: "Pemmican (Long-Term)", icon: "bag.fill", destination: .technique("food-pemmican")),
                            TriageOption(id: "food-preserve-gen", label: "General Preservation", icon: "archivebox.fill", destination: .technique("food-preservation"))
                        ])
                    ))
                ])
            )),

            // Advanced Foraging
            TriageOption(id: "food-adv-forage", label: "Advanced Foraging", icon: "leaf.circle.fill", destination: .nextQuestion(
                TriageNode(id: "food-adv-q", question: "What's available?", options: [
                    TriageOption(id: "food-wild-onion", label: "Wild Onion / Garlic", icon: "leaf.fill", destination: .technique("food-wild-onion")),
                    TriageOption(id: "food-pine-flour", label: "Pine Bark Flour", icon: "tree.fill", destination: .technique("food-pine-bark-flour")),
                    TriageOption(id: "food-cattail-adv", label: "Cattail (Full Harvest)", icon: "leaf.fill", destination: .technique("food-cattail-harvest")),
                    TriageOption(id: "food-seaweed-adv", label: "Seaweed (Coastal)", icon: "water.waves", destination: .technique("food-seaweed-harvesting")),
                    TriageOption(id: "food-grub", label: "Grubs / Larvae", icon: "ladybug.fill", destination: .technique("food-grub-finding"))
                ])
            )),

            // Advanced Trapping & Fishing
            TriageOption(id: "food-adv-trap", label: "Advanced Trapping & Fishing", icon: "target", destination: .nextQuestion(
                TriageNode(id: "food-adv-trap-q", question: "What method?", options: [
                    TriageOption(id: "food-ojibwe", label: "Ojibwe Bird Snare", icon: "bird.fill", destination: .technique("food-bird-snare-ojibwe")),
                    TriageOption(id: "food-crayfish-adv", label: "Crayfish Trapping", icon: "fish.fill", destination: .techniqueList(["food-crayfish", "food-crayfish-trapping"])),
                    TriageOption(id: "food-spear-fish", label: "Fish Spearing", icon: "arrow.down", destination: .technique("food-fish-spearing")),
                    TriageOption(id: "food-clay-cooking", label: "Clay Pot Cooking", icon: "cylinder.fill", destination: .technique("food-clay-pot-cooking"))
                ])
            )),

            // 📚 LEARN MORE
            TriageOption(id: "food-learn", label: "Learn More", icon: "book.fill", destination: .nextQuestion(
                TriageNode(id: "food-learn-q", question: "What would you like to read about?", options: [
                    TriageOption(id: "food-art-nutrition", label: "Survival Nutrition", icon: "leaf.fill", destination: .article("food-article-nutrition")),
                    TriageOption(id: "food-art-calories", label: "Calorie Needs", icon: "gauge.with.dots.needle.67percent", destination: .article("food-article-calories")),
                    TriageOption(id: "food-art-starvation", label: "Starvation Science", icon: "exclamationmark.triangle.fill", destination: .article("food-article-starvation")),
                    TriageOption(id: "food-art-deficiency", label: "Nutritional Deficiencies", icon: "pills.fill", destination: .article("food-article-deficiencies")),
                    TriageOption(id: "food-art-plants", label: "Wild Edible Plants", icon: "leaf.arrow.circlepath", destination: .article("food-article-wild-plants")),
                    TriageOption(id: "food-art-poisonous", label: "Poisonous Plants", icon: "xmark.octagon.fill", destination: .articleList(["food-article-poisonous", "food-article-plant-poisoning"])),
                    TriageOption(id: "food-art-insects", label: "Edible Insects", icon: "ant.fill", destination: .article("food-article-insects")),
                    TriageOption(id: "food-art-protein", label: "Protein Sources (Ranked)", icon: "scalemass.fill", destination: .article("food-article-protein-hierarchy")),
                    TriageOption(id: "food-art-fishing", label: "Fishing Techniques", icon: "fish.fill", destination: .article("food-article-fishing")),
                    TriageOption(id: "food-art-trapping", label: "Trapping Guide", icon: "hare.fill", destination: .article("food-article-trapping")),
                    TriageOption(id: "food-art-cooking", label: "Cooking Methods", icon: "frying.pan.fill", destination: .article("food-article-cooking-methods")),
                    TriageOption(id: "food-art-preservation", label: "Food Preservation", icon: "snowflake", destination: .articleList(["food-article-preservation", "food-article-long-preservation"])),
                    TriageOption(id: "food-art-safety", label: "Food Safety", icon: "checkmark.shield.fill", destination: .article("food-article-safety"))
                ])
            )),

            TriageOption(id: "g291", label: "Cooking", icon: "flame.fill", destination: .nextQuestion(
                TriageNode(id: "g291-q", question: "What specifically?", options: [
                TriageOption(id: "g292", label: "Oven", icon: "flame.fill", destination: .nextQuestion(
                    TriageNode(id: "g292-q", question: "Select:", options: [
                        TriageOption(id: "g293", label: "Underground pit cooking for large quantities", icon: "flame.fill", destination: .technique("food-earth-oven-cooking")),
                        TriageOption(id: "g294", label: "Build a stone oven for baking and cooking", icon: "flame.fill", destination: .technique("food-hot-stone-oven")),
                        TriageOption(id: "g295", label: "Building an oven from reflective material for campfire ", icon: "flame.fill", destination: .technique("food-reflector-oven")),
                        TriageOption(id: "g296", label: "Pit-cooking large meals using fire-heated stones", icon: "flame.fill", destination: .technique("food-rock-oven"))
                    ])
                )),
                TriageOption(id: "g297", label: "Fire", icon: "flame.fill", destination: .nextQuestion(
                    TriageNode(id: "g297-q", question: "Select:", options: [
                        TriageOption(id: "g298", label: "Cook directly in coals — simplest cooking method", icon: "ant.fill", destination: .technique("food-ash-roasting")),
                        TriageOption(id: "g299", label: "Roasting meat on a rotating horizontal spit over fire", icon: "ant.fill", destination: .technique("food-spit-roasting")),
                        TriageOption(id: "g300", label: "Building an adjustable fire-suspended cooking system", icon: "flame.fill", destination: .technique("food-tripod-cooking"))
                    ])
                )),
                TriageOption(id: "g301", label: "Rock", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g301-q", question: "Select:", options: [
                        TriageOption(id: "g302", label: "Remove bitter tannins from acorns for eating", icon: "ant.fill", destination: .technique("food-acorn-leaching-methods")),
                        TriageOption(id: "g303", label: "Boil water and cook food without a fireproof container", icon: "flame.fill", destination: .technique("food-rock-boiling-cooking"))
                    ])
                )),
                TriageOption(id: "g304", label: "Water", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g304-q", question: "Select:", options: [
                        TriageOption(id: "g305", label: "Process grains with wood ash for better nutrition", icon: "cloud.rain.fill", destination: .technique("food-ash-caking")),
                        TriageOption(id: "g306", label: "Obtain salt from natural sources", icon: "water.waves", destination: .technique("food-salt-extraction"))
                    ])
                )),
                TriageOption(id: "g307", label: "Feet", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g307-q", question: "Select:", options: [
                        TriageOption(id: "g308", label: "Build a grill grate from green wood", icon: "cross.case.fill", destination: .technique("food-primitive-grill")),
                        TriageOption(id: "g309", label: "Slow-cook large quantities of food with no pots", icon: "ant.fill", destination: .technique("food-pit-roasting"))
                    ])
                )),
                TriageOption(id: "g310", label: "Cooking", icon: "flame.fill", destination: .nextQuestion(
                    TriageNode(id: "g310-q", question: "Select:", options: [
                        TriageOption(id: "g311", label: "Extract fat from bones for cooking and calories", icon: "bandage.fill", destination: .technique("food-bone-grease")),
                        TriageOption(id: "g312", label: "Render clean cooking fat from animal carcasses", icon: "flame.fill", destination: .technique("food-fat-rendering-techniques")),
                        TriageOption(id: "g313", label: "Make flour from wild sources for bread and thickener", icon: "star.fill", destination: .technique("food-improvised-flour")),
                        TriageOption(id: "g314", label: "Skin, gut, and prepare a rabbit for cooking", icon: "flame.fill", destination: .technique("food-rabbit-processing"))
                    ])
                ))
                ])
            )),

            TriageOption(id: "g315", label: "Edible Plants", icon: "leaf.fill", destination: .nextQuestion(
                TriageNode(id: "g315-q", question: "What specifically?", options: [
                TriageOption(id: "g316", label: "Through", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g316-q", question: "Select:", options: [
                        TriageOption(id: "g317", label: "Distinctive round leaf with the stem growing straight t", icon: "cross.case.fill", destination: .technique("food-botany-miners-lettuce")),
                        TriageOption(id: "g318", label: "Eat the inner bark of pine trees", icon: "cross.case.fill", destination: .technique("food-pine-cambium")),
                        TriageOption(id: "g319", label: "Vitamin C powerhouse — available through winter", icon: "cross.case.fill", destination: .technique("food-rose-hip-harvest")),
                        TriageOption(id: "g320", label: "Brew vitamin C-rich tea from wild roses", icon: "cross.case.fill", destination: .technique("food-rose-hip-tea")),
                        TriageOption(id: "g321", label: "Ultra-sweet fruit available through early winter", icon: "cross.case.fill", destination: .technique("food-persimmon-harvest"))
                    ])
                )),
                TriageOption(id: "g322", label: "Inner", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g322-q", question: "Select:", options: [
                        TriageOption(id: "g323", label: "Harvesting the inner core of the ultimate survival plan", icon: "ant.fill", destination: .technique("food-cattail-spring-shoots")),
                        TriageOption(id: "g324", label: "Emergency winter starvation calories", icon: "ant.fill", destination: .technique("food-cambium-harvest")),
                        TriageOption(id: "g325", label: "Harvesting survival calories from trees", icon: "ant.fill", destination: .technique("food-plant-pine-cambium")),
                        TriageOption(id: "g326", label: "Making flour from inner bark of pine and birch", icon: "cross.case.fill", destination: .technique("food-bark-bread"))
                    ])
                )),
                TriageOption(id: "g327", label: "Leaflets", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g327-q", question: "Select:", options: [
                        TriageOption(id: "g328", label: "Powerful-flavored nut requiring hull removal", icon: "cross.case.fill", destination: .technique("food-black-walnut")),
                        TriageOption(id: "g329", label: "Identify and eat common clover species", icon: "cross.case.fill", destination: .technique("food-clover-identification")),
                        TriageOption(id: "g330", label: "High-calorie nut available across eastern forests", icon: "cross.case.fill", destination: .technique("food-hickory-nut")),
                        TriageOption(id: "g331", label: "Common lawn plant — entirely edible and nutritious", icon: "leaf.fill", destination: .technique("food-clover-foraging")),
                        TriageOption(id: "g332", label: "Tangy lemony green — thirst-quenching and vitamin-rich", icon: "heart.fill", destination: .technique("food-wood-sorrel"))
                    ])
                )),
                TriageOption(id: "g333", label: "Rich", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g333-q", question: "Select:", options: [
                        TriageOption(id: "g334", label: "Water, meat, oil, fiber, shell — the ultimate tropical ", icon: "leaf.fill", destination: .technique("food-coconut-complete")),
                        TriageOption(id: "g335", label: "Highly nutritious greens protected by formic acid", icon: "ant.fill", destination: .technique("food-stinging-nettle-prep")),
                        TriageOption(id: "g336", label: "Tap trees for drinkable, calorie-rich sap", icon: "drop.fill", destination: .technique("food-sap-collection"))
                    ])
                )),
                TriageOption(id: "g337", label: "Safety", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g337-q", question: "Select:", options: [
                        TriageOption(id: "g338", label: "Using coconuts correctly for hydration and calories", icon: "cross.case.fill", destination: .technique("food-coconut-water-safety")),
                        TriageOption(id: "g339", label: "Critical rules for wild mushroom foraging", icon: "leaf.fill", destination: .technique("food-mushroom-rules")),
                        TriageOption(id: "g340", label: "Systematically test unknown plants for safety — last re", icon: "leaf.fill", destination: .technique("food-universal-edibility-test")),
                        TriageOption(id: "g341", label: "Quick ID framework for safe berry foraging", icon: "exclamationmark.triangle.fill", destination: .technique("food-wild-berry-safety")),
                        TriageOption(id: "g342", label: "Critical rules before foraging ANY mushroom", icon: "leaf.fill", destination: .technique("food-mushroom-safety-rules"))
                    ])
                )),
                TriageOption(id: "g343", label: "Wild", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g343-q", question: "Select:", options: [
                        TriageOption(id: "g344", label: "Identify and eat edible seaweed species", icon: "leaf.fill", destination: .technique("food-seaweed-foraging")),
                        TriageOption(id: "g345", label: "Safely harvest and cook highly nutritious wild nettles", icon: "ant.fill", destination: .technique("food-nettle-harvest")),
                        TriageOption(id: "g346", label: "Identify and eat this common weed", icon: "leaf.fill", destination: .technique("food-plantain-wild")),
                        TriageOption(id: "g347", label: "Identify and harvest wild rice from waterways", icon: "cloud.rain.fill", destination: .technique("food-wild-rice-harvest")),
                        TriageOption(id: "g348", label: "Identify and harvest edible wild root vegetables", icon: "leaf.fill", destination: .technique("food-wild-yam-potato"))
                    ])
                )),
                TriageOption(id: "g349", label: "Identify", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g349-q", question: "Select:", options: [
                        TriageOption(id: "g350", label: "A tall weed yielding massive amounts of edible grain se", icon: "cloud.rain.fill", destination: .technique("food-botany-amaranth")),
                        TriageOption(id: "g351", label: "Found along fencelines and ditches in spring. Exact sam", icon: "drop.fill", destination: .technique("food-botany-asparagus-wild")),
                        TriageOption(id: "g352", label: "A ubiquitous edible and medicinal weed", icon: "leaf.fill", destination: .technique("food-plantain-weed")),
                        TriageOption(id: "g353", label: "Harvesting 'the supermarket of the swamp'", icon: "ant.fill", destination: .technique("food-cattail-tubers")),
                        TriageOption(id: "g354", label: "Identify and harvest a highly nutritious succulent weed", icon: "cloud.rain.fill", destination: .technique("food-purslane-foraging"))
                    ])
                )),
                TriageOption(id: "g355", label: "Edible", icon: "leaf.fill", destination: .nextQuestion(
                    TriageNode(id: "g355-q", question: "Select:", options: [
                        TriageOption(id: "g356", label: "First-year plants yield a massive, starchy taproot that", icon: "leaf.fill", destination: .technique("food-botany-burdock")),
                        TriageOption(id: "g357", label: "Tiny white star flowers. Entire plant is edible raw and", icon: "leaf.fill", destination: .technique("food-botany-chickweed")),
                        TriageOption(id: "g358", label: "Blue flowers. Young leaves are edible; roasted roots ar", icon: "leaf.fill", destination: .technique("food-botany-chicory")),
                        TriageOption(id: "g359", label: "Invasive weed; smells heavily of garlic. Highly nutriti", icon: "flame.fill", destination: .technique("food-botany-garlic-mustard")),
                        TriageOption(id: "g360", label: "Tall sunflower-like plant with massive, highly caloric ", icon: "leaf.fill", destination: .technique("food-botany-jerusalem-artichoke"))
                    ])
                )),
                TriageOption(id: "g361", label: "Leaves", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g361-q", question: "Select:", options: [
                        TriageOption(id: "g362", label: "Goosefoot-shaped leaves with white powdery undersides. ", icon: "cross.case.fill", destination: .technique("food-botany-lambsquarters")),
                        TriageOption(id: "g363", label: "Round, pie-shaped leaves. Produces tiny 'cheese wheel' ", icon: "cross.case.fill", destination: .technique("food-botany-mallow")),
                        TriageOption(id: "g364", label: "Yellow four-petaled flowers. Young leaves are spicy and", icon: "leaf.fill", destination: .technique("food-botany-mustard-wild")),
                        TriageOption(id: "g365", label: "Smells strongly of onion. Ensure it smells like onion t", icon: "cross.case.fill", destination: .technique("food-botany-onion-wild")),
                        TriageOption(id: "g366", label: "Flat, circular seed pods. Leaves are edible raw but pep", icon: "leaf.fill", destination: .technique("food-botany-pennycress"))
                    ])
                )),
                TriageOption(id: "g367", label: "Leaves (2)", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g367-q", question: "Select:", options: [
                        TriageOption(id: "g368", label: "Similar to Amaranth. Stems often have a red tint. Edibl", icon: "leaf.fill", destination: .technique("food-botany-pigweed")),
                        TriageOption(id: "g369", label: "Heart-shaped flat seed pods. Peppery edible leaves.", icon: "heart.fill", destination: .technique("food-botany-shepherds-purse")),
                        TriageOption(id: "g370", label: "Looks exactly like clover but has heart-shaped leaves a", icon: "heart.fill", destination: .technique("food-botany-sorrel-wood")),
                        TriageOption(id: "g371", label: "Looks like a dandelion but grows tall on a stalk. Young", icon: "flame.fill", destination: .technique("food-botany-sow-thistle")),
                        TriageOption(id: "g372", label: "Grows in cold, running water. Peppery leaves. MUST be p", icon: "cross.case.fill", destination: .technique("food-botany-watercress"))
                    ])
                )),
                TriageOption(id: "g373", label: "Flowers", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g373-q", question: "Select:", options: [
                        TriageOption(id: "g374", label: "Beautiful tubular bell flowers. Contains digitalis; cau", icon: "heart.fill", destination: .technique("food-botany-foxglove")),
                        TriageOption(id: "g375", label: "Large trumpet flowers, spiky seed pods. Hallucinogenic ", icon: "cross.case.fill", destination: .technique("food-botany-jimsonweed")),
                        TriageOption(id: "g376", label: "Purple hooded flowers. Contact with sap alone can cause", icon: "heart.fill", destination: .technique("food-botany-monkshood")),
                        TriageOption(id: "g377", label: "Glossy dark green leaves. Edible in early spring before", icon: "drop.fill", destination: .technique("food-botany-wintercress")),
                        TriageOption(id: "g378", label: "Feathery leaves, flat white flower heads. Famous medici", icon: "drop.fill", destination: .technique("food-botany-yarrow"))
                    ])
                )),
                TriageOption(id: "g379", label: "Dandelion", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g379-q", question: "Select:", options: [
                        TriageOption(id: "g380", label: "Removing tannins without fire", icon: "flame.fill", destination: .technique("food-acorn-cold-leaching")),
                        TriageOption(id: "g381", label: "Using every part of the cattail plant", icon: "ant.fill", destination: .technique("food-cattail-multi-use")),
                        TriageOption(id: "g382", label: "Every part of the dandelion is edible — leaves, roots, ", icon: "mouth.fill", destination: .technique("food-dandelion-full")),
                        TriageOption(id: "g383", label: "Extracting the edible growing tip from palm trees", icon: "ant.fill", destination: .technique("food-palm-heart")),
                        TriageOption(id: "g384", label: "Safe common edible wild plants", icon: "leaf.fill", destination: .technique("food-wild-greens-salad"))
                    ])
                )),
                TriageOption(id: "g385", label: "Plant", icon: "leaf.fill", destination: .nextQuestion(
                    TriageNode(id: "g385-q", question: "Select:", options: [
                        TriageOption(id: "g386", label: "Nutritious root vegetable — common worldwide weed", icon: "cross.case.fill", destination: .technique("food-burdock-root")),
                        TriageOption(id: "g387", label: "Caffeine-free hot drink from a common roadside plant", icon: "mouth.fill", destination: .technique("food-chicory")),
                        TriageOption(id: "g388", label: "Most nutritious wild green — better than store spinach", icon: "cross.case.fill", destination: .technique("food-lambs-quarters")),
                        TriageOption(id: "g389", label: "8-hour systematic testing protocol", icon: "ant.fill", destination: .technique("food-universal-edibility-test-full")),
                        TriageOption(id: "g390", label: "The deadliest plant in North America", icon: "leaf.fill", destination: .technique("food-water-hemlock-warning"))
                    ])
                )),
                TriageOption(id: "g391", label: "Identify (2)", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g391-q", question: "Select:", options: [
                        TriageOption(id: "g392", label: "Abundant tropical/subtropical food source", icon: "ant.fill", destination: .technique("food-bamboo-shoots")),
                        TriageOption(id: "g393", label: "Every part edible — leaves, roots, and flowers", icon: "mouth.fill", destination: .technique("food-dandelion-uses")),
                        TriageOption(id: "g394", label: "High-calorie tuber — no planting required", icon: "leaf.fill", destination: .technique("food-jerusalem-artichoke")),
                        TriageOption(id: "g395", label: "Tropical-tasting fruit native to eastern North America", icon: "ant.fill", destination: .technique("food-pawpaw")),
                        TriageOption(id: "g396", label: "Sweet fruit plus leaves are edible", icon: "heart.fill", destination: .technique("food-wild-grape"))
                    ])
                )),
                TriageOption(id: "g397", label: "Pine", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g397-q", question: "Select:", options: [
                        TriageOption(id: "g398", label: "Cooked agave heart is sweet and calorie-dense", icon: "ant.fill", destination: .technique("food-agave-heart")),
                        TriageOption(id: "g399", label: "Desert food and water source", icon: "flame.fill", destination: .technique("food-cactus-eating")),
                        TriageOption(id: "g400", label: "Tap maple trees for sugar water and boil to syrup", icon: "location.north.fill", destination: .technique("food-maple-syrup-field")),
                        TriageOption(id: "g401", label: "High-calorie seed from specific pine species", icon: "ant.fill", destination: .technique("food-pine-nut-harvest")),
                        TriageOption(id: "g402", label: "Aquatic grain — high calorie, grows in shallow lakes", icon: "ant.fill", destination: .technique("food-wild-rice"))
                    ])
                )),
                TriageOption(id: "g403", label: "Root", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g403-q", question: "Select:", options: [
                        TriageOption(id: "g404", label: "Emergency water from the desert's water tank", icon: "figure.stand", destination: .technique("food-barrel-cactus-water")),
                        TriageOption(id: "g405", label: "High-protein flour from desert tree pods", icon: "sun.max.fill", destination: .technique("food-mesquite-pod")),
                        TriageOption(id: "g406", label: "Preserve cactus fruit for weeks", icon: "flame.fill", destination: .technique("food-prickly-pear-jelly")),
                        TriageOption(id: "g407", label: "Aromatic tea and flavoring from a common forest tree", icon: "cross.case.fill", destination: .technique("food-sassafras-tea")),
                        TriageOption(id: "g408", label: "Starchy root vegetable of the desert", icon: "star.fill", destination: .technique("food-yucca-root"))
                    ])
                )),
                TriageOption(id: "g409", label: "Harvest", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g409-q", question: "Select:", options: [
                        TriageOption(id: "g410", label: "Starchy staple that feeds millions — cook like potato", icon: "flame.fill", destination: .technique("food-breadfruit-cooking")),
                        TriageOption(id: "g411", label: "Medicinal and nutritious berry — MUST be cooked", icon: "leaf.fill", destination: .technique("food-elderberry-harvest")),
                        TriageOption(id: "g412", label: "Wild allspice — aromatic seasoning for survival food", icon: "leaf.fill", destination: .technique("food-spicebush-berry")),
                        TriageOption(id: "g413", label: "Tart, refreshing wild drink from red sumac berries", icon: "leaf.fill", destination: .technique("food-sumac-lemonade")),
                        TriageOption(id: "g414", label: "Tropical staple — MUST be cooked to remove toxins", icon: "flame.fill", destination: .technique("food-taro-preparation"))
                    ])
                )),
                TriageOption(id: "g415", label: "Plant (2)", icon: "leaf.fill", destination: .nextQuestion(
                    TriageNode(id: "g415-q", question: "Select:", options: [
                        TriageOption(id: "g416", label: "More than just fruit — the entire plant is useful", icon: "leaf.fill", destination: .technique("food-banana-plant-uses")),
                        TriageOption(id: "g417", label: "Arctic golden raspberry — prized among the world's most", icon: "leaf.fill", destination: .technique("food-cloudberry")),
                        TriageOption(id: "g418", label: "Abundant black berry of northern tundra and boreal fore", icon: "scissors", destination: .technique("food-crowberry")),
                        TriageOption(id: "g419", label: "Warming tea from subarctic shrub — energy and morale bo", icon: "heart.fill", destination: .technique("food-labrador-tea")),
                        TriageOption(id: "g420", label: "Tap palm for sweet sap — tropical equivalent of maple s", icon: "scope", destination: .technique("food-nipa-palm-sugar"))
                    ])
                )),
                TriageOption(id: "g421", label: "Identify (3)", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g421-q", question: "Select:", options: [
                        TriageOption(id: "g422", label: "Identification and preparation of Amaranth.", icon: "leaf.fill", destination: .technique("food-plant-amaranth")),
                        TriageOption(id: "g423", label: "Sweet nutritious nut — must be cooked", icon: "ant.fill", destination: .technique("food-chestnut-roasting")),
                        TriageOption(id: "g424", label: "First plant to colonize burned areas — tender greens an", icon: "flame.fill", destination: .technique("food-fireweed-greens")),
                        TriageOption(id: "g425", label: "Emergency food found on rocks worldwide", icon: "cross.case.fill", destination: .technique("food-lichen-rock-tripe")),
                        TriageOption(id: "g426", label: "Anti-inflammatory root available in tropical regions", icon: "leaf.fill", destination: .technique("food-turmeric-root"))
                    ])
                )),
                TriageOption(id: "g427", label: "Identification", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g427-q", question: "Select:", options: [
                        TriageOption(id: "g428", label: "Identification and preparation of Arrowhead (Wapato).", icon: "leaf.fill", destination: .technique("food-plant-arrowhead")),
                        TriageOption(id: "g429", label: "Identification and preparation of Chicory.", icon: "leaf.fill", destination: .technique("food-plant-chicory")),
                        TriageOption(id: "g430", label: "Identification and preparation of Coltsfoot.", icon: "leaf.fill", destination: .technique("food-plant-coltsfoot")),
                        TriageOption(id: "g431", label: "Identification and preparation of Daylily.", icon: "leaf.fill", destination: .technique("food-plant-daylily")),
                        TriageOption(id: "g432", label: "Identification and preparation of Wild Asparagus.", icon: "leaf.fill", destination: .technique("food-plant-asparagus"))
                    ])
                )),
                TriageOption(id: "g433", label: "Identification (2)", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g433-q", question: "Select:", options: [
                        TriageOption(id: "g434", label: "Identification and preparation of Broadleaf Plantain.", icon: "leaf.fill", destination: .technique("food-plant-plantain-broadleaf")),
                        TriageOption(id: "g435", label: "Identification and preparation of Jerusalem Artichoke.", icon: "leaf.fill", destination: .technique("food-plant-jerusalem-artichoke")),
                        TriageOption(id: "g436", label: "Identification and preparation of Lamb's Quarters.", icon: "leaf.fill", destination: .technique("food-plant-lambs-quarters")),
                        TriageOption(id: "g437", label: "Identification and preparation of Miner's Lettuce.", icon: "leaf.fill", destination: .technique("food-plant-miner-lettuce")),
                        TriageOption(id: "g438", label: "Identification and preparation of Purslane.", icon: "leaf.fill", destination: .technique("food-plant-purslane"))
                    ])
                )),
                TriageOption(id: "g439", label: "Identification (3)", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g439-q", question: "Select:", options: [
                        TriageOption(id: "g440", label: "Identification and preparation of Evening Primrose.", icon: "leaf.fill", destination: .technique("food-plant-evening-primrose")),
                        TriageOption(id: "g441", label: "Identification and preparation of Watercress.", icon: "leaf.fill", destination: .technique("food-plant-watercress")),
                        TriageOption(id: "g442", label: "Identification and preparation of Wintercress.", icon: "leaf.fill", destination: .technique("food-plant-wintercress")),
                        TriageOption(id: "g443", label: "Identification and preparation of Wood Sorrel.", icon: "leaf.fill", destination: .technique("food-plant-sorrel-wood")),
                        TriageOption(id: "g444", label: "Identification and preparation of Yarrow.", icon: "leaf.fill", destination: .technique("food-plant-yarrow"))
                    ])
                )),
                TriageOption(id: "g445", label: "Identification (4)", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g445-q", question: "Select:", options: [
                        TriageOption(id: "g446", label: "Identification and preparation of Burdock.", icon: "leaf.fill", destination: .technique("food-plant-burdock")),
                        TriageOption(id: "g447", label: "Identification and preparation of Cattail Pollen.", icon: "leaf.fill", destination: .technique("food-plant-cattail-pollen")),
                        TriageOption(id: "g448", label: "Identification and preparation of Dandelion.", icon: "leaf.fill", destination: .technique("food-plant-dandelion")),
                        TriageOption(id: "g449", label: "Identification and preparation of Garlic Mustard.", icon: "leaf.fill", destination: .technique("food-plant-garlic-mustard")),
                        TriageOption(id: "g450", label: "Identification and preparation of Japanese Knotweed.", icon: "leaf.fill", destination: .technique("food-plant-knotweed-japanese"))
                    ])
                )),
                TriageOption(id: "g451", label: "Identification (5)", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g451-q", question: "Select:", options: [
                        TriageOption(id: "g452", label: "Identification and preparation of Black Walnut.", icon: "leaf.fill", destination: .technique("food-plant-walnut-black")),
                        TriageOption(id: "g453", label: "Foraging protocol for Blackberries/Raspberries species ", icon: "leaf.fill", destination: .technique("food-encyclopedia-rubus-eastern-woodlands")),
                        TriageOption(id: "g454", label: "Identification and preparation of Cattail Rhizome.", icon: "leaf.fill", destination: .technique("food-plant-cattail-root")),
                        TriageOption(id: "g455", label: "Identification and preparation of Red Oak Acorn.", icon: "leaf.fill", destination: .technique("food-plant-acorn-red")),
                        TriageOption(id: "g456", label: "Identification and preparation of White Oak Acorn.", icon: "leaf.fill", destination: .technique("food-plant-acorn-white"))
                    ])
                )),
                TriageOption(id: "g457", label: "Blackberries", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g457-q", question: "Select:", options: [
                        TriageOption(id: "g458", label: "Foraging protocol for Blackberries/Raspberries species ", icon: "leaf.fill", destination: .technique("food-encyclopedia-rubus-arid-deserts")),
                        TriageOption(id: "g459", label: "Foraging protocol for Blackberries/Raspberries species ", icon: "leaf.fill", destination: .technique("food-encyclopedia-rubus-northern-boreal")),
                        TriageOption(id: "g460", label: "Foraging protocol for Blackberries/Raspberries species ", icon: "leaf.fill", destination: .technique("food-encyclopedia-rubus-southern-swamps")),
                        TriageOption(id: "g461", label: "Foraging protocol for Blackberries/Raspberries species ", icon: "leaf.fill", destination: .technique("food-encyclopedia-rubus-western-mountains")),
                        TriageOption(id: "g462", label: "Foraging protocol for Blueberries/Cranberries species i", icon: "leaf.fill", destination: .technique("food-encyclopedia-vaccinium-eastern-woodlands"))
                    ])
                )),
                TriageOption(id: "g463", label: "Blueberries", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g463-q", question: "Select:", options: [
                        TriageOption(id: "g464", label: "Foraging protocol for Blueberries/Cranberries species i", icon: "leaf.fill", destination: .technique("food-encyclopedia-vaccinium-arid-deserts")),
                        TriageOption(id: "g465", label: "Foraging protocol for Blueberries/Cranberries species i", icon: "leaf.fill", destination: .technique("food-encyclopedia-vaccinium-northern-boreal")),
                        TriageOption(id: "g466", label: "Foraging protocol for Blueberries/Cranberries species i", icon: "leaf.fill", destination: .technique("food-encyclopedia-vaccinium-southern-swamps")),
                        TriageOption(id: "g467", label: "Foraging protocol for Blueberries/Cranberries species i", icon: "leaf.fill", destination: .technique("food-encyclopedia-vaccinium-western-mountains")),
                        TriageOption(id: "g468", label: "Foraging protocol for Wild Strawberry species in the Ea", icon: "leaf.fill", destination: .technique("food-encyclopedia-fragaria-eastern-woodlands"))
                    ])
                )),
                TriageOption(id: "g469", label: "Wild (2)", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g469-q", question: "Select:", options: [
                        TriageOption(id: "g470", label: "Foraging protocol for Wild Onion/Garlic species in the ", icon: "leaf.fill", destination: .technique("food-encyclopedia-allium-eastern-woodlands")),
                        TriageOption(id: "g471", label: "Foraging protocol for Wild Strawberry species in the Ar", icon: "leaf.fill", destination: .technique("food-encyclopedia-fragaria-arid-deserts")),
                        TriageOption(id: "g472", label: "Foraging protocol for Wild Strawberry species in the No", icon: "leaf.fill", destination: .technique("food-encyclopedia-fragaria-northern-boreal")),
                        TriageOption(id: "g473", label: "Foraging protocol for Wild Strawberry species in the So", icon: "leaf.fill", destination: .technique("food-encyclopedia-fragaria-southern-swamps")),
                        TriageOption(id: "g474", label: "Foraging protocol for Wild Strawberry species in the We", icon: "leaf.fill", destination: .technique("food-encyclopedia-fragaria-western-mountains"))
                    ])
                )),
                TriageOption(id: "g475", label: "Wild (3)", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g475-q", question: "Select:", options: [
                        TriageOption(id: "g476", label: "Foraging protocol for Wild Onion/Garlic species in the ", icon: "leaf.fill", destination: .technique("food-encyclopedia-allium-arid-deserts")),
                        TriageOption(id: "g477", label: "Foraging protocol for Wild Onion/Garlic species in the ", icon: "leaf.fill", destination: .technique("food-encyclopedia-allium-northern-boreal")),
                        TriageOption(id: "g478", label: "Foraging protocol for Wild Onion/Garlic species in the ", icon: "leaf.fill", destination: .technique("food-encyclopedia-allium-southern-swamps")),
                        TriageOption(id: "g479", label: "Foraging protocol for Wild Onion/Garlic species in the ", icon: "leaf.fill", destination: .technique("food-encyclopedia-allium-western-mountains")),
                        TriageOption(id: "g480", label: "Foraging protocol for Wild Rose species in the Eastern ", icon: "leaf.fill", destination: .technique("food-encyclopedia-rosa-eastern-woodlands"))
                    ])
                )),
                TriageOption(id: "g481", label: "Wild (4)", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g481-q", question: "Select:", options: [
                        TriageOption(id: "g482", label: "Foraging protocol for Wild Grape species in the Eastern", icon: "leaf.fill", destination: .technique("food-encyclopedia-vitis-eastern-woodlands")),
                        TriageOption(id: "g483", label: "Foraging protocol for Wild Rose species in the Arid Des", icon: "leaf.fill", destination: .technique("food-encyclopedia-rosa-arid-deserts")),
                        TriageOption(id: "g484", label: "Foraging protocol for Wild Rose species in the Northern", icon: "leaf.fill", destination: .technique("food-encyclopedia-rosa-northern-boreal")),
                        TriageOption(id: "g485", label: "Foraging protocol for Wild Rose species in the Southern", icon: "leaf.fill", destination: .technique("food-encyclopedia-rosa-southern-swamps")),
                        TriageOption(id: "g486", label: "Foraging protocol for Wild Rose species in the Western ", icon: "leaf.fill", destination: .technique("food-encyclopedia-rosa-western-mountains"))
                    ])
                )),
                TriageOption(id: "g487", label: "Wild (5)", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g487-q", question: "Select:", options: [
                        TriageOption(id: "g488", label: "Foraging protocol for Hickory species in the Eastern Wo", icon: "leaf.fill", destination: .technique("food-encyclopedia-carya-eastern-woodlands")),
                        TriageOption(id: "g489", label: "Foraging protocol for Wild Grape species in the Arid De", icon: "leaf.fill", destination: .technique("food-encyclopedia-vitis-arid-deserts")),
                        TriageOption(id: "g490", label: "Foraging protocol for Wild Grape species in the Norther", icon: "leaf.fill", destination: .technique("food-encyclopedia-vitis-northern-boreal")),
                        TriageOption(id: "g491", label: "Foraging protocol for Wild Grape species in the Souther", icon: "leaf.fill", destination: .technique("food-encyclopedia-vitis-southern-swamps")),
                        TriageOption(id: "g492", label: "Foraging protocol for Wild Grape species in the Western", icon: "leaf.fill", destination: .technique("food-encyclopedia-vitis-western-mountains"))
                    ])
                )),
                TriageOption(id: "g493", label: "Hickory", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g493-q", question: "Select:", options: [
                        TriageOption(id: "g494", label: "Foraging protocol for Beech species in the Eastern Wood", icon: "leaf.fill", destination: .technique("food-encyclopedia-fagus-eastern-woodlands")),
                        TriageOption(id: "g495", label: "Foraging protocol for Hickory species in the Arid Deser", icon: "leaf.fill", destination: .technique("food-encyclopedia-carya-arid-deserts")),
                        TriageOption(id: "g496", label: "Foraging protocol for Hickory species in the Northern B", icon: "leaf.fill", destination: .technique("food-encyclopedia-carya-northern-boreal")),
                        TriageOption(id: "g497", label: "Foraging protocol for Hickory species in the Southern S", icon: "leaf.fill", destination: .technique("food-encyclopedia-carya-southern-swamps")),
                        TriageOption(id: "g498", label: "Foraging protocol for Hickory species in the Western Mo", icon: "leaf.fill", destination: .technique("food-encyclopedia-carya-western-mountains"))
                    ])
                )),
                TriageOption(id: "g499", label: "Beech", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g499-q", question: "Select:", options: [
                        TriageOption(id: "g500", label: "Foraging protocol for Beech species in the Arid Deserts", icon: "leaf.fill", destination: .technique("food-encyclopedia-fagus-arid-deserts")),
                        TriageOption(id: "g501", label: "Foraging protocol for Beech species in the Northern Bor", icon: "leaf.fill", destination: .technique("food-encyclopedia-fagus-northern-boreal")),
                        TriageOption(id: "g502", label: "Foraging protocol for Beech species in the Southern Swa", icon: "leaf.fill", destination: .technique("food-encyclopedia-fagus-southern-swamps")),
                        TriageOption(id: "g503", label: "Foraging protocol for Beech species in the Western Moun", icon: "leaf.fill", destination: .technique("food-encyclopedia-fagus-western-mountains")),
                        TriageOption(id: "g504", label: "Foraging protocol for Hazelnut species in the Eastern W", icon: "leaf.fill", destination: .technique("food-encyclopedia-corylus-eastern-woodlands"))
                    ])
                )),
                TriageOption(id: "g505", label: "Hazelnut", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g505-q", question: "Select:", options: [
                        TriageOption(id: "g506", label: "Foraging protocol for Hazelnut species in the Arid Dese", icon: "leaf.fill", destination: .technique("food-encyclopedia-corylus-arid-deserts")),
                        TriageOption(id: "g507", label: "Foraging protocol for Hazelnut species in the Northern ", icon: "leaf.fill", destination: .technique("food-encyclopedia-corylus-northern-boreal")),
                        TriageOption(id: "g508", label: "Foraging protocol for Hazelnut species in the Southern ", icon: "leaf.fill", destination: .technique("food-encyclopedia-corylus-southern-swamps")),
                        TriageOption(id: "g509", label: "Foraging protocol for Hazelnut species in the Western M", icon: "leaf.fill", destination: .technique("food-encyclopedia-corylus-western-mountains")),
                        TriageOption(id: "g510", label: "Foraging protocol for Pine/Pinyon species in the Easter", icon: "leaf.fill", destination: .technique("food-encyclopedia-pinus-eastern-woodlands"))
                    ])
                )),
                TriageOption(id: "g511", label: "Pine (2)", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g511-q", question: "Select:", options: [
                        TriageOption(id: "g512", label: "Foraging protocol for Pine/Pinyon species in the Arid D", icon: "leaf.fill", destination: .technique("food-encyclopedia-pinus-arid-deserts")),
                        TriageOption(id: "g513", label: "Foraging protocol for Pine/Pinyon species in the Northe", icon: "leaf.fill", destination: .technique("food-encyclopedia-pinus-northern-boreal")),
                        TriageOption(id: "g514", label: "Foraging protocol for Pine/Pinyon species in the Southe", icon: "leaf.fill", destination: .technique("food-encyclopedia-pinus-southern-swamps")),
                        TriageOption(id: "g515", label: "Foraging protocol for Pine/Pinyon species in the Wester", icon: "leaf.fill", destination: .technique("food-encyclopedia-pinus-western-mountains")),
                        TriageOption(id: "g516", label: "Foraging protocol for Prickly Pear species in the Easte", icon: "leaf.fill", destination: .technique("food-encyclopedia-opuntia-eastern-woodlands"))
                    ])
                )),
                TriageOption(id: "g517", label: "Prickly", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g517-q", question: "Select:", options: [
                        TriageOption(id: "g518", label: "Foraging protocol for Prickly Pear species in the Arid ", icon: "leaf.fill", destination: .technique("food-encyclopedia-opuntia-arid-deserts")),
                        TriageOption(id: "g519", label: "Foraging protocol for Prickly Pear species in the North", icon: "leaf.fill", destination: .technique("food-encyclopedia-opuntia-northern-boreal")),
                        TriageOption(id: "g520", label: "Foraging protocol for Prickly Pear species in the South", icon: "leaf.fill", destination: .technique("food-encyclopedia-opuntia-southern-swamps")),
                        TriageOption(id: "g521", label: "Foraging protocol for Prickly Pear species in the Weste", icon: "leaf.fill", destination: .technique("food-encyclopedia-opuntia-western-mountains")),
                        TriageOption(id: "g522", label: "Foraging protocol for Yucca species in the Eastern Wood", icon: "leaf.fill", destination: .technique("food-encyclopedia-yucca-eastern-woodlands"))
                    ])
                )),
                TriageOption(id: "g523", label: "Yucca", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g523-q", question: "Select:", options: [
                        TriageOption(id: "g524", label: "Foraging protocol for Agave species in the Eastern Wood", icon: "leaf.fill", destination: .technique("food-encyclopedia-agave-eastern-woodlands")),
                        TriageOption(id: "g525", label: "Foraging protocol for Yucca species in the Arid Deserts", icon: "leaf.fill", destination: .technique("food-encyclopedia-yucca-arid-deserts")),
                        TriageOption(id: "g526", label: "Foraging protocol for Yucca species in the Northern Bor", icon: "leaf.fill", destination: .technique("food-encyclopedia-yucca-northern-boreal")),
                        TriageOption(id: "g527", label: "Foraging protocol for Yucca species in the Southern Swa", icon: "leaf.fill", destination: .technique("food-encyclopedia-yucca-southern-swamps")),
                        TriageOption(id: "g528", label: "Foraging protocol for Yucca species in the Western Moun", icon: "leaf.fill", destination: .technique("food-encyclopedia-yucca-western-mountains"))
                    ])
                )),
                TriageOption(id: "g529", label: "Agave", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g529-q", question: "Select:", options: [
                        TriageOption(id: "g530", label: "Foraging protocol for Agave species in the Arid Deserts", icon: "leaf.fill", destination: .technique("food-encyclopedia-agave-arid-deserts")),
                        TriageOption(id: "g531", label: "Foraging protocol for Agave species in the Northern Bor", icon: "leaf.fill", destination: .technique("food-encyclopedia-agave-northern-boreal")),
                        TriageOption(id: "g532", label: "Foraging protocol for Agave species in the Southern Swa", icon: "leaf.fill", destination: .technique("food-encyclopedia-agave-southern-swamps")),
                        TriageOption(id: "g533", label: "Foraging protocol for Agave species in the Western Moun", icon: "leaf.fill", destination: .technique("food-encyclopedia-agave-western-mountains")),
                        TriageOption(id: "g534", label: "Foraging protocol for Mesquite species in the Eastern W", icon: "leaf.fill", destination: .technique("food-encyclopedia-prosopis-eastern-woodlands"))
                    ])
                )),
                TriageOption(id: "g535", label: "Mesquite", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g535-q", question: "Select:", options: [
                        TriageOption(id: "g536", label: "Foraging protocol for Elderberry species in the Eastern", icon: "leaf.fill", destination: .technique("food-encyclopedia-sambucus-eastern-woodlands")),
                        TriageOption(id: "g537", label: "Foraging protocol for Mesquite species in the Arid Dese", icon: "leaf.fill", destination: .technique("food-encyclopedia-prosopis-arid-deserts")),
                        TriageOption(id: "g538", label: "Foraging protocol for Mesquite species in the Northern ", icon: "leaf.fill", destination: .technique("food-encyclopedia-prosopis-northern-boreal")),
                        TriageOption(id: "g539", label: "Foraging protocol for Mesquite species in the Southern ", icon: "leaf.fill", destination: .technique("food-encyclopedia-prosopis-southern-swamps")),
                        TriageOption(id: "g540", label: "Foraging protocol for Mesquite species in the Western M", icon: "leaf.fill", destination: .technique("food-encyclopedia-prosopis-western-mountains"))
                    ])
                )),
                TriageOption(id: "g541", label: "Elderberry", icon: "leaf.fill", destination: .nextQuestion(
                    TriageNode(id: "g541-q", question: "Select:", options: [
                        TriageOption(id: "g542", label: "Foraging protocol for Elderberry species in the Arid De", icon: "leaf.fill", destination: .technique("food-encyclopedia-sambucus-arid-deserts")),
                        TriageOption(id: "g543", label: "Foraging protocol for Elderberry species in the Norther", icon: "leaf.fill", destination: .technique("food-encyclopedia-sambucus-northern-boreal")),
                        TriageOption(id: "g544", label: "Foraging protocol for Elderberry species in the Souther", icon: "leaf.fill", destination: .technique("food-encyclopedia-sambucus-southern-swamps")),
                        TriageOption(id: "g545", label: "Foraging protocol for Elderberry species in the Western", icon: "leaf.fill", destination: .technique("food-encyclopedia-sambucus-western-mountains")),
                        TriageOption(id: "g546", label: "Foraging protocol for Mulberry species in the Eastern W", icon: "leaf.fill", destination: .technique("food-encyclopedia-morus-eastern-woodlands"))
                    ])
                )),
                TriageOption(id: "g547", label: "Mulberry", icon: "leaf.fill", destination: .nextQuestion(
                    TriageNode(id: "g547-q", question: "Select:", options: [
                        TriageOption(id: "g548", label: "Foraging protocol for Mulberry species in the Arid Dese", icon: "leaf.fill", destination: .technique("food-encyclopedia-morus-arid-deserts")),
                        TriageOption(id: "g549", label: "Foraging protocol for Mulberry species in the Northern ", icon: "leaf.fill", destination: .technique("food-encyclopedia-morus-northern-boreal")),
                        TriageOption(id: "g550", label: "Foraging protocol for Mulberry species in the Southern ", icon: "leaf.fill", destination: .technique("food-encyclopedia-morus-southern-swamps")),
                        TriageOption(id: "g551", label: "Foraging protocol for Mulberry species in the Western M", icon: "leaf.fill", destination: .technique("food-encyclopedia-morus-western-mountains")),
                        TriageOption(id: "g552", label: "Foraging protocol for Serviceberry species in the Easte", icon: "leaf.fill", destination: .technique("food-encyclopedia-amelanchier-eastern-woodlands"))
                    ])
                )),
                TriageOption(id: "g553", label: "Serviceberry", icon: "leaf.fill", destination: .nextQuestion(
                    TriageNode(id: "g553-q", question: "Select:", options: [
                        TriageOption(id: "g554", label: "Foraging protocol for Hackberry species in the Eastern ", icon: "leaf.fill", destination: .technique("food-encyclopedia-celtis-eastern-woodlands")),
                        TriageOption(id: "g555", label: "Foraging protocol for Serviceberry species in the Arid ", icon: "leaf.fill", destination: .technique("food-encyclopedia-amelanchier-arid-deserts")),
                        TriageOption(id: "g556", label: "Foraging protocol for Serviceberry species in the North", icon: "leaf.fill", destination: .technique("food-encyclopedia-amelanchier-northern-boreal")),
                        TriageOption(id: "g557", label: "Foraging protocol for Serviceberry species in the South", icon: "leaf.fill", destination: .technique("food-encyclopedia-amelanchier-southern-swamps")),
                        TriageOption(id: "g558", label: "Foraging protocol for Serviceberry species in the Weste", icon: "leaf.fill", destination: .technique("food-encyclopedia-amelanchier-western-mountains"))
                    ])
                )),
                TriageOption(id: "g559", label: "Hackberry", icon: "leaf.fill", destination: .nextQuestion(
                    TriageNode(id: "g559-q", question: "Select:", options: [
                        TriageOption(id: "g560", label: "Foraging protocol for Hackberry species in the Arid Des", icon: "leaf.fill", destination: .technique("food-encyclopedia-celtis-arid-deserts")),
                        TriageOption(id: "g561", label: "Foraging protocol for Hackberry species in the Northern", icon: "leaf.fill", destination: .technique("food-encyclopedia-celtis-northern-boreal")),
                        TriageOption(id: "g562", label: "Foraging protocol for Hackberry species in the Southern", icon: "leaf.fill", destination: .technique("food-encyclopedia-celtis-southern-swamps")),
                        TriageOption(id: "g563", label: "Foraging protocol for Hackberry species in the Western ", icon: "leaf.fill", destination: .technique("food-encyclopedia-celtis-western-mountains")),
                        TriageOption(id: "g564", label: "Foraging protocol for Persimmon species in the Eastern ", icon: "leaf.fill", destination: .technique("food-encyclopedia-diospyros-eastern-woodlands"))
                    ])
                )),
                TriageOption(id: "g565", label: "Persimmon", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g565-q", question: "Select:", options: [
                        TriageOption(id: "g566", label: "Foraging protocol for Pawpaw species in the Eastern Woo", icon: "leaf.fill", destination: .technique("food-encyclopedia-asimina-eastern-woodlands")),
                        TriageOption(id: "g567", label: "Foraging protocol for Persimmon species in the Arid Des", icon: "leaf.fill", destination: .technique("food-encyclopedia-diospyros-arid-deserts")),
                        TriageOption(id: "g568", label: "Foraging protocol for Persimmon species in the Northern", icon: "leaf.fill", destination: .technique("food-encyclopedia-diospyros-northern-boreal")),
                        TriageOption(id: "g569", label: "Foraging protocol for Persimmon species in the Southern", icon: "leaf.fill", destination: .technique("food-encyclopedia-diospyros-southern-swamps")),
                        TriageOption(id: "g570", label: "Foraging protocol for Persimmon species in the Western ", icon: "leaf.fill", destination: .technique("food-encyclopedia-diospyros-western-mountains"))
                    ])
                )),
                TriageOption(id: "g571", label: "Pawpaw", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g571-q", question: "Select:", options: [
                        TriageOption(id: "g572", label: "Foraging protocol for Pawpaw species in the Arid Desert", icon: "leaf.fill", destination: .technique("food-encyclopedia-asimina-arid-deserts")),
                        TriageOption(id: "g573", label: "Foraging protocol for Pawpaw species in the Northern Bo", icon: "leaf.fill", destination: .technique("food-encyclopedia-asimina-northern-boreal")),
                        TriageOption(id: "g574", label: "Foraging protocol for Pawpaw species in the Southern Sw", icon: "leaf.fill", destination: .technique("food-encyclopedia-asimina-southern-swamps")),
                        TriageOption(id: "g575", label: "Foraging protocol for Pawpaw species in the Western Mou", icon: "leaf.fill", destination: .technique("food-encyclopedia-asimina-western-mountains")),
                        TriageOption(id: "g576", label: "Foraging protocol for Wild Cherry/Plum species in the E", icon: "leaf.fill", destination: .technique("food-encyclopedia-prunus-eastern-woodlands"))
                    ])
                )),
                TriageOption(id: "g577", label: "Wild (6)", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g577-q", question: "Select:", options: [
                        TriageOption(id: "g578", label: "Foraging protocol for Crabapple species in the Eastern ", icon: "leaf.fill", destination: .technique("food-encyclopedia-malus-eastern-woodlands")),
                        TriageOption(id: "g579", label: "Foraging protocol for Wild Cherry/Plum species in the A", icon: "leaf.fill", destination: .technique("food-encyclopedia-prunus-arid-deserts")),
                        TriageOption(id: "g580", label: "Foraging protocol for Wild Cherry/Plum species in the N", icon: "leaf.fill", destination: .technique("food-encyclopedia-prunus-northern-boreal")),
                        TriageOption(id: "g581", label: "Foraging protocol for Wild Cherry/Plum species in the S", icon: "leaf.fill", destination: .technique("food-encyclopedia-prunus-southern-swamps")),
                        TriageOption(id: "g582", label: "Foraging protocol for Wild Cherry/Plum species in the W", icon: "leaf.fill", destination: .technique("food-encyclopedia-prunus-western-mountains"))
                    ])
                )),
                TriageOption(id: "g583", label: "Crabapple", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g583-q", question: "Select:", options: [
                        TriageOption(id: "g584", label: "Foraging protocol for Crabapple species in the Arid Des", icon: "leaf.fill", destination: .technique("food-encyclopedia-malus-arid-deserts")),
                        TriageOption(id: "g585", label: "Foraging protocol for Crabapple species in the Northern", icon: "leaf.fill", destination: .technique("food-encyclopedia-malus-northern-boreal")),
                        TriageOption(id: "g586", label: "Foraging protocol for Crabapple species in the Southern", icon: "leaf.fill", destination: .technique("food-encyclopedia-malus-southern-swamps")),
                        TriageOption(id: "g587", label: "Foraging protocol for Crabapple species in the Western ", icon: "leaf.fill", destination: .technique("food-encyclopedia-malus-western-mountains")),
                        TriageOption(id: "g588", label: "Foraging protocol for Sumac species in the Eastern Wood", icon: "leaf.fill", destination: .technique("food-encyclopedia-rhus-eastern-woodlands"))
                    ])
                )),
                TriageOption(id: "g589", label: "Sumac", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g589-q", question: "Select:", options: [
                        TriageOption(id: "g590", label: "Identifying Morchella species (The Foolproof Four).", icon: "flame.fill", destination: .technique("food-mushroom-morel")),
                        TriageOption(id: "g591", label: "Foraging protocol for Sumac species in the Arid Deserts", icon: "leaf.fill", destination: .technique("food-encyclopedia-rhus-arid-deserts")),
                        TriageOption(id: "g592", label: "Foraging protocol for Sumac species in the Northern Bor", icon: "leaf.fill", destination: .technique("food-encyclopedia-rhus-northern-boreal")),
                        TriageOption(id: "g593", label: "Foraging protocol for Sumac species in the Southern Swa", icon: "leaf.fill", destination: .technique("food-encyclopedia-rhus-southern-swamps")),
                        TriageOption(id: "g594", label: "Foraging protocol for Sumac species in the Western Moun", icon: "leaf.fill", destination: .technique("food-encyclopedia-rhus-western-mountains"))
                    ])
                )),
                TriageOption(id: "g595", label: "Asteraceae", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g595-q", question: "Select:", options: [
                        TriageOption(id: "g596", label: "Applying root digging techniques to edible members of t", icon: "flame.fill", destination: .technique("food-encyclopedia-forage-asteraceae-root-digging")),
                        TriageOption(id: "g597", label: "Applying sap tapping techniques to edible members of th", icon: "flame.fill", destination: .technique("food-encyclopedia-forage-asteraceae-sap-tapping")),
                        TriageOption(id: "g598", label: "Applying seed threshing techniques to edible members of", icon: "flame.fill", destination: .technique("food-encyclopedia-forage-asteraceae-seed-threshing")),
                        TriageOption(id: "g599", label: "Identifying Laetiporus sulphureus (The Foolproof Four).", icon: "leaf.fill", destination: .technique("food-mushroom-chicken-woods")),
                        TriageOption(id: "g600", label: "Identifying Calvatia gigantea (The Foolproof Four).", icon: "leaf.fill", destination: .technique("food-mushroom-puffball"))
                    ])
                )),
                TriageOption(id: "g601", label: "Rosaceae", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g601-q", question: "Select:", options: [
                        TriageOption(id: "g602", label: "Applying flower extraction techniques to edible members", icon: "flame.fill", destination: .technique("food-encyclopedia-forage-asteraceae-flower-extraction")),
                        TriageOption(id: "g603", label: "Applying shoot harvesting techniques to edible members ", icon: "ant.fill", destination: .technique("food-encyclopedia-forage-asteraceae-shoot-harvesting")),
                        TriageOption(id: "g604", label: "Applying root digging techniques to edible members of t", icon: "flame.fill", destination: .technique("food-encyclopedia-forage-rosaceae-root-digging")),
                        TriageOption(id: "g605", label: "Applying sap tapping techniques to edible members of th", icon: "flame.fill", destination: .technique("food-encyclopedia-forage-rosaceae-sap-tapping")),
                        TriageOption(id: "g606", label: "Applying seed threshing techniques to edible members of", icon: "flame.fill", destination: .technique("food-encyclopedia-forage-rosaceae-seed-threshing"))
                    ])
                )),
                TriageOption(id: "g607", label: "Lamiaceae", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g607-q", question: "Select:", options: [
                        TriageOption(id: "g608", label: "Applying root digging techniques to edible members of t", icon: "flame.fill", destination: .technique("food-encyclopedia-forage-lamiaceae-root-digging")),
                        TriageOption(id: "g609", label: "Applying seed threshing techniques to edible members of", icon: "flame.fill", destination: .technique("food-encyclopedia-forage-lamiaceae-seed-threshing")),
                        TriageOption(id: "g610", label: "Applying shoot harvesting techniques to edible members ", icon: "ant.fill", destination: .technique("food-encyclopedia-forage-lamiaceae-shoot-harvesting")),
                        TriageOption(id: "g611", label: "Applying flower extraction techniques to edible members", icon: "flame.fill", destination: .technique("food-encyclopedia-forage-rosaceae-flower-extraction")),
                        TriageOption(id: "g612", label: "Applying shoot harvesting techniques to edible members ", icon: "ant.fill", destination: .technique("food-encyclopedia-forage-rosaceae-shoot-harvesting"))
                    ])
                )),
                TriageOption(id: "g613", label: "Fabaceae", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g613-q", question: "Select:", options: [
                        TriageOption(id: "g614", label: "Applying root digging techniques to edible members of t", icon: "flame.fill", destination: .technique("food-encyclopedia-forage-fabaceae-root-digging")),
                        TriageOption(id: "g615", label: "Applying sap tapping techniques to edible members of th", icon: "flame.fill", destination: .technique("food-encyclopedia-forage-fabaceae-sap-tapping")),
                        TriageOption(id: "g616", label: "Applying seed threshing techniques to edible members of", icon: "flame.fill", destination: .technique("food-encyclopedia-forage-fabaceae-seed-threshing")),
                        TriageOption(id: "g617", label: "Applying shoot harvesting techniques to edible members ", icon: "ant.fill", destination: .technique("food-encyclopedia-forage-fabaceae-shoot-harvesting")),
                        TriageOption(id: "g618", label: "Applying flower extraction techniques to edible members", icon: "flame.fill", destination: .technique("food-encyclopedia-forage-lamiaceae-flower-extraction"))
                    ])
                )),
                TriageOption(id: "g619", label: "Apiaceae", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g619-q", question: "Select:", options: [
                        TriageOption(id: "g620", label: "Applying root digging techniques to edible members of t", icon: "flame.fill", destination: .technique("food-encyclopedia-forage-apiaceae-root-digging")),
                        TriageOption(id: "g621", label: "Applying sap tapping techniques to edible members of th", icon: "flame.fill", destination: .technique("food-encyclopedia-forage-apiaceae-sap-tapping")),
                        TriageOption(id: "g622", label: "Applying seed threshing techniques to edible members of", icon: "flame.fill", destination: .technique("food-encyclopedia-forage-apiaceae-seed-threshing")),
                        TriageOption(id: "g623", label: "Applying shoot harvesting techniques to edible members ", icon: "ant.fill", destination: .technique("food-encyclopedia-forage-apiaceae-shoot-harvesting")),
                        TriageOption(id: "g624", label: "Applying flower extraction techniques to edible members", icon: "flame.fill", destination: .technique("food-encyclopedia-forage-fabaceae-flower-extraction"))
                    ])
                )),
                TriageOption(id: "g625", label: "Brassicaceae", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g625-q", question: "Select:", options: [
                        TriageOption(id: "g626", label: "Applying flower extraction techniques to edible members", icon: "flame.fill", destination: .technique("food-encyclopedia-forage-apiaceae-flower-extraction")),
                        TriageOption(id: "g627", label: "Applying flower extraction techniques to edible members", icon: "flame.fill", destination: .technique("food-encyclopedia-forage-brassicaceae-flower-extraction")),
                        TriageOption(id: "g628", label: "Applying root digging techniques to edible members of t", icon: "flame.fill", destination: .technique("food-encyclopedia-forage-brassicaceae-root-digging")),
                        TriageOption(id: "g629", label: "Applying seed threshing techniques to edible members of", icon: "flame.fill", destination: .technique("food-encyclopedia-forage-brassicaceae-seed-threshing")),
                        TriageOption(id: "g630", label: "Applying shoot harvesting techniques to edible members ", icon: "ant.fill", destination: .technique("food-encyclopedia-forage-brassicaceae-shoot-harvesting"))
                    ])
                )),
                TriageOption(id: "g631", label: "Liliaceae", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g631-q", question: "Select:", options: [
                        TriageOption(id: "g632", label: "Applying flower extraction techniques to edible members", icon: "flame.fill", destination: .technique("food-encyclopedia-forage-liliaceae-flower-extraction")),
                        TriageOption(id: "g633", label: "Applying root digging techniques to edible members of t", icon: "flame.fill", destination: .technique("food-encyclopedia-forage-liliaceae-root-digging")),
                        TriageOption(id: "g634", label: "Applying sap tapping techniques to edible members of th", icon: "flame.fill", destination: .technique("food-encyclopedia-forage-liliaceae-sap-tapping")),
                        TriageOption(id: "g635", label: "Applying seed threshing techniques to edible members of", icon: "flame.fill", destination: .technique("food-encyclopedia-forage-liliaceae-seed-threshing")),
                        TriageOption(id: "g636", label: "Applying shoot harvesting techniques to edible members ", icon: "ant.fill", destination: .technique("food-encyclopedia-forage-liliaceae-shoot-harvesting"))
                    ])
                )),
                TriageOption(id: "g637", label: "Ericaceae", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g637-q", question: "Select:", options: [
                        TriageOption(id: "g638", label: "Applying flower extraction techniques to edible members", icon: "flame.fill", destination: .technique("food-encyclopedia-forage-ericaceae-flower-extraction")),
                        TriageOption(id: "g639", label: "Applying root digging techniques to edible members of t", icon: "flame.fill", destination: .technique("food-encyclopedia-forage-ericaceae-root-digging")),
                        TriageOption(id: "g640", label: "Applying sap tapping techniques to edible members of th", icon: "flame.fill", destination: .technique("food-encyclopedia-forage-ericaceae-sap-tapping")),
                        TriageOption(id: "g641", label: "Applying seed threshing techniques to edible members of", icon: "flame.fill", destination: .technique("food-encyclopedia-forage-ericaceae-seed-threshing")),
                        TriageOption(id: "g642", label: "Applying shoot harvesting techniques to edible members ", icon: "ant.fill", destination: .technique("food-encyclopedia-forage-ericaceae-shoot-harvesting"))
                    ])
                )),
                TriageOption(id: "g643", label: "Pinaceae", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g643-q", question: "Select:", options: [
                        TriageOption(id: "g644", label: "Applying root digging techniques to edible members of t", icon: "flame.fill", destination: .technique("food-encyclopedia-forage-fagaceae-root-digging")),
                        TriageOption(id: "g645", label: "Applying root digging techniques to edible members of t", icon: "flame.fill", destination: .technique("food-encyclopedia-forage-pinaceae-root-digging")),
                        TriageOption(id: "g646", label: "Applying sap tapping techniques to edible members of th", icon: "flame.fill", destination: .technique("food-encyclopedia-forage-pinaceae-sap-tapping")),
                        TriageOption(id: "g647", label: "Applying seed threshing techniques to edible members of", icon: "flame.fill", destination: .technique("food-encyclopedia-forage-pinaceae-seed-threshing")),
                        TriageOption(id: "g648", label: "Applying shoot harvesting techniques to edible members ", icon: "ant.fill", destination: .technique("food-encyclopedia-forage-pinaceae-shoot-harvesting"))
                    ])
                )),
                TriageOption(id: "g649", label: "Fagaceae", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g649-q", question: "Select:", options: [
                        TriageOption(id: "g650", label: "Applying flower extraction techniques to edible members", icon: "flame.fill", destination: .technique("food-encyclopedia-forage-fagaceae-flower-extraction")),
                        TriageOption(id: "g651", label: "Applying sap tapping techniques to edible members of th", icon: "flame.fill", destination: .technique("food-encyclopedia-forage-fagaceae-sap-tapping")),
                        TriageOption(id: "g652", label: "Applying seed threshing techniques to edible members of", icon: "flame.fill", destination: .technique("food-encyclopedia-forage-fagaceae-seed-threshing")),
                        TriageOption(id: "g653", label: "Applying shoot harvesting techniques to edible members ", icon: "ant.fill", destination: .technique("food-encyclopedia-forage-fagaceae-shoot-harvesting"))
                    ])
                ))
                ])
            )),

            TriageOption(id: "g654", label: "Fishing", icon: "fish.fill", destination: .nextQuestion(
                TriageNode(id: "g654-q", question: "What specifically?", options: [
                TriageOption(id: "g655", label: "Stream", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g655-q", question: "Select:", options: [
                        TriageOption(id: "g656", label: "Hand-catching freshwater lobsters from stream beds", icon: "fish.fill", destination: .technique("food-crayfish-catching")),
                        TriageOption(id: "g657", label: "Funnel fish into a catch basin using stone walls", icon: "fish.fill", destination: .technique("food-weir-fish-trap")),
                        TriageOption(id: "g658", label: "Construct a funnel trap to catch fish in moving water", icon: "target", destination: .technique("food-fish-weir")),
                        TriageOption(id: "g659", label: "Set multiple hooks on one line across water", icon: "fish.fill", destination: .technique("food-trotline-fishing"))
                    ])
                )),
                TriageOption(id: "g660", label: "Trap", icon: "target", destination: .nextQuestion(
                    TriageNode(id: "g660-q", question: "Select:", options: [
                        TriageOption(id: "g661", label: "High-protein coastal harvest with minimal gear", icon: "target", destination: .technique("food-crab-trapping")),
                        TriageOption(id: "g662", label: "Building a funnel trap from plastic bottles", icon: "target", destination: .technique("food-crayfish-trap-improvised")),
                        TriageOption(id: "g663", label: "Catching fish passively in flowing water.", icon: "target", destination: .technique("food-trap-fish-basket"))
                    ])
                )),
                TriageOption(id: "g664", label: "Line", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g664-q", question: "Select:", options: [
                        TriageOption(id: "g665", label: "Shoot fish in shallow water with a modified bow", icon: "fish.fill", destination: .technique("food-bow-fishing")),
                        TriageOption(id: "g666", label: "Set a passive net to catch fish while you sleep", icon: "fish.fill", destination: .technique("food-gill-net"))
                    ])
                )),
                TriageOption(id: "g667", label: "Natural", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g667-q", question: "Select:", options: [
                        TriageOption(id: "g668", label: "Using plant-derived compounds to harvest fish", icon: "leaf.fill", destination: .technique("food-fish-poison-plants")),
                        TriageOption(id: "g669", label: "Find natural bait for fishing", icon: "fish.fill", destination: .technique("food-bait-collection"))
                    ])
                )),
                TriageOption(id: "g670", label: "Catch", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g670-q", question: "Select:", options: [
                        TriageOption(id: "g671", label: "Catch freshwater crayfish without tools", icon: "fish.fill", destination: .technique("food-crayfish-by-hand")),
                        TriageOption(id: "g672", label: "Catch fish by hand in shallow water", icon: "fish.fill", destination: .technique("food-hand-fishing"))
                    ])
                )),
                TriageOption(id: "g673", label: "Fish", icon: "fish.fill", destination: .nextQuestion(
                    TriageNode(id: "g673-q", question: "Select:", options: [
                        TriageOption(id: "g674", label: "Aiming below the apparent position of fish", icon: "fish.fill", destination: .technique("food-fish-spearing-technique")),
                        TriageOption(id: "g675", label: "River protein available year-round", icon: "cross.case.fill", destination: .technique("food-mussel-harvest")),
                        TriageOption(id: "g676", label: "Passive fishing — catches fish while you do other tasks", icon: "fish.fill", destination: .technique("food-gill-net-construction")),
                        TriageOption(id: "g677", label: "Make hooks from thorns, bone, safety pins, or wire", icon: "bandage.fill", destination: .technique("food-improvised-fish-hook")),
                        TriageOption(id: "g678", label: "Harvesting shellfish and sea creatures at low tide", icon: "ant.fill", destination: .technique("food-tidal-pool-foraging"))
                    ])
                ))
                ])
            )),

            TriageOption(id: "g679", label: "Insects as Food", icon: "ant.fill", destination: .nextQuestion(
                TriageNode(id: "g679-q", question: "What specifically?", options: [
                TriageOption(id: "g680", label: "Crickets", icon: "ant.fill", destination: .nextQuestion(
                    TriageNode(id: "g680-q", question: "Select:", options: [
                        TriageOption(id: "g681", label: "High-protein emergency food — most insects are safe", icon: "leaf.fill", destination: .technique("food-insect-eating-guide")),
                        TriageOption(id: "g682", label: "Know which insects are safe to eat", icon: "leaf.fill", destination: .technique("food-edible-insect-guide"))
                    ])
                )),
                TriageOption(id: "g683", label: "Consumption", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g683-q", question: "Select:", options: [
                        TriageOption(id: "g684", label: "Harvest and prepare ants for consumption", icon: "leaf.fill", destination: .technique("food-ant-foraging")),
                        TriageOption(id: "g685", label: "Finding and eating high-calorie insect larvae", icon: "ant.fill", destination: .technique("food-grub-eating"))
                    ])
                )),
                TriageOption(id: "g686", label: "Moist", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g686-q", question: "Select:", options: [
                        TriageOption(id: "g687", label: "Available everywhere, year-round, high protein", icon: "ant.fill", destination: .technique("food-earthworm-harvest")),
                        TriageOption(id: "g688", label: "Abundant protein source — available worldwide", icon: "cloud.rain.fill", destination: .technique("food-snail-foraging"))
                    ])
                ))
                ])
            )),

            TriageOption(id: "g689", label: "Poisonous Plants", icon: "exclamationmark.triangle.fill", destination: .nextQuestion(
                TriageNode(id: "g689-q", question: "What specifically?", options: [
                TriageOption(id: "g690", label: "Wild", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g690-q", question: "Select:", options: [
                        TriageOption(id: "g691", label: "Toxic Lookalike - DO NOT EAT", icon: "exclamationmark.triangle.fill", destination: .technique("food-botany-death-camas")),
                        TriageOption(id: "g692", label: "Toxic Lookalike - DO NOT EAT", icon: "exclamationmark.triangle.fill", destination: .technique("food-botany-water-hemlock"))
                    ])
                )),
                TriageOption(id: "g693", label: "Weed", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g693-q", question: "Select:", options: [
                        TriageOption(id: "g694", label: "Toxic Lookalike - DO NOT EAT", icon: "exclamationmark.triangle.fill", destination: .technique("food-botany-castor-bean")),
                        TriageOption(id: "g695", label: "Toxic Lookalike - DO NOT EAT", icon: "exclamationmark.triangle.fill", destination: .technique("food-botany-poison-hemlock"))
                    ])
                )),
                TriageOption(id: "g696", label: "Toxic", icon: "exclamationmark.triangle.fill", destination: .nextQuestion(
                    TriageNode(id: "g696-q", question: "Select:", options: [
                        TriageOption(id: "g697", label: "Toxic Lookalike - DO NOT EAT", icon: "exclamationmark.triangle.fill", destination: .technique("food-botany-nightshade-deadly")),
                        TriageOption(id: "g698", label: "Toxic Lookalike - DO NOT EAT", icon: "exclamationmark.triangle.fill", destination: .technique("food-botany-oleander")),
                        TriageOption(id: "g699", label: "Toxic Lookalike - DO NOT EAT", icon: "ant.fill", destination: .technique("food-botany-white-snakeroot"))
                    ])
                ))
                ])
            )),

            TriageOption(id: "g700", label: "Preserving Food", icon: "flame.fill", destination: .nextQuestion(
                TriageNode(id: "g700-q", question: "What specifically?", options: [
                TriageOption(id: "g701", label: "Preserve", icon: "flame.fill", destination: .nextQuestion(
                    TriageNode(id: "g701-q", question: "Select:", options: [
                        TriageOption(id: "g702", label: "Preserve any meat for weeks using only sun and smoke", icon: "cloud.rain.fill", destination: .technique("food-drying-meat-jerky")),
                        TriageOption(id: "g703", label: "Preserve meat and plants using sun and wind", icon: "sun.max.fill", destination: .technique("food-solar-drying"))
                    ])
                )),
                TriageOption(id: "g704", label: "Fish", icon: "fish.fill", destination: .nextQuestion(
                    TriageNode(id: "g704-q", question: "Select:", options: [
                        TriageOption(id: "g705", label: "Hot-smoke fish for preservation and flavor", icon: "fish.fill", destination: .technique("food-fish-smoking")),
                        TriageOption(id: "g706", label: "Hot-smoke fish for 1-2 weeks of storage", icon: "fish.fill", destination: .technique("food-smoking-fish"))
                    ])
                )),
                TriageOption(id: "g707", label: "Electricity", icon: "building.2.fill", destination: .nextQuestion(
                    TriageNode(id: "g707-q", question: "Select:", options: [
                        TriageOption(id: "g708", label: "Keep food cold without electricity", icon: "water.waves", destination: .technique("food-natural-refrigeration")),
                        TriageOption(id: "g709", label: "Sun-dry food for long-term storage without electricity", icon: "sun.max.fill", destination: .technique("food-solar-dehydrator"))
                    ])
                )),
                TriageOption(id: "g710", label: "Meat", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g710-q", question: "Select:", options: [
                        TriageOption(id: "g711", label: "Preserving meat without modern equipment", icon: "flame.fill", destination: .technique("food-primitive-jerky")),
                        TriageOption(id: "g712", label: "Drying and smoking wild game for long-term storage", icon: "flame.fill", destination: .technique("food-smoking-preservation"))
                    ])
                )),
                TriageOption(id: "g713", label: "Birch", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g713-q", question: "Select:", options: [
                        TriageOption(id: "g714", label: "Concentrate birch sap into sweet syrup — boreal maple s", icon: "drop.fill", destination: .technique("food-birch-sap-syrup")),
                        TriageOption(id: "g715", label: "Ancient high-energy travel food from any grain or seed", icon: "flame.fill", destination: .technique("food-pinole")),
                        TriageOption(id: "g716", label: "Essential mineral for survival — extract from soil, pla", icon: "leaf.fill", destination: .technique("food-primitive-salt-extraction"))
                    ])
                ))
                ])
            )),

            TriageOption(id: "g717", label: "Tracking & Hunting", icon: "pawprint.fill", destination: .nextQuestion(
                TriageNode(id: "g717-q", question: "What specifically?", options: [
                TriageOption(id: "g718", label: "Inches", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g718-q", question: "Select:", options: [
                        TriageOption(id: "g719", label: "Read tracks to determine prey species and direction", icon: "heart.fill", destination: .technique("food-animal-track-identification")),
                        TriageOption(id: "g720", label: "Small, round feline track (no claws), about 2 inches ac", icon: "pawprint.fill", destination: .technique("food-track-bobcat-tracks")),
                        TriageOption(id: "g721", label: "Follow deer to food, water, and predict movements", icon: "heart.fill", destination: .technique("food-deer-tracking")),
                        TriageOption(id: "g722", label: "Classic three-toed arrow shape, often quite large (4+ i", icon: "pawprint.fill", destination: .technique("food-track-turkey-tracks")),
                        TriageOption(id: "g723", label: "Identical to coyote but massive (up to 4-5 inches long)", icon: "pawprint.fill", destination: .technique("food-track-wolf-tracks"))
                    ])
                )),
                TriageOption(id: "g724", label: "Shaped", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g724-q", question: "Select:", options: [
                        TriageOption(id: "g725", label: "Heart-shaped track with two distinct symmetrical toes (", icon: "heart.fill", destination: .technique("food-track-deer-tracks")),
                        TriageOption(id: "g726", label: "Small canine track, often showing a distinct chevron-sh", icon: "pawprint.fill", destination: .technique("food-track-fox-tracks")),
                        TriageOption(id: "g727", label: "Massive heart-shaped track, often showing dewclaws in m", icon: "heart.fill", destination: .technique("food-track-moose-tracks"))
                    ])
                )),
                TriageOption(id: "g728", label: "Often", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g728-q", question: "Select:", options: [
                        TriageOption(id: "g729", label: "Pebbled-texture footpads, often accompanied by a sweepi", icon: "pawprint.fill", destination: .technique("food-track-porcupine-tracks")),
                        TriageOption(id: "g730", label: "Boxy, paired clusters. Front and hind feet are often ad", icon: "pawprint.fill", destination: .technique("food-track-squirrel-tracks"))
                    ])
                )),
                TriageOption(id: "g731", label: "Rabbit", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g731-q", question: "Select:", options: [
                        TriageOption(id: "g732", label: "Interpreting scat, beds, and feeding damage left by Cot", icon: "pawprint.fill", destination: .technique("food-encyclopedia-sign-cottontail-rabbit")),
                        TriageOption(id: "g733", label: "Simple hunting weapon for small game", icon: "scope", destination: .technique("food-rabbit-stick")),
                        TriageOption(id: "g734", label: "Most common small game — year-round availability", icon: "pawprint.fill", destination: .technique("food-rabbit-tracking")),
                        TriageOption(id: "g735", label: "Distinct Y-pattern grouping: two large parallel back fe", icon: "pawprint.fill", destination: .technique("food-track-rabbit-tracks")),
                        TriageOption(id: "g736", label: "Identifying the physical footprint structure of Cottont", icon: "pawprint.fill", destination: .technique("food-encyclopedia-track-cottontail-rabbit"))
                    ])
                )),
                TriageOption(id: "g737", label: "Squirrel", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g737-q", question: "Select:", options: [
                        TriageOption(id: "g738", label: "Interpreting scat, beds, and feeding damage left by Gra", icon: "pawprint.fill", destination: .technique("food-encyclopedia-sign-gray-squirrel")),
                        TriageOption(id: "g739", label: "Interpreting scat, beds, and feeding damage left by Red", icon: "pawprint.fill", destination: .technique("food-encyclopedia-sign-red-squirrel")),
                        TriageOption(id: "g740", label: "Identifying the physical footprint structure of Gray Sq", icon: "pawprint.fill", destination: .technique("food-encyclopedia-track-gray-squirrel")),
                        TriageOption(id: "g741", label: "Identifying the physical footprint structure of Red Squ", icon: "pawprint.fill", destination: .technique("food-encyclopedia-track-red-squirrel"))
                    ])
                )),
                TriageOption(id: "g742", label: "Tracks", icon: "pawprint.fill", destination: .nextQuestion(
                    TriageNode(id: "g742-q", question: "Select:", options: [
                        TriageOption(id: "g743", label: "Large webbed hind foot, though webbing may not always r", icon: "pawprint.fill", destination: .technique("food-track-beaver-tracks")),
                        TriageOption(id: "g744", label: "Similar to deer but significantly larger and rounder.", icon: "pawprint.fill", destination: .technique("food-track-elk-tracks")),
                        TriageOption(id: "g745", label: "Distinctive opposable thumb on the hind foot pointing c", icon: "cloud.rain.fill", destination: .technique("food-track-opossum-tracks")),
                        TriageOption(id: "g746", label: "Maximize nutrition from hunted game organs", icon: "scope", destination: .technique("food-organ-meat-nutrition")),
                        TriageOption(id: "g747", label: "Looks startlingly like a small human handprint with lon", icon: "pawprint.fill", destination: .technique("food-track-raccoon-tracks"))
                    ])
                )),
                TriageOption(id: "g748", label: "Toes", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g748-q", question: "Select:", options: [
                        TriageOption(id: "g749", label: "Massive blocky track showing 5 toes and prominent claw ", icon: "pawprint.fill", destination: .technique("food-track-bear-tracks")),
                        TriageOption(id: "g750", label: "Asymmetrical pad with 4 toes. NO claw marks (felines re", icon: "pawprint.fill", destination: .technique("food-track-cougar-mountain-lion-tracks")),
                        TriageOption(id: "g751", label: "Symmetrical oval track with 4 toes and visible claw mar", icon: "pawprint.fill", destination: .technique("food-track-coyote-tracks")),
                        TriageOption(id: "g752", label: "Smaller three-toed track, similar to turkey but scaled ", icon: "pawprint.fill", destination: .technique("food-track-pheasant-tracks")),
                        TriageOption(id: "g753", label: "Similar to deer, but the toes are blunter and spread wi", icon: "cloud.rain.fill", destination: .technique("food-track-wild-boar-tracks"))
                    ])
                )),
                TriageOption(id: "g754", label: "Tracks (2)", icon: "pawprint.fill", destination: .nextQuestion(
                    TriageNode(id: "g754-q", question: "Select:", options: [
                        TriageOption(id: "g755", label: "Birds reveal food sources, water, and weather changes", icon: "cloud.fill", destination: .technique("food-bird-tracking-habits")),
                        TriageOption(id: "g756", label: "Differentiating dog/wolf/coyote from bobcat/cougar trac", icon: "pawprint.fill", destination: .technique("food-track-canine-vs-feline")),
                        TriageOption(id: "g757", label: "Three toes connected by distinct webbing.", icon: "pawprint.fill", destination: .technique("food-track-duck-tracks")),
                        TriageOption(id: "g758", label: "Night-time protein harvest from any pond or marsh", icon: "flame.fill", destination: .technique("food-frog-hunting")),
                        TriageOption(id: "g759", label: "Five toes showing on both front and rear feet, with lon", icon: "pawprint.fill", destination: .technique("food-track-skunk-tracks"))
                    ])
                )),
                TriageOption(id: "g760", label: "Deer", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g760-q", question: "Select:", options: [
                        TriageOption(id: "g761", label: "Determining how fresh a track is to gauge proximity to ", icon: "list.bullet.clipboard.fill", destination: .technique("food-track-deer-aging")),
                        TriageOption(id: "g762", label: "Interpreting scat, beds, and feeding damage left by Mul", icon: "pawprint.fill", destination: .technique("food-encyclopedia-sign-mule-deer")),
                        TriageOption(id: "g763", label: "Interpreting scat, beds, and feeding damage left by Whi", icon: "pawprint.fill", destination: .technique("food-encyclopedia-sign-whitetail-deer")),
                        TriageOption(id: "g764", label: "Identifying the physical footprint structure of Mule De", icon: "pawprint.fill", destination: .technique("food-encyclopedia-track-mule-deer")),
                        TriageOption(id: "g765", label: "Identifying the physical footprint structure of Whiteta", icon: "pawprint.fill", destination: .technique("food-encyclopedia-track-whitetail-deer"))
                    ])
                )),
                TriageOption(id: "g766", label: "Track", icon: "pawprint.fill", destination: .nextQuestion(
                    TriageNode(id: "g766-q", question: "Select:", options: [
                        TriageOption(id: "g767", label: "Interpreting scat, beds, and feeding damage left by Elk", icon: "pawprint.fill", destination: .technique("food-encyclopedia-sign-elk-wapiti")),
                        TriageOption(id: "g768", label: "Interpreting scat, beds, and feeding damage left by Moo", icon: "pawprint.fill", destination: .technique("food-encyclopedia-sign-moose")),
                        TriageOption(id: "g769", label: "Identifying the physical footprint structure of Caribou", icon: "pawprint.fill", destination: .technique("food-encyclopedia-track-caribou")),
                        TriageOption(id: "g770", label: "Identifying the physical footprint structure of Elk (Wa", icon: "pawprint.fill", destination: .technique("food-encyclopedia-track-elk-wapiti")),
                        TriageOption(id: "g771", label: "Identifying the physical footprint structure of Moose.", icon: "pawprint.fill", destination: .technique("food-encyclopedia-track-moose"))
                    ])
                )),
                TriageOption(id: "g772", label: "Scat", icon: "pawprint.fill", destination: .nextQuestion(
                    TriageNode(id: "g772-q", question: "Select:", options: [
                        TriageOption(id: "g773", label: "Interpreting scat, beds, and feeding damage left by Bis", icon: "pawprint.fill", destination: .technique("food-encyclopedia-sign-bison")),
                        TriageOption(id: "g774", label: "Interpreting scat, beds, and feeding damage left by Bla", icon: "pawprint.fill", destination: .technique("food-encyclopedia-sign-black-bear")),
                        TriageOption(id: "g775", label: "Interpreting scat, beds, and feeding damage left by Car", icon: "pawprint.fill", destination: .technique("food-encyclopedia-sign-caribou")),
                        TriageOption(id: "g776", label: "Identifying the physical footprint structure of Bison.", icon: "pawprint.fill", destination: .technique("food-encyclopedia-track-bison")),
                        TriageOption(id: "g777", label: "Identifying the physical footprint structure of Black B", icon: "pawprint.fill", destination: .technique("food-encyclopedia-track-black-bear"))
                    ])
                )),
                TriageOption(id: "g778", label: "Track (2)", icon: "pawprint.fill", destination: .nextQuestion(
                    TriageNode(id: "g778-q", question: "Select:", options: [
                        TriageOption(id: "g779", label: "Interpreting scat, beds, and feeding damage left by Cou", icon: "pawprint.fill", destination: .technique("food-encyclopedia-sign-cougar-mountain-lion")),
                        TriageOption(id: "g780", label: "Interpreting scat, beds, and feeding damage left by Gri", icon: "pawprint.fill", destination: .technique("food-encyclopedia-sign-grizzly-bear")),
                        TriageOption(id: "g781", label: "Identifying the physical footprint structure of Bobcat.", icon: "pawprint.fill", destination: .technique("food-encyclopedia-track-bobcat")),
                        TriageOption(id: "g782", label: "Identifying the physical footprint structure of Cougar ", icon: "pawprint.fill", destination: .technique("food-encyclopedia-track-cougar-mountain-lion")),
                        TriageOption(id: "g783", label: "Identifying the physical footprint structure of Grizzly", icon: "pawprint.fill", destination: .technique("food-encyclopedia-track-grizzly-bear"))
                    ])
                )),
                TriageOption(id: "g784", label: "Scat (2)", icon: "pawprint.fill", destination: .nextQuestion(
                    TriageNode(id: "g784-q", question: "Select:", options: [
                        TriageOption(id: "g785", label: "Interpreting scat, beds, and feeding damage left by Bob", icon: "pawprint.fill", destination: .technique("food-encyclopedia-sign-bobcat")),
                        TriageOption(id: "g786", label: "Interpreting scat, beds, and feeding damage left by Gra", icon: "pawprint.fill", destination: .technique("food-encyclopedia-sign-gray-wolf")),
                        TriageOption(id: "g787", label: "Interpreting scat, beds, and feeding damage left by Lyn", icon: "pawprint.fill", destination: .technique("food-encyclopedia-sign-lynx")),
                        TriageOption(id: "g788", label: "Identifying the physical footprint structure of Gray Wo", icon: "pawprint.fill", destination: .technique("food-encyclopedia-track-gray-wolf")),
                        TriageOption(id: "g789", label: "Identifying the physical footprint structure of Lynx.", icon: "pawprint.fill", destination: .technique("food-encyclopedia-track-lynx"))
                    ])
                )),
                TriageOption(id: "g790", label: "Track (3)", icon: "pawprint.fill", destination: .nextQuestion(
                    TriageNode(id: "g790-q", question: "Select:", options: [
                        TriageOption(id: "g791", label: "Interpreting scat, beds, and feeding damage left by Coy", icon: "pawprint.fill", destination: .technique("food-encyclopedia-sign-coyote")),
                        TriageOption(id: "g792", label: "Interpreting scat, beds, and feeding damage left by Red", icon: "pawprint.fill", destination: .technique("food-encyclopedia-sign-red-fox")),
                        TriageOption(id: "g793", label: "Identifying the physical footprint structure of Coyote.", icon: "pawprint.fill", destination: .technique("food-encyclopedia-track-coyote")),
                        TriageOption(id: "g794", label: "Identifying the physical footprint structure of Raccoon", icon: "pawprint.fill", destination: .technique("food-encyclopedia-track-raccoon")),
                        TriageOption(id: "g795", label: "Identifying the physical footprint structure of Red Fox", icon: "pawprint.fill", destination: .technique("food-encyclopedia-track-red-fox"))
                    ])
                )),
                TriageOption(id: "g796", label: "Scat (3)", icon: "pawprint.fill", destination: .nextQuestion(
                    TriageNode(id: "g796-q", question: "Select:", options: [
                        TriageOption(id: "g797", label: "Interpreting scat, beds, and feeding damage left by Bea", icon: "pawprint.fill", destination: .technique("food-encyclopedia-sign-beaver")),
                        TriageOption(id: "g798", label: "Interpreting scat, beds, and feeding damage left by Opo", icon: "pawprint.fill", destination: .technique("food-encyclopedia-sign-opossum")),
                        TriageOption(id: "g799", label: "Interpreting scat, beds, and feeding damage left by Rac", icon: "pawprint.fill", destination: .technique("food-encyclopedia-sign-raccoon")),
                        TriageOption(id: "g800", label: "Identifying the physical footprint structure of Beaver.", icon: "pawprint.fill", destination: .technique("food-encyclopedia-track-beaver")),
                        TriageOption(id: "g801", label: "Identifying the physical footprint structure of Opossum", icon: "pawprint.fill", destination: .technique("food-encyclopedia-track-opossum"))
                    ])
                )),
                TriageOption(id: "g802", label: "Track (4)", icon: "pawprint.fill", destination: .nextQuestion(
                    TriageNode(id: "g802-q", question: "Select:", options: [
                        TriageOption(id: "g803", label: "Interpreting scat, beds, and feeding damage left by Por", icon: "pawprint.fill", destination: .technique("food-encyclopedia-sign-porcupine")),
                        TriageOption(id: "g804", label: "Interpreting scat, beds, and feeding damage left by Str", icon: "pawprint.fill", destination: .technique("food-encyclopedia-sign-striped-skunk")),
                        TriageOption(id: "g805", label: "Identifying the physical footprint structure of Badger.", icon: "pawprint.fill", destination: .technique("food-encyclopedia-track-badger")),
                        TriageOption(id: "g806", label: "Identifying the physical footprint structure of Porcupi", icon: "pawprint.fill", destination: .technique("food-encyclopedia-track-porcupine")),
                        TriageOption(id: "g807", label: "Identifying the physical footprint structure of Striped", icon: "pawprint.fill", destination: .technique("food-encyclopedia-track-striped-skunk"))
                    ])
                )),
                TriageOption(id: "g808", label: "Scat (4)", icon: "pawprint.fill", destination: .nextQuestion(
                    TriageNode(id: "g808-q", question: "Select:", options: [
                        TriageOption(id: "g809", label: "Interpreting scat, beds, and feeding damage left by Bad", icon: "pawprint.fill", destination: .technique("food-encyclopedia-sign-badger")),
                        TriageOption(id: "g810", label: "Interpreting scat, beds, and feeding damage left by Fis", icon: "fish.fill", destination: .technique("food-encyclopedia-sign-fisher")),
                        TriageOption(id: "g811", label: "Interpreting scat, beds, and feeding damage left by Wol", icon: "pawprint.fill", destination: .technique("food-encyclopedia-sign-wolverine")),
                        TriageOption(id: "g812", label: "Identifying the physical footprint structure of Fisher.", icon: "fish.fill", destination: .technique("food-encyclopedia-track-fisher")),
                        TriageOption(id: "g813", label: "Identifying the physical footprint structure of Wolveri", icon: "pawprint.fill", destination: .technique("food-encyclopedia-track-wolverine"))
                    ])
                )),
                TriageOption(id: "g814", label: "Track (5)", icon: "pawprint.fill", destination: .nextQuestion(
                    TriageNode(id: "g814-q", question: "Select:", options: [
                        TriageOption(id: "g815", label: "Interpreting scat, beds, and feeding damage left by Min", icon: "pawprint.fill", destination: .technique("food-encyclopedia-sign-mink")),
                        TriageOption(id: "g816", label: "Interpreting scat, beds, and feeding damage left by Pin", icon: "pawprint.fill", destination: .technique("food-encyclopedia-sign-pine-marten")),
                        TriageOption(id: "g817", label: "Identifying the physical footprint structure of Mink.", icon: "pawprint.fill", destination: .technique("food-encyclopedia-track-mink")),
                        TriageOption(id: "g818", label: "Identifying the physical footprint structure of Pine Ma", icon: "pawprint.fill", destination: .technique("food-encyclopedia-track-pine-marten")),
                        TriageOption(id: "g819", label: "Identifying the physical footprint structure of River O", icon: "pawprint.fill", destination: .technique("food-encyclopedia-track-river-otter"))
                    ])
                )),
                TriageOption(id: "g820", label: "Scat (5)", icon: "pawprint.fill", destination: .nextQuestion(
                    TriageNode(id: "g820-q", question: "Select:", options: [
                        TriageOption(id: "g821", label: "Interpreting scat, beds, and feeding damage left by Riv", icon: "pawprint.fill", destination: .technique("food-encyclopedia-sign-river-otter")),
                        TriageOption(id: "g822", label: "Interpreting scat, beds, and feeding damage left by Sno", icon: "pawprint.fill", destination: .technique("food-encyclopedia-sign-snowshoe-hare")),
                        TriageOption(id: "g823", label: "Interpreting scat, beds, and feeding damage left by Woo", icon: "pawprint.fill", destination: .technique("food-encyclopedia-sign-woodchuck-marmot")),
                        TriageOption(id: "g824", label: "Identifying the physical footprint structure of Snowsho", icon: "pawprint.fill", destination: .technique("food-encyclopedia-track-snowshoe-hare")),
                        TriageOption(id: "g825", label: "Identifying the physical footprint structure of Woodchu", icon: "pawprint.fill", destination: .technique("food-encyclopedia-track-woodchuck-marmot"))
                    ])
                )),
                TriageOption(id: "g826", label: "Muskrat", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g826-q", question: "Select:", options: [
                        TriageOption(id: "g827", label: "Interpreting scat, beds, and feeding damage left by Mus", icon: "pawprint.fill", destination: .technique("food-encyclopedia-sign-muskrat")),
                        TriageOption(id: "g828", label: "Interpreting scat, beds, and feeding damage left by Wil", icon: "pawprint.fill", destination: .technique("food-encyclopedia-sign-wild-boar-feral-hog")),
                        TriageOption(id: "g829", label: "Identifying the physical footprint structure of Muskrat", icon: "pawprint.fill", destination: .technique("food-encyclopedia-track-muskrat")),
                        TriageOption(id: "g830", label: "Identifying the physical footprint structure of Wild Bo", icon: "pawprint.fill", destination: .technique("food-encyclopedia-track-wild-boar-feral-hog"))
                    ])
                ))
                ])
            )),

            TriageOption(id: "g831", label: "Trapping", icon: "target", destination: .nextQuestion(
                TriageNode(id: "g831-q", question: "What specifically?", options: [
                TriageOption(id: "g832", label: "Figure", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g832-q", question: "Select:", options: [
                        TriageOption(id: "g833", label: "Build multiple deadfall trap designs for different prey", icon: "target", destination: .technique("food-deadfall-variations")),
                        TriageOption(id: "g834", label: "The classic mechanical advantage trigger for heavy weig", icon: "target", destination: .technique("food-trap-figure-4-deadfall")),
                        TriageOption(id: "g835", label: "Optimizing trigger sensitivity and bait positioning", icon: "target", destination: .technique("food-figure4-deadfall-bait")),
                        TriageOption(id: "g836", label: "Trigger-based crush trap for rodents", icon: "target", destination: .technique("food-figure-4-deadfall")),
                        TriageOption(id: "g837", label: "A highly sensitive, lightning-fast trigger for small ga", icon: "target", destination: .technique("food-trap-paiute"))
                    ])
                )),
                TriageOption(id: "g838", label: "Hardwood", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g838-q", question: "Select:", options: [
                        TriageOption(id: "g839", label: "Optimizing mechanical trap location for Feral Fowl/Bird", icon: "list.bullet.clipboard.fill", destination: .technique("food-encyclopedia-trap-placement-hardwood-feral")),
                        TriageOption(id: "g840", label: "Optimizing mechanical trap location for Large Rodent wi", icon: "list.bullet.clipboard.fill", destination: .technique("food-encyclopedia-trap-placement-hardwood-large")),
                        TriageOption(id: "g841", label: "Optimizing mechanical trap location for Marmot/Woodchuc", icon: "list.bullet.clipboard.fill", destination: .technique("food-encyclopedia-trap-placement-hardwood-marmot/woodchuck")),
                        TriageOption(id: "g842", label: "Optimizing mechanical trap location for Rabbit/Hare wit", icon: "list.bullet.clipboard.fill", destination: .technique("food-encyclopedia-trap-placement-hardwood-rabbit/hare")),
                        TriageOption(id: "g843", label: "Optimizing mechanical trap location for Small Rodent wi", icon: "list.bullet.clipboard.fill", destination: .technique("food-encyclopedia-trap-placement-hardwood-small"))
                    ])
                )),
                TriageOption(id: "g844", label: "Large", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g844-q", question: "Select:", options: [
                        TriageOption(id: "g845", label: "Optimizing mechanical trap location for Large Rodent wi", icon: "list.bullet.clipboard.fill", destination: .technique("food-encyclopedia-trap-placement-alpine-large")),
                        TriageOption(id: "g846", label: "Optimizing mechanical trap location for Large Rodent wi", icon: "list.bullet.clipboard.fill", destination: .technique("food-encyclopedia-trap-placement-arid-large")),
                        TriageOption(id: "g847", label: "Optimizing mechanical trap location for Large Rodent wi", icon: "list.bullet.clipboard.fill", destination: .technique("food-encyclopedia-trap-placement-coniferous-large")),
                        TriageOption(id: "g848", label: "Optimizing mechanical trap location for Large Rodent wi", icon: "list.bullet.clipboard.fill", destination: .technique("food-encyclopedia-trap-placement-riparian-large"))
                    ])
                )),
                TriageOption(id: "g849", label: "Fowl", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g849-q", question: "Select:", options: [
                        TriageOption(id: "g850", label: "Optimizing mechanical trap location for Feral Fowl/Bird", icon: "list.bullet.clipboard.fill", destination: .technique("food-encyclopedia-trap-placement-alpine-feral")),
                        TriageOption(id: "g851", label: "Optimizing mechanical trap location for Feral Fowl/Bird", icon: "list.bullet.clipboard.fill", destination: .technique("food-encyclopedia-trap-placement-arid-feral")),
                        TriageOption(id: "g852", label: "Optimizing mechanical trap location for Feral Fowl/Bird", icon: "list.bullet.clipboard.fill", destination: .technique("food-encyclopedia-trap-placement-coniferous-feral")),
                        TriageOption(id: "g853", label: "Optimizing mechanical trap location for Feral Fowl/Bird", icon: "list.bullet.clipboard.fill", destination: .technique("food-encyclopedia-trap-placement-riparian-feral"))
                    ])
                )),
                TriageOption(id: "g854", label: "Riparian", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g854-q", question: "Select:", options: [
                        TriageOption(id: "g855", label: "Optimizing mechanical trap location for Marmot/Woodchuc", icon: "list.bullet.clipboard.fill", destination: .technique("food-encyclopedia-trap-placement-riparian-marmot/woodchuck")),
                        TriageOption(id: "g856", label: "Optimizing mechanical trap location for Rabbit/Hare wit", icon: "list.bullet.clipboard.fill", destination: .technique("food-encyclopedia-trap-placement-riparian-rabbit/hare")),
                        TriageOption(id: "g857", label: "Optimizing mechanical trap location for Small Rodent wi", icon: "list.bullet.clipboard.fill", destination: .technique("food-encyclopedia-trap-placement-riparian-small"))
                    ])
                )),
                TriageOption(id: "g858", label: "Snare", icon: "target", destination: .nextQuestion(
                    TriageNode(id: "g858-q", question: "Select:", options: [
                        TriageOption(id: "g859", label: "A pyramid cage trap for capturing birds alive", icon: "target", destination: .technique("food-trap-arapuca")),
                        TriageOption(id: "g860", label: "Attract birds for snaring using calls", icon: "target", destination: .technique("food-bird-call-trap")),
                        TriageOption(id: "g861", label: "Set 10+ snare traps for maximum catch probability", icon: "target", destination: .technique("food-cordage-snare-sets")),
                        TriageOption(id: "g862", label: "Set a snare that allows prey to drag the snare, tiring ", icon: "target", destination: .technique("food-snare-drag-set")),
                        TriageOption(id: "g863", label: "Build a concealed pit trap for medium game", icon: "target", destination: .technique("food-pit-trap-technique"))
                    ])
                )),
                TriageOption(id: "g864", label: "Trap", icon: "target", destination: .nextQuestion(
                    TriageNode(id: "g864-q", question: "Select:", options: [
                        TriageOption(id: "g865", label: "Building a live-capture trap from sticks or a container", icon: "ant.fill", destination: .technique("food-box-trap")),
                        TriageOption(id: "g866", label: "A heavy stone trap guided by brush walls for ground ani", icon: "target", destination: .technique("food-channel-deadfall")),
                        TriageOption(id: "g867", label: "Constructing an in-ground fall trap for medium game", icon: "target", destination: .technique("food-pit-trap")),
                        TriageOption(id: "g868", label: "Hoist an animal into the air to prevent predators from ", icon: "drop.fill", destination: .technique("food-trap-spring-pole")),
                        TriageOption(id: "g869", label: "Catch multiple squirrels descending a tree", icon: "target", destination: .technique("food-squirrel-pole"))
                    ])
                )),
                TriageOption(id: "g870", label: "Snare (2)", icon: "target", destination: .nextQuestion(
                    TriageNode(id: "g870-q", question: "Select:", options: [
                        TriageOption(id: "g871", label: "Passive fish catcher — works while you sleep", icon: "leaf.fill", destination: .technique("food-fish-trap-basket")),
                        TriageOption(id: "g872", label: "Ground-based snare sets for upland birds", icon: "target", destination: .technique("food-bird-snaring")),
                        TriageOption(id: "g873", label: "Maximizing catch rate with proper placement", icon: "target", destination: .technique("food-snare-set-optimization")),
                        TriageOption(id: "g874", label: "Auto-lifting snare that cleanly catches small game", icon: "drop.fill", destination: .technique("food-spring-snare")),
                        TriageOption(id: "g875", label: "Maximize trapping efficiency with systematic placement", icon: "target", destination: .technique("food-trap-line-management"))
                    ])
                )),
                TriageOption(id: "g876", label: "Strategic", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g876-q", question: "Select:", options: [
                        TriageOption(id: "g877", label: "Lifting caught game off the ground to prevent predator ", icon: "drop.fill", destination: .technique("food-trap-wire-snare-lift")),
                        TriageOption(id: "g878", label: "Positioning yourself or traps effectively for Elk (Wapi", icon: "target", destination: .technique("food-encyclopedia-hunt-elk-wapiti")),
                        TriageOption(id: "g879", label: "Positioning yourself or traps effectively for Moose bas", icon: "target", destination: .technique("food-encyclopedia-hunt-moose")),
                        TriageOption(id: "g880", label: "Positioning yourself or traps effectively for Mule Deer", icon: "target", destination: .technique("food-encyclopedia-hunt-mule-deer")),
                        TriageOption(id: "g881", label: "Positioning yourself or traps effectively for Whitetail", icon: "target", destination: .technique("food-encyclopedia-hunt-whitetail-deer"))
                    ])
                )),
                TriageOption(id: "g882", label: "Strategic (2)", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g882-q", question: "Select:", options: [
                        TriageOption(id: "g883", label: "Positioning yourself or traps effectively for Bison bas", icon: "target", destination: .technique("food-encyclopedia-hunt-bison")),
                        TriageOption(id: "g884", label: "Positioning yourself or traps effectively for Black Bea", icon: "target", destination: .technique("food-encyclopedia-hunt-black-bear")),
                        TriageOption(id: "g885", label: "Positioning yourself or traps effectively for Caribou b", icon: "target", destination: .technique("food-encyclopedia-hunt-caribou")),
                        TriageOption(id: "g886", label: "Positioning yourself or traps effectively for Cougar (M", icon: "target", destination: .technique("food-encyclopedia-hunt-cougar-mountain-lion")),
                        TriageOption(id: "g887", label: "Positioning yourself or traps effectively for Grizzly B", icon: "target", destination: .technique("food-encyclopedia-hunt-grizzly-bear"))
                    ])
                )),
                TriageOption(id: "g888", label: "Strategic (3)", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g888-q", question: "Select:", options: [
                        TriageOption(id: "g889", label: "Positioning yourself or traps effectively for Bobcat ba", icon: "target", destination: .technique("food-encyclopedia-hunt-bobcat")),
                        TriageOption(id: "g890", label: "Positioning yourself or traps effectively for Coyote ba", icon: "target", destination: .technique("food-encyclopedia-hunt-coyote")),
                        TriageOption(id: "g891", label: "Positioning yourself or traps effectively for Gray Wolf", icon: "target", destination: .technique("food-encyclopedia-hunt-gray-wolf")),
                        TriageOption(id: "g892", label: "Positioning yourself or traps effectively for Lynx base", icon: "target", destination: .technique("food-encyclopedia-hunt-lynx")),
                        TriageOption(id: "g893", label: "Positioning yourself or traps effectively for Red Fox b", icon: "target", destination: .technique("food-encyclopedia-hunt-red-fox"))
                    ])
                )),
                TriageOption(id: "g894", label: "Strategic (4)", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g894-q", question: "Select:", options: [
                        TriageOption(id: "g895", label: "Positioning yourself or traps effectively for Beaver ba", icon: "target", destination: .technique("food-encyclopedia-hunt-beaver")),
                        TriageOption(id: "g896", label: "Positioning yourself or traps effectively for Opossum b", icon: "target", destination: .technique("food-encyclopedia-hunt-opossum")),
                        TriageOption(id: "g897", label: "Positioning yourself or traps effectively for Porcupine", icon: "target", destination: .technique("food-encyclopedia-hunt-porcupine")),
                        TriageOption(id: "g898", label: "Positioning yourself or traps effectively for Raccoon b", icon: "target", destination: .technique("food-encyclopedia-hunt-raccoon")),
                        TriageOption(id: "g899", label: "Positioning yourself or traps effectively for Striped S", icon: "target", destination: .technique("food-encyclopedia-hunt-striped-skunk"))
                    ])
                )),
                TriageOption(id: "g900", label: "Strategic (5)", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g900-q", question: "Select:", options: [
                        TriageOption(id: "g901", label: "Positioning yourself or traps effectively for Badger ba", icon: "target", destination: .technique("food-encyclopedia-hunt-badger")),
                        TriageOption(id: "g902", label: "Positioning yourself or traps effectively for Fisher ba", icon: "target", destination: .technique("food-encyclopedia-hunt-fisher")),
                        TriageOption(id: "g903", label: "Positioning yourself or traps effectively for Mink base", icon: "target", destination: .technique("food-encyclopedia-hunt-mink")),
                        TriageOption(id: "g904", label: "Positioning yourself or traps effectively for Pine Mart", icon: "target", destination: .technique("food-encyclopedia-hunt-pine-marten")),
                        TriageOption(id: "g905", label: "Positioning yourself or traps effectively for Wolverine", icon: "target", destination: .technique("food-encyclopedia-hunt-wolverine"))
                    ])
                )),
                TriageOption(id: "g906", label: "Strategic (6)", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g906-q", question: "Select:", options: [
                        TriageOption(id: "g907", label: "Positioning yourself or traps effectively for Cottontai", icon: "target", destination: .technique("food-encyclopedia-hunt-cottontail-rabbit")),
                        TriageOption(id: "g908", label: "Positioning yourself or traps effectively for Gray Squi", icon: "target", destination: .technique("food-encyclopedia-hunt-gray-squirrel")),
                        TriageOption(id: "g909", label: "Positioning yourself or traps effectively for Red Squir", icon: "target", destination: .technique("food-encyclopedia-hunt-red-squirrel")),
                        TriageOption(id: "g910", label: "Positioning yourself or traps effectively for River Ott", icon: "target", destination: .technique("food-encyclopedia-hunt-river-otter")),
                        TriageOption(id: "g911", label: "Positioning yourself or traps effectively for Snowshoe ", icon: "target", destination: .technique("food-encyclopedia-hunt-snowshoe-hare"))
                    ])
                )),
                TriageOption(id: "g912", label: "Strategic (7)", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g912-q", question: "Select:", options: [
                        TriageOption(id: "g913", label: "An ultra-sensitive string-trigger deadfall.", icon: "target", destination: .technique("food-trap-paiute-deadfall")),
                        TriageOption(id: "g914", label: "A toggle-release snare that lifts the catch instantly.", icon: "target", destination: .technique("food-trap-promontory-peg")),
                        TriageOption(id: "g915", label: "Positioning yourself or traps effectively for Muskrat b", icon: "target", destination: .technique("food-encyclopedia-hunt-muskrat")),
                        TriageOption(id: "g916", label: "Positioning yourself or traps effectively for Wild Boar", icon: "target", destination: .technique("food-encyclopedia-hunt-wild-boar-feral-hog")),
                        TriageOption(id: "g917", label: "Positioning yourself or traps effectively for Woodchuck", icon: "target", destination: .technique("food-encyclopedia-hunt-woodchuck-marmot"))
                    ])
                )),
                TriageOption(id: "g918", label: "Terrain", icon: "cloud.rain.fill", destination: .nextQuestion(
                    TriageNode(id: "g918-q", question: "Select:", options: [
                        TriageOption(id: "g919", label: "Optimizing mechanical trap location for Rabbit/Hare wit", icon: "list.bullet.clipboard.fill", destination: .technique("food-encyclopedia-trap-placement-arid-rabbit/hare")),
                        TriageOption(id: "g920", label: "Optimizing mechanical trap location for Rabbit/Hare wit", icon: "list.bullet.clipboard.fill", destination: .technique("food-encyclopedia-trap-placement-coniferous-rabbit/hare")),
                        TriageOption(id: "g921", label: "Optimizing mechanical trap location for Small Rodent wi", icon: "list.bullet.clipboard.fill", destination: .technique("food-encyclopedia-trap-placement-alpine-small")),
                        TriageOption(id: "g922", label: "Optimizing mechanical trap location for Small Rodent wi", icon: "list.bullet.clipboard.fill", destination: .technique("food-encyclopedia-trap-placement-arid-small")),
                        TriageOption(id: "g923", label: "Optimizing mechanical trap location for Small Rodent wi", icon: "list.bullet.clipboard.fill", destination: .technique("food-encyclopedia-trap-placement-coniferous-small"))
                    ])
                )),
                TriageOption(id: "g924", label: "Alpine", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g924-q", question: "Select:", options: [
                        TriageOption(id: "g925", label: "Optimizing mechanical trap location for Marmot/Woodchuc", icon: "list.bullet.clipboard.fill", destination: .technique("food-encyclopedia-trap-placement-alpine-marmot/woodchuck")),
                        TriageOption(id: "g926", label: "Optimizing mechanical trap location for Rabbit/Hare wit", icon: "list.bullet.clipboard.fill", destination: .technique("food-encyclopedia-trap-placement-alpine-rabbit/hare"))
                    ])
                ))
                ])
            )),
        ])
    }

}
