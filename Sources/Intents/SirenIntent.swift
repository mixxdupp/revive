import AppIntents
import SwiftUI



struct StartSirenIntent: AppIntent {
    static var title: LocalizedStringResource = "Start Emergency Siren"
    static var description = IntentDescription("Activates the 120dB alarm and strobe light immediately in an emergency.")
    static var openAppWhenRun: Bool = true // Required to open the app

    static var authenticationPolicy: IntentAuthenticationPolicy = .alwaysAllowed

    @MainActor
    func perform() async throws -> some IntentResult {
        // Post the notification. Because `openAppWhenRun` is true, ContextView
        // will be active and listening, triggering the full screen siren.
        NotificationCenter.default.post(name: .triggerPanic, object: nil)
        
        // Alternatively, use Environment to trigger the deep link as a fallback
        if let url = URL(string: "revive://siren") {
            EnvironmentValues().openURL(url)
        }
        
        return .result()
    }
}

struct ReviveShortcuts: AppShortcutsProvider {
    static var appShortcuts: [AppShortcut] {
        AppShortcut(
            intent: StartSirenIntent(),
            phrases: [
                "Start Emergency Siren in \(.applicationName)",
                "Trigger Panic Alarm in \(.applicationName)",
                "Help me in \(.applicationName)"
            ],
            shortTitle: "Start Siren",
            systemImageName: "light.beacon.max.fill"
        )
    }
}
