import Foundation

// Auto-generated: buildWaterTriage extracted from ContentDatabase.swift
extension ContentDatabase {
    // =========================================================================
    // MARK: - NEED WATER (5 levels deep)
    // =========================================================================
    func buildWaterTriage() -> TriageNode {
        TriageNode(id: "water-root", question: "What environment are you in?", options: [

            // Near water source
            TriageOption(id: "water-stream", label: "Near Stream / River / Lake", icon: "water.waves", destination: .nextQuestion(
                TriageNode(id: "water-flow-q", question: "Is the water moving?", options: [
                    TriageOption(id: "water-flow-yes", label: "Yes — Flowing Stream", icon: "water.waves", destination: .nextQuestion(
                        TriageNode(id: "water-clarity", question: "Is the water clear or murky?", options: [
                            TriageOption(id: "water-clear", label: "Clear / Running", icon: "drop.fill", destination: .nextQuestion(
                        TriageNode(id: "water-purify", question: "How can you purify it?", options: [
                            TriageOption(id: "water-store", label: "Storage / Transport", icon: "bag.fill", destination: .nextQuestion(
                                TriageNode(id: "water-store-q", question: "Container type?", options: [
                                    TriageOption(id: "water-store-hacks", label: "Improvised Options", icon: "lightbulb.fill", destination: .techniqueList(["water-condom-canteen", "water-transpiration-bag"])), // Phase 5
                                ])
                            )),
                            TriageOption(id: "water-tabs", label: "Have Purification Tablets / Iodine", icon: "pills.fill", destination: .technique("water-iodine")),
                            TriageOption(id: "water-uv", label: "Clear Bottle + Strong Sun", icon: "sun.max.fill", destination: .technique("water-uv-purification")),
                            TriageOption(id: "water-filter-material", label: "Sand / Gravel / Charcoal", icon: "line.3.horizontal.decrease.circle", destination: .techniqueList(["water-charcoal-filter", "water-activated-charcoal"])), // Added orphan
                        ])
                    )),
                    TriageOption(id: "water-rain", label: "Rain / Precipitation", icon: "cloud.rain.fill", destination: .nextQuestion(
                        TriageNode(id: "water-rain-q", question: "How will you catch it?", options: [
                            TriageOption(id: "water-rain-tarp", label: "Tarp / Poncho Catch", icon: "square.fill", destination: .technique("water-tarp-rain-catch")), // Added orphan
                        ])
                    )),
                    TriageOption(id: "water-murky", label: "Murky / Standing / Stagnant", icon: "drop.triangle.fill", destination: .nextQuestion(
                        TriageNode(id: "water-filter-q", question: "Can you pre-filter sediment?", options: [
                            TriageOption(id: "water-pre-cloth", label: "Have Cloth / Fabric", icon: "tshirt.fill", destination: .nextQuestion(
                                TriageNode(id: "water-after-filter", question: "After filtering, can you purify?", options: [
                                ])
                            )),
                        ])
                    ))
                ])
            )),
                ])
            )),

            // Desert / Arid
            TriageOption(id: "water-desert", label: "Desert / Arid Land", icon: "sun.max.fill", destination: .nextQuestion(
                TriageNode(id: "water-desert-q", question: "What resources are available?", options: [
                    TriageOption(id: "water-plastic", label: "Plastic Sheet / Bag", icon: "bag.fill", destination: .technique("water-solar-still")),
                    TriageOption(id: "water-plants", label: "Vegetation Nearby", icon: "leaf.fill", destination: .nextQuestion(
                        TriageNode(id: "water-veg", question: "What type of vegetation?", options: [
                            TriageOption(id: "water-trees", label: "Trees / Bushes with Leaves", icon: "tree.fill", destination: .techniqueList(["water-transpiration-bag", "food-pine-tea"])), // Added orphan
                            TriageOption(id: "water-cactus", label: "Barrel Cactus / Succulents", icon: "leaf.fill", destination: .techniqueList(["water-vegetation-indicators", "water-cactus-extraction"])), // Added orphan
                        ])
                    )),
                    TriageOption(id: "water-rock-face", label: "Rock Faces Nearby", icon: "triangle.fill", destination: .techniqueList(["water-rock-seepage", "water-spring-identification"])), // Added orphan
                    TriageOption(id: "water-barren", label: "Nothing — Barren", icon: "xmark.circle.fill", destination: .techniqueList(["water-solar-still", "water-well-digging"])), // Added orphan
                    TriageOption(id: "water-fog", label: "High Altitude / Coastal Fog", icon: "cloud.fog.fill", destination: .technique("water-fog-nets")) // Orphan
                ])
            )),

            // Snow / Ice
            TriageOption(id: "water-snow", label: "Snow / Ice Available", icon: "snowflake", destination: .nextQuestion(
                TriageNode(id: "water-snow-q", question: "Can you make fire?", options: [
                    TriageOption(id: "water-snow-fire", label: "Yes — Can Melting Snow", icon: "flame", destination: .technique("water-snow-melting")), // Fixed from water-snow-ice
                ])
            )),

            // At Sea / Coastal
            TriageOption(id: "water-ocean", label: "At Sea / Coastal", icon: "sailboat.fill", destination: .nextQuestion(
                TriageNode(id: "water-sea-q", question: "What's available?", options: [
                    TriageOption(id: "water-sea-desal", label: "Desalination Kit / Solar Still", icon: "spigot.fill", destination: .technique("water-desalination")), // Orphan
                    TriageOption(id: "water-sea-seaweed", label: "Seawater Only", icon: "drop.fill", destination: .technique("water-seawater")),
                    TriageOption(id: "water-coastal-forage", label: "On Shore — Can Explore", icon: "figure.walk", destination: .techniqueList(["water-rain-collection", "water-rock-seepage", "water-dew-collection"]))
                ])
            )),

            // Jungle / Tropical
            TriageOption(id: "water-jungle", label: "Jungle / Tropical", icon: "leaf.fill", destination: .nextQuestion(
                TriageNode(id: "water-jungle-q", question: "What's around you?", options: [
                    TriageOption(id: "water-bamboo", label: "Bamboo", icon: "leaf.fill", destination: .technique("water-bamboo-collection")),
                    TriageOption(id: "water-banana", label: "Banana Plants", icon: "leaf.fill", destination: .technique("water-banana-plant")), // Added orphan
                    TriageOption(id: "water-vines", label: "Vines / Lianas", icon: "line.diagonal", destination: .techniqueList(["water-vegetation-indicators", "water-vine-extraction"])), // Added orphan
                    TriageOption(id: "water-fruits", label: "Coconuts / Fruits", icon: "circle.fill", destination: .technique("water-from-fruits")), // Added orphan
                    TriageOption(id: "water-birch", label: "Birch / Maple Trees", icon: "tree.fill", destination: .technique("water-birch-tapping")),
                    TriageOption(id: "water-transpire-enhance", label: "Broad-Leaf Trees (Enhanced)", icon: "tree.circle.fill", destination: .technique("water-transpiration-enhanced")), // Orphan
                ])
            )),

            // Urban
            TriageOption(id: "water-urban", label: "Urban Area", icon: "building.2.fill", destination: .nextQuestion(
                TriageNode(id: "water-urban-q", question: "What sources exist?", options: [
                    TriageOption(id: "water-urban-store", label: "Need to Store / Ration", icon: "drop.fill", destination: .technique("water-storage"))
                ])
            )),

            // Water Testing & Safety
            TriageOption(id: "water-test", label: "Water Testing & Safety", icon: "checkmark.shield.fill", destination: .nextQuestion(
                TriageNode(id: "water-test-q", question: "What do you need?", options: [
                    TriageOption(id: "water-test-quality", label: "Test Water Quality", icon: "eyedropper.halffull", destination: .technique("water-testing")),
                    TriageOption(id: "water-test-coconut", label: "Coconut Water Safety", icon: "circle.fill", destination: .technique("water-coconut-safety")),
                    TriageOption(id: "water-test-electrolyte", label: "Make Electrolyte Solution", icon: "cup.and.saucer.fill", destination: .technique("water-electrolyte-solution"))
                ])
            )),

            // Advanced Filtration
            TriageOption(id: "water-adv-filter", label: "Advanced Filtration", icon: "line.3.horizontal.decrease.circle.fill", destination: .nextQuestion(
                TriageNode(id: "water-adv-q", question: "What materials do you have?", options: [
                    TriageOption(id: "water-biosand", label: "Sand & Gravel (Bio-Sand)", icon: "square.3.layers.3d.down.right.fill", destination: .technique("water-bio-sand-filter")),
                    TriageOption(id: "water-claypot", label: "Clay Available (Pot Filter)", icon: "cylinder.fill", destination: .technique("water-clay-pot-filter")),
                ])
            )),

            // Emergency Water Sources
            TriageOption(id: "water-emergency", label: "Emergency Water Sources", icon: "exclamationmark.triangle.fill", destination: .nextQuestion(
                TriageNode(id: "water-emerg-q", question: "What's available?", options: [
                    TriageOption(id: "water-emerg-sources", label: "Overview of All Sources", icon: "list.bullet", destination: .technique("water-emergency-sources")),
                    TriageOption(id: "water-emerg-underground", label: "Underground Seep / Dig", icon: "arrow.down.circle.fill", destination: .technique("water-underground-seep")),
                    TriageOption(id: "water-emerg-animal", label: "Follow Animal Indicators", icon: "pawprint.fill", destination: .technique("water-animal-indicators")),
                    TriageOption(id: "water-emerg-dew", label: "Morning Dew (Drag Cloth)", icon: "sunrise.fill", destination: .technique("water-morning-dew-drag")),
                    TriageOption(id: "water-emerg-seaice", label: "Old Sea Ice (Desalinated)", icon: "snowflake", destination: .technique("water-seawater-ice"))
                ])
            )),

            // Container & Collection
            TriageOption(id: "water-container", label: "Container & Collection", icon: "mug.fill", destination: .nextQuestion(
                TriageNode(id: "water-cont-q", question: "What do you need?", options: [
                    TriageOption(id: "water-cont-birch", label: "Birch Bark Container", icon: "tree.fill", destination: .technique("water-birch-container")),
                    TriageOption(id: "water-cont-poncho", label: "Poncho / Tarp Rain Catch", icon: "cloud.rain.fill", destination: .technique("water-poncho-rain-catch")),
                    TriageOption(id: "water-cont-altitude", label: "Boiling at High Altitude", icon: "mountain.2.fill", destination: .technique("water-altitude-boiling"))
                ])
            )),

            // 📚 LEARN MORE
            TriageOption(id: "water-learn", label: "Learn More", icon: "book.fill", destination: .nextQuestion(
                TriageNode(id: "water-learn-q", question: "What would you like to read about?", options: [
                    TriageOption(id: "water-art-finding", label: "Finding Water Sources", icon: "drop.fill", destination: .article("water-article-finding")),
                    TriageOption(id: "water-art-signs", label: "Signs of Water Nearby", icon: "binoculars.fill", destination: .article("water-article-signs")),
                    TriageOption(id: "water-art-purify", label: "Purification Methods", icon: "arrow.3.trianglepath", destination: .article("water-article-purification")),
                    TriageOption(id: "water-art-filter", label: "Filter vs Purifier", icon: "line.3.horizontal.decrease", destination: .article("water-article-filter-vs-purify")),
                    TriageOption(id: "water-art-contam", label: "Water Contamination", icon: "exclamationmark.triangle.fill", destination: .article("water-article-contamination")),
                    TriageOption(id: "water-art-diseases", label: "Waterborne Diseases", icon: "microbe.fill", destination: .article("water-article-diseases")),
                    TriageOption(id: "water-art-testing", label: "Water Testing", icon: "flask.fill", destination: .article("water-article-testing")),
                    TriageOption(id: "water-art-dehydration", label: "Dehydration Management", icon: "person.fill", destination: .article("water-article-dehydration")),
                    TriageOption(id: "water-art-rationing", label: "Water Rationing", icon: "gauge.with.dots.needle.33percent", destination: .article("water-article-rationing")),
                    TriageOption(id: "water-art-desert", label: "Desert Water Sources", icon: "sun.max.fill", destination: .articleList(["water-article-desert", "water-article-desert-survival"])),
                    TriageOption(id: "water-art-rain", label: "Rainwater Collection", icon: "cloud.rain.fill", destination: .article("water-article-rainwater")),
                    TriageOption(id: "water-art-ice", label: "Ice & Snow Water", icon: "snowflake", destination: .article("water-article-ice-snow")),
                    TriageOption(id: "water-art-storage", label: "Water Storage", icon: "cylinder.fill", destination: .article("water-article-storage")),
                    TriageOption(id: "water-art-ocean", label: "Ocean Water Survival", icon: "water.waves", destination: .article("water-article-oceansurv")),
                    TriageOption(id: "water-art-winter", label: "Winter Water", icon: "thermometer.snowflake", destination: .article("water-article-winter"))
                ])
            )),

            TriageOption(id: "g2894", label: "Collecting Water", icon: "cross.case.fill", destination: .nextQuestion(
                TriageNode(id: "g2894-q", question: "What specifically?", options: [
                TriageOption(id: "g2895", label: "Vegetation", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g2895-q", question: "Select:", options: [
                        TriageOption(id: "g2896", label: "Finding groundwater near surface indicators", icon: "drop.fill", destination: .technique("water-well-digging-technique")),
                        TriageOption(id: "g2897", label: "Harvest water from fog and mist using mesh screens", icon: "fish.fill", destination: .technique("water-fog-collection")),
                        TriageOption(id: "g2898", label: "Extract water from dirt and vegetation using evaporatio", icon: "sun.max.fill", destination: .technique("water-solar-still-pit"))
                    ])
                )),
                TriageOption(id: "g2899", label: "Cactus", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g2899-q", question: "Select:", options: [
                        TriageOption(id: "g2900", label: "Extract moisture from succulent plants in desert surviv", icon: "leaf.fill", destination: .technique("water-cactus-water-extraction")),
                        TriageOption(id: "g2901", label: "Extracting moisture from Opuntia cactus", icon: "cross.case.fill", destination: .technique("water-prickly-pear-water")),
                        TriageOption(id: "g2902", label: "Myths and realities of getting water from cacti", icon: "sun.max.fill", destination: .technique("water-agave-cactus-safe"))
                    ])
                )),
                TriageOption(id: "g2903", label: "Groundwater", icon: "drop.fill", destination: .nextQuestion(
                    TriageNode(id: "g2903-q", question: "Select:", options: [
                        TriageOption(id: "g2904", label: "Locate reliable groundwater sources using terrain clues", icon: "cloud.rain.fill", destination: .technique("water-spring-finding")),
                        TriageOption(id: "g2905", label: "Access groundwater with minimal tools", icon: "drop.fill", destination: .technique("water-well-drilling-hand"))
                    ])
                )),
                TriageOption(id: "g2906", label: "Green", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g2906-q", question: "Select:", options: [
                        TriageOption(id: "g2907", label: "Nature's isotonic sports drink — available across tropi", icon: "cross.case.fill", destination: .technique("water-coconut-water")),
                        TriageOption(id: "g2908", label: "Trees pump water from the ground — collect it with a ba", icon: "cross.case.fill", destination: .technique("water-tree-bag-transpiration"))
                    ])
                )),
                TriageOption(id: "g2909", label: "Birch", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g2909-q", question: "Select:", options: [
                        TriageOption(id: "g2910", label: "Slightly sweet drinkable water directly from birch tree", icon: "drop.fill", destination: .technique("water-birch-sap")),
                        TriageOption(id: "g2911", label: "Harvesting safe, hydrating tree sap in springtime", icon: "ant.fill", destination: .technique("water-tree-tapping-birch"))
                    ])
                )),
                TriageOption(id: "g2912", label: "Water", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g2912-q", question: "Select:", options: [
                        TriageOption(id: "g2913", label: "Systematic morning dew collection", icon: "cloud.rain.fill", destination: .technique("water-morning-dew-mop")),
                        TriageOption(id: "g2914", label: "Above-ground solar distillation using a tripod", icon: "sun.max.fill", destination: .technique("water-solar-still-tripod")),
                        TriageOption(id: "g2915", label: "Maximizing rain catch with a poncho", icon: "cloud.rain.fill", destination: .technique("water-rain-poncho-collection")),
                        TriageOption(id: "g2916", label: "Harvest water from rock faces and cliff seeps", icon: "drop.fill", destination: .technique("water-rock-seep-collection")),
                        TriageOption(id: "g2917", label: "Cutting tropical vines for drinking water", icon: "leaf.fill", destination: .technique("water-water-vine-identification"))
                    ])
                ))
                ])
            )),

            TriageOption(id: "g2918", label: "Finding Water", icon: "cross.case.fill", destination: .nextQuestion(
                TriageNode(id: "g2918-q", question: "What specifically?", options: [
                TriageOption(id: "g2919", label: "Find", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g2919-q", question: "Select:", options: [
                        TriageOption(id: "g2920", label: "Find fresh water at the ocean beach", icon: "drop.fill", destination: .technique("water-beach-well")),
                        TriageOption(id: "g2921", label: "Channel rain and dew using large tropical leaves", icon: "cloud.rain.fill", destination: .technique("water-banana-leaf-funnel")),
                        TriageOption(id: "g2922", label: "Find hidden springs using terrain and vegetation clues", icon: "cloud.rain.fill", destination: .technique("water-natural-spring-signs")),
                        TriageOption(id: "g2923", label: "Collect rainwater using natural rock features", icon: "cloud.rain.fill", destination: .technique("water-rock-catchment")),
                        TriageOption(id: "g2924", label: "Enhance a natural water seep into a usable spring", icon: "cloud.rain.fill", destination: .technique("water-seep-improvement")),
                        TriageOption(id: "g2925", label: "Harvest water from tree branches using a plastic bag", icon: "cross.case.fill", destination: .technique("water-vegtube-transpiration"))
                    ])
                )),
                TriageOption(id: "g2926", label: "Locate", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g2926-q", question: "Select:", options: [
                        TriageOption(id: "g2927", label: "Filtering swamp/mud water safely", icon: "drop.fill", destination: .technique("water-gypsy-well")),
                        TriageOption(id: "g2928", label: "Finding freshwater directly on a saltwater beach.", icon: "drop.fill", destination: .technique("water-procure-beach-seep")),
                        TriageOption(id: "g2929", label: "Drinking water from frozen sea ice", icon: "water.waves", destination: .technique("water-ice-desalination")),
                        TriageOption(id: "g2930", label: "Draining 40-80 gallons of pristine water from a defunct", icon: "cloud.rain.fill", destination: .technique("water-water-heater-extraction"))
                    ])
                )),
                TriageOption(id: "g2931", label: "Bamboo", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g2931-q", question: "Select:", options: [
                        TriageOption(id: "g2932", label: "Adapting the bamboo node extraction technique specifica", icon: "cross.case.fill", destination: .technique("water-encyclopedia-procure-alpine-bamboo-node-extraction")),
                        TriageOption(id: "g2933", label: "Adapting the bamboo node extraction technique specifica", icon: "cross.case.fill", destination: .technique("water-encyclopedia-procure-coastal-bamboo-node-extraction")),
                        TriageOption(id: "g2934", label: "Adapting the bamboo node extraction technique specifica", icon: "sun.max.fill", destination: .technique("water-encyclopedia-procure-desert-bamboo-node-extraction")),
                        TriageOption(id: "g2935", label: "Adapting the bamboo node extraction technique specifica", icon: "leaf.fill", destination: .technique("water-encyclopedia-procure-jungle-bamboo-node-extraction")),
                        TriageOption(id: "g2936", label: "Adapting the bamboo node extraction technique specifica", icon: "cross.case.fill", destination: .technique("water-encyclopedia-procure-swamp-marsh-bamboo-node-extraction")),
                        TriageOption(id: "g2937", label: "Adapting the bamboo node extraction technique specifica", icon: "cross.case.fill", destination: .technique("water-encyclopedia-procure-temperate-forest-bamboo-node-extraction"))
                    ])
                )),
                TriageOption(id: "g2938", label: "Tree", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g2938-q", question: "Select:", options: [
                        TriageOption(id: "g2939", label: "Full tapping technique for sap water", icon: "location.north.fill", destination: .technique("water-maple-birch-tapping")),
                        TriageOption(id: "g2940", label: "Tap trees for clean, drinkable sap", icon: "drop.fill", destination: .technique("water-sap-hydration"))
                    ])
                )),
                TriageOption(id: "g2941", label: "Trap", icon: "target", destination: .nextQuestion(
                    TriageNode(id: "g2941-q", question: "Select:", options: [
                        TriageOption(id: "g2942", label: "Adapting the dew collection trap technique specifically", icon: "cloud.rain.fill", destination: .technique("water-encyclopedia-procure-alpine-dew-collection-trap")),
                        TriageOption(id: "g2943", label: "Adapting the dew collection trap technique specifically", icon: "cloud.rain.fill", destination: .technique("water-encyclopedia-procure-coastal-dew-collection-trap")),
                        TriageOption(id: "g2944", label: "Adapting the dew collection trap technique specifically", icon: "cloud.rain.fill", destination: .technique("water-encyclopedia-procure-desert-dew-collection-trap")),
                        TriageOption(id: "g2945", label: "Adapting the dew collection trap technique specifically", icon: "cloud.rain.fill", destination: .technique("water-encyclopedia-procure-jungle-dew-collection-trap")),
                        TriageOption(id: "g2946", label: "Adapting the dew collection trap technique specifically", icon: "cloud.rain.fill", destination: .technique("water-encyclopedia-procure-swamp-marsh-dew-collection-trap")),
                        TriageOption(id: "g2947", label: "Adapting the dew collection trap technique specifically", icon: "cloud.rain.fill", destination: .technique("water-encyclopedia-procure-temperate-forest-dew-collection-trap")),
                        TriageOption(id: "g2948", label: "Maximize dew collection with engineered surfaces", icon: "cloud.rain.fill", destination: .technique("water-dew-trap"))
                    ])
                )),
                TriageOption(id: "g2949", label: "Water", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g2949-q", question: "Select:", options: [
                        TriageOption(id: "g2950", label: "Harvest water from fog using mesh nets", icon: "fish.fill", destination: .technique("water-fog-fence")),
                        TriageOption(id: "g2951", label: "Safely melt ice and snow for drinking water", icon: "sun.max.fill", destination: .technique("water-ice-melting-technique")),
                        TriageOption(id: "g2952", label: "Maximize rainwater collection with large-scale tarp sys", icon: "cloud.rain.fill", destination: .technique("water-rain-tarp-mega")),
                        TriageOption(id: "g2953", label: "Adapting the transpiration bag technique specifically f", icon: "sun.max.fill", destination: .technique("water-encyclopedia-procure-desert-transpiration-bag")),
                        TriageOption(id: "g2954", label: "Extract water from a vehicle in an emergency", icon: "cloud.fill", destination: .technique("water-vehicle-water-sources"))
                    ])
                )),
                TriageOption(id: "g2955", label: "Transpiration", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g2955-q", question: "Select:", options: [
                        TriageOption(id: "g2956", label: "Adapting the transpiration bag technique specifically f", icon: "cross.case.fill", destination: .technique("water-encyclopedia-procure-alpine-transpiration-bag")),
                        TriageOption(id: "g2957", label: "Adapting the transpiration bag technique specifically f", icon: "snowflake", destination: .technique("water-encyclopedia-procure-arctic-transpiration-bag")),
                        TriageOption(id: "g2958", label: "Adapting the transpiration bag technique specifically f", icon: "cross.case.fill", destination: .technique("water-encyclopedia-procure-coastal-transpiration-bag")),
                        TriageOption(id: "g2959", label: "Adapting the transpiration bag technique specifically f", icon: "leaf.fill", destination: .technique("water-encyclopedia-procure-jungle-transpiration-bag")),
                        TriageOption(id: "g2960", label: "Adapting the transpiration bag technique specifically f", icon: "cross.case.fill", destination: .technique("water-encyclopedia-procure-temperate-forest-transpiration-bag"))
                    ])
                )),
                TriageOption(id: "g2961", label: "Solar", icon: "sun.max.fill", destination: .nextQuestion(
                    TriageNode(id: "g2961-q", question: "Select:", options: [
                        TriageOption(id: "g2962", label: "Adapting the solar still technique specifically for alp", icon: "sun.max.fill", destination: .technique("water-encyclopedia-procure-alpine-solar-still")),
                        TriageOption(id: "g2963", label: "Adapting the solar still technique specifically for arc", icon: "sun.max.fill", destination: .technique("water-encyclopedia-procure-arctic-solar-still")),
                        TriageOption(id: "g2964", label: "Adapting the solar still technique specifically for des", icon: "sun.max.fill", destination: .technique("water-encyclopedia-procure-desert-solar-still")),
                        TriageOption(id: "g2965", label: "Adapting the solar still technique specifically for jun", icon: "sun.max.fill", destination: .technique("water-encyclopedia-procure-jungle-solar-still")),
                        TriageOption(id: "g2966", label: "Adapting the transpiration bag technique specifically f", icon: "cross.case.fill", destination: .technique("water-encyclopedia-procure-swamp-marsh-transpiration-bag"))
                    ])
                )),
                TriageOption(id: "g2967", label: "Solar (2)", icon: "sun.max.fill", destination: .nextQuestion(
                    TriageNode(id: "g2967-q", question: "Select:", options: [
                        TriageOption(id: "g2968", label: "Adapting the rock/crevice siphoning technique specifica", icon: "snowflake", destination: .technique("water-encyclopedia-procure-arctic-rock-crevice-siphoning")),
                        TriageOption(id: "g2969", label: "Adapting the rock/crevice siphoning technique specifica", icon: "sun.max.fill", destination: .technique("water-encyclopedia-procure-desert-rock-crevice-siphoning")),
                        TriageOption(id: "g2970", label: "Adapting the solar still technique specifically for coa", icon: "sun.max.fill", destination: .technique("water-encyclopedia-procure-coastal-solar-still")),
                        TriageOption(id: "g2971", label: "Adapting the solar still technique specifically for swa", icon: "sun.max.fill", destination: .technique("water-encyclopedia-procure-swamp-marsh-solar-still")),
                        TriageOption(id: "g2972", label: "Adapting the solar still technique specifically for tem", icon: "sun.max.fill", destination: .technique("water-encyclopedia-procure-temperate-forest-solar-still"))
                    ])
                )),
                TriageOption(id: "g2973", label: "Rock", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g2973-q", question: "Select:", options: [
                        TriageOption(id: "g2974", label: "Adapting the rock/crevice siphoning technique specifica", icon: "cross.case.fill", destination: .technique("water-encyclopedia-procure-alpine-rock-crevice-siphoning")),
                        TriageOption(id: "g2975", label: "Adapting the rock/crevice siphoning technique specifica", icon: "cross.case.fill", destination: .technique("water-encyclopedia-procure-coastal-rock-crevice-siphoning")),
                        TriageOption(id: "g2976", label: "Adapting the rock/crevice siphoning technique specifica", icon: "leaf.fill", destination: .technique("water-encyclopedia-procure-jungle-rock-crevice-siphoning")),
                        TriageOption(id: "g2977", label: "Adapting the rock/crevice siphoning technique specifica", icon: "cross.case.fill", destination: .technique("water-encyclopedia-procure-swamp-marsh-rock-crevice-siphoning")),
                        TriageOption(id: "g2978", label: "Adapting the rock/crevice siphoning technique specifica", icon: "cross.case.fill", destination: .technique("water-encyclopedia-procure-temperate-forest-rock-crevice-siphoning"))
                    ])
                )),
                TriageOption(id: "g2979", label: "Desalination", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g2979-q", question: "Select:", options: [
                        TriageOption(id: "g2980", label: "Adapting the ice desalination technique specifically fo", icon: "cross.case.fill", destination: .technique("water-encyclopedia-procure-alpine-ice-desalination")),
                        TriageOption(id: "g2981", label: "Adapting the ice desalination technique specifically fo", icon: "snowflake", destination: .technique("water-encyclopedia-procure-arctic-ice-desalination")),
                        TriageOption(id: "g2982", label: "Adapting the ice desalination technique specifically fo", icon: "cross.case.fill", destination: .technique("water-encyclopedia-procure-coastal-ice-desalination")),
                        TriageOption(id: "g2983", label: "Adapting the ice desalination technique specifically fo", icon: "sun.max.fill", destination: .technique("water-encyclopedia-procure-desert-ice-desalination")),
                        TriageOption(id: "g2984", label: "Adapting the ice desalination technique specifically fo", icon: "cross.case.fill", destination: .technique("water-encyclopedia-procure-temperate-forest-ice-desalination"))
                    ])
                )),
                TriageOption(id: "g2985", label: "Grapevine", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g2985-q", question: "Select:", options: [
                        TriageOption(id: "g2986", label: "Adapting the grapevine tapping technique specifically f", icon: "cross.case.fill", destination: .technique("water-encyclopedia-procure-alpine-grapevine-tapping")),
                        TriageOption(id: "g2987", label: "Adapting the grapevine tapping technique specifically f", icon: "snowflake", destination: .technique("water-encyclopedia-procure-arctic-grapevine-tapping")),
                        TriageOption(id: "g2988", label: "Adapting the grapevine tapping technique specifically f", icon: "sun.max.fill", destination: .technique("water-encyclopedia-procure-desert-grapevine-tapping")),
                        TriageOption(id: "g2989", label: "Adapting the grapevine tapping technique specifically f", icon: "leaf.fill", destination: .technique("water-encyclopedia-procure-jungle-grapevine-tapping")),
                        TriageOption(id: "g2990", label: "Adapting the ice desalination technique specifically fo", icon: "cross.case.fill", destination: .technique("water-encyclopedia-procure-swamp-marsh-ice-desalination"))
                    ])
                )),
                TriageOption(id: "g2991", label: "Grapevine (2)", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g2991-q", question: "Select:", options: [
                        TriageOption(id: "g2992", label: "Adapting the grapevine tapping technique specifically f", icon: "cross.case.fill", destination: .technique("water-encyclopedia-procure-coastal-grapevine-tapping")),
                        TriageOption(id: "g2993", label: "Adapting the grapevine tapping technique specifically f", icon: "cross.case.fill", destination: .technique("water-encyclopedia-procure-swamp-marsh-grapevine-tapping")),
                        TriageOption(id: "g2994", label: "Adapting the grapevine tapping technique specifically f", icon: "cross.case.fill", destination: .technique("water-encyclopedia-procure-temperate-forest-grapevine-tapping")),
                        TriageOption(id: "g2995", label: "Adapting the mud hole filtration (seep) technique speci", icon: "drop.fill", destination: .technique("water-encyclopedia-procure-arctic-mud-hole-filtration-(seep)")),
                        TriageOption(id: "g2996", label: "Adapting the mud hole filtration (seep) technique speci", icon: "drop.fill", destination: .technique("water-encyclopedia-procure-desert-mud-hole-filtration-(seep)"))
                    ])
                )),
                TriageOption(id: "g2997", label: "Hole", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g2997-q", question: "Select:", options: [
                        TriageOption(id: "g2998", label: "Adapting the mud hole filtration (seep) technique speci", icon: "drop.fill", destination: .technique("water-encyclopedia-procure-alpine-mud-hole-filtration-(seep)")),
                        TriageOption(id: "g2999", label: "Adapting the mud hole filtration (seep) technique speci", icon: "drop.fill", destination: .technique("water-encyclopedia-procure-coastal-mud-hole-filtration-(seep)")),
                        TriageOption(id: "g3000", label: "Adapting the mud hole filtration (seep) technique speci", icon: "drop.fill", destination: .technique("water-encyclopedia-procure-jungle-mud-hole-filtration-(seep)")),
                        TriageOption(id: "g3001", label: "Adapting the mud hole filtration (seep) technique speci", icon: "drop.fill", destination: .technique("water-encyclopedia-procure-swamp-marsh-mud-hole-filtration-(seep)")),
                        TriageOption(id: "g3002", label: "Adapting the mud hole filtration (seep) technique speci", icon: "drop.fill", destination: .technique("water-encyclopedia-procure-temperate-forest-mud-hole-filtration-(seep)"))
                    ])
                )),
                TriageOption(id: "g3003", label: "Rain", icon: "cloud.rain.fill", destination: .nextQuestion(
                    TriageNode(id: "g3003-q", question: "Select:", options: [
                        TriageOption(id: "g3004", label: "Adapting the rain catchment basin technique specificall", icon: "cloud.rain.fill", destination: .technique("water-encyclopedia-procure-alpine-rain-catchment-basin")),
                        TriageOption(id: "g3005", label: "Adapting the rain catchment basin technique specificall", icon: "cloud.rain.fill", destination: .technique("water-encyclopedia-procure-arctic-rain-catchment-basin")),
                        TriageOption(id: "g3006", label: "Adapting the rain catchment basin technique specificall", icon: "cloud.rain.fill", destination: .technique("water-encyclopedia-procure-coastal-rain-catchment-basin")),
                        TriageOption(id: "g3007", label: "Adapting the rain catchment basin technique specificall", icon: "cloud.rain.fill", destination: .technique("water-encyclopedia-procure-desert-rain-catchment-basin")),
                        TriageOption(id: "g3008", label: "Adapting the rain catchment basin technique specificall", icon: "cloud.rain.fill", destination: .technique("water-encyclopedia-procure-jungle-rain-catchment-basin"))
                    ])
                )),
                TriageOption(id: "g3009", label: "Rain (2)", icon: "cloud.rain.fill", destination: .nextQuestion(
                    TriageNode(id: "g3009-q", question: "Select:", options: [
                        TriageOption(id: "g3010", label: "Adapting the rain catchment basin technique specificall", icon: "cloud.rain.fill", destination: .technique("water-encyclopedia-procure-swamp-marsh-rain-catchment-basin")),
                        TriageOption(id: "g3011", label: "Adapting the rain catchment basin technique specificall", icon: "cloud.rain.fill", destination: .technique("water-encyclopedia-procure-temperate-forest-rain-catchment-basin")),
                        TriageOption(id: "g3012", label: "Accessing the final 2 gallons of potable water in a bat", icon: "cylinder.fill", destination: .technique("water-toilet-tank-procurement"))
                    ])
                ))
                ])
            )),

            TriageOption(id: "g3013", label: "Purifying Water", icon: "cross.case.fill", destination: .nextQuestion(
                TriageNode(id: "g3013-q", question: "What specifically?", options: [
                TriageOption(id: "g3014", label: "Sodis", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g3014-q", question: "Select:", options: [
                        TriageOption(id: "g3015", label: "Maximizing UV-A exposure for water purification", icon: "drop.fill", destination: .technique("water-solar-disinfection-advanced")),
                        TriageOption(id: "g3016", label: "UV radiation sterilization using clear plastic bottles.", icon: "cross.case.fill", destination: .technique("water-purify-uv-sodis")),
                        TriageOption(id: "g3017", label: "Using UV radiation from sunlight to kill pathogens in c", icon: "cross.case.fill", destination: .technique("water-uv-sodis")),
                        TriageOption(id: "g3018", label: "Sterilize water using ultraviolet sunlight", icon: "drop.fill", destination: .technique("water-uv-sun-purification")),
                        TriageOption(id: "g3019", label: "Kill pathogens using sunlight and a plastic bottle", icon: "cross.case.fill", destination: .technique("water-uv-disinfection"))
                    ])
                )),
                TriageOption(id: "g3020", label: "Filtration", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g3020-q", question: "Select:", options: [
                        TriageOption(id: "g3021", label: "Filter water through layered fabric for clarity", icon: "drop.fill", destination: .technique("water-cloth-filtration")),
                        TriageOption(id: "g3022", label: "Processing charcoal for water filtration", icon: "cross.case.fill", destination: .technique("water-activated-charcoal-making")),
                        TriageOption(id: "g3023", label: "Building a layered filtration system", icon: "drop.fill", destination: .technique("water-gravity-filter-system")),
                        TriageOption(id: "g3024", label: "Obtaining clear water from a muddy swamp or bank", icon: "drop.fill", destination: .technique("water-mud-filtration-hole"))
                    ])
                )),
                TriageOption(id: "g3025", label: "Bottle", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g3025-q", question: "Select:", options: [
                        TriageOption(id: "g3026", label: "Building a multi-layer gravity filter from natural mate", icon: "drop.fill", destination: .technique("water-charcoal-filter-diy")),
                        TriageOption(id: "g3027", label: "Multi-layer filter removes sediment and many pathogens", icon: "drop.fill", destination: .technique("water-vegetable-filter"))
                    ])
                )),
                TriageOption(id: "g3028", label: "Natural", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g3028-q", question: "Select:", options: [
                        TriageOption(id: "g3029", label: "Building a ceramic filter from natural clay", icon: "drop.fill", destination: .technique("water-clay-pot-purification")),
                        TriageOption(id: "g3030", label: "Boiling water without a metal container", icon: "flame.fill", destination: .technique("water-boil-rock-wood"))
                    ])
                )),
                TriageOption(id: "g3031", label: "Filter", icon: "drop.fill", destination: .nextQuestion(
                    TriageNode(id: "g3031-q", question: "Select:", options: [
                        TriageOption(id: "g3032", label: "Build a gravity-fed ceramic water filter", icon: "drop.fill", destination: .technique("water-ceramic-filter-build")),
                        TriageOption(id: "g3033", label: "The ultimate, infallible method for biological steriliz", icon: "drop.fill", destination: .technique("water-purify-rolling-boil"))
                    ])
                )),
                TriageOption(id: "g3034", label: "Water", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g3034-q", question: "Select:", options: [
                        TriageOption(id: "g3035", label: "Using household chlorine bleach to disinfect water", icon: "drop.fill", destination: .technique("water-bleach-purification")),
                        TriageOption(id: "g3036", label: "Distill contaminated water using two containers", icon: "flame.fill", destination: .technique("water-double-boil-purification")),
                        TriageOption(id: "g3037", label: "Assess water safety without lab equipment", icon: "ant.fill", destination: .technique("water-water-testing-field")),
                        TriageOption(id: "g3038", label: "Chemical disinfection using iodine tablets or tincture", icon: "cross.case.fill", destination: .technique("water-iodine-purification")),
                        TriageOption(id: "g3039", label: "Converting saltwater to freshwater using heat", icon: "sun.max.fill", destination: .technique("water-seawater-distillation"))
                    ])
                )),
                TriageOption(id: "g3040", label: "Snow", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g3040-q", question: "Select:", options: [
                        TriageOption(id: "g3041", label: "Maximizing water yield from snow", icon: "cross.case.fill", destination: .technique("water-snow-melting-efficiency")),
                        TriageOption(id: "g3042", label: "Chemical treatment effective against Cryptosporidium.", icon: "cross.case.fill", destination: .technique("water-purify-chlorine-dioxide"))
                    ])
                ))
                ])
            )),

            TriageOption(id: "g3043", label: "Storing Water", icon: "cross.case.fill", destination: .nextQuestion(
                TriageNode(id: "g3043-q", question: "What specifically?", options: [
                TriageOption(id: "g3044", label: "Container", icon: "cylinder.fill", destination: .nextQuestion(
                    TriageNode(id: "g3044-q", question: "Select:", options: [
                        TriageOption(id: "g3045", label: "Use a condom as an emergency water container", icon: "car.fill", destination: .technique("water-condom-canteen-technique")),
                        TriageOption(id: "g3046", label: "Convert seawater to drinking water using sun and plasti", icon: "sun.max.fill", destination: .technique("water-desalination-solar"))
                    ])
                )),
                TriageOption(id: "g3047", label: "Water", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g3047-q", question: "Select:", options: [
                        TriageOption(id: "g3048", label: "Use bamboo segments as natural water containers", icon: "water.waves", destination: .technique("water-bamboo-segment-storage")),
                        TriageOption(id: "g3049", label: "Medical-grade rehydration formula from basic ingredient", icon: "cross.case.fill", destination: .technique("water-iv-fluid-improvised")),
                        TriageOption(id: "g3050", label: "Optimize water consumption in scarcity", icon: "building.2.fill", destination: .technique("water-rationing-schedule"))
                    ])
                )),
                TriageOption(id: "g3051", label: "Seawater", icon: "water.waves", destination: .nextQuestion(
                    TriageNode(id: "g3051-q", question: "Select:", options: [
                        TriageOption(id: "g3052", label: "Distill seawater using a pot and a condenser tube", icon: "water.waves", destination: .technique("water-seawater-reverse-osmosis-field")),
                        TriageOption(id: "g3053", label: "Emergency vitamin C and hydration source", icon: "scissors", destination: .technique("water-pine-needle-tea"))
                    ])
                ))
                ])
            )),

            TriageOption(id: "g3054", label: "Water", icon: "cross.case.fill", destination: .nextQuestion(
                TriageNode(id: "g3054-q", question: "What specifically?", options: [
                TriageOption(id: "g3055", label: "Swim", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g3055-q", question: "Select:", options: [
                        TriageOption(id: "g3056", label: "Surviving rip currents, tidal cuts, and surges", icon: "cross.case.fill", destination: .technique("env-coastal-tidal-adv")),
                        TriageOption(id: "g3057", label: "Staying alive at sea without a vessel", icon: "water.waves", destination: .technique("env-ocean-adrift"))
                    ])
                )),
                TriageOption(id: "g3058", label: "Escape", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g3058-q", question: "Select:", options: [
                        TriageOption(id: "g3059", label: "Surviving a vehicle caught in flash flooding", icon: "link", destination: .technique("env-flash-flood-vehicle")),
                        TriageOption(id: "g3060", label: "Escape a rip current pulling you out to sea", icon: "water.waves", destination: .technique("env-rip-current-escape"))
                    ])
                )),
                TriageOption(id: "g3061", label: "Breathing", icon: "lungs.fill", destination: .nextQuestion(
                    TriageNode(id: "g3061-q", question: "Select:", options: [
                        TriageOption(id: "g3062", label: "Survive sudden immersion in cold water", icon: "lungs.fill", destination: .technique("env-cold-water-immersion")),
                        TriageOption(id: "g3063", label: "Extending survival time in cold water", icon: "lungs.fill", destination: .technique("env-cold-water-swimming-technique"))
                    ])
                )),
                TriageOption(id: "g3064", label: "River", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g3064-q", question: "Select:", options: [
                        TriageOption(id: "g3065", label: "Avoiding lethal downed trees", icon: "cloud.rain.fill", destination: .technique("env-strainer-survival")),
                        TriageOption(id: "g3066", label: "Surviving river rapids", icon: "cross.case.fill", destination: .technique("env-swiftwater-swimming"))
                    ])
                ))
                ])
            )),
        ])
    }

}
