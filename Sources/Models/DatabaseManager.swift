import Foundation
import SwiftData

/// A centralized manager that provides a shared `ModelContainer` and `ModelContext`
/// for background services that cannot easily rely on the SwiftUI `@Environment(\.modelContext)`.
@MainActor
final class DatabaseManager {
    static let shared = DatabaseManager()
    
    let container: ModelContainer
    let context: ModelContext
    
    private init() {
        let schema = Schema([
            KitItem.self,
            WaypointData.self
        ])
        
        // Force a completely new database file to escape lingering SQLite UNIQUE constraints
        // from previous models. SwiftData migrations notoriously fail to drop these constraints.
        let storeURL = URL.documentsDirectory.appendingPathComponent("ReviveStore_v3.sqlite")
        let modelConfiguration = ModelConfiguration(url: storeURL)
        
        do {
            container = try ModelContainer(for: schema, configurations: [modelConfiguration])
            context = container.mainContext
        } catch {
            // Failsafe for severe corruption
            for ext in ["", "-shm", "-wal"] {
                let fileURL = storeURL.deletingPathExtension().appendingPathExtension("sqlite\(ext)")
                try? FileManager.default.removeItem(at: fileURL)
            }
            
            do {
                container = try ModelContainer(for: schema, configurations: [modelConfiguration])
                context = container.mainContext
            } catch {
                fatalError("Could not recover ModelContainer: \(error)")
            }
        }
    }
}


