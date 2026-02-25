
import Foundation

// Copying necessary structs from the app EXACTLY as they are
enum SurvivalDomain: String, Codable {
    case fire, shelter, water, navigation, firstaid, food, rescue, psychology, environments, tools
    case advanced_firstaid, advanced_tools, advanced_environments
    case expanded_firstaid, expanded_environments, hacks_general, rebuilding_civilization
    case missing_firstaid, missing_environments, missing_psychology, missing_shelter
}

enum HapticType: String, Codable {
    case cprRhythm, fireTempo, breathingPacer
}

struct Technique: Identifiable, Codable {
    let id: String
    var domain: SurvivalDomain
    let category: String
    let name: String
    let subtitle: String
    let difficulty: Int
    let steps: [TechniqueStep]
    let hasHapticGuide: Bool
    let hapticType: HapticType?
    let estimatedTime: String?
    let relatedIds: [String]?
    let sourceName: String?
    let sourceUrl: String?
    
    enum CodingKeys: String, CodingKey {
        case id, domain, category, name, subtitle, difficulty, steps, hasHapticGuide, hapticType, estimatedTime, relatedIds, sourceName, sourceUrl
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        domain = try container.decodeIfPresent(SurvivalDomain.self, forKey: .domain) ?? .fire
        category = try container.decode(String.self, forKey: .category)
        name = try container.decode(String.self, forKey: .name)
        subtitle = try container.decode(String.self, forKey: .subtitle)
        difficulty = try container.decode(Int.self, forKey: .difficulty)
        steps = try container.decode([TechniqueStep].self, forKey: .steps)
        hasHapticGuide = try container.decodeIfPresent(Bool.self, forKey: .hasHapticGuide) ?? false
        hapticType = try container.decodeIfPresent(HapticType.self, forKey: .hapticType)
        estimatedTime = try container.decodeIfPresent(String.self, forKey: .estimatedTime)
        relatedIds = try container.decodeIfPresent([String].self, forKey: .relatedIds)
        sourceName = try container.decodeIfPresent(String.self, forKey: .sourceName)
        sourceUrl = try container.decodeIfPresent(String.self, forKey: .sourceUrl)
    }
}

struct TechniqueStep: Identifiable, Codable {
    let id: String
    let stepNumber: Int
    let instruction: String
    let helpDetail: String
    let illustrationName: String?
    let illustrationDescription: String?
    
    enum CodingKeys: String, CodingKey {
        case stepNumber, instruction, helpDetail, illustrationName, illustrationDescription
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = UUID().uuidString
        stepNumber = try container.decode(Int.self, forKey: .stepNumber)
        instruction = try container.decode(String.self, forKey: .instruction)
        helpDetail = try container.decode(String.self, forKey: .helpDetail)
        illustrationName = try container.decodeIfPresent(String.self, forKey: .illustrationName)
        illustrationDescription = try container.decodeIfPresent(String.self, forKey: .illustrationDescription)
    }
}

struct Article: Identifiable, Codable {
    let id: String
    var domain: SurvivalDomain
    let title: String
    let body: String
    let relatedTechniqueIDs: [String]
    let sourceName: String?
    let sourceUrl: String?
    var order: Int?
    
    enum CodingKeys: String, CodingKey {
        case id, domain, title, body, relatedTechniqueIDs, sourceName, sourceUrl, order
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
        order = try container.decodeIfPresent(Int.self, forKey: .order)
    }
}

struct DomainContent: Codable {
    let domain: String
    let domainDisplayName: String
    let techniques: [Technique]
    let articles: [Article]
}

let fm = FileManager.default
let contents = try! fm.contentsOfDirectory(atPath: "Sources/Resources")
for file in contents {
    if file.hasSuffix(".json") && file != "glossary.json" {
        let url = URL(fileURLWithPath: "Sources/Resources/\(file)")
        do {
            let data = try Data(contentsOf: url)
            let decoded = try JSONDecoder().decode(DomainContent.self, from: data)
            print("[\(file)] OK: \(decoded.techniques.count) techniques")
        } catch {
            print("[\(file)] ERROR: \(error)")
        }
    }
}
