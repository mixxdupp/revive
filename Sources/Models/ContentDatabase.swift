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
















}
