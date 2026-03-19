import Foundation

// Auto-generated: buildVehicleTriage extracted from ContentDatabase.swift
extension ContentDatabase {
    // =========================================================================
    // =========================================================================
    func buildVehicleTriage() -> TriageNode {
        TriageNode(id: "vehicle-em-root", question: "What happened to the vehicle?", options: [

            // ── CRASH / IMPACT ──
            TriageOption(id: "veh-crash", label: "Crash / Impact", icon: "car.side.fill", destination: .nextQuestion(
                TriageNode(id: "veh-crash-q", question: "What's the situation?", options: [
                    TriageOption(id: "veh-submerged", label: "Submerged / Sinking in Water", icon: "water.waves", destination: .techniqueList(["env-vehicle-submersion-escape", "env-flood-vehicle-submergence"])),
                    TriageOption(id: "veh-rollover", label: "Rolled Over", icon: "arrow.triangle.2.circlepath", destination: .technique("env-vehicle-rollover-brace")),
                    TriageOption(id: "veh-fire", label: "Vehicle on Fire", icon: "flame", destination: .technique("env-vehicle-escape")),
                    TriageOption(id: "veh-trapped-inside", label: "Trapped Inside — Need to Break Out", icon: "rectangle.compress.vertical", destination: .technique("env-vehicle-entry")),
                    TriageOption(id: "veh-flood", label: "Floodwater Rising", icon: "cloud.rain.fill", destination: .technique("env-flash-flood-vehicle")),
                    TriageOption(id: "veh-injuries", label: "Injured — Need First Aid", icon: "cross.fill", destination: .technique("firstaid-scene-safety"))
                ])
            )),

            // ── STRANDED / BREAKDOWN ──
            TriageOption(id: "veh-breakdown", label: "Stranded / Breakdown", icon: "exclamationmark.triangle.fill", destination: .nextQuestion(
                TriageNode(id: "veh-break-q", question: "What environment?", options: [
                    TriageOption(id: "veh-break-desert", label: "Desert / Extreme Heat", icon: "sun.max.fill", destination: .technique("env-vehicle-breakdown-desert")),
                    TriageOption(id: "veh-break-winter", label: "Winter / Snow", icon: "snowflake", destination: .technique("env-vehicle-breakdown-winter")),
                    TriageOption(id: "veh-break-wildfire", label: "Wildfire Approaching", icon: "flame", destination: .technique("env-wildfire-vehicle")),
                    TriageOption(id: "veh-break-signal", label: "Need to Signal for Help", icon: "antenna.radiowaves.left.and.right", destination: .techniqueList(["rescue-vehicle-signal", "rescue-vehicle-signal-alt"]))
                ])
            )),

            // ── HOSTILE SITUATION ──
            TriageOption(id: "veh-hostile", label: "Mob / Road Threat", icon: "person.3.fill", destination: .technique("env-vehicle-riot-evasion")),

            // ── LANDSLIDE ──
            TriageOption(id: "veh-landslide", label: "Landslide / Debris", icon: "mountain.2.fill", destination: .technique("env-landslide-vehicle")),

            // View Related Articles
            TriageOption(id: "veh-learn", label: "Learn More", icon: "book.fill", destination: .nextQuestion(
                TriageNode(id: "veh-learn-q", question: "Vehicle safety topics?", options: [
                    TriageOption(id: "veh-art-kit", label: "Emergency Vehicle Kits", icon: "case.fill", destination: .article("tools-article-camp")),
                    TriageOption(id: "veh-art-signal", label: "Signaling from Vehicle", icon: "antenna.radiowaves.left.and.right", destination: .article("rescue-article-signaling"))
                ])
            ))
        ])
    }

}
