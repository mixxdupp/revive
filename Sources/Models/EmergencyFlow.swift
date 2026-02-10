import Foundation
import SwiftUI

// MARK: - Emergency Situations

enum EmergencySituation: String, Codable, CaseIterable, Identifiable {
    case cold, noFire, noWater, hurt, lost, trapped, disaster
    
    var id: String { rawValue }
    
    var displayName: String {
        switch self {
        case .cold: return "Cold / Hypothermia"
        case .noFire: return "Need Fire"
        case .noWater: return "Need Water"
        case .hurt: return "First Aid / Injury"
        case .lost: return "Lost / Navigation"
        case .trapped: return "Trapped / Rescue"
        case .disaster: return "Natural Disaster"
        }
    }
    
    var icon: String {
        switch self {
        case .cold: return "thermometer.snowflake"
        case .noFire: return "flame.fill"
        case .noWater: return "drop.fill"
        case .hurt: return "cross.case.fill"
        case .lost: return "location.fill"
        case .trapped: return "exclamationmark.triangle.fill"
        case .disaster: return "tornado"
        }
    }
    
    var color: Color {
        switch self {
        case .cold: return .cyan
        case .noFire: return .orange
        case .noWater: return .indigo
        case .hurt: return .red
        case .lost: return .gray
        case .trapped: return .yellow
        case .disaster: return .purple
        }
    }
}

// MARK: - Recursive Triage Tree

/// A single node in the triage decision tree.
/// Each node presents a question with multiple options.
struct TriageNode: Identifiable {
    let id: String
    let question: String
    let options: [TriageOption]
}

/// Where a triage option leads: another question, a single technique, or a list of techniques.
enum TriageDestination {
    case nextQuestion(TriageNode)
    case technique(String)        // single techniqueID
    case techniqueList([String])  // multiple techniqueIDs — user picks
}

/// A single selectable option in a triage question.
struct TriageOption: Identifiable {
    let id: String
    let label: String
    let icon: String
    let destination: TriageDestination
}

// MARK: - Legacy (kept for backward compat, unused)

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
