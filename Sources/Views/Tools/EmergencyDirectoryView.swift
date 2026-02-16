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
        ZStack {
            // MARK: - Ambient Background
            DesignSystem.backgroundPrimary
                .ignoresSafeArea()
            
            // Subtle Mesh Gradient Simulation (Blue/Teal for Directory)
            GeometryReader { proxy in
                ZStack {
                    Circle()
                        .fill(Color.blue.opacity(0.1))
                        .frame(width: 300, height: 300)
                        .blur(radius: 60)
                        .offset(x: -100, y: -100)
                    
                    Circle()
                        .fill(Color.teal.opacity(0.1))
                        .frame(width: 300, height: 300)
                        .blur(radius: 60)
                        .offset(x: 200, y: 100)
                }
                .frame(width: proxy.size.width, height: proxy.size.height)
            }
            .ignoresSafeArea()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    
                    // MARK: - Header
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Directory")
                            .font(.system(size: 42, weight: .black, design: .serif))
                            .foregroundStyle(DesignSystem.textPrimary)
                            .tracking(-0.5)
                        
                        Text("Global Emergency Numbers")
                            .font(.system(size: 20, weight: .medium, design: .serif))
                            .foregroundStyle(DesignSystem.textSecondary)
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 16)
                    
                    // MARK: - Search Results
                    LazyVStack(spacing: 16) {
                        ForEach(filteredCountries) { country in
                            GlassCountryRow(country: country)
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 40)
                }
            }
        }
        .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: "Search country (e.g. Japan)")
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Glass Country Row
struct GlassCountryRow: View {
    let country: CountryEmergency
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Country Header
            HStack {
                Text(country.flag)
                    .font(.system(size: 32))
                Text(country.name)
                    .font(.title3.weight(.bold))
                    .foregroundStyle(DesignSystem.textPrimary)
                    .lineLimit(2)
                    .minimumScaleFactor(0.85)
                    .fixedSize(horizontal: false, vertical: true)
                
                Spacer()
                
                if let unified = country.unifiedNumber {
                    Link("Call \(unified)", destination: URL(string: "tel://\(unified)")!)
                        .font(.headline.weight(.bold))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        .background(Color.red)
                        .clipShape(Capsule())
                        .shadow(color: Color.red.opacity(0.4), radius: 6, x: 0, y: 3)
                }
            }
            
            // Detailed Numbers if not unified
            if country.unifiedNumber == nil {
                Divider()
                    .background(Color.white.opacity(0.2))
                
                HStack(spacing: 12) {
                    ServiceButton(icon: "shield.fill", label: "Police", number: country.police, color: .blue)
                    ServiceButton(icon: "flame.fill", label: "Fire", number: country.fire, color: .orange)
                    ServiceButton(icon: "cross.fill", label: "Medical", number: country.ambulance, color: .red)
                }
            }
        }
        .padding(20)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .stroke(Color.white.opacity(0.1), lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
    }
}

struct ServiceButton: View {
    let icon: String
    let label: String
    let number: String
    let color: Color
    
    var body: some View {
        Link(destination: URL(string: "tel://\(number)")!) {
            VStack(spacing: 6) {
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
            .padding(.vertical, 12)
            .padding(.horizontal, 4)
            .background(color.opacity(0.1))
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .buttonStyle(.plain) // Standard tap behavior
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(label), \(number)")
        .accessibilityAddTraits(.isButton)
    }
}

#Preview {
    NavigationView {
        EmergencyDirectoryView()
    }
}
