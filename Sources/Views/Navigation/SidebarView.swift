import SwiftUI

enum AppScreen: String, CaseIterable, Identifiable {
    case dashboard = "Dashboard"
    case emergency = "Emergency"
    case library = "Library"
    case tools = "Tools"
    case settings = "Settings"
    
    var id: String { rawValue }
    
    var icon: String {
        switch self {
        case .dashboard: return "square.grid.2x2"
        case .emergency: return "exclamationmark.triangle"
        case .library: return "book"
        case .tools: return "hammer"
        case .settings: return "gearshape"
        }
    }
}

struct SidebarView: View {
    @Binding var selection: AppScreen?
    
    var body: some View {
        List(selection: $selection) {
            Section {
                ForEach(AppScreen.allCases) { screen in
                    NavigationLink(value: screen) {
                        Label(screen.rawValue, systemImage: screen.icon)
                            .font(.headline)
                            .padding(.vertical, 8)
                    }
                }
            } header: {
                Text("Menu")
                    .font(.caption.weight(.bold))
            }
        }
        .listStyle(.sidebar)
        .navigationTitle("Revive")
    }
}
