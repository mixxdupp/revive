import Foundation

// Helper for JSON Decoding
struct DomainContent: Codable {
    let domain: String
    let domainDisplayName: String
    let techniques: [Technique]
    let articles: [Article]
}

class ContentDatabase: ObservableObject {
    static let shared = ContentDatabase()
    
    @Published var techniques: [Technique] = []
    @Published var articles: [Article] = []
    @Published var triageTrees: [EmergencySituation: TriageNode] = [:]
    
    func search(query: String) -> [Technique] {
        guard !query.isEmpty else { return [] }
        let lowerQuery = query.lowercased()
        
        return techniques.filter { technique in
            technique.name.lowercased().contains(lowerQuery) ||
            technique.subtitle.lowercased().contains(lowerQuery) ||
            technique.steps.contains { step in
                step.instruction.lowercased().contains(lowerQuery) ||
                step.helpDetail.lowercased().contains(lowerQuery)
            }
        }.sorted { t1, t2 in
            // Prioritize title matches
            let t1NameMatch = t1.name.lowercased().contains(lowerQuery)
            let t2NameMatch = t2.name.lowercased().contains(lowerQuery)
            
            if t1NameMatch && !t2NameMatch { return true }
            if !t1NameMatch && t2NameMatch { return false }
            return t1.name < t2.name
        }
    }

    // MARK: - Related Techniques
    
    func getRelatedTechniques(for technique: Technique, limit: Int = 3) -> [Technique] {
        var results: [Technique] = []
        
        // 1. Explicit Related IDs
        if let relatedIds = technique.relatedIds {
            let matches = techniques.filter { relatedIds.contains($0.id) }
            results.append(contentsOf: matches)
        }
        
        // If we have enough, return
        if results.count >= limit {
            return Array(results.prefix(limit))
        }
        
        // 2. Same Category
        let sameCategory = techniques.filter { candidate in
            candidate.category == technique.category && candidate.id != technique.id && !results.contains(where: { match in match.id == candidate.id })
        }
        results.append(contentsOf: sameCategory.shuffled())
        
        if results.count >= limit {
             return Array(results.prefix(limit))
        }
        
        // 3. Same Domain
        let sameDomain = techniques.filter { candidate in
            candidate.domain == technique.domain && candidate.id != technique.id && !results.contains(where: { match in match.id == candidate.id })
        }
        results.append(contentsOf: sameDomain.shuffled())
        
        return Array(results.prefix(limit))
    }

    private init() {
        let domains = [
            "fire", "shelter", "water", "navigation",
            "firstaid", "food", "rescue", "psychology",
            "environments", "tools"
        ]
        for domain in domains {
            loadDomainFromJSON(fileName: domain)
        }
        buildTriageTrees()
    }
    
    private func loadDomainFromJSON(fileName: String) {
        guard let url = Bundle.main.url(forResource: fileName, withExtension: "json") else {
            NSLog("REVIVE: Failed to locate %@.json in bundle.", fileName)
            return
        }
        
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let domainContent = try decoder.decode(DomainContent.self, from: data)
            
            guard let survivalDomain = SurvivalDomain(rawValue: domainContent.domain) else {
                NSLog("REVIVE: Unknown domain: %@", domainContent.domain)
                return
            }
            
            var techniques = domainContent.techniques
            for i in techniques.indices {
                techniques[i].domain = survivalDomain
            }
            
            var articles = domainContent.articles
            for i in articles.indices {
                articles[i].domain = survivalDomain
            }
            
            self.techniques.append(contentsOf: techniques)
            self.articles.append(contentsOf: articles)
            NSLog("REVIVE: Loaded %@: %d techniques, %d articles.", domainContent.domainDisplayName, techniques.count, articles.count)
        } catch {
            NSLog("REVIVE: Failed to decode %@.json: %@", fileName, error.localizedDescription)
        }
    }
    
    func getTechniques(for domain: SurvivalDomain) -> [Technique] {
        techniques.filter { $0.domain == domain }
    }
    
    func getArticles(for domain: SurvivalDomain) -> [Article] {
        articles.filter { $0.domain == domain }
    }

    // MARK: - Deep Triage Trees
    private func buildTriageTrees() {
        triageTrees[.cold] = buildColdTriage()
        triageTrees[.noFire] = buildFireTriage()
        triageTrees[.noWater] = buildWaterTriage()
        triageTrees[.lost] = buildLostTriage()
        triageTrees[.trapped] = buildTrappedTriage()
        triageTrees[.disaster] = buildDisasterTriage()
        triageTrees[.noFood] = buildFoodTriage()
        triageTrees[.animal] = buildAnimalTriage()
        triageTrees[.inWater] = buildInWaterTriage()
        triageTrees[.shelter] = buildShelterTriage()
    }

    // =========================================================================
    // MARK: - COLD / HYPOTHERMIA (5 levels deep)
    // =========================================================================
    private func buildColdTriage() -> TriageNode {
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
                                    TriageOption(id: "cold-tarp-dry", label: "Dry but Cold", icon: "wind", destination: .technique("shelter-tarp-diamond")),
                                    TriageOption(id: "cold-tarp-wind", label: "Very Windy", icon: "wind", destination: .technique("shelter-tarp-cfly"))
                                ])
                            )),
                            TriageOption(id: "cold-rope-only", label: "Rope / Cordage Only", icon: "line.diagonal", destination: .technique("shelter-lean-to")),
                            TriageOption(id: "cold-nothing", label: "Nothing at All", icon: "xmark.circle.fill", destination: .nextQuestion(
                                TriageNode(id: "cold-debris-q", question: "Is there debris on the ground?", options: [
                                    TriageOption(id: "cold-debris-yes", label: "Lots of Leaves & Branches", icon: "leaf.fill", destination: .technique("shelter-debris-aframe")),
                                    TriageOption(id: "cold-debris-round", label: "Some — Can Pile Up", icon: "circle.fill", destination: .technique("shelter-debris-round")),
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
                                    TriageOption(id: "cold-snow-hands", label: "Bare Hands Only", icon: "hand.raised.fill", destination: .technique("shelter-snow-trench"))
                                ])
                            )),
                            TriageOption(id: "cold-snow-shallow", label: "Shallow / Hard Pack", icon: "rectangle.fill", destination: .technique("shelter-snow-trench")),
                            TriageOption(id: "cold-snow-blocks", label: "Can Cut Firm Blocks", icon: "square.stack.3d.up.fill", destination: .technique("shelter-igloo"))
                        ])
                    )),

                    // Desert / Open
                    TriageOption(id: "cold-desert", label: "Desert / Open Ground", icon: "sun.max.fill", destination: .nextQuestion(
                        TriageNode(id: "cold-desert-mat", question: "Any materials available?", options: [
                            TriageOption(id: "cold-desert-vehicle", label: "Near a Vehicle", icon: "car.fill", destination: .technique("shelter-vehicle")),
                            TriageOption(id: "cold-desert-tarp", label: "Have Tarp / Sheet", icon: "square.fill", destination: .technique("shelter-tarp-diamond")),
                            TriageOption(id: "cold-desert-nothing", label: "Nothing — Open Exposure", icon: "xmark.circle.fill", destination: .technique("shelter-emergency-bivy"))
                        ])
                    )),

                    // Urban
                    TriageOption(id: "cold-urban", label: "Urban / Suburban", icon: "building.2.fill", destination: .nextQuestion(
                        TriageNode(id: "cold-urban-q", question: "Can you get indoors?", options: [
                            TriageOption(id: "cold-urban-building", label: "Building Available", icon: "door.left.hand.open", destination: .technique("env-urban-disaster")),
                            TriageOption(id: "cold-urban-car", label: "Vehicle Available", icon: "car.fill", destination: .technique("shelter-vehicle")),
                            TriageOption(id: "cold-urban-none", label: "Outdoors Only", icon: "xmark.circle.fill", destination: .nextQuestion(
                                TriageNode(id: "cold-urban-mat", question: "What's available?", options: [
                                    TriageOption(id: "cold-urban-card", label: "Cardboard / Newspaper", icon: "doc.fill", destination: .technique("shelter-emergency-bivy")),
                                    TriageOption(id: "cold-urban-plastic", label: "Plastic Bags / Tarp", icon: "bag.fill", destination: .technique("shelter-mylar-wrap")),
                                    TriageOption(id: "cold-urban-zero", label: "Absolutely Nothing", icon: "xmark.circle.fill", destination: .technique("shelter-emergency-bivy"))
                                ])
                            ))
                        ])
                    )),

                    // Mountain
                    TriageOption(id: "cold-mountain", label: "Mountain / Exposed Ridge", icon: "mountain.2.fill", destination: .nextQuestion(
                        TriageNode(id: "cold-mtn-q", question: "Can you descend to tree line?", options: [
                            TriageOption(id: "cold-mtn-desc", label: "Yes — Can Get to Trees", icon: "arrow.down", destination: .technique("shelter-lean-to")),
                            TriageOption(id: "cold-mtn-stuck", label: "No — Stuck on Ridge", icon: "xmark.circle.fill", destination: .nextQuestion(
                                TriageNode(id: "cold-mtn-wind", question: "Is there a windbreak?", options: [
                                    TriageOption(id: "cold-mtn-rock", label: "Rock Outcrop / Boulder", icon: "triangle.fill", destination: .technique("env-cave-survival")),
                                    TriageOption(id: "cold-mtn-none", label: "Fully Exposed", icon: "wind", destination: .technique("shelter-emergency-bivy"))
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
                    TriageOption(id: "cold-need-fire", label: "Need to Start Fire", icon: "flame.fill", destination: .nextQuestion(
                        TriageNode(id: "cold-fire-tools", question: "What fire tools do you have?", options: [
                            TriageOption(id: "cold-lighter", label: "Lighter or Matches", icon: "flame.fill", destination: .nextQuestion(
                                TriageNode(id: "cold-fire-goal", question: "What type of fire do you need?", options: [
                                    TriageOption(id: "cold-quick", label: "Quick Heat Now", icon: "flame.fill", destination: .technique("fire-teepee")),
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
                                            TriageOption(id: "cold-shiver-stop", label: "Shivering STOPPED (Danger)", icon: "exclamationmark.triangle.fill", destination: .technique("firstaid-hypothermia"))
                                        ])
                                    )),
                                    TriageOption(id: "cold-severe", label: "Confused, Poor Coordination", icon: "exclamationmark.triangle.fill", destination: .technique("firstaid-hypothermia")),
                                    TriageOption(id: "cold-frostbite", label: "Numbness, White/Gray Skin", icon: "hand.raised.fill", destination: .technique("env-arctic-frostbite"))
                                ])
                            )),
                            TriageOption(id: "cold-hypo-other", label: "Someone Else", icon: "person.2.fill", destination: .nextQuestion(
                                TriageNode(id: "cold-hypo-other-q", question: "Are they conscious?", options: [
                                    TriageOption(id: "cold-other-conscious", label: "Yes — Conscious", icon: "checkmark.circle", destination: .technique("firstaid-hypothermia")),
                                    TriageOption(id: "cold-other-uncon", label: "No — Unconscious", icon: "exclamationmark.triangle.fill", destination: .techniqueList(["firstaid-hypothermia", "firstaid-recovery-position"]))
                                ])
                            ))
                        ])
                    )),

                    // Better insulation
                    TriageOption(id: "cold-insulation", label: "Need Better Insulation", icon: "bed.double.fill", destination: .nextQuestion(
                        TriageNode(id: "cold-insul-q", question: "What's available for insulation?", options: [
                            TriageOption(id: "cold-insul-debris", label: "Leaves / Pine Needles", icon: "leaf.fill", destination: .technique("shelter-debris-aframe")),
                            TriageOption(id: "cold-insul-mylar", label: "Space Blanket / Plastic", icon: "sparkle", destination: .technique("shelter-mylar-wrap")),
                            TriageOption(id: "cold-insul-hammock", label: "Off the Ground (Hammock)", icon: "figure.mind.and.body", destination: .technique("shelter-hammock"))
                        ])
                    )),

                    // Wet clothes
                    TriageOption(id: "cold-wet-clothes", label: "Wet Clothes / Drenched", icon: "drop.fill", destination: .nextQuestion(
                        TriageNode(id: "cold-wet-q", question: "Can you make fire?", options: [
                            TriageOption(id: "cold-wet-fire", label: "Yes — Can Dry Clothes", icon: "flame.fill", destination: .technique("fire-teepee")),
                            TriageOption(id: "cold-wet-nofire", label: "No — Must Insulate Wet", icon: "xmark.circle.fill", destination: .technique("shelter-mylar-wrap"))
                        ])
                    )),

                    // Psychological
                    TriageOption(id: "cold-morale", label: "Losing Hope / Morale", icon: "brain.head.profile", destination: .nextQuestion(
                        TriageNode(id: "cold-morale-q", question: "What do you need?", options: [
                            TriageOption(id: "cold-calm", label: "Calm Down / Breathe", icon: "wind", destination: .technique("psych-box-breathing")),
                            TriageOption(id: "cold-decide", label: "Can't Decide What To Do", icon: "questionmark.circle.fill", destination: .technique("psych-ooda-loop")),
                            TriageOption(id: "cold-alone", label: "Feeling Alone / Isolated", icon: "person.fill", destination: .technique("psych-loneliness"))
                        ])
                    ))
                ])
            ))
        ])
    }

    // =========================================================================
    // MARK: - NEED FIRE (5 levels deep)
    // =========================================================================
    private func buildFireTriage() -> TriageNode {
        TriageNode(id: "fire-root", question: "What fire-starting tools do you have?", options: [

            // Lighter / Matches
            TriageOption(id: "fire-lighter", label: "Lighter or Matches", icon: "flame.fill", destination: .nextQuestion(
                TriageNode(id: "fire-cond", question: "What are conditions like?", options: [
                    TriageOption(id: "fire-dry", label: "Dry Conditions", icon: "sun.max.fill", destination: .nextQuestion(
                        TriageNode(id: "fire-goal", question: "What's your goal?", options: [
                            TriageOption(id: "fire-quick", label: "Quick Heat", icon: "flame.fill", destination: .technique("fire-teepee")),
                            TriageOption(id: "fire-cooking", label: "Cooking Fire", icon: "frying.pan.fill", destination: .technique("fire-log-cabin")),
                            TriageOption(id: "fire-overnight", label: "All-Night Fire", icon: "moon.fill", destination: .technique("fire-long-fire")),
                            TriageOption(id: "fire-stealth", label: "Low Smoke / Tactical", icon: "eye.slash.fill", destination: .technique("fire-dakota-hole")),
                            TriageOption(id: "fire-signal", label: "Signal Fire", icon: "antenna.radiowaves.left.and.right", destination: .technique("rescue-signal-fire"))
                        ])
                    )),
                    TriageOption(id: "fire-wet", label: "Raining / Wet Wood", icon: "cloud.rain.fill", destination: .technique("fire-wet-conditions")),
                    TriageOption(id: "fire-wind", label: "Very Windy", icon: "wind", destination: .technique("fire-dakota-hole")),
                    TriageOption(id: "fire-snow-cond", label: "Snow on Ground", icon: "snowflake", destination: .technique("fire-wet-conditions"))
                ])
            )),

            // Ferro Rod
            TriageOption(id: "fire-ferro", label: "Ferro Rod / Firesteel", icon: "sparkle", destination: .nextQuestion(
                TriageNode(id: "fire-ferro-tinder", question: "Do you have good tinder?", options: [
                    TriageOption(id: "fire-ferro-good", label: "Birch Bark / Lint / Dry Grass", icon: "leaf.fill", destination: .nextQuestion(
                         TriageNode(id: "fire-tinder-type", question: "What kind?", options: [
                            TriageOption(id: "fire-tinder-natural", label: "Natural (Bark/Grass)", icon: "leaf.fill", destination: .technique("fire-ferrorod")),
                            TriageOption(id: "fire-tinder-man", label: "Man-Made (Lint/Paper)", icon: "doc.text.fill", destination: .technique("fire-ferrorod"))
                         ])
                    )),
                    TriageOption(id: "fire-ferro-none", label: "No Tinder Available", icon: "xmark.circle.fill", destination: .nextQuestion(
                        TriageNode(id: "fire-tinder-make", question: "Can you make tinder?", options: [
                            TriageOption(id: "fire-fatwood", label: "Pine / Resinous Trees Nearby", icon: "tree.fill", destination: .technique("fire-ferrorod")),
                            TriageOption(id: "fire-feather", label: "Have Knife + Dry Wood", icon: "knife.fill", destination: .technique("fire-feather-stick")),
                            TriageOption(id: "fire-charcloth", label: "Cotton + Existing Ember", icon: "tshirt.fill", destination: .technique("fire-charcloth")),
                            TriageOption(id: "fire-carry", label: "Already Have Ember to Transport", icon: "flame.fill", destination: .technique("fire-ember-carrier"))
                        ])
                    ))
                ])
            )),

            // Flint + Steel
            TriageOption(id: "fire-flint", label: "Knife + Flint / Quartz", icon: "bolt.fill", destination: .nextQuestion(
                TriageNode(id: "fire-flint-q", question: "Do you have charcloth or dry fungus?", options: [
                    TriageOption(id: "fire-flint-yes", label: "Yes — Have Char Material", icon: "checkmark.circle.fill", destination: .technique("fire-flint-steel")),
                    TriageOption(id: "fire-flint-no", label: "No — Need to Make It", icon: "xmark.circle.fill", destination: .technique("fire-charcloth"))
                ])
            )),

            // Battery
            TriageOption(id: "fire-battery", label: "Battery + Steel Wool / Gum Wrapper", icon: "battery.75percent", destination: .technique("fire-battery")),

            // Chemical
            TriageOption(id: "fire-chemical", label: "Potassium Permanganate + Glycerin", icon: "flask.fill", destination: .technique("fire-chemical")),

            // NOTHING — Primitive
            TriageOption(id: "fire-nothing", label: "Nothing — No Tools", icon: "xmark.circle.fill", destination: .nextQuestion(
                TriageNode(id: "fire-sun-q", question: "Is the sun visible?", options: [
                    TriageOption(id: "fire-sun-yes", label: "Yes — Sunny", icon: "sun.max.fill", destination: .nextQuestion(
                        TriageNode(id: "fire-solar", question: "Do you have anything to focus light?", options: [
                            TriageOption(id: "fire-lens", label: "Glasses / Magnifying Lens", icon: "magnifyingglass", destination: .technique("fire-magnifying")),
                            TriageOption(id: "fire-bottle", label: "Clear Water Bottle", icon: "waterbottle.fill", destination: .technique("fire-magnifying")),
                            TriageOption(id: "fire-ice-avail", label: "Clear Ice Available", icon: "snowflake", destination: .technique("fire-ice-lens")),
                            TriageOption(id: "fire-no-lens", label: "Nothing to Focus Light", icon: "xmark.circle.fill", destination: .technique("fire-bowdrill"))
                        ])
                    )),
                    TriageOption(id: "fire-sun-no", label: "No — Cloudy or Night", icon: "cloud.fill", destination: .nextQuestion(
                        TriageNode(id: "fire-friction", question: "What wood is available?", options: [
                            TriageOption(id: "fire-softwood", label: "Softwood (Cedar, Willow, Poplar)", icon: "tree.fill", destination: .technique("fire-bowdrill")),
                            TriageOption(id: "fire-bamboo-avail", label: "Bamboo Available", icon: "leaf.fill", destination: .technique("fire-firesaw")),
                            TriageOption(id: "fire-handdrill-avail", label: "Cattail / Mullein Stalks", icon: "wand.and.stars", destination: .technique("fire-handdrill")),
                            TriageOption(id: "fire-plow-avail", label: "Flat Board + Hard Stick", icon: "rectangle.fill", destination: .technique("fire-fire-plow"))
                        ])
                    ))
                ])
            ))
        ])
    }

    // =========================================================================
    // MARK: - NEED WATER (5 levels deep)
    // =========================================================================
    private func buildWaterTriage() -> TriageNode {
        TriageNode(id: "water-root", question: "What environment are you in?", options: [

            // Near water source
            TriageOption(id: "water-stream", label: "Near Stream / River / Lake", icon: "water.waves", destination: .nextQuestion(
                TriageNode(id: "water-flow-q", question: "Is the water moving?", options: [
                    TriageOption(id: "water-flow-yes", label: "Yes — Flowing Stream", icon: "water.waves", destination: .nextQuestion(
                        TriageNode(id: "water-clarity", question: "Is the water clear or murky?", options: [
                            TriageOption(id: "water-clear", label: "Clear / Running", icon: "drop.fill", destination: .nextQuestion(
                        TriageNode(id: "water-purify", question: "How can you purify it?", options: [
                            TriageOption(id: "water-boil", label: "Can Make Fire → Boil", icon: "flame.fill", destination: .technique("water-boiling")),
                            TriageOption(id: "water-tabs", label: "Have Purification Tablets / Iodine", icon: "pills.fill", destination: .technique("water-iodine")),
                            TriageOption(id: "water-uv", label: "Clear Bottle + Strong Sun", icon: "sun.max.fill", destination: .technique("water-uv-purification")),
                            TriageOption(id: "water-filter-material", label: "Sand / Gravel / Charcoal", icon: "line.3.horizontal.decrease.circle", destination: .technique("water-charcoal-filter")),
                            TriageOption(id: "water-cloth-only", label: "Cloth / Sock Only", icon: "tshirt.fill", destination: .technique("water-filter-sock")),
                            TriageOption(id: "water-nothing-purify", label: "Nothing — Must Drink As-Is", icon: "exclamationmark.triangle.fill", destination: .technique("water-boiling"))
                        ])
                    )),
                    TriageOption(id: "water-murky", label: "Murky / Standing / Stagnant", icon: "drop.triangle.fill", destination: .nextQuestion(
                        TriageNode(id: "water-filter-q", question: "Can you pre-filter sediment?", options: [
                            TriageOption(id: "water-pre-cloth", label: "Have Cloth / Fabric", icon: "tshirt.fill", destination: .nextQuestion(
                                TriageNode(id: "water-after-filter", question: "After filtering, can you purify?", options: [
                                    TriageOption(id: "water-filter-boil", label: "Yes — Can Boil", icon: "flame.fill", destination: .technique("water-boiling")),
                                    TriageOption(id: "water-filter-chem", label: "Have Iodine / Tablets", icon: "pills.fill", destination: .technique("water-iodine")),
                                    TriageOption(id: "water-filter-uv", label: "Sun + Clear Bottle", icon: "sun.max.fill", destination: .technique("water-uv-purification"))
                                ])
                            )),
                            TriageOption(id: "water-no-filter", label: "No Filter Material", icon: "xmark.circle.fill", destination: .technique("water-charcoal-filter"))
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
                            TriageOption(id: "water-trees", label: "Trees / Bushes with Leaves", icon: "tree.fill", destination: .technique("water-transpiration-bag")),
                            TriageOption(id: "water-cactus", label: "Barrel Cactus / Succulents", icon: "leaf.fill", destination: .technique("water-vegetation-indicators")),
                            TriageOption(id: "water-grass", label: "Grass (Early Morning)", icon: "sunrise.fill", destination: .technique("water-dew-collection"))
                        ])
                    )),
                    TriageOption(id: "water-dry-river", label: "Near Dry Riverbed", icon: "line.diagonal", destination: .technique("water-vegetation-indicators")),
                    TriageOption(id: "water-rock-face", label: "Rock Faces Nearby", icon: "triangle.fill", destination: .technique("water-rock-seepage")),
                    TriageOption(id: "water-barren", label: "Nothing — Barren", icon: "xmark.circle.fill", destination: .technique("water-solar-still")),
                    TriageOption(id: "water-condense", label: "Metal Surface Available", icon: "rectangle.fill", destination: .technique("water-condensation-trap"))
                ])
            )),

            // Snow / Ice
            TriageOption(id: "water-snow", label: "Snow / Ice Available", icon: "snowflake", destination: .nextQuestion(
                TriageNode(id: "water-snow-q", question: "Can you make fire?", options: [
                    TriageOption(id: "water-snow-fire", label: "Yes — Can Melt Snow", icon: "flame.fill", destination: .technique("water-snow-ice")),
                    TriageOption(id: "water-snow-nofire", label: "No Fire — Body Heat Only", icon: "person.fill", destination: .technique("water-snow-ice")),
                    TriageOption(id: "water-ice-clear", label: "Clear Ice (Not Sea Ice)", icon: "cube.fill", destination: .technique("water-snow-ice"))
                ])
            )),

            // At Sea / Coastal
            TriageOption(id: "water-ocean", label: "At Sea / Coastal", icon: "sailboat.fill", destination: .nextQuestion(
                TriageNode(id: "water-sea-q", question: "What's available?", options: [
                    TriageOption(id: "water-rain-exp", label: "Rain Expected", icon: "cloud.rain.fill", destination: .technique("water-rain-collection")),
                    TriageOption(id: "water-sea-plastic", label: "Container + Sun", icon: "sun.max.fill", destination: .technique("water-solar-still")),
                    TriageOption(id: "water-sea-seaweed", label: "Seawater Only", icon: "drop.fill", destination: .technique("water-seawater")),
                    TriageOption(id: "water-coastal-forage", label: "On Shore — Can Explore", icon: "figure.walk", destination: .techniqueList(["water-rain-collection", "water-rock-seepage", "water-dew-collection"]))
                ])
            )),

            // Jungle / Tropical
            TriageOption(id: "water-jungle", label: "Jungle / Tropical", icon: "leaf.fill", destination: .nextQuestion(
                TriageNode(id: "water-jungle-q", question: "What's around you?", options: [
                    TriageOption(id: "water-bamboo", label: "Bamboo", icon: "leaf.fill", destination: .technique("water-bamboo-collection")),
                    TriageOption(id: "water-vines", label: "Vines / Lianas", icon: "line.diagonal", destination: .technique("water-vegetation-indicators")),
                    TriageOption(id: "water-birch", label: "Birch / Maple Trees", icon: "tree.fill", destination: .technique("water-birch-tapping")),
                    TriageOption(id: "water-rain-jungle", label: "Rain Frequent", icon: "cloud.rain.fill", destination: .technique("water-rain-collection")),
                    TriageOption(id: "water-transpire", label: "Broad-Leaf Trees", icon: "tree.fill", destination: .technique("water-transpiration-bag"))
                ])
            )),

            // Urban
            TriageOption(id: "water-urban", label: "Urban Area", icon: "building.2.fill", destination: .nextQuestion(
                TriageNode(id: "water-urban-q", question: "What sources exist?", options: [
                    TriageOption(id: "water-urban-heater", label: "Water Heater / Toilet Tank", icon: "cylinder.fill", destination: .technique("water-rationing")),
                    TriageOption(id: "water-urban-rain", label: "Rain / Puddles", icon: "cloud.rain.fill", destination: .technique("water-boiling")),
                    TriageOption(id: "water-urban-store", label: "Need to Store / Ration", icon: "drop.fill", destination: .technique("water-storage"))
                ])
            ))
        ])
    }

    // =========================================================================
    // MARK: - LOST / NAVIGATION (6 levels deep)
    // =========================================================================
    private func buildLostTriage() -> TriageNode {
        TriageNode(id: "lost-root", question: "When did you realize you're lost?", options: [

            // Just now
            TriageOption(id: "lost-just", label: "Just Now", icon: "exclamationmark.circle", destination: .nextQuestion(
                TriageNode(id: "lost-stop", question: "STOP. Do not move. Can you backtrack?", options: [
                    TriageOption(id: "lost-backtrack", label: "Yes — Remember the Way", icon: "arrow.uturn.left", destination: .technique("nav-lost-procedure")),
                    TriageOption(id: "lost-unsure", label: "Not Sure / Disoriented", icon: "questionmark.circle.fill", destination: .nextQuestion(
                        TriageNode(id: "lost-tools", question: "What navigation tools do you have?", options: [
                            TriageOption(id: "lost-phone", label: "Phone (Any Battery)", icon: "iphone", destination: .technique("nav-gps-phone")),
                            TriageOption(id: "lost-compass", label: "Compass", icon: "safari.fill", destination: .technique("nav-compass-use")),
                            TriageOption(id: "lost-map-compass", label: "Map + Compass", icon: "map.fill", destination: .technique("nav-map-reading")),
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
                                            TriageOption(id: "lost-overcast", label: "Overcast / Can't See Sun", icon: "cloud.fill", destination: .technique("nav-natural-indicators"))
                                        ])
                                    )),

                                    // Nighttime
                                    TriageOption(id: "lost-night", label: "Nighttime", icon: "moon.fill", destination: .nextQuestion(
                                        TriageNode(id: "lost-stars", question: "Can you see stars or moon?", options: [
                                            TriageOption(id: "lost-stars-visible", label: "Yes — Clear Sky", icon: "star.fill", destination: .nextQuestion(
                                                TriageNode(id: "lost-star-method", question: "Which method?", options: [
                                                    TriageOption(id: "lost-stars-n", label: "North Star (N. Hemisphere)", icon: "star.fill", destination: .technique("nav-north-star")),
                                                    TriageOption(id: "lost-stars-s", label: "Southern Cross (S. Hemisphere)", icon: "star.fill", destination: .technique("nav-southern-cross")),
                                                    TriageOption(id: "lost-star-any", label: "Any Star (Movement)", icon: "sparkles", destination: .technique("nav-star-movement")),
                                                    TriageOption(id: "lost-moon", label: "Moon (Crescent)", icon: "moon.fill", destination: .technique("nav-moon-navigation"))
                                                ])
                                            )),
                                            TriageOption(id: "lost-no-sky", label: "No — Cloudy/Overcast", icon: "cloud.fill", destination: .nextQuestion(
                                                TriageNode(id: "lost-cloud-action", question: "What should you do?", options: [
                                                    TriageOption(id: "lost-wait-morn", label: "Stop & Wait for Morning", icon: "bed.double.fill", destination: .technique("shelter-emergency-bivy")),
                                                    TriageOption(id: "lost-move-cautious", label: "Must Move (Caution)", icon: "exclamationmark.triangle.fill", destination: .technique("nav-lost-procedure"))
                                                ])
                                            ))
                                        ])
                                    )),

                                    // Dawn/Dusk
                                    TriageOption(id: "lost-dawn", label: "Dawn or Dusk", icon: "sunrise.fill", destination: .technique("nav-sun-position"))
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
                            TriageOption(id: "lost-sig-mirror", label: "Mirror / Reflective", icon: "sparkle", destination: .technique("rescue-signal-mirror")),
                            TriageOption(id: "lost-sig-fire", label: "Can Make Fire", icon: "flame.fill", destination: .technique("rescue-signal-fire")),
                            TriageOption(id: "lost-sig-whistle", label: "Whistle / Loud Voice", icon: "speaker.wave.3.fill", destination: .technique("rescue-whistle")),
                            TriageOption(id: "lost-sig-smoke", label: "Colored Smoke (Daytime)", icon: "smoke.fill", destination: .technique("rescue-smoke-signal")),
                            TriageOption(id: "lost-sig-ground", label: "Open Ground for Symbols", icon: "square.fill", destination: .technique("rescue-ground-signal")),
                            TriageOption(id: "lost-sig-panel", label: "Know ICAO Panel Codes", icon: "textformat", destination: .technique("rescue-panel-signals")),
                            TriageOption(id: "lost-sig-morse", label: "Flashlight / Tapping", icon: "flashlight.on.fill", destination: .technique("rescue-morse-code")),
                            TriageOption(id: "lost-sig-phone", label: "Phone (Even Dead Service)", icon: "iphone", destination: .technique("rescue-phone-emergency"))
                        ])
                    )),
                    TriageOption(id: "lost-walk", label: "Self-Rescue / Walk Out", icon: "figure.walk", destination: .nextQuestion(
                        TriageNode(id: "lost-walk-q", question: "Can you see or hear any landmark?", options: [
                            TriageOption(id: "lost-hear-water", label: "Can Hear Water", icon: "water.waves", destination: .technique("nav-river-following")),
                            TriageOption(id: "lost-see-ridge", label: "Can See Ridge / High Ground", icon: "mountain.2.fill", destination: .technique("nav-terrain-association")),
                            TriageOption(id: "lost-road", label: "Found a Trail / Road", icon: "road.lanes", destination: .technique("nav-dead-reckoning")),
                            TriageOption(id: "lost-wind", label: "Open Area — Check Wind/Tree Lean", icon: "wind", destination: .technique("nav-wind-patterns")),
                            TriageOption(id: "lost-dense", label: "Dense Forest / No Features", icon: "tree.fill", destination: .nextQuestion(
                                TriageNode(id: "lost-dense-q", question: "What do you want to do?", options: [
                                    TriageOption(id: "lost-follow-water", label: "Find & Follow Water Downhill", icon: "water.waves", destination: .technique("nav-river-following")),
                                    TriageOption(id: "lost-deadreckon", label: "Pick Direction & Walk Straight", icon: "arrow.right", destination: .technique("nav-dead-reckoning")),
                                    TriageOption(id: "lost-leave-trail", label: "Walk + Leave Trail Markers", icon: "arrow.triangle.branch", destination: .technique("rescue-trail-markers"))
                                ])
                            ))
                        ])
                    ))
                ])
            ))
        ])
    }

    // =========================================================================
    // MARK: - TRAPPED / RESCUE (5 levels deep)
    // =========================================================================
    private func buildTrappedTriage() -> TriageNode {
        TriageNode(id: "trapped-root", question: "Can you move freely?", options: [

            // CAN MOVE
            TriageOption(id: "trapped-can-move", label: "Yes — Can Move", icon: "figure.walk", destination: .nextQuestion(
                TriageNode(id: "trapped-block", question: "What's preventing rescue?", options: [

                    // No one knows
                    TriageOption(id: "trapped-no-signal", label: "No One Knows I'm Here", icon: "antenna.radiowaves.left.and.right.slash", destination: .nextQuestion(
                        TriageNode(id: "trapped-sig-tools", question: "What signaling tools do you have?", options: [
                            TriageOption(id: "trapped-phone", label: "Phone (Even No Service)", icon: "iphone", destination: .technique("rescue-phone-emergency")),
                            TriageOption(id: "trapped-mirror", label: "Mirror / Reflective Object", icon: "sparkle", destination: .technique("rescue-signal-mirror")),
                            TriageOption(id: "trapped-whistle", label: "Whistle", icon: "speaker.wave.3.fill", destination: .technique("rescue-whistle")),
                            TriageOption(id: "trapped-smoke", label: "Make Colored Smoke", icon: "smoke.fill", destination: .technique("rescue-smoke-signal")),
                            TriageOption(id: "trapped-fire-sig", label: "Can Make Fire", icon: "flame.fill", destination: .technique("rescue-signal-fire")),
                            TriageOption(id: "trapped-morse", label: "Flashlight / Tapping Surface", icon: "flashlight.on.fill", destination: .technique("rescue-morse-code")),
                            TriageOption(id: "trapped-nothing-sig", label: "Nothing — No Tools", icon: "xmark.circle.fill", destination: .nextQuestion(
                                TriageNode(id: "trapped-prim-sig", question: "What's around you?", options: [
                                    TriageOption(id: "trapped-open-ground", label: "Open Ground / Clearing", icon: "square.fill", destination: .nextQuestion(
                                        TriageNode(id: "trapped-vis-signal", question: "Visual Signal Type?", options: [
                                            TriageOption(id: "trapped-ground-sig", label: "Ground Symbols (X, V)", icon: "textformat", destination: .technique("rescue-ground-signal")),
                                            TriageOption(id: "trapped-sos-large", label: "Large SOS", icon: "exclamationmark.circle", destination: .technique("rescue-sos")),
                                            TriageOption(id: "trapped-clothes", label: "Bright Clothing", icon: "tshirt.fill", destination: .technique("rescue-ground-signal"))
                                        ])
                                    )),
                                    TriageOption(id: "trapped-dense-cover", label: "Dense Cover / Canopy", icon: "tree.fill", destination: .technique("rescue-whistle")), // Audio is better
                                    TriageOption(id: "trapped-heli", label: "Helicopter Might Come", icon: "airplane", destination: .technique("rescue-helicopter-lz"))
                                ])
                            ))
                        ])
                    )),

                    // Terrain blocked
                    TriageOption(id: "trapped-terrain", label: "Terrain Blocked", icon: "mountain.2.fill", destination: .nextQuestion(
                        TriageNode(id: "trapped-terrain-q", question: "What's blocking you?", options: [
                            TriageOption(id: "trapped-river", label: "River / Water Crossing", icon: "water.waves", destination: .technique("rescue-self-rescue")),
                            TriageOption(id: "trapped-cliff", label: "Cliff / Steep Drop", icon: "arrow.down.to.line", destination: .technique("rescue-self-rescue")),
                            TriageOption(id: "trapped-dense-veg", label: "Dense Vegetation", icon: "tree.fill", destination: .technique("nav-terrain-association")),
                            TriageOption(id: "trapped-swamp", label: "Swamp / Wetland", icon: "water.waves", destination: .technique("env-swamp-survival"))
                        ])
                    )),

                    // Self-rescue
                    TriageOption(id: "trapped-self", label: "Want to Self-Rescue", icon: "arrow.right.circle.fill", destination: .nextQuestion(
                        TriageNode(id: "trapped-self-q", question: "Do you know which direction?", options: [
                            TriageOption(id: "trapped-know-dir", label: "Yes — Know the Way", icon: "location.fill", destination: .technique("rescue-self-rescue")),
                            TriageOption(id: "trapped-follow-water", label: "No — Follow Water Downhill", icon: "water.waves", destination: .technique("nav-following-water")),
                            TriageOption(id: "trapped-trail", label: "Going to Try + Leave Markers", icon: "arrow.triangle.branch", destination: .technique("rescue-trail-markers")),
                            TriageOption(id: "trapped-leave-markers", label: "Mark Path for Rescuers", icon: "signpost.right.fill", destination: .technique("rescue-leave-trail"))
                        ])
                    ))
                ])
            )),

            // CANNOT MOVE
            TriageOption(id: "trapped-no-move", label: "No — Injured / Pinned", icon: "figure.roll", destination: .nextQuestion(
                TriageNode(id: "trapped-immobile", question: "What's the situation?", options: [

                    // Injured
                    TriageOption(id: "trapped-injured", label: "Injured — Need First Aid", icon: "cross.case.fill", destination: .nextQuestion(
                        TriageNode(id: "trapped-injury", question: "What type of injury?", options: [

                            // ── BLEEDING ──
                            TriageOption(id: "trapped-bleeding", label: "Bleeding Heavily", icon: "drop.fill", destination: .nextQuestion(
                                TriageNode(id: "trapped-bleed-q", question: "Where is the bleeding?", options: [
                                    TriageOption(id: "trapped-bleed-limb", label: "Arm or Leg", icon: "figure.arms.open", destination: .nextQuestion(
                                        TriageNode(id: "trapped-bleed-type", question: "Is blood spurting?", options: [
                                            TriageOption(id: "trapped-bleed-art", label: "Yes — Spurting (Arterial)", icon: "drop.fill", destination: .nextQuestion(
                                                TriageNode(id: "trapped-tq-mat", question: "What can you use as a tourniquet?", options: [
                                                    TriageOption(id: "trapped-tq-belt", label: "Belt / Strap", icon: "rectangle.fill", destination: .technique("firstaid-tourniquet")),
                                                    TriageOption(id: "trapped-tq-cloth", label: "Torn Cloth / Shirt", icon: "tshirt.fill", destination: .technique("firstaid-tourniquet")),
                                                    TriageOption(id: "trapped-tq-cord", label: "Cord / Rope", icon: "line.diagonal", destination: .technique("firstaid-tourniquet")),
                                                    TriageOption(id: "trapped-tq-nothing", label: "Nothing — Direct Pressure Only", icon: "hand.raised.fill", destination: .technique("firstaid-pressure-bandage"))
                                                ])
                                            )),
                                            TriageOption(id: "trapped-bleed-ven", label: "No — Flowing (Venous)", icon: "drop", destination: .nextQuestion(
                                                TriageNode(id: "trapped-ven-q", question: "Can you apply pressure?", options: [
                                                    TriageOption(id: "trapped-ven-cloth", label: "Have Cloth / Bandage", icon: "bandage.fill", destination: .technique("firstaid-pressure-bandage")),
                                                    TriageOption(id: "trapped-ven-hand", label: "Bare Hands Only", icon: "hand.raised.fill", destination: .technique("firstaid-pressure-bandage")),
                                                    TriageOption(id: "trapped-ven-elevate", label: "Can Elevate Limb", icon: "arrow.up", destination: .technique("firstaid-wound-cleaning"))
                                                ])
                                            ))
                                        ])
                                    )),
                                    TriageOption(id: "trapped-bleed-torso", label: "Torso / Chest", icon: "heart.fill", destination: .nextQuestion(
                                        TriageNode(id: "trapped-torso-q", question: "Type of wound?", options: [
                                            TriageOption(id: "trapped-torso-stab", label: "Penetrating (Stab / Puncture)", icon: "exclamationmark.triangle.fill", destination: .technique("firstaid-pressure-bandage")),
                                            TriageOption(id: "trapped-torso-blunt", label: "Blunt (Fall / Crush)", icon: "rectangle.compress.vertical", destination: .technique("firstaid-shock")),
                                            TriageOption(id: "trapped-torso-sucking", label: "Sucking Chest Wound (Air Noise)", icon: "lungs.fill", destination: .technique("firstaid-pressure-bandage"))
                                        ])
                                    )),
                                    TriageOption(id: "trapped-bleed-head", label: "Head / Face", icon: "brain.head.profile", destination: .nextQuestion(
                                        TriageNode(id: "trapped-head-bleed-q", question: "How bad?", options: [
                                            TriageOption(id: "trapped-head-scalp", label: "Scalp Wound (Lots of Blood)", icon: "drop.fill", destination: .technique("firstaid-wound-cleaning")),
                                            TriageOption(id: "trapped-head-deep", label: "Deep Cut / Gash", icon: "exclamationmark.triangle.fill", destination: .technique("firstaid-pressure-bandage")),
                                            TriageOption(id: "trapped-head-eye", label: "Near Eye", icon: "eye.fill", destination: .technique("firstaid-wound-cleaning"))
                                        ])
                                    )),
                                    TriageOption(id: "trapped-bleed-nose", label: "Nosebleed", icon: "nose.fill", destination: .technique("firstaid-nosebleed"))
                                ])
                            )),

                            // ── FRACTURES ──
                            TriageOption(id: "trapped-broken", label: "Possible Fracture / Dislocation", icon: "bandage.fill", destination: .nextQuestion(
                                TriageNode(id: "trapped-fracture-q", question: "Which body part?", options: [
                                    TriageOption(id: "trapped-frac-arm", label: "Arm / Wrist", icon: "figure.arms.open", destination: .nextQuestion(
                                        TriageNode(id: "trapped-arm-type", question: "Is bone visible through skin?", options: [
                                            TriageOption(id: "trapped-arm-open", label: "Yes — Open Fracture (Bone Out)", icon: "exclamationmark.triangle.fill", destination: .techniqueList(["firstaid-wound-cleaning", "firstaid-arm-splint"])),
                                            TriageOption(id: "trapped-arm-closed", label: "No — Closed (Swollen/Deformed)", icon: "bandage.fill", destination: .nextQuestion(
                                                TriageNode(id: "trapped-arm-splint-mat", question: "Splint material available?", options: [
                                                    TriageOption(id: "trapped-arm-stick", label: "Sticks / Rigid Object", icon: "line.diagonal", destination: .technique("firstaid-arm-splint")),
                                                    TriageOption(id: "trapped-arm-pad", label: "Padding Only (Cloth/Jacket)", icon: "tshirt.fill", destination: .technique("firstaid-arm-splint")),
                                                    TriageOption(id: "trapped-arm-body", label: "Nothing — Body Splint (Sling)", icon: "hand.raised.fill", destination: .technique("firstaid-arm-splint"))
                                                ])
                                            ))
                                        ])
                                    )),
                                    TriageOption(id: "trapped-frac-leg", label: "Leg / Ankle", icon: "figure.walk", destination: .nextQuestion(
                                        TriageNode(id: "trapped-leg-type", question: "Is bone visible through skin?", options: [
                                            TriageOption(id: "trapped-leg-open", label: "Yes — Open Fracture", icon: "exclamationmark.triangle.fill", destination: .techniqueList(["firstaid-wound-cleaning", "firstaid-leg-splint"])),
                                            TriageOption(id: "trapped-leg-closed", label: "No — Closed Fracture", icon: "bandage.fill", destination: .nextQuestion(
                                                TriageNode(id: "trapped-leg-splint-mat", question: "Splint material?", options: [
                                                    TriageOption(id: "trapped-leg-stick", label: "Branches / Poles", icon: "line.diagonal", destination: .technique("firstaid-leg-splint")),
                                                    TriageOption(id: "trapped-leg-buddy", label: "Buddy Splint (Tape to Other Leg)", icon: "figure.2.arms.open", destination: .technique("firstaid-leg-splint")),
                                                    TriageOption(id: "trapped-leg-pad", label: "Padding / Clothing Only", icon: "tshirt.fill", destination: .technique("firstaid-leg-splint"))
                                                ])
                                            ))
                                        ])
                                    )),
                                    TriageOption(id: "trapped-frac-ribs", label: "Ribs (Pain When Breathing)", icon: "lungs.fill", destination: .technique("firstaid-pressure-bandage")),
                                    TriageOption(id: "trapped-frac-spine", label: "Back / Spine (Don't Move!)", icon: "exclamationmark.triangle.fill", destination: .technique("firstaid-spinal-immobilization")),
                                    TriageOption(id: "trapped-dislocate", label: "Joint Popped Out", icon: "arrow.left.arrow.right", destination: .nextQuestion(
                                        TriageNode(id: "trapped-disloc-q", question: "Which joint?", options: [
                                            TriageOption(id: "trapped-disloc-shoulder", label: "Shoulder", icon: "figure.arms.open", destination: .technique("firstaid-dislocated-joint")),
                                            TriageOption(id: "trapped-disloc-finger", label: "Finger / Toe", icon: "hand.raised.fill", destination: .technique("firstaid-dislocated-joint")),
                                            TriageOption(id: "trapped-disloc-knee", label: "Knee / Hip", icon: "figure.walk", destination: .technique("firstaid-dislocated-joint"))
                                        ])
                                    ))
                                ])
                            )),

                            // ── IMPALED / CRUSH ──
                            TriageOption(id: "trapped-impaled", label: "Impaled Object", icon: "exclamationmark.triangle.fill", destination: .technique("firstaid-impaled-object")),
                            TriageOption(id: "trapped-crush", label: "Crushed / Pinned Under Weight", icon: "rectangle.compress.vertical", destination: .technique("firstaid-crush-injury")),

                            // ── SHOCK ──
                            TriageOption(id: "trapped-shock", label: "Shock Symptoms", icon: "heart.fill", destination: .nextQuestion(
                                TriageNode(id: "trapped-shock-q", question: "Is the person conscious?", options: [
                                    TriageOption(id: "trapped-shock-conscious", label: "Yes — Conscious", icon: "eye.fill", destination: .nextQuestion(
                                        TriageNode(id: "trapped-shock-con-q", question: "Can they lie down?", options: [
                                            TriageOption(id: "trapped-shock-lie", label: "Yes — Elevate Legs", icon: "arrow.up", destination: .technique("firstaid-shock")),
                                            TriageOption(id: "trapped-shock-sit", label: "No — Keep Seated / Warm", icon: "flame.fill", destination: .technique("firstaid-shock")),
                                            TriageOption(id: "trapped-shock-vomit", label: "Vomiting — Recovery Position", icon: "arrow.turn.down.right", destination: .technique("firstaid-recovery-position"))
                                        ])
                                    )),
                                    TriageOption(id: "trapped-shock-uncon", label: "No — Unconscious", icon: "zzz", destination: .nextQuestion(
                                        TriageNode(id: "trapped-shock-uncon-q", question: "Are they breathing?", options: [
                                            TriageOption(id: "trapped-shock-breathing", label: "Yes — Breathing", icon: "lungs.fill", destination: .technique("firstaid-recovery-position")),
                                            TriageOption(id: "trapped-shock-no-breath", label: "No — Not Breathing", icon: "exclamationmark.triangle.fill", destination: .technique("firstaid-cpr"))
                                        ])
                                    ))
                                ])
                            )),

                            // ── BURNS ──
                            TriageOption(id: "trapped-burn", label: "Burn Injury", icon: "flame.fill", destination: .nextQuestion(
                                TriageNode(id: "trapped-burn-type", question: "What caused the burn?", options: [
                                    TriageOption(id: "trapped-burn-fire", label: "Fire / Heat (Thermal)", icon: "flame.fill", destination: .nextQuestion(
                                        TriageNode(id: "trapped-burn-deg", question: "Appearance?", options: [
                                            TriageOption(id: "burn-deg-2", label: "Blisters / Red / Wet", icon: "drop.fill", destination: .nextQuestion(
                                                TriageNode(id: "burn-2-area", question: "How large is the burn?", options: [
                                                    TriageOption(id: "burn-2-small", label: "Small (Palm-Sized or Less)", icon: "hand.raised.fill", destination: .technique("firstaid-burn-blister")),
                                                    TriageOption(id: "burn-2-large", label: "Large (Bigger Than Palm)", icon: "exclamationmark.triangle.fill", destination: .techniqueList(["firstaid-burn-blister", "firstaid-shock"])),
                                                    TriageOption(id: "burn-2-face", label: "Face / Hands / Genitals", icon: "exclamationmark.circle.fill", destination: .techniqueList(["firstaid-burn-blister", "firstaid-shock"]))
                                                ])
                                            )),
                                            TriageOption(id: "burn-deg-3", label: "Charred / Black / White", icon: "circle.fill", destination: .nextQuestion(
                                                TriageNode(id: "burn-3-airway", question: "Any breathing issues?", options: [
                                                    TriageOption(id: "burn-3-breath-ok", label: "No — Breathing Fine", icon: "checkmark.circle", destination: .technique("firstaid-burn-char")),
                                                    TriageOption(id: "burn-3-breath-bad", label: "Yes — Coughing / Soot Around Nose", icon: "lungs.fill", destination: .techniqueList(["firstaid-burn-char", "firstaid-asthma"])),
                                                    TriageOption(id: "burn-3-face", label: "Burns on Face / Neck", icon: "exclamationmark.triangle.fill", destination: .techniqueList(["firstaid-burn-char", "firstaid-shock"]))
                                                ])
                                            ))
                                        ])
                                    )),
                                    TriageOption(id: "trapped-burn-chem", label: "Chemicals", icon: "flask.fill", destination: .nextQuestion(
                                        TriageNode(id: "burn-chem-q", question: "Water available to flush?", options: [
                                            TriageOption(id: "burn-chem-water", label: "Yes — Have Water", icon: "drop.fill", destination: .technique("firstaid-chemical-burn")),
                                            TriageOption(id: "burn-chem-no-water", label: "No Water Available", icon: "xmark.circle.fill", destination: .technique("firstaid-chemical-burn")),
                                            TriageOption(id: "burn-chem-eyes", label: "Chemical in Eyes", icon: "eye.fill", destination: .technique("firstaid-chemical-burn"))
                                        ])
                                    )),
                                    TriageOption(id: "trapped-burn-sun", label: "Severe Sunburn", icon: "sun.max.fill", destination: .technique("firstaid-burn-blister")),
                                    TriageOption(id: "trapped-burn-electric", label: "Electrical", icon: "bolt.fill", destination: .techniqueList(["firstaid-burn-char", "firstaid-cpr"]))
                                ])
                            )),

                            // ── HEAD TRAUMA ──
                            TriageOption(id: "trapped-head-inj", label: "Head Injury / Concussion", icon: "brain.head.profile", destination: .nextQuestion(
                                TriageNode(id: "trapped-head-q", question: "Is the person conscious?", options: [
                                    TriageOption(id: "head-unconscious", label: "Unconscious / Waking Up", icon: "zzz", destination: .nextQuestion(
                                        TriageNode(id: "head-uncon-q", question: "Are they breathing?", options: [
                                            TriageOption(id: "head-uncon-breath", label: "Yes — Breathing", icon: "lungs.fill", destination: .technique("firstaid-recovery-position")),
                                            TriageOption(id: "head-uncon-no-breath", label: "No — Not Breathing", icon: "exclamationmark.triangle.fill", destination: .technique("firstaid-cpr"))
                                        ])
                                    )),
                                    TriageOption(id: "head-conscious", label: "Conscious", icon: "eye.fill", destination: .nextQuestion(
                                        TriageNode(id: "trapped-head-symp", question: "Check symptoms:", options: [
                                            TriageOption(id: "head-pupil-unequal", label: "Unequal Pupils / One Large", icon: "exclamationmark.circle.fill", destination: .technique("firstaid-head-trauma")),
                                            TriageOption(id: "head-pupil-normal", label: "Normal Pupils / Dizzy", icon: "checkmark.circle", destination: .technique("firstaid-head-concussion")),
                                            TriageOption(id: "head-vomiting", label: "Vomiting Repeatedly", icon: "exclamationmark.triangle.fill", destination: .technique("firstaid-head-trauma")),
                                            TriageOption(id: "head-fluid", label: "Clear Fluid From Ears/Nose", icon: "drop.fill", destination: .technique("firstaid-head-trauma")),
                                            TriageOption(id: "head-confused", label: "Confused / Slurred Speech", icon: "brain.head.profile", destination: .technique("firstaid-head-trauma"))
                                        ])
                                    ))
                                ])
                            )),

                            // ── ALLERGIC REACTION ──
                            TriageOption(id: "trapped-allergy", label: "Allergic Reaction", icon: "allergens.fill", destination: .nextQuestion(
                                TriageNode(id: "trapped-allergy-q", question: "How severe?", options: [
                                    TriageOption(id: "trapped-allergy-severe", label: "Throat Swelling / Can't Breathe", icon: "exclamationmark.triangle.fill", destination: .nextQuestion(
                                        TriageNode(id: "trapped-allergy-epi", question: "EpiPen / Adrenaline available?", options: [
                                            TriageOption(id: "trapped-epi-yes", label: "Yes — Have EpiPen", icon: "syringe.fill", destination: .technique("firstaid-anaphylaxis")),
                                            TriageOption(id: "trapped-epi-no", label: "No EpiPen", icon: "xmark.circle.fill", destination: .technique("firstaid-anaphylaxis"))
                                        ])
                                    )),
                                    TriageOption(id: "trapped-allergy-mild", label: "Hives / Itching / Mild Swelling", icon: "hand.raised.fill", destination: .technique("firstaid-allergic-reaction")),
                                    TriageOption(id: "trapped-allergy-sting", label: "Insect Sting Reaction", icon: "ant.fill", destination: .technique("firstaid-sting-treat"))
                                ])
                            )),

                            // ── MEDICAL EMERGENCIES ──
                            TriageOption(id: "trapped-heart", label: "Chest Pain / Heart Attack Signs", icon: "heart.fill", destination: .nextQuestion(
                                TriageNode(id: "trapped-heart-q", question: "Is the person conscious?", options: [
                                    TriageOption(id: "trapped-heart-con", label: "Yes — Conscious", icon: "eye.fill", destination: .technique("firstaid-heart-attack")),
                                    TriageOption(id: "trapped-heart-uncon", label: "No — Collapsed", icon: "zzz", destination: .technique("firstaid-cpr"))
                                ])
                            )),
                            TriageOption(id: "trapped-stroke", label: "Face Drooping / Slurred Speech", icon: "brain.head.profile", destination: .technique("firstaid-stroke")),
                            TriageOption(id: "trapped-breathing", label: "Can't Breathe / Asthma", icon: "lungs.fill", destination: .nextQuestion(
                                TriageNode(id: "trapped-breath-q", question: "What's happening?", options: [
                                    TriageOption(id: "trapped-choke", label: "Choking on Object", icon: "exclamationmark.triangle.fill", destination: .technique("firstaid-choking")),
                                    TriageOption(id: "trapped-asthma", label: "Asthma / Tight Chest", icon: "lungs.fill", destination: .technique("firstaid-asthma")),
                                    TriageOption(id: "trapped-smoke-inhal", label: "Smoke Inhalation", icon: "smoke.fill", destination: .techniqueList(["firstaid-asthma", "firstaid-recovery-position"]))
                                ])
                            )),
                            TriageOption(id: "trapped-hypervent", label: "Hyperventilating / Panic", icon: "wind", destination: .technique("firstaid-hyperventilation")),
                            TriageOption(id: "trapped-no-pulse", label: "No Pulse / Not Breathing", icon: "heart.slash.fill", destination: .technique("firstaid-cpr"))
                        ])
                    )),

                    // Physically pinned
                    TriageOption(id: "trapped-pinned", label: "Physically Trapped / Pinned", icon: "rectangle.compress.vertical", destination: .nextQuestion(
                        TriageNode(id: "trapped-pinned-q", question: "Can you attract attention?", options: [
                            TriageOption(id: "trapped-yell", label: "Can Yell / Make Noise", icon: "speaker.wave.3.fill", destination: .technique("rescue-whistle")),
                            TriageOption(id: "trapped-tap", label: "Can Tap on Hard Surface", icon: "hand.tap.fill", destination: .technique("rescue-morse-code")),
                            TriageOption(id: "trapped-phone-pin", label: "Have Phone", icon: "iphone", destination: .technique("rescue-phone-emergency")),
                            TriageOption(id: "trapped-nothing-pin", label: "Cannot Signal", icon: "xmark.circle.fill", destination: .technique("psych-box-breathing"))
                        ])
                    )),

                    // Waiting for rescue
                    TriageOption(id: "trapped-waiting", label: "Safe — Waiting for Rescue", icon: "clock.fill", destination: .nextQuestion(
                        TriageNode(id: "trapped-needs", question: "What do you need most?", options: [
                            TriageOption(id: "trapped-need-water", label: "Water", icon: "drop.fill", destination: .techniqueList(["water-rain-collection", "water-dew-collection", "water-condensation-trap"])),
                            TriageOption(id: "trapped-need-warmth", label: "Warmth", icon: "flame.fill", destination: .techniqueList(["shelter-mylar-wrap", "shelter-emergency-bivy", "firstaid-hypothermia"])),
                            TriageOption(id: "trapped-need-food", label: "Food", icon: "leaf.fill", destination: .techniqueList(["food-common-edibles", "food-cattail", "food-insect-eating", "food-shellfish", "food-frog-catching"])),
                            TriageOption(id: "trapped-need-morale", label: "Staying Calm / Morale", icon: "brain.head.profile", destination: .techniqueList(["psych-box-breathing", "psych-54321-grounding", "psych-routine", "psych-loneliness", "psych-ooda-loop"])),
                            TriageOption(id: "trapped-need-pain", label: "Managing Pain", icon: "cross.case.fill", destination: .technique("psych-pain-management")),
                            TriageOption(id: "trapped-need-tools", label: "Making Tools / Traps", icon: "wrench.and.screwdriver.fill", destination: .techniqueList(["tools-trap-triggers", "tools-bow-making", "tools-stone-axe"]))
                        ])
                    ))
                ])
            ))
        ])
    }

    // =========================================================================
    // MARK: - NATURAL DISASTER (5 levels deep)
    // =========================================================================
    private func buildDisasterTriage() -> TriageNode {
        TriageNode(id: "disaster-root", question: "What disaster are you facing?", options: [

            // --- EARTHQUAKE ---
            TriageOption(id: "dis-earthquake", label: "Earthquake", icon: "waveform.path.ecg", destination: .nextQuestion(
                TriageNode(id: "dis-eq-q", question: "Where are you?", options: [
                    TriageOption(id: "dis-eq-indoor", label: "Indoors", icon: "building.2.fill", destination: .technique("env-earthquake")),
                    TriageOption(id: "dis-eq-outdoor", label: "Outdoors", icon: "tree.fill", destination: .technique("env-earthquake")),
                    TriageOption(id: "dis-eq-vehicle", label: "In a Vehicle", icon: "car.fill", destination: .technique("env-earthquake")),
                    TriageOption(id: "dis-eq-after", label: "Earthquake Over — Now What?", icon: "checkmark.circle", destination: .nextQuestion(
                        TriageNode(id: "dis-eq-after-q", question: "What's your situation?", options: [
                            TriageOption(id: "dis-eq-injured", label: "Injured", icon: "cross.case.fill", destination: .techniqueList(["firstaid-wound-cleaning", "firstaid-crush-injury", "firstaid-shock"])),
                            TriageOption(id: "dis-eq-trapped", label: "Trapped Under Debris", icon: "rectangle.compress.vertical", destination: .techniqueList(["rescue-morse-code", "rescue-whistle", "rescue-phone-emergency"])),
                            TriageOption(id: "dis-eq-gas", label: "Smell Gas / Leaks", icon: "exclamationmark.triangle.fill", destination: .technique("env-urban-disaster")),
                            TriageOption(id: "dis-eq-safe", label: "Safe — Need Shelter", icon: "house.fill", destination: .techniqueList(["shelter-poncho", "shelter-vehicle", "shelter-emergency-bivy"]))
                        ])
                    ))
                ])
            )),

            // --- TORNADO ---
            TriageOption(id: "dis-tornado", label: "Tornado", icon: "tornado", destination: .nextQuestion(
                TriageNode(id: "dis-tor-q", question: "Where are you?", options: [
                    TriageOption(id: "dis-tor-building", label: "In a Building", icon: "building.2.fill", destination: .technique("env-tornado")),
                    TriageOption(id: "dis-tor-mobile", label: "Mobile Home", icon: "house.fill", destination: .technique("env-tornado-shelter")), // Specific tech if available, else env-tornado
                    TriageOption(id: "dis-tor-vehicle", label: "In a Vehicle", icon: "car.fill", destination: .nextQuestion(
                        TriageNode(id: "dis-tor-debris", question: "Is debris hitting you?", options: [
                            TriageOption(id: "dis-tor-hit", label: "Yes — Flying Debris", icon: "exclamationmark.triangle.fill", destination: .technique("env-tornado-shelter")),
                            TriageOption(id: "dis-tor-clear", label: "No — Distant", icon: "car.fill", destination: .technique("env-tornado"))
                        ])
                    )),
                    TriageOption(id: "dis-tor-outdoor", label: "Open Outdoors", icon: "figure.walk", destination: .technique("env-tornado-shelter"))
                ])
            )),

            // --- WILDFIRE ---
            TriageOption(id: "dis-wildfire", label: "Wildfire", icon: "flame.fill", destination: .nextQuestion(
                TriageNode(id: "dis-fire-q", question: "How close is the fire?", options: [
                    TriageOption(id: "dis-fire-far", label: "Visible but Far", icon: "arrow.right", destination: .nextQuestion(
                         TriageNode(id: "dis-fire-wind", question: "Where is the wind blowing?", options: [
                            TriageOption(id: "dis-fire-upwind", label: "Fire is Upwind (Coming at me)", icon: "wind", destination: .technique("env-wildfire-evac")),
                            TriageOption(id: "dis-fire-downwind", label: "Fire is Downwind (Moving away)", icon: "arrow.right.circle", destination: .technique("env-wildfire"))
                         ])
                    )),
                    TriageOption(id: "dis-fire-near", label: "Close — Smoke Heavy", icon: "smoke.fill", destination: .technique("env-wildfire")),
                    TriageOption(id: "dis-fire-vehicle", label: "Trapped in Vehicle", icon: "car.fill", destination: .technique("env-wildfire-evac")),
                    TriageOption(id: "dis-fire-house", label: "Trapped in House", icon: "house.fill", destination: .technique("env-wildfire")),
                    TriageOption(id: "dis-fire-surrounded", label: "Surrounded Outdoors", icon: "xmark.circle.fill", destination: .technique("env-wildfire-survival"))
                ])
            )),

            // --- FLOOD ---
            TriageOption(id: "dis-flood", label: "Flood / Flash Flood", icon: "water.waves", destination: .nextQuestion(
                TriageNode(id: "dis-flood-q", question: "Where are you?", options: [
                    TriageOption(id: "dis-flood-indoor", label: "Indoors", icon: "house.fill", destination: .technique("env-flood-survival")),
                    TriageOption(id: "dis-flood-vehicle", label: "In a Vehicle (Stalled?)", icon: "car.fill", destination: .technique("env-flood-survival")),
                    TriageOption(id: "dis-flood-outdoor", label: "Outdoors / Swept Away", icon: "figure.wave", destination: .techniqueList(["env-flood-survival", "rescue-self-rescue"])),
                    TriageOption(id: "dis-flood-after", label: "Water Receding", icon: "arrow.down", destination: .technique("water-boiling")) // Disease risk
                ])
            )),

            // --- HURRICANE ---
            TriageOption(id: "dis-hurricane", label: "Hurricane / Cyclone", icon: "hurricane", destination: .nextQuestion(
                TriageNode(id: "dis-hurr-q", question: "What stage?", options: [
                    TriageOption(id: "dis-hurr-prep", label: "Approaching (Pre-Storm)", icon: "clock.fill", destination: .technique("env-hurricane")),
                    TriageOption(id: "dis-hurr-during", label: "During the Storm", icon: "wind", destination: .technique("env-hurricane")),
                    TriageOption(id: "dis-hurr-eye", label: "Eye (Sudden Calm)", icon: "eye.fill", destination: .technique("env-hurricane")),
                    TriageOption(id: "dis-hurr-after", label: "Aftermath", icon: "exclamationmark.triangle.fill", destination: .technique("env-urban-disaster"))
                ])
            )),

            // --- BLIZZARD ---
            TriageOption(id: "dis-blizzard", label: "Blizzard / Whiteout", icon: "snowflake", destination: .nextQuestion(
                TriageNode(id: "dis-blizz-q", question: "Where are you?", options: [
                    TriageOption(id: "dis-blizz-car", label: "Stranded in Car", icon: "car.fill", destination: .technique("env-blizzard")),
                    TriageOption(id: "dis-blizz-outdoor", label: "Caught Outdoors", icon: "figure.walk", destination: .techniqueList(["env-blizzard", "shelter-snow-trench"])),
                    TriageOption(id: "dis-blizz-home", label: "At Home (No Power)", icon: "house.fill", destination: .nextQuestion(
                        TriageNode(id: "dis-blizz-home-q", question: "What is your main concern?", options: [
                            TriageOption(id: "dis-blizz-heat", label: "Staying Warm", icon: "flame.fill", destination: .nextQuestion(
                                TriageNode(id: "dis-blizz-heat-q", question: "Do you have a fireplace?", options: [
                                    TriageOption(id: "dis-blizz-fireplace", label: "Yes — Fireplace / Wood Stove", icon: "flame.fill", destination: .technique("fire-log-cabin")),
                                    TriageOption(id: "dis-blizz-no-fire", label: "No — Electric Only", icon: "xmark.circle.fill", destination: .techniqueList(["shelter-mylar-wrap", "firstaid-hypothermia"]))
                                ])
                            )),
                            TriageOption(id: "dis-blizz-water", label: "Safe Drinking Water", icon: "drop.fill", destination: .technique("water-snow-ice")),
                            TriageOption(id: "dis-blizz-hypo", label: "Signs of Hypothermia", icon: "thermometer.snowflake", destination: .technique("firstaid-hypothermia")),
                            TriageOption(id: "dis-blizz-pipe", label: "Pipes Frozen / Burst", icon: "wrench.fill", destination: .technique("water-rationing"))
                        ])
                    ))
                ])
            )),

            // --- AVALANCHE ---
            TriageOption(id: "dis-avalanche", label: "Avalanche", icon: "mountain.2.fill", destination: .nextQuestion(
                TriageNode(id: "dis-aval-q", question: "What's your situation?", options: [
                    TriageOption(id: "dis-aval-imminent", label: "Avalanche Starting — Act NOW", icon: "exclamationmark.triangle.fill", destination: .technique("env-avalanche")),
                    TriageOption(id: "dis-aval-buried", label: "Buried Under Snow", icon: "snowflake", destination: .technique("env-avalanche")),
                    TriageOption(id: "dis-aval-after", label: "After — Need to Find Someone", icon: "person.fill.questionmark", destination: .technique("env-avalanche"))
                ])
            )),

            // --- VOLCANO ---
            TriageOption(id: "dis-volcano", label: "Volcanic Eruption", icon: "smoke.fill", destination: .nextQuestion(
                TriageNode(id: "dis-volc-q", question: "What are the hazards?", options: [
                    TriageOption(id: "dis-volc-ash", label: "Ashfall (Breathing)", icon: "lungs.fill", destination: .technique("env-volcanic-ash")),
                    TriageOption(id: "dis-volc-flow", label: "Lava / Pyroclastic Flow", icon: "flame.fill", destination: .technique("env-volcanic-eruption")),
                    TriageOption(id: "dis-volc-shelter", label: "Sheltering in Place", icon: "house.fill", destination: .technique("env-volcanic-ash"))
                ])
            )),

            // --- TSUNAMI ---
            TriageOption(id: "dis-tsunami", label: "Tsunami", icon: "water.waves.and.arrow.up", destination: .nextQuestion(
                TriageNode(id: "dis-tsu-q", question: "What's happening?", options: [
                    TriageOption(id: "dis-tsu-warning", label: "Earthquake / Warning Siren", icon: "speaker.wave.3.fill", destination: .technique("env-tsunami")),
                    TriageOption(id: "dis-tsu-water", label: "Water Receding Rapidly", icon: "arrow.down.to.line", destination: .technique("env-tsunami")),
                    TriageOption(id: "dis-tsu-wave", label: "Wave Incoming / Hitting", icon: "water.waves", destination: .technique("env-tsunami")),
                    TriageOption(id: "dis-tsu-debris", label: "In Water with Debris", icon: "exclamationmark.triangle.fill", destination: .technique("env-flood-survival"))
                ])
            )),

            // --- EXTREME HEAT ---
            TriageOption(id: "dis-heat", label: "Extreme Heat / Heat Wave", icon: "sun.max.fill", destination: .nextQuestion(
                TriageNode(id: "dis-heat-q", question: "Any symptoms?", options: [
                    TriageOption(id: "dis-heat-cramp", label: "Cramps / Heavy Sweating", icon: "drop.fill", destination: .technique("env-extreme-heat")),
                    TriageOption(id: "dis-heat-stroke", label: "No Sweat / Confusion / Hot Skin", icon: "exclamationmark.triangle.fill", destination: .technique("firstaid-heat-stroke")),
                    TriageOption(id: "dis-heat-water", label: "Need Water Source", icon: "waterbottle.fill", destination: .technique("water-vegetation-indicators"))
                ])
            )),

            // --- QUICKSAND ---
            TriageOption(id: "dis-quicksand", label: "Quicksand / Mud", icon: "arrow.down.circle.fill", destination: .technique("env-quicksand")),

            // --- LIGHTNING ---
            TriageOption(id: "dis-lightning", label: "Lightning Storm", icon: "bolt.fill", destination: .nextQuestion(
                TriageNode(id: "dis-light-dist", question: "Count seconds: Flash to Bang", options: [
                    TriageOption(id: "light-close", label: "Under 30 Seconds (Close!)", icon: "exclamationmark.triangle.fill", destination: .technique("env-lightning-safety")),
                    TriageOption(id: "light-far", label: "Over 30 Seconds", icon: "checkmark.circle", destination: .nextQuestion(
                        TriageNode(id: "dis-light-q", question: "Where are you?", options: [
                            TriageOption(id: "dis-light-ridge", label: "High Ground / Ridge", icon: "mountain.2.fill", destination: .technique("env-lightning")),
                            TriageOption(id: "dis-light-open", label: "Open Field", icon: "figure.walk", destination: .technique("env-lightning")),
                            TriageOption(id: "dis-light-forest", label: "In Forest", icon: "tree.fill", destination: .technique("env-lightning")),
                            TriageOption(id: "dis-light-struck", label: "Someone Was Struck", icon: "bolt.heart.fill", destination: .techniqueList(["env-lightning", "firstaid-cpr"]))
                        ])
                    ))
                ])
            ))
        ])
    }

    // =========================================================================
    // MARK: - NEED FOOD (5 levels deep)
    // =========================================================================
    private func buildFoodTriage() -> TriageNode {
        TriageNode(id: "food-root", question: "What is your immediate situation?", options: [

            // --- STARVATION RISK ---
            TriageOption(id: "food-starve", label: "No Food for Days / Starving", icon: "exclamationmark.triangle.fill", destination: .nextQuestion(
                TriageNode(id: "food-starve-q", question: "How long without food?", options: [
                    TriageOption(id: "food-days-3", label: "1-3 Days", icon: "clock", destination: .nextQuestion(
                        TriageNode(id: "food-days3-q", question: "What can you do right now?", options: [
                            TriageOption(id: "food-3d-forage", label: "Forage for Anything Safe", icon: "leaf.fill", destination: .techniqueList(["food-dandelion", "food-cattail", "food-insect-eating"])),
                            TriageOption(id: "food-3d-trap", label: "Set Traps / Snares", icon: "circle", destination: .techniqueList(["food-snare", "food-deadfall-trap", "food-fish-trap"])),
                            TriageOption(id: "food-3d-ration", label: "Have Small Amount — Ration It", icon: "bag.fill", destination: .technique("food-rationing")),
                            TriageOption(id: "food-3d-water", label: "Focus on Water First", icon: "drop.fill", destination: .technique("water-rationing"))
                        ])
                    )),
                    TriageOption(id: "food-days-7", label: "4-7+ Days", icon: "clock.fill", destination: .nextQuestion(
                        TriageNode(id: "food-days7-q", question: "How are you feeling?", options: [
                            TriageOption(id: "food-7d-weak", label: "Weak but Mobile", icon: "figure.walk", destination: .nextQuestion(
                                TriageNode(id: "food-7d-weak-q", question: "Best energy source?", options: [
                                    TriageOption(id: "food-7d-insects", label: "Insects / Grubs (Fast Protein)", icon: "ant.fill", destination: .technique("food-insect-eating")),
                                    TriageOption(id: "food-7d-broth", label: "Bone Broth (If Animal Parts)", icon: "drop.fill", destination: .technique("food-bone-broth")),
                                    TriageOption(id: "food-7d-bark", label: "Inner Bark / Pine Needles", icon: "tree.fill", destination: .technique("food-cattail")),
                                    TriageOption(id: "food-7d-seaweed", label: "Near Coast — Seaweed", icon: "water.waves", destination: .technique("food-seaweed"))
                                ])
                            )),
                            TriageOption(id: "food-7d-immobile", label: "Can Barely Move", icon: "bed.double.fill", destination: .techniqueList(["food-rationing", "psych-pain-management"])),
                            TriageOption(id: "food-7d-confused", label: "Confused / Dizzy", icon: "brain.head.profile", destination: .techniqueList(["food-rationing", "water-rationing", "psych-box-breathing"]))
                        ])
                    )),
                    TriageOption(id: "food-ration", label: "Have Small Amount Left", icon: "bag.fill", destination: .nextQuestion(
                        TriageNode(id: "food-ration-q", question: "How much food do you have?", options: [
                            TriageOption(id: "food-ration-1day", label: "Enough for ~1 Day", icon: "clock", destination: .technique("food-rationing")),
                            TriageOption(id: "food-ration-multi", label: "Enough for 2-3 Days", icon: "clock.fill", destination: .technique("food-rationing")),
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
                            TriageOption(id: "food-berry-no", label: "No / Unsure", icon: "questionmark.circle", destination: .technique("food-universal-edibility"))
                        ])
                    )),
                    TriageOption(id: "food-mushrooms", label: "Mushrooms", icon: "umbrella.fill", destination: .nextQuestion(
                        TriageNode(id: "food-shroom-safety", question: "Are you an expert?", options: [
                            TriageOption(id: "food-shroom-expert", label: "Yes — 100% Sure", icon: "checkmark.seal.fill", destination: .technique("food-mushroom-safety")),
                            TriageOption(id: "food-shroom-no", label: "No / Unsure", icon: "exclamationmark.triangle.fill", destination: .technique("food-avoid-plants"))
                        ])
                    )),
                    TriageOption(id: "food-greens", label: "Greens / Leaves (Dandelion, etc)", icon: "leaf.arrow.circle.path", destination: .technique("food-dandelion")),
                    TriageOption(id: "food-nuts", label: "Nuts / Acorns", icon: "circle.grid.cross.fill", destination: .technique("food-acorn-processing")),
                    TriageOption(id: "food-cattail", label: "Cattails (Wetland)", icon: "drop.fill", destination: .technique("food-cattail")),
                    TriageOption(id: "food-seaweed", label: "Seaweed / Coastal", icon: "water.waves", destination: .technique("food-seaweed"))
                ])
            )),

            // --- HUNTING / TRAPPING ---
            TriageOption(id: "food-hunt", label: "Hunting & Trapping", icon: "hare.fill", destination: .nextQuestion(
                TriageNode(id: "food-hunt-method", question: "What method?", options: [
                    TriageOption(id: "food-trap-land", label: "Passive Trapping (Snares)", icon: "circle", destination: .technique("food-snare")),
                    TriageOption(id: "food-trap-trigger", label: "Active Triggers (Deadfall)", icon: "triangle.fill", destination: .technique("food-deadfall-trap")),
                    TriageOption(id: "food-spear", label: "Spear Hunting", icon: "pencil.line", destination: .technique("food-fish-spear")),
                    TriageOption(id: "food-bird", label: "Bird Trap (Ojibwa)", icon: "bird.fill", destination: .technique("food-bird-trap")),
                    TriageOption(id: "food-insects", label: "Insects / Grubs", icon: "ant.fill", destination: .technique("food-insect-eating"))
                ])
            )),

            // --- FISHING ---
            TriageOption(id: "food-fish", label: "Fishing", icon: "fish.fill", destination: .nextQuestion(
                TriageNode(id: "food-fish-q", question: "What gear do you have?", options: [
                    TriageOption(id: "food-fish-hook", label: "Hooks / Line", icon: "pencil.slash", destination: .technique("food-hook-line")),
                    TriageOption(id: "food-fish-spear", label: "Spear / Sharp Stick", icon: "pencil.line", destination: .technique("food-fish-spear")),
                    TriageOption(id: "food-fish-trap", label: "Trap / Basket", icon: "square.grid.3x3.fill", destination: .technique("food-fish-trap")),
                    TriageOption(id: "food-fish-hand", label: "Nothing (Hand Fishing)", icon: "hand.raised.fill", destination: .technique("food-fish-spear"))
                ])
            )),

            // --- PREPARATION ---
            TriageOption(id: "food-prep", label: "Cooking / Preparation", icon: "flame.fill", destination: .nextQuestion(
                TriageNode(id: "food-prep-q", question: "What do you need to do?", options: [
                    TriageOption(id: "food-clean-game", label: "Skin / Gut Small Game", icon: "hare.fill", destination: .nextQuestion(
                        TriageNode(id: "food-clean-game-q", question: "What type of game?", options: [
                            TriageOption(id: "food-clean-small", label: "Small (Rabbit, Squirrel)", icon: "hare.fill", destination: .technique("food-animal-skinning")),
                            TriageOption(id: "food-clean-bird", label: "Bird (Pheasant, Duck)", icon: "bird.fill", destination: .technique("food-animal-skinning")),
                            TriageOption(id: "food-clean-fish", label: "Fish", icon: "fish.fill", destination: .technique("food-cooking-fire"))
                        ])
                    )),
                    TriageOption(id: "food-cook-fire", label: "Cook on Fire", icon: "flame.fill", destination: .nextQuestion(
                        TriageNode(id: "food-cook-method", question: "Best method for your food?", options: [
                            TriageOption(id: "food-cook-spit", label: "Roast on Stick / Spit", icon: "flame.fill", destination: .technique("food-cooking-fire")),
                            TriageOption(id: "food-cook-boil", label: "Boil in Container", icon: "drop.fill", destination: .technique("food-bone-broth")),
                            TriageOption(id: "food-cook-earth", label: "Underground (Earth Oven)", icon: "circle.fill", destination: .technique("food-earth-oven")),
                            TriageOption(id: "food-cook-rocks", label: "Hot Rocks (No Container)", icon: "triangle.fill", destination: .technique("food-earth-oven"))
                        ])
                    )),
                    TriageOption(id: "food-preserve", label: "Preserve for Later", icon: "clock.fill", destination: .nextQuestion(
                        TriageNode(id: "food-preserve-q", question: "How do you want to preserve?", options: [
                            TriageOption(id: "food-preserve-smoke", label: "Smoke It", icon: "smoke.fill", destination: .technique("food-smoking-meat")),
                            TriageOption(id: "food-preserve-jerk", label: "Sun Dry / Jerky", icon: "sun.max.fill", destination: .technique("food-jerky-no-salt")),
                            TriageOption(id: "food-preserve-pemm", label: "Pemmican (Long-Term)", icon: "bag.fill", destination: .technique("food-pemmican"))
                        ])
                    ))
                ])
            ))
        ])
    }

    // =========================================================================
    // MARK: - NEED SHELTER (4 levels deep)
    // =========================================================================
    private func buildShelterTriage() -> TriageNode {
        TriageNode(id: "shelter-root", question: "What climate/environment are you in?", options: [

            // ── TEMPERATE / FOREST ──
            TriageOption(id: "shelter-temp", label: "Temperate Forest", icon: "tree.fill", destination: .nextQuestion(
                TriageNode(id: "shelter-temp-time", question: "How much time until dark/storm?", options: [
                    TriageOption(id: "shelter-temp-immediate", label: "Less than 1 Hour", icon: "hourglass.bottomhalf.filled", destination: .nextQuestion(
                        TriageNode(id: "shelter-temp-imm-mat", question: "What do you have?", options: [
                            TriageOption(id: "shelter-temp-tarp", label: "Tarp / Poncho", icon: "square.fill", destination: .nextQuestion(
                                TriageNode(id: "shelter-temp-tarp-wind", question: "How is the wind?", options: [
                                    TriageOption(id: "shelter-tarp-calm", label: "Calm / Light", icon: "checkmark.circle", destination: .technique("shelter-tarp-aframe")),
                                    TriageOption(id: "shelter-tarp-windy", label: "Moderate Wind", icon: "wind", destination: .technique("shelter-tarp-leanto")),
                                    TriageOption(id: "shelter-tarp-gale", label: "Strong / Storm", icon: "tornado", destination: .technique("shelter-tarp-cfly"))
                                ])
                            )),
                            TriageOption(id: "shelter-temp-natural", label: "Natural Only", icon: "leaf.fill", destination: .nextQuestion(
                                TriageNode(id: "shelter-temp-nat-q", question: "What's around you?", options: [
                                    TriageOption(id: "shelter-temp-tree", label: "Fallen Tree / Low Branches", icon: "tree.fill", destination: .technique("shelter-lean-to")),
                                    TriageOption(id: "shelter-temp-rock", label: "Rock Overhang / Cave", icon: "triangle.fill", destination: .technique("shelter-rock-overhang")),
                                    TriageOption(id: "shelter-temp-well", label: "Dense Conifer Trees", icon: "tree.fill", destination: .technique("shelter-tree-well"))
                                ])
                            ))
                        ])
                    )),
                    TriageOption(id: "shelter-temp-long", label: "2+ Hours / Planning", icon: "clock.fill", destination: .nextQuestion(
                        TriageNode(id: "shelter-temp-long-mat", question: "What's the goal?", options: [
                            TriageOption(id: "shelter-temp-warmth", label: "Maximum Warmth", icon: "flame.fill", destination: .nextQuestion(
                                TriageNode(id: "shelter-temp-warmth-q", question: "How cold is it?", options: [
                                    TriageOption(id: "shelter-temp-freeze", label: "Below Freezing", icon: "thermometer.snowflake", destination: .technique("shelter-debris-aframe")),
                                    TriageOption(id: "shelter-temp-chilly", label: "Chilly (40-50°F)", icon: "thermometer.medium", destination: .technique("shelter-debris-round")),
                                    TriageOption(id: "shelter-temp-cool", label: "Cool but Bearable", icon: "thermometer.low", destination: .technique("shelter-lean-to"))
                                ])
                            )),
                            TriageOption(id: "shelter-temp-rain", label: "Rain Protection", icon: "cloud.rain.fill", destination: .nextQuestion(
                                TriageNode(id: "shelter-temp-rain-q", question: "Materials available?", options: [
                                    TriageOption(id: "shelter-temp-rain-tarp", label: "Tarp / Plastic", icon: "square.fill", destination: .technique("shelter-tarp-aframe")),
                                    TriageOption(id: "shelter-temp-rain-bark", label: "Bark / Large Leaves", icon: "leaf.fill", destination: .technique("shelter-debris-hut")),
                                    TriageOption(id: "shelter-temp-rain-none", label: "Nothing", icon: "xmark.circle.fill", destination: .technique("shelter-debris-aframe"))
                                ])
                            )),
                            TriageOption(id: "shelter-temp-comfort", label: "Comfort / Space", icon: "bed.double.fill", destination: .technique("shelter-lean-to")),
                            TriageOption(id: "shelter-temp-bed", label: "Need Bedding / Insulation", icon: "leaf.fill", destination: .nextQuestion(
                                TriageNode(id: "shelter-temp-bed-q", question: "What ground material is available?", options: [
                                    TriageOption(id: "shelter-bed-leaves", label: "Fallen Leaves", icon: "leaf.fill", destination: .technique("shelter-ground-insulation")),
                                    TriageOption(id: "shelter-bed-pine", label: "Pine Boughs", icon: "tree.fill", destination: .technique("shelter-bough-bed")),
                                    TriageOption(id: "shelter-bed-grass", label: "Tall Grass / Cattails", icon: "leaf.fill", destination: .technique("shelter-grass-bed")),
                                    TriageOption(id: "shelter-bed-nothing", label: "Nothing Soft", icon: "xmark.circle.fill", destination: .technique("shelter-ground-insulation"))
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
                                    TriageOption(id: "shelter-cold-hours", label: "2+ Hours", icon: "clock.fill", destination: .technique("shelter-quinzhee")),
                                    TriageOption(id: "shelter-cold-urgent", label: "Under 1 Hour", icon: "hourglass.bottomhalf.filled", destination: .technique("shelter-snow-trench"))
                                ])
                            )),
                            TriageOption(id: "shelter-cold-hands", label: "Hands Only", icon: "hand.raised.fill", destination: .nextQuestion(
                                TriageNode(id: "shelter-cold-hands-q", question: "Are there trees nearby?", options: [
                                    TriageOption(id: "shelter-cold-hands-tree", label: "Yes — Conifer Trees", icon: "tree.fill", destination: .technique("shelter-tree-well")),
                                    TriageOption(id: "shelter-cold-hands-open", label: "No — Open Snow", icon: "xmark.circle.fill", destination: .technique("shelter-snow-trench"))
                                ])
                            ))
                        ])
                    )),
                    TriageOption(id: "shelter-cold-hard", label: "Hard Packed / Ice", icon: "square.stack.3d.up.fill", destination: .nextQuestion(
                        TriageNode(id: "shelter-cold-hard-q", question: "Can you cut firm blocks?", options: [
                            TriageOption(id: "shelter-cold-blocks-yes", label: "Yes — Have Cutting Tool", icon: "square.stack.3d.up.fill", destination: .technique("shelter-igloo")),
                            TriageOption(id: "shelter-cold-blocks-no", label: "No — Surface Too Hard", icon: "xmark.circle.fill", destination: .technique("shelter-snow-trench"))
                        ])
                    )),
                    TriageOption(id: "shelter-cold-tree", label: "Below Tree Line", icon: "tree.fill", destination: .nextQuestion(
                        TriageNode(id: "shelter-cold-tree-q", question: "What do you have?", options: [
                            TriageOption(id: "shelter-cold-tarp", label: "Tarp / Poncho", icon: "square.fill", destination: .technique("shelter-tarp-leanto")),
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
                                    TriageOption(id: "shelter-hot-single", label: "Single Layer Only", icon: "square.fill", destination: .technique("shelter-tarp-diamond"))
                                ])
                            )),
                            TriageOption(id: "shelter-hot-dig", label: "Can Dig Trench", icon: "arrow.down.circle.fill", destination: .technique("shelter-desert-trench")),
                            TriageOption(id: "shelter-hot-vehicle", label: "Near Vehicle", icon: "car.fill", destination: .technique("shelter-vehicle"))
                        ])
                    )),
                    TriageOption(id: "shelter-hot-cold-night", label: "Warmth (Night)", icon: "moon.fill", destination: .nextQuestion(
                        TriageNode(id: "shelter-hot-night-q", question: "What can you use for insulation?", options: [
                            TriageOption(id: "shelter-hot-sand", label: "Sand / Rocks (Thermal Mass)", icon: "triangle.fill", destination: .technique("shelter-thermal-mass")),
                            TriageOption(id: "shelter-hot-debris", label: "Vegetation / Debris", icon: "leaf.fill", destination: .technique("shelter-debris-hut")),
                            TriageOption(id: "shelter-hot-mylar", label: "Space Blanket / Plastic", icon: "sparkle", destination: .technique("shelter-mylar-wrap"))
                        ])
                    )),
                    TriageOption(id: "shelter-hot-wind", label: "Wind Protection", icon: "wind", destination: .nextQuestion(
                        TriageNode(id: "shelter-hot-wind-q", question: "What's available for windbreak?", options: [
                            TriageOption(id: "shelter-hot-rock", label: "Rock Face / Overhang", icon: "triangle.fill", destination: .technique("shelter-rock-overhang")),
                            TriageOption(id: "shelter-hot-wall", label: "Can Stack Rocks", icon: "square.stack.fill", destination: .technique("shelter-rock-windbreak")),
                            TriageOption(id: "shelter-hot-ditch", label: "Dig Depression", icon: "arrow.down.circle.fill", destination: .technique("shelter-desert-trench"))
                        ])
                    ))
                ])
            )),

            // ── TROPICAL / WET ──
            TriageOption(id: "shelter-wet", label: "Tropical / Jungle", icon: "drop.fill", destination: .nextQuestion(
                TriageNode(id: "shelter-wet-q", question: "What is the main threat?", options: [
                    TriageOption(id: "shelter-wet-rain", label: "Heavy Rain", icon: "cloud.rain.fill", destination: .nextQuestion(
                        TriageNode(id: "shelter-wet-rain-q", question: "What materials do you have?", options: [
                            TriageOption(id: "shelter-wet-rain-tarp", label: "Tarp / Poncho", icon: "square.fill", destination: .technique("shelter-tarp-aframe")),
                            TriageOption(id: "shelter-wet-rain-leaves", label: "Large Leaves / Palm Fronds", icon: "leaf.fill", destination: .technique("shelter-raised-platform")),
                            TriageOption(id: "shelter-wet-rain-nothing", label: "Nothing", icon: "xmark.circle.fill", destination: .technique("shelter-debris-hut"))
                        ])
                    )),
                    TriageOption(id: "shelter-wet-ground", label: "Ground Moisture / Bugs", icon: "ant.fill", destination: .nextQuestion(
                        TriageNode(id: "shelter-wet-ground-q", question: "How do you want to get off the ground?", options: [
                            TriageOption(id: "shelter-wet-hammock", label: "Hammock (Have Material)", icon: "figure.mind.and.body", destination: .technique("shelter-hammock")),
                            TriageOption(id: "shelter-wet-platform", label: "Build Raised Platform", icon: "rectangle.stack.fill", destination: .technique("shelter-raised-platform")),
                            TriageOption(id: "shelter-wet-swamp", label: "Swamp Bed (Quick)", icon: "bed.double.fill", destination: .technique("shelter-swamp-bed"))
                        ])
                    )),
                    TriageOption(id: "shelter-wet-night", label: "Sleeping Setup", icon: "bed.double.fill", destination: .nextQuestion(
                        TriageNode(id: "shelter-wet-sleep-q", question: "What bothers you most?", options: [
                            TriageOption(id: "shelter-wet-sleep-wet", label: "Wet Ground", icon: "drop.fill", destination: .technique("shelter-swamp-bed")),
                            TriageOption(id: "shelter-wet-sleep-bugs", label: "Insects / Creatures", icon: "ant.fill", destination: .technique("shelter-hammock")),
                            TriageOption(id: "shelter-wet-sleep-cold", label: "Getting Cold at Night", icon: "thermometer.snowflake", destination: .technique("shelter-debris-hut"))
                        ])
                    ))
                ])
            )),

            // ── URBAN / DISASTER ──
            TriageOption(id: "shelter-urban", label: "Urban / After Disaster", icon: "building.2.fill", destination: .nextQuestion(
                TriageNode(id: "shelter-urban-q", question: "What's your situation?", options: [
                    TriageOption(id: "shelter-urban-building", label: "Building Damaged", icon: "building.2.fill", destination: .technique("shelter-urban-debris")),
                    TriageOption(id: "shelter-urban-vehicle", label: "Vehicle Available", icon: "car.fill", destination: .technique("shelter-vehicle")),
                    TriageOption(id: "shelter-urban-nothing", label: "Outdoors — No Structure", icon: "xmark.circle.fill", destination: .nextQuestion(
                        TriageNode(id: "shelter-urban-out-q", question: "What can you find?", options: [
                            TriageOption(id: "shelter-urban-card", label: "Cardboard / Plastic", icon: "doc.fill", destination: .technique("shelter-emergency-bivy")),
                            TriageOption(id: "shelter-urban-tarp", label: "Tarp / Sheet", icon: "square.fill", destination: .technique("shelter-tarp-leanto")),
                            TriageOption(id: "shelter-urban-zero", label: "Nothing", icon: "xmark.circle.fill", destination: .technique("shelter-mylar-wrap"))
                        ])
                    ))
                ])
            ))
        ])
    }


    // =========================================================================
    // MARK: - ANIMAL ENCOUNTER (4 levels deep)
    // =========================================================================
    private func buildAnimalTriage() -> TriageNode {
        TriageNode(id: "animal-root", question: "What animal?", options: [

            // --- BEARS ---
            TriageOption(id: "an-bear", label: "Bear", icon: "pawprint.fill", destination: .nextQuestion(
                TriageNode(id: "an-bear-q", question: "What type / color?", options: [
                    TriageOption(id: "an-bear-black", label: "Black Bear", icon: "pawprint.fill", destination: .nextQuestion(
                        TriageNode(id: "an-bear-black-q", question: "Has it seen you?", options: [
                            TriageOption(id: "an-black-seen", label: "Yes — Stand Ground", icon: "eye.fill", destination: .technique("env-bear-black")),
                            TriageOption(id: "an-black-unseen", label: "No — Back Away", icon: "eye.slash.fill", destination: .technique("env-bear-black"))
                        ])
                    )),
                    TriageOption(id: "an-bear-grizzly", label: "Grizzly / Brown Bear", icon: "pawprint.fill", destination: .nextQuestion(
                        TriageNode(id: "an-bear-griz-q", question: "Is it attacking?", options: [
                            TriageOption(id: "an-griz-attack", label: "Yes — Play Dead", icon: "exclamationmark.triangle.fill", destination: .technique("env-bear-grizzly")),
                            TriageOption(id: "an-griz-calm", label: "No — Back Away Slowly", icon: "figure.walk", destination: .technique("env-bear-grizzly"))
                        ])
                    )),
                    TriageOption(id: "an-bear-polar", label: "Polar Bear", icon: "snowflake", destination: .technique("env-bear-polar"))
                ])
            )),

            // --- INSECTS / STINGS ---
            TriageOption(id: "an-insect", label: "Insect Bite / Sting", icon: "ant.fill", destination: .nextQuestion(
                TriageNode(id: "an-insect-q", question: "Trouble breathing?", options: [
                    TriageOption(id: "an-insect-anaph", label: "Yes — Swelling / Wheezing", icon: "exclamationmark.triangle.fill", destination: .technique("firstaid-anaphylaxis")),
                    TriageOption(id: "an-insect-norm", label: "No — Just Pain/Itch", icon: "checkmark.circle", destination: .technique("firstaid-sting-treat"))
                ])
            )),

            // --- SNAKES ---
            TriageOption(id: "an-snake", label: "Snake", icon: "scribble.variable", destination: .nextQuestion(
                TriageNode(id: "an-snake-q", question: "Did it bite you?", options: [
                    TriageOption(id: "an-snake-bite", label: "Yes — bitten", icon: "exclamationmark.triangle.fill", destination: .technique("firstaid-snakebite")),
                    TriageOption(id: "an-snake-see", label: "No — Just saw it", icon: "eye.fill", destination: .nextQuestion(
                         TriageNode(id: "an-snake-id", question: "Head shape?", options: [
                            TriageOption(id: "an-snake-tri", label: "Triangular / Diamond (Venomous)", icon: "triangle.fill", destination: .technique("firstaid-snakebite")),
                            TriageOption(id: "an-snake-round", label: "Round / Oval (Likely Safe)", icon: "circle.fill", destination: .technique("firstaid-snakebite")), // Still avoid
                            TriageOption(id: "an-snake-unk", label: "Unknown / Hidden", icon: "questionmark.circle", destination: .technique("firstaid-snakebite"))
                         ])
                    ))
                ])
            )),

            // --- CATS / WOLVES ---
            TriageOption(id: "an-predator", label: "Cougar / Wolf / Coyote", icon: "cat.fill", destination: .nextQuestion(
                TriageNode(id: "an-pred-q", question: "What animal?", options: [
                    TriageOption(id: "an-cougar", label: "Mountain Lion / Cougar", icon: "cat.fill", destination: .technique("env-cougar")),
                    TriageOption(id: "an-wolf", label: "Wolf Pack", icon: "pawprint.fill", destination: .technique("env-wolf"))
                ])
            )),

            // --- HERBIVORES (MOOSE/ELK) ---
            TriageOption(id: "an-moose", label: "Moose / Elk / Bison", icon: "ant.fill", destination: .technique("env-moose-elk")),

            // --- REPTILES ---
            TriageOption(id: "an-reptile", label: "Snake / Alligator", icon: "scribble.variable", destination: .nextQuestion(
                TriageNode(id: "an-rep-q", question: "Situation?", options: [
                    TriageOption(id: "an-snake-bite", label: "Bitten by Snake", icon: "exclamationmark.triangle.fill", destination: .technique("firstaid-snake-bite")),
                    TriageOption(id: "an-snake-encounter", label: "Snake Nearby", icon: "eye.fill", destination: .technique("firstaid-snake-bite")),
                    TriageOption(id: "an-gator", label: "Alligator / Croc", icon: "water.waves", destination: .technique("env-alligator"))
                ])
            )),

            // --- BUGS ---
            TriageOption(id: "an-bugs", label: "Insects / Spiders / Scorpions", icon: "ant.fill", destination: .nextQuestion(
                TriageNode(id: "an-bug-q", question: "What happened?", options: [
                    TriageOption(id: "an-bee", label: "Stung (Bee/Wasp)", icon: "ant.fill", destination: .technique("firstaid-allergic-reaction")),
                    TriageOption(id: "an-spider", label: "Bitten (Spider/Scorpion)", icon: "exclamationmark.triangle.fill", destination: .technique("firstaid-spider-bite")),
                    TriageOption(id: "an-tick", label: "Tick Attached", icon: "circle.fill", destination: .technique("env-tick-removal"))
                ])
            )),

            // --- MARINE ---
            TriageOption(id: "an-marine", label: "Shark / Jellyfish", icon: "fish.fill", destination: .nextQuestion(
                TriageNode(id: "an-marine-q", question: "What animal?", options: [
                    TriageOption(id: "an-shark", label: "Shark", icon: "fish.fill", destination: .technique("env-shark")),
                    TriageOption(id: "an-jelly", label: "Jellyfish Sting", icon: "drop.fill", destination: .technique("env-jellyfish"))
                ])
            ))
        ])
    }

    // =========================================================================
    // MARK: - IN WATER (4 levels deep)
    // =========================================================================
    private func buildInWaterTriage() -> TriageNode {
        TriageNode(id: "water-em-root", question: "What is the emergency?", options: [

            // --- DROWNING / SWIMMING ---
            TriageOption(id: "wet-swim", label: "Struggling to Swim", icon: "figure.pool.swim", destination: .nextQuestion(
                TriageNode(id: "wet-swim-q", question: "Why?", options: [
                    TriageOption(id: "wet-exhaust", label: "Exhausted", icon: "battery.0", destination: .nextQuestion(
                        TriageNode(id: "wet-exhaust-q", question: "Can you float?", options: [
                            TriageOption(id: "wet-exhaust-float", label: "Yes — Can Float on Back", icon: "checkmark.circle", destination: .technique("rescue-self-rescue")),
                            TriageOption(id: "wet-exhaust-sinking", label: "No — Going Under", icon: "exclamationmark.triangle.fill", destination: .technique("rescue-improvised-flotation")),
                            TriageOption(id: "wet-exhaust-close", label: "Close to Shore / Object", icon: "arrow.right", destination: .technique("rescue-self-rescue"))
                        ])
                    )),
                    TriageOption(id: "wet-cramp", label: "Muscle Cramp", icon: "bolt.fill", destination: .nextQuestion(
                        TriageNode(id: "wet-cramp-q", question: "Which body part?", options: [
                            TriageOption(id: "wet-cramp-leg", label: "Leg / Calf", icon: "figure.walk", destination: .technique("rescue-self-rescue")),
                            TriageOption(id: "wet-cramp-foot", label: "Foot / Toes", icon: "shoeprint.fill", destination: .technique("rescue-self-rescue")),
                            TriageOption(id: "wet-cramp-side", label: "Side / Abdomen", icon: "figure.arms.open", destination: .technique("rescue-self-rescue"))
                        ])
                    )),
                    TriageOption(id: "wet-drown-rescue", label: "Rescuing Drowning Person", icon: "person.2.fill", destination: .nextQuestion(
                        TriageNode(id: "wet-drown-how", question: "How far away are they?", options: [
                            TriageOption(id: "wet-drown-near", label: "Within Arm's Reach", icon: "hand.raised.fill", destination: .technique("rescue-throw-bag")),
                            TriageOption(id: "wet-drown-throw", label: "Can Throw Rope / Object", icon: "arrow.right", destination: .technique("rescue-throw-bag")),
                            TriageOption(id: "wet-drown-far", label: "Far — Need to Swim Out", icon: "figure.pool.swim", destination: .technique("rescue-improvised-flotation")),
                            TriageOption(id: "wet-drown-child", label: "Child / Non-Swimmer", icon: "exclamationmark.triangle.fill", destination: .technique("rescue-throw-bag"))
                        ])
                    ))
                ])
            )),

            // --- COLD WATER ---
            TriageOption(id: "wet-cold", label: "Cold Water Immersion", icon: "snowflake", destination: .nextQuestion(
                TriageNode(id: "wet-cold-q", question: "How long in water?", options: [
                    TriageOption(id: "wet-shock", label: "Just Fell In (Cold Shock)", icon: "exclamationmark.triangle.fill", destination: .nextQuestion(
                        TriageNode(id: "wet-shock-q", question: "Can you grab something?", options: [
                            TriageOption(id: "wet-shock-grab", label: "Yes — Ledge / Boat / Dock", icon: "hand.raised.fill", destination: .technique("rescue-cold-water-self")),
                            TriageOption(id: "wet-shock-nothing", label: "No — Open Water", icon: "xmark.circle.fill", destination: .nextQuestion(
                                TriageNode(id: "wet-shock-float-q", question: "Focus: Control breathing first!", options: [
                                    TriageOption(id: "wet-shock-float", label: "Can Float / Tread Water", icon: "checkmark.circle", destination: .technique("rescue-cold-water-self")),
                                    TriageOption(id: "wet-shock-pfd", label: "Have Life Jacket / PFD", icon: "shield.fill", destination: .technique("rescue-cold-water-self")),
                                    TriageOption(id: "wet-shock-improv", label: "Need Improvised Flotation", icon: "bag.fill", destination: .technique("rescue-improvised-flotation"))
                                ])
                            ))
                        ])
                    )),
                    TriageOption(id: "wet-hypo", label: "Been In a While", icon: "thermometer.snowflake", destination: .nextQuestion(
                        TriageNode(id: "wet-hypo-q", question: "Symptoms?", options: [
                            TriageOption(id: "wet-hypo-shiver", label: "Shivering Violently", icon: "wind", destination: .technique("firstaid-hypothermia")),
                            TriageOption(id: "wet-hypo-numb", label: "Going Numb / Losing Grip", icon: "hand.raised.fill", destination: .technique("rescue-cold-water-self")),
                            TriageOption(id: "wet-hypo-confused", label: "Confused / Drowsy", icon: "brain.head.profile", destination: .technique("firstaid-hypothermia"))
                        ])
                    )),
                    TriageOption(id: "wet-ice", label: "Fell Through Ice", icon: "snowflake", destination: .nextQuestion(
                        TriageNode(id: "wet-ice-q", question: "Can you reach solid ice?", options: [
                            TriageOption(id: "wet-ice-reach", label: "Yes — Can Touch Edge", icon: "hand.raised.fill", destination: .technique("env-ice-fall-through")),
                            TriageOption(id: "wet-ice-far", label: "No — Away From Edge", icon: "xmark.circle.fill", destination: .technique("env-ice-fall-through")),
                            TriageOption(id: "wet-ice-rescue", label: "Rescuing Someone on Ice", icon: "person.2.fill", destination: .technique("env-ice-fall-through"))
                        ])
                    ))
                ])
            )),

            // --- CURRENTS ---
            TriageOption(id: "wet-current", label: "Caught in Current", icon: "water.waves", destination: .nextQuestion(
                TriageNode(id: "wet-curr-q", question: "Where?", options: [
                    TriageOption(id: "wet-rip", label: "Ocean Rip Current", icon: "water.waves", destination: .nextQuestion(
                        TriageNode(id: "wet-rip-q", question: "How strong?", options: [
                            TriageOption(id: "wet-rip-swim", label: "Can Still Swim Sideways", icon: "arrow.left.and.right", destination: .technique("env-rip-current")),
                            TriageOption(id: "wet-rip-strong", label: "Too Strong — Being Pulled Out", icon: "exclamationmark.triangle.fill", destination: .technique("env-rip-current")),
                            TriageOption(id: "wet-rip-tired", label: "Exhausted From Fighting", icon: "battery.0", destination: .technique("env-rip-current"))
                        ])
                    )),
                    TriageOption(id: "wet-river", label: "River Current", icon: "arrow.right", destination: .nextQuestion(
                        TriageNode(id: "wet-river-q", question: "What's ahead?", options: [
                            TriageOption(id: "wet-river-rapids", label: "Rapids / Rocks Ahead", icon: "exclamationmark.triangle.fill", destination: .technique("rescue-river-self")),
                            TriageOption(id: "wet-river-calm", label: "Current but No Rapids", icon: "water.waves", destination: .technique("rescue-river-self")),
                            TriageOption(id: "wet-river-strainer", label: "Fallen Tree / Strainer", icon: "tree.fill", destination: .technique("rescue-river-self"))
                        ])
                    ))
                ])
            )),

            // --- BOAT ---
            TriageOption(id: "wet-boat", label: "Boat Capsized / Sinking", icon: "sailboat.fill", destination: .nextQuestion(
                TriageNode(id: "wet-boat-q", question: "What's the situation?", options: [
                    TriageOption(id: "wet-boat-capsize", label: "Capsized — Can Cling to Hull", icon: "sailboat.fill", destination: .technique("rescue-cold-water-self")),
                    TriageOption(id: "wet-boat-sinking", label: "Sinking — Abandoning", icon: "exclamationmark.triangle.fill", destination: .nextQuestion(
                        TriageNode(id: "wet-boat-sink-q", question: "Do you have a life jacket?", options: [
                            TriageOption(id: "wet-boat-pfd", label: "Yes — PFD / Life Jacket", icon: "shield.fill", destination: .technique("rescue-cold-water-self")),
                            TriageOption(id: "wet-boat-nopfd", label: "No — Need Flotation", icon: "xmark.circle.fill", destination: .technique("rescue-improvised-flotation"))
                        ])
                    )),
                    TriageOption(id: "wet-boat-shore", label: "Near Shore — Can I Swim?", icon: "figure.pool.swim", destination: .technique("rescue-self-rescue")),
                    TriageOption(id: "wet-boat-cold", label: "Cold Water — Hypothermia Risk", icon: "thermometer.snowflake", destination: .technique("rescue-cold-water-self")),
                    TriageOption(id: "wet-boat-signal", label: "Need to Signal for Help", icon: "antenna.radiowaves.left.and.right", destination: .techniqueList(["rescue-signal-mirror", "rescue-whistle", "rescue-phone-emergency"]))
                ])
            ))
        ])
    }
}
