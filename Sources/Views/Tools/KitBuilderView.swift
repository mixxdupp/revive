import SwiftUI
import SwiftData

// MARK: - SwiftData Model

@Model
final class KitItem {
    var id: UUID = UUID()
    var name: String
    var scenario: String          // Maps to EmergencySituation.rawValue
    var points: Int               // Weight of this item's importance
    var isAcquired: Bool
    var addedDate: Date
    
    init(name: String, scenario: String, points: Int, isAcquired: Bool = false) {
        self.name = name
        self.scenario = scenario
        self.points = points
        self.isAcquired = isAcquired
        self.addedDate = Date()
    }
}

// MARK: - Scenario Gear Mapping

/// Maps each EmergencySituation to a curated list of gear the user needs.
struct ScenarioGear {
    let scenario: EmergencySituation
    let items: [(name: String, points: Int)]
    
    static let all: [ScenarioGear] = [
        // MARK: First Aid / Injury
        ScenarioGear(scenario: .hurt, items: [
            ("CAT Tourniquet", 50),
            ("Hemostatic Gauze (QuikClot)", 40),
            ("Israeli Pressure Bandage", 35),
            ("Vented Chest Seal (x2)", 30),
            ("Trauma Shears", 20),
            ("SAM Splint (36\")", 20),
            ("Medical Tape Roll", 10),
            ("Nitrile Gloves (2 Pairs)", 10),
            ("CPR Face Shield", 10)
        ]),
        // MARK: Cold / Hypothermia
        ScenarioGear(scenario: .cold, items: [
            ("Emergency Mylar Blanket (x2)", 40),
            ("Hand / Body Warmers (4-Pack)", 30),
            ("Wool or Fleece Base Layer", 20),
            ("Insulated Water Bottle", 15),
            ("Extra Dry Socks", 10)
        ]),
        // MARK: Need Fire
        ScenarioGear(scenario: .noFire, items: [
            ("Ferro Rod + Striker", 50),
            ("Waterproof Storm Matches", 30),
            ("Cotton Tinder Bundle / Vaseline Balls", 20),
            ("BIC Lighter (Backup)", 15)
        ]),
        // MARK: Need Water
        ScenarioGear(scenario: .noWater, items: [
            ("Water Purification Tablets (Aquatabs)", 50),
            ("LifeStraw Personal Filter", 40),
            ("Collapsible Water Container (2L)", 30),
            ("Metal Cup / Canteen (for boiling)", 20)
        ]),
        // MARK: Lost / Navigation
        ScenarioGear(scenario: .lost, items: [
            ("Button Compass", 40),
            ("Signal Mirror", 30),
            ("Emergency Whistle (Fox 40)", 30),
            ("Headlamp + Spare Batteries", 25),
            ("Bright Orange Bandana", 10)
        ]),
        // MARK: Trapped / Rescue
        ScenarioGear(scenario: .trapped, items: [
            ("Emergency Whistle", 40),
            ("Glow Stick (Cyalume, x3)", 30),
            ("Glass Breaker Tool", 25),
            ("Paracord Bracelet (12ft)", 20),
            ("Dust Mask (N95)", 15)
        ]),
        // MARK: Natural Disaster
        ScenarioGear(scenario: .disaster, items: [
            ("Emergency Crank Radio (AM/FM)", 50),
            ("N95 Dust Masks (3-Pack)", 30),
            ("Headlamp / Flashlight", 25),
            ("Heavy-Duty Trash Bags (x3)", 20),
            ("Cash (Small Bills)", 15),
            ("Copies of ID Documents (Sealed)", 10)
        ]),
        // MARK: Need Food
        ScenarioGear(scenario: .noFood, items: [
            ("Calorie-Dense Bars (2400kcal+)", 50),
            ("Electrolyte Powder Packets", 20),
            ("Fishing Line + Hooks Kit", 20),
            ("Snare Wire (Brass, 5ft)", 20)
        ]),
        // MARK: Animal Encounter
        ScenarioGear(scenario: .animal, items: [
            ("Bear Spray / Animal Deterrent", 50),
            ("Emergency Whistle", 30),
            ("Headlamp (Animals avoid bright light)", 20)
        ]),
        // MARK: In Water
        ScenarioGear(scenario: .inWater, items: [
            ("Rescue Whistle (Waterproof)", 40),
            ("Personal Flotation Marker", 30),
            ("Chemical Light Sticks (x3)", 20),
            ("Dry Bag (for electronics/supplies)", 15)
        ]),
        // MARK: Need Shelter
        ScenarioGear(scenario: .shelter, items: [
            ("Emergency Bivvy Sack", 50),
            ("Lightweight Tarp (8x10ft)", 30),
            ("550 Paracord (50ft)", 25),
            ("Duct Tape Roll (Mini)", 15)
        ]),
        // MARK: Extreme Heat
        ScenarioGear(scenario: .extremeHeat, items: [
            ("Oral Rehydration Salts (6-Pack)", 50),
            ("Wide-Brim Sun Hat", 20),
            ("Cooling Towel / Neck Wrap", 20),
            ("Sunscreen (SPF 50+, Travel Size)", 15),
            ("Electrolyte Tablets", 15)
        ]),
        // MARK: Human Threat
        ScenarioGear(scenario: .humanThreat, items: [
            ("Personal Safety Alarm (130dB)", 50),
            ("Emergency Whistle", 30),
            ("Compact Flashlight (Strobe Mode)", 25),
            ("Fully Charged Power Bank", 15)
        ]),
        // MARK: Vehicle Emergency
        ScenarioGear(scenario: .vehicleEmergency, items: [
            ("Seatbelt Cutter + Window Breaker", 50),
            ("Reflective Warning Triangle", 30),
            ("Jumper Cables / Jump Starter", 25),
            ("Hi-Vis Safety Vest", 20),
            ("Compact Flashlight", 15)
        ]),
        // MARK: Chemical / Hazmat
        ScenarioGear(scenario: .chemicalExposure, items: [
            ("N95/P100 Respirator", 50),
            ("Chemical-Resistant Gloves", 30),
            ("Eye Wash Bottle (500ml)", 30),
            ("Sealed Plastic Poncho", 20)
        ])
    ]
}

// MARK: - Main View

struct KitBuilderView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \KitItem.addedDate, order: .forward) private var items: [KitItem]
    
    var overallProgress: Double {
        guard !items.isEmpty else { return 0 }
        let totalPoints = items.reduce(0) { $0 + $1.points }
        let acquiredPoints = items.filter { $0.isAcquired }.reduce(0) { $0 + $1.points }
        guard totalPoints > 0 else { return 0 }
        return Double(acquiredPoints) / Double(totalPoints)
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                headerView
                overallProgressView
                scenarioCardsView
            }
            .padding(.bottom, 40)
        }
        .background(Color.primary.opacity(0.05).ignoresSafeArea())
        .onAppear {
            seedDefaultGearIfNeeded()
        }
    }
    
    // MARK: - Header
    private var headerView: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Emergency Readiness")
                .font(.system(size: 34, weight: .bold))
                .foregroundStyle(Color.primary)
            
            Text("Your preparedness across all scenarios")
                .font(.body)
                .foregroundStyle(Color.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal)
        .padding(.top, 16)
    }
    
    // MARK: - Overall Progress
    private var overallProgressView: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Overall Readiness")
                    .font(.headline.weight(.semibold))
                Spacer()
                Text("\(Int(overallProgress * 100))%")
                    .font(.system(.title2, design: .rounded, weight: .heavy))
                    .foregroundStyle(progressColor(overallProgress))
                    .contentTransition(.numericText())
            }
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(Color.primary.opacity(0.1))
                        .frame(height: 12)
                    
                    Capsule()
                        .fill(LinearGradient(
                            colors: [progressColor(overallProgress).opacity(0.8), progressColor(overallProgress)],
                            startPoint: .leading, endPoint: .trailing))
                        .frame(width: max(geometry.size.width * CGFloat(overallProgress), 0), height: 12)
                }
            }
            .frame(height: 12)
            .animation(.spring(response: 0.5, dampingFraction: 0.7), value: overallProgress)
        }
        .padding()
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .padding(.horizontal)
    }
    
    // MARK: - Per-Scenario Cards
    private var scenarioCardsView: some View {
        LazyVStack(spacing: 16) {
            ForEach(ScenarioGear.all, id: \.scenario) { scenarioGear in
                let scenarioItems = items.filter { $0.scenario == scenarioGear.scenario.rawValue }
                if !scenarioItems.isEmpty {
                    ScenarioCard(
                        scenario: scenarioGear.scenario,
                        items: scenarioItems
                    )
                }
            }
        }
        .padding(.horizontal)
    }
    
    // MARK: - Seed Data
    private func seedDefaultGearIfNeeded() {
        if items.isEmpty {
            for scenarioGear in ScenarioGear.all {
                for gear in scenarioGear.items {
                    let item = KitItem(
                        name: gear.name,
                        scenario: scenarioGear.scenario.rawValue,
                        points: gear.points
                    )
                    modelContext.insert(item)
                }
            }
            // Force commit so @Query picks up the seed data immediately
            try? modelContext.save()
        }
    }
    
    private func progressColor(_ value: Double) -> Color {
        if value >= 0.75 { return .green }
        if value >= 0.4 { return .orange }
        return .red
    }
}

// MARK: - Per-Scenario Card

struct ScenarioCard: View {
    let scenario: EmergencySituation
    let items: [KitItem]
    
    @State private var isExpanded = false
    
    var scenarioProgress: Double {
        let total = items.reduce(0) { $0 + $1.points }
        let acquired = items.filter { $0.isAcquired }.reduce(0) { $0 + $1.points }
        guard total > 0 else { return 0 }
        return Double(acquired) / Double(total)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Header Row (always visible)
            Button(action: { withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) { isExpanded.toggle() } }) {
                HStack(spacing: 14) {
                    // Scenario Icon
                    Image(systemName: scenario.icon)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundStyle(scenario.color)
                        .frame(width: 40, height: 40)
                        .background(scenario.color.opacity(0.15))
                        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text(scenario.displayName)
                            .font(.subheadline.weight(.semibold))
                            .foregroundStyle(Color.primary)
                        
                        Text("\(items.filter { $0.isAcquired }.count)/\(items.count) items")
                            .font(.caption)
                            .foregroundStyle(Color.secondary)
                    }
                    
                    Spacer()
                    
                    // Mini progress ring
                    ZStack {
                        Circle()
                            .stroke(Color.primary.opacity(0.1), lineWidth: 3)
                        Circle()
                            .trim(from: 0, to: CGFloat(scenarioProgress))
                            .stroke(scenarioProgressColor, style: StrokeStyle(lineWidth: 3, lineCap: .round))
                            .rotationEffect(.degrees(-90))
                    }
                    .frame(width: 32, height: 32)
                    .animation(.spring(response: 0.4), value: scenarioProgress)
                    
                    Image(systemName: "chevron.right")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.secondary)
                        .rotationEffect(.degrees(isExpanded ? 90 : 0))
                }
                .padding()
            }
            .buttonStyle(.plain)
            
            // Expanded Item List
            if isExpanded {
                Divider()
                    .padding(.horizontal)
                
                VStack(spacing: 0) {
                    ForEach(items) { item in
                        ScenarioItemRow(item: item)
                        if item.id != items.last?.id {
                            Divider()
                                .padding(.leading, 52)
                        }
                    }
                }
                .padding(.bottom, 8)
            }
        }
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .strokeBorder(scenarioProgressColor.opacity(scenarioProgress == 1.0 ? 0.4 : 0.1), lineWidth: 1)
        )
        .accessibilityElement(children: .contain)
        .accessibilityLabel("\(scenario.displayName), \(items.filter { $0.isAcquired }.count) of \(items.count) items acquired, \(Int(scenarioProgress * 100)) percent ready")
    }
    
    private var scenarioProgressColor: Color {
        if scenarioProgress >= 1.0 { return .green }
        if scenarioProgress >= 0.5 { return .orange }
        return .red
    }
}

// MARK: - Item Row

struct ScenarioItemRow: View {
    @Bindable var item: KitItem
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: item.isAcquired ? "checkmark.circle.fill" : "circle")
                .font(.system(size: 22))
                .foregroundStyle(item.isAcquired ? .green : .secondary)
                .onTapGesture {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        item.isAcquired.toggle()
                    }
                }
            
            Text(item.name)
                .font(.subheadline.weight(item.isAcquired ? .regular : .medium))
                .foregroundStyle(item.isAcquired ? .secondary : .primary)
                .strikethrough(item.isAcquired, color: .secondary)
            
            Spacer()
            
            if !item.isAcquired {
                Text("\(item.points)pt")
                    .font(.caption2.weight(.bold))
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(Color.primary.opacity(0.05))
                    .clipShape(Capsule())
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 10)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(item.name), \(item.isAcquired ? "acquired" : "not acquired"), \(item.points) points")
        .accessibilityHint(item.isAcquired ? "Double tap to mark as not acquired" : "Double tap to mark as acquired")
        .accessibilityAddTraits(.isButton)
    }
}
