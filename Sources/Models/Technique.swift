import Foundation

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
    
    var icon: String {
        TechniqueIconMapper.icon(for: id) ?? domain.icon
    }
    
    /// Indicates life-threatening conditions requiring professional emergency services.
    var isCritical: Bool {
        Self.criticalIDs.contains(id)
    }
    
    private static let criticalIDs: Set<String> = [
        "firstaid-cpr",
        "firstaid-tourniquet",
        "firstaid-anaphylaxis",
        "firstaid-snakebite",
        "firstaid-snake-bite",
        "firstaid-shock",
        "firstaid-hypothermia",
        "firstaid-heart-attack",
        "firstaid-stroke",
        "firstaid-head-trauma",
        "firstaid-spinal-immobilization",
        "firstaid-burn-char",
        "firstaid-crush-injury",
        "firstaid-choking",
        "firstaid-drowning",
        "firstaid-drowning-rescue",
        "firstaid-electrocution",
        "firstaid-chest-seal",
        "firstaid-femur-traction"
    ]
    
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
    
    init(id: String, domain: SurvivalDomain, category: String, name: String, subtitle: String, difficulty: Int, steps: [TechniqueStep], hasHapticGuide: Bool = false, hapticType: HapticType? = nil, estimatedTime: String? = nil, relatedIds: [String]? = nil, sourceName: String? = nil, sourceUrl: String? = nil) {
        self.id = id
        self.domain = domain
        self.category = category
        self.name = name
        self.subtitle = subtitle
        self.difficulty = difficulty
        self.steps = steps
        self.hasHapticGuide = hasHapticGuide
        self.hapticType = hapticType
        self.estimatedTime = estimatedTime
        self.relatedIds = relatedIds
        self.sourceName = sourceName
        self.sourceUrl = sourceUrl
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
    
    init(stepNumber: Int, instruction: String, helpDetail: String, illustrationName: String? = nil, illustrationDescription: String? = nil) {
        self.id = UUID().uuidString
        self.stepNumber = stepNumber
        self.instruction = instruction
        self.helpDetail = helpDetail
        self.illustrationName = illustrationName
        self.illustrationDescription = illustrationDescription
    }
}
