import SwiftUI

enum SurvivalDomain: String, Codable, CaseIterable, Identifiable {
    case fire, shelter, water, navigation, firstAid, food, rescue, psychology, environments, tools
    
    var id: String { rawValue }
    
    var displayName: String {
        switch self {
        case .fire: return "Fire"
        case .shelter: return "Shelter"
        case .water: return "Water"
        case .navigation: return "Navigation"
        case .firstAid: return "First Aid"
        case .food: return "Food"
        case .rescue: return "Rescue"
        case .psychology: return "Psychology"
        case .environments: return "Environments"
        case .tools: return "Tools & Knots"
        }
    }
    
    var icon: String {
        switch self {
        case .fire: return "flame.fill"
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
