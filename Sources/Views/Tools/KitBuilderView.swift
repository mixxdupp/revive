import SwiftUI
import SwiftData


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


struct ScenarioGear {
    let scenario: EmergencySituation
    let items: [(name: String, points: Int)]
    
    static let all: [ScenarioGear] = [
        ScenarioGear(scenario: .hurt, items: [
            ("Combat Tourniquet", 50), ("Hemostatic Gauze", 40), ("Pressure Bandage", 35),
            ("Vented Chest Seal (x2)", 30), ("Trauma Shears", 20), ("Moldable Splint (36\")", 20),
            ("Elastic Bandage (ACE Wrap)", 15), ("Antiseptic Wipes (10-Pack)", 15), ("Tweezers", 15),
            ("Medical Tape Roll", 10), ("Nitrile Gloves (2 Pairs)", 10), ("CPR Face Shield", 10),
            ("Irrigation Syringe (20ml)", 10), ("Safety Pins (x5)", 10)
        ]),
        ScenarioGear(scenario: .cold, items: [
            ("Emergency Mylar Blanket (x2)", 40), ("Hand / Body Warmers (4-Pack)", 30),
            ("Wool or Fleece Base Layer", 20), ("Insulated Water Bottle", 15), ("Extra Dry Socks", 10)
        ]),
        ScenarioGear(scenario: .noFire, items: [
            ("Ferro Rod + Striker", 50), ("Waterproof Storm Matches", 30),
            ("Char Cloth Tin", 20), ("Cotton Tinder Bundle", 20),
            ("Backup Lighter", 15), ("Magnifying Lens", 10)
        ]),
        ScenarioGear(scenario: .noWater, items: [
            ("Water Purification Tablets", 50), ("Portable Water Filter", 40),
            ("Collapsible Water Container (2L)", 30), ("Metal Cup / Canteen", 20),
            ("Iodine Solution (2oz)", 15)
        ]),
        ScenarioGear(scenario: .lost, items: [
            ("Button Compass", 40), ("Signal Mirror", 30), ("Emergency Whistle", 30),
            ("Topographic Map (Local Area)", 25), ("Headlamp + Spare Batteries", 25),
            ("Signal Flares (x2)", 20), ("Bright Orange Bandana", 10)
        ]),
        ScenarioGear(scenario: .trapped, items: [
            ("Emergency Whistle", 40), ("Fixed-Blade Knife", 30), ("Chemical Glow Sticks (x3)", 30),
            ("Glass Breaker Tool", 25), ("Paracord Bracelet (12ft)", 20),
            ("Dust Mask", 15), ("Carabiner (x2)", 15)
        ]),
        ScenarioGear(scenario: .disaster, items: [
            ("Emergency Crank Radio (AM/FM)", 50), ("Dust Masks (3-Pack)", 30),
            ("Headlamp / Flashlight", 25), ("Heavy-Duty Trash Bags (x3)", 20),
            ("Cash (Small Bills)", 15), ("Copies of ID Documents", 10)
        ]),
        ScenarioGear(scenario: .noFood, items: [
            ("Calorie-Dense Bars (2400kcal+)", 50), ("Fixed-Blade Knife", 25),
            ("Electrolyte Powder", 20), ("Fishing Line + Hooks Kit", 20),
            ("Snare Wire (Brass, 5ft)", 20), ("Metal Cooking Pot", 15)
        ]),
        ScenarioGear(scenario: .animal, items: [
            ("Animal Deterrent Spray", 50), ("Emergency Whistle", 30), ("Headlamp", 20)
        ]),
        ScenarioGear(scenario: .inWater, items: [
            ("Rescue Whistle (Waterproof)", 40), ("Personal Flotation Marker", 30),
            ("Chemical Light Sticks (x3)", 20), ("Dry Bag", 15)
        ]),
        ScenarioGear(scenario: .shelter, items: [
            ("Emergency Bivvy Sack", 50), ("Lightweight Tarp (8x10ft)", 30),
            ("Paracord (50ft)", 25), ("Compact Sleeping Bag", 20),
            ("Duct Tape Roll (Mini)", 15), ("Emergency Poncho", 10)
        ]),
        ScenarioGear(scenario: .extremeHeat, items: [
            ("Oral Rehydration Salts (6-Pack)", 50), ("Wide-Brim Sun Hat", 20),
            ("Cooling Towel", 20), ("Sunscreen (SPF 50+)", 15), ("Electrolyte Tablets", 15)
        ]),
        ScenarioGear(scenario: .humanThreat, items: [
            ("Personal Safety Alarm (130dB)", 50), ("Emergency Whistle", 30),
            ("Compact Flashlight (Strobe)", 25), ("Fully Charged Power Bank", 15)
        ]),
        ScenarioGear(scenario: .vehicleEmergency, items: [
            ("Seatbelt Cutter + Window Breaker", 50), ("Reflective Warning Triangle", 30),
            ("Jumper Cables", 25), ("Hi-Vis Safety Vest", 20), ("Compact Flashlight", 15)
        ]),
        ScenarioGear(scenario: .chemicalExposure, items: [
            ("Respirator Mask", 50), ("Chemical-Resistant Gloves", 30),
            ("Eye Wash Bottle (500ml)", 30), ("Sealed Plastic Poncho", 20)
        ])
    ]
}


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
        List {
            Section {
                overallProgressView
                    .listRowInsets(EdgeInsets())
                    .listRowBackground(Color.clear)
            }
            
            Section(header: Text("Scenarios")) {
                ForEach(ScenarioGear.all, id: \.scenario) { scenarioGear in
                    let scenarioItems = items.filter { $0.scenario == scenarioGear.scenario.rawValue }
                    if !scenarioItems.isEmpty {
                        NavigationLink(destination: ScenarioDetailView(scenario: scenarioGear.scenario, items: scenarioItems)) {
                            ScenarioListRow(scenario: scenarioGear.scenario, items: scenarioItems)
                        }
                    }
                }
            }
        }
        .listStyle(.insetGrouped)
        .navigationTitle("Emergency Readiness")
        .navigationBarTitleDisplayMode(.large)
        .onAppear {
            seedDefaultGearIfNeeded()
        }
    }
    
    private var overallProgressView: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Overall Progress")
                    .font(.headline.weight(.semibold))
                Spacer()
                Text("\(Int(overallProgress * 100))%")
                    .font(.title2.bold())
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
        .background(Color(uiColor: .secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }
    
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
            try? modelContext.save()
        }
    }
    
    private func progressColor(_ value: Double) -> Color {
        if value >= 0.75 { return .green }
        if value >= 0.4 { return .orange }
        return .red
    }
}


struct ScenarioListRow: View {
    let scenario: EmergencySituation
    let items: [KitItem]
    
    var scenarioProgress: Double {
        let total = items.reduce(0) { $0 + $1.points }
        let acquired = items.filter { $0.isAcquired }.reduce(0) { $0 + $1.points }
        guard total > 0 else { return 0 }
        return Double(acquired) / Double(total)
    }
    
    var body: some View {
        HStack(spacing: 16) {
            // Icon
            Image(systemName: scenario.icon)
                .font(.system(size: 20, weight: .semibold))
                .foregroundStyle(scenario.color)
                .frame(width: 36, height: 36)
            
            // Text
            VStack(alignment: .leading, spacing: 2) {
                Text(scenario.displayName)
                    .font(.body.weight(.medium))
                    .foregroundStyle(DesignSystem.textPrimary)
                
                Text("\(items.filter { $0.isAcquired }.count) of \(items.count) items")
                    .font(.subheadline)
                    .foregroundStyle(DesignSystem.textSecondary)
            }
            
            Spacer()
            
            // Clean Progress Ring (Replacing the chaotic duel-circles)
            ZStack {
                Circle()
                    .stroke(Color.primary.opacity(0.1), lineWidth: 3)
                Circle()
                    .trim(from: 0, to: CGFloat(scenarioProgress))
                    .stroke(scenarioProgressColor, style: StrokeStyle(lineWidth: 3, lineCap: .round))
                    .rotationEffect(.degrees(-90))
            }
            .frame(width: 24, height: 24)
            .animation(.spring(response: 0.4), value: scenarioProgress)
        }
        .padding(.vertical, 4)
    }
    
    private var scenarioProgressColor: Color {
        if scenarioProgress >= 1.0 { return .green }
        if scenarioProgress >= 0.5 { return .orange }
        return .red
    }
}


struct ScenarioDetailView: View {
    let scenario: EmergencySituation
    let items: [KitItem]
    
    var body: some View {
        List {
            Section(header: Text("Required Gear")) {
                ForEach(items) { item in
                    ScenarioItemRow(item: item)
                }
            }
        }
        .listStyle(.insetGrouped)
        .navigationTitle(scenario.displayName)
        .navigationBarTitleDisplayMode(.inline)
    }
}


struct ScenarioItemRow: View {
    @Bindable var item: KitItem
    
    var body: some View {
        Button(action: {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                item.isAcquired.toggle()
            }
        }) {
            HStack(spacing: 12) {
                Image(systemName: item.isAcquired ? "checkmark.circle.fill" : "circle")
                    .font(.system(size: 22))
                    .foregroundStyle(item.isAcquired ? .green : .secondary)
                
                Text(item.name)
                    .font(.body.weight(item.isAcquired ? .regular : .medium))
                    .foregroundStyle(item.isAcquired ? Color.secondary : DesignSystem.textPrimary)
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
        }
        .buttonStyle(.plain)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(item.name), \(item.isAcquired ? "acquired" : "not acquired"), \(item.points) points")
        .accessibilityAddTraits(.isButton)
    }
}
