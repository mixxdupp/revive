import Foundation

// Auto-generated: buildFoodTriage extracted from ContentDatabase.swift
extension ContentDatabase {
    // =========================================================================
    // =========================================================================
    func buildFoodTriage() -> TriageNode {
        TriageNode(id: "food-root", question: "What do you need?", options: [

            // --- STARVATION RISK ---
            TriageOption(id: "food-starve", label: "Starving (Energy Critical)", icon: "exclamationmark.triangle.fill", destination: .nextQuestion(
                TriageNode(id: "food-starve-q", question: "How long without food?", options: [
                    TriageOption(id: "food-days-3", label: "1-3 Days — Mobile", icon: "clock", destination: .techniqueList(["food-dandelion", "food-cattail", "food-insect-eating"])),
                    TriageOption(id: "food-days-7-mobile", label: "4-7+ Days — Weak but Mobile", icon: "clock.fill", destination: .techniqueList(["food-bone-broth", "food-rationing", "food-seaweed"])),
                    TriageOption(id: "food-days-7-immobile", label: "4-7+ Days — Bedridden", icon: "bed.double.fill", destination: .techniqueList(["food-rationing", "psych-pain-management"])),
                    TriageOption(id: "food-ration", label: "Have Small Amount Left", icon: "bag.fill", destination: .techniqueList(["food-rationing", "food-insect-eating", "food-dandelion"]))
                ])
            )),

            // --- FORAGING ---
            TriageOption(id: "food-forage-cat", label: "Find Plants & Bugs", icon: "leaf.fill", destination: .nextQuestion(
                TriageNode(id: "food-foraging-q", question: "What are you looking for?", options: [
                    TriageOption(id: "food-berries", label: "Berries / Fruit", icon: "leaf.fill", destination: .nextQuestion(
                        TriageNode(id: "food-berry-know", question: "Do you recognize it?", options: [
                            TriageOption(id: "food-berry-yes", label: "Yes — 100% Sure", icon: "checkmark.seal.fill", destination: .technique("food-wild-fruit")),
                            TriageOption(id: "food-berry-no", label: "No / Unsure", icon: "questionmark.circle", destination: .technique("food-universal-edibility")),
                            TriageOption(id: "food-poison-symp", label: "Poisoning Symptoms?", icon: "exclamationmark.triangle.fill", destination: .article("food-article-plant-poisoning"))
                        ])
                    )),
                    TriageOption(id: "food-mushrooms", label: "Mushrooms", icon: "umbrella.fill", destination: .nextQuestion(
                        TriageNode(id: "food-shroom-safety", question: "Are you an expert?", options: [
                            TriageOption(id: "food-shroom-expert", label: "Yes — 100% Sure", icon: "checkmark.seal.fill", destination: .technique("food-mushroom-safety")),
                            TriageOption(id: "food-shroom-no", label: "No / Unsure", icon: "exclamationmark.triangle.fill", destination: .technique("food-avoid-plants"))
                        ])
                    )),
                    TriageOption(id: "food-greens-adv", label: "Greens (Onion / Cattail / Pine)", icon: "leaf.arrow.circle.path", destination: .techniqueList(["food-dandelion", "food-wild-garlic", "food-wild-onion", "food-pine-bark-flour", "food-cattail"])),
                    TriageOption(id: "food-nuts", label: "Nuts / Acorns", icon: "circle.grid.cross.fill", destination: .technique("food-acorn-processing")),
                    TriageOption(id: "food-coastal", label: "Seaweed (Coastal)", icon: "water.waves", destination: .technique("food-seaweed-harvesting")),
                    TriageOption(id: "food-grub", label: "Insects / Grubs", icon: "ladybug.fill", destination: .technique("food-grub-finding"))
                ])
            )),

            // --- HUNTING / TRAPPING / FISHING ---
            TriageOption(id: "food-hunt-fish-cat", label: "Hunt, Trap & Fish", icon: "hare.fill", destination: .nextQuestion(
                TriageNode(id: "food-hunt-method", question: "What method?", options: [
                    TriageOption(id: "food-trap-deadfall", label: "Deadfall Trap", icon: "triangle.fill", destination: .techniqueList(["food-deadfall-trap"])),
                    TriageOption(id: "food-spear-all", label: "Spear Hunting", icon: "pencil.line", destination: .techniqueList(["food-fish-spear", "food-fish-spearing"])),
                    TriageOption(id: "food-bird-all", label: "Bird Snare (Ojibwe)", icon: "bird.fill", destination: .techniqueList(["food-bird-trap", "food-bird-snare", "food-bird-snare-ojibwe"])),
                    TriageOption(id: "food-fish-hook", label: "Fish Hook / Line", icon: "pencil.slash", destination: .technique("food-hook-line")),
                    TriageOption(id: "food-crayfish", label: "Water Trap (Crayfish)", icon: "circle.grid.cross.fill", destination: .techniqueList(["food-crayfish-trap", "food-crayfish"]))
                ])
            )),

            // --- PREP & COOKING ---
            TriageOption(id: "food-prep", label: "Cooking & Preservation", icon: "flame", destination: .nextQuestion(
                TriageNode(id: "food-prep-q", question: "What do you need to do?", options: [
                    TriageOption(id: "food-pemmican", label: "Make Pemmican / Preserve", icon: "archivebox.fill", destination: .techniqueList(["food-pemmican-making", "food-preservation"])),
                    TriageOption(id: "food-cooking-rocks", label: "Boil With Rocks / Clay Pot", icon: "drop.fill", destination: .techniqueList(["food-boiling-rocks", "food-clay-pot-cooking"])),
                    TriageOption(id: "food-clean-game", label: "Skin / Gut Game", icon: "hare.fill", destination: .techniqueList(["food-small-game-cleaning", "food-animal-skinning"])),
                    TriageOption(id: "food-cook-fire", label: "Cook on Fire", icon: "flame", destination: .techniqueList(["food-cooking-fire", "food-earth-oven"])),
                    TriageOption(id: "food-preserve-smoke", label: "Smoke / Dry Meat", icon: "smoke.fill", destination: .techniqueList(["food-smoking-meat", "food-jerky-no-salt"]))
                ])
            )),

            // View Related Articles
            TriageOption(id: "food-learn", label: "Learn More", icon: "book.fill", destination: .nextQuestion(
                TriageNode(id: "food-learn-q", question: "What would you like to read about?", options: [
                    TriageOption(id: "food-art-health", label: "Nutrition & Starvation", icon: "leaf.fill", destination: .articleList(["food-article-nutrition", "food-article-calories", "food-article-starvation", "food-article-deficiencies", "food-article-protein-hierarchy"])),
                    TriageOption(id: "food-art-plants", label: "Wild Edible Plants", icon: "leaf.arrow.circlepath", destination: .article("food-article-wild-plants")),
                    TriageOption(id: "food-art-poisonous", label: "Poisonous Plants", icon: "xmark.octagon.fill", destination: .articleList(["food-article-poisonous", "food-article-plant-poisoning"])),
                    TriageOption(id: "food-art-insects", label: "Edible Insects", icon: "ant.fill", destination: .article("food-article-insects")),
                    TriageOption(id: "food-art-howto", label: "Fishing, Trapping, Cooking", icon: "hare.fill", destination: .articleList(["food-article-fishing", "food-article-trapping", "food-article-cooking-methods", "food-article-preservation", "food-article-long-preservation", "food-article-safety"]))
                ])
            ))
        ])
    }

}
