
import Foundation

// Exact match of app's structs
enum SurvivalDomain: String, Codable {
    case fire, shelter, water, navigation, firstaid, food, rescue, psychology, environments, tools
    case advanced_firstaid, advanced_tools, advanced_environments
    case expanded_firstaid, expanded_environments, hacks_general, rebuilding_civilization
    case missing_firstaid, missing_environments, missing_psychology, missing_shelter
}

struct TechniqueStep: Codable, Identifiable {
    var id: String { "\(stepNumber)" }
    let stepNumber: Int
    let instruction: String
    let helpDetail: String?
    let illustrationDescription: String?
}

struct Technique: Identifiable, Codable {
    let id: String
    var domain: SurvivalDomain?
    let name: String
    let subtitle: String
    let category: String
    let difficulty: Int
    let estimatedTime: String
    let hasHapticGuide: Bool?
    let hapticType: String?
    let steps: [TechniqueStep]
    let relatedIds: [String]?
    let sourceName: String?
    let sourceUrl: String?
}

struct Article: Identifiable, Codable {
    let id: String
    var domain: SurvivalDomain?
    let title: String
    let body: String
    let relatedTechniqueIDs: [String]?
    let sourceName: String?
    let sourceUrl: String?
}

struct DomainContent: Codable {
    let domain: String
    let domainDisplayName: String
    let techniques: [Technique]
    let articles: [Article]?
    
    enum CodingKeys: String, CodingKey {
        case domain, domainDisplayName, techniques, articles
    }
}

let data = try! Data(contentsOf: URL(fileURLWithPath: "Sources/Resources/psychology.json"))
do {
    let decoded = try JSONDecoder().decode(DomainContent.self, from: data)
    print("SUCCESS: Loaded \(decoded.techniques.count) psychology techniques")
} catch {
    print("ERROR: \(error)")
}
