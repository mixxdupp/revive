import Foundation
import Combine

class FavoritesService: ObservableObject {
    static let shared = FavoritesService()
    
    @Published var savedTechniqueIDs: Set<String> = []
    @Published var savedArticleIDs: Set<String> = []
    
    private let techniquesKey = "revive_favorites_v1"
    private let articlesKey = "revive_favorites_articles_v1"
    
    init() {
        if let techniqueData = UserDefaults.standard.array(forKey: techniquesKey) as? [String] {
            savedTechniqueIDs = Set(techniqueData)
        }
        if let articleData = UserDefaults.standard.array(forKey: articlesKey) as? [String] {
            savedArticleIDs = Set(articleData)
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
    
    // MARK: - Articles
    
    func toggleArticle(_ id: String) {
        if savedArticleIDs.contains(id) {
            savedArticleIDs.remove(id)
        } else {
            savedArticleIDs.insert(id)
        }
        save()
    }
    
    func isArticleSaved(_ id: String) -> Bool {
        return savedArticleIDs.contains(id)
    }
    
    func getSavedArticles() -> [Article] {
        return savedArticleIDs.compactMap { ContentDatabase.shared.getArticle(id: $0) }
    }
    
    private func save() {
        UserDefaults.standard.set(Array(savedTechniqueIDs), forKey: techniquesKey)
        UserDefaults.standard.set(Array(savedArticleIDs), forKey: articlesKey)
    }
}
