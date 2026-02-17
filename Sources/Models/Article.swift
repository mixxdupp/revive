import Foundation

struct Article: Identifiable, Codable {
    let id: String
    var domain: SurvivalDomain
    let title: String
    let body: String
    let relatedTechniqueIDs: [String]
    let sourceName: String?
    let sourceUrl: String?
    
    enum CodingKeys: String, CodingKey {
        case id, domain, title, body, relatedTechniqueIDs, sourceName, sourceUrl
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        domain = try container.decodeIfPresent(SurvivalDomain.self, forKey: .domain) ?? .fire
        title = try container.decode(String.self, forKey: .title)
        body = try container.decode(String.self, forKey: .body)
        relatedTechniqueIDs = try container.decodeIfPresent([String].self, forKey: .relatedTechniqueIDs) ?? []
        sourceName = try container.decodeIfPresent(String.self, forKey: .sourceName)
        sourceUrl = try container.decodeIfPresent(String.self, forKey: .sourceUrl)
    }
    
    init(id: String, domain: SurvivalDomain, title: String, body: String, relatedTechniqueIDs: [String] = [], sourceName: String? = nil, sourceUrl: String? = nil) {
        self.id = id
        self.domain = domain
        self.title = title
        self.body = body
        self.relatedTechniqueIDs = relatedTechniqueIDs
        self.sourceName = sourceName
        self.sourceUrl = sourceUrl
    }
}
