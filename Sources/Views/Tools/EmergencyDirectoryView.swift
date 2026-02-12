import SwiftUI

struct EmergencyDirectoryView: View {
    @State private var searchText = ""
    
    // Sort countries alphabetically
    private var countries: [CountryEmergency] {
        EmergencyData.allCountries.sorted { $0.name < $1.name }
    }
    
    var filteredCountries: [CountryEmergency] {
        if searchText.isEmpty { return countries }
        return countries.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
    }
    
    var body: some View {
        List {
            // Header Section
            Section {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Emergency Directory")
                        .font(.largeTitle.weight(.bold))
                        .foregroundStyle(DesignSystem.textPrimary)
                    Text("Offline database of worldwide emergency numbers.")
                        .font(.body)
                        .foregroundStyle(DesignSystem.textSecondary)
                }
                .padding(.vertical, 8)
                .listRowBackground(Color.clear)
                .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
            }
            
            // Results
            ForEach(filteredCountries) { country in
                CountryRow(country: country)
            }
        }
        .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: "Search country (e.g. Japan)")
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .background(Color(uiColor: .systemGroupedBackground))
    }
}

struct CountryRow: View {
    let country: CountryEmergency
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Country Header
            HStack {
                Text(country.flag)
                    .font(.title)
                Text(country.name)
                    .font(.headline)
                    .foregroundStyle(DesignSystem.textPrimary)
                Spacer()
                if let unified = country.unifiedNumber {
                    Link("Call \(unified)", destination: URL(string: "tel://\(unified)")!)
                        .font(.subheadline.weight(.bold))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(Color.red)
                        .clipShape(Capsule())
                }
            }
            
            // Detailed Numbers if not unified
            if country.unifiedNumber == nil {
                Divider()
                HStack(spacing: 20) {
                    ServiceButton(icon: "shield.fill", label: "Police", number: country.police, color: .blue)
                    ServiceButton(icon: "flame.fill", label: "Fire", number: country.fire, color: .orange)
                    ServiceButton(icon: "cross.fill", label: "Medical", number: country.ambulance, color: .red)
                }
            }
        }
        .padding(.vertical, 8)
    }
}

struct ServiceButton: View {
    let icon: String
    let label: String
    let number: String
    let color: Color
    
    var body: some View {
        Link(destination: URL(string: "tel://\(number)")!) {
            VStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.system(size: 20))
                Text(label)
                    .font(.caption2.weight(.bold))
                    .textCase(.uppercase)
                Text(number)
                    .font(.headline)
            }
            .foregroundStyle(color) // Colored text/icon
            .frame(maxWidth: .infinity)
            .padding(8)
            .background(color.opacity(0.1))
            .clipShape(RoundedRectangle(cornerRadius: 8))
        }
        .buttonStyle(.plain) // Standard tap behavior
    }
}

#Preview {
    NavigationView {
        EmergencyDirectoryView()
    }
}
