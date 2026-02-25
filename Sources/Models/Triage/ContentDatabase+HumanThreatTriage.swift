import Foundation

// Auto-generated: buildHumanThreatTriage extracted from ContentDatabase.swift
extension ContentDatabase {
    // =========================================================================
    // MARK: - HUMAN THREAT (NEW)
    // =========================================================================
    func buildHumanThreatTriage() -> TriageNode {
        TriageNode(id: "human-em-root", question: "What is the threat?", options: [
            TriageOption(id: "human-active", label: "Active Attacker / Pursuer", icon: "figure.run", destination: .nextQuestion(
                TriageNode(id: "human-active-q", question: "Can you escape?", options: [
                    TriageOption(id: "human-run", label: "Yes — Run / Evade", icon: "figure.run", destination: .technique("psych-evasion")),
                    TriageOption(id: "human-hide", label: "No — Need to Hide", icon: "eye.slash.fill", destination: .technique("shelter-camouflage")),
                    TriageOption(id: "human-fight", label: "Cornered — Self Defense", icon: "hand.raised.slash.fill", destination: .technique("psych-conflict-resolution")) 
                ])
            )),
            TriageOption(id: "human-riot", label: "Civil Unrest / Riot", icon: "person.3.fill", destination: .nextQuestion(
                TriageNode(id: "human-riot-q", question: "Location?", options: [
                    TriageOption(id: "human-riot-street", label: "On the Street", icon: "road.lanes", destination: .technique("psych-gray-man")),
                    TriageOption(id: "human-riot-car", label: "In a Vehicle", icon: "car.fill", destination: .technique("env-vehicle-escape")), // Placeholder
                    TriageOption(id: "human-riot-home", label: "At Home", icon: "house.fill", destination: .technique("shelter-barricade")) // Placeholder
                ])
            )),
            TriageOption(id: "human-stalk", label: "Being Followed", icon: "eye.fill", destination: .technique("psych-antisurveillance")), // Placeholder
            
            // Learn More
            TriageOption(id: "human-learn", label: "Learn More", icon: "book.fill", destination: .nextQuestion(
                TriageNode(id: "human-learn-q", question: "Security topics?", options: [
                    TriageOption(id: "human-art-psych", label: "Survival Psychology", icon: "brain.head.profile", destination: .article("psych-article-mindset")),
                    TriageOption(id: "human-art-sit", label: "Situational Awareness", icon: "eye.fill", destination: .article("psych-article-mindset"))
                ])
            ))
        ])
    }

}
