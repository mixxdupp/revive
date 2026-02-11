import Foundation

/// Tracks recently viewed technique IDs using UserDefaults.
/// Stores the last 10 unique technique IDs in LIFO order.
final class RecentlyViewedService: ObservableObject {
    static let shared = RecentlyViewedService()
    
    private let storageKey = "revive.recently.viewed.techniques"
    private let maxItems = 10
    
    @Published private(set) var recentIDs: [String] = []
    
    private init() {
        recentIDs = UserDefaults.standard.stringArray(forKey: storageKey) ?? []
    }
    
    /// Records a technique view. Moves to front if already present.
    func addTechnique(id: String) {
        var ids = recentIDs
        ids.removeAll { $0 == id }
        ids.insert(id, at: 0)
        if ids.count > maxItems {
            ids = Array(ids.prefix(maxItems))
        }
        recentIDs = ids
        UserDefaults.standard.set(ids, forKey: storageKey)
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
        recentIDs = []
        UserDefaults.standard.removeObject(forKey: storageKey)
    }
}
