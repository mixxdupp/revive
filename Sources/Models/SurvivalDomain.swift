import SwiftUI

enum SurvivalDomain: String, Codable, CaseIterable, Identifiable {
    case fire, shelter, water, navigation, firstAid, food, rescue, psychology, environments, tools
    
    var id: String { rawValue }
    
    var displayName: String {
        switch self {
        case .fire: return String(localized: "Fire", comment: "Survival Domain")
        case .shelter: return String(localized: "Shelter", comment: "Survival Domain")
        case .water: return String(localized: "Water", comment: "Survival Domain")
        case .navigation: return String(localized: "Navigation", comment: "Survival Domain")
        case .firstAid: return String(localized: "First Aid", comment: "Survival Domain")
        case .food: return String(localized: "Food", comment: "Survival Domain")
        case .rescue: return String(localized: "Rescue", comment: "Survival Domain")
        case .psychology: return String(localized: "Psychology", comment: "Survival Domain")
        case .environments: return String(localized: "Environments", comment: "Survival Domain")
        case .tools: return String(localized: "Tools & Knots", comment: "Survival Domain")
        }
    }
    
    var icon: String {
        switch self {
        case .fire: return "flame"
        case .shelter: return "tent.fill"
        case .water: return "drop.fill"
        case .navigation: return "location.fill" // Simpler, solid
        case .firstAid: return "cross.case.fill"
        case .food: return "fork.knife" // Standard
        case .rescue: return "light.beacon.max.fill" // Solid signal beacon
        case .psychology: return "brain.head.profile" // Standard
        case .environments: return "mountain.2.fill"
        case .tools: return "hammer.fill" // Simpler tool icon
        }
    }
    
    var color: Color {
        switch self {
        case .fire: return DesignSystem.fireDomain
        case .shelter: return DesignSystem.shelterDomain
        case .water: return DesignSystem.waterDomain
        case .navigation: return DesignSystem.navigationDomain
        case .firstAid: return DesignSystem.firstAidDomain
        case .food: return DesignSystem.foodDomain
        case .rescue: return DesignSystem.rescueDomain
        case .psychology: return DesignSystem.psychologyDomain
        case .environments: return DesignSystem.environmentDomain
        case .tools: return DesignSystem.toolsDomain
        }
    }
}
