import SwiftUI

struct EmergencyDirectoryView: View {
    @State private var searchText = ""
    @Environment(\.dismiss) var dismiss
    
    // For smooth mesh gradient animation
    @State private var isAnimating = false
    
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
            
            // Subtle Animated Mesh Gradient Simulation (Blue/Teal/Indigo for Directory)
            GeometryReader { proxy in
                ZStack {
                    Circle()
                        .fill(Color.blue.opacity(0.12))
                        .frame(width: 350, height: 350)
                        .blur(radius: 60)
                        .offset(x: isAnimating ? -50 : -150, y: isAnimating ? -50 : -150)
                    
                    Circle()
                        .fill(Color.teal.opacity(0.12))
                        .frame(width: 300, height: 300)
                        .blur(radius: 60)
                        .offset(x: isAnimating ? 150 : 250, y: isAnimating ? 50 : 150)
                        
                    Circle()
                        .fill(Color.indigo.opacity(0.08))
                        .frame(width: 400, height: 400)
                        .blur(radius: 80)
                        .offset(x: isAnimating ? -100 : 100, y: isAnimating ? 300 : 400)
                }
                .frame(width: proxy.size.width, height: proxy.size.height)
                .onAppear {
                    withAnimation(.easeInOut(duration: 8.0).repeatForever(autoreverses: true)) {
                        isAnimating = true
                    }
                }
            }
            .ignoresSafeArea()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    
                    // MARK: - Custom Header
                    VStack(alignment: .leading, spacing: 16) {
                        Button(action: { dismiss() }) {
                            HStack(spacing: 6) {
                                Image(systemName: "chevron.left")
                                    .font(.body.weight(.semibold))
                                Text("Back")
                                    .font(.headline)
                            }
                            .foregroundStyle(Color.blue)
                        }
                        .padding(.top, 16)
                        
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Directory")
                                .font(.system(size: 42, weight: .bold))
                                .foregroundStyle(DesignSystem.textPrimary)
                                .tracking(-0.5)
                            
                            Text("Global Emergency Numbers")
                                .font(.system(size: 20, weight: .medium))
                                .foregroundStyle(DesignSystem.textSecondary)
                        }
                        
                        // MARK: - Search Bar
                        HStack {
                            Image(systemName: "magnifyingglass")
                                .foregroundStyle(DesignSystem.textSecondary)
                            TextField("Search country (e.g. Japan)", text: $searchText)
                                .font(.body)
                                .foregroundStyle(DesignSystem.textPrimary)
                                .submitLabel(.search)
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 14)
                        .background(.ultraThinMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                        .overlay(
                            RoundedRectangle(cornerRadius: 16, style: .continuous)
                                .stroke(Color.white.opacity(0.15), lineWidth: 0.5)
                        )
                        .padding(.top, 8)
                    }
                    .padding(.horizontal, 24)
                    
                    // MARK: - Search Results
                    LazyVStack(spacing: 20) {
                        ForEach(filteredCountries) { country in
                            GlassCountryRow(country: country)
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 40)
                    .animation(.spring(response: 0.4, dampingFraction: 0.8), value: searchText)
                }
            }
        }
        .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: "Search country (e.g. Japan)")
        .navigationBarHidden(true)
    }
}

// MARK: - Glass Country Row
struct GlassCountryRow: View {
    let country: CountryEmergency
    
    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            // Country Header
            HStack(alignment: .center, spacing: 12) {
                Text(country.flag)
                    .font(.system(size: 28))
                    
                Text(country.name)
                    .font(.headline)
                    .foregroundStyle(DesignSystem.textPrimary)
                    .lineLimit(2)
                    .minimumScaleFactor(0.85)
                    .fixedSize(horizontal: false, vertical: true)
                
                Spacer()
                
                if let unified = country.unifiedNumber {
                    Link(destination: URL(string: "tel://\(unified)")!) {
                        HStack(spacing: 4) {
                            Image(systemName: "phone.fill")
                            Text("Call \(unified)")
                        }
                        .font(.subheadline.weight(.bold))
                        .foregroundStyle(Color.red)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(Color.red.opacity(0.15))
                        .clipShape(Capsule())
                    }
                }
            }
            
            // Detailed Numbers if not unified
            if country.unifiedNumber == nil {
                Divider()
                    .background(Color.white.opacity(0.1))
                
                HStack(spacing: 12) {
                    ServiceButton(
                        icon: "shield.fill",
                        label: "Police",
                        number: country.police,
                        color: .blue
                    )
                    
                    ServiceButton(
                        icon: "flame.fill",
                        label: "Fire",
                        number: country.fire,
                        color: .orange
                    )
                    
                    ServiceButton(
                        icon: "cross.fill",
                        label: "Medical",
                        number: country.ambulance,
                        color: .red
                    )
                }
            }
        }
        .padding(16)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .strokeBorder(Color.white.opacity(0.1), lineWidth: 0.5)
        )
    }
}

// MARK: - Premium Service Button
struct ServiceButton: View {
    let icon: String
    let label: String
    let number: String
    let color: Color
    
    var body: some View {
        Link(destination: URL(string: "tel://\(number)")!) {
            VStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.system(size: 20, weight: .medium))
                
                VStack(spacing: 2) {
                    Text(label)
                        .font(.caption2.weight(.medium))
                        .textCase(.uppercase)
                        .opacity(0.8)
                        
                    Text(number)
                        .font(.headline.weight(.bold))
                }
            }
            .foregroundStyle(color)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .padding(.horizontal, 4)
            .background(color.opacity(0.15))
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        }
        .buttonStyle(ScalableButtonStyle()) // Uses standard app scaler logic
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
