import Foundation
import Combine
import SwiftUI

@MainActor
class SettingsService: ObservableObject {
    static let shared = SettingsService()
    
    @Published var isMetric: Bool {
        didSet {
            UserDefaults.standard.set(isMetric, forKey: "revive_is_metric")
        }
    }
    
    @Published var hasAcceptedLiability: Bool {
        didSet {
            UserDefaults.standard.set(hasAcceptedLiability, forKey: "revive_liability_accepted")
        }
    }
    
    private init() {
        self.isMetric = UserDefaults.standard.bool(forKey: "revive_is_metric")
        self.hasAcceptedLiability = UserDefaults.standard.bool(forKey: "revive_liability_accepted")
    }
    
    func resetAllData() {
        // 1. Clear Favorites
        FavoritesService.shared.savedTechniqueIDs.removeAll()
        FavoritesService.shared.savedArticleIDs.removeAll()
        
        // 2. Clear History
        RecentlyViewedService.shared.clear()
        
        // 3. Reset Settings
        self.isMetric = false

        
        // 4. Force UI Refresh
        objectWillChange.send()
    }
}
