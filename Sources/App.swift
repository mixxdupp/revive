import SwiftUI
import AppIntents

@main
struct ReviveApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @State private var showLaunchScreen = true
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                ContentView()
                
                if showLaunchScreen {
                    LaunchScreenView()
                        .transition(.opacity)
                        .zIndex(1)
                }
            }
            .onAppear {
                // Simulate app loading / splash duration
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                    withAnimation(.easeOut(duration: 0.5)) {
                        showLaunchScreen = false
                    }
                }
            }
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
    
    // Force Portrait Orientation at Runtime
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return .portrait
    }
}

extension Notification.Name {
    static let launchWithShortcut = Notification.Name("LaunchWithShortcut")
    static let triggerPanic = Notification.Name("TriggerPanic")
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
        // Listener for In-App Panic Button
        .onReceive(NotificationCenter.default.publisher(for: .triggerPanic)) { _ in
            showSiren = true
        }
        .onAppear {
            setupQuickActions()
            ReviveShortcuts.updateAppShortcutParameters()
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

struct LaunchScreenView: View {
    @State private var pulse: Bool = false
    @State private var textVisible: Bool = false
    
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            
            VStack {
                // Heartbeat Icon
                Image(systemName: "staroflife.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 80, height: 80)
                    .foregroundStyle(Color.red)
                    .scaleEffect(pulse ? 1.0 : 0.8)
                    .opacity(pulse ? 1.0 : 0.6)
                    .onAppear {
                        withAnimation(.easeInOut(duration: 0.8).repeatForever(autoreverses: true)) {
                            pulse = true
                        }
                    }
                
                // App Text
                Text("Revive")
                    .font(.largeTitle.weight(.heavy))
                    .foregroundStyle(.white)
                    .opacity(textVisible ? 1.0 : 0.0)
                    .offset(y: textVisible ? 0 : 20)
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                withAnimation(.easeOut(duration: 0.8)) {
                    textVisible = true
                }
            }
        }
    }
}
