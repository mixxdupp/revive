import SwiftUI

struct Typography {
    // MARK: - Standard Apple Health Hierarchy
    // Using standard SwiftUI fonts which map to SF Pro
    
    static let largeTitle: Font = .largeTitle.weight(.bold)
    static let title: Font = .title2.weight(.bold)
    static let headline: Font = .headline
    static let body: Font = .body
    static let callout: Font = .callout
    static let caption: Font = .caption
    static let detail: Font = .caption2
    
    // MARK: - Specific Elements
    static let emergencyTitle: Font = .largeTitle.weight(.heavy)
    static let button: Font = .headline
    
    // MARK: - Data/Numbers
    // Apple Health uses rounded fonts for data values
    static let stepNumber: Font = .system(size: 80, weight: .bold, design: .rounded)
    static let stepWatermark: Font = .system(size: 80, weight: .bold, design: .rounded)
    
    // MARK: - Tracking (Standard)
    static let trackingTight: CGFloat = 0
    static let trackingWide: CGFloat = 0
}
