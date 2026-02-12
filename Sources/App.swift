import SwiftUI

@main
struct ReviveApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        if let shortcutItem = options.shortcutItem {
            // Handle launch from Quick Action
            NotificationCenter.default.post(name: .launchWithShortcut, object: nil, userInfo: ["id": shortcutItem.type])
        }
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        // Handle runtime Quick Action
        NotificationCenter.default.post(name: .launchWithShortcut, object: nil, userInfo: ["id": shortcutItem.type])
        completionHandler(true)
    }
}

extension Notification.Name {
    static let launchWithShortcut = Notification.Name("LaunchWithShortcut")
}

struct ContentView: View {
    @State private var showSiren = false
    
    var body: some View {
        NavigationStack {
            HomeView()
        }
        .preferredColorScheme(.dark)
        .fullScreenCover(isPresented: $showSiren) {
            EmergencySirenView(autoPlay: true) // Auto-start siren when launched via Shortcut/Widget
        }
        .onOpenURL { url in
            if url.scheme == "revive" && url.host == "siren" {
                showSiren = true
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: .launchWithShortcut)) { notification in
            if let id = notification.userInfo?["id"] as? String, id == "com.revive.siren" {
                showSiren = true
            }
        }
        .onAppear {
            setupQuickActions()
        }
    }
    
    func setupQuickActions() {
        let sirenItem = UIApplicationShortcutItem(
            type: "com.revive.siren",
            localizedTitle: "Emergency Siren",
            localizedSubtitle: "Loud Alarm + Strobe",
            icon: UIApplicationShortcutIcon(systemImageName: "exclamationmark.triangle.fill")
        )
        UIApplication.shared.shortcutItems = [sirenItem]
    }
}
