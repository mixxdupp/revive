import SwiftUI

struct SettingsView: View {
    @ObservedObject var settings = SettingsService.shared
    @State private var showingResetAlert = false
    @State private var showingLegal = false
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            Form {
                // MARK: - PREFERENCES
                Section(header: Text("Preferences", comment: "Settings Section")) {
                    Toggle("Use Metric System (°C, m)", isOn: $settings.isMetric)
                }
                
                // MARK: - DATA MANAGEMENT
                Section(header: Text("Data Management", comment: "Settings Section")) {
                    Button(action: {
                        showingResetAlert = true
                    }) {
                        Label(
                            title: { Text("Reset All Data", comment: "Destructive Action") },
                            icon: { Image(systemName: "trash") }
                        )
                        .foregroundColor(.red)
                    }
                }
                
                // MARK: - LEGAL & ABOUT
                Section(header: Text("Legal & Safety", comment: "Settings Section")) {
                    Button(action: {
                        showingLegal = true
                    }) {
                        Label(
                            title: { Text("Liability Disclaimer", comment: "Legal Menu Item") },
                            icon: { Image(systemName: "exclamationmark.shield") }
                        )
                    }
                    
                    HStack {
                        Label(
                            title: { Text("Version", comment: "App Version Label") },
                            icon: { Image(systemName: "info.circle") }
                        )
                        Spacer()
                        Text("1.0 (Build 1)")
                            .foregroundStyle(.secondary)
                    }
                }
                
                Section {
                    Link(destination: URL(string: "https://www.redcross.org/take-a-class")!) {
                        Label(
                            title: { Text("Find a Real First Aid Class", comment: "External Link") },
                            icon: { Image(systemName: "safari") }
                        )
                    }
                } footer: {
                    Text("This app is for backup use only. Training saves lives.", comment: "Safety Disclaimer Footer")
                }
            }
            .navigationTitle(Text("Settings", comment: "Screen Title"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
            .alert("Reset All Data?", isPresented: $showingResetAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Reset", role: .destructive) {
                    settings.resetAllData()
                    HapticsService.shared.playNotification(type: .success)
                }
            } message: {
                Text("This will clear all Favorites, History, and Local Preferences. This action cannot be undone.", comment: "Reset Warning")
            }
            .sheet(isPresented: $showingLegal) {
                LegalView()
            }
        }
    }
}
