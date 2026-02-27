import Foundation

extension ContentDatabase {
    func buildGearTriage() -> TriageNode {
        return TriageNode(id: "gear-root", question: "What category of tool or gear do you need to fabricate?", options: [
            TriageOption(id: "gear-1", label: "Cutting & Piercing", icon: "scissors", destination: .techniqueList([
                "tools-stone-blade-knapping",
                "tools-friction-saw",
                "tools-tool-bone-awl"
            ])),
            TriageOption(id: "gear-2", label: "Cordage & Binding", icon: "link", destination: .nextQuestion(
                TriageNode(id: "gear-nq-cordage", question: "What material or purpose are you working with?", options: [
                    TriageOption(id: "gear-2a", label: "Plant Fibers (Spinning)", icon: "leaf.fill", destination: .techniqueList([
                        "tools-rope-from-plants",
                        "tools-craft-cordage-reverse-wrap"
                    ])),
                    TriageOption(id: "gear-2b", label: "Tree Bark / Roots", icon: "tree.fill", destination: .technique("tools-bark-rope")),
                    TriageOption(id: "gear-2c", label: "Animal Hide", icon: "pawprint.fill", destination: .technique("tools-rawhide-making"))
                ])
            )),
            TriageOption(id: "gear-3", label: "Adhesives (Glue / Pitch)", icon: "drop.fill", destination: .techniqueList([
                "tools-tool-pine-pitch-glue",
                "tools-hide-glue",
                "tools-birch-tar-adhesive"
            ])),
            TriageOption(id: "gear-4", label: "Containers & Vessels", icon: "cup.and.saucer.fill", destination: .nextQuestion(
                TriageNode(id: "gear-nq-vessels", question: "What material are you using?", options: [
                    TriageOption(id: "gear-4a", label: "Clay / Mud (Ceramics)", icon: "lanyardcard", destination: .techniqueList([
                        "tools-craft-clay-processing",
                        "tools-craft-coil-pottery",
                        "tools-pottery-pit-firing"
                    ])),
                    TriageOption(id: "gear-4b", label: "Wood / Birch Bark", icon: "tree.fill", destination: .technique("tools-birch-bark-basket")),
                    TriageOption(id: "gear-4c", label: "Animal Hide", icon: "pawprint.fill", destination: .technique("tools-rawhide-production"))
                ])
            )),
            TriageOption(id: "gear-5", label: "Hunting & Weapons", icon: "target", destination: .techniqueList([
                "tools-weapon-hunting-boomerang",
                "tools-weapon-atlatl-fabrication",
                "tools-fish-spear-multi",
                "tools-fish-hook-bone"
            ])),
            TriageOption(id: "gear-6", label: "Knots & Hitches", icon: "lasso", destination: .nextQuestion(
                TriageNode(id: "gear-nq-knots", question: "What type of knot do you need?", options: [
                    TriageOption(id: "gear-knot-1", label: "Joining Two Ropes", icon: "link", destination: .techniqueList([
                        "tools-reef-knot",
                        "tools-sheet-bend",
                        "tools-double-fishermans",
                        "tools-water-knot"
                    ])),
                    TriageOption(id: "gear-knot-2", label: "Loops (Fixed or Sliding)", icon: "infinity", destination: .techniqueList([
                        "tools-figure-eight-loop",
                        "tools-bowline-on-bight",
                        "tools-honda-knot",
                        "tools-scaffold-knot"
                    ])),
                    TriageOption(id: "gear-knot-3", label: "Binding & Constricting", icon: "bandage.fill", destination: .techniqueList([
                        "tools-constrictor-knot",
                        "tools-marlinspike-hitch",
                        "tools-icicle-hitch" 
                    ])),
                    TriageOption(id: "gear-knot-4", label: "Tensioning (Guy Lines)", icon: "arrow.up.and.down", destination: .techniqueList([
                        "tools-truckers-hitch",
                        "tools-adjustable-grip-hitch"
                    ])),
                    TriageOption(id: "gear-knot-5", label: "Friction & Climbing", icon: "figure.climbing", destination: .techniqueList([
                        "tools-prusik-knot",
                        "tools-klemheist-knot",
                        "tools-munter-hitch"
                    ]))
                ])
            ))
        ])
    }
}
