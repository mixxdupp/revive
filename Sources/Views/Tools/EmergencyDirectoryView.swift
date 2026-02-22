import SwiftUI

struct EmergencyDirectoryView: View {
    @State private var searchText = ""
    
    // For smooth mesh gradient animation
    @State private var isAnimating = false
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    
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
            if !reduceMotion {
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
            }
            
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    
                    // MARK: - Subtitle (directly below native large title)
                    Text("Global Emergency Numbers")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundStyle(DesignSystem.textSecondary)
                        .padding(.horizontal, 24)
                    
                    // MARK: - Search Bar
                    HStack(spacing: 8) {
                        Image(systemName: "magnifyingglass")
                            .foregroundStyle(DesignSystem.textSecondary)
                        TextField("Search country (e.g. Japan)", text: $searchText)
                            .font(.body)
                            .foregroundStyle(DesignSystem.textPrimary)
                            .submitLabel(.search)
                        
                        if !searchText.isEmpty {
                            Button {
                                searchText = ""
                            } label: {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundStyle(DesignSystem.textSecondary)
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(Color(uiColor: .secondarySystemGroupedBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                    .padding(.horizontal, 24)
                    
                    // MARK: - Country List
                    if filteredCountries.isEmpty {
                        // Empty State
                        VStack(spacing: 12) {
                            Image(systemName: "magnifyingglass")
                                .font(.system(size: 36))
                                .foregroundStyle(DesignSystem.textSecondary)
                            Text("No countries found")
                                .font(.headline)
                                .foregroundStyle(DesignSystem.textSecondary)
                            Text("Try a different search term")
                                .font(.subheadline)
                                .foregroundStyle(DesignSystem.textSecondary.opacity(0.7))
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.top, 60)
                    } else {
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
        }
        .navigationTitle("Directory")
        .navigationBarTitleDisplayMode(.large)
    }
}

// MARK: - Glass Country Row
struct GlassCountryRow: View {
    let country: CountryEmergency
    @State private var numberToCall: String?
    @State private var serviceToCall: String?
    @State private var showingCallConfirmation = false
    
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
                    Button {
                        numberToCall = unified
                        serviceToCall = "Emergency"
                        showingCallConfirmation = true
                    } label: {
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
                        color: .blue,
                        onTap: { number, label in
                            numberToCall = number
                            serviceToCall = label
                            showingCallConfirmation = true
                        }
                    )
                    
                    ServiceButton(
                        icon: "flame.fill",
                        label: "Fire",
                        number: country.fire,
                        color: .orange,
                        onTap: { number, label in
                            numberToCall = number
                            serviceToCall = label
                            showingCallConfirmation = true
                        }
                    )
                    
                    ServiceButton(
                        icon: "cross.fill",
                        label: "Medical",
                        number: country.ambulance,
                        color: .red,
                        onTap: { number, label in
                            numberToCall = number
                            serviceToCall = label
                            showingCallConfirmation = true
                        }
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
        .accessibilityElement(children: .contain)
        .accessibilityLabel("\(country.name) emergency numbers")
        .confirmationDialog(
            "Call \(serviceToCall ?? "Emergency") — \(numberToCall ?? "")?",
            isPresented: $showingCallConfirmation,
            titleVisibility: .visible
        ) {
            if let number = numberToCall {
                Button("Call \(number)", role: .destructive) {
                    if let url = URL(string: "tel://\(number)") {
                        UIApplication.shared.open(url)
                    }
                }
                Button("Cancel", role: .cancel) {}
            }
        } message: {
            Text("This will initiate a phone call to \(country.name) \(serviceToCall ?? "emergency") services.")
        }
    }
}

// MARK: - Premium Service Button
struct ServiceButton: View {
    let icon: String
    let label: String
    let number: String
    let color: Color
    var onTap: (String, String) -> Void
    
    var body: some View {
        Button {
            onTap(number, label)
        } label: {
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
        .buttonStyle(ScalableButtonStyle())
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(label), \(number)")
        .accessibilityHint("Double tap to call")
        .accessibilityAddTraits(.isButton)
    }
}

#Preview {
    NavigationView {
        EmergencyDirectoryView()
    }
}
