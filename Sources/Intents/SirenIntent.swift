import AppIntents
import SwiftUI

struct StartSirenIntent: AppIntent {
    static var title: LocalizedStringResource = "Start Emergency Siren"
    static var description = IntentDescription("Activates the loud emergency alarm and flashlight strobe.")
    static var openAppWhenRun: Bool = true // Open app to show the flashing screen

    @MainActor
    func perform() async throws -> some IntentResult {
        // The App.swift handles the deep link logic. 
        // By opening the app with a specific context (or just reliance on the deep link URLScheme if invoked via URL),
        // we can trigger it.
        // However, for pure AppIntent, we rely on the `onOpenURL` or similar binding in ContentView.
        // Since `openAppWhenRun` is true, the app launches.
        // To ensure the siren starts, we can use a dependency or notification system, 
        // but the simplest way compatible with this structure is to rely on the Deep Link mechanism 
        // by returning a specific result or via `DeepLink` handling if we were using the older SiriKit.
        
        // BETTER APPROACH: Open the Deep Link URL explicitly
        if let url = URL(string: "revive://siren") {
            await UIApplication.shared.open(url)
        }
        
        return .result()
    }
}

struct ReviveShortcuts: AppShortcutsProvider {
    static var appShortcuts: [AppShortcut] {
        AppShortcut(
            intent: StartSirenIntent(),
            phrases: [
                "Start Siren in \(.applicationName)",
                "Panic in \(.applicationName)",
                "Emergency in \(.applicationName)"
            ],
            shortTitle: "Start Siren",
            systemImageName: "exclamationmark.triangle.fill"
        )
    }
}
