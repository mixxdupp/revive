
import Foundation

struct Technique: Codable, Identifiable {
    let id: String
    let name: String
    let subtitle: String
    let category: String
    let difficulty: Int
    let estimatedTime: String
    let hasHapticGuide: Bool?
    let hapticType: String?
    let steps: [TechniqueStep]
    let sourceName: String?
    let sourceUrl: String?
    let relatedIds: [String]?
}

struct TechniqueStep: Codable, Identifiable {
    var id: String { "\(stepNumber)" }
    let stepNumber: Int
    let instruction: String
    let helpDetail: String?
    let illustrationDescription: String?
}

struct Article: Codable, Identifiable {
    let id: String
    let title: String
    let body: String
    let order: Int
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
            let _ = try JSONDecoder().decode(DomainContent.self, from: data)
            print("[\(file)] OK")
        } catch {
            print("[\(file)] ERROR: \(error)")
        }
    }
}
