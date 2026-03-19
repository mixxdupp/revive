import SwiftUI

struct SettingsView: View {
    @ObservedObject var settings = SettingsService.shared
    @State private var showingResetAlert = false
    @State private var showingLegal = false
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Preferences", comment: "Settings Section")) {
                    Toggle("Use Metric System (°C, m)", isOn: $settings.isMetric)
                }
                
                Section(header: Text("Data Management", comment: "Settings Section")) {
                    Button(role: .destructive, action: {
                        showingResetAlert = true
                    }) {
                        Text("Reset All Data", comment: "Destructive Action")
                    }
                }
                
                Section(header: Text("System & Integrations", comment: "Settings Section")) {
                    HStack {
                        Label(
                            title: { Text("Offline Content", comment: "Offline status") },
                            icon: { SettingsIcon(systemName: "checkmark.icloud.fill", color: .green) }
                        )
                        Spacer()
                        Text("21 Domains (14MB)")
                            .foregroundStyle(.secondary)
                    }
                    
                    Button(action: {
                        if let url = URL(string: "x-apple-health://") {
                            UIApplication.shared.open(url)
                        }
                    }) {
                        Label(
                            title: { Text("Update Medical ID", comment: "Health integration link").foregroundColor(.primary) },
                            icon: { SettingsIcon(systemName: "staroflife.fill", color: .blue) }
                        )
                    }
                }
                
                Section(header: Text("Legal & Safety", comment: "Settings Section")) {
                    Button(action: {
                        showingLegal = true
                    }) {
                        Label(
                            title: { Text("Liability Disclaimer", comment: "Legal Menu Item").foregroundColor(.primary) },
                            icon: { SettingsIcon(systemName: "exclamationmark.shield.fill", color: .orange) }
                        )
                    }
                    
                    HStack {
                        Label(
                            title: { Text("Version", comment: "App Version Label") },
                            icon: { SettingsIcon(systemName: "info.circle.fill", color: .gray) }
                        )
                        Spacer()
                        Text("1.0 (Build 1)")
                            .foregroundStyle(.secondary)
                    }
                }
                
                Section(header: Text("Professional Training", comment: "External links section"), 
                        footer: Text("Revive works completely offline, but is for backup reference only. Professional training is always recommended.", comment: "Safety Disclaimer Footer")) {
                    Link(destination: URL(string: "https://www.nols.edu/en/courses/wilderness-medicine/")!) {
                        Label(
                            title: { Text("NOLS Wilderness Medicine", comment: "External Link").foregroundColor(.primary) },
                            icon: { SettingsIcon(systemName: "tree.fill", color: .green) }
                        )
                    }
                    
                    Link(destination: URL(string: "https://www.ready.gov/kit")!) {
                        Label(
                            title: { Text("FEMA Disaster Preparedness", comment: "External Link").foregroundColor(.primary) },
                            icon: { SettingsIcon(systemName: "house.and.flag.fill", color: .orange) }
                        )
                    }
                    
                    Link(destination: URL(string: "https://www.redcross.org/take-a-class")!) {
                        Label(
                            title: { Text("Red Cross First Aid", comment: "External Link").foregroundColor(.primary) },
                            icon: { SettingsIcon(systemName: "cross.case.fill", color: .red) }
                        )
                    }
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

struct SettingsIcon: View {
    let systemName: String
    let color: Color
    
    var body: some View {
        Image(systemName: systemName)
            .symbolRenderingMode(.monochrome)
            .font(.system(size: 15, weight: .regular))
            .foregroundStyle(.white)
            .frame(width: 29, height: 29)
            .background(color)
            .clipShape(RoundedRectangle(cornerRadius: 7, style: .continuous))
    }
}
