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
                                    TriageOption(id: "cold-mild", label: "Shivering, Still Alert", icon: "exclamationmark.circle", destination: .technique("firstaid-hypothermia")),
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
                    TriageOption(id: "fire-ferro-good", label: "Birch Bark / Lint / Dry Grass", icon: "leaf.fill", destination: .technique("fire-ferrorod")),
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
                                                TriageNode(id: "lost-sun-method", question: "Choose a method:", options: [
                                                    TriageOption(id: "lost-watch", label: "Have Analog Watch", icon: "clock.fill", destination: .technique("nav-watch-compass")),
                                                    TriageOption(id: "lost-stick", label: "Stick + 20 Minutes", icon: "pencil", destination: .technique("nav-stick-shadow")),
                                                    TriageOption(id: "lost-quick", label: "Quick Sun Estimate", icon: "location.fill", destination: .technique("nav-sun-position"))
                                                ])
                                            )),
                                            TriageOption(id: "lost-overcast", label: "Overcast / Can't See Sun", icon: "cloud.fill", destination: .technique("nav-natural-indicators"))
                                        ])
                                    )),

                                    // Nighttime
                                    TriageOption(id: "lost-night", label: "Nighttime", icon: "moon.fill", destination: .nextQuestion(
                                        TriageNode(id: "lost-stars", question: "Can you see stars or moon?", options: [
                                            TriageOption(id: "lost-stars-n", label: "Stars — Northern Hemisphere", icon: "star.fill", destination: .technique("nav-north-star")),
                                            TriageOption(id: "lost-stars-s", label: "Stars — Southern Hemisphere", icon: "star.fill", destination: .technique("nav-southern-cross")),
                                            TriageOption(id: "lost-star-any", label: "Stars — Not Sure Which Hemisphere", icon: "sparkles", destination: .technique("nav-star-movement")),
                                            TriageOption(id: "lost-moon", label: "Moon Visible (Crescent)", icon: "moon.fill", destination: .technique("nav-moon-navigation")),
                                            TriageOption(id: "lost-no-sky", label: "Cloudy — No Stars/Moon", icon: "cloud.fill", destination: .technique("nav-lost-procedure"))
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
                                    TriageOption(id: "trapped-open-ground", label: "Open Ground — Make Ground Signal", icon: "square.fill", destination: .technique("rescue-ground-signal")),
                                    TriageOption(id: "trapped-bright", label: "Bright Clothing to Display", icon: "tshirt.fill", destination: .technique("rescue-ground-signal")),
                                    TriageOption(id: "trapped-heli", label: "Helicopter Might Come", icon: "airplane", destination: .technique("rescue-helicopter-lz")),
                                    TriageOption(id: "trapped-sos", label: "Write SOS Large on Ground", icon: "textformat", destination: .technique("rescue-sos"))
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
                            TriageOption(id: "trapped-bleeding", label: "Bleeding Heavily", icon: "drop.fill", destination: .nextQuestion(
                                TriageNode(id: "trapped-bleed-q", question: "Where is the bleeding?", options: [
                                    TriageOption(id: "trapped-bleed-limb", label: "Arm or Leg", icon: "figure.arms.open", destination: .technique("firstaid-tourniquet")),
                                    TriageOption(id: "trapped-bleed-torso", label: "Torso / Chest", icon: "heart.fill", destination: .technique("firstaid-pressure-bandage")),
                                    TriageOption(id: "trapped-bleed-head", label: "Head / Face", icon: "brain.head.profile", destination: .technique("firstaid-wound-cleaning")),
                                    TriageOption(id: "trapped-bleed-nose", label: "Nosebleed", icon: "nose.fill", destination: .technique("firstaid-nosebleed"))
                                ])
                            )),
                            TriageOption(id: "trapped-broken", label: "Possible Fracture / Dislocation", icon: "bandage.fill", destination: .nextQuestion(
                                TriageNode(id: "trapped-fracture-q", question: "Which body part?", options: [
                                    TriageOption(id: "trapped-frac-arm", label: "Arm / Wrist", icon: "figure.arms.open", destination: .technique("firstaid-arm-splint")),
                                    TriageOption(id: "trapped-frac-leg", label: "Leg / Ankle", icon: "figure.walk", destination: .technique("firstaid-leg-splint")),
                                    TriageOption(id: "trapped-frac-spine", label: "Back / Spine (Don't Move!)", icon: "exclamationmark.triangle.fill", destination: .technique("firstaid-spinal-immobilization")),
                                    TriageOption(id: "trapped-dislocate", label: "Joint Popped Out", icon: "arrow.left.arrow.right", destination: .technique("firstaid-dislocated-joint"))
                                ])
                            )),
                            TriageOption(id: "trapped-impaled", label: "Impaled Object", icon: "exclamationmark.triangle.fill", destination: .technique("firstaid-impaled-object")),
                            TriageOption(id: "trapped-crush", label: "Crushed / Pinned Under Weight", icon: "rectangle.compress.vertical", destination: .technique("firstaid-crush-injury")),
                            TriageOption(id: "trapped-shock", label: "Shock Symptoms", icon: "heart.fill", destination: .technique("firstaid-shock")),
                            TriageOption(id: "trapped-burn", label: "Burn Injury", icon: "flame.fill", destination: .technique("firstaid-burn")),
                            TriageOption(id: "trapped-head-inj", label: "Head Injury / Concussion", icon: "brain.head.profile", destination: .technique("firstaid-spinal-immobilization")),
                            TriageOption(id: "trapped-heart", label: "Chest Pain / Heart Attack Signs", icon: "heart.fill", destination: .technique("firstaid-heart-attack")),
                            TriageOption(id: "trapped-stroke", label: "Face Drooping / Slurred Speech", icon: "brain.head.profile", destination: .technique("firstaid-stroke")),
                            TriageOption(id: "trapped-breathing", label: "Can't Breathe / Asthma", icon: "lungs.fill", destination: .technique("firstaid-asthma")),
                            TriageOption(id: "trapped-hypervent", label: "Hyperventilating / Panic", icon: "wind", destination: .technique("firstaid-hyperventilation"))
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

            TriageOption(id: "dis-earthquake", label: "Earthquake", icon: "waveform.path.ecg", destination: .nextQuestion(
                TriageNode(id: "dis-eq-q", question: "Where are you?", options: [
                    TriageOption(id: "dis-eq-indoor", label: "Indoors", icon: "building.2.fill", destination: .technique("env-earthquake")),
                    TriageOption(id: "dis-eq-outdoor", label: "Outdoors", icon: "tree.fill", destination: .technique("env-earthquake")),
                    TriageOption(id: "dis-eq-after", label: "Earthquake Over — Now What?", icon: "checkmark.circle", destination: .nextQuestion(
                        TriageNode(id: "dis-eq-after-q", question: "What's your situation?", options: [
                            TriageOption(id: "dis-eq-injured", label: "Injured", icon: "cross.case.fill", destination: .techniqueList(["firstaid-wound-cleaning", "firstaid-crush-injury", "firstaid-shock"])),
                            TriageOption(id: "dis-eq-trapped", label: "Trapped Under Debris", icon: "rectangle.compress.vertical", destination: .technique("rescue-morse-code")),
                            TriageOption(id: "dis-eq-safe", label: "Safe — Need Shelter", icon: "house.fill", destination: .techniqueList(["shelter-poncho", "shelter-vehicle", "shelter-emergency-bivy"]))
                        ])
                    ))
                ])
            )),

            TriageOption(id: "dis-tornado", label: "Tornado", icon: "tornado", destination: .nextQuestion(
                TriageNode(id: "dis-tor-q", question: "Where are you?", options: [
                    TriageOption(id: "dis-tor-building", label: "In a Building", icon: "building.2.fill", destination: .technique("env-tornado")),
                    TriageOption(id: "dis-tor-vehicle", label: "In a Vehicle", icon: "car.fill", destination: .technique("env-tornado")),
                    TriageOption(id: "dis-tor-outdoor", label: "Open Outdoors", icon: "figure.walk", destination: .technique("env-tornado"))
                ])
            )),

            TriageOption(id: "dis-wildfire", label: "Wildfire", icon: "flame.fill", destination: .nextQuestion(
                TriageNode(id: "dis-fire-q", question: "How close is the fire?", options: [
                    TriageOption(id: "dis-fire-far", label: "Visible but Far — Can Escape", icon: "arrow.right", destination: .technique("env-wildfire")),
                    TriageOption(id: "dis-fire-near", label: "Close — Smoke Heavy", icon: "smoke.fill", destination: .technique("env-wildfire")),
                    TriageOption(id: "dis-fire-surrounded", label: "Surrounded / Trapped", icon: "xmark.circle.fill", destination: .technique("env-wildfire"))
                ])
            )),

            TriageOption(id: "dis-avalanche", label: "Avalanche", icon: "snowflake", destination: .nextQuestion(
                TriageNode(id: "dis-aval-q", question: "What's your situation?", options: [
                    TriageOption(id: "dis-aval-imminent", label: "Avalanche Starting — Act NOW", icon: "exclamationmark.triangle.fill", destination: .technique("env-avalanche")),
                    TriageOption(id: "dis-aval-buried", label: "Buried Under Snow", icon: "snowflake", destination: .technique("env-avalanche")),
                    TriageOption(id: "dis-aval-after", label: "After — Need to Find Someone", icon: "person.fill.questionmark", destination: .technique("env-avalanche"))
                ])
            )),

            TriageOption(id: "dis-quicksand", label: "Quicksand / Sinking", icon: "arrow.down.circle.fill", destination: .technique("env-quicksand")),

            TriageOption(id: "dis-lightning", label: "Lightning Storm", icon: "bolt.fill", destination: .nextQuestion(
                TriageNode(id: "dis-light-q", question: "Where are you?", options: [
                    TriageOption(id: "dis-light-ridge", label: "High Ground / Ridge", icon: "mountain.2.fill", destination: .technique("env-lightning")),
                    TriageOption(id: "dis-light-open", label: "Open Field", icon: "figure.walk", destination: .technique("env-lightning")),
                    TriageOption(id: "dis-light-forest", label: "In Forest", icon: "tree.fill", destination: .technique("env-lightning")),
                    TriageOption(id: "dis-light-struck", label: "Someone Was Struck", icon: "bolt.heart.fill", destination: .techniqueList(["env-lightning", "firstaid-cpr"]))
                ])
            ))
        ])
    }
}
