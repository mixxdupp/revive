import SwiftUI

struct Typography {
    // Using standard SwiftUI fonts which map to SF Pro
    
    static let largeTitle: Font = .largeTitle.weight(.bold)
    static let title: Font = .title2.weight(.bold)
    static let headline: Font = .headline
    static let body: Font = .body
    static let callout: Font = .callout
    static let caption: Font = .caption
    static let detail: Font = .caption2
    
    static let emergencyTitle: Font = .largeTitle.weight(.heavy)
    static let button: Font = .headline
    
    // Apple Health uses rounded fonts for data values
    static let stepNumber: Font = .system(size: 80, weight: .bold)
    static let stepWatermark: Font = .system(size: 80, weight: .bold)
    
    static let trackingTight: CGFloat = 0
    static let trackingWide: CGFloat = 0
}
