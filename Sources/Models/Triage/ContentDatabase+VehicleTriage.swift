import Foundation

// Auto-generated: buildVehicleTriage extracted from ContentDatabase.swift
extension ContentDatabase {
    // =========================================================================
    // MARK: - VEHICLE EMERGENCY (NEW)
    // =========================================================================
    func buildVehicleTriage() -> TriageNode {
        TriageNode(id: "vehicle-em-root", question: "What happened to the vehicle?", options: [
            TriageOption(id: "veh-crash", label: "Crash / Impact", icon: "car.side.fill", destination: .nextQuestion(
                TriageNode(id: "veh-crash-q", question: "Are you trapped?", options: [
                    TriageOption(id: "veh-trap-water", label: "Submerged in Water", icon: "water.waves", destination: .technique("env-vehicle-water-escape")), // Placeholder
                    TriageOption(id: "veh-trap-no", label: "No — Outside Vehicle", icon: "figure.walk", destination: .technique("firstaid-scene-safety"))
                ])
            )),
            TriageOption(id: "veh-breakdown", label: "Stranded / Breakdown", icon: "exclamationmark.triangle.fill", destination: .nextQuestion(
                TriageNode(id: "veh-break-q", question: "Environment?", options: [
                    TriageOption(id: "veh-break-winter", label: "Winter / Snow", icon: "snowflake", destination: .technique("env-winter-car-kit")), // Placeholder
                ])
            )),
            
            // Learn More
            TriageOption(id: "veh-learn", label: "Learn More", icon: "book.fill", destination: .nextQuestion(
                TriageNode(id: "veh-learn-q", question: "Vehicle safety topics?", options: [
                    TriageOption(id: "veh-art-kit", label: "Vehicle Kits", icon: "case.fill", destination: .article("tools-article-camp")), // Placeholder
                    TriageOption(id: "veh-art-signal", label: "Signaling", icon: "antenna.radiowaves.left.and.right", destination: .article("rescue-article-signaling"))
                ])
            )),

            TriageOption(id: "g2888", label: "Vehicle", icon: "car.fill", destination: .nextQuestion(
                TriageNode(id: "g2888-q", question: "Which best matches?", options: [
                    TriageOption(id: "g2889", label: "Overcoming hydrostatic pressure", icon: "car.fill", destination: .technique("env-vehicle-submersion-escape")),
                    TriageOption(id: "g2890", label: "Stay with the vehicle — it's your biggest survival asse", icon: "sun.max.fill", destination: .technique("env-vehicle-breakdown-desert")),
                    TriageOption(id: "g2891", label: "Your car is a survival shelter — don't leave it", icon: "house.fill", destination: .technique("env-vehicle-breakdown-winter")),
                    TriageOption(id: "g2892", label: "Minimizing trauma during kinetic rotation", icon: "fish.fill", destination: .technique("env-vehicle-rollover-brace")),
                    TriageOption(id: "g2893", label: "Surviving civil unrest in a car", icon: "cloud.fill", destination: .technique("env-vehicle-riot-evasion"))
                ])
            )),
        ])
    }

}
