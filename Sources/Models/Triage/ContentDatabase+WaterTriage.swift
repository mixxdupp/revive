import Foundation

extension ContentDatabase {
    // =========================================================================
    // MARK: - NEED WATER
    // =========================================================================
    func buildWaterTriage() -> TriageNode {
        TriageNode(id: "water-root", question: "What do you need?", options: [

            // ── NEAR WATER SOURCE ──
            TriageOption(id: "water-stream", label: "Found Stream / Lake", icon: "water.waves", destination: .nextQuestion(
                TriageNode(id: "water-stream-q", question: "Water quality?", options: [
                    TriageOption(id: "water-clear", label: "Clear / Running", icon: "drop.fill", destination: .nextQuestion(
                        TriageNode(id: "water-purify-q", question: "How can you purify it?", options: [
                            TriageOption(id: "water-boil", label: "Boil It (Fire Available)", icon: "flame", destination: .technique("water-boiling")),
                            TriageOption(id: "water-tabs", label: "Tablets / Iodine", icon: "pills.fill", destination: .technique("water-iodine")),
                            TriageOption(id: "water-uv", label: "Clear Bottle + Strong Sun", icon: "sun.max.fill", destination: .technique("water-uv-purification")),
                            TriageOption(id: "water-filter-char", label: "Use Store-Bought Filter", icon: "line.3.horizontal.decrease.circle", destination: .techniqueList(["water-charcoal-filter", "water-activated-charcoal"])),
                            TriageOption(id: "water-no-purify", label: "Nothing — Drink It?", icon: "exclamationmark.triangle.fill", destination: .technique("water-testing"))
                        ])
                    )),
                    TriageOption(id: "water-murky", label: "Murky / Stagnant", icon: "drop.triangle.fill", destination: .nextQuestion(
                        TriageNode(id: "water-murky-q", question: "What can you do?", options: [
                            TriageOption(id: "water-murky-cloth", label: "Pre-Filter with Cloth + Boil", icon: "tshirt.fill", destination: .technique("water-boiling")),
                            TriageOption(id: "water-murky-charcoal", label: "Build DIY Charcoal Filter", icon: "hammer.fill", destination: .technique("water-charcoal-filter")),
                            TriageOption(id: "water-murky-biosand", label: "Bio-Sand Filter (Long-Term)", icon: "square.3.layers.3d.down.right.fill", destination: .technique("water-bio-sand-filter"))
                        ])
                    ))
                ])
            )),

            // ── ENVIRONMENT GROUPS ──
            TriageOption(id: "water-env", label: "Find Water by Environment", icon: "globe.americas.fill", destination: .nextQuestion(
                TriageNode(id: "water-env-q", question: "What environment?", options: [
                    TriageOption(id: "water-rain", label: "Rain / Precipitation", icon: "cloud.rain.fill", destination: .nextQuestion(
                        TriageNode(id: "water-rain-q", question: "How will you catch it?", options: [
                            TriageOption(id: "water-rain-tarp", label: "Tarp / Poncho", icon: "square.fill", destination: .technique("water-tarp-rain-catch")),
                            TriageOption(id: "water-rain-poncho", label: "Poncho / Tarp Funnel", icon: "chevron.down", destination: .technique("water-poncho-rain-catch")),
                            TriageOption(id: "water-rain-collect", label: "Any Container / Leaves", icon: "cup.and.saucer.fill", destination: .technique("water-rain-collection"))
                        ])
                    )),
                    TriageOption(id: "water-desert", label: "Desert / Arid Land", icon: "sun.max.fill", destination: .nextQuestion(
                        TriageNode(id: "water-desert-q", question: "What resources are available?", options: [
                            TriageOption(id: "water-solar", label: "Plastic Sheet Available", icon: "bag.fill", destination: .technique("water-solar-still")),
                            TriageOption(id: "water-plants", label: "Vegetation Nearby", icon: "leaf.fill", destination: .nextQuestion(
                                TriageNode(id: "water-veg-q", question: "What type?", options: [
                                    TriageOption(id: "water-trees", label: "Trees / Bushes", icon: "tree.fill", destination: .technique("water-transpiration-bag")),
                                    TriageOption(id: "water-cactus", label: "Cactus / Succulents", icon: "leaf.fill", destination: .technique("water-cactus-extraction"))
                                ])
                            )),
                            TriageOption(id: "water-rock-face", label: "Rock Faces", icon: "triangle.fill", destination: .techniqueList(["water-rock-seepage", "water-spring-identification"])),
                            TriageOption(id: "water-dig", label: "Can Dig (Dry Riverbed)", icon: "arrow.down.circle.fill", destination: .technique("water-well-digging")),
                            TriageOption(id: "water-fog", label: "Fog / Mist Present", icon: "cloud.fog.fill", destination: .technique("water-fog-nets"))
                        ])
                    )),
                    TriageOption(id: "water-snow", label: "Snow / Ice Available", icon: "snowflake", destination: .nextQuestion(
                        TriageNode(id: "water-snow-q", question: "Can you make fire?", options: [
                            TriageOption(id: "water-snow-fire", label: "Yes — Melt Snow", icon: "flame", destination: .technique("water-snow-melting")),
                            TriageOption(id: "water-snow-nofire", label: "No — Body Heat Only", icon: "person.fill", destination: .technique("water-snow-melting")),
                            TriageOption(id: "water-snow-altitude", label: "High Altitude", icon: "mountain.2.fill", destination: .technique("water-altitude-boiling"))
                        ])
                    )),
                    TriageOption(id: "water-ocean", label: "At Sea / Coastal", icon: "sailboat.fill", destination: .nextQuestion(
                        TriageNode(id: "water-sea-q", question: "What's available?", options: [
                            TriageOption(id: "water-sea-desal", label: "Desalination / Solar Still", icon: "spigot.fill", destination: .technique("water-desalination")),
                            TriageOption(id: "water-sea-only", label: "Seawater Only", icon: "drop.fill", destination: .technique("water-seawater")),
                            TriageOption(id: "water-sea-shore", label: "On Shore — Explore", icon: "figure.walk", destination: .techniqueList(["water-rain-collection", "water-rock-seepage", "water-dew-collection"])),
                            TriageOption(id: "water-sea-ice", label: "Old Sea Ice", icon: "snowflake", destination: .technique("water-seawater-ice"))
                        ])
                    )),
                    TriageOption(id: "water-jungle", label: "Jungle / Tropical", icon: "leaf.fill", destination: .nextQuestion(
                        TriageNode(id: "water-jungle-q", question: "What's around you?", options: [
                            TriageOption(id: "water-bamboo", label: "Bamboo", icon: "leaf.fill", destination: .technique("water-bamboo-collection")),
                            TriageOption(id: "water-banana", label: "Banana Plants", icon: "leaf.fill", destination: .technique("water-banana-plant")),
                            TriageOption(id: "water-vines", label: "Vines / Lianas", icon: "line.diagonal", destination: .technique("water-vine-extraction")),
                            TriageOption(id: "water-fruits", label: "Coconuts / Fruits", icon: "circle.fill", destination: .technique("water-from-fruits")),
                            TriageOption(id: "water-transpire", label: "Broad-Leaf Trees", icon: "tree.circle.fill", destination: .techniqueList(["water-transpiration-enhanced", "water-birch-tapping"]))
                        ])
                    )),
                    TriageOption(id: "water-urban", label: "Urban Area", icon: "building.2.fill", destination: .nextQuestion(
                        TriageNode(id: "water-urban-q", question: "What sources exist?", options: [
                            TriageOption(id: "water-urban-store", label: "Store / Ration", icon: "drop.fill", destination: .technique("water-storage")),
                            TriageOption(id: "water-urban-heater", label: "Water Heater Tank", icon: "flame", destination: .technique("water-water-heater-extraction")),
                            TriageOption(id: "water-urban-uv", label: "UV Sun Purify (SODIS)", icon: "sun.max.fill", destination: .technique("water-uv-sun-purification"))
                        ])
                    ))
                ])
            )),

            // ── EMERGENCY SOURCES ──
            TriageOption(id: "water-emergency", label: "Emergency Digging / Tracking", icon: "exclamationmark.triangle.fill", destination: .nextQuestion(
                TriageNode(id: "water-emerg-q", question: "What's available?", options: [
                    TriageOption(id: "water-emerg-sources", label: "Overview of All Sources", icon: "list.bullet", destination: .technique("water-emergency-sources")),
                    TriageOption(id: "water-emerg-underground", label: "Underground Seep / Dig", icon: "arrow.down.circle.fill", destination: .technique("water-underground-seep")),
                    TriageOption(id: "water-emerg-animal", label: "Follow Animal Signs", icon: "pawprint.fill", destination: .technique("water-animal-indicators")),
                    TriageOption(id: "water-emerg-dew", label: "Morning Dew (Drag Cloth)", icon: "sunrise.fill", destination: .technique("water-morning-dew-drag")),
                    TriageOption(id: "water-emerg-electrolyte", label: "Make Electrolytes", icon: "cup.and.saucer.fill", destination: .technique("water-electrolyte-solution")),
                    TriageOption(id: "water-emerg-condom", label: "Improvised Container", icon: "bag.fill", destination: .technique("water-condom-canteen"))
                ])
            )),

            // ── CONTAINER & COLLECTION ──
            TriageOption(id: "water-container", label: "Containers & Testing", icon: "mug.fill", destination: .nextQuestion(
                TriageNode(id: "water-cont-q", question: "What do you need?", options: [
                    TriageOption(id: "water-cont-birch", label: "Birch Bark Container", icon: "tree.fill", destination: .technique("water-birch-container")),
                    TriageOption(id: "water-cont-clay", label: "Clay Pot Filter", icon: "cylinder.fill", destination: .technique("water-clay-pot-filter")),
                    TriageOption(id: "water-cont-coconut", label: "Coconut Water Safety", icon: "circle.fill", destination: .technique("water-coconut-water")),
                    TriageOption(id: "water-cont-test", label: "Test Water Quality", icon: "eyedropper.halffull", destination: .technique("water-testing"))
                ])
            )),

            // 📚 LEARN MORE
            TriageOption(id: "water-learn", label: "Learn More", icon: "book.fill", destination: .nextQuestion(
                TriageNode(id: "water-learn-q", question: "What would you like to read about?", options: [
                    TriageOption(id: "w-art-find", label: "Finding / Indicators", icon: "binoculars.fill", destination: .articleList(["water-article-finding", "water-article-signs", "water-article-desert", "water-article-desert-survival"])),
                    TriageOption(id: "w-art-purify", label: "Purifying / Filters", icon: "arrow.3.trianglepath", destination: .articleList(["water-article-purification", "water-article-filter-vs-purify"])),
                    TriageOption(id: "w-art-danger", label: "Contamination / Disease", icon: "microbe.fill", destination: .articleList(["water-article-contamination", "water-article-diseases"])),
                    TriageOption(id: "w-art-body", label: "Dehydration / Rationing", icon: "person.fill", destination: .articleList(["water-article-dehydration", "water-article-rationing"])),
                    TriageOption(id: "w-art-methods", label: "Environment Methods", icon: "globe.americas.fill", destination: .articleList(["water-article-rainwater", "water-article-ice-snow", "water-article-storage", "water-article-oceansurv"]))
                ])
            ))
        ])
    }

}
