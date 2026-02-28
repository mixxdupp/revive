import SwiftUI
import AppIntents
import SwiftData
import UIKit

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
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                    withAnimation(.easeOut(duration: 0.3)) {
                        showLaunchScreen = false
                    }
                }
            }
            .modelContainer(for: KitItem.self)
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
    
    // Allow all orientations (Crucial for iPad support)
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return .all
    }
}

extension Notification.Name {
    static let launchWithShortcut = Notification.Name("LaunchWithShortcut")
    static let triggerPanic = Notification.Name("TriggerPanic")
}

struct ContentView: View {
    @Environment(\.horizontalSizeClass) var sizeClass
    @ObservedObject var settings = SettingsService.shared
    @State private var showSiren = false
    
    var body: some View {
        Group {
            if !settings.hasAcceptedLiability {
                OnboardingView()
            } else {
                if sizeClass == .compact {
                    // iPhone: Standard Stack
                    NavigationStack {
                        HomeView()
                    }
                } else {
                    // iPad: Pro Split View
                    NavigationSplitView {
                        SidebarView(selection: $selection)
                    } detail: {
                        NavigationStack {
                            switch selection ?? .dashboard {
                            case .dashboard:
                                HomeView()
                            case .emergency:
                                EmergencyMenuView()
                            case .library:
                                GuideMainView()
                            case .tools:
                                ToolsMenuView()
                            case .settings:
                                SettingsView()
                            }
                        }
                    }
                }
            }
        }
        .preferredColorScheme(.dark)
        .fullScreenCover(isPresented: $showSiren) {
            NavigationStack {
                EmergencySirenView(autoPlay: true, isPresentedModally: true)
            }
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
        .onReceive(NotificationCenter.default.publisher(for: .triggerPanic)) { _ in
            showSiren = true
        }
        .onAppear {
            setupQuickActions()
            ReviveShortcuts.updateAppShortcutParameters()
        }
    }
    
    @State private var selection: AppScreen? = .dashboard
    
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
    @State private var iconVisible = false
    @State private var textVisible = false
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack(spacing: 24) {
                Image(systemName: "flame.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 64, height: 64)
                    .foregroundStyle(Color.red)
                    .scaleEffect(iconVisible ? 1.0 : 0.5)
                    .opacity(iconVisible ? 1.0 : 0.0)
                
                Text("REVIVE")
                    .font(.system(size: 28, weight: .light))
                    .foregroundStyle(.white)
                    .kerning(textVisible ? 6 : 20)
                    .opacity(textVisible ? 1.0 : 0.0)
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.35, dampingFraction: 0.7)) {
                iconVisible = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                withAnimation(.easeOut(duration: 0.3)) {
                    textVisible = true
                }
            }
        }
    }
}
