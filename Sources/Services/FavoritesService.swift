import Foundation
import Combine

@MainActor
class FavoritesService: ObservableObject {
    static let shared = FavoritesService()
    
    @Published var savedTechniqueIDs: Set<String> = []
    @Published var savedArticleIDs: Set<String> = []
    
    private let techniquesKey = "revive_saved_techniques"
    private let articlesKey = "revive_saved_articles"
    
    init() {
        refreshMemory()
    }
    
    private func refreshMemory() {
        if let stored = UserDefaults.standard.array(forKey: techniquesKey) as? [String] {
            savedTechniqueIDs = Set(stored)
        }
        if let storedArgs = UserDefaults.standard.array(forKey: articlesKey) as? [String] {
            savedArticleIDs = Set(storedArgs)
        }
    }
    
    func toggle(_ id: String) {
        if savedTechniqueIDs.contains(id) {
            savedTechniqueIDs.remove(id)
        } else {
            savedTechniqueIDs.insert(id)
        }
        UserDefaults.standard.set(Array(savedTechniqueIDs), forKey: techniquesKey)
    }
    
    func isSaved(_ id: String) -> Bool {
        return savedTechniqueIDs.contains(id)
    }
    
    func getSavedTechniques() -> [Technique] {
        return savedTechniqueIDs.compactMap { ContentDatabase.shared.getTechnique(id: $0) }
    }
    
    func toggleArticle(_ id: String) {
        if savedArticleIDs.contains(id) {
            savedArticleIDs.remove(id)
        } else {
            savedArticleIDs.insert(id)
        }
        UserDefaults.standard.set(Array(savedArticleIDs), forKey: articlesKey)
    }
    
    func isArticleSaved(_ id: String) -> Bool {
        return savedArticleIDs.contains(id)
    }
    
    func getSavedArticles() -> [Article] {
        return savedArticleIDs.compactMap { ContentDatabase.shared.getArticle(id: $0) }
    }
}



