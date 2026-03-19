import SwiftUI
import UIKit

struct DesignSystem {
    // Use native iOS system colors for automatic Light/Dark mode support
    static let backgroundPrimary = Color(uiColor: .systemGroupedBackground)
    static let backgroundSecondary = Color(uiColor: .secondarySystemGroupedBackground) // Cards
    static let backgroundTertiary = Color(uiColor: .tertiarySystemGroupedBackground)
    
    static let textPrimary = Color(uiColor: .label)
    static let textSecondary = Color(uiColor: .secondaryLabel)
    static let textTertiary = Color(uiColor: .tertiaryLabel)
    
    static let fireDomain = Color.orange
    static let shelterDomain = Color.green
    static let waterDomain = Color.blue
    static let navigationDomain = Color.yellow
    static let firstAidDomain = Color.red
    static let foodDomain = Color.purple
    static let rescueDomain = Color.indigo
    static let psychologyDomain = Color.brown
    static let environmentDomain = Color.teal
    static let toolsDomain = Color.gray
    
    static let coldTile = Color.cyan
    static let heatTile = Color(uiColor: .systemYellow)
    static let disasterTile = Color(uiColor: .systemTeal)
    static let animalTile = Color.mint
    static let inWaterTile = Color(uiColor: .systemIndigo)
    static let threatTile = Color.pink
    static let vehicleTile = Color(uiColor: .darkGray)
    static let chemicalTile = Color.purple
    
    static let emergencyRed = Color.red
    static let emergencyBackground = Color(uiColor: .systemBackground)
    
    static let success = Color.green
    static let warning = Color.orange
    
    static let separator = Color(uiColor: .separator)
    static let glassBorder = Color.clear // Not used in native design
}
