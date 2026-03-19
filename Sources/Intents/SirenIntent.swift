import AppIntents
import SwiftUI



struct StartSirenIntent: AppIntent {
    static var title: LocalizedStringResource = "Start Emergency Siren"
    static var description = IntentDescription("Activates the 120dB alarm and strobe light immediately in an emergency.")
    static var openAppWhenRun: Bool = false // Run in background to bypass lock screen
    static var isDiscoverable: Bool = true
    static var authenticationPolicy: IntentAuthenticationPolicy = .alwaysAllowed

    @MainActor
    func perform() async throws -> some IntentResult {
        // Trigger the siren audio engine instantly from the background
        // without requiring the user to unlock the device with a passcode.
        SirenManager.shared.startSiren()
        
        return .result()
    }
}

struct StopSirenIntent: AppIntent {
    static var title: LocalizedStringResource = "Stop Emergency Siren"
    static var description = IntentDescription("Deactivates the 120dB alarm and strobe light.")
    static var openAppWhenRun: Bool = false
    static var isDiscoverable: Bool = true
    static var authenticationPolicy: IntentAuthenticationPolicy = .alwaysAllowed

    @MainActor
    func perform() async throws -> some IntentResult {
        SirenManager.shared.stopSiren()
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
                "Sound the Alarm in \(.applicationName)",
                "Help me in \(.applicationName)",
                "Turn Siren on \(.applicationName)",
                "Turn on Siren in \(.applicationName)",
                "Play Siren on \(.applicationName)",
                "Start Siren on \(.applicationName)"
            ],
            shortTitle: "Start Siren",
            systemImageName: "light.beacon.max.fill"
        )
        
        AppShortcut(
            intent: StopSirenIntent(),
            phrases: [
                "Stop Emergency Siren in \(.applicationName)",
                "Stop Panic Alarm in \(.applicationName)",
                "Stop the Alarm in \(.applicationName)",
                "Turn Siren off \(.applicationName)",
                "Turn off Siren in \(.applicationName)",
                "Stop Siren on \(.applicationName)",
                "Stop Siren in \(.applicationName)"
            ],
            shortTitle: "Stop Siren",
            systemImageName: "light.beacon.min.fill"
        )
    }
}
