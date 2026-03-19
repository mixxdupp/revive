import Foundation

// Auto-generated: buildAnimalTriage extracted from ContentDatabase.swift
extension ContentDatabase {
    // =========================================================================
    // =========================================================================
    func buildAnimalTriage() -> TriageNode {
        TriageNode(id: "animal-root", question: "What is the situation?", options: [

            // --- ENCOUNTER (ESCAPE/AVOID) ---
            TriageOption(id: "an-enc-nearby", label: "Dangerous Animal Nearby", icon: "eye.fill", destination: .nextQuestion(
                TriageNode(id: "an-enc-q", question: "What animal?", options: [
                    // --- BEARS ---
                    TriageOption(id: "an-bear", label: "Bear", icon: "pawprint.fill", destination: .nextQuestion(
                        TriageNode(id: "an-bear-q", question: "What type / color?", options: [
                            TriageOption(id: "an-bear-black-seen", label: "Black Bear (Spotted Me)", icon: "eye.fill", destination: .technique("env-bear-black")),
                            TriageOption(id: "an-bear-black-unseen", label: "Black Bear (Unaware)", icon: "eye.slash.fill", destination: .technique("env-bear-black-avoid")),
                            TriageOption(id: "an-bear-grizzly-atk", label: "Grizzly (Actively Attacking)", icon: "exclamationmark.triangle.fill", destination: .technique("env-bear-grizzly")),
                            TriageOption(id: "an-bear-grizzly-calm", label: "Grizzly (Calm / Distant)", icon: "figure.walk", destination: .technique("env-bear-grizzly-avoid")),
                            TriageOption(id: "an-bear-polar", label: "Polar Bear", icon: "snowflake", destination: .technique("env-bear-polar"))
                        ])
                    )),

                    // --- CATS / WOLVES ---
                    TriageOption(id: "an-predator", label: "Cougar / Wolf / Coyote", icon: "cat.fill", destination: .nextQuestion(
                        TriageNode(id: "an-pred-q", question: "What animal?", options: [
                            TriageOption(id: "an-cougar", label: "Mountain Lion / Cougar", icon: "cat.fill", destination: .technique("env-cougar")),
                            TriageOption(id: "an-wolf", label: "Wolf Pack", icon: "pawprint.fill", destination: .technique("env-wolf"))
                        ])
                    )),

                    // --- HERBIVORES (MOOSE/ELK) ---
                    TriageOption(id: "an-moose", label: "Moose / Elk / Bison", icon: "ant.fill", destination: .technique("env-moose-elk")),

                    // --- REPTILES ---
                    TriageOption(id: "an-reptile", label: "Croc / Alligator", icon: "scribble.variable", destination: .technique("env-alligator"))
                ])
            )),

            // --- BITES & STINGS (FIRST AID) ---
            TriageOption(id: "an-enc-bitten", label: "I Was Bitten or Stung", icon: "bolt.fill", destination: .nextQuestion(
                TriageNode(id: "an-bite-q", question: "What caused the bite or sting?", options: [
            
                    // --- INSECTS / STINGS ---
                    TriageOption(id: "an-insect", label: "Insect Bite / Sting", icon: "ant.fill", destination: .nextQuestion(
                        TriageNode(id: "an-insect-q", question: "Trouble breathing?", options: [
                            TriageOption(id: "an-insect-anaph", label: "Yes — Swelling / Wheezing", icon: "exclamationmark.triangle.fill", destination: .technique("firstaid-anaphylaxis")),
                            TriageOption(id: "an-insect-norm", label: "No — Just Pain/Itch", icon: "checkmark.circle", destination: .technique("firstaid-sting-treat"))
                        ])
                    )),

                    // --- SNAKES ---
                    TriageOption(id: "an-snake", label: "Snake", icon: "scribble.variable", destination: .nextQuestion(
                        TriageNode(id: "an-snake-q", question: "Did it bite you?", options: [
                            TriageOption(id: "an-snake-bite", label: "Yes — bitten", icon: "exclamationmark.triangle.fill", destination: .technique("firstaid-snakebite")),
                            TriageOption(id: "an-snake-see-tri", label: "No — Triangular Head", icon: "triangle.fill", destination: .technique("env-snake-avoid"))
                        ])
                    )),
        
                    // --- BUGS ---
                    TriageOption(id: "an-bugs", label: "Insects / Spiders / Scorpions", icon: "ant.fill", destination: .nextQuestion(
                        TriageNode(id: "an-bug-q", question: "What happened?", options: [
                            TriageOption(id: "an-spider", label: "Bitten (Spider/Scorpion)", icon: "exclamationmark.triangle.fill", destination: .technique("firstaid-spider-bite")),
                            TriageOption(id: "an-tick", label: "Tick Attached", icon: "circle.fill", destination: .technique("env-tick-removal"))
                        ])
                    )),
        
                    // --- MARINE ---
                    TriageOption(id: "an-marine", label: "Shark / Jellyfish", icon: "fish.fill", destination: .nextQuestion(
                        TriageNode(id: "an-marine-q", question: "What animal?", options: [
                            TriageOption(id: "an-shark", label: "Shark", icon: "fish.fill", destination: .technique("env-shark")),
                            TriageOption(id: "an-jelly", label: "Jellyfish Sting", icon: "drop.fill", destination: .technique("env-jellyfish"))
                        ])
                    ))
                ])
            )),

            // --- ENVIRONMENT HAZARDS ---
            TriageOption(id: "an-env-hazard", label: "Environment Hazards", icon: "globe.americas.fill", destination: .nextQuestion(
                TriageNode(id: "an-env-q", question: "What environment?", options: [
                    TriageOption(id: "an-tropical", label: "Tropical Disease Risk", icon: "ladybug.fill", destination: .technique("env-tropical-disease-adv")),
                    TriageOption(id: "an-desert", label: "Desert Hazards", icon: "sun.max.fill", destination: .nextQuestion(
                        TriageNode(id: "an-desert-q", question: "What do you need?", options: [
                            TriageOption(id: "an-desert-travel", label: "Desert Travel", icon: "figure.walk", destination: .technique("env-desert-travel")),
                            TriageOption(id: "an-desert-night", label: "Night Travel", icon: "moon.fill", destination: .technique("env-desert-night-adv")),
                            TriageOption(id: "an-desert-shelter", label: "Desert Shelter", icon: "tent.fill", destination: .technique("env-desert-shelter")),
                            TriageOption(id: "an-desert-water", label: "Finding Water", icon: "drop.fill", destination: .technique("env-desert-water"))
                        ])
                    )),
                    TriageOption(id: "an-jungle", label: "Jungle Hazards", icon: "tree.fill", destination: .nextQuestion(
                        TriageNode(id: "an-jungle-q", question: "What do you need?", options: [
                            TriageOption(id: "an-jungle-move", label: "Jungle Movement", icon: "figure.walk", destination: .technique("env-jungle-movement")),
                            TriageOption(id: "an-jungle-travel", label: "Jungle Travel", icon: "arrow.right", destination: .technique("env-jungle-travel")),
                            TriageOption(id: "an-jungle-shelter", label: "Jungle Shelter", icon: "tent.fill", destination: .technique("env-jungle-shelter")),
                            TriageOption(id: "an-jungle-water", label: "Jungle Water Sources", icon: "drop.fill", destination: .technique("env-jungle-travel"))
                        ])
                    )),
                    TriageOption(id: "an-arctic", label: "Arctic Shelter & Survival", icon: "snowflake", destination: .technique("env-arctic-shelter"))
                ])
            )),

            // View Related Articles
            TriageOption(id: "animal-learn", label: "Learn More", icon: "book.fill", destination: .nextQuestion(
                TriageNode(id: "animal-learn-q", question: "What would you like to read about?", options: [
                    TriageOption(id: "animal-art-bites", label: "Bites & Envenomation", icon: "ant.fill", destination: .article("firstaid-article-bites")),
                    TriageOption(id: "animal-art-jungle", label: "Jungle Medicine", icon: "leaf.fill", destination: .article("env-article-jungle-medicine")),
                    TriageOption(id: "animal-art-desert", label: "Desert Hazards", icon: "sun.max.fill", destination: .article("env-article-desert")),
                    TriageOption(id: "animal-art-ocean", label: "Ocean Wildlife", icon: "water.waves", destination: .article("env-article-ocean")),
                    TriageOption(id: "animal-art-mountain", label: "Mountain Wildlife", icon: "mountain.2.fill", destination: .article("env-article-mountain")),
                    TriageOption(id: "animal-art-env-emerg", label: "Environmental Emergencies", icon: "exclamationmark.triangle.fill", destination: .articleList(["firstaid-article-environmental", "firstaid-article-environmental-emergencies"]))
                ])
            )),

        ])
    }

}
