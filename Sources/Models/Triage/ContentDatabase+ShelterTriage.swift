import Foundation

extension ContentDatabase {
    // =========================================================================
    // MARK: - NEED SHELTER
    // =========================================================================
    func buildShelterTriage() -> TriageNode {
        TriageNode(id: "shelter-root", question: "What do you need?", options: [

            // ── WILDERNESS Environments ──
            TriageOption(id: "shelter-env", label: "Wilderness (Forest/Snow/Desert)", icon: "tree.fill", destination: .nextQuestion(
                TriageNode(id: "shelter-env-q", question: "What environment?", options: [
                    TriageOption(id: "shelter-temp", label: "Temperate Forest", icon: "tree.fill", destination: .nextQuestion(
                        TriageNode(id: "shelter-temp-q", question: "What do you have?", options: [
                            TriageOption(id: "shelter-temp-tarp", label: "Tarp / Poncho", icon: "square.fill", destination: .techniqueList(["shelter-tarp-aframe", "shelter-tarp-diamond"])),
                            TriageOption(id: "shelter-temp-debris", label: "Leaves & Branches", icon: "leaf.fill", destination: .techniqueList(["shelter-debris-aframe", "shelter-debris-round"])),
                            TriageOption(id: "shelter-temp-rock", label: "Rock / Cave / Log", icon: "triangle.fill", destination: .techniqueList(["shelter-rock-overhang", "shelter-fallen-tree"])),
                            TriageOption(id: "shelter-temp-mylar", label: "Mylar Blanket / Rope", icon: "sparkle", destination: .techniqueList(["shelter-mylar-wrap", "shelter-lean-to"]))
                        ])
                    )),
                    TriageOption(id: "shelter-cold", label: "Cold / Snow", icon: "snowflake", destination: .nextQuestion(
                        TriageNode(id: "shelter-cold-q", question: "What snow conditions?", options: [
                            TriageOption(id: "shelter-cold-deep", label: "Deep Snow (Digging)", icon: "arrow.down.to.line", destination: .techniqueList(["shelter-quinzhee", "shelter-snow-cave", "shelter-snow-trench"])),
                            TriageOption(id: "shelter-cold-hard", label: "Hard Packed Snow", icon: "square.stack.3d.up.fill", destination: .technique("shelter-igloo")),
                            TriageOption(id: "shelter-cold-tree", label: "Below Tree Line", icon: "tree.fill", destination: .techniqueList(["shelter-tree-well", "shelter-lean-to"])),
                            TriageOption(id: "shelter-cold-emergency", label: "Freezing NOW", icon: "exclamationmark.triangle.fill", destination: .technique("shelter-emergency-bivy"))
                        ])
                    )),
                    TriageOption(id: "shelter-hot", label: "Desert / Hot", icon: "sun.max.fill", destination: .nextQuestion(
                        TriageNode(id: "shelter-hot-q", question: "What is your priority?", options: [
                            TriageOption(id: "shelter-hot-sun", label: "Shade (Cloth/Tarp)", icon: "sun.max.fill", destination: .technique("shelter-shade-structure")),
                            TriageOption(id: "shelter-hot-dig", label: "Shade (Dig Trench)", icon: "arrow.down.circle.fill", destination: .technique("shelter-desert-trench")),
                            TriageOption(id: "shelter-hot-rocks", label: "Shade (Rocks)", icon: "triangle.fill", destination: .technique("shelter-rock-overhang")),
                            TriageOption(id: "shelter-hot-night", label: "Warmth at Night", icon: "moon.fill", destination: .technique("shelter-thermal-mass")),
                            TriageOption(id: "shelter-hot-wind", label: "Wind Protection", icon: "wind", destination: .technique("shelter-rock-windbreak"))
                        ])
                    )),
                    TriageOption(id: "shelter-wet", label: "Tropical / Jungle", icon: "drop.fill", destination: .nextQuestion(
                        TriageNode(id: "shelter-wet-q", question: "What is the threat?", options: [
                            TriageOption(id: "shelter-wet-rain", label: "Heavy Rain (Platform)", icon: "cloud.rain.fill", destination: .technique("shelter-raised-platform")),
                            TriageOption(id: "shelter-wet-ground", label: "Bugs/Moisture", icon: "ant.fill", destination: .techniqueList(["shelter-raised-platform", "shelter-tree-platform"])),
                            TriageOption(id: "shelter-wet-swamp", label: "Swamp / Wetland", icon: "leaf.fill", destination: .techniqueList(["shelter-swamp-bed", "shelter-swamp"])),
                            TriageOption(id: "shelter-wet-hammock", label: "Hammock Available", icon: "figure.mind.and.body", destination: .technique("shelter-hammock"))
                        ])
                    ))
                ])
            )),

            // ── DISASTER Environments ──
            TriageOption(id: "shelter-disaster", label: "Urban / Coastal Disaster", icon: "building.2.fill", destination: .nextQuestion(
                TriageNode(id: "shelter-disaster-q", question: "Where are you?", options: [
                    TriageOption(id: "shelter-urban-vehicle", label: "Urban (Vehicle)", icon: "car.fill", destination: .technique("shelter-vehicle")),
                    TriageOption(id: "shelter-urban-tarp", label: "Urban (Tarp/Debris)", icon: "square.fill", destination: .technique("shelter-tarp-leanto")),
                    TriageOption(id: "shelter-urban-nothing", label: "Urban (Exposed)", icon: "xmark.circle", destination: .technique("shelter-emergency-bivy")),
                    TriageOption(id: "shelter-coastal", label: "Coastal (Beach/Driftwood)", icon: "water.waves", destination: .technique("shelter-coastal-driftwood"))
                ])
            )),

            // ── IMPROVE EXISTING ──
            TriageOption(id: "shelter-improve", label: "Improve Existing Shelter", icon: "wrench.fill", destination: .nextQuestion(
                TriageNode(id: "shelter-imp-q", question: "What improvement?", options: [
                    TriageOption(id: "shelter-imp-bedding", label: "Bedding / Insulation", icon: "bed.double.fill", destination: .techniqueList(["shelter-ground-insulation", "shelter-bough-bed", "shelter-grass-bed", "shelter-heated-bed"])),
                    TriageOption(id: "shelter-imp-heat", label: "Heat & Entry (Door)", icon: "flame", destination: .techniqueList(["shelter-fire-reflector", "shelter-door-construction"])),
                    TriageOption(id: "shelter-imp-seal", label: "Weather Sealing / Storm", icon: "cloud.rain.fill", destination: .techniqueList(["shelter-waterproofing", "shelter-storm-proofing"])),
                    TriageOption(id: "shelter-imp-vent", label: "Ventilation (Prevent CO)", icon: "wind", destination: .technique("shelter-ventilation")),
                    TriageOption(id: "shelter-imp-wind", label: "Snow Wall / Windbreak", icon: "square.stack.fill", destination: .technique("shelter-snow-wall"))
                ])
            )),

            // ── SPECIALTY ──
            TriageOption(id: "shelter-specialty", label: "Specialty / Long-Term", icon: "house.fill", destination: .nextQuestion(
                TriageNode(id: "shelter-spec-q", question: "What type?", options: [
                    TriageOption(id: "shelter-spec-wickiup", label: "Wickiup (Long-Term)", icon: "triangle.fill", destination: .technique("shelter-wickiup")),
                    TriageOption(id: "shelter-spec-group", label: "Group Shelter", icon: "person.3.fill", destination: .technique("shelter-group")),
                    TriageOption(id: "shelter-spec-para", label: "Parachute Shelter", icon: "wind", destination: .technique("shelter-parachute")),
                    TriageOption(id: "shelter-spec-debris-hut", label: "Debris Hut (All-Weather)", icon: "house.fill", destination: .technique("shelter-debris-hut"))
                ])
            )),

            // 📚 LEARN MORE
            TriageOption(id: "shelter-learn", label: "Learn More", icon: "book.fill", destination: .nextQuestion(
                TriageNode(id: "shelter-learn-root-q", question: "Topic?", options: [
                    TriageOption(id: "sh-art-insulation", label: "Insulation / Bedding", icon: "bed.double.fill", destination: .articleList(["shelter-article-insulation", "shelter-article-insulation-values", "shelter-article-ground", "shelter-article-bedding"])),
                    TriageOption(id: "sh-art-weather", label: "Wind / Rain Defense", icon: "cloud.rain.fill", destination: .articleList(["shelter-article-wind", "shelter-article-rain"])),
                    TriageOption(id: "sh-art-env", label: "Environments (Snow/Desert/Jungle)", icon: "globe.americas", destination: .articleList(["shelter-article-snow-insulation", "shelter-article-desert", "shelter-article-tropical"])),
                    TriageOption(id: "sh-art-other", label: "Repairs / Mistakes / Urban", icon: "exclamationmark.triangle.fill", destination: .articleList(["shelter-article-urban", "shelter-article-maintenance", "shelter-article-mistakes"]))
                ])
            ))
        ])
    }
}
