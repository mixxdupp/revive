import SwiftUI

@main
struct ReviveApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

struct ContentView: View {
    var body: some View {
        NavigationStack {
            HomeView()
        }
        .preferredColorScheme(.dark) // Force Stealth / Night Mode globally
    }
}
