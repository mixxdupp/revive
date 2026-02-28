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
                CampfireIcon()
                    .frame(width: 64, height: 64)
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

// MARK: - Custom Vector Campfire Icon
struct CampfireIcon: View {
    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width
            let h = geo.size.height
            
            ZStack {
                // Crossed Logs
                Path { p in
                    // Left Log
                    p.move(to: CGPoint(x: w * 0.20, y: h * 0.90))
                    p.addLine(to: CGPoint(x: w * 0.80, y: h * 0.70))
                    
                    // Right Log
                    p.move(to: CGPoint(x: w * 0.80, y: h * 0.90))
                    p.addLine(to: CGPoint(x: w * 0.20, y: h * 0.70))
                }
                .stroke(style: StrokeStyle(lineWidth: w * 0.08, lineCap: .round, lineJoin: .round))
                .foregroundStyle(Color(red: 0.4, green: 0.2, blue: 0.1)) // Dark woody brown
                
                // 3-Prong Flame
                Path { p in
                    // Center Main Flame
                    p.move(to: CGPoint(x: w * 0.50, y: h * 0.70))
                    p.addCurve(to: CGPoint(x: w * 0.50, y: h * 0.15),
                               control1: CGPoint(x: w * 0.25, y: h * 0.55),
                               control2: CGPoint(x: w * 0.40, y: h * 0.30))
                    p.addCurve(to: CGPoint(x: w * 0.50, y: h * 0.70),
                               control1: CGPoint(x: w * 0.75, y: h * 0.40),
                               control2: CGPoint(x: w * 0.65, y: h * 0.65))
                    
                    // Left Flame Sub-branch
                    p.move(to: CGPoint(x: w * 0.50, y: h * 0.70))
                    p.addCurve(to: CGPoint(x: w * 0.35, y: h * 0.35),
                               control1: CGPoint(x: w * 0.15, y: h * 0.65),
                               control2: CGPoint(x: w * 0.25, y: h * 0.45))
                    p.addCurve(to: CGPoint(x: w * 0.50, y: h * 0.70),
                               control1: CGPoint(x: w * 0.45, y: h * 0.45),
                               control2: CGPoint(x: w * 0.45, y: h * 0.60))
                               
                    // Right Flame Sub-branch
                    p.move(to: CGPoint(x: w * 0.50, y: h * 0.70))
                    p.addCurve(to: CGPoint(x: w * 0.70, y: h * 0.40),
                               control1: CGPoint(x: w * 0.85, y: h * 0.65),
                               control2: CGPoint(x: w * 0.75, y: h * 0.50))
                    p.addCurve(to: CGPoint(x: w * 0.50, y: h * 0.70),
                               control1: CGPoint(x: w * 0.60, y: h * 0.50),
                               control2: CGPoint(x: w * 0.60, y: h * 0.65))
                }
                .fill(
                    LinearGradient(
                        colors: [.yellow, .orange, .red],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
            }
        }
    }
}
