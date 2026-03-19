import Foundation

extension ContentDatabase {
    // =========================================================================
    // =========================================================================
    func buildLostTriage() -> TriageNode {
        TriageNode(id: "lost-root", question: "What do you need?", options: [

            // ── JUST REALIZED I'M LOST ──
            TriageOption(id: "lost-just", label: "Just Realized I'm Lost", icon: "exclamationmark.circle", destination: .nextQuestion(
                TriageNode(id: "lost-stop", question: "STOP. What can you use to navigate?", options: [
                    TriageOption(id: "lost-backtrack", label: "I Remember the Way Back", icon: "arrow.uturn.left", destination: .technique("nav-lost-procedure")),
                    TriageOption(id: "lost-phone", label: "Phone (Any Battery)", icon: "iphone", destination: .techniqueList(["nav-gps-phone", "rescue-plb"])),
                    TriageOption(id: "lost-map-compass", label: "Map + Compass", icon: "map.fill", destination: .techniqueList(["nav-map-reading", "nav-triangulation"])),
                    TriageOption(id: "lost-compass", label: "Compass Only", icon: "safari.fill", destination: .techniqueList(["nav-compass-use", "nav-emergency-bearing"])),
                    TriageOption(id: "lost-watch", label: "Analog Watch + Sun", icon: "clock.fill", destination: .technique("nav-watch-compass")),
                    TriageOption(id: "lost-nothing", label: "Nothing — No Tools", icon: "xmark.circle.fill", destination: .nextQuestion(
                        TriageNode(id: "lost-notools", question: "What can you see?", options: [
                            TriageOption(id: "lost-sun-vis", label: "Sun Visible", icon: "sun.max.fill", destination: .techniqueList(["nav-stick-shadow", "nav-sun-position"])),
                            TriageOption(id: "lost-stars-vis", label: "Stars / Moon Visible", icon: "star.fill", destination: .techniqueList(["nav-north-star", "nav-southern-cross", "nav-moon-navigation"])),
                            TriageOption(id: "lost-overcast", label: "Overcast / Can't See Sky", icon: "cloud.fill", destination: .techniqueList(["nav-natural-indicators", "nav-vegetation-indicators", "nav-wind-reading"]))
                        ])
                    ))
                ])
            )),

            // ── BEEN LOST — NEED STRATEGY ──
            TriageOption(id: "lost-long", label: "Been Lost — Need Strategy", icon: "clock.fill", destination: .nextQuestion(
                TriageNode(id: "lost-strategy", question: "What's your plan?", options: [
                    TriageOption(id: "lost-stay", label: "Stay Put & Signal", icon: "hand.raised.fill", destination: .nextQuestion(
                        TriageNode(id: "lost-signal-q", question: "What signaling tools?", options: [
                            TriageOption(id: "lost-sig-whistle", label: "Whistle / Voice", icon: "speaker.wave.3.fill", destination: .techniqueList(["rescue-whistle", "rescue-whistle-patterns"])),
                            TriageOption(id: "lost-sig-smoke", label: "Signal Smoke", icon: "smoke.fill", destination: .technique("rescue-smoke-signal")),
                            TriageOption(id: "lost-sig-ground", label: "Ground Signals", icon: "square.fill", destination: .techniqueList(["rescue-ground-signal", "rescue-flag-signals"])),
                            TriageOption(id: "lost-sig-panel", label: "ICAO Panel Codes", icon: "textformat", destination: .technique("rescue-panel-signals"))
                        ])
                    )),
                    TriageOption(id: "lost-walk", label: "Self-Rescue / Walk Out", icon: "figure.walk", destination: .nextQuestion(
                        TriageNode(id: "lost-walk-q", question: "What can you see or hear?", options: [
                            TriageOption(id: "lost-hear-water", label: "Can Hear Water", icon: "water.waves", destination: .technique("nav-river-following")),
                            TriageOption(id: "lost-see-ridge", label: "Ridge / High Ground", icon: "mountain.2.fill", destination: .techniqueList(["nav-terrain-association", "nav-handrail-features"])),
                            TriageOption(id: "lost-road", label: "Trail / Road", icon: "road.lanes", destination: .technique("nav-dead-reckoning")),
                            TriageOption(id: "lost-wind", label: "Wind / Tree Lean", icon: "wind", destination: .technique("nav-wind-patterns")),
                            TriageOption(id: "lost-dense", label: "Dense Forest / Nothing", icon: "tree.fill", destination: .techniqueList(["rescue-trail-markers", "nav-vegetation-indicators", "nav-dead-reckoning"]))
                        ])
                    ))
                ])
            )),

            // ── NAVIGATE BY ENVIRONMENT ──
            TriageOption(id: "lost-env-nav", label: "Navigate by Environment", icon: "map.fill", destination: .nextQuestion(
                TriageNode(id: "lost-env-q", question: "What terrain?", options: [
                    TriageOption(id: "lost-nav-coastal", label: "Coastal / Shoreline", icon: "water.waves", destination: .technique("nav-coastal")),
                    TriageOption(id: "lost-nav-urban", label: "Urban / City", icon: "building.2.fill", destination: .technique("nav-urban")),
                    TriageOption(id: "lost-nav-weather", label: "Read Weather", icon: "cloud.sun.fill", destination: .technique("nav-weather-prediction")),
                    TriageOption(id: "lost-nav-altitude", label: "Estimate Altitude", icon: "mountain.2.fill", destination: .technique("nav-altitude-estimation"))
                ])
            )),

            // ── COMPASS & BEARING SKILLS ──
            TriageOption(id: "lost-adv-compass", label: "Compass & Bearing Skills", icon: "safari.fill", destination: .nextQuestion(
                TriageNode(id: "lost-adv-q", question: "What technique?", options: [
                    TriageOption(id: "lost-back-bearing", label: "Back Bearing", icon: "arrow.uturn.left", destination: .technique("nav-back-bearing")),
                    TriageOption(id: "lost-deliberate", label: "Deliberate Offset", icon: "arrow.right.and.line.vertical.and.arrow.left", destination: .technique("nav-deliberate-offset")),
                    TriageOption(id: "lost-magnetic", label: "Magnetic Deviation", icon: "minus.plus.batteryblock.fill", destination: .technique("nav-magnetic-deviation")),
                    TriageOption(id: "lost-pace", label: "Pace Beading", icon: "figure.walk", destination: .technique("nav-pace-beading")),
                    TriageOption(id: "lost-shadow-tip", label: "Shadow Tip Compass", icon: "sun.min.fill", destination: .technique("nav-shadow-tip-compass")),
                    TriageOption(id: "lost-sun-noon", label: "Sun at Noon", icon: "sun.max.fill", destination: .technique("nav-sun-noon"))
                ])
            )),

            // View Related Articles
            TriageOption(id: "lost-learn", label: "Learn More", icon: "book.fill", destination: .nextQuestion(
                TriageNode(id: "lost-learn-q", question: "What topic?", options: [
                    TriageOption(id: "lost-learn-basics", label: "Navigation Basics", icon: "map.fill", destination: .nextQuestion(
                        TriageNode(id: "lost-learn-basics-q", question: "Select article:", options: [
                            TriageOption(id: "lost-art-unlost", label: "Getting Un-Lost", icon: "location.fill", destination: .article("nav-article-getting-unlost")),
                            TriageOption(id: "lost-art-lost", label: "Psychology of Being Lost", icon: "brain.head.profile", destination: .article("nav-article-lost")),
                            TriageOption(id: "lost-art-map", label: "Map Reading Basics", icon: "map.fill", destination: .article("nav-article-map-basics")),
                            TriageOption(id: "lost-art-gps", label: "GPS Navigation", icon: "antenna.radiowaves.left.and.right", destination: .articleList(["nav-article-gps", "nav-article-gps-limitations"]))
                        ])
                    )),
                    TriageOption(id: "lost-learn-celestial", label: "Celestial & Natural", icon: "star.fill", destination: .nextQuestion(
                        TriageNode(id: "lost-learn-cel-q", question: "Select article:", options: [
                            TriageOption(id: "lost-art-celestial", label: "Celestial Navigation", icon: "star.fill", destination: .article("nav-article-celestial")),
                            TriageOption(id: "lost-art-magnetic", label: "Magnetic Declination", icon: "safari", destination: .articleList(["nav-article-magnetic", "nav-article-declination"])),
                            TriageOption(id: "lost-art-night", label: "Night Navigation", icon: "moon.stars.fill", destination: .articleList(["nav-article-night", "nav-article-night-nav"])),
                            TriageOption(id: "lost-art-emergency", label: "Emergency Navigation", icon: "exclamationmark.triangle.fill", destination: .article("nav-article-emergency"))
                        ])
                    )),
                    TriageOption(id: "lost-learn-terrain", label: "Terrain & Urban", icon: "mountain.2.fill", destination: .nextQuestion(
                        TriageNode(id: "lost-learn-ter-q", question: "Select article:", options: [
                            TriageOption(id: "lost-art-terrain", label: "Terrain Association", icon: "mountain.2.fill", destination: .article("nav-article-terrain")),
                            TriageOption(id: "lost-art-dense", label: "Dense Forest Navigation", icon: "tree.fill", destination: .article("nav-article-dense-forest")),
                            TriageOption(id: "lost-art-urban", label: "Urban Navigation", icon: "building.2.fill", destination: .article("nav-article-urban-nav"))
                        ])
                    ))
                ])
            ))

        ])
    }

}
