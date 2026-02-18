import SwiftUI
import Charts

struct SurvivalChartsView: View {
    @Environment(\.dismiss) var dismiss
    
    // Tab Selection
    @State private var selectedTab = 0
    
    var body: some View {
        ZStack {
            DesignSystem.backgroundPrimary.edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 0) {
                // Header
                HStack {
                    Button(action: { dismiss() }) {
                        HStack(spacing: 4) {
                            Image(systemName: "chevron.left")
                            Text("Back")
                        }
                        .font(Typography.button)
                        .foregroundColor(DesignSystem.textSecondary)
                    }
                    Spacer()
                    Text("Survival Stats")
                        .font(.headline)
                        .foregroundStyle(DesignSystem.textPrimary)
                    Spacer()
                    // Balance the back button
                    Color.clear.frame(width: 60)
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                .padding(.bottom, 20)
                
                // Picker
                Picker("Stats", selection: $selectedTab) {
                    Text("Hypothermia").tag(0)
                    Text("Water Needs").tag(1)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
                
                // Content
                ScrollView {
                    if selectedTab == 0 {
                        HypothermiaChartView()
                            .transition(.opacity.combined(with: .move(edge: .leading)))
                    } else {
                        WaterNeedsChartView()
                            .transition(.opacity.combined(with: .move(edge: .trailing)))
                    }
                }
            }
        }
        .navigationBarHidden(true)
        .animation(.easeInOut, value: selectedTab)
    }
}

// MARK: - Hypothermia Data Model
struct HypothermiaData: Identifiable {
    let id = UUID()
    let waterTemp: Double // Fahrenheit
    let survivalTime: Double // Hours (approx max)
    let condition: String
}

// MARK: - Water Data Model
struct WaterData: Identifiable {
    let id = UUID()
    let activityLevel: String
    let tempRange: String
    let liters: Double
}

// MARK: - Hypothermia Chart View
struct HypothermiaChartView: View {
    let data: [HypothermiaData] = [
        .init(waterTemp: 32.5, survivalTime: 0.25, condition: "Freezing"),
        .init(waterTemp: 40, survivalTime: 0.5, condition: "Very Cold"),
        .init(waterTemp: 50, survivalTime: 1.0, condition: "Cold"),
        .init(waterTemp: 60, survivalTime: 2.0, condition: "Chilly"),
        .init(waterTemp: 70, survivalTime: 12.0, condition: "Cool"),
        .init(waterTemp: 80, survivalTime: 24.0, condition: "Warm") // Indefinite really
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            ChartInfoCard(
                title: "Cold Water Survival",
                description: "Estimated consciousness time based on water temperature. Without protective gear, these times drop significantly."
            )
            
            VStack(alignment: .leading) {
                Text("Survival Time (Hours)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .padding(.leading, 8)
                
                Chart(data) { item in
                    LineMark(
                        x: .value("Water Temp", item.waterTemp),
                        y: .value("Hours", item.survivalTime)
                    )
                    .interpolationMethod(.catmullRom)
                    .symbol(by: .value("Condition", item.condition))
                    .foregroundStyle(.blue)
                    
                    AreaMark(
                        x: .value("Water Temp", item.waterTemp),
                        y: .value("Hours", item.survivalTime)
                    )
                    .interpolationMethod(.catmullRom)
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.blue.opacity(0.3), .blue.opacity(0.0)],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                }
                .chartYScale(domain: 0...30)
                .chartXScale(domain: 30...85)
                .chartXAxis {
                    AxisMarks(position: .bottom, values: .automatic) { value in
                        AxisGridLine()
                        AxisTick()
                        AxisValueLabel {
                            if let doubleValue = value.as(Double.self) {
                                Text("\(Int(doubleValue))°F")
                                    .font(.caption2)
                            }
                        }
                    }
                }
                .frame(height: 300)
                .padding()
                .background(Color(uiColor: .secondarySystemGroupedBackground))
                .cornerRadius(16)
                .accessibilityElement(children: .combine)
                .accessibilityLabel("Line chart: Hypothermia survival time. 15 minutes at 32°F, 1 hour at 50°F, Indefinite above 80°F.")
            }
            .padding(.horizontal, 20)

            // Critical Warning
            HStack(spacing: 12) {
                Image(systemName: "exclamationmark.triangle.fill")
                    .font(.title2)
                    .foregroundStyle(.yellow)
                
                Text("Below 50°F (10°C), loss of dexterity occurs in under 5 minutes. Swimming ability is lost shortly after.")
                    .font(.subheadline)
                    .foregroundStyle(DesignSystem.textSecondary)
            }
            .padding(20)
            .background(Color.yellow.opacity(0.1))
            .cornerRadius(16)
            .padding(.horizontal, 20)
        }
        .padding(.bottom, 40)
    }
}

// MARK: - Water Needs Chart View
struct WaterNeedsChartView: View {
    let data: [WaterData] = [
        // Rest
        .init(activityLevel: "Rest", tempRange: "Moderate (70°F)", liters: 2.5),
        .init(activityLevel: "Rest", tempRange: "Hot (95°F)", liters: 4.0),
        
        // Moderate Activity
        .init(activityLevel: "Moderate", tempRange: "Moderate (70°F)", liters: 3.5),
        .init(activityLevel: "Moderate", tempRange: "Hot (95°F)", liters: 6.0),
        
        // Heavy Activity
        .init(activityLevel: "Heavy", tempRange: "Moderate (70°F)", liters: 5.0),
        .init(activityLevel: "Heavy", tempRange: "Hot (95°F)", liters: 9.0),
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            ChartInfoCard(
                title: "Daily Water Requirements",
                description: "Liters needed per day based on activity and environmental temperature."
            )
            
            VStack(alignment: .leading) {
                Text("Liters / Day")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .padding(.leading, 8)
                
                Chart(data) { item in
                    BarMark(
                        x: .value("Activity", item.activityLevel),
                        y: .value("Liters", item.liters)
                    )
                    .foregroundStyle(by: .value("Temp", item.tempRange))
                    .position(by: .value("Temp", item.tempRange))
                    .annotation(position: .top) {
                        Text("\(String(format: "%.1f", item.liters))")
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                    }
                }
                .chartForegroundStyleScale([
                    "Moderate (70°F)": Color.cyan,
                    "Hot (95°F)": Color.orange
                ])
                .frame(height: 300)
                .padding()
                .background(Color(uiColor: .secondarySystemGroupedBackground))
                .cornerRadius(16)
                .accessibilityElement(children: .combine)
                .accessibilityLabel("Bar chart: Water needs. Heavy activity in heat requires 9 liters. Rest in moderate temp requires 2.5 liters.")
            }
            .padding(.horizontal, 20)
            
            // Tips
            VStack(alignment: .leading, spacing: 8) {
                Label("Rationing Myth", systemImage: "drop.triangle.fill")
                    .font(.headline)
                    .foregroundStyle(.blue)
                
                Text("Do not ration water if you are thirsty. Drink what you have to maintain cognitive function. Dehydration kills faster than lack of water efficiency.")
                    .font(.subheadline)
                    .foregroundStyle(DesignSystem.textSecondary)
            }
            .padding(20)
            .background(Color.blue.opacity(0.1))
            .cornerRadius(16)
            .padding(.horizontal, 20)
        }
        .padding(.bottom, 40)
    }
}

struct ChartInfoCard: View {
    let title: String
    let description: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.title2.weight(.bold))
                .foregroundStyle(DesignSystem.textPrimary)
            
            Text(description)
                .font(.body)
                .foregroundStyle(DesignSystem.textSecondary)
        }
        .padding(.horizontal, 20)
    }
}
