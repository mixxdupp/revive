import SwiftUI
import UIKit

struct DesignSystem {
    // MARK: - System Backgrounds
    // Use native iOS system colors for automatic Light/Dark mode support
    static let backgroundPrimary = Color(uiColor: .systemGroupedBackground)
    static let backgroundSecondary = Color(uiColor: .secondarySystemGroupedBackground) // Cards
    static let backgroundTertiary = Color(uiColor: .tertiarySystemGroupedBackground)
    
    // MARK: - Text Colors
    static let textPrimary = Color(uiColor: .label)
    static let textSecondary = Color(uiColor: .secondaryLabel)
    static let textTertiary = Color(uiColor: .tertiaryLabel)
    
    // MARK: - System Accents (Apple Health Style)
    static let fireDomain = Color.orange
    static let shelterDomain = Color.green
    static let waterDomain = Color.blue
    static let navigationDomain = Color.yellow
    static let firstAidDomain = Color.red
    static let foodDomain = Color.purple
    static let rescueDomain = Color.indigo
    static let psychologyDomain = Color.brown
    static let environmentDomain = Color.cyan
    static let toolsDomain = Color.gray
    
    // MARK: - Emergency
    static let emergencyRed = Color.red
    static let emergencyBackground = Color(uiColor: .systemBackground)
    
    // MARK: - Status
    static let success = Color.green
    static let warning = Color.orange
    
    // MARK: - Borders/Separators
    static let separator = Color(uiColor: .separator)
    static let glassBorder = Color.clear // Not used in native design
}
