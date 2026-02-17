import SwiftUI

struct InventoryView: View {
    // Common Survival Items
    // Common Survival Items
    let items = [
        String(localized: "Rope"), String(localized: "Knife"), String(localized: "Tarp"), String(localized: "Duct Tape"),
        String(localized: "Trash Bag"), String(localized: "Battery"), String(localized: "Condom"), String(localized: "Tampon"),
        String(localized: "Steel Wool"), String(localized: "Soda Can"), String(localized: "Cloth"), String(localized: "Bottle")
    ]
    
    @State private var selectedItems: Set<String> = []
    
    var computedResults: [Technique] {
        if selectedItems.isEmpty { return [] }
        return ContentDatabase.shared.findTechniques(forItems: selectedItems)
    }
    
    var body: some View {
        ZStack {
            DesignSystem.backgroundPrimary.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                VStack(alignment: .leading, spacing: 8) {
                    Text("Inventory", comment: "Screen Title")
                        .font(.system(size: 34, weight: .black))
                        .foregroundStyle(DesignSystem.textPrimary)
                    
                    Text("Select what you have to see what you can make.", comment: "Instruction Text")
                        .font(.subheadline)
                        .foregroundStyle(DesignSystem.textSecondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(24)
                
                // Item Grid
                VStack(alignment: .leading, spacing: 24) {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 100), spacing: 12)], spacing: 12) {
                        ForEach(items, id: \.self) { item in
                            ItemToggle(name: item, isSelected: selectedItems.contains(item)) {
                                toggleItem(item)
                            }
                        }
                    }
                    .padding(.horizontal, 24)
                    
                    Divider()
                        .padding(.horizontal, 24)
                    
                    // Results
                    if selectedItems.isEmpty {
                        InventoryEmptyState(
                            title: "Select Items",
                            icon: "backpack",
                            description: "Tap items above to find matching techniques."
                        )
                    } else if computedResults.isEmpty {
                        InventoryEmptyState(
                            title: "No Matches",
                            icon: "magnifyingglass",
                            description: "Try selecting different combinations."
                        )
                    } else {
                        VStack(alignment: .leading, spacing: 16) {
                            Text("\(computedResults.count) Techniques Found", comment: "Search Result Count")
                                .font(.headline)
                                .foregroundStyle(DesignSystem.textSecondary)
                                .padding(.horizontal, 24)
                            
                            ForEach(computedResults) { technique in
                                NavigationLink(destination: VerticalGuideView(technique: technique)) {
                                    TechniqueRow(technique: technique)
                                }
                            }
                            .padding(.horizontal, 24)
                        }
                        .padding(.bottom, 40)
                    }
                }
            }
        }
    }
    
    func toggleItem(_ item: String) {
        if selectedItems.contains(item) {
            selectedItems.remove(item)
        } else {
            selectedItems.insert(item)
        }
    }
}

// MARK: - Custom Empty State
struct InventoryEmptyState: View {
    let title: LocalizedStringKey
    let icon: String
    let description: LocalizedStringKey
    
    var body: some View {
        VStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(DesignSystem.backgroundSecondary)
                    .frame(width: 80, height: 80)
                
                Image(systemName: icon)
                    .font(.system(size: 32))
                    .foregroundStyle(DesignSystem.textSecondary)
            }
            .padding(.bottom, 8)
            
            Text(title)
                .font(.headline)
                .foregroundStyle(DesignSystem.textPrimary)
            
            Text(description)
                .font(.subheadline)
                .foregroundStyle(DesignSystem.textSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 60)
    }
}

struct ItemToggle: View {
    let name: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(name)
                .font(.system(size: 16, weight: .medium))
                .foregroundStyle(isSelected ? .white : DesignSystem.textPrimary)
                .padding(.vertical, 12)
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(isSelected ? Color.blue : Color.gray.opacity(0.1))
                )
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .stroke(isSelected ? Color.blue : Color.gray.opacity(0.2), lineWidth: 1)
                )
        }
        .scaleEffect(isSelected ? 0.95 : 1.0)
        .animation(.spring(response: 0.3), value: isSelected)
        .accessibilityLabel(name)
        .accessibilityAddTraits(isSelected ? [.isButton, .isSelected] : [.isButton])
    }
}
