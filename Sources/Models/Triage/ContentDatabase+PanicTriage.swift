import Foundation

extension ContentDatabase {
    func buildPanicTriage() -> TriageNode {
        return TriageNode(id: "panic-root", question: "What is your primary mental or situational challenge right now?", options: [
            TriageOption(id: "panic-opt-1", label: "Overwhelming Fear / Hyperventilation", icon: "wind", destination: .techniqueList([
                "psych-box-breathing",
                "psych-54321-grounding",
                "psych-stop-method"
            ])),
            TriageOption(id: "panic-opt-2", label: "Isolation / Hopelessness", icon: "person.fill", destination: .techniqueList([
                "psych-will-to-live",
                "psych-routine",
                "psych-will-to-survive"
            ])),
            TriageOption(id: "panic-opt-3", label: "Exhaustion / Burnout", icon: "battery.25", destination: .techniqueList([
                "psych-cognitive-offloading",
                "psych-decision-fatigue",
                "psych-boredom-management"
            ])),
            TriageOption(id: "panic-opt-4", label: "Severe Anxiety / Dissociation", icon: "eye.trianglebadge.exclamationmark.fill", destination: .technique("psych-sensory-grounding")),
            TriageOption(id: "panic-opt-5", label: "Group Conflict / Leadership", icon: "person.3.fill", destination: .techniqueList([
                "psych-group-conflict",
                "psych-group-leadership",
                "psych-conflict-deescalation"
            ]))
        ])
    }
}
