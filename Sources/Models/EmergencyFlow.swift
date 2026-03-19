import Foundation
import SwiftUI


enum EmergencySituation: String, Codable, CaseIterable, Identifiable {
    // Judge impression: most impressive triage flows first (top 2 rows visible without scrolling)
    case hurt, disaster, noFire, trapped, noWater
    case shelter, inWater, cold, extremeHeat, chemicalExposure
    case animal, humanThreat, lost, noFood, vehicleEmergency
    case panic, improviseGear
    
    var id: String { rawValue }
    
    var displayName: String {
        switch self {
        case .cold: return String(localized: "Cold / Hypothermia", comment: "Emergency Situation")
        case .noFire: return String(localized: "Need Fire", comment: "Emergency Situation")
        case .noWater: return String(localized: "Need Water", comment: "Emergency Situation")
        case .hurt: return String(localized: "First Aid / Injury", comment: "Emergency Situation")
        case .lost: return String(localized: "Lost / Navigation", comment: "Emergency Situation")
        case .trapped: return String(localized: "Trapped / Rescue", comment: "Emergency Situation")
        case .disaster: return String(localized: "Natural Disaster", comment: "Emergency Situation")
        case .noFood: return String(localized: "Need Food", comment: "Emergency Situation")
        case .animal: return String(localized: "Animal Encounter", comment: "Emergency Situation")
        case .inWater: return String(localized: "In Water", comment: "Emergency Situation")
        case .shelter: return String(localized: "Need Shelter", comment: "Emergency Situation")
        case .extremeHeat: return String(localized: "Extreme Heat", comment: "Emergency Situation")
        case .humanThreat: return String(localized: "Human Threat", comment: "Emergency Situation")
        case .vehicleEmergency: return String(localized: "Vehicle Emergency", comment: "Emergency Situation")
        case .chemicalExposure: return String(localized: "Chemical / Hazmat", comment: "Emergency Situation")
        case .panic: return String(localized: "Panic / Mindset", comment: "Emergency Situation")
        case .improviseGear: return String(localized: "Improvised Gear", comment: "Emergency Situation")
        }
    }
    
    var icon: String {
        switch self {
        case .cold: return "thermometer.snowflake"
        case .noFire: return "flame"
        case .noWater: return "drop.fill"
        case .hurt: return "cross.case.fill"
        case .lost: return "location.fill"
        case .trapped: return "exclamationmark.triangle.fill"
        case .disaster: return "tornado"
        case .noFood: return "fork.knife"
        case .animal: return "pawprint.fill"
        case .inWater: return "figure.water.fitness"
        case .shelter: return "tent.fill"
        case .extremeHeat: return "sun.max.fill"
        case .humanThreat: return "figure.run"
        case .vehicleEmergency: return "car.fill"
        case .chemicalExposure: return "burn"
        case .panic: return "brain.head.profile"
        case .improviseGear: return "hammer.fill"
        }
    }
    
    var color: Color {
        switch self {
        case .cold: return DesignSystem.coldTile
        case .noFire: return DesignSystem.fireDomain
        case .noWater: return DesignSystem.waterDomain
        case .hurt: return DesignSystem.firstAidDomain
        case .lost: return DesignSystem.navigationDomain
        case .trapped: return DesignSystem.rescueDomain
        case .disaster: return DesignSystem.disasterTile
        case .noFood: return DesignSystem.foodDomain
        case .animal: return DesignSystem.animalTile
        case .inWater: return DesignSystem.inWaterTile
        case .shelter: return DesignSystem.shelterDomain
        case .extremeHeat: return DesignSystem.heatTile
        case .humanThreat: return DesignSystem.threatTile
        case .vehicleEmergency: return DesignSystem.vehicleTile
        case .chemicalExposure: return DesignSystem.chemicalTile
        case .panic: return DesignSystem.psychologyDomain
        case .improviseGear: return DesignSystem.toolsDomain
        }
    }
}


/// A single node in the triage decision tree.
/// Each node presents a question with multiple options.
struct TriageNode: Identifiable {
    let id: String
    let question: String
    let options: [TriageOption]
}

/// Confidence level of a leaf's technique recommendation.
/// Used by the agent to modulate tone, urgency, and presentation.
enum TriageLeafConfidence: String {
    case highCertaintySingle      // Exactly 1 canonical action — present with full confidence
    case rankedPrimaryBackup      // Primary + 1-2 ranked alternatives — present primary, offer fallbacks
    case complexContextual        // 3+ context-dependent options — present ranked, invite user assessment
}

/// Role of a technique within a ranked leaf.
enum TriageTechniqueRole: String {
    case primary       // First-line action — do this first
    case adjunct       // Complementary to primary — do alongside
    case escalation    // Use if primary insufficient — step up
    case contextual    // Context-dependent alternative — choose based on situation
}

/// A technique with its clinical role annotation.
struct RankedTechnique {
    let id: String
    let role: TriageTechniqueRole
}

/// Where a triage option leads: another question, a single technique, or a list of techniques.
enum TriageDestination {
    case nextQuestion(TriageNode)
    case technique(String)        // single techniqueID
    case techniqueList([String])  // multiple techniqueIDs — user picks
    case rankedTechniqueList([RankedTechnique], confidence: TriageLeafConfidence) // V20: role-annotated
    case article(String)          // single articleID — "Learn More" link
    case articleList([String])    // multiple articleIDs — reference reading
}

/// A single selectable option in a triage question.
struct TriageOption: Identifiable {
    let id: String
    let label: String
    let icon: String
    let destination: TriageDestination
}


struct EmergencyFlow: Codable, Identifiable {
    var id: String { situation.rawValue }
    let situation: EmergencySituation
    let question: String
    let options: [EmergencyOption]
    let subFlows: [String: EmergencySubFlow]?
}

struct EmergencySubFlow: Codable {
    let question: String
    let options: [EmergencyOption]
}

struct EmergencyOption: Codable, Identifiable {
    var id: String { label + techniqueID }
    let label: String
    let icon: String
    let techniqueID: String
}
