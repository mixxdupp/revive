import Foundation

struct SurvivalDomain: Codable {
    // Enum mock to match string or whatever
}

// Full structs from app
struct Technique: Codable {
    let id: String
    let category: String
    let name: String
    let subtitle: String
    let difficulty: Int
    let steps: [TechniqueStep]
    let hasHapticGuide: Bool
    let hapticType: HapticType?
    let estimatedTime: String?
    let relatedIds: [String]?
}

enum HapticType: String, Codable {
    case cprRhythm, fireTempo, breathingPacer
}

struct TechniqueStep: Codable {
    let stepNumber: Int
    let instruction: String
    let helpDetail: String
    let illustrationName: String?
    let illustrationDescription: String?
}

struct Article: Codable {
    let id: String
    let title: String
    let body: String
    let relatedTechniqueIDs: [String]?
}

struct DomainContent: Codable {
    let domain: String
    let techniques: [Technique]
    let articles: [Article]
}

let url = URL(fileURLWithPath: "/Users/adithya/Documents/Revive.swiftpm/Sources/Resources/shelter.json")
do {
    let data = try Data(contentsOf: url)
    let decoder = JSONDecoder()
    let content = try decoder.decode(DomainContent.self, from: data)
    print("Success: \(content.domain)")
} catch let DecodingError.dataCorrupted(context) {
    print("Data corrupted: \(context)")
} catch let DecodingError.keyNotFound(key, context) {
    print("Key '\(key)' not found: \(context.debugDescription)")
    print("CodingPath: \(context.codingPath)")
} catch let DecodingError.valueNotFound(value, context) {
    print("Value '\(value)' not found: \(context.debugDescription)")
    print("CodingPath: \(context.codingPath)")
} catch let DecodingError.typeMismatch(type, context) {
    print("Type '\(type)' mismatch: \(context.debugDescription)")
    print("CodingPath: \(context.codingPath)")
} catch {
    print("Other error: \(error)")
}
