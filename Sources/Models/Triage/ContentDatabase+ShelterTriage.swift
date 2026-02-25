import Foundation

// Auto-generated: buildShelterTriage extracted from ContentDatabase.swift
extension ContentDatabase {
    // =========================================================================
    // MARK: - NEED SHELTER (4 levels deep)
    // =========================================================================
    func buildShelterTriage() -> TriageNode {
        TriageNode(id: "shelter-root", question: "What climate/environment are you in?", options: [

            // ── TEMPERATE / FOREST ──
            TriageOption(id: "shelter-temp", label: "Temperate Forest", icon: "tree.fill", destination: .nextQuestion(
                TriageNode(id: "shelter-temp-time", question: "How much time until dark/storm?", options: [
                    TriageOption(id: "shelter-temp-immediate", label: "Less than 1 Hour", icon: "hourglass.bottomhalf.filled", destination: .nextQuestion(
                        TriageNode(id: "shelter-temp-imm-mat", question: "What do you have?", options: [
                            TriageOption(id: "shelter-temp-tarp", label: "Tarp / Poncho", icon: "square.fill", destination: .nextQuestion(
                                TriageNode(id: "shelter-temp-tarp-wind", question: "How is the wind?", options: [
                                ])
                            )),
                            TriageOption(id: "shelter-temp-natural", label: "Natural Only", icon: "leaf.fill", destination: .nextQuestion(
                                TriageNode(id: "shelter-temp-nat-q", question: "What's around you?", options: [
                                    TriageOption(id: "shelter-temp-rock", label: "Rock Overhang / Cave", icon: "triangle.fill", destination: .technique("shelter-rock-overhang")),
                                ])
                            ))
                        ])
                    )),
                    TriageOption(id: "shelter-temp-long", label: "2+ Hours / Planning", icon: "clock.fill", destination: .nextQuestion(
                        TriageNode(id: "shelter-temp-long-mat", question: "What's the goal?", options: [
                            TriageOption(id: "shelter-temp-warmth", label: "Maximum Warmth", icon: "flame", destination: .nextQuestion(
                                TriageNode(id: "shelter-temp-warmth-q", question: "How cold is it?", options: [
                                    TriageOption(id: "shelter-temp-freeze", label: "Below Freezing", icon: "thermometer.snowflake", destination: .techniqueList(["shelter-debris-aframe", "firstaid-frostbite"])), // Added orphan
                                    TriageOption(id: "shelter-temp-chilly", label: "Chilly (40-50°F)", icon: "thermometer.medium", destination: .techniqueList(["shelter-debris-round", "firstaid-hypothermia-treatment"])), // Added orphan
                                ])
                            )),
                            TriageOption(id: "shelter-temp-rain", label: "Rain Protection", icon: "cloud.rain.fill", destination: .nextQuestion(
                                TriageNode(id: "shelter-temp-rain-q", question: "Materials available?", options: [
                                    TriageOption(id: "shelter-temp-rain-bark", label: "Bark / Large Leaves", icon: "leaf.fill", destination: .technique("shelter-debris-hut")),
                                ])
                            )),
                            TriageOption(id: "shelter-temp-bed", label: "Need Bedding / Insulation", icon: "leaf.fill", destination: .nextQuestion(
                                TriageNode(id: "shelter-temp-bed-q", question: "What ground material is available?", options: [
                                    TriageOption(id: "shelter-bed-leaves", label: "Fallen Leaves", icon: "leaf.fill", destination: .technique("shelter-ground-insulation")),
                                    TriageOption(id: "shelter-bed-pine", label: "Pine Boughs", icon: "tree.fill", destination: .technique("shelter-bough-bed")),
                                    TriageOption(id: "shelter-bed-grass", label: "Tall Grass / Cattails", icon: "leaf.fill", destination: .technique("shelter-grass-bed")),
                                ])
                            ))
                        ])
                    ))
                ])
            )),

            // ── COLD / SNOW ──
            TriageOption(id: "shelter-cold", label: "Cold / Snow", icon: "snowflake", destination: .nextQuestion(
                TriageNode(id: "shelter-cold-q", question: "What are the snow conditions?", options: [
                    TriageOption(id: "shelter-cold-deep", label: "Deep Snow", icon: "arrow.down.to.line", destination: .nextQuestion(
                        TriageNode(id: "shelter-cold-deep-tools", question: "Do you have digging tools?", options: [
                            TriageOption(id: "shelter-cold-shovel", label: "Shovel / Pot", icon: "hammer.fill", destination: .nextQuestion(
                                TriageNode(id: "shelter-cold-shovel-time", question: "How much time do you have?", options: [
                                    TriageOption(id: "shelter-cold-hours", label: "2+ Hours", icon: "clock.fill", destination: .techniqueList(["shelter-quinzhee", "shelter-snow-cave"])), // Added orphan
                                ])
                            )),
                            TriageOption(id: "shelter-cold-hands", label: "Hands Only", icon: "hand.raised.fill", destination: .nextQuestion(
                                TriageNode(id: "shelter-cold-hands-q", question: "Are there trees nearby?", options: [
                                ])
                            ))
                        ])
                    )),
                    TriageOption(id: "shelter-cold-hard", label: "Hard Packed / Ice", icon: "square.stack.3d.up.fill", destination: .nextQuestion(
                        TriageNode(id: "shelter-cold-hard-q", question: "Can you cut firm blocks?", options: [
                        ])
                    )),
                    TriageOption(id: "shelter-cold-tree", label: "Below Tree Line", icon: "tree.fill", destination: .nextQuestion(
                        TriageNode(id: "shelter-cold-tree-q", question: "What do you have?", options: [
                            TriageOption(id: "shelter-cold-nothing", label: "Nothing — Natural Only", icon: "leaf.fill", destination: .techniqueList(["shelter-tree-well", "shelter-lean-to"]))
                        ])
                    ))
                ])
            )),

            // ── DESERT / HOT ──
            TriageOption(id: "shelter-hot", label: "Desert / Hot", icon: "sun.max.fill", destination: .nextQuestion(
                TriageNode(id: "shelter-hot-q", question: "What is your priority?", options: [
                    TriageOption(id: "shelter-hot-sun", label: "Escape Sun (Day)", icon: "sun.max.fill", destination: .nextQuestion(
                        TriageNode(id: "shelter-hot-sun-mat", question: "Materials?", options: [
                            TriageOption(id: "shelter-hot-tarp", label: "Tarp / Cloth", icon: "square.fill", destination: .nextQuestion(
                                TriageNode(id: "shelter-hot-tarp-q", question: "Double layer possible?", options: [
                                    TriageOption(id: "shelter-hot-double", label: "Yes — Two Layers", icon: "square.on.square.fill", destination: .technique("shelter-shade-structure")),
                                ])
                            )),
                            TriageOption(id: "shelter-hot-dig", label: "Can Dig Trench", icon: "arrow.down.circle.fill", destination: .technique("shelter-desert-trench")),
                        ])
                    )),
                    TriageOption(id: "shelter-hot-cold-night", label: "Warmth (Night)", icon: "moon.fill", destination: .nextQuestion(
                        TriageNode(id: "shelter-hot-night-q", question: "What can you use for insulation?", options: [
                            TriageOption(id: "shelter-hot-sand", label: "Sand / Rocks (Thermal Mass)", icon: "triangle.fill", destination: .technique("shelter-thermal-mass")),
                        ])
                    )),
                    TriageOption(id: "shelter-hot-wind", label: "Wind Protection", icon: "wind", destination: .nextQuestion(
                        TriageNode(id: "shelter-hot-wind-q", question: "What's available for windbreak?", options: [
                            TriageOption(id: "shelter-hot-wall", label: "Can Stack Rocks", icon: "square.stack.fill", destination: .technique("shelter-rock-windbreak")),
                        ])
                    ))
                ])
            )),

            // ── TROPICAL / WET ──
            TriageOption(id: "shelter-wet", label: "Tropical / Jungle", icon: "drop.fill", destination: .nextQuestion(
                TriageNode(id: "shelter-wet-q", question: "What is the main threat?", options: [
                    TriageOption(id: "shelter-wet-rain", label: "Heavy Rain", icon: "cloud.rain.fill", destination: .nextQuestion(
                        TriageNode(id: "shelter-wet-rain-q", question: "What materials do you have?", options: [
                            TriageOption(id: "shelter-wet-rain-leaves", label: "Large Leaves / Palm Fronds", icon: "leaf.fill", destination: .technique("shelter-raised-platform")),
                        ])
                    )),
                    TriageOption(id: "shelter-wet-ground", label: "Ground Moisture / Bugs", icon: "ant.fill", destination: .nextQuestion(
                        TriageNode(id: "shelter-wet-ground-q", question: "How do you want to get off the ground?", options: [
                            TriageOption(id: "shelter-wet-platform", label: "Build Raised Platform", icon: "rectangle.stack.fill", destination: .techniqueList(["shelter-raised-platform", "shelter-tree-platform"])), // Added orphan
                            TriageOption(id: "shelter-wet-swamp", label: "Swamp Bed (Quick)", icon: "bed.double.fill", destination: .techniqueList(["shelter-swamp-bed", "env-swamp-movement"])) // Added orphan
                        ])
                    )),
                    TriageOption(id: "shelter-wet-night", label: "Sleeping Setup", icon: "bed.double.fill", destination: .nextQuestion(
                        TriageNode(id: "shelter-wet-sleep-q", question: "What bothers you most?", options: [
                        ])
                    ))
                ])
            )),

            // ── URBAN / DISASTER ──
            TriageOption(id: "shelter-urban", label: "Urban / After Disaster", icon: "building.2.fill", destination: .nextQuestion(
                TriageNode(id: "shelter-urban-q", question: "What's your situation?", options: [
                    TriageOption(id: "shelter-urban-vehicle", label: "Vehicle Available", icon: "car.fill", destination: .techniqueList(["shelter-vehicle", "shelter-parachute"])), // Added orphan
                    TriageOption(id: "shelter-urban-outside", label: "Outside — Exposed", icon: "cloud.rain.fill", destination: .nextQuestion(
                        TriageNode(id: "shelter-urban-out-q", question: "What can you find?", options: [
                        ])
                    ))
                ])
            )),

            // Shelter Improvements
            TriageOption(id: "shelter-improve", label: "Improve Existing Shelter", icon: "wrench.fill", destination: .nextQuestion(
                TriageNode(id: "shelter-imp-q", question: "What improvement?", options: [
                ])
            )),

            // Specialty Shelters
            TriageOption(id: "shelter-specialty", label: "Specialty Shelters", icon: "house.fill", destination: .nextQuestion(
                TriageNode(id: "shelter-spec-q", question: "What type?", options: [
                    TriageOption(id: "shelter-spec-coastal", label: "Coastal / Driftwood", icon: "water.waves", destination: .technique("shelter-coastal-driftwood")),
                    TriageOption(id: "shelter-spec-wickiup", label: "Wickiup (Long-Term)", icon: "triangle.fill", destination: .technique("shelter-wickiup")),
                    TriageOption(id: "shelter-spec-fallen", label: "Fallen Tree Shelter", icon: "tree.fill", destination: .technique("shelter-fallen-tree")),
                    TriageOption(id: "shelter-spec-group", label: "Group Shelter (Multiple People)", icon: "person.3.fill", destination: .technique("shelter-group")),
                    TriageOption(id: "shelter-spec-flyv", label: "Tarp Flying-V", icon: "chevron.down", destination: .technique("shelter-tarp-flying-v")),
                    TriageOption(id: "shelter-spec-swamp", label: "Swamp / Wetland", icon: "leaf.fill", destination: .technique("shelter-swamp"))
                ])
            )),

            // 📚 LEARN MORE
            TriageOption(id: "shelter-learn", label: "Learn More", icon: "book.fill", destination: .nextQuestion(
                TriageNode(id: "shelter-learn-q", question: "What would you like to read about?", options: [
                    TriageOption(id: "shelter-art-site", label: "Site Selection", icon: "mappin.and.ellipse", destination: .articleList(["shelter-article-site", "shelter-article-site-science"])),
                    TriageOption(id: "shelter-art-insulation", label: "Insulation Guide", icon: "thermometer.snowflake", destination: .articleList(["shelter-article-insulation", "shelter-article-insulation-values"])),
                    TriageOption(id: "shelter-art-ground", label: "Ground Insulation", icon: "square.3.layers.3d.bottom.filled", destination: .article("shelter-article-ground")),
                    TriageOption(id: "shelter-art-bedding", label: "Bedding Systems", icon: "bed.double.fill", destination: .article("shelter-article-bedding")),
                    TriageOption(id: "shelter-art-wind", label: "Wind Protection", icon: "wind", destination: .article("shelter-article-wind")),
                    TriageOption(id: "shelter-art-rain", label: "Rain & Waterproofing", icon: "cloud.rain.fill", destination: .article("shelter-article-rain")),
                    TriageOption(id: "shelter-art-reflector", label: "Heat Reflectors", icon: "flame", destination: .article("shelter-article-reflector")),
                    TriageOption(id: "shelter-art-snow", label: "Snow Shelters", icon: "snowflake", destination: .article("shelter-article-snow-insulation")),
                    TriageOption(id: "shelter-art-desert", label: "Desert Shelters", icon: "sun.max.fill", destination: .article("shelter-article-desert")),
                    TriageOption(id: "shelter-art-tropical", label: "Tropical Shelters", icon: "leaf.fill", destination: .article("shelter-article-tropical")),
                    TriageOption(id: "shelter-art-urban", label: "Urban Shelters", icon: "building.2.fill", destination: .article("shelter-article-urban")),
                    TriageOption(id: "shelter-art-longterm", label: "Long-Term Shelters", icon: "house.fill", destination: .article("shelter-article-longterm")),
                    TriageOption(id: "shelter-art-maint", label: "Maintenance & Repair", icon: "wrench.fill", destination: .article("shelter-article-maintenance")),
                    TriageOption(id: "shelter-art-mistakes", label: "Common Mistakes", icon: "exclamationmark.triangle.fill", destination: .article("shelter-article-mistakes")),
                    TriageOption(id: "shelter-art-psych", label: "Psychology of Shelter", icon: "brain.head.profile", destination: .article("shelter-article-psychology"))
                ])
            )),

            TriageOption(id: "g1595", label: "Biome Survival", icon: "cross.case.fill", destination: .nextQuestion(
                TriageNode(id: "g1595-q", question: "Which best matches?", options: [
                    TriageOption(id: "g1596", label: "High altitude, weather exposure, and difficult terrain", icon: "mountain.2.fill", destination: .technique("env-mountain-survival")),
                    TriageOption(id: "g1597", label: "Adrift at sea — water, shade, and signaling are everyth", icon: "sun.max.fill", destination: .technique("env-open-ocean-survival")),
                    TriageOption(id: "g1598", label: "Everything is wet, everything bites, everything grows", icon: "ant.fill", destination: .technique("env-jungle-survival")),
                    TriageOption(id: "g1599", label: "Above treeline — wind and exposure are the primary thre", icon: "cloud.fill", destination: .technique("env-tundra-survival")),
                    TriageOption(id: "g1600", label: "Surviving in a city after infrastructure failure", icon: "building.2.fill", destination: .technique("env-urban-collapse"))
                ])
            )),

            TriageOption(id: "g1601", label: "Camp Setup", icon: "mappin.and.ellipse", destination: .nextQuestion(
                TriageNode(id: "g1601-q", question: "What specifically?", options: [
                TriageOption(id: "g1602", label: "Shelter", icon: "house.fill", destination: .nextQuestion(
                    TriageNode(id: "g1602-q", question: "Select:", options: [
                        TriageOption(id: "g1603", label: "Stone or clay fireplace for permanent shelter heating", icon: "flame.fill", destination: .technique("shelter-chimney-fireplace")),
                        TriageOption(id: "g1604", label: "Long-term survival structure — permanent shelter", icon: "cloud.rain.fill", destination: .technique("shelter-log-cabin-basics")),
                        TriageOption(id: "g1605", label: "Classic 3-pole robust shelter", icon: "house.fill", destination: .technique("shelter-parateepee")),
                        TriageOption(id: "g1606", label: "Minimalist gear shelter", icon: "house.fill", destination: .technique("shelter-poncho-tent")),
                        TriageOption(id: "g1607", label: "Prairie-style shelter using cut earth blocks", icon: "house.fill", destination: .technique("shelter-sod-house"))
                    ])
                )),
                TriageOption(id: "g1608", label: "Rain", icon: "cloud.rain.fill", destination: .nextQuestion(
                    TriageNode(id: "g1608-q", question: "Select:", options: [
                        TriageOption(id: "g1609", label: "Waterproofing with garbage bags or emergency blankets", icon: "cloud.rain.fill", destination: .technique("shelter-improvised-poncho")),
                        TriageOption(id: "g1610", label: "Adapting rain catchment tarp construction for alpine te", icon: "cloud.rain.fill", destination: .technique("shelter-encyclopedia-infra-rain-alpine")),
                        TriageOption(id: "g1611", label: "Adapting rain catchment tarp construction for coniferou", icon: "cloud.rain.fill", destination: .technique("shelter-encyclopedia-infra-rain-coniferous")),
                        TriageOption(id: "g1612", label: "Adapting rain catchment tarp construction for jungle ca", icon: "cloud.rain.fill", destination: .technique("shelter-encyclopedia-infra-rain-jungle")),
                        TriageOption(id: "g1613", label: "Adapting rain catchment tarp construction for swampland", icon: "cloud.rain.fill", destination: .technique("shelter-encyclopedia-infra-rain-swampland"))
                    ])
                )),
                TriageOption(id: "g1614", label: "Long", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g1614-q", question: "Select:", options: [
                        TriageOption(id: "g1615", label: "Organizing long-term camps to prevent cross-contaminati", icon: "mappin.and.ellipse", destination: .technique("shelter-camp-triad")),
                        TriageOption(id: "g1616", label: "Maximum protection from weather, wind, and observation", icon: "cloud.rain.fill", destination: .technique("shelter-underground-shelter"))
                    ])
                )),
                TriageOption(id: "g1617", label: "Basin", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g1617-q", question: "Select:", options: [
                        TriageOption(id: "g1618", label: "Adapting waste disposal basin construction for alpine t", icon: "cloud.rain.fill", destination: .technique("shelter-encyclopedia-infra-waste-alpine")),
                        TriageOption(id: "g1619", label: "Adapting waste disposal basin construction for conifero", icon: "mappin.and.ellipse", destination: .technique("shelter-encyclopedia-infra-waste-coniferous")),
                        TriageOption(id: "g1620", label: "Adapting waste disposal basin construction for desert s", icon: "mappin.and.ellipse", destination: .technique("shelter-encyclopedia-infra-waste-desert")),
                        TriageOption(id: "g1621", label: "Adapting waste disposal basin construction for jungle c", icon: "mappin.and.ellipse", destination: .technique("shelter-encyclopedia-infra-waste-jungle")),
                        TriageOption(id: "g1622", label: "Adapting waste disposal basin construction for swamplan", icon: "mappin.and.ellipse", destination: .technique("shelter-encyclopedia-infra-waste-swampland"))
                    ])
                )),
                TriageOption(id: "g1623", label: "Greywater", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g1623-q", question: "Select:", options: [
                        TriageOption(id: "g1624", label: "Adapting greywater sump construction for alpine terrain", icon: "cloud.rain.fill", destination: .technique("shelter-encyclopedia-infra-greywater-alpine")),
                        TriageOption(id: "g1625", label: "Adapting greywater sump construction for coniferous for", icon: "mappin.and.ellipse", destination: .technique("shelter-encyclopedia-infra-greywater-coniferous")),
                        TriageOption(id: "g1626", label: "Adapting greywater sump construction for desert sand ca", icon: "mappin.and.ellipse", destination: .technique("shelter-encyclopedia-infra-greywater-desert")),
                        TriageOption(id: "g1627", label: "Adapting greywater sump construction for jungle canopy ", icon: "mappin.and.ellipse", destination: .technique("shelter-encyclopedia-infra-greywater-jungle")),
                        TriageOption(id: "g1628", label: "Adapting greywater sump construction for swampland camp", icon: "mappin.and.ellipse", destination: .technique("shelter-encyclopedia-infra-greywater-swampland"))
                    ])
                )),
                TriageOption(id: "g1629", label: "Rocks", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g1629-q", question: "Select:", options: [
                        TriageOption(id: "g1630", label: "How much insulation you actually need", icon: "cross.case.fill", destination: .technique("shelter-debris-insulation-calc")),
                        TriageOption(id: "g1631", label: "Using heated rocks for radiant sleeping warmth", icon: "flame.fill", destination: .technique("shelter-hot-rock-bed")),
                        TriageOption(id: "g1632", label: "Selecting safe sites near water crossings", icon: "mappin.and.ellipse", destination: .technique("shelter-water-crossing-camp")),
                        TriageOption(id: "g1633", label: "Underground food storage — natural refrigeration", icon: "cross.case.fill", destination: .technique("shelter-root-cellar")),
                        TriageOption(id: "g1634", label: "Permanent weatherproof walls from sticks and mud", icon: "cloud.fill", destination: .technique("shelter-wattle-and-daub"))
                    ])
                )),
                TriageOption(id: "g1635", label: "Drying", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g1635-q", question: "Select:", options: [
                        TriageOption(id: "g1636", label: "Adapting drying rack construction for alpine terrain ca", icon: "cloud.rain.fill", destination: .technique("shelter-encyclopedia-infra-drying-alpine")),
                        TriageOption(id: "g1637", label: "Adapting drying rack construction for desert sand camps", icon: "mappin.and.ellipse", destination: .technique("shelter-encyclopedia-infra-drying-desert")),
                        TriageOption(id: "g1638", label: "Adapting drying rack construction for jungle canopy cam", icon: "mappin.and.ellipse", destination: .technique("shelter-encyclopedia-infra-drying-jungle")),
                        TriageOption(id: "g1639", label: "Build a permanent windbreak from available stone", icon: "cloud.fill", destination: .technique("shelter-rock-wall-windbreak")),
                        TriageOption(id: "g1640", label: "Tactical disposal of human waste for 1-3 day camps.", icon: "mappin.and.ellipse", destination: .technique("shelter-straddle-trench"))
                    ])
                )),
                TriageOption(id: "g1641", label: "Coniferous", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g1641-q", question: "Select:", options: [
                        TriageOption(id: "g1642", label: "Adapting drying rack construction for coniferous forest", icon: "mappin.and.ellipse", destination: .technique("shelter-encyclopedia-infra-drying-coniferous")),
                        TriageOption(id: "g1643", label: "Adapting drying rack construction for swampland camps.", icon: "mappin.and.ellipse", destination: .technique("shelter-encyclopedia-infra-drying-swampland")),
                        TriageOption(id: "g1644", label: "Adapting fire reflector wall construction for alpine te", icon: "flame.fill", destination: .technique("shelter-encyclopedia-infra-fire-alpine")),
                        TriageOption(id: "g1645", label: "Adapting fire reflector wall construction for coniferou", icon: "flame.fill", destination: .technique("shelter-encyclopedia-infra-fire-coniferous")),
                        TriageOption(id: "g1646", label: "Adapting fire reflector wall construction for desert sa", icon: "flame.fill", destination: .technique("shelter-encyclopedia-infra-fire-desert"))
                    ])
                )),
                TriageOption(id: "g1647", label: "Raised", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g1647-q", question: "Select:", options: [
                        TriageOption(id: "g1648", label: "Adapting raised bed platform construction for alpine te", icon: "cloud.rain.fill", destination: .technique("shelter-encyclopedia-infra-raised-alpine")),
                        TriageOption(id: "g1649", label: "Adapting raised bed platform construction for coniferou", icon: "mappin.and.ellipse", destination: .technique("shelter-encyclopedia-infra-raised-coniferous")),
                        TriageOption(id: "g1650", label: "Adapting raised bed platform construction for desert sa", icon: "mappin.and.ellipse", destination: .technique("shelter-encyclopedia-infra-raised-desert")),
                        TriageOption(id: "g1651", label: "Adapting raised bed platform construction for jungle ca", icon: "mappin.and.ellipse", destination: .technique("shelter-encyclopedia-infra-raised-jungle")),
                        TriageOption(id: "g1652", label: "Adapting raised bed platform construction for swampland", icon: "mappin.and.ellipse", destination: .technique("shelter-encyclopedia-infra-raised-swampland"))
                    ])
                )),
                TriageOption(id: "g1653", label: "Smokehouse", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g1653-q", question: "Select:", options: [
                        TriageOption(id: "g1654", label: "Adapting smokehouse rack construction for alpine terrai", icon: "cloud.rain.fill", destination: .technique("shelter-encyclopedia-infra-smokehouse-alpine")),
                        TriageOption(id: "g1655", label: "Adapting smokehouse rack construction for coniferous fo", icon: "mappin.and.ellipse", destination: .technique("shelter-encyclopedia-infra-smokehouse-coniferous")),
                        TriageOption(id: "g1656", label: "Adapting smokehouse rack construction for desert sand c", icon: "mappin.and.ellipse", destination: .technique("shelter-encyclopedia-infra-smokehouse-desert")),
                        TriageOption(id: "g1657", label: "Adapting smokehouse rack construction for jungle canopy", icon: "mappin.and.ellipse", destination: .technique("shelter-encyclopedia-infra-smokehouse-jungle")),
                        TriageOption(id: "g1658", label: "Adapting smokehouse rack construction for swampland cam", icon: "mappin.and.ellipse", destination: .technique("shelter-encyclopedia-infra-smokehouse-swampland"))
                    ])
                )),
                TriageOption(id: "g1659", label: "Meat", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g1659-q", question: "Select:", options: [
                        TriageOption(id: "g1660", label: "Adapting meat cache construction for alpine terrain cam", icon: "cloud.rain.fill", destination: .technique("shelter-encyclopedia-infra-meat-alpine")),
                        TriageOption(id: "g1661", label: "Adapting meat cache construction for coniferous forest ", icon: "mappin.and.ellipse", destination: .technique("shelter-encyclopedia-infra-meat-coniferous")),
                        TriageOption(id: "g1662", label: "Adapting meat cache construction for jungle canopy camp", icon: "mappin.and.ellipse", destination: .technique("shelter-encyclopedia-infra-meat-jungle")),
                        TriageOption(id: "g1663", label: "Adapting water filtration stand construction for alpine", icon: "cloud.rain.fill", destination: .technique("shelter-encyclopedia-infra-water-alpine")),
                        TriageOption(id: "g1664", label: "Adapting water filtration stand construction for jungle", icon: "mappin.and.ellipse", destination: .technique("shelter-encyclopedia-infra-water-jungle"))
                    ])
                )),
                TriageOption(id: "g1665", label: "Water", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g1665-q", question: "Select:", options: [
                        TriageOption(id: "g1666", label: "Adapting water filtration stand construction for conife", icon: "mappin.and.ellipse", destination: .technique("shelter-encyclopedia-infra-water-coniferous")),
                        TriageOption(id: "g1667", label: "Adapting water filtration stand construction for desert", icon: "mappin.and.ellipse", destination: .technique("shelter-encyclopedia-infra-water-desert")),
                        TriageOption(id: "g1668", label: "Adapting water filtration stand construction for swampl", icon: "mappin.and.ellipse", destination: .technique("shelter-encyclopedia-infra-water-swampland"))
                    ])
                ))
                ])
            )),

            TriageOption(id: "g1669", label: "Cold Weather", icon: "cloud.fill", destination: .nextQuestion(
                TriageNode(id: "g1669-q", question: "What specifically?", options: [
                TriageOption(id: "g1670", label: "Insulation", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g1670-q", question: "Select:", options: [
                        TriageOption(id: "g1671", label: "Stuffing clothes with leaves to survive cold without ge", icon: "cross.case.fill", destination: .technique("shelter-improvised-insulation")),
                        TriageOption(id: "g1672", label: "Improve warmth inside a snow shelter", icon: "house.fill", destination: .technique("shelter-snow-cave-insulation"))
                    ])
                )),
                TriageOption(id: "g1673", label: "Thermal", icon: "flame.fill", destination: .nextQuestion(
                    TriageNode(id: "g1673-q", question: "Select:", options: [
                        TriageOption(id: "g1674", label: "A greenhouse biome in sub-zero wilderness", icon: "flame.fill", destination: .technique("shelter-kochanski-super")),
                        TriageOption(id: "g1675", label: "Design a shelter that retains maximum heat", icon: "flame.fill", destination: .technique("shelter-thermal-trap"))
                    ])
                )),
                TriageOption(id: "g1676", label: "Packed", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g1676-q", question: "Select:", options: [
                        TriageOption(id: "g1677", label: "The ultimate cold-weather shelter — warm, quiet, and wi", icon: "house.fill", destination: .technique("shelter-igloo-construction")),
                        TriageOption(id: "g1678", label: "Using packed snow blocks to create wind shelter", icon: "house.fill", destination: .technique("shelter-snow-wall-windbreak"))
                    ])
                )),
                TriageOption(id: "g1679", label: "Underground", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g1679-q", question: "Select:", options: [
                        TriageOption(id: "g1680", label: "Digging into hillsides for extreme cold protection", icon: "house.fill", destination: .technique("shelter-underground-bunker"))
                    ])
                ))
                ])
            )),

            TriageOption(id: "g1681", label: "Concealment", icon: "cross.case.fill", destination: .nextQuestion(
                TriageNode(id: "g1681-q", question: "What specifically?", options: [
                TriageOption(id: "g1682", label: "Site", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g1682-q", question: "Select:", options: [
                        TriageOption(id: "g1683", label: "Dig a partially underground shelter for insulation", icon: "cloud.rain.fill", destination: .technique("shelter-pit-house")),
                        TriageOption(id: "g1684", label: "Concealed sub-surface evasion shelter", icon: "ant.fill", destination: .technique("shelter-spider-hole"))
                    ])
                )),
                TriageOption(id: "g1685", label: "Build", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g1685-q", question: "Select:", options: [
                        TriageOption(id: "g1686", label: "Build shelter for multiple people", icon: "house.fill", destination: .technique("shelter-group-shelter")),
                        TriageOption(id: "g1687", label: "Greenhouse survival shelter for deep cold", icon: "house.fill", destination: .technique("shelter-kochanski-supershelter"))
                    ])
                )),
                TriageOption(id: "g1688", label: "Vehicle", icon: "car.fill", destination: .nextQuestion(
                    TriageNode(id: "g1688-q", question: "Select:", options: [
                        TriageOption(id: "g1689", label: "Using a stranded vehicle as a survival shelter", icon: "house.fill", destination: .technique("shelter-vehicle-survival")),
                        TriageOption(id: "g1690", label: "Optimize a vehicle for emergency living", icon: "house.fill", destination: .technique("shelter-vehicle-shelter"))
                    ])
                )),
                TriageOption(id: "g1691", label: "Shelter", icon: "house.fill", destination: .nextQuestion(
                    TriageNode(id: "g1691-q", question: "Select:", options: [
                        TriageOption(id: "g1692", label: "Keep your shelter weather-worthy over weeks", icon: "cloud.rain.fill", destination: .technique("shelter-long-term-maintenance")),
                        TriageOption(id: "g1693", label: "Use sunlight to warm your shelter", icon: "sun.max.fill", destination: .technique("shelter-solar-heating"))
                    ])
                )),
                TriageOption(id: "g1694", label: "Personal", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g1694-q", question: "Select:", options: [
                        TriageOption(id: "g1695", label: "Disrupt your outline and blend in", icon: "cross.case.fill", destination: .technique("shelter-personal-camo"))
                    ])
                ))
                ])
            )),

            TriageOption(id: "g1696", label: "Desert Shelters", icon: "house.fill", destination: .nextQuestion(
                TriageNode(id: "g1696-q", question: "Which best matches?", options: [
                    TriageOption(id: "g1697", label: "Double-layered shade to survive extreme solar radiation", icon: "sun.max.fill", destination: .technique("shelter-desert-shade")),
                    TriageOption(id: "g1698", label: "Double-roof shade that drops temperature 30°F below amb", icon: "sun.max.fill", destination: .technique("shelter-desert-shade-structure")),
                    TriageOption(id: "g1699", label: "Avoiding extreme daytime desert heat", icon: "house.fill", destination: .technique("shelter-desert-subterranean")),
                    TriageOption(id: "g1700", label: "Escape extreme daytime heat using a subsurface trench", icon: "house.fill", destination: .technique("shelter-desert-trench-tarp")),
                    TriageOption(id: "g1701", label: "Below-grade shelter combining shade, water collection, ", icon: "sun.max.fill", destination: .technique("shelter-solar-still-shelter"))
                ])
            )),

            TriageOption(id: "g1702", label: "Emergency Shelter", icon: "house.fill", destination: .nextQuestion(
                TriageNode(id: "g1702-q", question: "What specifically?", options: [
                TriageOption(id: "g1703", label: "Build", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g1703-q", question: "Select:", options: [
                        TriageOption(id: "g1704", label: "Build a robust coastal shelter from driftwood", icon: "list.bullet.clipboard.fill", destination: .technique("shelter-coastal-driftwood-adv")),
                        TriageOption(id: "g1705", label: "Maximizing heat retention in a lean-to", icon: "house.fill", destination: .technique("shelter-lean-to-advanced")),
                        TriageOption(id: "g1706", label: "Build a comfortable insulating sleep surface", icon: "moon.fill", destination: .technique("shelter-bedding-layers")),
                        TriageOption(id: "g1707", label: "Seal shelter entrances from wind and cold", icon: "fish.fill", destination: .technique("shelter-door-insulation")),
                        TriageOption(id: "g1708", label: "Maximum warmth using fire and reflective materials", icon: "flame.fill", destination: .technique("shelter-super-shelter"))
                    ])
                )),
                TriageOption(id: "g1709", label: "Boreal", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g1709-q", question: "Select:", options: [
                        TriageOption(id: "g1710", label: "Deploying bark shingles specifically to shed the precip", icon: "cloud.fill", destination: .technique("shelter-encyclopedia-roofing-boreal-bark")),
                        TriageOption(id: "g1711", label: "Deploying canvas tarp specifically to shed the precipit", icon: "tent.fill", destination: .technique("shelter-encyclopedia-roofing-boreal-canvas")),
                        TriageOption(id: "g1712", label: "Deploying pine bough thatch specifically to shed the pr", icon: "cloud.fill", destination: .technique("shelter-encyclopedia-roofing-boreal-pine")),
                        TriageOption(id: "g1713", label: "Deploying snow blocks specifically to shed the precipit", icon: "cloud.fill", destination: .technique("shelter-encyclopedia-roofing-boreal-snow")),
                        TriageOption(id: "g1714", label: "Deploying sod/grass plugs specifically to shed the prec", icon: "cloud.fill", destination: .technique("shelter-encyclopedia-roofing-boreal-sod-grass"))
                    ])
                )),
                TriageOption(id: "g1715", label: "Arid", icon: "sun.max.fill", destination: .nextQuestion(
                    TriageNode(id: "g1715-q", question: "Select:", options: [
                        TriageOption(id: "g1716", label: "Deploying bark shingles specifically to shed the precip", icon: "cloud.fill", destination: .technique("shelter-encyclopedia-roofing-arid-bark")),
                        TriageOption(id: "g1717", label: "Deploying canvas tarp specifically to shed the precipit", icon: "tent.fill", destination: .technique("shelter-encyclopedia-roofing-arid-canvas")),
                        TriageOption(id: "g1718", label: "Deploying pine bough thatch specifically to shed the pr", icon: "cloud.fill", destination: .technique("shelter-encyclopedia-roofing-arid-pine")),
                        TriageOption(id: "g1719", label: "Deploying sand/earth berm specifically to shed the prec", icon: "cloud.fill", destination: .technique("shelter-encyclopedia-roofing-arid-sand-earth")),
                        TriageOption(id: "g1720", label: "Deploying sod/grass plugs specifically to shed the prec", icon: "cloud.fill", destination: .technique("shelter-encyclopedia-roofing-arid-sod-grass"))
                    ])
                )),
                TriageOption(id: "g1721", label: "Look", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g1721-q", question: "Select:", options: [
                        TriageOption(id: "g1722", label: "Assess and safely use a natural cave", icon: "bandage.fill", destination: .technique("shelter-cave-safety")),
                        TriageOption(id: "g1723", label: "Natural shelter improvement", icon: "house.fill", destination: .technique("shelter-rock-overhang-basic")),
                        TriageOption(id: "g1724", label: "Evaluate a site before building", icon: "cloud.rain.fill", destination: .technique("shelter-site-drainage-check"))
                    ])
                )),
                TriageOption(id: "g1725", label: "High", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g1725-q", question: "Select:", options: [
                        TriageOption(id: "g1726", label: "Deploying bark shingles specifically to shed the precip", icon: "cloud.fill", destination: .technique("shelter-encyclopedia-roofing-high-bark")),
                        TriageOption(id: "g1727", label: "Deploying canvas tarp specifically to shed the precipit", icon: "tent.fill", destination: .technique("shelter-encyclopedia-roofing-high-canvas")),
                        TriageOption(id: "g1728", label: "Deploying pine bough thatch specifically to shed the pr", icon: "cloud.fill", destination: .technique("shelter-encyclopedia-roofing-high-pine")),
                        TriageOption(id: "g1729", label: "Deploying snow blocks specifically to shed the precipit", icon: "cloud.fill", destination: .technique("shelter-encyclopedia-roofing-high-snow")),
                        TriageOption(id: "g1730", label: "Deploying sod/grass plugs specifically to shed the prec", icon: "cloud.fill", destination: .technique("shelter-encyclopedia-roofing-high-sod-grass"))
                    ])
                )),
                TriageOption(id: "g1731", label: "Shelter", icon: "house.fill", destination: .nextQuestion(
                    TriageNode(id: "g1731-q", question: "Select:", options: [
                        TriageOption(id: "g1732", label: "Use urban debris for survival insulation", icon: "target", destination: .technique("shelter-emergency-trash-insulation")),
                        TriageOption(id: "g1733", label: "Channel rain off your shelter roof", icon: "cloud.rain.fill", destination: .technique("shelter-rainwater-diversion")),
                        TriageOption(id: "g1734", label: "Prevent water pooling around your shelter", icon: "cloud.rain.fill", destination: .technique("shelter-drainage-system")),
                        TriageOption(id: "g1735", label: "Use your car as emergency shelter", icon: "house.fill", destination: .technique("shelter-vehicle-alt")),
                        TriageOption(id: "g1736", label: "Determine prevailing wind for shelter placement", icon: "list.bullet.clipboard.fill", destination: .technique("shelter-wind-assessment"))
                    ])
                )),
                TriageOption(id: "g1737", label: "Wind", icon: "cloud.fill", destination: .nextQuestion(
                    TriageNode(id: "g1737-q", question: "Select:", options: [
                        TriageOption(id: "g1738", label: "Last-resort shelter built in 15 minutes from found mate", icon: "house.fill", destination: .technique("shelter-brush-shelter")),
                        TriageOption(id: "g1739", label: "Quick wind protection from woven branches", icon: "flame.fill", destination: .technique("shelter-brush-wall")),
                        TriageOption(id: "g1740", label: "An insulated thermal envelope carved from a massive sno", icon: "flame.fill", destination: .technique("shelter-snow-trench-quinzee")),
                        TriageOption(id: "g1741", label: "Building a traditional conical brush shelter", icon: "house.fill", destination: .technique("shelter-wickiup-construction")),
                        TriageOption(id: "g1742", label: "Block wind in minutes with stacked natural materials", icon: "cloud.fill", destination: .technique("shelter-debris-wall"))
                    ])
                )),
                TriageOption(id: "g1743", label: "Tropical", icon: "leaf.fill", destination: .nextQuestion(
                    TriageNode(id: "g1743-q", question: "Select:", options: [
                        TriageOption(id: "g1744", label: "Deploying bark shingles specifically to shed the precip", icon: "cloud.fill", destination: .technique("shelter-encyclopedia-roofing-tropical-bark")),
                        TriageOption(id: "g1745", label: "Deploying pine bough thatch specifically to shed the pr", icon: "cloud.fill", destination: .technique("shelter-encyclopedia-roofing-tropical-pine")),
                        TriageOption(id: "g1746", label: "Deploying sod/grass plugs specifically to shed the prec", icon: "cloud.fill", destination: .technique("shelter-encyclopedia-roofing-tropical-sod-grass")),
                        TriageOption(id: "g1747", label: "Elevating sleeping quarters above water and crawling in", icon: "ant.fill", destination: .technique("shelter-swamp-swedebed")),
                        TriageOption(id: "g1748", label: "Deploying woven palm/broadleaf specifically to shed the", icon: "flame.fill", destination: .technique("shelter-encyclopedia-roofing-tropical-woven"))
                    ])
                )),
                TriageOption(id: "g1749", label: "Coastal", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g1749-q", question: "Select:", options: [
                        TriageOption(id: "g1750", label: "Deploying canvas tarp specifically to shed the precipit", icon: "tent.fill", destination: .technique("shelter-encyclopedia-roofing-tropical-canvas")),
                        TriageOption(id: "g1751", label: "Deploying pine bough thatch specifically to shed the pr", icon: "cloud.fill", destination: .technique("shelter-encyclopedia-roofing-coastal-pine")),
                        TriageOption(id: "g1752", label: "Deploying sand/earth berm specifically to shed the prec", icon: "cloud.fill", destination: .technique("shelter-encyclopedia-roofing-tropical-sand-earth")),
                        TriageOption(id: "g1753", label: "Deploying sod/grass plugs specifically to shed the prec", icon: "cloud.fill", destination: .technique("shelter-encyclopedia-roofing-coastal-sod-grass")),
                        TriageOption(id: "g1754", label: "Deploying woven palm/broadleaf specifically to shed the", icon: "flame.fill", destination: .technique("shelter-encyclopedia-roofing-coastal-woven"))
                    ])
                )),
                TriageOption(id: "g1755", label: "Coastal (2)", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g1755-q", question: "Select:", options: [
                        TriageOption(id: "g1756", label: "Deploying bark shingles specifically to shed the precip", icon: "cloud.fill", destination: .technique("shelter-encyclopedia-roofing-coastal-bark")),
                        TriageOption(id: "g1757", label: "Deploying canvas tarp specifically to shed the precipit", icon: "tent.fill", destination: .technique("shelter-encyclopedia-roofing-coastal-canvas")),
                        TriageOption(id: "g1758", label: "Deploying pine bough thatch specifically to shed the pr", icon: "cloud.fill", destination: .technique("shelter-encyclopedia-roofing-temperate-pine")),
                        TriageOption(id: "g1759", label: "Deploying sand/earth berm specifically to shed the prec", icon: "cloud.fill", destination: .technique("shelter-encyclopedia-roofing-coastal-sand-earth")),
                        TriageOption(id: "g1760", label: "Deploying woven palm/broadleaf specifically to shed the", icon: "flame.fill", destination: .technique("shelter-encyclopedia-roofing-temperate-woven"))
                    ])
                )),
                TriageOption(id: "g1761", label: "Temperate", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g1761-q", question: "Select:", options: [
                        TriageOption(id: "g1762", label: "Deploying bark shingles specifically to shed the precip", icon: "cloud.fill", destination: .technique("shelter-encyclopedia-roofing-temperate-bark")),
                        TriageOption(id: "g1763", label: "Deploying canvas tarp specifically to shed the precipit", icon: "tent.fill", destination: .technique("shelter-encyclopedia-roofing-temperate-canvas")),
                        TriageOption(id: "g1764", label: "Deploying sand/earth berm specifically to shed the prec", icon: "cloud.fill", destination: .technique("shelter-encyclopedia-roofing-temperate-sand-earth")),
                        TriageOption(id: "g1765", label: "Deploying snow blocks specifically to shed the precipit", icon: "cloud.fill", destination: .technique("shelter-encyclopedia-roofing-temperate-snow")),
                        TriageOption(id: "g1766", label: "Deploying sod/grass plugs specifically to shed the prec", icon: "cloud.fill", destination: .technique("shelter-encyclopedia-roofing-temperate-sod-grass"))
                    ])
                ))
                ])
            )),

            TriageOption(id: "g1767", label: "Environment", icon: "cross.case.fill", destination: .nextQuestion(
                TriageNode(id: "g1767-q", question: "Which best matches?", options: [
                    TriageOption(id: "g1768", label: "Avoiding malaria, dengue, and waterborne illness", icon: "ant.fill", destination: .technique("env-tropical-disease-adv"))
                ])
            )),

            TriageOption(id: "g1769", label: "Environmental Medicine", icon: "cross.case.fill", destination: .nextQuestion(
                TriageNode(id: "g1769-q", question: "Which best matches?", options: [
                    TriageOption(id: "g1770", label: "Stop progression to heat stroke — which is fatal", icon: "brain.head.profile", destination: .technique("env-heat-exhaustion-treatment"))
                ])
            )),

            TriageOption(id: "g1771", label: "Forest Shelters", icon: "house.fill", destination: .nextQuestion(
                TriageNode(id: "g1771-q", question: "Which best matches?", options: [
                    TriageOption(id: "g1772", label: "Build a raised shelter in the trees", icon: "house.fill", destination: .technique("shelter-tree-house-platform")),
                    TriageOption(id: "g1773", label: "Create an off-ground sleeping platform from available m", icon: "moon.fill", destination: .technique("shelter-hammock-improvised"))
                ])
            )),

            TriageOption(id: "g1774", label: "Tarp Setups", icon: "tent.fill", destination: .nextQuestion(
                TriageNode(id: "g1774-q", question: "What specifically?", options: [
                TriageOption(id: "g1775", label: "Single", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g1775-q", question: "Select:", options: [
                        TriageOption(id: "g1776", label: "Quick military-style shelter from a single poncho or ta", icon: "house.fill", destination: .technique("shelter-poncho-hooch")),
                        TriageOption(id: "g1777", label: "Multiple shelter designs from a single poncho", icon: "house.fill", destination: .technique("shelter-poncho-configs"))
                    ])
                )),
                TriageOption(id: "g1778", label: "Plow", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g1778-q", question: "Select:", options: [
                        TriageOption(id: "g1779", label: "Maximum wind resistance tarp setup", icon: "tent.fill", destination: .technique("shelter-tarp-plow-point-advanced")),
                        TriageOption(id: "g1780", label: "Fast, 1-tie setup", icon: "tent.fill", destination: .technique("shelter-tarp-plow-alt"))
                    ])
                )),
                TriageOption(id: "g1781", label: "Lean", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g1781-q", question: "Select:", options: [
                        TriageOption(id: "g1782", label: "Open front, heating shelter", icon: "house.fill", destination: .technique("shelter-tarp-leanto-alt")),
                        TriageOption(id: "g1783", label: "Maximum heat shelter configuration in cold weather", icon: "flame.fill", destination: .technique("shelter-tarp-lean-to"))
                    ])
                )),
                TriageOption(id: "g1784", label: "Tarp", icon: "tent.fill", destination: .nextQuestion(
                    TriageNode(id: "g1784-q", question: "Select:", options: [
                        TriageOption(id: "g1785", label: "One tarp, eight different shelters for every condition", icon: "house.fill", destination: .technique("shelter-tarp-configurations"))
                    ])
                ))
                ])
            )),

            TriageOption(id: "g1786", label: "Tropical Climate", icon: "leaf.fill", destination: .nextQuestion(
                TriageNode(id: "g1786-q", question: "What specifically?", options: [
                TriageOption(id: "g1787", label: "Build", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g1787-q", question: "Select:", options: [
                        TriageOption(id: "g1788", label: "Build a sturdy tropical shelter using bamboo", icon: "house.fill", destination: .technique("shelter-bamboo-frame")),
                        TriageOption(id: "g1789", label: "Stay dry and off the ground in tropical forests", icon: "house.fill", destination: .technique("env-jungle-shelter-adv")),
                        TriageOption(id: "g1790", label: "Build an elevated sleeping platform in wet terrain", icon: "cloud.rain.fill", destination: .technique("shelter-raised-swamp-bed"))
                    ])
                )),
                TriageOption(id: "g1791", label: "Rectangle", icon: "fish.fill", destination: .nextQuestion(
                    TriageNode(id: "g1791-q", question: "Select:", options: [
                        TriageOption(id: "g1792", label: "Sleep above water and mud in wetland environments", icon: "fish.fill", destination: .technique("shelter-swamp-platform")),
                        TriageOption(id: "g1793", label: "Sleeping above standing water on a pole frame", icon: "fish.fill", destination: .technique("shelter-swamp-raised-bed"))
                    ])
                )),
                TriageOption(id: "g1794", label: "Waterways", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g1794-q", question: "Select:", options: [
                        TriageOption(id: "g1795", label: "Moving through dense tropical forest without getting lo", icon: "leaf.fill", destination: .technique("env-jungle-movement-adv")),
                        TriageOption(id: "g1796", label: "Navigating slow-moving, biologically hazardous waterway", icon: "list.bullet.clipboard.fill", destination: .technique("env-jungle-river-crossing"))
                    ])
                )),
                TriageOption(id: "g1797", label: "Hammock", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g1797-q", question: "Select:", options: [
                        TriageOption(id: "g1798", label: "Elevated sleeping platform with rain protection", icon: "cloud.rain.fill", destination: .technique("shelter-hammock-tarp")),
                        TriageOption(id: "g1799", label: "Building a functional hammock from cordage", icon: "building.2.fill", destination: .technique("shelter-para-hammock")),
                        TriageOption(id: "g1800", label: "Sleep safely above ground hazards, water, and cold soil", icon: "flame.fill", destination: .technique("shelter-hammock-suspension"))
                    ])
                )),
                TriageOption(id: "g1801", label: "Jungle", icon: "leaf.fill", destination: .nextQuestion(
                    TriageNode(id: "g1801-q", question: "Select:", options: [
                        TriageOption(id: "g1802", label: "Route selection and daily rhythm in tropical forest", icon: "brain.fill", destination: .technique("env-jungle-travel-plan")),
                        TriageOption(id: "g1803", label: "Water is everywhere in the jungle — know where to look", icon: "leaf.fill", destination: .technique("env-jungle-water-adv"))
                    ])
                ))
                ])
            )),

            TriageOption(id: "g1804", label: "Urban Survival", icon: "building.2.fill", destination: .nextQuestion(
                TriageNode(id: "g1804-q", question: "Which best matches?", options: [
                    TriageOption(id: "g1805", label: "Navigate collapsed urban environment safely", icon: "list.bullet.clipboard.fill", destination: .technique("env-urban-survival-basics"))
                ])
            )),
        ])
    }

}
