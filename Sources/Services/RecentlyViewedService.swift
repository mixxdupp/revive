import Foundation

/// Tracks recently viewed technique IDs using UserDefaults.
/// Stores the last 10 unique technique IDs in LIFO order.
@MainActor
final class RecentlyViewedService: ObservableObject {
    static let shared = RecentlyViewedService()
    
    private let maxItems = 10
    private let storageKey = "revive_recent_techniques"
    
    @Published private(set) var recentIDs: [String] = []
    
    private init() {
        refreshMemory()
    }
    
    private func refreshMemory() {
        if let stored = UserDefaults.standard.array(forKey: storageKey) as? [String] {
            recentIDs = stored
        }
    }
    
    /// Records a technique view. Moves to front if already present.
    func addTechnique(id: String) {
        // Remove if exists to move to front
        if let idx = recentIDs.firstIndex(of: id) {
            recentIDs.remove(at: idx)
        }
        
        recentIDs.insert(id, at: 0)
        
        if recentIDs.count > maxItems {
            recentIDs = Array(recentIDs.prefix(maxItems))
        }
        
        UserDefaults.standard.set(recentIDs, forKey: storageKey)
    }
    
    /// Returns resolved Technique objects for recently viewed IDs.
    func recentTechniques(limit: Int = 5) -> [Technique] {
        let db = ContentDatabase.shared
        return recentIDs.prefix(limit).compactMap { id in
            db.techniques.first(where: { $0.id == id })
        }
    }
    
    /// Clears all recently viewed history.
    func clear() {
        recentIDs.removeAll()
        UserDefaults.standard.removeObject(forKey: storageKey)
    }
}

