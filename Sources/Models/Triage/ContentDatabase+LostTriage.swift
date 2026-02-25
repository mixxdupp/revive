import Foundation

// Auto-generated: buildLostTriage extracted from ContentDatabase.swift
extension ContentDatabase {
    // =========================================================================
    // MARK: - LOST / NAVIGATION (6 levels deep)
    // =========================================================================
    func buildLostTriage() -> TriageNode {
        TriageNode(id: "lost-root", question: "When did you realize you're lost?", options: [

            // Just now
            TriageOption(id: "lost-just", label: "Just Now", icon: "exclamationmark.circle", destination: .nextQuestion(
                TriageNode(id: "lost-stop", question: "STOP. Do not move. Can you backtrack?", options: [
                    TriageOption(id: "lost-backtrack", label: "Yes — Remember the Way", icon: "arrow.uturn.left", destination: .technique("nav-lost-procedure")),
                    TriageOption(id: "lost-unsure", label: "Not Sure / Disoriented", icon: "questionmark.circle.fill", destination: .nextQuestion(
                        TriageNode(id: "lost-tools", question: "What navigation tools do you have?", options: [
                            TriageOption(id: "lost-phone", label: "Phone (Any Battery)", icon: "iphone", destination: .techniqueList(["nav-gps-phone", "rescue-plb"])), // Added orphan
                            TriageOption(id: "lost-altimeter", label: "Altimeter / Watch", icon: "gauge", destination: .technique("nav-altimeter")), // Added orphan
                            TriageOption(id: "lost-compass", label: "Compass", icon: "safari.fill", destination: .techniqueList(["nav-compass-use", "nav-emergency-bearing", "nav-night-compass"])), // Added orphans
                            TriageOption(id: "lost-map-compass", label: "Map + Compass", icon: "map.fill", destination: .techniqueList(["nav-map-reading", "nav-triangulation"])), // Added orphan
                            TriageOption(id: "lost-no-tools", label: "Nothing — No Tools", icon: "xmark.circle.fill", destination: .nextQuestion(
                                TriageNode(id: "lost-time", question: "What time of day?", options: [

                                    // Daytime
                                    TriageOption(id: "lost-day", label: "Daytime", icon: "sun.max.fill", destination: .nextQuestion(
                                        TriageNode(id: "lost-sun", question: "Can you see the sun?", options: [
                                            TriageOption(id: "lost-sun-yes", label: "Sun Visible", icon: "sun.max.fill", destination: .nextQuestion(
                                                TriageNode(id: "lost-sun-method", question: "Do you have an analog watch?", options: [
                                                    TriageOption(id: "lost-watch-yes", label: "Yes — Analog Watch", icon: "clock.fill", destination: .technique("nav-watch-compass")),
                                                    TriageOption(id: "lost-watch-no", label: "No / Digital Only", icon: "digitalcrown.horizontal.arrow.counterclockwise.fill", destination: .nextQuestion(
                                                        TriageNode(id: "lost-sun-tools", question: "Choose a method:", options: [
                                                            TriageOption(id: "lost-stick", label: "Stick + 20 Minutes", icon: "pencil", destination: .technique("nav-stick-shadow")),
                                                            TriageOption(id: "lost-quick", label: "Quick Sun Estimate", icon: "location.fill", destination: .technique("nav-sun-position"))
                                                        ])
                                                    ))
                                                ])
                                            )),
                                            TriageOption(id: "lost-overcast", label: "Overcast / Can't See Sun", icon: "cloud.fill", destination: .techniqueList(["nav-natural-indicators", "nav-vegetation-indicators", "nav-wind-reading", "nav-cloud-reading"])) // Added orphans
                                        ])
                                    )),

                                    // Nighttime
                                    TriageOption(id: "lost-night", label: "Nighttime", icon: "moon.fill", destination: .nextQuestion(
                                        TriageNode(id: "lost-stars", question: "Can you see stars or moon?", options: [
                                            TriageOption(id: "lost-stars-visible", label: "Yes — Clear Sky", icon: "star.fill", destination: .nextQuestion(
                                                TriageNode(id: "lost-star-method", question: "Which method?", options: [
                                                    TriageOption(id: "lost-stars-n", label: "North Star (N. Hemisphere)", icon: "star.fill", destination: .technique("nav-north-star")),
                                                    TriageOption(id: "lost-stars-s", label: "Southern Cross (S. Hemisphere)", icon: "star.fill", destination: .technique("nav-southern-cross")),
                                                    TriageOption(id: "lost-star-any", label: "Any Star (Movement)", icon: "sparkles", destination: .techniqueList(["nav-star-movement", "nav-night-star-steering"])), // Added orphan
                                                    TriageOption(id: "lost-moon", label: "Moon (Crescent)", icon: "moon.fill", destination: .technique("nav-moon-navigation"))
                                                ])
                                            )),
                                            TriageOption(id: "lost-no-sky", label: "No — Cloudy/Overcast", icon: "cloud.fill", destination: .nextQuestion(
                                                TriageNode(id: "lost-cloud-action", question: "What should you do?", options: [
                                                ])
                                            ))
                                        ])
                                    )),

                                    // Dawn/Dusk
                                ])
                            ))
                        ])
                    ))
                ])
            )),

            // Been lost
            TriageOption(id: "lost-long", label: "Been Lost — Need Strategy", icon: "clock.fill", destination: .nextQuestion(
                TriageNode(id: "lost-strategy", question: "What's your plan?", options: [
                    TriageOption(id: "lost-stay", label: "Stay Put & Signal for Rescue", icon: "hand.raised.fill", destination: .nextQuestion(
                        TriageNode(id: "lost-signal-q", question: "What signaling tools do you have?", options: [
                            TriageOption(id: "lost-sig-whistle", label: "Whistle / Loud Voice", icon: "speaker.wave.3.fill", destination: .techniqueList(["rescue-whistle", "rescue-whistle-patterns"])), // Added orphan
                            TriageOption(id: "lost-sig-smoke", label: "Colored Smoke (Daytime)", icon: "smoke.fill", destination: .technique("rescue-smoke-signal")),
                            TriageOption(id: "lost-sig-ground", label: "Open Ground for Symbols", icon: "square.fill", destination: .techniqueList(["rescue-ground-signal", "rescue-flag-signals"])), // Added orphan
                            TriageOption(id: "lost-sig-panel", label: "Know ICAO Panel Codes", icon: "textformat", destination: .technique("rescue-panel-signals")),
                        ])
                    )),
                    TriageOption(id: "lost-walk", label: "Self-Rescue / Walk Out", icon: "figure.walk", destination: .nextQuestion(
                        TriageNode(id: "lost-walk-q", question: "Can you see or hear any landmark?", options: [
                            TriageOption(id: "lost-hear-water", label: "Can Hear Water", icon: "water.waves", destination: .technique("nav-river-following")),
                            TriageOption(id: "lost-see-ridge", label: "Can See Ridge / High Ground", icon: "mountain.2.fill", destination: .techniqueList(["nav-terrain-association", "nav-handrail-features"])), // Added orphan
                            TriageOption(id: "lost-road", label: "Found a Trail / Road", icon: "road.lanes", destination: .technique("nav-dead-reckoning")),
                            TriageOption(id: "lost-urban-mark", label: "In Urban Area", icon: "building.2.fill", destination: .technique("rescue-urban-marking")), // Added orphan
                            TriageOption(id: "lost-wind", label: "Open Area — Check Wind/Tree Lean", icon: "wind", destination: .technique("nav-wind-patterns")),
                            TriageOption(id: "lost-dense", label: "Dense Forest / No Features", icon: "tree.fill", destination: .nextQuestion(
                                TriageNode(id: "lost-dense-q", question: "What do you want to do?", options: [
                                    TriageOption(id: "lost-leave-trail", label: "Walk + Leave Trail Markers", icon: "arrow.triangle.branch", destination: .technique("rescue-trail-markers"))
                                ])
                            ))
                        ])
                    ))
                ])
            )),

            // Navigating by Environment
            TriageOption(id: "lost-env-nav", label: "Navigate by Environment", icon: "map.fill", destination: .nextQuestion(
                TriageNode(id: "lost-env-q", question: "What terrain are you in?", options: [
                    TriageOption(id: "lost-nav-coastal", label: "Coastal / Shoreline", icon: "water.waves", destination: .techniqueList(["nav-coastal", "nav-coastal-navigation"])),
                    TriageOption(id: "lost-nav-urban", label: "Urban / City", icon: "building.2.fill", destination: .technique("nav-urban")),
                    TriageOption(id: "lost-nav-weather", label: "Read Weather for Direction", icon: "cloud.sun.fill", destination: .technique("nav-weather-prediction")),
                    TriageOption(id: "lost-nav-altitude", label: "Estimate Altitude", icon: "mountain.2.fill", destination: .technique("nav-altitude-estimation"))
                ])
            )),

            // Advanced Compass & Bearing
            TriageOption(id: "lost-adv-compass", label: "Advanced Compass Skills", icon: "safari.fill", destination: .nextQuestion(
                TriageNode(id: "lost-adv-q", question: "What do you need?", options: [
                    TriageOption(id: "lost-back-bearing", label: "Back Bearing", icon: "arrow.uturn.left", destination: .technique("nav-back-bearing")),
                    TriageOption(id: "lost-deliberate", label: "Deliberate Offset", icon: "arrow.right.and.line.vertical.and.arrow.left", destination: .technique("nav-deliberate-offset")),
                    TriageOption(id: "lost-magnetic", label: "Magnetic Deviation", icon: "minus.plus.batteryblock.fill", destination: .technique("nav-magnetic-deviation")),
                    TriageOption(id: "lost-pace", label: "Pace Beading (Distance)", icon: "figure.walk", destination: .technique("nav-pace-beading")),
                    TriageOption(id: "lost-shadow-tip", label: "Shadow Tip Compass", icon: "sun.min.fill", destination: .technique("nav-shadow-tip-compass")),
                    TriageOption(id: "lost-sun-noon", label: "Sun at Noon (True South)", icon: "sun.max.fill", destination: .technique("nav-sun-noon"))
                ])
            )),

            // 📚 LEARN MORE
            TriageOption(id: "lost-learn", label: "Learn More", icon: "book.fill", destination: .nextQuestion(
                TriageNode(id: "lost-learn-q", question: "What would you like to read about?", options: [
                    TriageOption(id: "lost-art-unlost", label: "Getting Un-Lost", icon: "location.fill", destination: .article("nav-article-getting-unlost")),
                    TriageOption(id: "lost-art-lost", label: "Psychology of Being Lost", icon: "brain.head.profile", destination: .article("nav-article-lost")),
                    TriageOption(id: "lost-art-celestial", label: "Celestial Navigation", icon: "star.fill", destination: .article("nav-article-celestial")),
                    TriageOption(id: "lost-art-map", label: "Map Reading Basics", icon: "map.fill", destination: .article("nav-article-map-basics")),
                    TriageOption(id: "lost-art-terrain", label: "Terrain Association", icon: "mountain.2.fill", destination: .article("nav-article-terrain")),
                    TriageOption(id: "lost-art-gps", label: "GPS Navigation", icon: "antenna.radiowaves.left.and.right", destination: .articleList(["nav-article-gps", "nav-article-gps-limitations"])),
                    TriageOption(id: "lost-art-magnetic", label: "Magnetic Declination", icon: "safari", destination: .articleList(["nav-article-magnetic", "nav-article-declination"])),
                    TriageOption(id: "lost-art-night", label: "Night Navigation", icon: "moon.stars.fill", destination: .articleList(["nav-article-night", "nav-article-night-nav"])),
                    TriageOption(id: "lost-art-dense", label: "Dense Forest Navigation", icon: "tree.fill", destination: .article("nav-article-dense-forest")),
                    TriageOption(id: "lost-art-urban", label: "Urban Navigation", icon: "building.2.fill", destination: .article("nav-article-urban-nav")),
                    TriageOption(id: "lost-art-emergency", label: "Emergency Navigation", icon: "exclamationmark.triangle.fill", destination: .article("nav-article-emergency"))
                ])
            )),

            TriageOption(id: "g1433", label: "Compass & Map", icon: "location.north.fill", destination: .nextQuestion(
                TriageNode(id: "g1433-q", question: "What specifically?", options: [
                TriageOption(id: "g1434", label: "Look", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g1434-q", question: "Select:", options: [
                        TriageOption(id: "g1435", label: "Look behind you regularly to remember the return route", icon: "flame.fill", destination: .technique("nav-back-bearing-check")),
                        TriageOption(id: "g1436", label: "A low point or sinkhole.", icon: "cross.case.fill", destination: .technique("nav-terrain-depression")),
                        TriageOption(id: "g1437", label: "Identifying a peak from contour lines.", icon: "cross.case.fill", destination: .technique("nav-terrain-hill")),
                        TriageOption(id: "g1438", label: "A line of high ground.", icon: "mountain.2.fill", destination: .technique("nav-terrain-ridge")),
                        TriageOption(id: "g1439", label: "Low ground flanked by high ground.", icon: "mountain.2.fill", destination: .technique("nav-terrain-valley"))
                    ])
                )),
                TriageOption(id: "g1440", label: "Analog", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g1440-q", question: "Select:", options: [
                        TriageOption(id: "g1441", label: "Finding North/South using the hour hand in the Northern", icon: "location.north.fill", destination: .technique("nav-analog-watch-method")),
                        TriageOption(id: "g1442", label: "Applying analog watch directional finding inside a Deep", icon: "list.bullet.clipboard.fill", destination: .technique("nav-encyclopedia-improv-analog-deep")),
                        TriageOption(id: "g1443", label: "Applying analog watch directional finding inside a Feat", icon: "list.bullet.clipboard.fill", destination: .technique("nav-encyclopedia-improv-analog-featureless")),
                        TriageOption(id: "g1444", label: "Applying analog watch directional finding inside a Open", icon: "list.bullet.clipboard.fill", destination: .technique("nav-encyclopedia-improv-analog-open")),
                        TriageOption(id: "g1445", label: "Use an analog watch to find North in the Southern Hemis", icon: "cross.case.fill", destination: .technique("nav-watch-method-southern"))
                    ])
                )),
                TriageOption(id: "g1446", label: "Ground", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g1446-q", question: "Select:", options: [
                        TriageOption(id: "g1447", label: "Create a usable map from observation when you have no m", icon: "location.north.fill", destination: .technique("nav-field-sketch-map")),
                        TriageOption(id: "g1448", label: "Measuring distance traveled using calibrated steps", icon: "cross.case.fill", destination: .technique("nav-pace-count")),
                        TriageOption(id: "g1449", label: "Finding east-west line using shadow movement", icon: "leaf.fill", destination: .technique("nav-sun-shadow-stick"))
                    ])
                )),
                TriageOption(id: "g1450", label: "Deep", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g1450-q", question: "Select:", options: [
                        TriageOption(id: "g1451", label: "Applying improvised magnetic needle directional finding", icon: "scissors", destination: .technique("nav-encyclopedia-improv-improvised-deep")),
                        TriageOption(id: "g1452", label: "Applying moss/vegetation bias directional finding insid", icon: "list.bullet.clipboard.fill", destination: .technique("nav-encyclopedia-improv-moss/vegetation-deep")),
                        TriageOption(id: "g1453", label: "Applying prevailing wind striations directional finding", icon: "list.bullet.clipboard.fill", destination: .technique("nav-encyclopedia-improv-prevailing-deep")),
                        TriageOption(id: "g1454", label: "Applying shadow-tip directional finding inside a Deep e", icon: "list.bullet.clipboard.fill", destination: .technique("nav-encyclopedia-improv-shadowtip-deep"))
                    ])
                )),
                TriageOption(id: "g1455", label: "Bearing", icon: "location.north.fill", destination: .nextQuestion(
                    TriageNode(id: "g1455-q", question: "Select:", options: [
                        TriageOption(id: "g1456", label: "Military-grade point-to-point land navigation", icon: "location.north.fill", destination: .technique("nav-army-dead-reckoning")),
                        TriageOption(id: "g1457", label: "Navigate to a precise point using bearing and distance ", icon: "location.north.fill", destination: .technique("nav-dead-reckoning-advanced")),
                        TriageOption(id: "g1458", label: "Verifying your direction by looking back", icon: "location.north.fill", destination: .technique("nav-reciprocal-bearing"))
                    ])
                )),
                TriageOption(id: "g1459", label: "Railroad", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g1459-q", question: "Select:", options: [
                        TriageOption(id: "g1460", label: "Retracing your steps when hopelessly lost", icon: "pawprint.fill", destination: .technique("nav-backtracking")),
                        TriageOption(id: "g1461", label: "Understanding contour lines, scale, and orientation", icon: "location.north.fill", destination: .technique("nav-map-reading-basic")),
                        TriageOption(id: "g1462", label: "Following linear features to avoid getting lost", icon: "cloud.rain.fill", destination: .technique("nav-handrail-navigation")),
                        TriageOption(id: "g1463", label: "Magnetizing a needle to find North", icon: "scissors", destination: .technique("nav-float-compass")),
                        TriageOption(id: "g1464", label: "Use railroad tracks to navigate to civilization", icon: "pawprint.fill", destination: .technique("env-railroad-navigation"))
                    ])
                )),
                TriageOption(id: "g1465", label: "Identify", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g1465-q", question: "Select:", options: [
                        TriageOption(id: "g1466", label: "Intentionally targeting left or right of destination", icon: "cross.case.fill", destination: .technique("nav-aiming-off-technique")),
                        TriageOption(id: "g1467", label: "Precision navigation from a known feature to a target", icon: "cross.case.fill", destination: .technique("nav-attack-point-navigation")),
                        TriageOption(id: "g1468", label: "Maintaining elevation while traversing slopes", icon: "cross.case.fill", destination: .technique("nav-contour-navigation")),
                        TriageOption(id: "g1469", label: "Determining your position using two known landmarks", icon: "location.north.fill", destination: .technique("nav-resection-position")),
                        TriageOption(id: "g1470", label: "Using hill slope direction for orientation", icon: "location.north.fill", destination: .technique("nav-slope-aspect-navigation"))
                    ])
                )),
                TriageOption(id: "g1471", label: "Moss", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g1471-q", question: "Select:", options: [
                        TriageOption(id: "g1472", label: "Understanding the limitations of the moss myth", icon: "cross.case.fill", destination: .technique("nav-moss-myth-reality")),
                        TriageOption(id: "g1473", label: "Moving safely after dark", icon: "eye.fill", destination: .technique("nav-night-travel-techniques")),
                        TriageOption(id: "g1474", label: "Route finding in whiteout and snowfields", icon: "cross.case.fill", destination: .technique("nav-snow-travel-techniques")),
                        TriageOption(id: "g1475", label: "Using city infrastructure for orientation", icon: "location.north.fill", destination: .technique("nav-urban-navigation-signs")),
                        TriageOption(id: "g1476", label: "Using drainage patterns to find civilization", icon: "cloud.rain.fill", destination: .technique("nav-watershed-navigation"))
                    ])
                )),
                TriageOption(id: "g1477", label: "North", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g1477-q", question: "Select:", options: [
                        TriageOption(id: "g1478", label: "Extending electronic navigation device life", icon: "bolt.fill", destination: .technique("nav-gps-battery-conservation")),
                        TriageOption(id: "g1479", label: "What to do when electronics die — and they WILL die", icon: "brain.fill", destination: .technique("nav-gps-failure-backup")),
                        TriageOption(id: "g1480", label: "The difference between true north and magnetic north — ", icon: "fish.fill", destination: .technique("nav-magnetic-declination")),
                        TriageOption(id: "g1481", label: "Combine map reading and compass into precision navigati", icon: "scissors", destination: .technique("nav-orienteering-basics")),
                        TriageOption(id: "g1482", label: "Interpret contour lines, scale, and symbols", icon: "cloud.rain.fill", destination: .technique("nav-map-reading-basics"))
                    ])
                )),
                TriageOption(id: "g1483", label: "Phone", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g1483-q", question: "Select:", options: [
                        TriageOption(id: "g1484", label: "Locating an unknown point from two known positions.", icon: "cross.case.fill", destination: .technique("nav-nav-intersection")),
                        TriageOption(id: "g1485", label: "Use phone compass without cellular or GPS signal", icon: "fish.fill", destination: .technique("nav-mantis-nav")),
                        TriageOption(id: "g1486", label: "Pinpointing your exact map location.", icon: "location.north.fill", destination: .technique("nav-nav-resection")),
                        TriageOption(id: "g1487", label: "Navigating by mapping topography to reality", icon: "cloud.rain.fill", destination: .technique("nav-army-terrain-association")),
                        TriageOption(id: "g1488", label: "A dip between two high points.", icon: "cross.case.fill", destination: .technique("nav-terrain-saddle"))
                    ])
                )),
                TriageOption(id: "g1489", label: "Identify (2)", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g1489-q", question: "Select:", options: [
                        TriageOption(id: "g1490", label: "Identifying and utilizing a Cut on an MGRS military top", icon: "location.north.fill", destination: .technique("nav-encyclopedia-terrain-cut")),
                        TriageOption(id: "g1491", label: "Identifying and utilizing a Draw on an MGRS military to", icon: "location.north.fill", destination: .technique("nav-encyclopedia-terrain-draw")),
                        TriageOption(id: "g1492", label: "Identifying and utilizing a Fill on an MGRS military to", icon: "location.north.fill", destination: .technique("nav-encyclopedia-terrain-fill")),
                        TriageOption(id: "g1493", label: "Identifying and utilizing a Spur on an MGRS military to", icon: "location.north.fill", destination: .technique("nav-encyclopedia-terrain-spur")),
                        TriageOption(id: "g1494", label: "Failsafe directional travel without a specific point.", icon: "cross.case.fill", destination: .technique("nav-nav-baselines"))
                    ])
                )),
                TriageOption(id: "g1495", label: "Contour", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g1495-q", question: "Select:", options: [
                        TriageOption(id: "g1496", label: "Identifying and utilizing a Cliff on an MGRS military t", icon: "location.north.fill", destination: .technique("nav-encyclopedia-terrain-cliff")),
                        TriageOption(id: "g1497", label: "Identifying and utilizing a Index Contour on an MGRS mi", icon: "location.north.fill", destination: .technique("nav-encyclopedia-terrain-index-contour")),
                        TriageOption(id: "g1498", label: "Identifying and utilizing a Intermittent Stream on an M", icon: "location.north.fill", destination: .technique("nav-encyclopedia-terrain-intermittent-stream")),
                        TriageOption(id: "g1499", label: "Identifying and utilizing a Marsh on an MGRS military t", icon: "location.north.fill", destination: .technique("nav-encyclopedia-terrain-marsh")),
                        TriageOption(id: "g1500", label: "Identifying and utilizing a Supplementary Contour on an", icon: "location.north.fill", destination: .technique("nav-encyclopedia-terrain-supplementary-contour"))
                    ])
                )),
                TriageOption(id: "g1501", label: "North (2)", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g1501-q", question: "Select:", options: [
                        TriageOption(id: "g1502", label: "Identifying and utilizing a Benchmark on an MGRS milita", icon: "location.north.fill", destination: .technique("nav-encyclopedia-terrain-benchmark")),
                        TriageOption(id: "g1503", label: "Identifying and utilizing a Declination Diagram on an M", icon: "location.north.fill", destination: .technique("nav-encyclopedia-terrain-declination-diagram")),
                        TriageOption(id: "g1504", label: "Identifying and utilizing a Grid North on an MGRS milit", icon: "location.north.fill", destination: .technique("nav-encyclopedia-terrain-grid-north")),
                        TriageOption(id: "g1505", label: "Identifying and utilizing a Magnetic North on an MGRS m", icon: "fish.fill", destination: .technique("nav-encyclopedia-terrain-magnetic-north")),
                        TriageOption(id: "g1506", label: "Identifying and utilizing a True North on an MGRS milit", icon: "location.north.fill", destination: .technique("nav-encyclopedia-terrain-true-north"))
                    ])
                )),
                TriageOption(id: "g1507", label: "Open", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g1507-q", question: "Select:", options: [
                        TriageOption(id: "g1508", label: "Applying improvised magnetic needle directional finding", icon: "scissors", destination: .technique("nav-encyclopedia-improv-improvised-dense")),
                        TriageOption(id: "g1509", label: "Applying improvised magnetic needle directional finding", icon: "scissors", destination: .technique("nav-encyclopedia-improv-improvised-open")),
                        TriageOption(id: "g1510", label: "Applying shadow-tip directional finding inside a Featur", icon: "list.bullet.clipboard.fill", destination: .technique("nav-encyclopedia-improv-shadowtip-featureless")),
                        TriageOption(id: "g1511", label: "Applying shadow-tip directional finding inside a Open e", icon: "list.bullet.clipboard.fill", destination: .technique("nav-encyclopedia-improv-shadowtip-open")),
                        TriageOption(id: "g1512", label: "Finding True South in the Southern Hemisphere at night.", icon: "cross.case.fill", destination: .technique("nav-southern-cross-method"))
                    ])
                )),
                TriageOption(id: "g1513", label: "Featureless", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g1513-q", question: "Select:", options: [
                        TriageOption(id: "g1514", label: "Applying improvised magnetic needle directional finding", icon: "scissors", destination: .technique("nav-encyclopedia-improv-improvised-featureless")),
                        TriageOption(id: "g1515", label: "Applying moss/vegetation bias directional finding insid", icon: "list.bullet.clipboard.fill", destination: .technique("nav-encyclopedia-improv-moss/vegetation-dense")),
                        TriageOption(id: "g1516", label: "Applying prevailing wind striations directional finding", icon: "list.bullet.clipboard.fill", destination: .technique("nav-encyclopedia-improv-prevailing-featureless")),
                        TriageOption(id: "g1517", label: "Applying prevailing wind striations directional finding", icon: "list.bullet.clipboard.fill", destination: .technique("nav-encyclopedia-improv-prevailing-open"))
                    ])
                ))
                ])
            )),

            TriageOption(id: "g1518", label: "Emergency Nav", icon: "cross.case.fill", destination: .nextQuestion(
                TriageNode(id: "g1518-q", question: "What specifically?", options: [
                TriageOption(id: "g1519", label: "Rivers", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g1519-q", question: "Select:", options: [
                        TriageOption(id: "g1520", label: "Navigate using waterways to find civilization", icon: "cross.case.fill", destination: .technique("nav-creek-following")),
                        TriageOption(id: "g1521", label: "Rivers tell you about terrain, direction, and human act", icon: "cloud.rain.fill", destination: .technique("nav-river-reading"))
                    ])
                )),
                TriageOption(id: "g1522", label: "Light", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g1522-q", question: "Select:", options: [
                        TriageOption(id: "g1523", label: "Use light pollution to find towns and roads", icon: "cross.case.fill", destination: .technique("nav-night-horizon-glow")),
                        TriageOption(id: "g1524", label: "Travel safely in darkness when necessary", icon: "eye.fill", destination: .technique("nav-night-navigation"))
                    ])
                )),
                TriageOption(id: "g1525", label: "Current", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g1525-q", question: "Select:", options: [
                        TriageOption(id: "g1526", label: "Cross flowing water safely", icon: "cross.case.fill", destination: .technique("nav-river-crossing-technique")),
                        TriageOption(id: "g1527", label: "Assess a river before committing to a crossing", icon: "list.bullet.clipboard.fill", destination: .technique("nav-current-river-reading"))
                    ])
                )),
                TriageOption(id: "g1528", label: "Open", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g1528-q", question: "Select:", options: [
                        TriageOption(id: "g1529", label: "Navigate open water without compass or GPS", icon: "pawprint.fill", destination: .technique("nav-maritime-direction")),
                        TriageOption(id: "g1530", label: "Navigate by analyzing the direction of open ocean swell", icon: "drop.fill", destination: .technique("nav-ocean-swel-reading"))
                    ])
                )),
                TriageOption(id: "g1531", label: "Without", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g1531-q", question: "Select:", options: [
                        TriageOption(id: "g1532", label: "Create an improvised compass without a magnet", icon: "scissors", destination: .technique("nav-improvising-compass-needle")),
                        TriageOption(id: "g1533", label: "Navigate a destroyed or unfamiliar city", icon: "location.north.fill", destination: .technique("nav-urban-navigation"))
                    ])
                ))
                ])
            )),

            TriageOption(id: "g1534", label: "Natural Signs", icon: "cross.case.fill", destination: .nextQuestion(
                TriageNode(id: "g1534-q", question: "What specifically?", options: [
                TriageOption(id: "g1535", label: "Determine", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g1535-q", question: "Select:", options: [
                        TriageOption(id: "g1536", label: "Use snowdrift patterns to determine wind and direction", icon: "location.north.fill", destination: .technique("nav-snow-drift-orientation")),
                        TriageOption(id: "g1537", label: "Read a cut stump to determine direction", icon: "cross.case.fill", destination: .technique("nav-tree-growth-rings")),
                        TriageOption(id: "g1538", label: "Determine cardinal directions using wind patterns", icon: "cloud.fill", destination: .technique("nav-wind-direction-feel"))
                    ])
                )),
                TriageOption(id: "g1539", label: "Indicate", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g1539-q", question: "Select:", options: [
                        TriageOption(id: "g1540", label: "Use animal paths to find water, shelter, and routes", icon: "house.fill", destination: .technique("nav-animal-trail-following")),
                        TriageOption(id: "g1541", label: "Read clouds for weather and terrain information", icon: "flame.fill", destination: .technique("nav-cloud-type-identification")),
                        TriageOption(id: "g1542", label: "Trees and plants indicate cardinal directions", icon: "leaf.fill", destination: .technique("nav-vegetation-direction"))
                    ])
                )),
                TriageOption(id: "g1543", label: "Water", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g1543-q", question: "Select:", options: [
                        TriageOption(id: "g1544", label: "Use bird behavior for direction and location clues", icon: "cross.case.fill", destination: .technique("nav-bird-flight-patterns")),
                        TriageOption(id: "g1545", label: "Use insect patterns to find water and direction", icon: "ant.fill", destination: .technique("nav-insect-behavior"))
                    ])
                )),
                TriageOption(id: "g1546", label: "Direction", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g1546-q", question: "Select:", options: [
                        TriageOption(id: "g1547", label: "Use lichen patterns on rocks for rough direction", icon: "cross.case.fill", destination: .technique("nav-lichen-growth")),
                        TriageOption(id: "g1548", label: "Determining prevailing wind direction in alpine terrain", icon: "cloud.rain.fill", destination: .technique("nav-cornice-reading"))
                    ])
                )),
                TriageOption(id: "g1549", label: "Pressure", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g1549-q", question: "Select:", options: [
                        TriageOption(id: "g1550", label: "Sense weather changes without instruments", icon: "cloud.fill", destination: .technique("nav-pressure-detection")),
                        TriageOption(id: "g1551", label: "Trace shadow movement for accurate east-west line", icon: "cross.case.fill", destination: .technique("nav-shadow-board"))
                    ])
                ))
                ])
            )),

            TriageOption(id: "g1552", label: "Signaling", icon: "antenna.radiowaves.left.and.right", destination: .nextQuestion(
                TriageNode(id: "g1552-q", question: "Which best matches?", options: [
                    TriageOption(id: "g1553", label: "International Ground-to-Air Signal Code.", icon: "antenna.radiowaves.left.and.right", destination: .technique("nav-signal-ground-arrow")),
                    TriageOption(id: "g1554", label: "Navigate by matching ground features to mental map", icon: "cloud.rain.fill", destination: .technique("nav-terrain-assoc-nav")),
                    TriageOption(id: "g1555", label: "International Ground-to-Air Signal Code.", icon: "antenna.radiowaves.left.and.right", destination: .technique("nav-signal-ground-v")),
                    TriageOption(id: "g1556", label: "International Ground-to-Air Signal Code.", icon: "antenna.radiowaves.left.and.right", destination: .technique("nav-signal-ground-x"))
                ])
            )),

            TriageOption(id: "g1557", label: "Stars & Sun", icon: "star.fill", destination: .nextQuestion(
                TriageNode(id: "g1557-q", question: "What specifically?", options: [
                TriageOption(id: "g1558", label: "Constellation", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g1558-q", question: "Select:", options: [
                        TriageOption(id: "g1559", label: "Use the W-shaped constellation to find the North Star", icon: "star.fill", destination: .technique("nav-stars-cassiopeia")),
                        TriageOption(id: "g1560", label: "Use the constellation Orion to find East and West", icon: "star.fill", destination: .technique("nav-stars-orion")),
                        TriageOption(id: "g1561", label: "Find south using the Southern Cross constellation", icon: "star.fill", destination: .technique("nav-star-navigation-south"))
                    ])
                )),
                TriageOption(id: "g1562", label: "East", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g1562-q", question: "Select:", options: [
                        TriageOption(id: "g1563", label: "Determine east-west line using a stick and two rocks", icon: "cross.case.fill", destination: .technique("nav-shadow-stick")),
                        TriageOption(id: "g1564", label: "Find East and West using only a stick and the sun", icon: "cross.case.fill", destination: .technique("nav-shadow-tip-method"))
                    ])
                )),
                TriageOption(id: "g1565", label: "Southern", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g1565-q", question: "Select:", options: [
                        TriageOption(id: "g1566", label: "Night navigation in the Southern Hemisphere", icon: "cross.case.fill", destination: .technique("nav-stars-southern-cross")),
                        TriageOption(id: "g1567", label: "Precise South finding using the Southern Cross and Poin", icon: "star.fill", destination: .technique("nav-stars-southern-cross-adv"))
                    ])
                )),
                TriageOption(id: "g1568", label: "Position", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g1568-q", question: "Select:", options: [
                        TriageOption(id: "g1569", label: "Determine rough directions using the shape and position", icon: "cross.case.fill", destination: .technique("nav-moon-phase-direction")),
                        TriageOption(id: "g1570", label: "Estimate time without a watch using sun position", icon: "cross.case.fill", destination: .technique("nav-sun-position-time")),
                        TriageOption(id: "g1571", label: "Determine cardinal directions from lunar position", icon: "car.fill", destination: .technique("nav-moon-direction"))
                    ])
                )),
                TriageOption(id: "g1572", label: "North", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g1572-q", question: "Select:", options: [
                        TriageOption(id: "g1573", label: "Finding North/South without the Dipper", icon: "star.fill", destination: .technique("nav-stars-advanced")),
                        TriageOption(id: "g1574", label: "Use an analog watch to find north/south", icon: "location.north.fill", destination: .technique("nav-watch-compass-method")),
                        TriageOption(id: "g1575", label: "The most reliable night navigation technique in the Nor", icon: "cross.case.fill", destination: .technique("nav-stars-polaris-dipper"))
                    ])
                )),
                TriageOption(id: "g1576", label: "Moon", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g1576-q", question: "Select:", options: [
                        TriageOption(id: "g1577", label: "Estimate South using a crescent moon", icon: "cross.case.fill", destination: .technique("nav-moon-horn-method"))
                    ])
                ))
                ])
            )),

            TriageOption(id: "g1578", label: "Terrain", icon: "cloud.rain.fill", destination: .nextQuestion(
                TriageNode(id: "g1578-q", question: "Which best matches?", options: [
                    TriageOption(id: "g1579", label: "Breaking free from liquefied sand or mud", icon: "cross.case.fill", destination: .technique("env-quicksand-escape")),
                    TriageOption(id: "g1580", label: "Safely fording a fast-moving stream on foot", icon: "cross.case.fill", destination: .technique("env-river-crossing"))
                ])
            )),

            TriageOption(id: "g1581", label: "Weather Reading", icon: "cloud.fill", destination: .nextQuestion(
                TriageNode(id: "g1581-q", question: "What specifically?", options: [
                TriageOption(id: "g1582", label: "Barometric", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g1582-q", question: "Select:", options: [
                        TriageOption(id: "g1583", label: "Predicting weather from pressure changes without instru", icon: "cloud.fill", destination: .technique("nav-weather-barometric")),
                        TriageOption(id: "g1584", label: "Your body and nature indicate pressure changes", icon: "flame.fill", destination: .technique("nav-barometric-pressure-body"))
                    ])
                )),
                TriageOption(id: "g1585", label: "Front", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g1585-q", question: "Select:", options: [
                        TriageOption(id: "g1586", label: "Read cloud types to predict weather 6-24 hours ahead", icon: "cloud.fill", destination: .technique("nav-cloud-identification")),
                        TriageOption(id: "g1587", label: "Using cloud shapes to forecast weather 6-24 hours ahead", icon: "cloud.fill", destination: .technique("nav-weather-cloud-reading"))
                    ])
                )),
                TriageOption(id: "g1588", label: "Direction", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g1588-q", question: "Select:", options: [
                        TriageOption(id: "g1589", label: "Wind patterns are consistent — use them as a compass", icon: "location.north.fill", destination: .technique("nav-prevailing-wind")),
                        TriageOption(id: "g1590", label: "Predict weather movement and plan travel accordingly", icon: "list.bullet.clipboard.fill", destination: .technique("nav-wind-direction-prediction")),
                        TriageOption(id: "g1591", label: "Reading wind direction changes to predict incoming weat", icon: "cloud.fill", destination: .technique("nav-weather-wind-fronts"))
                    ])
                )),
                TriageOption(id: "g1592", label: "Sailor", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g1592-q", question: "Select:", options: [
                        TriageOption(id: "g1593", label: "Anticipating freezing conditions to protect water and g", icon: "cloud.rain.fill", destination: .technique("nav-weather-frost")),
                        TriageOption(id: "g1594", label: "Ancient folk methods that actually work for short-term ", icon: "ant.fill", destination: .technique("nav-weather-red-sky"))
                    ])
                ))
                ])
            )),
        ])
    }

}
