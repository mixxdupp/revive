import SwiftUI

struct SavedTechniquesView: View {
    @ObservedObject var favorites = FavoritesService.shared
    
    var savedTechniques: [Technique] {
        favorites.getSavedTechniques()
    }
    
    var body: some View {
        VStack {
            if savedTechniques.isEmpty {
                ContentUnavailableView("No Saved Guides", systemImage: "bookmark", description: Text("Tap the bookmark icon on any guide to save it here."))
                    .padding(.top, 40)
            } else {
                LazyVStack(spacing: 16) {
                    ForEach(savedTechniques) { technique in
                        NavigationLink(destination: VerticalGuideView(technique: technique)) {
                            ZStack(alignment: .topTrailing) {
                                TechniqueRow(technique: technique)
                                
                                // Un-bookmark button
                                Button(action: {
                                    favorites.toggle(technique.id)
                                }) {
                                    Image(systemName: "bookmark.fill")
                                        .font(.title3)
                                        .foregroundStyle(Color.orange)
                                        .padding(16)
                                    .accessibilityHidden(true)
                                }
                            }
                        }
                    }
                }
                .padding(.bottom, 40)
            }
        }
    }
}
