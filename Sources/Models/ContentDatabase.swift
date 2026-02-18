import Foundation

// Helper for JSON Decoding
struct DomainContent: Codable {
    let domain: String
    let domainDisplayName: String
    let techniques: [Technique]
    let articles: [Article]
}

struct GlossaryContent: Codable {
    let terms: [GlossaryTerm]
}

struct GlossaryTerm: Identifiable, Codable {
    var id: String { term }
    let term: String
    let definition: String
}

class ContentDatabase: ObservableObject {
    static let shared = ContentDatabase()
    
    @Published var techniques: [Technique] = []
    @Published var articles: [Article] = []
    @Published var glossaryTerms: [GlossaryTerm] = []
    @Published var triageTrees: [EmergencySituation: TriageNode] = [:]
    


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
            "environments", "tools",
            "advanced_firstaid", "advanced_tools", "advanced_environments",
            "expanded_firstaid", "expanded_environments",
            "hacks_general", "rebuilding_civilization", // Phase 5 content
            "missing_firstaid", "missing_environments", "missing_psychology", "missing_shelter" // Supplemental content for new emergencies
        ]
        for domain in domains {
            loadDomainFromJSON(fileName: domain)
        }
        loadGlossary()
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
            NSLog("REVIVE: Failed to decode %@.json: %@", fileName, String(describing: error))
        }
    }
    
    func getTechniques(for domain: SurvivalDomain) -> [Technique] {
        techniques.filter { $0.domain == domain }
    }
    
    func getArticles(for domain: SurvivalDomain) -> [Article] {
        articles.filter { $0.domain == domain }
    }

    private func loadGlossary() {
        guard let url = Bundle.main.url(forResource: "glossary", withExtension: "json") else { return }
        do {
            let data = try Data(contentsOf: url)
            let content = try JSONDecoder().decode(GlossaryContent.self, from: data)
            self.glossaryTerms = content.terms.sorted { $0.term < $1.term }
        } catch {
            print("Failed to load glossary: \(error)")
        }
    }

    // MARK: - Search
    func search(query: String) -> [Technique] {
        let lowerQuery = query.localizedLowercase
        return techniques.filter { technique in
            technique.name.localizedLowercase.contains(lowerQuery) ||
            technique.subtitle.localizedLowercase.contains(lowerQuery) ||
            technique.category.localizedLowercase.contains(lowerQuery) ||
            technique.domain.displayName.localizedLowercase.contains(lowerQuery)
        }
    }

    // MARK: - Helper
    func getTechnique(id: String) -> Technique? {
        return techniques.first { $0.id == id }
    }

    // MARK: - Inventory Logic
    func findTechniques(forItems items: Set<String>) -> [Technique] {
        if items.isEmpty { return [] }
        
        // rudimentary keyword matching
        // In a real app, we'd have a 'materials' array on Technique.
        // Here we scan steps and description for the item name.
        
        return techniques.filter { technique in
            for item in items {
                let lowerItem = item.localizedLowercase
                // Check title/subtitle
                if technique.name.localizedLowercase.contains(lowerItem) { return true }
                if technique.subtitle.localizedLowercase.contains(lowerItem) { return true }
                
                // Check steps
                for step in technique.steps {
                    if step.instruction.localizedLowercase.contains(lowerItem) { return true }
                    if step.helpDetail.localizedLowercase.contains(lowerItem) { return true }
                }
            }
            return false
        }
    }

    // MARK: - Triage Builders
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
        triageTrees[.hurt] = buildHurtTriage()
        triageTrees[.extremeHeat] = buildHeatTriage()
        triageTrees[.humanThreat] = buildHumanThreatTriage()
        triageTrees[.vehicleEmergency] = buildVehicleTriage()
        triageTrees[.chemicalExposure] = buildChemicalTriage()
    }

    // =========================================================================
    // MARK: - FIRST AID / HURT (New - Phase 2)
    // =========================================================================
    private func buildHurtTriage() -> TriageNode {
        TriageNode(id: "hurt-root", question: "What is the primary injury?", options: [

            // 1. BLEEDING
            TriageOption(id: "hurt-bleeding", label: "Bleeding (Severe)", icon: "drop.fill", destination: .nextQuestion(
                TriageNode(id: "hurt-bleed-q", question: "Is it life-threatening?", options: [
                    TriageOption(id: "bleed-limb", label: "Spurting from Arm/Leg", icon: "exclamationmark.triangle.fill", destination: .technique("firstaid-tourniquet")),
                    TriageOption(id: "bleed-torso", label: "Chest / Abdomen / Neck", icon: "shield.fill", destination: .technique("firstaid-wound-packing")), // Orphan
                    TriageOption(id: "bleed-clot", label: "Won't Stop Bleeding", icon: "bandage.fill", destination: .technique("firstaid-pressure-bandage"))
                ])
            )),

            // 2.5 HEAD INJURY
            TriageOption(id: "hurt-head", label: "Head / Eye / Mouth", icon: "brain.head.profile", destination: .nextQuestion(
                TriageNode(id: "hurt-head-q", question: "What is the issue?", options: [
                    TriageOption(id: "head-concussion", label: "Hit Head / Dizziness", icon: "brain.head.profile", destination: .technique("firstaid-concussion")),
                    TriageOption(id: "head-tooth", label: "Toothache / Broken Tooth", icon: "mouth.fill", destination: .technique("firstaid-tooth-emergency")), // Added orphan
                    TriageOption(id: "head-eye", label: "Eye Injury", icon: "eye.fill", destination: .technique("firstaid-eye-injury"))
                ])
            )),

            // 2. BREATHING / CHOKING
            TriageOption(id: "hurt-airway", label: "Breathing / Choking", icon: "lungs.fill", destination: .nextQuestion(
                TriageNode(id: "hurt-choke-q", question: "Is the airway blocked?", options: [
                    TriageOption(id: "choke-adult", label: "Choking (Adult/Child)", icon: "figure.stand", destination: .technique("firstaid-heimlich")), // Orphan
                    TriageOption(id: "choke-infant", label: "Choking (Infant)", icon: "figure.baby", destination: .technique("firstaid-choking-infant")),
                    TriageOption(id: "choke-uncon", label: "Unconscious / No Breathing", icon: "heart.fill", destination: .technique("firstaid-cpr"))
                ])
            )),

            // 3. FRACTURES / SPRAINS
            TriageOption(id: "hurt-bone", label: "Broken Bone / Sprain", icon: "cross.case.fill", destination: .nextQuestion(
                TriageNode(id: "hurt-bone-q", question: "Which body part?", options: [
                    TriageOption(id: "bone-leg", label: "Upper Leg / Thigh (Femur)", icon: "figure.walk", destination: .technique("firstaid-femur-traction")), // Orphan
                    TriageOption(id: "bone-arm", label: "Arm / Wrist", icon: "hand.raised.fill", destination: .technique("firstaid-arm-splint")),
                    TriageOption(id: "bone-leg-lower", label: "Lower Leg / Ankle", icon: "figure.walk", destination: .technique("firstaid-leg-splint")),
                    TriageOption(id: "bone-neck", label: "Neck / Back (Spine)", icon: "figure.stand", destination: .technique("firstaid-spinal-immobilization"))
                ])
            )),

            // 4. BITES & STINGS
            TriageOption(id: "hurt-bite", label: "Bite or Sting", icon: "ant.fill", destination: .nextQuestion(
                TriageNode(id: "hurt-bite-q", question: "What bit you?", options: [
                    TriageOption(id: "bite-snake", label: "Snake Bite", icon: "exclamationmark.triangle.fill", destination: .technique("firstaid-snake-bite")),
                    TriageOption(id: "bite-spider", label: "Spider / Insect", icon: "ant.fill", destination: .technique("firstaid-spider-bite")),
                    TriageOption(id: "bite-tick", label: "Tick Attached", icon: "circle.circle.fill", destination: .technique("firstaid-tick-removal")),
                    TriageOption(id: "bite-animal", label: "Animal Bite", icon: "pawprint.fill", destination: .technique("firstaid-wound-cleaning"))
                ])
            )),
            
            // 5. POISON / SICKNESS
            TriageOption(id: "hurt-sick", label: "Poison / Sickness", icon: "flask.fill", destination: .nextQuestion(
                TriageNode(id: "hurt-sick-q", question: "What happened?", options: [
                    TriageOption(id: "sick-poison", label: "Swallowed Poison", icon: "skull.fill", destination: .techniqueList(["firstaid-poison", "firstaid-poison-response"])), // Added orphan
                    TriageOption(id: "sick-fever", label: "High Fever / Infection", icon: "thermometer", destination: .technique("firstaid-fever")), // Added orphan
                    TriageOption(id: "sick-allergic", label: "Allergic Reaction", icon: "allergens.fill", destination: .technique("firstaid-anaphylaxis")),
                    TriageOption(id: "sick-shock", label: "Shock (Pale, Clammy)", icon: "bolt.heart.fill", destination: .technique("firstaid-shock"))
                ])
            )),

            // 6. BURNS
            TriageOption(id: "hurt-burns", label: "Burns", icon: "flame", destination: .technique("firstaid-burn")),

            // 7. EXTREME / SURGICAL
            TriageOption(id: "hurt-extreme", label: "Extreme Measures (Last Resort)", icon: "exclamationmark.shield.fill", destination: .nextQuestion(
                TriageNode(id: "hurt-extreme-q", question: "What is the critical failure?", options: [
                    TriageOption(id: "ext-shoulder", label: "Dislocated Shoulder", icon: "figure.arms.open", destination: .technique("firstaid-shoulder-reduction")),
                    TriageOption(id: "ext-abscess", label: "Dental Abscess / Infection", icon: "mouth.fill", destination: .technique("firstaid-dental-abscess")),
                    TriageOption(id: "ext-suture", label: "Wound Needs Closing", icon: "pencil.line", destination: .technique("firstaid-superglue-suture")),
                    TriageOption(id: "ext-hack-tampon", label: "Tampon Dressing", icon: "capsule.fill", destination: .technique("firstaid-tampon-dressing")), // Phase 5
                    TriageOption(id: "ext-hack-tape", label: "Duct Tape Stitch", icon: "tape", destination: .technique("firstaid-duct-tape-butterfly")), // Phase 5
                    TriageOption(id: "ext-fishhook", label: "Fishhook Embedded", icon: "hook", destination: .technique("firstaid-fishhook-removal")),
                    TriageOption(id: "ext-amputate", label: "Trapped Limb (Amputation)", icon: "scissors", destination: .technique("firstaid-finger-amputation"))
                ])
            )),

            // 8. CHOKING (Additional)
            TriageOption(id: "hurt-choking-resp", label: "Choking Response Guide", icon: "person.fill.xmark", destination: .technique("firstaid-choking-response")),

            // 9. SEIZURE / CONVULSION
            TriageOption(id: "hurt-seizure", label: "Seizure / Convulsion", icon: "brain.fill", destination: .technique("firstaid-seizure")),

            // 9. NOSEBLEED
            TriageOption(id: "hurt-nosebleed", label: "Nosebleed", icon: "drop.fill", destination: .technique("firstaid-nosebleed")),

            // 10. HEAT ILLNESS / DEHYDRATION
            TriageOption(id: "hurt-heat", label: "Heat Illness / Dehydration", icon: "sun.max.fill", destination: .nextQuestion(
                TriageNode(id: "hurt-heat-q", question: "What are the symptoms?", options: [
                    TriageOption(id: "heat-cramps", label: "Cramps / Heavy Sweating", icon: "drop.fill", destination: .technique("firstaid-dehydration")),
                    TriageOption(id: "heat-exhaust", label: "Dizzy / Nauseous / Weak", icon: "exclamationmark.circle", destination: .technique("firstaid-dehydration")),
                    TriageOption(id: "heat-stroke-opt", label: "No Sweat / Hot Skin / Confused", icon: "exclamationmark.triangle.fill", destination: .technique("firstaid-heatstroke")),
                    TriageOption(id: "heat-sunburn", label: "Severe Sunburn", icon: "sun.max.fill", destination: .technique("firstaid-burn"))
                ])
            )),

            // 11. ALTITUDE SICKNESS
            TriageOption(id: "hurt-altitude", label: "Altitude Sickness", icon: "mountain.2.fill", destination: .nextQuestion(
                TriageNode(id: "hurt-alt-q", question: "How severe?", options: [
                    TriageOption(id: "alt-mild", label: "Headache / Nausea / Fatigue", icon: "exclamationmark.circle", destination: .technique("firstaid-altitude")),
                    TriageOption(id: "alt-moderate", label: "Severe Headache / Vomiting", icon: "exclamationmark.triangle.fill", destination: .technique("env-altitude-sickness")),
                    TriageOption(id: "alt-severe", label: "Confusion / Ataxia (HACE)", icon: "brain.head.profile", destination: .techniqueList(["env-mountain-altitude", "firstaid-altitude"])),
                    TriageOption(id: "alt-pulm", label: "Breathless at Rest (HAPE)", icon: "lungs.fill", destination: .techniqueList(["env-altitude-sickness", "firstaid-altitude"]))
                ])
            )),

            // 12. DIABETIC EMERGENCY
            TriageOption(id: "hurt-diabetic", label: "Diabetic Emergency", icon: "cross.vial.fill", destination: .technique("firstaid-diabetic-emergency")),

            // 13. MINOR / SURFACE INJURIES
            TriageOption(id: "hurt-minor", label: "Minor / Surface Injury", icon: "bandage.fill", destination: .nextQuestion(
                TriageNode(id: "hurt-minor-q", question: "What happened?", options: [
                    TriageOption(id: "minor-splinter", label: "Splinter / Foreign Object", icon: "pin.fill", destination: .technique("firstaid-splinter")),
                    TriageOption(id: "minor-blister", label: "Blister (Foot / Hand)", icon: "circle.fill", destination: .technique("firstaid-blister")),
                    TriageOption(id: "minor-sprain", label: "Sprain / Twisted Joint", icon: "bandage.fill", destination: .technique("firstaid-sprain")),
                    TriageOption(id: "minor-knee", label: "Knee Injury", icon: "figure.walk", destination: .technique("firstaid-knee-injury")),
                    TriageOption(id: "minor-bee", label: "Bee / Wasp Sting", icon: "ant.fill", destination: .technique("firstaid-bee-sting")),
                    TriageOption(id: "minor-dental", label: "Dental Pain / Broken Tooth", icon: "mouth.fill", destination: .technique("firstaid-dental"))
                ])
            )),

            // 14. PATIENT TRANSPORT
            TriageOption(id: "hurt-transport", label: "Moving an Injured Person", icon: "figure.2.arms.open", destination: .nextQuestion(
                TriageNode(id: "hurt-transport-q", question: "What do you need?", options: [
                    TriageOption(id: "transport-stretcher", label: "Improvised Stretcher", icon: "bed.double.fill", destination: .technique("firstaid-improvised-stretcher")),
                    TriageOption(id: "transport-litter", label: "Improvised Litter (Poles)", icon: "rectangle.fill", destination: .technique("rescue-improvised-litter")),
                    TriageOption(id: "transport-sling", label: "Arm Sling", icon: "hand.raised.fill", destination: .technique("firstaid-sling")),
                    TriageOption(id: "transport-nerve", label: "Check Nerve / Circulation", icon: "waveform.path.ecg", destination: .technique("firstaid-nerve-assessment")),
                    TriageOption(id: "transport-bleed-adv", label: "Advanced Bleeding Control", icon: "cross.case.fill", destination: .technique("firstaid-bleeding-control-advanced"))
                ])
            )),

            // 15. ABDOMINAL INJURY
            TriageOption(id: "hurt-abdomen", label: "Abdominal Injury", icon: "figure.arms.open", destination: .technique("firstaid-abdominal-injury")),

            // 16. PSYCHOLOGICAL CRISIS
            TriageOption(id: "hurt-psych", label: "Psychological Crisis", icon: "brain.head.profile", destination: .nextQuestion(
                TriageNode(id: "hurt-psych-q", question: "What's happening?", options: [
                    TriageOption(id: "psych-crisis-panic", label: "Panic Attack", icon: "wind", destination: .techniqueList(["psych-combat-breathing", "firstaid-hyperventilation"])),
                    TriageOption(id: "psych-crisis-fear", label: "Paralyzed by Fear", icon: "exclamationmark.circle", destination: .technique("psych-fear-management")),
                    TriageOption(id: "psych-crisis-aid", label: "Helping Someone in Crisis", icon: "person.2.fill", destination: .technique("firstaid-psychological-aid")),
                    TriageOption(id: "psych-crisis-will", label: "Giving Up / Loss of Will", icon: "heart.slash.fill", destination: .technique("psych-will-to-live"))
                ])
            )),

            // 17. WOUND INFECTION
            TriageOption(id: "hurt-infection", label: "Wound Infection (Red/Swollen)", icon: "exclamationmark.triangle.fill", destination: .technique("firstaid-infection-management")),

            // 18. RIB INJURY
            TriageOption(id: "hurt-rib", label: "Rib Injury / Chest Pain", icon: "lungs.fill", destination: .technique("firstaid-rib-fracture")),

            // 19. DENTAL EMERGENCY
            TriageOption(id: "hurt-dental-emerg", label: "Dental Emergency", icon: "mouth.fill", destination: .technique("firstaid-dental-emergency")),

            // 20. TRENCH FOOT
            TriageOption(id: "hurt-trench", label: "Trench Foot / Wet Feet", icon: "shoe.fill", destination: .technique("firstaid-trench-foot")),

            // 21. EYE INJURY
            TriageOption(id: "hurt-eye", label: "Eye Injury / Chemical in Eye", icon: "eye.fill", destination: .technique("firstaid-eye-injury")),

            // 📚 LEARN MORE
            TriageOption(id: "hurt-learn", label: "Learn More", icon: "book.fill", destination: .nextQuestion(
                TriageNode(id: "hurt-learn-q", question: "What would you like to read about?", options: [
                    TriageOption(id: "hurt-art-priorities", label: "First Aid Priorities", icon: "list.number", destination: .article("firstaid-article-priorities")),
                    TriageOption(id: "hurt-art-trauma", label: "Trauma Assessment", icon: "stethoscope", destination: .article("firstaid-article-trauma-assessment")),
                    TriageOption(id: "hurt-art-bleeding", label: "Bleeding Control", icon: "drop.fill", destination: .article("firstaid-article-bleeding")),
                    TriageOption(id: "hurt-art-airway", label: "Airway Management", icon: "wind", destination: .article("firstaid-article-airway")),
                    TriageOption(id: "hurt-art-cpr", label: "CPR Basics", icon: "heart.fill", destination: .article("firstaid-article-cpr-basics")),
                    TriageOption(id: "hurt-art-fractures", label: "Fractures & Splinting", icon: "bandage.fill", destination: .article("firstaid-article-fractures")),
                    TriageOption(id: "hurt-art-burns", label: "Burns Treatment", icon: "flame", destination: .article("firstaid-article-burns")),
                    TriageOption(id: "hurt-art-bites", label: "Bites & Stings", icon: "ant.fill", destination: .article("firstaid-article-bites")),
                    TriageOption(id: "hurt-art-anaphylaxis", label: "Anaphylaxis", icon: "exclamationmark.triangle.fill", destination: .article("firstaid-article-anaphylaxis")),
                    TriageOption(id: "hurt-art-crush", label: "Crush Syndrome", icon: "rectangle.compress.vertical", destination: .article("firstaid-article-crush-syndrome")),
                    TriageOption(id: "hurt-art-env", label: "Environmental Emergencies", icon: "thermometer.sun.fill", destination: .articleList(["firstaid-article-environmental", "firstaid-article-environmental-emergencies"])),
                    TriageOption(id: "hurt-art-infection", label: "Infection Prevention", icon: "microbe.fill", destination: .article("firstaid-article-infection")),
                    TriageOption(id: "hurt-art-improvised", label: "Improvised Medical Supplies", icon: "cross.case.fill", destination: .article("firstaid-article-improvised")),
                    TriageOption(id: "hurt-art-kit", label: "First Aid Kit Building", icon: "bag.fill", destination: .article("firstaid-article-kit")),
                    TriageOption(id: "hurt-art-field-pharm", label: "Field Pharmacy", icon: "pills.fill", destination: .article("firstaid-article-field-pharmacy")),
                    TriageOption(id: "hurt-art-pediatric", label: "Pediatric First Aid", icon: "figure.and.child.holdinghands", destination: .article("firstaid-article-pediatric"))
                ])
            ))
        ])
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
                                    TriageOption(id: "cold-tarp-dry", label: "Dry but Cold", icon: "wind", destination: .techniqueList(["shelter-tarp-diamond", "shelter-tarp-plowpoint"])), // Added orphan
                                    TriageOption(id: "cold-tarp-wind", label: "Very Windy", icon: "wind", destination: .techniqueList(["shelter-tarp-cfly", "shelter-storm-proofing"])) // Added orphan
                                ])
                            )),
                            TriageOption(id: "cold-rope-only", label: "Rope / Cordage Only", icon: "line.diagonal", destination: .technique("shelter-lean-to")),
                            TriageOption(id: "cold-nothing", label: "Nothing at All", icon: "xmark.circle.fill", destination: .nextQuestion(
                                TriageNode(id: "cold-debris-q", question: "Is there debris on the ground?", options: [
                                    TriageOption(id: "cold-debris-yes", label: "Lots of Leaves & Branches", icon: "leaf.fill", destination: .technique("shelter-debris-aframe")),
                                    TriageOption(id: "cold-debris-round", label: "Some — Can Pile Up", icon: "circle.fill", destination: .techniqueList(["shelter-debris-round", "shelter-natural-hollow"])), // Added orphan
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
                                    TriageOption(id: "cold-snow-hands", label: "Bare Hands / Stick", icon: "hand.raised.fill", destination: .techniqueList(["shelter-snow-trench", "tools-digging-stick"])) // Added orphan
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
                    TriageOption(id: "cold-need-fire", label: "Need to Start Fire", icon: "flame", destination: .nextQuestion(
                        TriageNode(id: "cold-fire-tools", question: "What fire tools do you have?", options: [
                            TriageOption(id: "cold-lighter", label: "Lighter or Matches", icon: "flame", destination: .nextQuestion(
                                TriageNode(id: "cold-fire-goal", question: "What type of fire do you need?", options: [
                                    TriageOption(id: "cold-quick", label: "Quick Heat Now", icon: "flame", destination: .technique("fire-teepee")),
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
                                    TriageOption(id: "cold-frostbite", label: "Numbness, White/Gray Skin", icon: "hand.raised.fill", destination: .technique("env-arctic-frostbite")),
                                    TriageOption(id: "cold-trenchfoot", label: "Wet/Soggy Feet (Painful)", icon: "drop.fill", destination: .technique("firstaid-trench-foot")) // Added orphan
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
                            TriageOption(id: "cold-wet-fire", label: "Yes — Can Dry Clothes", icon: "flame", destination: .technique("fire-teepee")),
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
                    )),

                    // Shelter Improvement
                    TriageOption(id: "cold-improve", label: "Improve Existing Shelter", icon: "wrench.fill", destination: .nextQuestion(
                        TriageNode(id: "cold-improve-q", question: "What improvement?", options: [
                            TriageOption(id: "cold-heated-bed", label: "Heated Sleeping Platform", icon: "flame", destination: .technique("shelter-heated-bed")),
                            TriageOption(id: "cold-fire-reflect", label: "Fire Reflector Wall", icon: "rectangle.split.3x1.fill", destination: .technique("shelter-fire-reflector")),
                            TriageOption(id: "cold-vent", label: "Ventilation (Prevent CO)", icon: "wind", destination: .technique("shelter-ventilation")),
                            TriageOption(id: "cold-snow-wall", label: "Snow Wall Windbreak", icon: "square.stack.fill", destination: .technique("shelter-snow-wall")),
                            TriageOption(id: "cold-door-const", label: "Door / Entrance Block", icon: "door.left.hand.closed", destination: .technique("shelter-door-construction")),
                            TriageOption(id: "cold-waterproof", label: "Waterproofing", icon: "drop.fill", destination: .technique("shelter-waterproofing"))
                        ])
                    )),

                    // Arctic/Tundra Travel
                    TriageOption(id: "cold-arctic-travel", label: "Need to Travel in Cold", icon: "figure.walk", destination: .nextQuestion(
                        TriageNode(id: "cold-travel-q", question: "What terrain?", options: [
                            TriageOption(id: "cold-arctic-move", label: "Arctic / Polar", icon: "snowflake", destination: .technique("env-arctic-travel")),
                            TriageOption(id: "cold-tundra-move", label: "Tundra / Open Frozen", icon: "wind", destination: .technique("env-tundra-travel")),
                            TriageOption(id: "cold-snow-nav", label: "Snow Navigation", icon: "location.fill", destination: .technique("nav-snow-navigation")),
                            TriageOption(id: "cold-snow-goggles", label: "Snow Blindness Prevention", icon: "eyeglasses", destination: .technique("tools-snow-goggles"))
                        ])
                    ))
                ])
            )),

            // 📚 LEARN MORE
            TriageOption(id: "cold-learn", label: "Learn More", icon: "book.fill", destination: .nextQuestion(
                TriageNode(id: "cold-learn-q", question: "What would you like to read about?", options: [
                    TriageOption(id: "cold-art-insulation", label: "Insulation Science", icon: "thermometer.snowflake", destination: .articleList(["shelter-article-insulation", "shelter-article-insulation-values"])),
                    TriageOption(id: "cold-art-snow", label: "Snow Insulation", icon: "snowflake", destination: .article("shelter-article-snow-insulation")),
                    TriageOption(id: "cold-art-arctic", label: "Arctic Survival Guide", icon: "globe", destination: .article("env-article-arctic")),
                    TriageOption(id: "cold-art-winter-water", label: "Winter Water Sources", icon: "drop.fill", destination: .articleList(["water-article-ice-snow", "water-article-winter"])),
                    TriageOption(id: "cold-art-bedding", label: "Bedding & Ground Insulation", icon: "bed.double.fill", destination: .articleList(["shelter-article-bedding", "shelter-article-ground"]))
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
            TriageOption(id: "fire-lighter", label: "Lighter or Matches", icon: "flame", destination: .nextQuestion(
                TriageNode(id: "fire-cond", question: "Do you have a kit?", options: [
                    TriageOption(id: "fire-kit-yes", label: "Yes — Waterproof Kit", icon: "archivebox.fill", destination: .technique("fire-waterproof-kit")), // Added orphan
                    TriageOption(id: "fire-kit-no", label: "No — Standard Lighter", icon: "flame", destination: .nextQuestion(
                        TriageNode(id: "fire-standard-cond", question: "Current Conditions?", options: [
                            TriageOption(id: "fire-dry", label: "Dry Conditions", icon: "sun.max.fill", destination: .nextQuestion(
                                TriageNode(id: "fire-goal", question: "What's your goal?", options: [
                                    TriageOption(id: "fire-lay-teepee", label: "Teepee (Standard)", icon: "cone.fill", destination: .technique("fire-teepee")),
                                    TriageOption(id: "fire-lay-log", label: "Log Cabin (Long Burn)", icon: "square.grid.2x2.fill", destination: .techniqueList(["fire-log-cabin", "fire-upside-down"])), // Added orphan
                                    TriageOption(id: "fire-lay-star", label: "Star Fire (Efficient)", icon: "star.fill", destination: .technique("fire-star-fire")), // Added orphan
                                    TriageOption(id: "fire-lay-lean", label: "Lean-To (Windy)", icon: "arrow.up.right", destination: .technique("fire-lean-to")),
                                    TriageOption(id: "fire-stealth", label: "Low Smoke / Tactical", icon: "eye.slash.fill", destination: .technique("fire-dakota-hole")),
                                    TriageOption(id: "fire-signal", label: "Signal Fire", icon: "antenna.radiowaves.left.and.right", destination: .technique("rescue-signal-fire")),
                                    TriageOption(id: "fire-goal-bug", label: "Repel Insects", icon: "ant.fill", destination: .technique("fire-insect-repellent")) // Added orphan
                                ])
                            )),
                            TriageOption(id: "fire-wet", label: "Raining / Wet Wood", icon: "cloud.rain.fill", destination: .technique("fire-wet-conditions")),
                            TriageOption(id: "fire-wind", label: "Very Windy", icon: "wind", destination: .technique("fire-dakota-hole")),
                            TriageOption(id: "fire-snow-cond", label: "Snow on Ground", icon: "snowflake", destination: .technique("fire-wet-conditions"))
                        ])
                    ))
                ])
            )),

            // Ferro Rod
            TriageOption(id: "fire-ferro", label: "Ferro Rod / Firesteel", icon: "sparkle", destination: .nextQuestion(
                TriageNode(id: "fire-ferro-tinder", question: "Do you have good tinder?", options: [
                    TriageOption(id: "fire-ferro-good", label: "Birch Bark / Lint / Dry Grass", icon: "leaf.fill", destination: .nextQuestion(
                         TriageNode(id: "fire-tinder-type", question: "What kind?", options: [
                            TriageOption(id: "fire-tinder-natural", label: "Natural (Bark/Grass)", icon: "leaf.fill", destination: .techniqueList(["fire-ferrorod", "fire-birch-bark"])), // Added orphan
                            TriageOption(id: "fire-tinder-man", label: "Man-Made (Lint/Paper/Jute)", icon: "doc.text.fill", destination: .techniqueList(["fire-ferrorod", "fire-jute-twine"])) // Added orphan
                         ])
                    )),
                    TriageOption(id: "fire-ferro-none", label: "No Tinder Available", icon: "xmark.circle.fill", destination: .nextQuestion(
                        TriageNode(id: "fire-tinder-make", question: "Can you make tinder?", options: [
                            TriageOption(id: "fire-fatwood", label: "Pine / Resinous Trees Nearby", icon: "tree.fill", destination: .technique("fire-ferrorod")),
                            TriageOption(id: "fire-feather", label: "Have Knife + Dry Wood", icon: "knife.fill", destination: .technique("fire-feather-stick")),
                            TriageOption(id: "fire-charcloth", label: "Cotton + Existing Ember", icon: "tshirt.fill", destination: .technique("fire-charcloth")),
                            TriageOption(id: "fire-carry", label: "Already Have Ember to Transport", icon: "flame", destination: .technique("fire-ember-carrier"))
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

            // Compression (Piston)
            TriageOption(id: "fire-piston", label: "Fire Piston", icon: "cylinder.split.1x2.fill", destination: .technique("fire-piston")), // Orphan

            // Pet Jelly
            TriageOption(id: "fire-vaseline", label: "Cotton Balls + Vaseline", icon: "cross.vial.fill", destination: .technique("fire-vaseline-cotton")), // Orphan

            // NOTHING — Primitive
            TriageOption(id: "fire-nothing", label: "Nothing — No Tools", icon: "xmark.circle.fill", destination: .nextQuestion(
                TriageNode(id: "fire-sun-q", question: "Is the sun visible?", options: [
                    TriageOption(id: "fire-sun-yes", label: "Yes — Sunny", icon: "sun.max.fill", destination: .nextQuestion(
                        TriageNode(id: "fire-solar", question: "Do you have anything to focus light?", options: [
                            TriageOption(id: "fire-lens", label: "Glasses / Magnifying Lens", icon: "magnifyingglass", destination: .technique("fire-magnifying")),
                            TriageOption(id: "fire-bottle", label: "Clear Water Bottle", icon: "waterbottle.fill", destination: .technique("fire-magnifying")),
                            TriageOption(id: "fire-solar-can", label: "Soda Can / Reflector", icon: "circle.fill", destination: .technique("fire-chocolate-can")), // Added orphan
                            TriageOption(id: "fire-ice-avail", label: "Clear Ice Available", icon: "snowflake", destination: .technique("fire-ice-lens")),
                            TriageOption(id: "fire-no-lens", label: "Nothing to Focus Light", icon: "xmark.circle.fill", destination: .technique("fire-bowdrill"))
                        ])
                    )),
                    TriageOption(id: "fire-sun-no", label: "No — Cloudy or Night", icon: "cloud.fill", destination: .nextQuestion(
                        TriageNode(id: "fire-friction", question: "What wood is available?", options: [
                            TriageOption(id: "fire-softwood", label: "Softwood (Cedar, Willow, Poplar)", icon: "tree.fill", destination: .technique("fire-bowdrill")),
                            TriageOption(id: "fire-bamboo-avail", label: "Bamboo Available", icon: "leaf.fill", destination: .technique("fire-firesaw")),
                            TriageOption(id: "fire-handdrill-avail", label: "Cattail / Mullein Stalks", icon: "wand.and.stars", destination: .techniqueList(["fire-handdrill", "tools-hand-drill-improvement"])), // Added orphan
                            TriageOption(id: "fire-plow-avail", label: "Flat Board + Hard Stick", icon: "rectangle.fill", destination: .technique("fire-fire-plow"))
                        ])
                    ))
                ])
            )),

            // 8. HOUSEHOLD HACKS (Phase 5)
            TriageOption(id: "fire-hacks", label: "Household Hacks", icon: "lightbulb.fill", destination: .nextQuestion(
                TriageNode(id: "fire-hacks-q", question: "What do you have?", options: [
                    TriageOption(id: "fire-hack-batt", label: "Battery & Wrapper", icon: "battery.100", destination: .technique("fire-battery-gum")),
                    TriageOption(id: "fire-hack-wool", label: "Steel Wool & 9V", icon: "bolt.fill", destination: .technique("fire-steel-wool")),
                    TriageOption(id: "fire-hack-can", label: "Soda Can & Chocolate", icon: "circle.fill", destination: .technique("fire-chocolate-can"))
                ])
            )),

            // 9. FIRE MAINTENANCE (Keep It Going)
            TriageOption(id: "fire-maintain", label: "Fire Maintenance", icon: "flame", destination: .nextQuestion(
                TriageNode(id: "fire-maint-q", question: "What do you need?", options: [
                    TriageOption(id: "fire-fuel", label: "Fuel Stages (Tinder→Kindling→Fuel)", icon: "arrow.up.right", destination: .technique("fire-fuel-stages")),
                    TriageOption(id: "fire-reflect", label: "Reflector Wall (Direct Heat)", icon: "rectangle.split.3x1.fill", destination: .technique("fire-reflector-wall")),
                    TriageOption(id: "fire-safety-opt", label: "Safety Perimeter", icon: "shield.fill", destination: .technique("fire-safety-perimeter")),
                    TriageOption(id: "fire-extinguish-opt", label: "Extinguishing Safely", icon: "drop.fill", destination: .technique("fire-extinguish")),
                    TriageOption(id: "fire-sig-maint", label: "Signal Fire Maintenance", icon: "antenna.radiowaves.left.and.right", destination: .technique("fire-signal-maintenance")),
                    TriageOption(id: "fire-torch", label: "Make a Torch (Portable Light)", icon: "flashlight.on.fill", destination: .technique("fire-pine-torch"))
                ])
            )),

            // 10. SPECIALTY FIRE TYPES
            TriageOption(id: "fire-specialty", label: "Specialty Fire Types", icon: "square.grid.3x3.fill", destination: .nextQuestion(
                TriageNode(id: "fire-spec-q", question: "What's the purpose?", options: [
                    TriageOption(id: "fire-keyhole", label: "Keyhole Fire (Cook + Warm)", icon: "key.fill", destination: .technique("fire-keyhole-fire")),
                    TriageOption(id: "fire-trench-opt", label: "Trench Fire (Wind / Low Smoke)", icon: "arrow.down.to.line", destination: .technique("fire-trench-fire")),
                    TriageOption(id: "fire-conceal", label: "Concealed Fire (No Visibility)", icon: "eye.slash.fill", destination: .technique("fire-concealed"))
                ])
            )),

            // 11. FIRE IN BAD CONDITIONS
            TriageOption(id: "fire-conditions", label: "Fire in Bad Conditions", icon: "cloud.rain.fill", destination: .nextQuestion(
                TriageNode(id: "fire-bad-q", question: "What's the problem?", options: [
                    TriageOption(id: "fire-cond-snow", label: "Snow / Ice on Ground", icon: "snowflake", destination: .technique("fire-in-snow")),
                    TriageOption(id: "fire-cond-wind-opt", label: "High Wind", icon: "wind", destination: .technique("fire-in-wind")),
                    TriageOption(id: "fire-cond-rain", label: "Rain / Wet Everything", icon: "cloud.rain.fill", destination: .technique("fire-wet-conditions"))
                ])
            )),

            // 12. TINDER & FUEL PREPARATION
            TriageOption(id: "fire-tinder-prep", label: "Tinder & Fuel Prep", icon: "leaf.fill", destination: .nextQuestion(
                TriageNode(id: "fire-prep-q", question: "What are you preparing?", options: [
                    TriageOption(id: "fire-prep-fatwood", label: "Find Fatwood / Resin Wood", icon: "tree.fill", destination: .technique("fire-fatwood-id")),
                    TriageOption(id: "fire-prep-charrope", label: "Make Char Rope", icon: "line.diagonal", destination: .technique("fire-char-rope")),
                    TriageOption(id: "fire-prep-bundle", label: "Fire Bundle (Transport Ember)", icon: "basket.fill", destination: .technique("fire-fire-bundle")),
                    TriageOption(id: "fire-prep-sanitizer", label: "Hand Sanitizer (Accelerant)", icon: "drop.fill", destination: .technique("fire-hand-sanitizer")),
                    TriageOption(id: "fire-prep-bamsaw", label: "Bamboo Fire Saw", icon: "leaf.fill", destination: .technique("fire-bamboo-fire-saw")),
                    TriageOption(id: "fire-prep-saw", label: "Wire / Friction Saw", icon: "scissors", destination: .technique("fire-saw")),
                    TriageOption(id: "fire-prep-plow", label: "Fire Plow (Flat Board)", icon: "rectangle.fill", destination: .technique("fire-plow"))
                ])
            )),

            // 📚 LEARN MORE
            TriageOption(id: "fire-learn", label: "Learn More", icon: "book.fill", destination: .nextQuestion(
                TriageNode(id: "fire-learn-q", question: "What would you like to read about?", options: [
                    TriageOption(id: "fire-art-methods", label: "Fire-Starting Methods", icon: "flame", destination: .article("fire-article-methods")),
                    TriageOption(id: "fire-art-primitive", label: "Primitive Fire Techniques", icon: "leaf.fill", destination: .article("fire-article-primitive")),
                    TriageOption(id: "fire-art-fuel", label: "Fuel Selection & Preparation", icon: "tree.fill", destination: .article("fire-article-fuel")),
                    TriageOption(id: "fire-art-wet", label: "Fire in Wet Conditions", icon: "cloud.rain.fill", destination: .articleList(["fire-article-wet", "fire-article-wet-weather"])),
                    TriageOption(id: "fire-art-maint", label: "Fire Maintenance", icon: "flame", destination: .article("fire-article-maintenance")),
                    TriageOption(id: "fire-art-cooking", label: "Cooking with Fire", icon: "frying.pan.fill", destination: .article("fire-article-cooking")),
                    TriageOption(id: "fire-art-signal", label: "Signal Fires", icon: "smoke.fill", destination: .article("fire-article-signaling")),
                    TriageOption(id: "fire-art-biomes", label: "Fire by Biome", icon: "globe.americas.fill", destination: .article("fire-article-biomes")),
                    TriageOption(id: "fire-art-wood", label: "Wood Identification", icon: "tree.circle.fill", destination: .article("fire-article-wood-id")),
                    TriageOption(id: "fire-art-chem", label: "Chemical Fire Starters", icon: "flask.fill", destination: .article("fire-article-chemical")),
                    TriageOption(id: "fire-art-psych", label: "Psychology of Fire", icon: "brain.head.profile", destination: .article("fire-article-psychology")),
                    TriageOption(id: "fire-art-safety", label: "Fire Safety", icon: "exclamationmark.triangle.fill", destination: .article("fire-article-safety"))
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
                            TriageOption(id: "water-boil", label: "Can Make Fire → Boil", icon: "flame", destination: .technique("water-boiling")),
                            TriageOption(id: "water-store", label: "Storage / Transport", icon: "bag.fill", destination: .nextQuestion(
                                TriageNode(id: "water-store-q", question: "Container type?", options: [
                                    TriageOption(id: "water-store-bottle", label: "Water Bottle / Canteen", icon: "waterbottle.fill", destination: .technique("water-rationing")),
                                    TriageOption(id: "water-store-hacks", label: "Improvised Options", icon: "lightbulb.fill", destination: .techniqueList(["water-condom-canteen", "water-transpiration-bag"])), // Phase 5
                                    TriageOption(id: "water-store-natural", label: "Natural Containers", icon: "leaf.fill", destination: .technique("tools-bark-container"))
                                ])
                            )),
                            TriageOption(id: "water-tabs", label: "Have Purification Tablets / Iodine", icon: "pills.fill", destination: .technique("water-iodine")),
                            TriageOption(id: "water-uv", label: "Clear Bottle + Strong Sun", icon: "sun.max.fill", destination: .technique("water-uv-purification")),
                            TriageOption(id: "water-filter-material", label: "Sand / Gravel / Charcoal", icon: "line.3.horizontal.decrease.circle", destination: .techniqueList(["water-charcoal-filter", "water-activated-charcoal"])), // Added orphan
                            TriageOption(id: "water-cloth-only", label: "Cloth / Sock Only", icon: "tshirt.fill", destination: .technique("water-filter-sock")),
                            TriageOption(id: "water-nothing-purify", label: "Nothing — Must Drink As-Is", icon: "exclamationmark.triangle.fill", destination: .technique("water-boiling"))
                        ])
                    )),
                    TriageOption(id: "water-rain", label: "Rain / Precipitation", icon: "cloud.rain.fill", destination: .nextQuestion(
                        TriageNode(id: "water-rain-q", question: "How will you catch it?", options: [
                            TriageOption(id: "water-rain-cont", label: "Bottles / Containers", icon: "cup.and.saucer.fill", destination: .technique("water-rain-collection")),
                            TriageOption(id: "water-rain-tarp", label: "Tarp / Poncho Catch", icon: "square.fill", destination: .technique("water-tarp-rain-catch")), // Added orphan
                            TriageOption(id: "water-rain-clothes", label: "Soak Clothes & Wring", icon: "tshirt.fill", destination: .technique("water-rain-collection"))
                        ])
                    )),
                    TriageOption(id: "water-murky", label: "Murky / Standing / Stagnant", icon: "drop.triangle.fill", destination: .nextQuestion(
                        TriageNode(id: "water-filter-q", question: "Can you pre-filter sediment?", options: [
                            TriageOption(id: "water-pre-cloth", label: "Have Cloth / Fabric", icon: "tshirt.fill", destination: .nextQuestion(
                                TriageNode(id: "water-after-filter", question: "After filtering, can you purify?", options: [
                                    TriageOption(id: "water-filter-boil", label: "Yes — Can Boil", icon: "flame", destination: .technique("water-boiling")),
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
                            TriageOption(id: "water-trees", label: "Trees / Bushes with Leaves", icon: "tree.fill", destination: .techniqueList(["water-transpiration-bag", "food-pine-tea"])), // Added orphan
                            TriageOption(id: "water-cactus", label: "Barrel Cactus / Succulents", icon: "leaf.fill", destination: .techniqueList(["water-vegetation-indicators", "water-cactus-extraction"])), // Added orphan
                            TriageOption(id: "water-grass", label: "Grass (Early Morning)", icon: "sunrise.fill", destination: .technique("water-dew-collection"))
                        ])
                    )),
                    TriageOption(id: "water-dry-river", label: "Near Dry Riverbed", icon: "line.diagonal", destination: .technique("water-vegetation-indicators")),
                    TriageOption(id: "water-rock-face", label: "Rock Faces Nearby", icon: "triangle.fill", destination: .techniqueList(["water-rock-seepage", "water-spring-identification"])), // Added orphan
                    TriageOption(id: "water-barren", label: "Nothing — Barren", icon: "xmark.circle.fill", destination: .techniqueList(["water-solar-still", "water-well-digging"])), // Added orphan
                    TriageOption(id: "water-condense", label: "Metal Surface Available", icon: "rectangle.fill", destination: .technique("water-condensation-trap")),
                    TriageOption(id: "water-fog", label: "High Altitude / Coastal Fog", icon: "cloud.fog.fill", destination: .technique("water-fog-nets")) // Orphan
                ])
            )),

            // Snow / Ice
            TriageOption(id: "water-snow", label: "Snow / Ice Available", icon: "snowflake", destination: .nextQuestion(
                TriageNode(id: "water-snow-q", question: "Can you make fire?", options: [
                    TriageOption(id: "water-snow-fire", label: "Yes — Can Melting Snow", icon: "flame", destination: .technique("water-snow-melting")), // Fixed from water-snow-ice
                    TriageOption(id: "water-snow-nofire", label: "No Fire — Body Heat Only", icon: "person.fill", destination: .technique("water-snow-ice")),
                    TriageOption(id: "water-ice-clear", label: "Clear Ice (Not Sea Ice)", icon: "cube.fill", destination: .technique("water-snow-ice"))
                ])
            )),

            // At Sea / Coastal
            TriageOption(id: "water-ocean", label: "At Sea / Coastal", icon: "sailboat.fill", destination: .nextQuestion(
                TriageNode(id: "water-sea-q", question: "What's available?", options: [
                    TriageOption(id: "water-rain-exp", label: "Rain Expected", icon: "cloud.rain.fill", destination: .technique("water-rain-collection")),
                    TriageOption(id: "water-sea-desal", label: "Desalination Kit / Solar Still", icon: "spigot.fill", destination: .technique("water-desalination")), // Orphan
                    TriageOption(id: "water-sea-plastic", label: "Container + Sun (Solar Still)", icon: "sun.max.fill", destination: .technique("water-solar-still")),
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
                    TriageOption(id: "water-rain-jungle", label: "Rain Frequent", icon: "cloud.rain.fill", destination: .technique("water-rain-collection")),
                    TriageOption(id: "water-transpire", label: "Standard Transpiration Bag", icon: "bag.fill", destination: .technique("water-transpiration-bag"))
                ])
            )),

            // Urban
            TriageOption(id: "water-urban", label: "Urban Area", icon: "building.2.fill", destination: .nextQuestion(
                TriageNode(id: "water-urban-q", question: "What sources exist?", options: [
                    TriageOption(id: "water-urban-heater", label: "Water Heater / Toilet Tank", icon: "cylinder.fill", destination: .technique("water-rationing")),
                    TriageOption(id: "water-urban-rain", label: "Rain / Puddles", icon: "cloud.rain.fill", destination: .technique("water-boiling")),
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
                    TriageOption(id: "water-charcoal-adv", label: "Charcoal (Activated)", icon: "circle.fill", destination: .technique("water-activated-charcoal")),
                    TriageOption(id: "water-sock-filter", label: "Cloth / Sock Filter", icon: "tshirt.fill", destination: .technique("water-filter-sock"))
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
                    TriageOption(id: "water-cont-condom", label: "Improvised Canteen", icon: "drop.fill", destination: .technique("water-condom-canteen")),
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
                            TriageOption(id: "lost-sig-fire", label: "Can Make Fire", icon: "flame", destination: .technique("rescue-signal-fire")),
                            TriageOption(id: "lost-sig-whistle", label: "Whistle / Loud Voice", icon: "speaker.wave.3.fill", destination: .techniqueList(["rescue-whistle", "rescue-whistle-patterns"])), // Added orphan
                            TriageOption(id: "lost-sig-smoke", label: "Colored Smoke (Daytime)", icon: "smoke.fill", destination: .technique("rescue-smoke-signal")),
                            TriageOption(id: "lost-sig-ground", label: "Open Ground for Symbols", icon: "square.fill", destination: .techniqueList(["rescue-ground-signal", "rescue-flag-signals"])), // Added orphan
                            TriageOption(id: "lost-sig-panel", label: "Know ICAO Panel Codes", icon: "textformat", destination: .technique("rescue-panel-signals")),
                            TriageOption(id: "lost-sig-morse", label: "Flashlight / Tapping", icon: "flashlight.on.fill", destination: .technique("rescue-morse-code")),
                            TriageOption(id: "lost-sig-phone", label: "Phone (Even Dead Service)", icon: "iphone", destination: .technique("rescue-phone-emergency"))
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
                                    TriageOption(id: "lost-follow-water", label: "Find & Follow Water Downhill", icon: "water.waves", destination: .technique("nav-river-following")),
                                    TriageOption(id: "lost-deadreckon", label: "Pick Direction & Walk Straight", icon: "arrow.right", destination: .technique("nav-dead-reckoning")),
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
                    TriageOption(id: "lost-nav-snow", label: "Snow / Winter", icon: "snowflake", destination: .technique("nav-snow-navigation")),
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
                            TriageOption(id: "trapped-fire-sig", label: "Can Make Fire", icon: "flame", destination: .technique("rescue-signal-fire")),
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
                            TriageOption(id: "trapped-know-dir", label: "Yes — Know the Way", icon: "location.fill", destination: .techniqueList(["rescue-self-rescue", "rescue-self-evacuation"])), // Added orphan
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
                                                    TriageOption(id: "trapped-ven-elevate", label: "Can Elevate Limb", icon: "arrow.up", destination: .technique("firstaid-wound-cleaning")),
                                                    TriageOption(id: "trapped-ven-suture", label: "Deep Gash (Needs Closing)", icon: "pencil.line", destination: .techniqueList(["firstaid-wound-closure", "firstaid-field-suturing"])) // Added orphan
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
                                    TriageOption(id: "trapped-bleed-head", label: "Head Wound", icon: "brain.head.profile", destination: .technique("firstaid-head-trauma")),
                                    TriageOption(id: "trapped-bleed-impaled", label: "Object Impaled", icon: "pin.fill", destination: .technique("firstaid-impaled-object"))
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
                                    )),
                                    TriageOption(id: "trapped-sprain", label: "Sprain / Twist (Swelling)", icon: "bandage.fill", destination: .techniqueList(["firstaid-ankle-wrap", "firstaid-sprained-ankle", "firstaid-blister"])) // Added orphans
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
                                            TriageOption(id: "trapped-shock-sit", label: "No — Keep Seated / Warm", icon: "flame", destination: .technique("firstaid-shock")),
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
                            TriageOption(id: "trapped-burn", label: "Burn Injury", icon: "flame", destination: .nextQuestion(
                                TriageNode(id: "trapped-burn-type", question: "What caused the burn?", options: [
                                    TriageOption(id: "trapped-burn-fire", label: "Fire / Heat (Thermal)", icon: "flame", destination: .nextQuestion(
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
                                    TriageOption(id: "trapped-burn-minor", label: "Minor / Redness", icon: "drop.fill", destination: .technique("firstaid-burn")),
                                    TriageOption(id: "trapped-burn-electric", label: "Electrical", icon: "bolt.fill", destination: .techniqueList(["firstaid-burn-char", "firstaid-cpr", "firstaid-electrocution"])) // Added orphan
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
                                    TriageOption(id: "trapped-heart-con", label: "Yes — Conscious", icon: "eye.fill", destination: .techniqueList(["firstaid-heart-attack", "firstaid-chest-seal"])), // Added orphan
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
                            TriageOption(id: "trapped-childbirth", label: "Emergency Childbirth", icon: "figure.2.and.child.holdinghands", destination: .technique("firstaid-childbirth")), // Added orphan
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
                            TriageOption(id: "trapped-need-warmth", label: "Warmth", icon: "flame", destination: .techniqueList(["shelter-mylar-wrap", "shelter-emergency-bivy", "firstaid-hypothermia"])),
                            TriageOption(id: "trapped-need-food", label: "Food", icon: "leaf.fill", destination: .techniqueList(["food-common-edibles", "food-cattail", "food-insect-eating", "food-shellfish", "food-frog-catching"])),
                            TriageOption(id: "trapped-need-morale", label: "Staying Calm / Morale", icon: "brain.head.profile", destination: .techniqueList(["psych-box-breathing", "psych-54321-grounding", "psych-routine", "psych-loneliness", "psych-ooda-loop", "psych-group-leadership", "psych-grief-processing", "psych-gratitude-practice", "psych-positive-self-talk"])), // Added orphans
                            TriageOption(id: "trapped-need-pain", label: "Managing Pain", icon: "cross.case.fill", destination: .technique("psych-pain-management")),
                            TriageOption(id: "trapped-need-morale", label: "Staying Calm / Morale", icon: "brain.head.profile", destination: .techniqueList(["psych-box-breathing", "psych-54321-grounding", "psych-routine", "psych-loneliness", "psych-ooda-loop", "psych-group-leadership", "psych-grief-processing", "psych-gratitude-practice", "psych-positive-self-talk"])), // Added orphans
                            TriageOption(id: "trapped-need-pain", label: "Managing Pain", icon: "cross.case.fill", destination: .technique("psych-pain-management")),
                            TriageOption(id: "trapped-need-tools", label: "Making Tools / Traps", icon: "wrench.and.screwdriver.fill", destination: .techniqueList(["tools-trap-triggers", "tools-bow-making", "tools-stone-axe", "tools-spear-making", "tools-fire-hardened-spear", "tools-stone-drill", "tools-atlatl", "tools-sling", "tools-knife-sharpening", "tools-natural-glue", "tools-bark-container", "tools-sinew-cordage", "tools-repair", "tools-rock-hammer", "tools-square-lashing", "tools-improvised-container", "tools-water-carrier", "tools-camp-organization", "tools-charcoal-filter"])) // Added orphans
                        ])
                    )),

                    // Vehicle Accident
                    TriageOption(id: "trapped-vehicle", label: "Vehicle Accident / Crash", icon: "car.fill", destination: .nextQuestion(
                        TriageNode(id: "trapped-vehicle-q", question: "Immediate danger?", options: [
                            TriageOption(id: "veh-fire", label: "Fire / Smoke", icon: "flame", destination: .technique("fire-article-safety")),
                            TriageOption(id: "veh-leak", label: "Fuel Leak / Smell Gas", icon: "drop.triangle.fill", destination: .technique("env-urban-disaster")),
                            TriageOption(id: "veh-pinned", label: "Pinned Inside", icon: "rectangle.compress.vertical", destination: .technique("rescue-vehicle-signal")),
                            TriageOption(id: "veh-safe-loc", label: "Safe Location (Wait)", icon: "checkmark.circle", destination: .techniqueList(["shelter-vehicle", "rescue-vehicle-signal"]))
                        ])
                    ))
                ])
            )),

            // PSYCHOLOGY — WAITING TO BE RESCUED
            TriageOption(id: "trapped-psych", label: "Staying Mentally Strong", icon: "brain.head.profile", destination: .nextQuestion(
                TriageNode(id: "trapped-psych-q", question: "What do you need?", options: [
                    TriageOption(id: "tp-stop", label: "STOP Method (First Steps)", icon: "hand.raised.fill", destination: .technique("psych-stop-method")),
                    TriageOption(id: "tp-fear", label: "Managing Fear / Anxiety", icon: "exclamationmark.circle", destination: .technique("psych-fear-management")),
                    TriageOption(id: "tp-decision", label: "Decision Fatigue", icon: "questionmark.circle.fill", destination: .technique("psych-decision-fatigue")),
                    TriageOption(id: "tp-sleep", label: "Sleep Management", icon: "moon.fill", destination: .nextQuestion(
                        TriageNode(id: "tp-sleep-q", question: "What's the issue?", options: [
                            TriageOption(id: "tp-sleep-cant", label: "Can't Sleep", icon: "moon.zzz.fill", destination: .technique("psych-sleep-hygiene")),
                            TriageOption(id: "tp-sleep-deprived", label: "Sleep Deprived", icon: "exclamationmark.triangle.fill", destination: .technique("psych-sleep-deprivation")),
                            TriageOption(id: "tp-sleep-schedule", label: "Setting Sleep Discipline", icon: "clock.fill", destination: .technique("psych-sleep-discipline")),
                            TriageOption(id: "tp-night-anxiety", label: "Night Anxiety", icon: "moon.stars.fill", destination: .technique("psych-night-anxiety"))
                        ])
                    )),
                    TriageOption(id: "tp-boredom", label: "Boredom / Waiting", icon: "hourglass", destination: .technique("psych-boredom-management")),
                    TriageOption(id: "tp-children", label: "Children in Survival", icon: "figure.and.child.holdinghands", destination: .technique("psych-children-survival")),
                    TriageOption(id: "tp-group", label: "Group Dynamics", icon: "person.3.fill", destination: .nextQuestion(
                        TriageNode(id: "tp-group-q", question: "What's happening?", options: [
                            TriageOption(id: "tp-conflict", label: "Conflict Between People", icon: "exclamationmark.bubble.fill", destination: .technique("psych-conflict-resolution")),
                            TriageOption(id: "tp-leadership", label: "Leadership Transfer", icon: "person.badge.key.fill", destination: .technique("psych-leadership-handoff")),
                            TriageOption(id: "tp-teach", label: "Teaching Others to Cope", icon: "person.fill.questionmark", destination: .technique("psych-teach-to-cope"))
                        ])
                    )),
                    TriageOption(id: "tp-morale", label: "Building Morale", icon: "heart.fill", destination: .nextQuestion(
                        TriageNode(id: "tp-morale-q", question: "What technique?", options: [
                            TriageOption(id: "tp-reframe", label: "Cognitive Reframing", icon: "brain.fill", destination: .technique("psych-cognitive-reframe")),
                            TriageOption(id: "tp-acceptance", label: "Acceptance & Stages", icon: "checkmark.circle", destination: .techniqueList(["psych-acceptance", "psych-acceptance-stages"])),
                            TriageOption(id: "tp-humor", label: "Humor as Survival Tool", icon: "face.smiling.fill", destination: .technique("psych-humor")),
                            TriageOption(id: "tp-journal", label: "Journaling / Record", icon: "note.text", destination: .technique("psych-journaling")),
                            TriageOption(id: "tp-motivation", label: "Motivation Anchors", icon: "star.fill", destination: .technique("psych-motivation-anchors")),
                            TriageOption(id: "tp-visualize", label: "Visualization", icon: "eye.fill", destination: .technique("psych-visualization")),
                            TriageOption(id: "tp-normalcy", label: "Creating Normalcy", icon: "clock.fill", destination: .technique("psych-normalcy")),
                            TriageOption(id: "tp-grief", label: "Processing Grief / Loss", icon: "heart.slash.fill", destination: .technique("psych-grief-management")),
                            TriageOption(id: "tp-will", label: "Will to Live", icon: "flame", destination: .technique("psych-will-to-live"))
                        ])
                    ))
                ])
            )),

            // TOOLCRAFT — WHILE TRAPPED OR WAITING
            TriageOption(id: "trapped-tools", label: "Craft Tools & Equipment", icon: "wrench.and.screwdriver.fill", destination: .nextQuestion(
                TriageNode(id: "trapped-tools-q", question: "What do you need to make?", options: [
                    TriageOption(id: "tool-knots", label: "Knots & Lashing", icon: "link", destination: .nextQuestion(
                        TriageNode(id: "tool-knots-q", question: "What knot?", options: [
                            TriageOption(id: "tool-bowline", label: "Bowline (Loop)", icon: "circle", destination: .technique("tools-bowline")),
                            TriageOption(id: "tool-clove", label: "Clove Hitch (Attach to Pole)", icon: "link", destination: .technique("tools-clove-hitch")),
                            TriageOption(id: "tool-trucker", label: "Trucker's Hitch (Tension)", icon: "arrow.up.and.down", destination: .technique("tools-truckers-hitch")),
                            TriageOption(id: "tool-taut", label: "Taut-Line (Adjustable)", icon: "line.diagonal", destination: .technique("tools-taut-line")),
                            TriageOption(id: "tool-prusik", label: "Prusik Knot (Climbing)", icon: "arrow.up", destination: .technique("tools-prusik-knot")),
                            TriageOption(id: "tool-sheet", label: "Sheet Bend (Join Ropes)", icon: "arrow.triangle.merge", destination: .technique("tools-sheet-bend")),
                            TriageOption(id: "tool-alpine", label: "Alpine Butterfly (Mid-Line)", icon: "figure.climbing", destination: .technique("tools-alpine-butterfly")),
                            TriageOption(id: "tool-constrictor", label: "Constrictor Knot (Grip)", icon: "xmark.circle", destination: .technique("tools-constrictor-knot"))
                        ])
                    )),
                    TriageOption(id: "tool-cordage-opt", label: "Make Cordage / Rope", icon: "line.diagonal", destination: .technique("tools-cordage")),
                    TriageOption(id: "tool-stone", label: "Stone Tools", icon: "hammer.fill", destination: .nextQuestion(
                        TriageNode(id: "tool-stone-q", question: "What tool?", options: [
                            TriageOption(id: "tool-flint", label: "Flint Knapping (Blades)", icon: "arrowtriangle.down.fill", destination: .technique("tools-flint-knapping")),
                            TriageOption(id: "tool-axe", label: "Stone Axe", icon: "hammer.fill", destination: .technique("tools-stone-axe")),
                            TriageOption(id: "tool-drill", label: "Stone Drill", icon: "arrow.down.circle", destination: .technique("tools-stone-drill")),
                            TriageOption(id: "tool-hammer", label: "Rock Hammer", icon: "hammer", destination: .technique("tools-rock-hammer"))
                        ])
                    )),
                    TriageOption(id: "tool-bone", label: "Bone & Natural Craft", icon: "leaf.fill", destination: .nextQuestion(
                        TriageNode(id: "tool-bone-q", question: "What to make?", options: [
                            TriageOption(id: "tool-bone-needle", label: "Bone Needle (Sewing)", icon: "pin.fill", destination: .technique("tools-bone-needle")),
                            TriageOption(id: "tool-bone-hook", label: "Bone Fish Hook", icon: "hook", destination: .technique("tools-bone-fishhook")),
                            TriageOption(id: "tool-clay-pot", label: "Clay Pot", icon: "cylinder.fill", destination: .technique("tools-clay-pot")),
                            TriageOption(id: "tool-bamboo", label: "Bamboo Tools", icon: "leaf.fill", destination: .technique("tools-bamboo-tools")),
                            TriageOption(id: "tool-net", label: "Net Making", icon: "square.grid.3x3.fill", destination: .technique("tools-net-making")),
                            TriageOption(id: "tool-saw", label: "Improvised Saw", icon: "scissors", destination: .technique("tools-improvised-saw")),
                            TriageOption(id: "tool-torch-opt", label: "Torch / Light", icon: "flashlight.on.fill", destination: .technique("tools-torch")),
                            TriageOption(id: "tool-bark-cloth", label: "Bark Cloth", icon: "tree.fill", destination: .technique("tools-bark-cloth")),
                            TriageOption(id: "tool-hide", label: "Hide Tanning", icon: "rectangle.fill", destination: .technique("tools-hide-tanning")),
                            TriageOption(id: "tool-bark-adv", label: "Advanced Bark Container", icon: "basket.fill", destination: .technique("tools-bark-container-adv")),
                            TriageOption(id: "tool-fish-hook", label: "Improvised Fish Hook", icon: "hook", destination: .techniqueList(["tools-fish-hook", "tools-fishing-hooks"])),
                            TriageOption(id: "tool-weighted-net", label: "Weighted Net", icon: "square.grid.3x3.fill", destination: .technique("tools-weighted-net"))
                        ])
                    ))
                ])
            )),

            // 📚 LEARN MORE
            TriageOption(id: "trap-learn", label: "Learn More", icon: "book.fill", destination: .nextQuestion(
                TriageNode(id: "trap-learn-q", question: "What would you like to read about?", options: [
                    TriageOption(id: "trap-art-mindset", label: "Survival Mindset", icon: "brain.head.profile", destination: .article("psych-article-mindset")),
                    TriageOption(id: "trap-art-decisions", label: "Decision Making Under Stress", icon: "arrow.triangle.branch", destination: .article("psych-article-decisions")),
                    TriageOption(id: "trap-art-group", label: "Group Dynamics", icon: "person.3.fill", destination: .article("psych-article-group")),
                    TriageOption(id: "trap-art-children", label: "Children in Survival", icon: "figure.and.child.holdinghands", destination: .articleList(["psych-article-children", "psych-article-children-management"])),
                    TriageOption(id: "trap-art-isolation", label: "Isolation Effects", icon: "person.fill.questionmark", destination: .articleList(["psych-article-isolation", "psych-article-isolation-effects"])),
                    TriageOption(id: "trap-art-sleep", label: "Sleep Deprivation", icon: "moon.zzz.fill", destination: .articleList(["psych-article-sleep", "psych-article-sleep-deprivation"])),
                    TriageOption(id: "trap-art-night", label: "Surviving the Night", icon: "moon.fill", destination: .article("psych-article-night")),
                    TriageOption(id: "trap-art-longterm", label: "Long-Term Survival", icon: "calendar", destination: .article("psych-article-longterm")),
                    TriageOption(id: "trap-art-postrescue", label: "Post-Rescue Recovery", icon: "heart.circle.fill", destination: .article("psych-article-postrescue")),
                    TriageOption(id: "trap-art-knots", label: "Essential Knots", icon: "lasso", destination: .article("tools-article-knots")),
                    TriageOption(id: "trap-art-cordage", label: "Cordage & Rope Making", icon: "line.diagonal", destination: .article("tools-article-cordage")),
                    TriageOption(id: "trap-art-stone", label: "Stone Tool Craft", icon: "fossil.shell.fill", destination: .articleList(["tools-article-stone", "tools-article-stone-tools"])),
                    TriageOption(id: "trap-art-blade", label: "Blade & Edge Tools", icon: "scissors", destination: .article("tools-article-blade")),
                    TriageOption(id: "trap-art-containers", label: "Making Containers", icon: "cup.and.saucer.fill", destination: .article("tools-article-containers")),
                    TriageOption(id: "trap-art-adhesives", label: "Natural Adhesives", icon: "drop.fill", destination: .article("tools-article-adhesives")),
                    TriageOption(id: "trap-art-leather", label: "Leather Working", icon: "rectangle.fill", destination: .article("tools-article-leather")),
                    TriageOption(id: "trap-art-camp", label: "Camp Craft", icon: "tent.fill", destination: .article("tools-article-camp")),
                    TriageOption(id: "trap-art-repair", label: "Field Repairs", icon: "wrench.fill", destination: .article("tools-article-repair")),
                    TriageOption(id: "trap-art-trapping", label: "Trapping Theory", icon: "hare.fill", destination: .article("tools-article-trapping")),
                    TriageOption(id: "trap-art-fishing", label: "Fishing Technology", icon: "fish.fill", destination: .article("tools-article-fishing-tech"))
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
                    TriageOption(id: "dis-eq-indoor", label: "Indoors", icon: "building.2.fill", destination: .technique("env-earthquake-indoor")),
                    TriageOption(id: "dis-eq-outdoor", label: "Outdoors", icon: "tree.fill", destination: .technique("env-earthquake-outdoor")),
                    TriageOption(id: "dis-eq-vehicle", label: "In a Vehicle", icon: "car.fill", destination: .technique("env-earthquake-outdoor")),
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
                    TriageOption(id: "dis-tor-building", label: "In a House/Building", icon: "building.2.fill", destination: .technique("env-tornado-shelter")),
                    TriageOption(id: "dis-tor-mobile", label: "Mobile Home", icon: "house.fill", destination: .technique("env-tornado-mobile")), 
                    TriageOption(id: "dis-tor-vehicle", label: "In a Vehicle", icon: "car.fill", destination: .nextQuestion(
                        TriageNode(id: "dis-tor-drive-q", question: "Can you see its path?", options: [
                            TriageOption(id: "dis-tor-drive-evade", label: "Yes — Evade", icon: "arrow.turn.up.right", destination: .technique("env-tornado-drive")),
                            TriageOption(id: "dis-tor-drive-trap", label: "Trapped / Close", icon: "exclamationmark.triangle.fill", destination: .technique("env-tornado-ditch"))
                        ])
                    )),
                    TriageOption(id: "dis-tor-outdoor", label: "Open Outdoors", icon: "figure.walk", destination: .technique("env-tornado-ditch"))
                ])
            )),

            // --- WILDFIRE ---
            TriageOption(id: "dis-wildfire", label: "Wildfire", icon: "flame", destination: .nextQuestion(
                TriageNode(id: "dis-fire-q", question: "How close is the fire?", options: [
                    TriageOption(id: "dis-fire-far", label: "Visible but Far", icon: "arrow.right", destination: .nextQuestion(
                         TriageNode(id: "dis-fire-wind", question: "Monitor the wind!", options: [
                            TriageOption(id: "dis-fire-monitor", label: "Watch & Prepare", icon: "wind", destination: .technique("env-wildfire-monitor")),
                            TriageOption(id: "dis-fire-evac-early", label: "Evacuating Now", icon: "car.fill", destination: .technique("env-wildfire-evac"))
                         ])
                    )),
                    TriageOption(id: "dis-fire-near", label: "Close — Smoke Heavy", icon: "smoke.fill", destination: .technique("env-wildfire-evac")),
                    TriageOption(id: "dis-fire-vehicle", label: "Trapped in Vehicle", icon: "car.fill", destination: .technique("env-wildfire-vehicle")),
                    TriageOption(id: "dis-fire-house", label: "Trapped in House", icon: "house.fill", destination: .technique("env-wildfire-survival")),
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
                    TriageOption(id: "dis-hurr-prep", label: "Approaching (Pre-Storm)", icon: "clock.fill", destination: .technique("env-coastal-storm")),
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
                            TriageOption(id: "dis-blizz-heat", label: "Staying Warm", icon: "flame", destination: .nextQuestion(
                                TriageNode(id: "dis-blizz-heat-q", question: "Do you have a fireplace?", options: [
                                    TriageOption(id: "dis-blizz-fireplace", label: "Yes — Fireplace / Wood Stove", icon: "flame", destination: .technique("fire-log-cabin")),
                                    TriageOption(id: "dis-blizz-no-fire", label: "No — Electric Only", icon: "xmark.circle.fill", destination: .techniqueList(["shelter-mylar-wrap", "firstaid-hypothermia", "shelter-insulation-techniques"])) // Added orphan
                                ])
                            )),
                            TriageOption(id: "dis-blizz-water", label: "Safe Drinking Water", icon: "drop.fill", destination: .technique("water-snow-ice")),
                            TriageOption(id: "dis-blizz-hypo", label: "Signs of Hypothermia", icon: "thermometer.snowflake", destination: .technique("firstaid-hypothermia")),
                            TriageOption(id: "dis-blizz-pipe", label: "Pipes Frozen / Burst", icon: "wrench.fill", destination: .technique("water-rationing"))
                        ])
                    ))
                ])
            )),

            // --- LIGHTNING ---
            TriageOption(id: "dis-lightning", label: "Lightning / Thunderstorm", icon: "cloud.bolt.fill", destination: .nextQuestion(
                TriageNode(id: "dis-light-q", question: "Where are you?", options: [
                    TriageOption(id: "dis-light-exposed", label: "Open / Exposed Area", icon: "figure.walk", destination: .technique("env-lightning-position")),
                    TriageOption(id: "dis-light-mtn", label: "Mountain Ridge / Peak", icon: "mountain.2.fill", destination: .technique("env-mountain-lightning")),
                    TriageOption(id: "dis-light-forest", label: "Forest / Near Trees", icon: "tree.fill", destination: .technique("env-lightning-safety")),
                    TriageOption(id: "dis-light-water", label: "On Water (Boat/Swim)", icon: "water.waves", destination: .technique("env-lightning-safety")),
                    TriageOption(id: "dis-light-group", label: "With a Group", icon: "person.3.fill", destination: .technique("env-lightning-position")),
                    TriageOption(id: "dis-light-dist", label: "Calculating Distance", icon: "stopwatch.fill", destination: .technique("env-lightning-dist"))
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
                    TriageOption(id: "dis-volc-flow", label: "Lava / Pyroclastic Flow", icon: "flame", destination: .technique("env-volcanic-eruption")),
                    TriageOption(id: "dis-volc-shelter", label: "Sheltering in Place", icon: "house.fill", destination: .technique("env-volcanic-ashfall"))
                ])
            )),

            // --- TSUNAMI ---
            TriageOption(id: "dis-tsunami", label: "Tsunami", icon: "water.waves.and.arrow.up", destination: .nextQuestion(
                TriageNode(id: "dis-tsu-q", question: "What's happening?", options: [
                    TriageOption(id: "dis-tsu-warning", label: "Earthquake / Warning Siren", icon: "speaker.wave.3.fill", destination: .technique("env-tsunami-response")),
                    TriageOption(id: "dis-tsu-water", label: "Water Receding Rapidly", icon: "arrow.down.to.line", destination: .technique("env-tsunami-response")),
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

            // --- SANDSTORM ---
            TriageOption(id: "dis-sandstorm", label: "Sandstorm", icon: "wind", destination: .technique("env-sandstorm")),

            // --- QUICKSAND ---
            TriageOption(id: "dis-quicksand", label: "Quicksand / Mud", icon: "arrow.down.circle.fill", destination: .technique("env-quicksand")),

            // --- LIGHTNING ---
            TriageOption(id: "dis-lightning", label: "Lightning Storm", icon: "bolt.fill", destination: .nextQuestion(
                TriageNode(id: "dis-light-dist", question: "Count seconds: Flash to Bang", options: [
                    TriageOption(id: "light-close", label: "Under 30 Seconds (Close!)", icon: "exclamationmark.triangle.fill", destination: .technique("env-lightning-safety")),
                    TriageOption(id: "light-far", label: "Over 30 Seconds", icon: "checkmark.circle", destination: .nextQuestion(
                        TriageNode(id: "dis-light-q", question: "Where are you?", options: [
                            TriageOption(id: "dis-light-ridge", label: "High Ground / Ridge", icon: "mountain.2.fill", destination: .technique("env-lightning-position")),
                            TriageOption(id: "dis-light-open", label: "Open Field", icon: "figure.walk", destination: .technique("env-lightning-position")),
                            TriageOption(id: "dis-light-forest", label: "In Forest", icon: "tree.fill", destination: .technique("env-lightning-safety")),
                            TriageOption(id: "dis-light-struck", label: "Someone Was Struck", icon: "bolt.heart.fill", destination: .techniqueList(["env-lightning-safety", "firstaid-cpr"]))
                        ])
                    ))
                ])
            )),

            // --- NUCLEAR / RADIOLOGICAL ---
            TriageOption(id: "dis-nuclear", label: "Nuclear / Radiological", icon: "exclamationmark.triangle.fill", destination: .nextQuestion(
                TriageNode(id: "dis-nuc-q", question: "What is the threat?", options: [
                    TriageOption(id: "nuc-blast", label: "Blast / Flash Observed", icon: "sun.max.fill", destination: .technique("env-urban-disaster")),
                    TriageOption(id: "nuc-fallout", label: "Fallout Warning", icon: "smoke.fill", destination: .nextQuestion(
                        TriageNode(id: "nuc-fallout-q", question: "Where is shelter?", options: [
                            TriageOption(id: "nuc-shelter-under", label: "Underground / Basement", icon: "house.fill", destination: .technique("shelter-underground")), // NOTE: Mapped to shelter-vehicle if underground missing
                            TriageOption(id: "nuc-shelter-inner", label: "Inner Room / Center of Building", icon: "building.2.fill", destination: .technique("env-urban-disaster")),
                            TriageOption(id: "nuc-outdoor", label: "Caught Outdoors", icon: "figure.walk", destination: .technique("env-urban-disaster"))
                        ])
                    )),
                    TriageOption(id: "nuc-water", label: "Concerned About Water", icon: "drop.fill", destination: .technique("water-filter-sock")) // Best proxy for purification
                ])
            )),

            // --- PANDEMIC / BIOHAZARD ---
            TriageOption(id: "dis-bio", label: "Pandemic / Biohazard", icon: "allergens.fill", destination: .nextQuestion(
                TriageNode(id: "dis-bio-q", question: "Immediate need?", options: [
                    TriageOption(id: "bio-isolate", label: "Isolation / Quarantine Area", icon: "house.fill", destination: .technique("shelter-urban-debris")),
                    TriageOption(id: "bio-water", label: "Safe Water (Grid Down)", icon: "drop.fill", destination: .technique("water-boiling")),
                    TriageOption(id: "bio-sanitize", label: "Sanitation / Hygiene", icon: "hands.sparkles.fill", destination: .technique("firstaid-wound-cleaning")) // Hygiene proxy
                ])
            )),

            // --- CIVIL UNREST ---
            TriageOption(id: "dis-unrest", label: "Civil Unrest / Riots", icon: "person.3.fill", destination: .nextQuestion(
                TriageNode(id: "dis-unrest-q", question: "Your situation?", options: [
                    TriageOption(id: "unrest-home", label: "Sheltering at Home", icon: "house.fill", destination: .techniqueList(["env-door-barricade", "env-urban-disaster"])),
                    TriageOption(id: "unrest-move", label: "Need to Move / Evade", icon: "figure.walk", destination: .techniqueList(["env-urban-grayman", "env-anti-tracking", "env-vehicle-entry"])),
                    TriageOption(id: "unrest-detained", label: "Detained / Restrained", icon: "lock.fill", destination: .technique("env-ziptie-escape")),
                    TriageOption(id: "unrest-crowd", label: "Caught in Crowd", icon: "exclamationmark.triangle.fill", destination: .technique("psych-article-panic")) // Fixed ID
                ])
            )),

            // --- CYBER / GRID DOWN ---
            TriageOption(id: "dis-cyber", label: "Solar Flare / Cyber Attack", icon: "bolt.slash.fill", destination: .nextQuestion(
                TriageNode(id: "dis-cyber-q", question: "Main challenge?", options: [
                    TriageOption(id: "cyber-comms", label: "No Communications", icon: "antenna.radiowaves.left.and.right.slash", destination: .techniqueList(["rescue-article-radio", "rescue-cd-mirror"])),
                    TriageOption(id: "cyber-power", label: "Power Outage Survival", icon: "bolt.slash.fill", destination: .technique("env-urban-disaster")),
                    TriageOption(id: "cyber-supply", label: "Supply Chain / Food", icon: "cart.fill", destination: .technique("food-rationing"))
                ])
            )),

            // --- REBUILDING CIVILIZATION ---
            TriageOption(id: "dis-rebuild", label: "Long Term / Rebuilding", icon: "hammer.fill", destination: .nextQuestion(
                TriageNode(id: "dis-rebuild-q", question: "What do you need to produce?", options: [
                    TriageOption(id: "rebuild-hygiene", label: "Soap & Hygiene", icon: "hands.sparkles.fill", destination: .techniqueList(["hygiene-soap-making", "hygiene-charcoal-toothpaste"])),
                    TriageOption(id: "rebuild-agri", label: "Agriculture (Farming)", icon: "leaf.fill", destination: .techniqueList(["agri-three-sisters", "agri-seed-saving", "agri-composting"])),
                    TriageOption(id: "rebuild-industry", label: "Industry (Leather/Weaving)", icon: "gearshape.2.fill", destination: .techniqueList(["industry-tanning", "industry-basketry"]))
                ])
            )),

            // --- FLASH FLOOD ---
            TriageOption(id: "dis-flash-flood", label: "Flash Flood", icon: "cloud.heavyrain.fill", destination: .nextQuestion(
                TriageNode(id: "dis-flash-q", question: "Where are you?", options: [
                    TriageOption(id: "dis-flash-canyon", label: "Canyon / Ravine", icon: "mountain.2.fill", destination: .technique("env-flash-flood")),
                    TriageOption(id: "dis-flash-road", label: "Road / Vehicle", icon: "car.fill", destination: .technique("env-flash-flood-response")),
                    TriageOption(id: "dis-flash-camp", label: "Camp Near Water", icon: "tent.fill", destination: .technique("env-flash-flood")),
                    TriageOption(id: "dis-flash-after", label: "After the Flood", icon: "drop.fill", destination: .technique("env-flood-survival"))
                ])
            )),

            // --- OCEAN / COASTAL ---
            TriageOption(id: "dis-ocean", label: "Ocean / Coastal Emergency", icon: "water.waves", destination: .nextQuestion(
                TriageNode(id: "dis-ocean-q", question: "What's happening?", options: [
                    TriageOption(id: "dis-ocean-survive", label: "Adrift at Sea", icon: "sailboat.fill", destination: .technique("env-ocean-survival")),
                    TriageOption(id: "dis-coastal-tidal", label: "Tidal / Coastal Hazard", icon: "water.waves", destination: .technique("env-coastal-tidal")),
                    TriageOption(id: "dis-tropical", label: "Tropical Disease Risk", icon: "ladybug.fill", destination: .technique("env-tropical-disease"))
                ])
            )),

            // --- GENERAL DISASTER GUIDES ---
            TriageOption(id: "dis-general", label: "General Disaster Guides", icon: "book.fill", destination: .nextQuestion(
                TriageNode(id: "dis-gen-q", question: "Which disaster?", options: [
                    TriageOption(id: "dis-gen-quake", label: "Earthquake (General)", icon: "waveform.path.ecg", destination: .technique("env-earthquake")),
                    TriageOption(id: "dis-gen-tornado", label: "Tornado (General)", icon: "tornado", destination: .technique("env-tornado")),
                    TriageOption(id: "dis-gen-wildfire", label: "Wildfire (General)", icon: "flame", destination: .technique("env-wildfire")),
                    TriageOption(id: "dis-gen-lightning", label: "Lightning (General)", icon: "bolt.fill", destination: .technique("env-lightning"))
                ])
            )),

            // 📚 LEARN MORE
            TriageOption(id: "dis-learn", label: "Learn More", icon: "book.fill", destination: .nextQuestion(
                TriageNode(id: "dis-learn-q", question: "What would you like to read about?", options: [
                    TriageOption(id: "dis-art-multihazard", label: "Multi-Hazard Preparedness", icon: "exclamationmark.shield.fill", destination: .article("env-article-multihazard")),
                    TriageOption(id: "dis-art-flood", label: "Flood Science", icon: "water.waves", destination: .articleList(["env-article-flood", "env-article-flash-flood-science"])),
                    TriageOption(id: "dis-art-wildfire", label: "Wildfire Behavior", icon: "flame", destination: .article("env-article-wildfire-behavior")),
                    TriageOption(id: "dis-art-urban", label: "Urban Disaster Survival", icon: "building.2.fill", destination: .article("env-article-urban-disaster")),
                    TriageOption(id: "dis-art-mountain", label: "Mountain Hazards", icon: "mountain.2.fill", destination: .article("env-article-mountain")),
                    TriageOption(id: "dis-art-altitude", label: "Altitude Sickness", icon: "arrow.up.to.line", destination: .article("env-article-altitude")),
                    TriageOption(id: "dis-art-climate", label: "Climate & Weather Patterns", icon: "cloud.sun.fill", destination: .article("env-article-climate")),
                    TriageOption(id: "dis-art-desert", label: "Desert Survival Guide", icon: "sun.max.fill", destination: .article("env-article-desert")),
                    TriageOption(id: "dis-art-jungle", label: "Jungle Survival", icon: "leaf.fill", destination: .articleList(["env-article-jungle", "env-article-jungle-medicine"])),
                    TriageOption(id: "dis-art-ocean", label: "Ocean Hazards", icon: "water.waves", destination: .article("env-article-ocean")),
                    TriageOption(id: "dis-art-cave", label: "Cave Safety", icon: "mountain.2.circle.fill", destination: .article("env-article-cave-guide")),
                    TriageOption(id: "dis-art-arctic", label: "Arctic Conditions", icon: "snowflake", destination: .article("env-article-arctic"))
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
                            TriageOption(id: "food-berry-no", label: "No / Unsure", icon: "questionmark.circle", destination: .technique("food-universal-edibility")),
                            TriageOption(id: "food-poison-symp", label: "Poisoning Symptoms?", icon: "exclamationmark.triangle.fill", destination: .technique("food-article-plant-poisoning")) // Added orphan
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
                    TriageOption(id: "food-cattail", label: "Cattails (Wetland)", icon: "drop.fill", destination: .technique("food-cattail")),
                    TriageOption(id: "food-seaweed", label: "Seaweed / Coastal", icon: "water.waves", destination: .technique("food-seaweed"))
                ])
            )),

            // --- HUNTING / TRAPPING ---
            TriageOption(id: "food-hunt", label: "Hunting & Trapping", icon: "hare.fill", destination: .nextQuestion(
                TriageNode(id: "food-hunt-method", question: "What method?", options: [
                    TriageOption(id: "food-trap-land", label: "Passive Trapping (Snares)", icon: "circle", destination: .technique("food-snare")),
                    TriageOption(id: "food-trap-trigger", label: "Active Triggers (Deadfall)", icon: "triangle.fill", destination: .techniqueList(["food-deadfall-trap", "tools-figure4-deadfall"])), // Added orphan
                    TriageOption(id: "food-spear", label: "Spear Hunting", icon: "pencil.line", destination: .technique("food-fish-spear")),
                    TriageOption(id: "food-bird", label: "Bird Trap (Ojibwa)", icon: "bird.fill", destination: .techniqueList(["food-bird-trap", "food-bird-snare"])), // Added orphan
                    TriageOption(id: "food-insects", label: "Insects / Grubs", icon: "ant.fill", destination: .technique("food-insect-eating"))
                ])
            )),

            // --- FISHING ---
            TriageOption(id: "food-fish", label: "Fishing", icon: "fish.fill", destination: .nextQuestion(
                TriageNode(id: "food-fish-q", question: "What gear do you have?", options: [
                    TriageOption(id: "food-fish-hook", label: "Hooks / Line", icon: "pencil.slash", destination: .technique("food-hook-line")),
                    TriageOption(id: "food-fish-spear", label: "Spear / Sharp Stick", icon: "pencil.line", destination: .technique("food-fish-spear")),
                    TriageOption(id: "food-fish-trap", label: "Fish Trap / Basket", icon: "square.grid.3x3.fill", destination: .technique("food-fish-trap")),
                    TriageOption(id: "food-crayfish-trap", label: "Crayfish / Crawdad Trap", icon: "circle.grid.cross.fill", destination: .technique("food-crayfish-trap")), // Added orphan
                    TriageOption(id: "food-fish-hand", label: "Nothing (Hand Fishing)", icon: "hand.raised.fill", destination: .technique("food-fish-spear"))
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
                            TriageOption(id: "food-clean-bird", label: "Bird (Pheasant, Duck)", icon: "bird.fill", destination: .technique("food-animal-skinning")),
                            TriageOption(id: "food-clean-fish", label: "Fish", icon: "fish.fill", destination: .technique("food-cooking-fire"))
                        ])
                    )),
                    TriageOption(id: "food-cook-fire", label: "Cook on Fire", icon: "flame", destination: .nextQuestion(
                        TriageNode(id: "food-cook-method", question: "Best method for your food?", options: [
                            TriageOption(id: "food-cook-spit", label: "Roast on Stick / Spit", icon: "flame", destination: .technique("food-cooking-fire")),
                            TriageOption(id: "food-cook-boil", label: "Boil in Container", icon: "drop.fill", destination: .techniqueList(["food-bone-broth", "food-pine-needle-tea"])), // Added orphan
                            TriageOption(id: "food-cook-earth", label: "Underground (Earth Oven)", icon: "circle.fill", destination: .technique("food-earth-oven")),
                            TriageOption(id: "food-cook-rocks", label: "Hot Rocks (No Container)", icon: "triangle.fill", destination: .technique("food-earth-oven"))
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
                            TriageOption(id: "shelter-temp-warmth", label: "Maximum Warmth", icon: "flame", destination: .nextQuestion(
                                TriageNode(id: "shelter-temp-warmth-q", question: "How cold is it?", options: [
                                    TriageOption(id: "shelter-temp-freeze", label: "Below Freezing", icon: "thermometer.snowflake", destination: .techniqueList(["shelter-debris-aframe", "firstaid-frostbite"])), // Added orphan
                                    TriageOption(id: "shelter-temp-chilly", label: "Chilly (40-50°F)", icon: "thermometer.medium", destination: .techniqueList(["shelter-debris-round", "firstaid-hypothermia-treatment"])), // Added orphan
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
                                    TriageOption(id: "shelter-cold-hours", label: "2+ Hours", icon: "clock.fill", destination: .techniqueList(["shelter-quinzhee", "shelter-snow-cave"])), // Added orphan
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
                            TriageOption(id: "shelter-wet-platform", label: "Build Raised Platform", icon: "rectangle.stack.fill", destination: .techniqueList(["shelter-raised-platform", "shelter-tree-platform"])), // Added orphan
                            TriageOption(id: "shelter-wet-swamp", label: "Swamp Bed (Quick)", icon: "bed.double.fill", destination: .techniqueList(["shelter-swamp-bed", "env-swamp-movement"])) // Added orphan
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
                    TriageOption(id: "shelter-urban-vehicle", label: "Vehicle Available", icon: "car.fill", destination: .techniqueList(["shelter-vehicle", "shelter-parachute"])), // Added orphan
                    TriageOption(id: "shelter-urban-outside", label: "Outside — Exposed", icon: "cloud.rain.fill", destination: .nextQuestion(
                        TriageNode(id: "shelter-urban-out-q", question: "What can you find?", options: [
                            TriageOption(id: "shelter-urban-card", label: "Cardboard / Plastic", icon: "doc.fill", destination: .technique("shelter-emergency-bivy")),
                            TriageOption(id: "shelter-urban-tarp", label: "Tarp / Sheet", icon: "square.fill", destination: .technique("shelter-tarp-leanto")),
                            TriageOption(id: "shelter-urban-zero", label: "Nothing", icon: "xmark.circle.fill", destination: .technique("shelter-mylar-wrap"))
                        ])
                    ))
                ])
            )),

            // Shelter Improvements
            TriageOption(id: "shelter-improve", label: "Improve Existing Shelter", icon: "wrench.fill", destination: .nextQuestion(
                TriageNode(id: "shelter-imp-q", question: "What improvement?", options: [
                    TriageOption(id: "shelter-imp-door", label: "Build a Door / Entrance", icon: "door.left.hand.closed", destination: .technique("shelter-door-construction")),
                    TriageOption(id: "shelter-imp-vent", label: "Ventilation", icon: "wind", destination: .technique("shelter-ventilation")),
                    TriageOption(id: "shelter-imp-water", label: "Waterproofing", icon: "drop.fill", destination: .technique("shelter-waterproofing")),
                    TriageOption(id: "shelter-imp-fire-ref", label: "Fire Reflector Wall", icon: "flame", destination: .technique("shelter-fire-reflector")),
                    TriageOption(id: "shelter-imp-heated", label: "Heated Bed / Platform", icon: "flame", destination: .technique("shelter-heated-bed")),
                    TriageOption(id: "shelter-imp-snow-wall", label: "Snow Wall / Windbreak", icon: "square.stack.fill", destination: .technique("shelter-snow-wall")),
                    TriageOption(id: "shelter-imp-camo", label: "Camouflage / Concealment", icon: "eye.slash.fill", destination: .technique("shelter-camouflage"))
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
                            TriageOption(id: "an-black-unseen", label: "No — Back Away", icon: "eye.slash.fill", destination: .technique("env-bear-black-avoid"))
                        ])
                    )),
                    TriageOption(id: "an-bear-grizzly", label: "Grizzly / Brown Bear", icon: "pawprint.fill", destination: .nextQuestion(
                        TriageNode(id: "an-bear-griz-q", question: "Is it attacking?", options: [
                            TriageOption(id: "an-griz-attack", label: "Yes — Play Dead", icon: "exclamationmark.triangle.fill", destination: .technique("env-bear-grizzly")),
                            TriageOption(id: "an-griz-calm", label: "No — Back Away Slowly", icon: "figure.walk", destination: .technique("env-bear-grizzly-avoid"))
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
                            TriageOption(id: "an-snake-tri", label: "Triangular / Diamond (Venomous)", icon: "triangle.fill", destination: .technique("env-snake-avoid")),
                            TriageOption(id: "an-snake-round", label: "Round / Oval (Likely Safe)", icon: "circle.fill", destination: .technique("env-snake-avoid")),
                            TriageOption(id: "an-snake-unk", label: "Unknown / Hidden", icon: "questionmark.circle", destination: .technique("env-snake-avoid"))
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
            TriageOption(id: "an-reptile", label: "Croc / Alligator", icon: "scribble.variable", destination: .nextQuestion(
                TriageNode(id: "an-rep-q", question: "Situation?", options: [
                    TriageOption(id: "an-gator-see", label: "See one nearby", icon: "eye.fill", destination: .technique("env-alligator")),
                    TriageOption(id: "an-gator-attack", label: "Attack / Chase", icon: "exclamationmark.triangle.fill", destination: .technique("env-alligator"))
                ])
            )),

            // --- BUGS ---
            TriageOption(id: "an-bugs", label: "Insects / Spiders / Scorpions", icon: "ant.fill", destination: .nextQuestion(
                TriageNode(id: "an-bug-q", question: "What happened?", options: [
                    TriageOption(id: "an-bee", label: "Stung (Bee/Wasp)", icon: "ant.fill", destination: .technique("firstaid-sting-treat")),
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
            )),

            // --- ENVIRONMENT HAZARDS ---
            TriageOption(id: "an-env-hazard", label: "Environment Hazards", icon: "globe.americas.fill", destination: .nextQuestion(
                TriageNode(id: "an-env-q", question: "What environment?", options: [
                    TriageOption(id: "an-tropical", label: "Tropical Disease Risk", icon: "ladybug.fill", destination: .technique("env-tropical-disease")),
                    TriageOption(id: "an-desert", label: "Desert Hazards", icon: "sun.max.fill", destination: .nextQuestion(
                        TriageNode(id: "an-desert-q", question: "What do you need?", options: [
                            TriageOption(id: "an-desert-travel", label: "Desert Travel", icon: "figure.walk", destination: .technique("env-desert-travel")),
                            TriageOption(id: "an-desert-night", label: "Night Travel", icon: "moon.fill", destination: .technique("env-desert-night-travel")),
                            TriageOption(id: "an-desert-shelter", label: "Desert Shelter", icon: "tent.fill", destination: .technique("env-desert-shelter")),
                            TriageOption(id: "an-desert-water", label: "Finding Water", icon: "drop.fill", destination: .technique("env-desert-water"))
                        ])
                    )),
                    TriageOption(id: "an-jungle", label: "Jungle Hazards", icon: "tree.fill", destination: .nextQuestion(
                        TriageNode(id: "an-jungle-q", question: "What do you need?", options: [
                            TriageOption(id: "an-jungle-move", label: "Jungle Movement", icon: "figure.walk", destination: .technique("env-jungle-movement")),
                            TriageOption(id: "an-jungle-travel", label: "Jungle Travel", icon: "arrow.right", destination: .technique("env-jungle-travel")),
                            TriageOption(id: "an-jungle-shelter", label: "Jungle Shelter", icon: "tent.fill", destination: .technique("env-jungle-shelter")),
                            TriageOption(id: "an-jungle-water", label: "Jungle Water Sources", icon: "drop.fill", destination: .technique("env-jungle-water"))
                        ])
                    )),
                    TriageOption(id: "an-arctic", label: "Arctic Shelter & Survival", icon: "snowflake", destination: .technique("env-arctic-shelter"))
                ])
            )),

            // 📚 LEARN MORE
            TriageOption(id: "animal-learn", label: "Learn More", icon: "book.fill", destination: .nextQuestion(
                TriageNode(id: "animal-learn-q", question: "What would you like to read about?", options: [
                    TriageOption(id: "animal-art-bites", label: "Bites & Envenomation", icon: "ant.fill", destination: .article("firstaid-article-bites")),
                    TriageOption(id: "animal-art-jungle", label: "Jungle Medicine", icon: "leaf.fill", destination: .article("env-article-jungle-medicine")),
                    TriageOption(id: "animal-art-desert", label: "Desert Hazards", icon: "sun.max.fill", destination: .article("env-article-desert")),
                    TriageOption(id: "animal-art-ocean", label: "Ocean Wildlife", icon: "water.waves", destination: .article("env-article-ocean")),
                    TriageOption(id: "animal-art-mountain", label: "Mountain Wildlife", icon: "mountain.2.fill", destination: .article("env-article-mountain")),
                    TriageOption(id: "animal-art-env-emerg", label: "Environmental Emergencies", icon: "exclamationmark.triangle.fill", destination: .articleList(["firstaid-article-environmental", "firstaid-article-environmental-emergencies"]))
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
                            TriageOption(id: "wet-drown-throw", label: "Can Throw Rope / Object", icon: "arrow.right", destination: .techniqueList(["rescue-throw-bag", "rescue-throw-line"])), // Added orphan
                            TriageOption(id: "wet-drown-far", label: "Far — Need to Swim Out", icon: "figure.pool.swim", destination: .technique("rescue-improvised-flotation")),
                            TriageOption(id: "wet-drown-child", label: "Child / Non-Swimmer", icon: "exclamationmark.triangle.fill", destination: .technique("rescue-throw-bag")),
                            TriageOption(id: "wet-drown-rescue-tech", label: "After Rescue / Recovery", icon: "cross.fill", destination: .techniqueList(["firstaid-drowning-rescue", "firstaid-drowning"])) // Added orphans
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
                            TriageOption(id: "wet-river-calm", label: "Current but No Rapids", icon: "water.waves", destination: .techniqueList(["rescue-river-self", "nav-river-navigation"])), // Added orphan
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
            )),

            // --- OCEAN SURVIVAL (Adrift) ---
            TriageOption(id: "wet-ocean", label: "Adrift at Sea / Open Water", icon: "globe.americas.fill", destination: .technique("env-ocean-survival")),

            // --- ADVANCED SIGNALING FROM WATER ---
            TriageOption(id: "wet-signal-adv", label: "Advanced Signaling", icon: "antenna.radiowaves.left.and.right", destination: .nextQuestion(
                TriageNode(id: "wet-sig-q", question: "What signaling method?", options: [
                    TriageOption(id: "wet-sig-night", label: "Night Signaling", icon: "moon.fill", destination: .technique("rescue-night-signaling")),
                    TriageOption(id: "wet-sig-sat", label: "Satellite Messenger / PLB", icon: "antenna.radiowaves.left.and.right", destination: .technique("rescue-satellite-messenger")),
                    TriageOption(id: "wet-sig-vhf", label: "VHF Radio", icon: "radio.fill", destination: .technique("rescue-vhf-radio")),
                    TriageOption(id: "wet-sig-drone", label: "Drone Awareness", icon: "airplane", destination: .technique("rescue-drone-awareness")),
                    TriageOption(id: "wet-sig-heli", label: "Helicopter Approaching", icon: "helicopter", destination: .techniqueList(["rescue-helicopter", "rescue-helicopter-approach"])),
                    TriageOption(id: "wet-sig-kite", label: "Signal Kite", icon: "wind", destination: .technique("rescue-signal-kite")),
                    TriageOption(id: "wet-sig-panel", label: "Signal Panel", icon: "square.fill", destination: .technique("rescue-signal-panel")),
                    TriageOption(id: "wet-sig-smoke-opt", label: "Smoke Timing", icon: "smoke.fill", destination: .technique("rescue-smoke-timing")),
                    TriageOption(id: "wet-sig-gps", label: "GPS Reading", icon: "location.fill", destination: .technique("rescue-gps-reading")),
                    TriageOption(id: "wet-sig-cliff", label: "Cliff / Elevated Signals", icon: "mountain.2.fill", destination: .technique("rescue-cliff-signals"))
                ])
            )),

            // 📚 LEARN MORE
            TriageOption(id: "wet-learn", label: "Learn More", icon: "book.fill", destination: .nextQuestion(
                TriageNode(id: "wet-learn-q", question: "What would you like to read about?", options: [
                    TriageOption(id: "wet-art-signaling", label: "Signaling Science", icon: "antenna.radiowaves.left.and.right", destination: .articleList(["rescue-article-signaling", "rescue-article-signaling-science"])),
                    TriageOption(id: "wet-art-water-rescue", label: "Water Rescue Principles", icon: "figure.water.fitness", destination: .articleList(["rescue-article-water-rescue", "rescue-article-water-principles"])),
                    TriageOption(id: "wet-art-search", label: "Search & Rescue Ops", icon: "binoculars.fill", destination: .article("rescue-article-search")),
                    TriageOption(id: "wet-art-group", label: "Group Rescue", icon: "person.3.fill", destination: .article("rescue-article-group-rescue")),
                    TriageOption(id: "wet-art-night", label: "Night Rescue", icon: "moon.fill", destination: .article("rescue-article-night-rescue")),
                    TriageOption(id: "wet-art-phone", label: "Emergency Phone Use", icon: "phone.fill", destination: .article("rescue-article-phone")),
                    TriageOption(id: "wet-art-plb", label: "PLB & Emergency Beacons", icon: "antenna.radiowaves.left.and.right", destination: .article("rescue-article-plb")),
                    TriageOption(id: "wet-art-selfrescue", label: "Self-Rescue Navigation", icon: "location.fill", destination: .article("rescue-article-self-rescue-nav")),
                    TriageOption(id: "wet-art-timing", label: "Rescue Timing", icon: "clock.fill", destination: .article("rescue-article-timing")),
                    TriageOption(id: "wet-art-radio", label: "Radio Communication", icon: "radio.fill", destination: .article("rescue-article-radio")),
                    TriageOption(id: "wet-art-ocean", label: "Ocean Survival Guide", icon: "water.waves", destination: .article("water-article-oceansurv"))
                ])
            ))
        ])
    }

    // =========================================================================
    // MARK: - EXTREME HEAT (NEW)
    // =========================================================================
    private func buildHeatTriage() -> TriageNode {
        TriageNode(id: "heat-em-root", question: "What is the heat emergency?", options: [
            TriageOption(id: "heat-illness", label: "Feeling Sick / Dizzy", icon: "thermometer.sun.fill", destination: .nextQuestion(
                TriageNode(id: "heat-illness-q", question: "Symptoms?", options: [
                    TriageOption(id: "heat-exhaustion", label: "Heavy Sweating / Pale / Weak", icon: "drop.fill", destination: .technique("firstaid-heat-exhaustion")),
                    TriageOption(id: "heat-stroke", label: "Hot Dry Skin / Confusion / No Sweat", icon: "exclamationmark.triangle.fill", destination: .technique("firstaid-heatstroke")),
                    TriageOption(id: "heat-cramps", label: "Muscle Cramps / Spasms", icon: "bolt.fill", destination: .technique("firstaid-heat-cramps"))
                ])
            )),
            TriageOption(id: "heat-burn", label: "Sunburn / Burns", icon: "flame", destination: .nextQuestion(
                TriageNode(id: "heat-burn-q", question: "Severity?", options: [
                    TriageOption(id: "heat-sunburn", label: "Red / Painful (Sunburn)", icon: "sun.max.fill", destination: .technique("firstaid-sunburn")),
                    TriageOption(id: "heat-burn-blister", label: "Blistered / Charred", icon: "flame", destination: .technique("firstaid-burn-treat"))
                ])
            )),
            TriageOption(id: "heat-water", label: "Dehydration / No Water", icon: "drop.triangle.fill", destination: .technique("firstaid-dehydration")),
            
            // Learn More
            TriageOption(id: "heat-learn", label: "Learn More", icon: "book.fill", destination: .nextQuestion(
                TriageNode(id: "heat-learn-q", question: "Read about heat safety?", options: [
                    TriageOption(id: "heat-art-illness", label: "Heat Illnesses", icon: "thermometer.sun.fill", destination: .article("firstaid-article-heat-illness")),
                    TriageOption(id: "heat-art-water", label: "Water Needs", icon: "drop.fill", destination: .article("water-article-needs"))
                ])
            ))
        ])
    }

    // =========================================================================
    // MARK: - HUMAN THREAT (NEW)
    // =========================================================================
    private func buildHumanThreatTriage() -> TriageNode {
        TriageNode(id: "human-em-root", question: "What is the threat?", options: [
            TriageOption(id: "human-active", label: "Active Attacker / Pursuer", icon: "figure.run", destination: .nextQuestion(
                TriageNode(id: "human-active-q", question: "Can you escape?", options: [
                    TriageOption(id: "human-run", label: "Yes — Run / Evade", icon: "figure.run", destination: .technique("psych-evasion")),
                    TriageOption(id: "human-hide", label: "No — Need to Hide", icon: "eye.slash.fill", destination: .technique("shelter-camouflage")),
                    TriageOption(id: "human-fight", label: "Cornered — Self Defense", icon: "hand.raised.slash.fill", destination: .technique("psych-conflict-resolution")) 
                ])
            )),
            TriageOption(id: "human-riot", label: "Civil Unrest / Riot", icon: "person.3.fill", destination: .nextQuestion(
                TriageNode(id: "human-riot-q", question: "Location?", options: [
                    TriageOption(id: "human-riot-street", label: "On the Street", icon: "road.lanes", destination: .technique("psych-gray-man")),
                    TriageOption(id: "human-riot-car", label: "In a Vehicle", icon: "car.fill", destination: .technique("env-vehicle-escape")), // Placeholder
                    TriageOption(id: "human-riot-home", label: "At Home", icon: "house.fill", destination: .technique("shelter-barricade")) // Placeholder
                ])
            )),
            TriageOption(id: "human-stalk", label: "Being Followed", icon: "eye.fill", destination: .technique("psych-antisurveillance")), // Placeholder
            
            // Learn More
            TriageOption(id: "human-learn", label: "Learn More", icon: "book.fill", destination: .nextQuestion(
                TriageNode(id: "human-learn-q", question: "Security topics?", options: [
                    TriageOption(id: "human-art-psych", label: "Survival Psychology", icon: "brain.head.profile", destination: .article("psych-article-mindset")),
                    TriageOption(id: "human-art-sit", label: "Situational Awareness", icon: "eye.fill", destination: .article("psych-article-awareness"))
                ])
            ))
        ])
    }

    // =========================================================================
    // MARK: - VEHICLE EMERGENCY (NEW)
    // =========================================================================
    private func buildVehicleTriage() -> TriageNode {
        TriageNode(id: "vehicle-em-root", question: "What happened to the vehicle?", options: [
            TriageOption(id: "veh-crash", label: "Crash / Impact", icon: "car.side.fill", destination: .nextQuestion(
                TriageNode(id: "veh-crash-q", question: "Are you trapped?", options: [
                    TriageOption(id: "veh-trap-yes", label: "Yes — Trapped Inside", icon: "lock.fill", destination: .technique("env-vehicle-escape")),
                    TriageOption(id: "veh-trap-water", label: "Submerged in Water", icon: "water.waves", destination: .technique("env-vehicle-water-escape")), // Placeholder
                    TriageOption(id: "veh-trap-no", label: "No — Outside Vehicle", icon: "figure.walk", destination: .technique("firstaid-scene-safety"))
                ])
            )),
            TriageOption(id: "veh-breakdown", label: "Stranded / Breakdown", icon: "exclamationmark.triangle.fill", destination: .nextQuestion(
                TriageNode(id: "veh-break-q", question: "Environment?", options: [
                    TriageOption(id: "veh-break-winter", label: "Winter / Snow", icon: "snowflake", destination: .technique("env-winter-car-kit")), // Placeholder
                    TriageOption(id: "veh-break-desert", label: "Desert / Heat", icon: "sun.max.fill", destination: .technique("env-desert-travel")), // Reuse desert
                    TriageOption(id: "veh-break-remote", label: "Remote Area", icon: "tree.fill", destination: .technique("rescue-signal-mirror"))
                ])
            )),
            TriageOption(id: "veh-fuel", label: "Out of Fuel", icon: "fuelpump.fill", destination: .technique("rescue-signal-fire")),
            
            // Learn More
            TriageOption(id: "veh-learn", label: "Learn More", icon: "book.fill", destination: .nextQuestion(
                TriageNode(id: "veh-learn-q", question: "Vehicle safety topics?", options: [
                    TriageOption(id: "veh-art-kit", label: "Vehicle Kits", icon: "case.fill", destination: .article("tools-article-vehicle-kit")), // Placeholder
                    TriageOption(id: "veh-art-signal", label: "Signaling", icon: "antenna.radiowaves.left.and.right", destination: .article("rescue-article-visual"))
                ])
            ))
        ])
    }

    // =========================================================================
    // MARK: - CHEMICAL / HAZMAT (NEW)
    // =========================================================================
    private func buildChemicalTriage() -> TriageNode {
        TriageNode(id: "chem-em-root", question: "What is the exposure?", options: [
            TriageOption(id: "chem-air", label: "Airborne Gas / Smoke", icon: "wind", destination: .nextQuestion(
                TriageNode(id: "chem-air-q", question: "Can you evacuate?", options: [
                    TriageOption(id: "chem-run", label: "Yes — Move Crosswind", icon: "arrow.up.right", destination: .technique("env-hazmat-evac")), // Placeholder
                    TriageOption(id: "chem-shelter", label: "No — Shelter in Place", icon: "house.fill", destination: .technique("shelter-seal-room")) // Placeholder
                ])
            )),
            TriageOption(id: "chem-contact", label: "Skin Contact / Spill", icon: "drop.fill", destination: .nextQuestion(
                TriageNode(id: "chem-skin-q", question: "What substance?", options: [
                    TriageOption(id: "chem-acid", label: "Acid / Corrosive", icon: "exclamationmark.triangle.fill", destination: .technique("firstaid-chem-burn")),
                    TriageOption(id: "chem-unk", label: "Unknown Powder/Liquid", icon: "questionmark.circle", destination: .technique("firstaid-decon")) // Placeholder
                ])
            )),
            TriageOption(id: "chem-radio", label: "Radiation / Nuclear", icon: "atom", destination: .technique("env-nuclear-fallout")), // Placeholder
            
            // Learn More
            TriageOption(id: "chem-learn", label: "Learn More", icon: "book.fill", destination: .nextQuestion(
                TriageNode(id: "chem-learn-q", question: "Hazmat safety topics?", options: [
                    TriageOption(id: "chem-art-decon", label: "Decontamination", icon: "shower.fill", destination: .article("firstaid-article-decon")), // Placeholder
                    TriageOption(id: "chem-art-shelter", label: "Sheltering in Place", icon: "house.fill", destination: .article("shelter-article-home")) // Placeholder
                ])
            ))
        ])
    }
}
