import Foundation

// Rebuilt: Trapped/Rescue decision engine — hand-crafted only, domain-pure, zero dead ends
// All encyclopedia-generated template techniques purged for SSC quality
extension ContentDatabase {
    // =========================================================================
    // MARK: - TRAPPED / RESCUE
    // =========================================================================
    func buildTrappedTriage() -> TriageNode {
        TriageNode(id: "trapped-root", question: "What do you need help with?", options: [

            // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
            // 1. INJURED OR TRAPPED
            // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
            TriageOption(id: "trapped-injured-cat", label: "I'm Injured or Trapped", icon: "cross.case.fill", destination: .nextQuestion(
                TriageNode(id: "trapped-injury", question: "What type of injury?", options: [

                    // ── BLEEDING & SHOCK ──
                    TriageOption(id: "trapped-bleed-shock", label: "Bleeding & Shock", icon: "drop.fill", destination: .nextQuestion(
                        TriageNode(id: "trapped-bs-q", question: "What is the priority?", options: [
                            TriageOption(id: "trapped-bleed-limb", label: "Arm/Leg Bleeding", icon: "drop.fill", destination: .techniqueList(["firstaid-tourniquet", "firstaid-wound-packing", "firstaid-wound-closure", "firstaid-field-suturing"])),
                            TriageOption(id: "trapped-bleed-torso", label: "Torso / Chest Wound", icon: "heart.fill", destination: .techniqueList(["firstaid-chest-seal", "firstaid-sucking-chest-wound", "firstaid-wound-packing"])),
                            TriageOption(id: "trapped-bleed-head", label: "Head Wound", icon: "brain.head.profile", destination: .technique("firstaid-head-trauma")),
                            TriageOption(id: "trapped-bleed-impaled", label: "Object Impaled", icon: "pin.fill", destination: .technique("firstaid-impaled-object")),
                            TriageOption(id: "trapped-shock", label: "Shock Symptoms", icon: "bolt.heart.fill", destination: .techniqueList(["firstaid-recovery-position", "firstaid-cpr", "firstaid-shock"]))
                        ])
                    )),

                    // ── FRACTURES & HEAD INJURY ──
                    TriageOption(id: "trapped-bone-head", label: "Fracture / Head / Spine", icon: "figure.walk", destination: .nextQuestion(
                        TriageNode(id: "trapped-bh-q", question: "What is injured?", options: [
                            TriageOption(id: "trapped-frac-arm", label: "Arm / Wrist", icon: "figure.arms.open", destination: .techniqueList(["firstaid-arm-splint", "firstaid-sling"])),
                            TriageOption(id: "trapped-frac-leg", label: "Leg / Ankle", icon: "figure.walk", destination: .technique("firstaid-leg-splint")),
                            TriageOption(id: "trapped-dislocate", label: "Joint Dislocated", icon: "arrow.left.arrow.right", destination: .technique("firstaid-dislocated-joint")),
                            TriageOption(id: "trapped-sprain", label: "Sprain / Twist", icon: "bandage.fill", destination: .techniqueList(["firstaid-ankle-wrap", "firstaid-sprained-ankle"])),
                            TriageOption(id: "trapped-head-inj", label: "Head Trauma / Concussion", icon: "brain.head.profile", destination: .techniqueList(["firstaid-head-trauma", "firstaid-head-concussion", "firstaid-recovery-position"]))
                        ])
                    )),

                    // ── MEDICAL EMERGENCIES ──
                    TriageOption(id: "trapped-medical", label: "Breathing & Medical", icon: "cross.case.fill", destination: .nextQuestion(
                        TriageNode(id: "trapped-med-q", question: "What's happening?", options: [
                            TriageOption(id: "trapped-choke", label: "Choking on Object", icon: "exclamationmark.triangle.fill", destination: .technique("firstaid-choking")),
                            TriageOption(id: "trapped-breath", label: "Asthma / Smoke Inhalation", icon: "lungs.fill", destination: .techniqueList(["firstaid-asthma", "firstaid-recovery-position"])),
                            TriageOption(id: "trapped-heart", label: "Chest Pain / Heart Attack", icon: "heart.fill", destination: .techniqueList(["firstaid-heart-attack", "firstaid-chest-seal"])),
                            TriageOption(id: "trapped-stroke", label: "Stroke / Face Drooping", icon: "brain.head.profile", destination: .technique("firstaid-stroke")),
                            TriageOption(id: "trapped-allergy", label: "Severe Allergic Reaction", icon: "allergens.fill", destination: .technique("firstaid-allergic-reaction")),
                            TriageOption(id: "trapped-childbirth", label: "Emergency Childbirth", icon: "figure.2.and.child.holdinghands", destination: .technique("firstaid-childbirth"))
                        ])
                    )),

                    // ── BURNS ──
                    TriageOption(id: "trapped-burn", label: "Burns (Fire / Chem / Elec)", icon: "flame", destination: .nextQuestion(
                        TriageNode(id: "trapped-burn-type", question: "What caused the burn?", options: [
                            TriageOption(id: "trapped-burn-fire", label: "Fire / Heat (Thermal)", icon: "flame", destination: .techniqueList(["firstaid-burn-blister", "firstaid-burn-char", "firstaid-shock"])),
                            TriageOption(id: "trapped-burn-chem", label: "Chemicals", icon: "flask.fill", destination: .technique("firstaid-chemical-burn")),
                            TriageOption(id: "trapped-burn-electric", label: "Electrical", icon: "bolt.fill", destination: .techniqueList(["firstaid-burn-char", "firstaid-cpr", "firstaid-electrocution"]))
                        ])
                    )),

                    // ── VEHICLE & TRAPPED ──
                    TriageOption(id: "trapped-phys-veh", label: "Trapped / Vehicle Crash", icon: "car.fill", destination: .nextQuestion(
                        TriageNode(id: "trapped-veh-q", question: "What is the danger?", options: [
                            TriageOption(id: "trapped-veh-fire", label: "Vehicle Fire / Smoke", icon: "flame", destination: .article("fire-article-safety")),
                            TriageOption(id: "veh-pinned", label: "Pinned Inside Vehicle", icon: "car.fill", destination: .technique("rescue-vehicle-signal")),
                            TriageOption(id: "veh-safe-loc", label: "Safe Inside Vehicle (Wait)", icon: "checkmark.circle", destination: .techniqueList(["shelter-vehicle", "rescue-vehicle-signal"])),
                            TriageOption(id: "trapped-pinned", label: "Trapped Under Debris", icon: "rectangle.compress.vertical", destination: .techniqueList(["rescue-sos", "rescue-ground-signal", "rescue-horn-whistle-pattern"]))
                        ])
                    ))
                ])
            )),

            // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
            // 2. RESCUE & SIGNALING
            // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
            TriageOption(id: "trapped-rescue-cat", label: "Rescue & Signaling", icon: "antenna.radiowaves.left.and.right", destination: .nextQuestion(
                TriageNode(id: "trapped-rescue-q", question: "What do you need?", options: [

                    // ── SIGNALING FOR RESCUE ──
                    TriageOption(id: "trapped-signal", label: "Signal for Help", icon: "antenna.radiowaves.left.and.right.slash", destination: .nextQuestion(
                        TriageNode(id: "trapped-sig-q", question: "What can you use?", options: [
                            TriageOption(id: "sig-visual", label: "Visual Signals (Ground / Body)", icon: "square.fill", destination: .techniqueList(["rescue-sos", "rescue-ground-signal", "rescue-ground-to-air-signals", "rescue-attention-panel", "rescue-body-signals", "rescue-clothing-signals"])),
                            TriageOption(id: "sig-mirror", label: "Mirror / Reflective Surface", icon: "sun.max.fill", destination: .techniqueList(["rescue-reflective-signal", "rescue-sere-vector-signaling"])),
                            TriageOption(id: "sig-fire-phone", label: "Signal Fire / Phone", icon: "flame", destination: .techniqueList(["rescue-sos-signal-fire", "rescue-signal-fire-platform", "rescue-cell-phone-strategy", "rescue-cell-phone-emergency", "rescue-plb-activation"])),
                            TriageOption(id: "sig-whistle", label: "Whistle / Sound", icon: "speaker.wave.3.fill", destination: .techniqueList(["rescue-horn-whistle-pattern", "rescue-whistle-signals"])),
                            TriageOption(id: "sig-night", label: "Night Signals", icon: "moon.fill", destination: .techniqueList(["rescue-night-light-signals", "rescue-fire-arrow-signal", "rescue-tire-fire-smoke"])),
                            TriageOption(id: "sig-heli", label: "Helicopter Approaching", icon: "airplane", destination: .techniqueList(["rescue-helicopter-lz", "rescue-heli-lz-prep", "rescue-helicopter-lz-marking"]))
                        ])
                    )),

                    // ── SELF-RESCUE ──
                    TriageOption(id: "trapped-self", label: "Self-Rescue / Get Out", icon: "arrow.right.circle.fill", destination: .nextQuestion(
                        TriageNode(id: "trapped-self-q", question: "What's your situation?", options: [
                            TriageOption(id: "self-know-dir", label: "Know the Way Out", icon: "location.fill", destination: .technique("rescue-self-evacuation")),
                            TriageOption(id: "self-follow-water", label: "Follow Water Downhill", icon: "water.waves", destination: .technique("nav-following-water")),
                            TriageOption(id: "self-leave-markers", label: "Mark Path", icon: "signpost.right.fill", destination: .technique("rescue-leave-trail")),
                            TriageOption(id: "self-urban-escape", label: "Escape Building", icon: "building.2.fill", destination: .technique("rescue-urban-escape")),
                            TriageOption(id: "self-crevasse", label: "Fell Into Crevasse", icon: "arrow.down.to.line", destination: .technique("rescue-self-rescue-crevasse"))
                        ])
                    )),

                    // ── TERRAIN OBSTACLES ──
                    TriageOption(id: "trapped-terrain", label: "Terrain Obstacle", icon: "mountain.2.fill", destination: .nextQuestion(
                        TriageNode(id: "trapped-terrain-q", question: "What's blocking you?", options: [
                            TriageOption(id: "terrain-swamp", label: "Swamp / Wetland", icon: "water.waves", destination: .technique("env-swamp-survival")),
                            TriageOption(id: "terrain-river", label: "River Crossing", icon: "figure.pool.swim", destination: .techniqueList(["rescue-river-self", "rescue-river-rescue-self"])),
                            TriageOption(id: "terrain-cliff", label: "Cliff / Ledge", icon: "triangle.fill", destination: .technique("rescue-cliff-rescue-basics")),
                            TriageOption(id: "terrain-snow", label: "Deep Snow", icon: "snowflake", destination: .technique("rescue-snowshoe-construction")),
                            TriageOption(id: "terrain-rubble", label: "Urban Rubble", icon: "building.2.fill", destination: .technique("rescue-urban-rubble-rescue"))
                        ])
                    )),

                    // ── WATER RESCUE ──
                    TriageOption(id: "trapped-water-rescue", label: "Someone in Water", icon: "figure.pool.swim", destination: .nextQuestion(
                        TriageNode(id: "trapped-waterrescue-q", question: "What's happening?", options: [
                            TriageOption(id: "wr-reach", label: "Drowning — Reach / Throw", icon: "hand.raised.fill", destination: .technique("rescue-water-rescue-reach")),
                            TriageOption(id: "wr-mob", label: "Fell Overboard", icon: "exclamationmark.triangle.fill", destination: .technique("rescue-man-overboard")),
                            TriageOption(id: "wr-float", label: "Need to Float / Tread", icon: "drop.fill", destination: .techniqueList(["rescue-navy-drownproofing", "rescue-help-huddle-position", "rescue-flotation-improvised", "rescue-pants-flotation"]))
                        ])
                    )),

                    // ── MOVE AN INJURED PERSON ──
                    TriageOption(id: "trapped-transport", label: "Move Injured Person", icon: "figure.walk.motion", destination: .nextQuestion(
                        TriageNode(id: "trapped-transport-q", question: "How many helpers?", options: [
                            TriageOption(id: "transport-alone", label: "I'm Alone", icon: "person.fill", destination: .techniqueList(["rescue-firemans-carry", "rescue-litter-drag"])),
                            TriageOption(id: "transport-two", label: "Two People", icon: "person.2.fill", destination: .techniqueList(["rescue-two-person-seat-carry", "rescue-stretcher-improvised", "rescue-travois-construction"])),
                            TriageOption(id: "transport-prep", label: "Package for Transport", icon: "shippingbox.fill", destination: .technique("rescue-casualty-packaging"))
                        ])
                    ))
                ])
            )),

            // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
            // 3. STAYING MENTALLY STRONG
            // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
            TriageOption(id: "trapped-psych-cat", label: "Staying Mentally Strong", icon: "brain.head.profile", destination: .nextQuestion(
                TriageNode(id: "trapped-psych-q", question: "What do you need?", options: [
                    TriageOption(id: "tp-stop", label: "STOP Method (First Steps)", icon: "hand.raised.fill", destination: .technique("psych-stop-method")),
                    TriageOption(id: "tp-decision", label: "Decision Fatigue", icon: "questionmark.circle.fill", destination: .technique("psych-decision-fatigue")),
                    TriageOption(id: "tp-sleep-wait", label: "Sleep & Waiting", icon: "moon.fill", destination: .techniqueList(["psych-sleep-hygiene", "psych-sleep-deprivation", "psych-sleep-discipline", "psych-night-anxiety", "psych-boredom-management"])),
                    TriageOption(id: "tp-children", label: "Children in Survival", icon: "figure.and.child.holdinghands", destination: .technique("psych-children-survival")),
                    TriageOption(id: "tp-group", label: "Group Dynamics", icon: "person.3.fill", destination: .techniqueList(["psych-leadership-handoff", "psych-teach-to-cope"])),
                    TriageOption(id: "tp-morale", label: "Building Morale", icon: "heart.fill", destination: .techniqueList(["psych-cognitive-reframe", "psych-acceptance", "psych-acceptance-stages", "psych-humor", "psych-journaling", "psych-motivation-anchors", "psych-visualization", "psych-normalcy", "psych-grief-management"]))
                ])
            )),

            // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
            // 4. MAKING TOOLS & GEAR
            // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
            TriageOption(id: "trapped-tools-cat", label: "Making Tools & Gear", icon: "wrench.and.screwdriver.fill", destination: .nextQuestion(
                TriageNode(id: "trapped-tools-q", question: "What do you need to make?", options: [
                    TriageOption(id: "tool-knots", label: "Knots & Lashing", icon: "link", destination: .nextQuestion(
                        TriageNode(id: "tool-knots-q", question: "What's the purpose?", options: [
                            TriageOption(id: "tool-knot-loop", label: "Loop / Rescue", icon: "circle", destination: .techniqueList(["tools-bowline", "tools-alpine-butterfly"])),
                            TriageOption(id: "tool-knot-hitch", label: "Attach to Post", icon: "link", destination: .techniqueList(["tools-clove-hitch", "tools-taut-line", "tools-constrictor-knot"])),
                            TriageOption(id: "tool-knot-tension", label: "Tension Shelter Line", icon: "arrow.up.and.down", destination: .techniqueList(["tools-truckers-hitch", "tools-taut-line"])),
                            TriageOption(id: "tool-knot-join", label: "Join Two Ropes", icon: "arrow.triangle.merge", destination: .technique("tools-sheet-bend")),
                            TriageOption(id: "tool-knot-climb", label: "Climbing/Ascending", icon: "arrow.up", destination: .technique("tools-prusik-knot"))
                        ])
                    )),
                    TriageOption(id: "tool-cordage-opt", label: "Make Cordage / Rope", icon: "line.diagonal", destination: .technique("tools-cordage")),
                    TriageOption(id: "tool-stone", label: "Stone Tools (Knapping)", icon: "hammer.fill", destination: .technique("tools-flint-knapping")),
                    TriageOption(id: "tool-bone", label: "Bone & Natural Craft", icon: "leaf.fill", destination: .nextQuestion(
                        TriageNode(id: "tool-bone-q", question: "What material?", options: [
                            TriageOption(id: "tool-bone-items", label: "Bone (Needle/Hook)", icon: "pin.fill", destination: .techniqueList(["tools-bone-needle", "tools-bone-fishhook", "tools-improvised-saw"])),
                            TriageOption(id: "tool-bark-items", label: "Bark & Fiber", icon: "tree.fill", destination: .techniqueList(["tools-bark-cloth", "tools-bark-container-adv", "tools-hide-tanning"])),
                            TriageOption(id: "tool-clay-bamboo", label: "Clay / Bamboo", icon: "cylinder.fill", destination: .techniqueList(["tools-clay-pot", "tools-bamboo-tools", "tools-torch"])),
                            TriageOption(id: "tool-fishing-gear", label: "Fishing Gear", icon: "fish.fill", destination: .techniqueList(["tools-fish-hook", "tools-fishing-hooks", "tools-net-making", "tools-weighted-net"]))
                        ])
                    ))
                ])
            )),

            // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
            // 5. WAITING FOR RESCUE
            // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
            TriageOption(id: "trapped-waiting-cat", label: "Waiting for Rescue", icon: "clock.fill", destination: .nextQuestion(
                TriageNode(id: "trapped-needs", question: "What do you need most?", options: [
                    TriageOption(id: "trapped-need-water", label: "Water", icon: "drop.fill", destination: .techniqueList(["water-rain-collection", "water-dew-collection", "water-condensation-trap"])),
                    TriageOption(id: "trapped-need-warmth", label: "Warmth", icon: "flame", destination: .techniqueList(["shelter-mylar-wrap", "shelter-emergency-bivy", "firstaid-hypothermia"])),
                    TriageOption(id: "trapped-need-food", label: "Food", icon: "leaf.fill", destination: .techniqueList(["food-common-edibles", "food-cattail", "food-insect-eating", "food-shellfish", "food-frog-catching"])),
                    TriageOption(id: "trapped-need-morale", label: "Staying Calm", icon: "brain.head.profile", destination: .techniqueList(["psych-box-breathing", "psych-54321-grounding", "psych-routine", "psych-loneliness", "psych-ooda-loop", "psych-group-leadership", "psych-grief-processing", "psych-gratitude-practice", "psych-positive-self-talk"])),
                    TriageOption(id: "trapped-need-tools", label: "Making Gadgets", icon: "wrench.and.screwdriver.fill", destination: .techniqueList(["tools-trap-triggers", "tools-bow-making", "tools-stone-axe", "tools-spear-making", "tools-fire-hardened-spear", "tools-stone-drill", "tools-atlatl", "tools-sling", "tools-knife-sharpening", "tools-natural-glue", "tools-bark-container", "tools-sinew-cordage", "tools-repair", "tools-rock-hammer", "tools-square-lashing", "tools-improvised-container", "tools-water-carrier", "tools-camp-organization", "tools-charcoal-filter"]))
                ])
            )),

            // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
            // 6. LEARN & READ
            // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
            TriageOption(id: "trap-learn", label: "Learn More", icon: "book.fill", destination: .nextQuestion(
                TriageNode(id: "trap-learn-q", question: "What topic?", options: [
                    TriageOption(id: "trap-learn-mindset", label: "Survival Mindset", icon: "brain.head.profile", destination: .nextQuestion(
                        TriageNode(id: "trap-learn-mind-q", question: "Select article:", options: [
                            TriageOption(id: "trap-art-mindset", label: "Survival Mindset", icon: "brain.head.profile", destination: .article("psych-article-mindset")),
                            TriageOption(id: "trap-art-decisions", label: "Decisions Under Stress", icon: "arrow.triangle.branch", destination: .article("psych-article-decisions")),
                            TriageOption(id: "trap-art-group", label: "Group Dynamics", icon: "person.3.fill", destination: .article("psych-article-group")),
                            TriageOption(id: "trap-art-children", label: "Children in Survival", icon: "figure.and.child.holdinghands", destination: .articleList(["psych-article-children", "psych-article-children-management"])),
                            TriageOption(id: "trap-art-isolation", label: "Isolation Effects", icon: "person.fill.questionmark", destination: .articleList(["psych-article-isolation", "psych-article-isolation-effects"])),
                            TriageOption(id: "trap-art-sleep", label: "Sleep Deprivation", icon: "moon.zzz.fill", destination: .articleList(["psych-article-sleep", "psych-article-sleep-deprivation"]))
                        ])
                    )),
                    TriageOption(id: "trap-learn-skills", label: "Skills & Knots", icon: "lasso", destination: .nextQuestion(
                        TriageNode(id: "trap-learn-skill-q", question: "Select article:", options: [
                            TriageOption(id: "trap-art-knots", label: "Essential Knots", icon: "lasso", destination: .article("tools-article-knots")),
                            TriageOption(id: "trap-art-cordage", label: "Cordage & Rope", icon: "line.diagonal", destination: .article("tools-article-cordage")),
                            TriageOption(id: "trap-art-stone", label: "Stone Tool Craft", icon: "fossil.shell.fill", destination: .articleList(["tools-article-stone", "tools-article-stone-tools"])),
                            TriageOption(id: "trap-art-blade", label: "Blade & Edge Tools", icon: "scissors", destination: .article("tools-article-blade")),
                            TriageOption(id: "trap-art-trapping", label: "Trapping Theory", icon: "hare.fill", destination: .article("tools-article-trapping"))
                        ])
                    )),
                    TriageOption(id: "trap-learn-camp", label: "Camp & Tools", icon: "tent.fill", destination: .nextQuestion(
                        TriageNode(id: "trap-learn-camp-q", question: "Select article:", options: [
                            TriageOption(id: "trap-art-containers", label: "Making Containers", icon: "cup.and.saucer.fill", destination: .article("tools-article-containers")),
                            TriageOption(id: "trap-art-adhesives", label: "Natural Adhesives", icon: "drop.fill", destination: .article("tools-article-adhesives")),
                            TriageOption(id: "trap-art-leather", label: "Leather Working", icon: "rectangle.fill", destination: .article("tools-article-leather")),
                            TriageOption(id: "trap-art-camp", label: "Camp Craft", icon: "tent.fill", destination: .article("tools-article-camp")),
                            TriageOption(id: "trap-art-repair", label: "Field Repairs", icon: "wrench.fill", destination: .article("tools-article-repair"))
                        ])
                    )),
                    TriageOption(id: "trap-learn-longterm", label: "Long-Term & Recovery", icon: "calendar", destination: .nextQuestion(
                        TriageNode(id: "trap-learn-lt-q", question: "Select article:", options: [
                            TriageOption(id: "trap-art-night", label: "Surviving the Night", icon: "moon.fill", destination: .article("psych-article-night")),
                            TriageOption(id: "trap-art-longterm", label: "Long-Term Survival", icon: "calendar", destination: .article("psych-article-longterm")),
                            TriageOption(id: "trap-art-postrescue", label: "Post-Rescue Recovery", icon: "heart.circle.fill", destination: .article("psych-article-postrescue")),
                            TriageOption(id: "trap-art-fishing", label: "Fishing Technology", icon: "fish.fill", destination: .article("tools-article-fishing-tech"))
                        ])
                    ))
                ])
            ))
        ])
    }
}
