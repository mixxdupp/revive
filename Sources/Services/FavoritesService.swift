import Foundation
import Combine

class FavoritesService: ObservableObject {
    static let shared = FavoritesService()
    
    @Published var savedTechniqueIDs: Set<String> = []
    
    private let key = "revive_favorites_v1"
    
    init() {
        if let data = UserDefaults.standard.array(forKey: key) as? [String] {
            savedTechniqueIDs = Set(data)
        }
    }
    
    func toggle(_ id: String) {
        if savedTechniqueIDs.contains(id) {
            savedTechniqueIDs.remove(id)
        } else {
            savedTechniqueIDs.insert(id)
        }
        save()
    }
    
    func isSaved(_ id: String) -> Bool {
        return savedTechniqueIDs.contains(id)
    }
    
    func getSavedTechniques() -> [Technique] {
        return savedTechniqueIDs.compactMap { ContentDatabase.shared.getTechnique(id: $0) }
    }
    
    private func save() {
        UserDefaults.standard.set(Array(savedTechniqueIDs), forKey: key)
    }
}
