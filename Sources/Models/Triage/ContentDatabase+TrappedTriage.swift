import Foundation

// Auto-generated: buildTrappedTriage extracted from ContentDatabase.swift
extension ContentDatabase {
    // =========================================================================
    // MARK: - TRAPPED / RESCUE (5 levels deep)
    // =========================================================================
    func buildTrappedTriage() -> TriageNode {
        TriageNode(id: "trapped-root", question: "Can you move freely?", options: [

            // CAN MOVE
            TriageOption(id: "trapped-can-move", label: "Yes — Can Move", icon: "figure.walk", destination: .nextQuestion(
                TriageNode(id: "trapped-block", question: "What's preventing rescue?", options: [

                    // No one knows
                    TriageOption(id: "trapped-no-signal", label: "No One Knows I'm Here", icon: "antenna.radiowaves.left.and.right.slash", destination: .nextQuestion(
                        TriageNode(id: "trapped-sig-tools", question: "What signaling tools do you have?", options: [
                            TriageOption(id: "trapped-nothing-sig", label: "Nothing — No Tools", icon: "xmark.circle.fill", destination: .nextQuestion(
                                TriageNode(id: "trapped-prim-sig", question: "What's around you?", options: [
                                    TriageOption(id: "trapped-open-ground", label: "Open Ground / Clearing", icon: "square.fill", destination: .nextQuestion(
                                        TriageNode(id: "trapped-vis-signal", question: "Visual Signal Type?", options: [
                                            TriageOption(id: "trapped-sos-large", label: "Large SOS", icon: "exclamationmark.circle", destination: .technique("rescue-sos")),
                                        ])
                                    )),
                                    TriageOption(id: "trapped-heli", label: "Helicopter Might Come", icon: "airplane", destination: .technique("rescue-helicopter-lz"))
                                ])
                            ))
                        ])
                    )),

                    // Terrain blocked
                    TriageOption(id: "trapped-terrain", label: "Terrain Blocked", icon: "mountain.2.fill", destination: .nextQuestion(
                        TriageNode(id: "trapped-terrain-q", question: "What's blocking you?", options: [
                            TriageOption(id: "trapped-swamp", label: "Swamp / Wetland", icon: "water.waves", destination: .technique("env-swamp-survival"))
                        ])
                    )),

                    // Self-rescue
                    TriageOption(id: "trapped-self", label: "Want to Self-Rescue", icon: "arrow.right.circle.fill", destination: .nextQuestion(
                        TriageNode(id: "trapped-self-q", question: "Do you know which direction?", options: [
                            TriageOption(id: "trapped-know-dir", label: "Yes — Know the Way", icon: "location.fill", destination: .techniqueList(["rescue-self-rescue", "rescue-self-evacuation"])), // Added orphan
                            TriageOption(id: "trapped-follow-water", label: "No — Follow Water Downhill", icon: "water.waves", destination: .technique("nav-following-water")),
                            TriageOption(id: "trapped-leave-markers", label: "Mark Path for Rescuers", icon: "signpost.right.fill", destination: .technique("rescue-leave-trail"))
                        ])
                    ))
                ])
            )),

            // CANNOT MOVE
            TriageOption(id: "trapped-no-move", label: "No — Injured / Pinned", icon: "figure.roll", destination: .nextQuestion(
                TriageNode(id: "trapped-immobile", question: "What's the situation?", options: [

                    // Injured
                    TriageOption(id: "trapped-injured", label: "Injured — Need First Aid", icon: "cross.case.fill", destination: .nextQuestion(
                        TriageNode(id: "trapped-injury", question: "What type of injury?", options: [

                            // ── BLEEDING ──
                            TriageOption(id: "trapped-bleeding", label: "Bleeding Heavily", icon: "drop.fill", destination: .nextQuestion(
                                TriageNode(id: "trapped-bleed-q", question: "Where is the bleeding?", options: [
                                    TriageOption(id: "trapped-bleed-limb", label: "Arm or Leg", icon: "figure.arms.open", destination: .nextQuestion(
                                        TriageNode(id: "trapped-bleed-type", question: "Is blood spurting?", options: [
                                            TriageOption(id: "trapped-bleed-art", label: "Yes — Spurting (Arterial)", icon: "drop.fill", destination: .nextQuestion(
                                                TriageNode(id: "trapped-tq-mat", question: "What can you use as a tourniquet?", options: [
                                                ])
                                            )),
                                            TriageOption(id: "trapped-bleed-ven", label: "No — Flowing (Venous)", icon: "drop", destination: .nextQuestion(
                                                TriageNode(id: "trapped-ven-q", question: "Can you apply pressure?", options: [
                                                    TriageOption(id: "trapped-ven-suture", label: "Deep Gash (Needs Closing)", icon: "pencil.line", destination: .techniqueList(["firstaid-wound-closure", "firstaid-field-suturing"])) // Added orphan
                                                ])
                                            ))
                                        ])
                                    )),
                                    TriageOption(id: "trapped-bleed-torso", label: "Torso / Chest", icon: "heart.fill", destination: .nextQuestion(
                                        TriageNode(id: "trapped-torso-q", question: "Type of wound?", options: [
                                        ])
                                    )),
                                    TriageOption(id: "trapped-bleed-head", label: "Head Wound", icon: "brain.head.profile", destination: .technique("firstaid-head-trauma")),
                                    TriageOption(id: "trapped-bleed-impaled", label: "Object Impaled", icon: "pin.fill", destination: .technique("firstaid-impaled-object"))
                                ])
                            )),

                            // ── FRACTURES ──
                            TriageOption(id: "trapped-broken", label: "Possible Fracture / Dislocation", icon: "bandage.fill", destination: .nextQuestion(
                                TriageNode(id: "trapped-fracture-q", question: "Which body part?", options: [
                                    TriageOption(id: "trapped-frac-arm", label: "Arm / Wrist", icon: "figure.arms.open", destination: .nextQuestion(
                                        TriageNode(id: "trapped-arm-type", question: "Is bone visible through skin?", options: [
                                            TriageOption(id: "trapped-arm-open", label: "Yes — Open Fracture (Bone Out)", icon: "exclamationmark.triangle.fill", destination: .techniqueList(["firstaid-wound-cleaning", "firstaid-arm-splint"])),
                                            TriageOption(id: "trapped-arm-closed", label: "No — Closed (Swollen/Deformed)", icon: "bandage.fill", destination: .nextQuestion(
                                                TriageNode(id: "trapped-arm-splint-mat", question: "Splint material available?", options: [
                                                ])
                                            ))
                                        ])
                                    )),
                                    TriageOption(id: "trapped-frac-leg", label: "Leg / Ankle", icon: "figure.walk", destination: .nextQuestion(
                                        TriageNode(id: "trapped-leg-type", question: "Is bone visible through skin?", options: [
                                            TriageOption(id: "trapped-leg-open", label: "Yes — Open Fracture", icon: "exclamationmark.triangle.fill", destination: .techniqueList(["firstaid-wound-cleaning", "firstaid-leg-splint"])),
                                            TriageOption(id: "trapped-leg-closed", label: "No — Closed Fracture", icon: "bandage.fill", destination: .nextQuestion(
                                                TriageNode(id: "trapped-leg-splint-mat", question: "Splint material?", options: [
                                                ])
                                            ))
                                        ])
                                    )),
                                    TriageOption(id: "trapped-dislocate", label: "Joint Popped Out", icon: "arrow.left.arrow.right", destination: .nextQuestion(
                                        TriageNode(id: "trapped-disloc-q", question: "Which joint?", options: [
                                            TriageOption(id: "trapped-disloc-shoulder", label: "Shoulder", icon: "figure.arms.open", destination: .technique("firstaid-dislocated-joint")),
                                        ])
                                    )),
                                    TriageOption(id: "trapped-sprain", label: "Sprain / Twist (Swelling)", icon: "bandage.fill", destination: .techniqueList(["firstaid-ankle-wrap", "firstaid-sprained-ankle", "firstaid-blister"])) // Added orphans
                                ])
                            )),

                            // ── IMPALED / CRUSH ──

                            // ── SHOCK ──
                            TriageOption(id: "trapped-shock", label: "Shock Symptoms", icon: "heart.fill", destination: .nextQuestion(
                                TriageNode(id: "trapped-shock-q", question: "Is the person conscious?", options: [
                                    TriageOption(id: "trapped-shock-conscious", label: "Yes — Conscious", icon: "eye.fill", destination: .nextQuestion(
                                        TriageNode(id: "trapped-shock-con-q", question: "Can they lie down?", options: [
                                        ])
                                    )),
                                    TriageOption(id: "trapped-shock-uncon", label: "No — Unconscious", icon: "zzz", destination: .nextQuestion(
                                        TriageNode(id: "trapped-shock-uncon-q", question: "Are they breathing?", options: [
                                        ])
                                    ))
                                ])
                            )),

                            // ── BURNS ──
                            TriageOption(id: "trapped-burn", label: "Burn Injury", icon: "flame", destination: .nextQuestion(
                                TriageNode(id: "trapped-burn-type", question: "What caused the burn?", options: [
                                    TriageOption(id: "trapped-burn-fire", label: "Fire / Heat (Thermal)", icon: "flame", destination: .nextQuestion(
                                        TriageNode(id: "trapped-burn-deg", question: "Appearance?", options: [
                                            TriageOption(id: "burn-deg-2", label: "Blisters / Red / Wet", icon: "drop.fill", destination: .nextQuestion(
                                                TriageNode(id: "burn-2-area", question: "How large is the burn?", options: [
                                                    TriageOption(id: "burn-2-small", label: "Small (Palm-Sized or Less)", icon: "hand.raised.fill", destination: .technique("firstaid-burn-blister")),
                                                    TriageOption(id: "burn-2-large", label: "Large (Bigger Than Palm)", icon: "exclamationmark.triangle.fill", destination: .techniqueList(["firstaid-burn-blister", "firstaid-shock"])),
                                                    TriageOption(id: "burn-2-face", label: "Face / Hands / Genitals", icon: "exclamationmark.circle.fill", destination: .techniqueList(["firstaid-burn-blister", "firstaid-shock"]))
                                                ])
                                            )),
                                            TriageOption(id: "burn-deg-3", label: "Charred / Black / White", icon: "circle.fill", destination: .nextQuestion(
                                                TriageNode(id: "burn-3-airway", question: "Any breathing issues?", options: [
                                                    TriageOption(id: "burn-3-breath-ok", label: "No — Breathing Fine", icon: "checkmark.circle", destination: .technique("firstaid-burn-char")),
                                                    TriageOption(id: "burn-3-breath-bad", label: "Yes — Coughing / Soot Around Nose", icon: "lungs.fill", destination: .techniqueList(["firstaid-burn-char", "firstaid-asthma"])),
                                                    TriageOption(id: "burn-3-face", label: "Burns on Face / Neck", icon: "exclamationmark.triangle.fill", destination: .techniqueList(["firstaid-burn-char", "firstaid-shock"]))
                                                ])
                                            ))
                                        ])
                                    )),
                                    TriageOption(id: "trapped-burn-chem", label: "Chemicals", icon: "flask.fill", destination: .nextQuestion(
                                        TriageNode(id: "burn-chem-q", question: "Water available to flush?", options: [
                                            TriageOption(id: "burn-chem-water", label: "Yes — Have Water", icon: "drop.fill", destination: .technique("firstaid-chemical-burn")),
                                        ])
                                    )),
                                    TriageOption(id: "trapped-burn-electric", label: "Electrical", icon: "bolt.fill", destination: .techniqueList(["firstaid-burn-char", "firstaid-cpr", "firstaid-electrocution"])) // Added orphan
                                ])
                            )),

                            // ── HEAD TRAUMA ──
                            TriageOption(id: "trapped-head-inj", label: "Head Injury / Concussion", icon: "brain.head.profile", destination: .nextQuestion(
                                TriageNode(id: "trapped-head-q", question: "Is the person conscious?", options: [
                                    TriageOption(id: "head-unconscious", label: "Unconscious / Waking Up", icon: "zzz", destination: .nextQuestion(
                                        TriageNode(id: "head-uncon-q", question: "Are they breathing?", options: [
                                        ])
                                    )),
                                    TriageOption(id: "head-conscious", label: "Conscious", icon: "eye.fill", destination: .nextQuestion(
                                        TriageNode(id: "trapped-head-symp", question: "Check symptoms:", options: [
                                            TriageOption(id: "head-pupil-normal", label: "Normal Pupils / Dizzy", icon: "checkmark.circle", destination: .technique("firstaid-head-concussion")),
                                        ])
                                    ))
                                ])
                            )),

                            // ── ALLERGIC REACTION ──
                            TriageOption(id: "trapped-allergy", label: "Allergic Reaction", icon: "allergens.fill", destination: .nextQuestion(
                                TriageNode(id: "trapped-allergy-q", question: "How severe?", options: [
                                    TriageOption(id: "trapped-allergy-severe", label: "Throat Swelling / Can't Breathe", icon: "exclamationmark.triangle.fill", destination: .nextQuestion(
                                        TriageNode(id: "trapped-allergy-epi", question: "EpiPen / Adrenaline available?", options: [
                                        ])
                                    )),
                                    TriageOption(id: "trapped-allergy-mild", label: "Hives / Itching / Mild Swelling", icon: "hand.raised.fill", destination: .technique("firstaid-allergic-reaction")),
                                ])
                            )),

                            // ── MEDICAL EMERGENCIES ──
                            TriageOption(id: "trapped-heart", label: "Chest Pain / Heart Attack Signs", icon: "heart.fill", destination: .nextQuestion(
                                TriageNode(id: "trapped-heart-q", question: "Is the person conscious?", options: [
                                    TriageOption(id: "trapped-heart-con", label: "Yes — Conscious", icon: "eye.fill", destination: .techniqueList(["firstaid-heart-attack", "firstaid-chest-seal"])), // Added orphan
                                ])
                            )),
                            TriageOption(id: "trapped-stroke", label: "Face Drooping / Slurred Speech", icon: "brain.head.profile", destination: .technique("firstaid-stroke")),
                            TriageOption(id: "trapped-breathing", label: "Can't Breathe / Asthma", icon: "lungs.fill", destination: .nextQuestion(
                                TriageNode(id: "trapped-breath-q", question: "What's happening?", options: [
                                    TriageOption(id: "trapped-choke", label: "Choking on Object", icon: "exclamationmark.triangle.fill", destination: .technique("firstaid-choking")),
                                    TriageOption(id: "trapped-smoke-inhal", label: "Smoke Inhalation", icon: "smoke.fill", destination: .techniqueList(["firstaid-asthma", "firstaid-recovery-position"]))
                                ])
                            )),
                            TriageOption(id: "trapped-childbirth", label: "Emergency Childbirth", icon: "figure.2.and.child.holdinghands", destination: .technique("firstaid-childbirth")), // Added orphan
                        ])
                    )),

                    // Physically pinned
                    TriageOption(id: "trapped-pinned", label: "Physically Trapped / Pinned", icon: "rectangle.compress.vertical", destination: .nextQuestion(
                        TriageNode(id: "trapped-pinned-q", question: "Can you attract attention?", options: [
                        ])
                    )),

                    // Waiting for rescue
                    TriageOption(id: "trapped-waiting", label: "Safe — Waiting for Rescue", icon: "clock.fill", destination: .nextQuestion(
                        TriageNode(id: "trapped-needs", question: "What do you need most?", options: [
                            TriageOption(id: "trapped-need-water", label: "Water", icon: "drop.fill", destination: .techniqueList(["water-rain-collection", "water-dew-collection", "water-condensation-trap"])),
                            TriageOption(id: "trapped-need-warmth", label: "Warmth", icon: "flame", destination: .techniqueList(["shelter-mylar-wrap", "shelter-emergency-bivy", "firstaid-hypothermia"])),
                            TriageOption(id: "trapped-need-food", label: "Food", icon: "leaf.fill", destination: .techniqueList(["food-common-edibles", "food-cattail", "food-insect-eating", "food-shellfish", "food-frog-catching"])),
                            TriageOption(id: "trapped-need-morale", label: "Staying Calm / Morale", icon: "brain.head.profile", destination: .techniqueList(["psych-box-breathing", "psych-54321-grounding", "psych-routine", "psych-loneliness", "psych-ooda-loop", "psych-group-leadership", "psych-grief-processing", "psych-gratitude-practice", "psych-positive-self-talk"])), // Added orphans
                            TriageOption(id: "trapped-need-morale", label: "Staying Calm / Morale", icon: "brain.head.profile", destination: .techniqueList(["psych-box-breathing", "psych-54321-grounding", "psych-routine", "psych-loneliness", "psych-ooda-loop", "psych-group-leadership", "psych-grief-processing", "psych-gratitude-practice", "psych-positive-self-talk"])), // Added orphans
                            TriageOption(id: "trapped-need-tools", label: "Making Tools / Traps", icon: "wrench.and.screwdriver.fill", destination: .techniqueList(["tools-trap-triggers", "tools-bow-making", "tools-stone-axe", "tools-spear-making", "tools-fire-hardened-spear", "tools-stone-drill", "tools-atlatl", "tools-sling", "tools-knife-sharpening", "tools-natural-glue", "tools-bark-container", "tools-sinew-cordage", "tools-repair", "tools-rock-hammer", "tools-square-lashing", "tools-improvised-container", "tools-water-carrier", "tools-camp-organization", "tools-charcoal-filter"])) // Added orphans
                        ])
                    )),

                    // Vehicle Accident
                    TriageOption(id: "trapped-vehicle", label: "Vehicle Accident / Crash", icon: "car.fill", destination: .nextQuestion(
                        TriageNode(id: "trapped-vehicle-q", question: "Immediate danger?", options: [
                            TriageOption(id: "veh-fire", label: "Fire / Smoke", icon: "flame", destination: .article("fire-article-safety")),
                            TriageOption(id: "veh-pinned", label: "Pinned Inside", icon: "rectangle.compress.vertical", destination: .technique("rescue-vehicle-signal")),
                            TriageOption(id: "veh-safe-loc", label: "Safe Location (Wait)", icon: "checkmark.circle", destination: .techniqueList(["shelter-vehicle", "rescue-vehicle-signal"]))
                        ])
                    ))
                ])
            )),

            // PSYCHOLOGY — WAITING TO BE RESCUED
            TriageOption(id: "trapped-psych", label: "Staying Mentally Strong", icon: "brain.head.profile", destination: .nextQuestion(
                TriageNode(id: "trapped-psych-q", question: "What do you need?", options: [
                    TriageOption(id: "tp-stop", label: "STOP Method (First Steps)", icon: "hand.raised.fill", destination: .technique("psych-stop-method")),
                    TriageOption(id: "tp-decision", label: "Decision Fatigue", icon: "questionmark.circle.fill", destination: .technique("psych-decision-fatigue")),
                    TriageOption(id: "tp-sleep", label: "Sleep Management", icon: "moon.fill", destination: .nextQuestion(
                        TriageNode(id: "tp-sleep-q", question: "What's the issue?", options: [
                            TriageOption(id: "tp-sleep-cant", label: "Can't Sleep", icon: "moon.zzz.fill", destination: .technique("psych-sleep-hygiene")),
                            TriageOption(id: "tp-sleep-deprived", label: "Sleep Deprived", icon: "exclamationmark.triangle.fill", destination: .technique("psych-sleep-deprivation")),
                            TriageOption(id: "tp-sleep-schedule", label: "Setting Sleep Discipline", icon: "clock.fill", destination: .technique("psych-sleep-discipline")),
                            TriageOption(id: "tp-night-anxiety", label: "Night Anxiety", icon: "moon.stars.fill", destination: .technique("psych-night-anxiety"))
                        ])
                    )),
                    TriageOption(id: "tp-boredom", label: "Boredom / Waiting", icon: "hourglass", destination: .technique("psych-boredom-management")),
                    TriageOption(id: "tp-children", label: "Children in Survival", icon: "figure.and.child.holdinghands", destination: .technique("psych-children-survival")),
                    TriageOption(id: "tp-group", label: "Group Dynamics", icon: "person.3.fill", destination: .nextQuestion(
                        TriageNode(id: "tp-group-q", question: "What's happening?", options: [
                            TriageOption(id: "tp-leadership", label: "Leadership Transfer", icon: "person.badge.key.fill", destination: .technique("psych-leadership-handoff")),
                            TriageOption(id: "tp-teach", label: "Teaching Others to Cope", icon: "person.fill.questionmark", destination: .technique("psych-teach-to-cope"))
                        ])
                    )),
                    TriageOption(id: "tp-morale", label: "Building Morale", icon: "heart.fill", destination: .nextQuestion(
                        TriageNode(id: "tp-morale-q", question: "What technique?", options: [
                            TriageOption(id: "tp-reframe", label: "Cognitive Reframing", icon: "brain.fill", destination: .technique("psych-cognitive-reframe")),
                            TriageOption(id: "tp-acceptance", label: "Acceptance & Stages", icon: "checkmark.circle", destination: .techniqueList(["psych-acceptance", "psych-acceptance-stages"])),
                            TriageOption(id: "tp-humor", label: "Humor as Survival Tool", icon: "face.smiling.fill", destination: .technique("psych-humor")),
                            TriageOption(id: "tp-journal", label: "Journaling / Record", icon: "note.text", destination: .technique("psych-journaling")),
                            TriageOption(id: "tp-motivation", label: "Motivation Anchors", icon: "star.fill", destination: .technique("psych-motivation-anchors")),
                            TriageOption(id: "tp-visualize", label: "Visualization", icon: "eye.fill", destination: .technique("psych-visualization")),
                            TriageOption(id: "tp-normalcy", label: "Creating Normalcy", icon: "clock.fill", destination: .technique("psych-normalcy")),
                            TriageOption(id: "tp-grief", label: "Processing Grief / Loss", icon: "heart.slash.fill", destination: .technique("psych-grief-management")),
                        ])
                    ))
                ])
            )),

            // TOOLCRAFT — WHILE TRAPPED OR WAITING
            TriageOption(id: "trapped-tools", label: "Craft Tools & Equipment", icon: "wrench.and.screwdriver.fill", destination: .nextQuestion(
                TriageNode(id: "trapped-tools-q", question: "What do you need to make?", options: [
                    TriageOption(id: "tool-knots", label: "Knots & Lashing", icon: "link", destination: .nextQuestion(
                        TriageNode(id: "tool-knots-q", question: "What knot?", options: [
                            TriageOption(id: "tool-bowline", label: "Bowline (Loop)", icon: "circle", destination: .technique("tools-bowline")),
                            TriageOption(id: "tool-clove", label: "Clove Hitch (Attach to Pole)", icon: "link", destination: .technique("tools-clove-hitch")),
                            TriageOption(id: "tool-trucker", label: "Trucker's Hitch (Tension)", icon: "arrow.up.and.down", destination: .technique("tools-truckers-hitch")),
                            TriageOption(id: "tool-taut", label: "Taut-Line (Adjustable)", icon: "line.diagonal", destination: .technique("tools-taut-line")),
                            TriageOption(id: "tool-prusik", label: "Prusik Knot (Climbing)", icon: "arrow.up", destination: .technique("tools-prusik-knot")),
                            TriageOption(id: "tool-sheet", label: "Sheet Bend (Join Ropes)", icon: "arrow.triangle.merge", destination: .technique("tools-sheet-bend")),
                            TriageOption(id: "tool-alpine", label: "Alpine Butterfly (Mid-Line)", icon: "figure.climbing", destination: .technique("tools-alpine-butterfly")),
                            TriageOption(id: "tool-constrictor", label: "Constrictor Knot (Grip)", icon: "xmark.circle", destination: .technique("tools-constrictor-knot"))
                        ])
                    )),
                    TriageOption(id: "tool-cordage-opt", label: "Make Cordage / Rope", icon: "line.diagonal", destination: .technique("tools-cordage")),
                    TriageOption(id: "tool-stone", label: "Stone Tools", icon: "hammer.fill", destination: .nextQuestion(
                        TriageNode(id: "tool-stone-q", question: "What tool?", options: [
                            TriageOption(id: "tool-flint", label: "Flint Knapping (Blades)", icon: "arrowtriangle.down.fill", destination: .technique("tools-flint-knapping")),
                        ])
                    )),
                    TriageOption(id: "tool-bone", label: "Bone & Natural Craft", icon: "leaf.fill", destination: .nextQuestion(
                        TriageNode(id: "tool-bone-q", question: "What to make?", options: [
                            TriageOption(id: "tool-bone-needle", label: "Bone Needle (Sewing)", icon: "pin.fill", destination: .technique("tools-bone-needle")),
                            TriageOption(id: "tool-bone-hook", label: "Bone Fish Hook", icon: "hook", destination: .technique("tools-bone-fishhook")),
                            TriageOption(id: "tool-clay-pot", label: "Clay Pot", icon: "cylinder.fill", destination: .technique("tools-clay-pot")),
                            TriageOption(id: "tool-bamboo", label: "Bamboo Tools", icon: "leaf.fill", destination: .technique("tools-bamboo-tools")),
                            TriageOption(id: "tool-net", label: "Net Making", icon: "square.grid.3x3.fill", destination: .technique("tools-net-making")),
                            TriageOption(id: "tool-saw", label: "Improvised Saw", icon: "scissors", destination: .technique("tools-improvised-saw")),
                            TriageOption(id: "tool-torch-opt", label: "Torch / Light", icon: "flashlight.on.fill", destination: .technique("tools-torch")),
                            TriageOption(id: "tool-bark-cloth", label: "Bark Cloth", icon: "tree.fill", destination: .technique("tools-bark-cloth")),
                            TriageOption(id: "tool-hide", label: "Hide Tanning", icon: "rectangle.fill", destination: .technique("tools-hide-tanning")),
                            TriageOption(id: "tool-bark-adv", label: "Advanced Bark Container", icon: "basket.fill", destination: .technique("tools-bark-container-adv")),
                            TriageOption(id: "tool-fish-hook", label: "Improvised Fish Hook", icon: "hook", destination: .techniqueList(["tools-fish-hook", "tools-fishing-hooks"])),
                            TriageOption(id: "tool-weighted-net", label: "Weighted Net", icon: "square.grid.3x3.fill", destination: .technique("tools-weighted-net"))
                        ])
                    ))
                ])
            )),

            // 📚 LEARN MORE
            TriageOption(id: "trap-learn", label: "Learn More", icon: "book.fill", destination: .nextQuestion(
                TriageNode(id: "trap-learn-q", question: "What would you like to read about?", options: [
                    TriageOption(id: "trap-art-mindset", label: "Survival Mindset", icon: "brain.head.profile", destination: .article("psych-article-mindset")),
                    TriageOption(id: "trap-art-decisions", label: "Decision Making Under Stress", icon: "arrow.triangle.branch", destination: .article("psych-article-decisions")),
                    TriageOption(id: "trap-art-group", label: "Group Dynamics", icon: "person.3.fill", destination: .article("psych-article-group")),
                    TriageOption(id: "trap-art-children", label: "Children in Survival", icon: "figure.and.child.holdinghands", destination: .articleList(["psych-article-children", "psych-article-children-management"])),
                    TriageOption(id: "trap-art-isolation", label: "Isolation Effects", icon: "person.fill.questionmark", destination: .articleList(["psych-article-isolation", "psych-article-isolation-effects"])),
                    TriageOption(id: "trap-art-sleep", label: "Sleep Deprivation", icon: "moon.zzz.fill", destination: .articleList(["psych-article-sleep", "psych-article-sleep-deprivation"])),
                    TriageOption(id: "trap-art-night", label: "Surviving the Night", icon: "moon.fill", destination: .article("psych-article-night")),
                    TriageOption(id: "trap-art-longterm", label: "Long-Term Survival", icon: "calendar", destination: .article("psych-article-longterm")),
                    TriageOption(id: "trap-art-postrescue", label: "Post-Rescue Recovery", icon: "heart.circle.fill", destination: .article("psych-article-postrescue")),
                    TriageOption(id: "trap-art-knots", label: "Essential Knots", icon: "lasso", destination: .article("tools-article-knots")),
                    TriageOption(id: "trap-art-cordage", label: "Cordage & Rope Making", icon: "line.diagonal", destination: .article("tools-article-cordage")),
                    TriageOption(id: "trap-art-stone", label: "Stone Tool Craft", icon: "fossil.shell.fill", destination: .articleList(["tools-article-stone", "tools-article-stone-tools"])),
                    TriageOption(id: "trap-art-blade", label: "Blade & Edge Tools", icon: "scissors", destination: .article("tools-article-blade")),
                    TriageOption(id: "trap-art-containers", label: "Making Containers", icon: "cup.and.saucer.fill", destination: .article("tools-article-containers")),
                    TriageOption(id: "trap-art-adhesives", label: "Natural Adhesives", icon: "drop.fill", destination: .article("tools-article-adhesives")),
                    TriageOption(id: "trap-art-leather", label: "Leather Working", icon: "rectangle.fill", destination: .article("tools-article-leather")),
                    TriageOption(id: "trap-art-camp", label: "Camp Craft", icon: "tent.fill", destination: .article("tools-article-camp")),
                    TriageOption(id: "trap-art-repair", label: "Field Repairs", icon: "wrench.fill", destination: .article("tools-article-repair")),
                    TriageOption(id: "trap-art-trapping", label: "Trapping Theory", icon: "hare.fill", destination: .article("tools-article-trapping")),
                    TriageOption(id: "trap-art-fishing", label: "Fishing Technology", icon: "fish.fill", destination: .article("tools-article-fishing-tech"))
                ])
            )),

            TriageOption(id: "g1806", label: "Captivity", icon: "eye.slash.fill", destination: .nextQuestion(
                TriageNode(id: "g1806-q", question: "Which best matches?", options: [
                    TriageOption(id: "g1807", label: "Mental strategies during captivity or abduction", icon: "brain.head.profile", destination: .technique("psych-hostage-survival")),
                    TriageOption(id: "g1808", label: "Maintain will and opportunities for escape or rescue", icon: "figure.walk.motion", destination: .technique("psych-captivity-survival")),
                    TriageOption(id: "g1809", label: "Recognize captor-bonding and maintain rescue-oriented m", icon: "location.north.fill", destination: .technique("psych-stockholm-prevention"))
                ])
            )),

            TriageOption(id: "g1810", label: "Cutting & Blades", icon: "scissors", destination: .nextQuestion(
                TriageNode(id: "g1810-q", question: "Which best matches?", options: [
                    TriageOption(id: "g1811", label: "Create a sharp cutting edge from bamboo", icon: "scissors", destination: .technique("tools-bamboo-knife"))
                ])
            )),

            TriageOption(id: "g1812", label: "Decision Making", icon: "brain.fill", destination: .nextQuestion(
                TriageNode(id: "g1812-q", question: "Which best matches?", options: [
                    TriageOption(id: "g1813", label: "Using external tools to reduce mental load", icon: "cross.case.fill", destination: .technique("psych-cognitive-offloading")),
                    TriageOption(id: "g1814", label: "Combat Hunter protocol for identifying anomalies.", icon: "scope", destination: .technique("psych-combat-baseline")),
                    TriageOption(id: "g1815", label: "Set survival priorities correctly every time", icon: "drop.fill", destination: .technique("psych-rule-of-threes")),
                    TriageOption(id: "g1816", label: "What to focus on first when everything goes wrong", icon: "drop.fill", destination: .technique("psych-survival-priorities"))
                ])
            )),

            TriageOption(id: "g1817", label: "Electronic Signals", icon: "antenna.radiowaves.left.and.right", destination: .nextQuestion(
                TriageNode(id: "g1817-q", question: "Which best matches?", options: [
                    TriageOption(id: "g1818", label: "Maximize a dying phone's rescue potential", icon: "bolt.fill", destination: .technique("rescue-cell-phone-strategy")),
                    TriageOption(id: "g1819", label: "Maximizing phone usefulness in survival situations", icon: "bolt.fill", destination: .technique("rescue-cell-phone-emergency")),
                    TriageOption(id: "g1820", label: "How to maximize the effectiveness of a rescue beacon", icon: "antenna.radiowaves.left.and.right", destination: .technique("rescue-plb-activation")),
                    TriageOption(id: "g1821", label: "Communicate visually over long distances using arm/flag", icon: "location.north.fill", destination: .technique("rescue-semaphore-basics")),
                    TriageOption(id: "g1822", label: "Use horn, whistle, or voice in recognized distress patt", icon: "antenna.radiowaves.left.and.right", destination: .technique("rescue-horn-whistle-pattern"))
                ])
            )),

            TriageOption(id: "g1823", label: "Evasion", icon: "eye.slash.fill", destination: .nextQuestion(
                TriageNode(id: "g1823-q", question: "Which best matches?", options: [
                    TriageOption(id: "g1824", label: "Confusing human or dog trackers following your trail", icon: "pawprint.fill", destination: .technique("env-evasion-tracker-confusion")),
                    TriageOption(id: "g1825", label: "Breaking up the human face outline with natural materia", icon: "cross.case.fill", destination: .technique("env-evasion-face-paint")),
                    TriageOption(id: "g1826", label: "Avoiding or navigating through controlled access points", icon: "cross.case.fill", destination: .technique("env-evasion-checkpoint")),
                    TriageOption(id: "g1827", label: "Specific techniques to defeat tracking dogs", icon: "pawprint.fill", destination: .technique("env-evasion-dog-evasion")),
                    TriageOption(id: "g1828", label: "Moving undetected through hostile terrain at night", icon: "cloud.rain.fill", destination: .technique("env-evasion-movement-night"))
                ])
            )),

            TriageOption(id: "g1829", label: "Fishing Tools", icon: "fish.fill", destination: .nextQuestion(
                TriageNode(id: "g1829-q", question: "What specifically?", options: [
                TriageOption(id: "g1830", label: "Long", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g1830-q", question: "Select:", options: [
                        TriageOption(id: "g1831", label: "Weave a funnel trap to catch fish passively", icon: "target", destination: .technique("tools-basket-fish-trap")),
                        TriageOption(id: "g1832", label: "Split-tip fishing spear — catches fish where hooks can'", icon: "fish.fill", destination: .technique("tools-fish-spear-multi"))
                    ])
                )),
                TriageOption(id: "g1833", label: "Splinter", icon: "bandage.fill", destination: .nextQuestion(
                    TriageNode(id: "g1833-q", question: "Select:", options: [
                        TriageOption(id: "g1834", label: "Carving functional hooks from bone or thorn", icon: "bandage.fill", destination: .technique("tools-fish-hook-bone")),
                        TriageOption(id: "g1835", label: "Carving a functional fish hook from animal bone or thor", icon: "bandage.fill", destination: .technique("tools-fish-bone-hook"))
                    ])
                )),
                TriageOption(id: "g1836", label: "Steel", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g1836-q", question: "Select:", options: [
                        TriageOption(id: "g1837", label: "Magnetizing a razor blade for emergency direction findi", icon: "fish.fill", destination: .technique("tools-improvised-compass")),
                        TriageOption(id: "g1838", label: "Building a self-tightening wire snare for small game", icon: "target", destination: .technique("tools-snare-wire-lock"))
                    ])
                )),
                TriageOption(id: "g1839", label: "Water", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g1839-q", question: "Select:", options: [
                        TriageOption(id: "g1840", label: "Throw-and-retrieve fishing net for shallow water", icon: "fish.fill", destination: .technique("tools-fishing-net-cast")),
                        TriageOption(id: "g1841", label: "Building a multi-stage filter", icon: "drop.fill", destination: .technique("tools-water-filtration-build"))
                    ])
                )),
                TriageOption(id: "g1842", label: "Trigger", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g1842-q", question: "Select:", options: [
                        TriageOption(id: "g1843", label: "Preventing accidental trigger during set", icon: "mouth.fill", destination: .technique("tools-deadfall-setting-safety")),
                        TriageOption(id: "g1844", label: "More sensitive than figure-4 — catches the lightest tou", icon: "target", destination: .technique("tools-deadfall-trap-paiute"))
                    ])
                ))
                ])
            )),

            TriageOption(id: "g1845", label: "Group Dynamics", icon: "person.3.fill", destination: .nextQuestion(
                TriageNode(id: "g1845-q", question: "What specifically?", options: [
                TriageOption(id: "g1846", label: "Children", icon: "figure.and.child.holdinghands", destination: .nextQuestion(
                    TriageNode(id: "g1846-q", question: "Select:", options: [
                        TriageOption(id: "g1847", label: "Keep kids calm, safe, and occupied", icon: "figure.and.child.holdinghands", destination: .technique("psych-children-manage")),
                        TriageOption(id: "g1848", label: "Age-appropriate crisis communication and task assignmen", icon: "figure.and.child.holdinghands", destination: .technique("psych-managing-children-crisis"))
                    ])
                )),
                TriageOption(id: "g1849", label: "Stress", icon: "brain.head.profile", destination: .nextQuestion(
                    TriageNode(id: "g1849-q", question: "Select:", options: [
                        TriageOption(id: "g1850", label: "Preserving group unity in high-stress survival scenario", icon: "flame.fill", destination: .technique("psych-conflict-deescalation")),
                        TriageOption(id: "g1851", label: "Resolve disputes before they become dangerous", icon: "brain.head.profile", destination: .technique("psych-group-conflict"))
                    ])
                )),
                TriageOption(id: "g1852", label: "Through", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g1852-q", question: "Select:", options: [
                        TriageOption(id: "g1853", label: "Prevent group despair through structured activities", icon: "heart.fill", destination: .technique("psych-morale-boosting")),
                        TriageOption(id: "g1854", label: "Maintain group spirit through structured activities", icon: "heart.fill", destination: .technique("psych-team-morale-games"))
                    ])
                )),
                TriageOption(id: "g1855", label: "Leadership", icon: "person.3.fill", destination: .nextQuestion(
                    TriageNode(id: "g1855-q", question: "Select:", options: [
                        TriageOption(id: "g1856", label: "Lead a group effectively when lives are at stake", icon: "person.3.fill", destination: .technique("psych-leadership-small-group")),
                        TriageOption(id: "g1857", label: "Provide effective leadership in a crisis group", icon: "person.3.fill", destination: .technique("psych-leadership-survival"))
                    ])
                )),
                TriageOption(id: "g1858", label: "Loss", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g1858-q", question: "Select:", options: [
                        TriageOption(id: "g1859", label: "Processing loss in a survival scenario", icon: "heart.slash.fill", destination: .technique("psych-grief-field-management")),
                        TriageOption(id: "g1860", label: "Establish communication and decision-making protocols", icon: "star.fill", destination: .technique("psych-survival-circle"))
                    ])
                ))
                ])
            )),

            TriageOption(id: "g1861", label: "Knots & Ropework", icon: "link", destination: .nextQuestion(
                TriageNode(id: "g1861-q", question: "What specifically?", options: [
                TriageOption(id: "g1862", label: "Lines", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g1862-q", question: "Select:", options: [
                        TriageOption(id: "g1863", label: "Infinitely adjustable tension on guy lines", icon: "bandage.fill", destination: .technique("tools-adjustable-grip-hitch")),
                        TriageOption(id: "g1864", label: "Simple rope join for equal-diameter lines", icon: "fish.fill", destination: .technique("tools-fishermans-knot")),
                        TriageOption(id: "g1865", label: "Weighted throwing knot for heaving lines", icon: "bandage.fill", destination: .technique("tools-monkey-fist")),
                        TriageOption(id: "g1866", label: "Adjustable tension knot — essential for guy lines", icon: "link", destination: .technique("tools-taut-line-hitch")),
                        TriageOption(id: "g1867", label: "An adjustable loop knot for use on lines under tension ", icon: "link", destination: .technique("tools-knot-taut-line-hitch"))
                    ])
                )),
                TriageOption(id: "g1868", label: "Adjustable", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g1868-q", question: "Select:", options: [
                        TriageOption(id: "g1869", label: "Adjustable noose — tightens under load for snares", icon: "target", destination: .technique("tools-scaffold-knot")),
                        TriageOption(id: "g1870", label: "Two adjustable loops from one rope — harness or rescue ", icon: "link", destination: .technique("tools-spanish-bowline"))
                    ])
                )),
                TriageOption(id: "g1871", label: "Tying", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g1871-q", question: "Select:", options: [
                        TriageOption(id: "g1872", label: "Tying two secure, non-slip loops in the middle of a rop", icon: "link", destination: .technique("tools-knot-bowline-on-a-bight")),
                        TriageOption(id: "g1873", label: "Instant-connect/disconnect fastener — no knot tying nee", icon: "link", destination: .technique("tools-toggle-knot")),
                        TriageOption(id: "g1874", label: "Used for tying down loads with mechanical advantage.", icon: "link", destination: .technique("tools-knot-truckers-hitch")),
                        TriageOption(id: "g1875", label: "A reliable knot for tying a rope to a post or ring.", icon: "link", destination: .technique("tools-knot-two-half-hitches")),
                        TriageOption(id: "g1876", label: "The only safe knot for tying tubular climbing webbing t", icon: "link", destination: .technique("tools-knot-water-knot-webbing"))
                    ])
                )),
                TriageOption(id: "g1877", label: "Ring", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g1877-q", question: "Select:", options: [
                        TriageOption(id: "g1878", label: "Most secure hitch to a ring or post — stays under shock", icon: "bolt.fill", destination: .technique("tools-anchor-hitch")),
                        TriageOption(id: "g1879", label: "Attach rope to a closed ring — no end access needed", icon: "link", destination: .technique("tools-lark-head-tether")),
                        TriageOption(id: "g1880", label: "General purpose tie-off to a ring or post", icon: "link", destination: .technique("tools-two-half-hitches"))
                    ])
                )),
                TriageOption(id: "g1881", label: "Constrictor", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g1881-q", question: "Select:", options: [
                        TriageOption(id: "g1882", label: "Applying the Constrictor Knot from ABOK Binding Knots u", icon: "list.bullet.clipboard.fill", destination: .technique("tools-encyclopedia-constrictor-knot-natural-fiber")),
                        TriageOption(id: "g1883", label: "Applying the Constrictor Knot from ABOK Binding Knots u", icon: "list.bullet.clipboard.fill", destination: .technique("tools-encyclopedia-constrictor-knot-paracord")),
                        TriageOption(id: "g1884", label: "Applying the Constrictor Knot from ABOK Binding Knots u", icon: "list.bullet.clipboard.fill", destination: .technique("tools-encyclopedia-constrictor-knot-synthetic-rope")),
                        TriageOption(id: "g1885", label: "Applying the Constrictor Knot from ABOK Binding Knots u", icon: "list.bullet.clipboard.fill", destination: .technique("tools-encyclopedia-constrictor-knot-webbing")),
                        TriageOption(id: "g1886", label: "One of the most secure binding knots. Often must be cut", icon: "link", destination: .technique("tools-knot-constrictor-knot"))
                    ])
                )),
                TriageOption(id: "g1887", label: "Knot", icon: "link", destination: .nextQuestion(
                    TriageNode(id: "g1887-q", question: "Select:", options: [
                        TriageOption(id: "g1888", label: "The king of knots. Forms a secure loop that will not ja", icon: "link", destination: .technique("tools-knot-bowline")),
                        TriageOption(id: "g1889", label: "Used to secure a rope to a post or tree quickly.", icon: "link", destination: .technique("tools-knot-clove-hitch")),
                        TriageOption(id: "g1890", label: "A strong, secure loop knot used extensively in climbing", icon: "link", destination: .technique("tools-knot-figure-eight-loop")),
                        TriageOption(id: "g1891", label: "The definitive knot for joining two ropes of different ", icon: "link", destination: .technique("tools-knot-sheet-bend")),
                        TriageOption(id: "g1892", label: "Used to secure a rope or line around an object. It is N", icon: "link", destination: .technique("tools-knot-square-knot-reef-knot"))
                    ])
                )),
                TriageOption(id: "g1893", label: "Hitch", icon: "link", destination: .nextQuestion(
                    TriageNode(id: "g1893-q", question: "Select:", options: [
                        TriageOption(id: "g1894", label: "Forms a secure loop in the middle of a continuous rope.", icon: "link", destination: .technique("tools-knot-alpine-butterfly")),
                        TriageOption(id: "g1895", label: "A simple friction knot used for belaying or rappelling ", icon: "flame.fill", destination: .technique("tools-knot-munter-hitch")),
                        TriageOption(id: "g1896", label: "A friction hitch used to attach a loop of cord around a", icon: "flame.fill", destination: .technique("tools-knot-prusik-knot")),
                        TriageOption(id: "g1897", label: "Used to attach a rope to a cylindrical object (logging/", icon: "link", destination: .technique("tools-knot-timber-hitch")),
                        TriageOption(id: "g1898", label: "Used specifically to join two pieces of flat webbing se", icon: "link", destination: .technique("tools-knot-water-knot"))
                    ])
                )),
                TriageOption(id: "g1899", label: "Identify", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g1899-q", question: "Select:", options: [
                        TriageOption(id: "g1900", label: "Used for joining two very heavy ropes or cables.", icon: "car.fill", destination: .technique("tools-knot-carrick-bend")),
                        TriageOption(id: "g1901", label: "The strongest way to join two ropes of equal diameter.", icon: "fish.fill", destination: .technique("tools-knot-double-fishermans")),
                        TriageOption(id: "g1902", label: "A quick-release knot used to secure boats or animals.", icon: "link", destination: .technique("tools-knot-moorings-hitch")),
                        TriageOption(id: "g1903", label: "Used to attach a rope to another rope or pole, resistin", icon: "ant.fill", destination: .technique("tools-knot-rolling-hitch")),
                        TriageOption(id: "g1904", label: "A highly secure end-to-end joining knot that is easy to", icon: "link", destination: .technique("tools-knot-zeppelin-bend"))
                    ])
                )),
                TriageOption(id: "g1905", label: "Lashing", icon: "link", destination: .nextQuestion(
                    TriageNode(id: "g1905-q", question: "Select:", options: [
                        TriageOption(id: "g1906", label: "Used to lash a series of smaller poles to longer suppor", icon: "link", destination: .technique("tools-knot-continuous-lashing")),
                        TriageOption(id: "g1907", label: "Used to bind two crossed poles together where they do n", icon: "link", destination: .technique("tools-knot-diagonal-lashing")),
                        TriageOption(id: "g1908", label: "Used to create A-frames or bipods from two poles.", icon: "link", destination: .technique("tools-knot-shear-lashing")),
                        TriageOption(id: "g1909", label: "Used to temporarily shorten a rope or bypass a frayed s", icon: "link", destination: .technique("tools-knot-sheepshank")),
                        TriageOption(id: "g1910", label: "Used to bind three poles together to form a freestandin", icon: "link", destination: .technique("tools-knot-tripod-lashing"))
                    ])
                )),
                TriageOption(id: "g1911", label: "Lashing (2)", icon: "link", destination: .nextQuestion(
                    TriageNode(id: "g1911-q", question: "Select:", options: [
                        TriageOption(id: "g1912", label: "A faster alternative to square lashing using a folded r", icon: "link", destination: .technique("tools-knot-japanese-mark-ii-lashing")),
                        TriageOption(id: "g1913", label: "A decorative and functional stopper knot used on lanyar", icon: "link", destination: .technique("tools-knot-matthew-walker-knot")),
                        TriageOption(id: "g1914", label: "Used to join two poles side-by-side to extend their len", icon: "link", destination: .technique("tools-knot-round-lashing")),
                        TriageOption(id: "g1915", label: "The most secure method of preventing an organic rope fr", icon: "link", destination: .technique("tools-knot-sailmakers-whipping")),
                        TriageOption(id: "g1916", label: "Used to quickly stop the end of a synthetic or natural ", icon: "link", destination: .technique("tools-knot-west-country-whipping"))
                    ])
                )),
                TriageOption(id: "g1917", label: "Rope", icon: "link", destination: .nextQuestion(
                    TriageNode(id: "g1917-q", question: "Select:", options: [
                        TriageOption(id: "g1918", label: "A bulky, heavy stopper knot that will not slip through ", icon: "link", destination: .technique("tools-knot-ashley-stopper-knot")),
                        TriageOption(id: "g1919", label: "Descending a cliff using only rope and your body as fri", icon: "flame.fill", destination: .technique("tools-body-rappel")),
                        TriageOption(id: "g1920", label: "Setting up a rope system for safely crossing rushing wa", icon: "link", destination: .technique("tools-highline-river")),
                        TriageOption(id: "g1921", label: "Crossing a gap on a fixed horizontal rope", icon: "link", destination: .technique("tools-tyrolean-traverse")),
                        TriageOption(id: "g1922", label: "Using rope to create 3:1 pulling force for rescues", icon: "figure.walk.motion", destination: .technique("tools-z-drag-pulley"))
                    ])
                )),
                TriageOption(id: "g1923", label: "Knot (2)", icon: "link", destination: .nextQuestion(
                    TriageNode(id: "g1923-q", question: "Select:", options: [
                        TriageOption(id: "g1924", label: "Optimal knots and tensioning for hammock camping", icon: "target", destination: .technique("tools-hammock-knot-system")),
                        TriageOption(id: "g1925", label: "Creating strong cordage from natural fibers", icon: "leaf.fill", destination: .technique("tools-rope-from-plants")),
                        TriageOption(id: "g1926", label: "Slide-and-grip for ascending ropes", icon: "link", destination: .technique("tools-prussik-knot")),
                        TriageOption(id: "g1927", label: "Join two ropes of equal thickness", icon: "link", destination: .technique("tools-reef-knot")),
                        TriageOption(id: "g1928", label: "Drag logs and heavy cylindrical objects", icon: "link", destination: .technique("tools-timber-hitch"))
                    ])
                )),
                TriageOption(id: "g1929", label: "Rope (2)", icon: "link", destination: .nextQuestion(
                    TriageNode(id: "g1929-q", question: "Select:", options: [
                        TriageOption(id: "g1930", label: "Secure a line to a horn cleat — boats and docks", icon: "link", destination: .technique("tools-cleat-hitch")),
                        TriageOption(id: "g1931", label: "Permanent rope-to-rope join — strongest bend", icon: "fish.fill", destination: .technique("tools-double-fishermans")),
                        TriageOption(id: "g1932", label: "Strongest fixed loop — climbing standard", icon: "link", destination: .technique("tools-figure-eight-loop")),
                        TriageOption(id: "g1933", label: "Belay without a device — rope-only friction brake", icon: "flame.fill", destination: .technique("tools-munter-hitch")),
                        TriageOption(id: "g1934", label: "Grip a loaded rope or pole — directional friction", icon: "bandage.fill", destination: .technique("tools-rolling-hitch"))
                    ])
                )),
                TriageOption(id: "g1935", label: "Poles", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g1935-q", question: "Select:", options: [
                        TriageOption(id: "g1936", label: "Arborist's slide-and-grip — superior to prusik on some ", icon: "bandage.fill", destination: .technique("tools-blakes-hitch")),
                        TriageOption(id: "g1937", label: "Join poles that cross at angles other than 90°", icon: "fish.fill", destination: .technique("tools-diagonal-lashing")),
                        TriageOption(id: "g1938", label: "Join parallel poles — bipods and extension poles", icon: "link", destination: .technique("tools-shear-lashing")),
                        TriageOption(id: "g1939", label: "Three-pole tripod for cooking, shelter, or water collec", icon: "flame.fill", destination: .technique("tools-tripod-lashing")),
                        TriageOption(id: "g1940", label: "Join flat webbing — the ONLY reliable webbing knot", icon: "link", destination: .technique("tools-water-knot"))
                    ])
                )),
                TriageOption(id: "g1941", label: "Rope (3)", icon: "link", destination: .nextQuestion(
                    TriageNode(id: "g1941-q", question: "Select:", options: [
                        TriageOption(id: "g1942", label: "Shorten rope without cutting — instant deployment", icon: "fish.fill", destination: .technique("tools-chain-sinnet")),
                        TriageOption(id: "g1943", label: "Permanent loop in rope end — stronger than any knot", icon: "eye.fill", destination: .technique("tools-eye-splice")),
                        TriageOption(id: "g1944", label: "One-way friction grip — slides up, locks down", icon: "bandage.fill", destination: .technique("tools-klemheist-knot")),
                        TriageOption(id: "g1945", label: "Create a temporary handle on a rope for hauling", icon: "link", destination: .technique("tools-marlinspike-hitch")),
                        TriageOption(id: "g1946", label: "Join two rope ends permanently — full strength", icon: "link", destination: .technique("tools-short-splice"))
                    ])
                )),
                TriageOption(id: "g1947", label: "Rope (4)", icon: "link", destination: .nextQuestion(
                    TriageNode(id: "g1947-q", question: "Select:", options: [
                        TriageOption(id: "g1948", label: "Quick field cordage from inner tree bark", icon: "leaf.fill", destination: .technique("tools-bark-rope")),
                        TriageOption(id: "g1949", label: "Coil rope for backpack carry — deploys tangle-free", icon: "fish.fill", destination: .technique("tools-butterfly-coil")),
                        TriageOption(id: "g1950", label: "Two interlocking loops — hobble animals or create handl", icon: "link", destination: .technique("tools-handcuff-knot")),
                        TriageOption(id: "g1951", label: "Create a lasso — a sliding loop for catching", icon: "link", destination: .technique("tools-honda-knot")),
                        TriageOption(id: "g1952", label: "Make rope from plant fibers — the universal technique", icon: "bandage.fill", destination: .technique("tools-reverse-wrap-cordage"))
                    ])
                )),
                TriageOption(id: "g1953", label: "Hitch (2)", icon: "link", destination: .nextQuestion(
                    TriageNode(id: "g1953-q", question: "Select:", options: [
                        TriageOption(id: "g1954", label: "Carabiner-assisted friction hitch — easier to release t", icon: "flame.fill", destination: .technique("tools-bachmann-knot")),
                        TriageOption(id: "g1955", label: "Attach a loop or sling to any object instantly", icon: "link", destination: .technique("tools-girth-hitch")),
                        TriageOption(id: "g1956", label: "Instant attachment to any post — seconds to tie", icon: "link", destination: .technique("tools-pile-hitch")),
                        TriageOption(id: "g1957", label: "Tie to a post with mittens on — one-handed cold weather", icon: "bandage.fill", destination: .technique("tools-siberian-hitch")),
                        TriageOption(id: "g1958", label: "Most reliable rope join — never jams, never slips", icon: "link", destination: .technique("tools-zeppelin-bend"))
                    ])
                )),
                TriageOption(id: "g1959", label: "Rope (5)", icon: "link", destination: .nextQuestion(
                    TriageNode(id: "g1959-q", question: "Select:", options: [
                        TriageOption(id: "g1960", label: "Mid-line double loop — no access to rope ends needed", icon: "link", destination: .technique("tools-bowline-on-bight")),
                        TriageOption(id: "g1961", label: "Two-loop bowline for harness or rescue seat", icon: "link", destination: .technique("tools-double-bowline")),
                        TriageOption(id: "g1962", label: "Quick-release hitch — pull the tail and it falls free", icon: "link", destination: .technique("tools-highwaymans-hitch")),
                        TriageOption(id: "g1963", label: "Grip smooth and tapered objects — works where nothing e", icon: "bandage.fill", destination: .technique("tools-icicle-hitch")),
                        TriageOption(id: "g1964", label: "Prevent rope ends from fraying — permanent fix", icon: "link", destination: .technique("tools-wrap-around-splice"))
                    ])
                )),
                TriageOption(id: "g1965", label: "Knot (3)", icon: "link", destination: .nextQuestion(
                    TriageNode(id: "g1965-q", question: "Select:", options: [
                        TriageOption(id: "g1966", label: "Attach a rope to a hook — will not slip off", icon: "fish.fill", destination: .technique("tools-cats-paw")),
                        TriageOption(id: "g1967", label: "Bulky stopper — grips inside knot holes", icon: "link", destination: .technique("tools-double-overhand")),
                        TriageOption(id: "g1968", label: "Larger stopper — easier to untie than overhand", icon: "link", destination: .technique("tools-figure-eight-stopper")),
                        TriageOption(id: "g1969", label: "Simplest stopper knot — prevents rope from pulling thro", icon: "link", destination: .technique("tools-overhand-knot")),
                        TriageOption(id: "g1970", label: "Quick-release temporary hold", icon: "link", destination: .technique("tools-slip-knot"))
                    ])
                )),
                TriageOption(id: "g1971", label: "Rope (6)", icon: "link", destination: .nextQuestion(
                    TriageNode(id: "g1971-q", question: "Select:", options: [
                        TriageOption(id: "g1972", label: "Heavy rope join — large cable connection", icon: "car.fill", destination: .technique("tools-carrick-bend")),
                        TriageOption(id: "g1973", label: "Three-way anchor — creates three loops from one point", icon: "link", destination: .technique("tools-masthead-knot")),
                        TriageOption(id: "g1974", label: "Create fishing nets, hammocks, and cargo nets from cord", icon: "fish.fill", destination: .technique("tools-net-making-knot")),
                        TriageOption(id: "g1975", label: "General-purpose strong post attachment", icon: "bandage.fill", destination: .technique("tools-round-turn-two-half")),
                        TriageOption(id: "g1976", label: "Bowline that holds in wet, slippery rope", icon: "link", destination: .technique("tools-water-bowline"))
                    ])
                )),
                TriageOption(id: "g1977", label: "Rope (7)", icon: "link", destination: .nextQuestion(
                    TriageNode(id: "g1977-q", question: "Select:", options: [
                        TriageOption(id: "g1978", label: "A secure loop in the middle of a rope that takes a load", icon: "bandage.fill", destination: .technique("tools-knot-alpine-butterfly-loop")),
                        TriageOption(id: "g1979", label: "Maintain rope strength — know when to retire a rope", icon: "car.fill", destination: .technique("tools-rope-care-field")),
                        TriageOption(id: "g1980", label: "An advanced friction hitch with immense gripping power ", icon: "flame.fill", destination: .technique("tools-knot-icicle-hitch")),
                        TriageOption(id: "g1981", label: "Carry 10+ feet of cordage on your wrist", icon: "car.fill", destination: .technique("tools-paracord-bracelet")),
                        TriageOption(id: "g1982", label: "A bowline variant that will not jam when wet.", icon: "link", destination: .technique("tools-knot-water-bowline"))
                    ])
                )),
                TriageOption(id: "g1983", label: "Abok", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g1983-q", question: "Select:", options: [
                        TriageOption(id: "g1984", label: "Applying the Figure Eight from ABOK Stopper Knots using", icon: "list.bullet.clipboard.fill", destination: .technique("tools-encyclopedia-figure-eight-natural-fiber")),
                        TriageOption(id: "g1985", label: "Applying the Figure Eight from ABOK Stopper Knots using", icon: "list.bullet.clipboard.fill", destination: .technique("tools-encyclopedia-figure-eight-paracord")),
                        TriageOption(id: "g1986", label: "Applying the Figure Eight from ABOK Stopper Knots using", icon: "list.bullet.clipboard.fill", destination: .technique("tools-encyclopedia-figure-eight-synthetic-rope")),
                        TriageOption(id: "g1987", label: "Joining two ropes of unequal diameter securely.", icon: "link", destination: .technique("tools-knot-sheet-bend-double")),
                        TriageOption(id: "g1988", label: "A highly secure, jam-resistant bend for joining two rop", icon: "link", destination: .technique("tools-knot-zeppelins-bend"))
                    ])
                )),
                TriageOption(id: "g1989", label: "Abok (2)", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g1989-q", question: "Select:", options: [
                        TriageOption(id: "g1990", label: "Applying the Figure Eight from ABOK Stopper Knots using", icon: "list.bullet.clipboard.fill", destination: .technique("tools-encyclopedia-figure-eight-webbing")),
                        TriageOption(id: "g1991", label: "Applying the Stevedore Knot from ABOK Stopper Knots usi", icon: "list.bullet.clipboard.fill", destination: .technique("tools-encyclopedia-stevedore-knot-natural-fiber")),
                        TriageOption(id: "g1992", label: "Applying the Stevedore Knot from ABOK Stopper Knots usi", icon: "list.bullet.clipboard.fill", destination: .technique("tools-encyclopedia-stevedore-knot-paracord")),
                        TriageOption(id: "g1993", label: "Applying the Stevedore Knot from ABOK Stopper Knots usi", icon: "list.bullet.clipboard.fill", destination: .technique("tools-encyclopedia-stevedore-knot-synthetic-rope")),
                        TriageOption(id: "g1994", label: "Applying the Stevedore Knot from ABOK Stopper Knots usi", icon: "list.bullet.clipboard.fill", destination: .technique("tools-encyclopedia-stevedore-knot-webbing"))
                    ])
                )),
                TriageOption(id: "g1995", label: "Abok (3)", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g1995-q", question: "Select:", options: [
                        TriageOption(id: "g1996", label: "Applying the Multiple Overhand from ABOK Stopper Knots ", icon: "list.bullet.clipboard.fill", destination: .technique("tools-encyclopedia-multiple-overhand-paracord")),
                        TriageOption(id: "g1997", label: "Applying the Ossel Knot from ABOK Stopper Knots using N", icon: "list.bullet.clipboard.fill", destination: .technique("tools-encyclopedia-ossel-knot-natural-fiber")),
                        TriageOption(id: "g1998", label: "Applying the Ossel Knot from ABOK Stopper Knots using P", icon: "list.bullet.clipboard.fill", destination: .technique("tools-encyclopedia-ossel-knot-paracord")),
                        TriageOption(id: "g1999", label: "Applying the Ossel Knot from ABOK Stopper Knots using S", icon: "list.bullet.clipboard.fill", destination: .technique("tools-encyclopedia-ossel-knot-synthetic-rope")),
                        TriageOption(id: "g2000", label: "Applying the Ossel Knot from ABOK Stopper Knots using W", icon: "list.bullet.clipboard.fill", destination: .technique("tools-encyclopedia-ossel-knot-webbing"))
                    ])
                )),
                TriageOption(id: "g2001", label: "Abok (4)", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g2001-q", question: "Select:", options: [
                        TriageOption(id: "g2002", label: "Applying the Ashley's Stopper from ABOK Stopper Knots u", icon: "list.bullet.clipboard.fill", destination: .technique("tools-encyclopedia-ashleys-stopper-natural-fiber")),
                        TriageOption(id: "g2003", label: "Applying the Ashley's Stopper from ABOK Stopper Knots u", icon: "list.bullet.clipboard.fill", destination: .technique("tools-encyclopedia-ashleys-stopper-paracord")),
                        TriageOption(id: "g2004", label: "Applying the Multiple Overhand from ABOK Stopper Knots ", icon: "list.bullet.clipboard.fill", destination: .technique("tools-encyclopedia-multiple-overhand-natural-fiber")),
                        TriageOption(id: "g2005", label: "Applying the Multiple Overhand from ABOK Stopper Knots ", icon: "list.bullet.clipboard.fill", destination: .technique("tools-encyclopedia-multiple-overhand-synthetic-rope")),
                        TriageOption(id: "g2006", label: "Applying the Multiple Overhand from ABOK Stopper Knots ", icon: "list.bullet.clipboard.fill", destination: .technique("tools-encyclopedia-multiple-overhand-webbing"))
                    ])
                )),
                TriageOption(id: "g2007", label: "Abok (5)", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g2007-q", question: "Select:", options: [
                        TriageOption(id: "g2008", label: "Applying the Ashley's Stopper from ABOK Stopper Knots u", icon: "list.bullet.clipboard.fill", destination: .technique("tools-encyclopedia-ashleys-stopper-synthetic-rope")),
                        TriageOption(id: "g2009", label: "Applying the Ashley's Stopper from ABOK Stopper Knots u", icon: "list.bullet.clipboard.fill", destination: .technique("tools-encyclopedia-ashleys-stopper-webbing")),
                        TriageOption(id: "g2010", label: "Applying the Matthew Walker Knot from ABOK Stopper Knot", icon: "list.bullet.clipboard.fill", destination: .technique("tools-encyclopedia-matthew-walker-knot-natural-fiber")),
                        TriageOption(id: "g2011", label: "Applying the Matthew Walker Knot from ABOK Stopper Knot", icon: "list.bullet.clipboard.fill", destination: .technique("tools-encyclopedia-matthew-walker-knot-paracord")),
                        TriageOption(id: "g2012", label: "Applying the Matthew Walker Knot from ABOK Stopper Knot", icon: "list.bullet.clipboard.fill", destination: .technique("tools-encyclopedia-matthew-walker-knot-synthetic-rope"))
                    ])
                )),
                TriageOption(id: "g2013", label: "Abok (6)", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g2013-q", question: "Select:", options: [
                        TriageOption(id: "g2014", label: "Applying the Matthew Walker Knot from ABOK Stopper Knot", icon: "list.bullet.clipboard.fill", destination: .technique("tools-encyclopedia-matthew-walker-knot-webbing")),
                        TriageOption(id: "g2015", label: "Applying the Reef Knot from ABOK Binding Knots using Na", icon: "list.bullet.clipboard.fill", destination: .technique("tools-encyclopedia-reef-knot-natural-fiber")),
                        TriageOption(id: "g2016", label: "Applying the Reef Knot from ABOK Binding Knots using Pa", icon: "list.bullet.clipboard.fill", destination: .technique("tools-encyclopedia-reef-knot-paracord")),
                        TriageOption(id: "g2017", label: "Applying the Reef Knot from ABOK Binding Knots using Sy", icon: "list.bullet.clipboard.fill", destination: .technique("tools-encyclopedia-reef-knot-synthetic-rope")),
                        TriageOption(id: "g2018", label: "Applying the Reef Knot from ABOK Binding Knots using We", icon: "list.bullet.clipboard.fill", destination: .technique("tools-encyclopedia-reef-knot-webbing"))
                    ])
                )),
                TriageOption(id: "g2019", label: "Abok (7)", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g2019-q", question: "Select:", options: [
                        TriageOption(id: "g2020", label: "Applying the Granny Knot from ABOK Binding Knots using ", icon: "list.bullet.clipboard.fill", destination: .technique("tools-encyclopedia-granny-knot-paracord")),
                        TriageOption(id: "g2021", label: "Applying the Thief Knot from ABOK Binding Knots using N", icon: "list.bullet.clipboard.fill", destination: .technique("tools-encyclopedia-thief-knot-natural-fiber")),
                        TriageOption(id: "g2022", label: "Applying the Thief Knot from ABOK Binding Knots using P", icon: "list.bullet.clipboard.fill", destination: .technique("tools-encyclopedia-thief-knot-paracord")),
                        TriageOption(id: "g2023", label: "Applying the Thief Knot from ABOK Binding Knots using S", icon: "list.bullet.clipboard.fill", destination: .technique("tools-encyclopedia-thief-knot-synthetic-rope")),
                        TriageOption(id: "g2024", label: "Applying the Thief Knot from ABOK Binding Knots using W", icon: "list.bullet.clipboard.fill", destination: .technique("tools-encyclopedia-thief-knot-webbing"))
                    ])
                )),
                TriageOption(id: "g2025", label: "Abok (8)", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g2025-q", question: "Select:", options: [
                        TriageOption(id: "g2026", label: "Applying the Granny Knot from ABOK Binding Knots using ", icon: "list.bullet.clipboard.fill", destination: .technique("tools-encyclopedia-granny-knot-natural-fiber")),
                        TriageOption(id: "g2027", label: "Applying the Granny Knot from ABOK Binding Knots using ", icon: "list.bullet.clipboard.fill", destination: .technique("tools-encyclopedia-granny-knot-synthetic-rope")),
                        TriageOption(id: "g2028", label: "Applying the Granny Knot from ABOK Binding Knots using ", icon: "list.bullet.clipboard.fill", destination: .technique("tools-encyclopedia-granny-knot-webbing")),
                        TriageOption(id: "g2029", label: "Applying the Surgeon's Knot from ABOK Binding Knots usi", icon: "list.bullet.clipboard.fill", destination: .technique("tools-encyclopedia-surgeons-knot-natural-fiber")),
                        TriageOption(id: "g2030", label: "Applying the Surgeon's Knot from ABOK Binding Knots usi", icon: "list.bullet.clipboard.fill", destination: .technique("tools-encyclopedia-surgeons-knot-paracord"))
                    ])
                )),
                TriageOption(id: "g2031", label: "Abok (9)", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g2031-q", question: "Select:", options: [
                        TriageOption(id: "g2032", label: "Applying the Strangle Knot from ABOK Binding Knots usin", icon: "list.bullet.clipboard.fill", destination: .technique("tools-encyclopedia-strangle-knot-natural-fiber")),
                        TriageOption(id: "g2033", label: "Applying the Strangle Knot from ABOK Binding Knots usin", icon: "list.bullet.clipboard.fill", destination: .technique("tools-encyclopedia-strangle-knot-paracord")),
                        TriageOption(id: "g2034", label: "Applying the Strangle Knot from ABOK Binding Knots usin", icon: "list.bullet.clipboard.fill", destination: .technique("tools-encyclopedia-strangle-knot-synthetic-rope")),
                        TriageOption(id: "g2035", label: "Applying the Surgeon's Knot from ABOK Binding Knots usi", icon: "list.bullet.clipboard.fill", destination: .technique("tools-encyclopedia-surgeons-knot-synthetic-rope")),
                        TriageOption(id: "g2036", label: "Applying the Surgeon's Knot from ABOK Binding Knots usi", icon: "list.bullet.clipboard.fill", destination: .technique("tools-encyclopedia-surgeons-knot-webbing"))
                    ])
                )),
                TriageOption(id: "g2037", label: "Abok (10)", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g2037-q", question: "Select:", options: [
                        TriageOption(id: "g2038", label: "Applying the Miller's Knot from ABOK Binding Knots usin", icon: "list.bullet.clipboard.fill", destination: .technique("tools-encyclopedia-millers-knot-natural-fiber")),
                        TriageOption(id: "g2039", label: "Applying the Miller's Knot from ABOK Binding Knots usin", icon: "list.bullet.clipboard.fill", destination: .technique("tools-encyclopedia-millers-knot-paracord")),
                        TriageOption(id: "g2040", label: "Applying the Miller's Knot from ABOK Binding Knots usin", icon: "list.bullet.clipboard.fill", destination: .technique("tools-encyclopedia-millers-knot-synthetic-rope")),
                        TriageOption(id: "g2041", label: "Applying the Miller's Knot from ABOK Binding Knots usin", icon: "list.bullet.clipboard.fill", destination: .technique("tools-encyclopedia-millers-knot-webbing")),
                        TriageOption(id: "g2042", label: "Applying the Strangle Knot from ABOK Binding Knots usin", icon: "list.bullet.clipboard.fill", destination: .technique("tools-encyclopedia-strangle-knot-webbing"))
                    ])
                )),
                TriageOption(id: "g2043", label: "Abok (11)", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g2043-q", question: "Select:", options: [
                        TriageOption(id: "g2044", label: "Applying the Boa Knot from ABOK Binding Knots using Nat", icon: "list.bullet.clipboard.fill", destination: .technique("tools-encyclopedia-boa-knot-natural-fiber")),
                        TriageOption(id: "g2045", label: "Applying the Boa Knot from ABOK Binding Knots using Par", icon: "list.bullet.clipboard.fill", destination: .technique("tools-encyclopedia-boa-knot-paracord")),
                        TriageOption(id: "g2046", label: "Applying the Boa Knot from ABOK Binding Knots using Syn", icon: "list.bullet.clipboard.fill", destination: .technique("tools-encyclopedia-boa-knot-synthetic-rope")),
                        TriageOption(id: "g2047", label: "Applying the Boa Knot from ABOK Binding Knots using Web", icon: "list.bullet.clipboard.fill", destination: .technique("tools-encyclopedia-boa-knot-webbing")),
                        TriageOption(id: "g2048", label: "Applying the Honda Knot from ABOK Loop Knots using Para", icon: "list.bullet.clipboard.fill", destination: .technique("tools-encyclopedia-honda-knot-paracord"))
                    ])
                )),
                TriageOption(id: "g2049", label: "Abok (12)", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g2049-q", question: "Select:", options: [
                        TriageOption(id: "g2050", label: "Applying the Honda Knot from ABOK Loop Knots using Natu", icon: "list.bullet.clipboard.fill", destination: .technique("tools-encyclopedia-honda-knot-natural-fiber")),
                        TriageOption(id: "g2051", label: "Applying the Honda Knot from ABOK Loop Knots using Synt", icon: "list.bullet.clipboard.fill", destination: .technique("tools-encyclopedia-honda-knot-synthetic-rope")),
                        TriageOption(id: "g2052", label: "Applying the Honda Knot from ABOK Loop Knots using Webb", icon: "list.bullet.clipboard.fill", destination: .technique("tools-encyclopedia-honda-knot-webbing")),
                        TriageOption(id: "g2053", label: "Applying the Perfection Loop from ABOK Loop Knots using", icon: "list.bullet.clipboard.fill", destination: .technique("tools-encyclopedia-perfection-loop-natural-fiber")),
                        TriageOption(id: "g2054", label: "Applying the Perfection Loop from ABOK Loop Knots using", icon: "list.bullet.clipboard.fill", destination: .technique("tools-encyclopedia-perfection-loop-paracord"))
                    ])
                )),
                TriageOption(id: "g2055", label: "Loop", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g2055-q", question: "Select:", options: [
                        TriageOption(id: "g2056", label: "Applying the Artillery Loop from ABOK Loop Knots using ", icon: "list.bullet.clipboard.fill", destination: .technique("tools-encyclopedia-artillery-loop-natural-fiber")),
                        TriageOption(id: "g2057", label: "Applying the Artillery Loop from ABOK Loop Knots using ", icon: "list.bullet.clipboard.fill", destination: .technique("tools-encyclopedia-artillery-loop-paracord")),
                        TriageOption(id: "g2058", label: "Applying the Artillery Loop from ABOK Loop Knots using ", icon: "list.bullet.clipboard.fill", destination: .technique("tools-encyclopedia-artillery-loop-synthetic-rope")),
                        TriageOption(id: "g2059", label: "Applying the Perfection Loop from ABOK Loop Knots using", icon: "list.bullet.clipboard.fill", destination: .technique("tools-encyclopedia-perfection-loop-synthetic-rope")),
                        TriageOption(id: "g2060", label: "Applying the Perfection Loop from ABOK Loop Knots using", icon: "list.bullet.clipboard.fill", destination: .technique("tools-encyclopedia-perfection-loop-webbing"))
                    ])
                )),
                TriageOption(id: "g2061", label: "Loop (2)", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g2061-q", question: "Select:", options: [
                        TriageOption(id: "g2062", label: "Applying the Artillery Loop from ABOK Loop Knots using ", icon: "list.bullet.clipboard.fill", destination: .technique("tools-encyclopedia-artillery-loop-webbing")),
                        TriageOption(id: "g2063", label: "Applying the Farmer's Loop from ABOK Loop Knots using N", icon: "list.bullet.clipboard.fill", destination: .technique("tools-encyclopedia-farmers-loop-natural-fiber")),
                        TriageOption(id: "g2064", label: "Applying the Farmer's Loop from ABOK Loop Knots using P", icon: "list.bullet.clipboard.fill", destination: .technique("tools-encyclopedia-farmers-loop-paracord")),
                        TriageOption(id: "g2065", label: "Applying the Farmer's Loop from ABOK Loop Knots using S", icon: "list.bullet.clipboard.fill", destination: .technique("tools-encyclopedia-farmers-loop-synthetic-rope")),
                        TriageOption(id: "g2066", label: "Applying the Farmer's Loop from ABOK Loop Knots using W", icon: "list.bullet.clipboard.fill", destination: .technique("tools-encyclopedia-farmers-loop-webbing"))
                    ])
                )),
                TriageOption(id: "g2067", label: "Abok (13)", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g2067-q", question: "Select:", options: [
                        TriageOption(id: "g2068", label: "Applying the Portuguese Bowline from ABOK Loop Knots us", icon: "list.bullet.clipboard.fill", destination: .technique("tools-encyclopedia-portuguese-bowline-paracord")),
                        TriageOption(id: "g2069", label: "Applying the Spanish Bowline from ABOK Loop Knots using", icon: "list.bullet.clipboard.fill", destination: .technique("tools-encyclopedia-spanish-bowline-natural-fiber")),
                        TriageOption(id: "g2070", label: "Applying the Spanish Bowline from ABOK Loop Knots using", icon: "list.bullet.clipboard.fill", destination: .technique("tools-encyclopedia-spanish-bowline-paracord")),
                        TriageOption(id: "g2071", label: "Applying the Spanish Bowline from ABOK Loop Knots using", icon: "list.bullet.clipboard.fill", destination: .technique("tools-encyclopedia-spanish-bowline-synthetic-rope")),
                        TriageOption(id: "g2072", label: "Applying the Spanish Bowline from ABOK Loop Knots using", icon: "list.bullet.clipboard.fill", destination: .technique("tools-encyclopedia-spanish-bowline-webbing"))
                    ])
                )),
                TriageOption(id: "g2073", label: "Abok (14)", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g2073-q", question: "Select:", options: [
                        TriageOption(id: "g2074", label: "Applying the French Bowline from ABOK Loop Knots using ", icon: "list.bullet.clipboard.fill", destination: .technique("tools-encyclopedia-french-bowline-natural-fiber")),
                        TriageOption(id: "g2075", label: "Applying the French Bowline from ABOK Loop Knots using ", icon: "list.bullet.clipboard.fill", destination: .technique("tools-encyclopedia-french-bowline-paracord")),
                        TriageOption(id: "g2076", label: "Applying the Portuguese Bowline from ABOK Loop Knots us", icon: "list.bullet.clipboard.fill", destination: .technique("tools-encyclopedia-portuguese-bowline-natural-fiber")),
                        TriageOption(id: "g2077", label: "Applying the Portuguese Bowline from ABOK Loop Knots us", icon: "list.bullet.clipboard.fill", destination: .technique("tools-encyclopedia-portuguese-bowline-synthetic-rope")),
                        TriageOption(id: "g2078", label: "Applying the Portuguese Bowline from ABOK Loop Knots us", icon: "list.bullet.clipboard.fill", destination: .technique("tools-encyclopedia-portuguese-bowline-webbing"))
                    ])
                )),
                TriageOption(id: "g2079", label: "Abok (15)", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g2079-q", question: "Select:", options: [
                        TriageOption(id: "g2080", label: "Applying the Eskimo Bowline from ABOK Loop Knots using ", icon: "list.bullet.clipboard.fill", destination: .technique("tools-encyclopedia-eskimo-bowline-natural-fiber")),
                        TriageOption(id: "g2081", label: "Applying the Eskimo Bowline from ABOK Loop Knots using ", icon: "list.bullet.clipboard.fill", destination: .technique("tools-encyclopedia-eskimo-bowline-paracord")),
                        TriageOption(id: "g2082", label: "Applying the Eskimo Bowline from ABOK Loop Knots using ", icon: "list.bullet.clipboard.fill", destination: .technique("tools-encyclopedia-eskimo-bowline-synthetic-rope")),
                        TriageOption(id: "g2083", label: "Applying the French Bowline from ABOK Loop Knots using ", icon: "list.bullet.clipboard.fill", destination: .technique("tools-encyclopedia-french-bowline-synthetic-rope")),
                        TriageOption(id: "g2084", label: "Applying the French Bowline from ABOK Loop Knots using ", icon: "list.bullet.clipboard.fill", destination: .technique("tools-encyclopedia-french-bowline-webbing"))
                    ])
                )),
                TriageOption(id: "g2085", label: "Abok (16)", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g2085-q", question: "Select:", options: [
                        TriageOption(id: "g2086", label: "Applying the Clove Hitch from ABOK Hitches using Natura", icon: "list.bullet.clipboard.fill", destination: .technique("tools-encyclopedia-clove-hitch-natural-fiber")),
                        TriageOption(id: "g2087", label: "Applying the Clove Hitch from ABOK Hitches using Paraco", icon: "list.bullet.clipboard.fill", destination: .technique("tools-encyclopedia-clove-hitch-paracord")),
                        TriageOption(id: "g2088", label: "Applying the Clove Hitch from ABOK Hitches using Synthe", icon: "list.bullet.clipboard.fill", destination: .technique("tools-encyclopedia-clove-hitch-synthetic-rope")),
                        TriageOption(id: "g2089", label: "Applying the Clove Hitch from ABOK Hitches using Webbin", icon: "list.bullet.clipboard.fill", destination: .technique("tools-encyclopedia-clove-hitch-webbing")),
                        TriageOption(id: "g2090", label: "Applying the Eskimo Bowline from ABOK Loop Knots using ", icon: "list.bullet.clipboard.fill", destination: .technique("tools-encyclopedia-eskimo-bowline-webbing"))
                    ])
                )),
                TriageOption(id: "g2091", label: "Abok (17)", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g2091-q", question: "Select:", options: [
                        TriageOption(id: "g2092", label: "Applying the Cow Hitch from ABOK Hitches using Natural ", icon: "list.bullet.clipboard.fill", destination: .technique("tools-encyclopedia-cow-hitch-natural-fiber")),
                        TriageOption(id: "g2093", label: "Applying the Cow Hitch from ABOK Hitches using Paracord", icon: "list.bullet.clipboard.fill", destination: .technique("tools-encyclopedia-cow-hitch-paracord")),
                        TriageOption(id: "g2094", label: "Applying the Cow Hitch from ABOK Hitches using Syntheti", icon: "list.bullet.clipboard.fill", destination: .technique("tools-encyclopedia-cow-hitch-synthetic-rope")),
                        TriageOption(id: "g2095", label: "Applying the Cow Hitch from ABOK Hitches using Webbing.", icon: "list.bullet.clipboard.fill", destination: .technique("tools-encyclopedia-cow-hitch-webbing")),
                        TriageOption(id: "g2096", label: "Applying the Pile Hitch from ABOK Hitches using Paracor", icon: "list.bullet.clipboard.fill", destination: .technique("tools-encyclopedia-pile-hitch-paracord"))
                    ])
                )),
                TriageOption(id: "g2097", label: "Abok (18)", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g2097-q", question: "Select:", options: [
                        TriageOption(id: "g2098", label: "Applying the Buntline Hitch from ABOK Hitches using Nat", icon: "list.bullet.clipboard.fill", destination: .technique("tools-encyclopedia-buntline-hitch-natural-fiber")),
                        TriageOption(id: "g2099", label: "Applying the Buntline Hitch from ABOK Hitches using Par", icon: "list.bullet.clipboard.fill", destination: .technique("tools-encyclopedia-buntline-hitch-paracord")),
                        TriageOption(id: "g2100", label: "Applying the Pile Hitch from ABOK Hitches using Natural", icon: "list.bullet.clipboard.fill", destination: .technique("tools-encyclopedia-pile-hitch-natural-fiber")),
                        TriageOption(id: "g2101", label: "Applying the Pile Hitch from ABOK Hitches using Synthet", icon: "list.bullet.clipboard.fill", destination: .technique("tools-encyclopedia-pile-hitch-synthetic-rope")),
                        TriageOption(id: "g2102", label: "Applying the Pile Hitch from ABOK Hitches using Webbing", icon: "list.bullet.clipboard.fill", destination: .technique("tools-encyclopedia-pile-hitch-webbing"))
                    ])
                )),
                TriageOption(id: "g2103", label: "Abok (19)", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g2103-q", question: "Select:", options: [
                        TriageOption(id: "g2104", label: "Applying the Buntline Hitch from ABOK Hitches using Syn", icon: "list.bullet.clipboard.fill", destination: .technique("tools-encyclopedia-buntline-hitch-synthetic-rope")),
                        TriageOption(id: "g2105", label: "Applying the Buntline Hitch from ABOK Hitches using Web", icon: "list.bullet.clipboard.fill", destination: .technique("tools-encyclopedia-buntline-hitch-webbing")),
                        TriageOption(id: "g2106", label: "Applying the Magnus Hitch from ABOK Hitches using Natur", icon: "list.bullet.clipboard.fill", destination: .technique("tools-encyclopedia-magnus-hitch-natural-fiber")),
                        TriageOption(id: "g2107", label: "Applying the Magnus Hitch from ABOK Hitches using Parac", icon: "list.bullet.clipboard.fill", destination: .technique("tools-encyclopedia-magnus-hitch-paracord")),
                        TriageOption(id: "g2108", label: "Applying the Magnus Hitch from ABOK Hitches using Synth", icon: "list.bullet.clipboard.fill", destination: .technique("tools-encyclopedia-magnus-hitch-synthetic-rope"))
                    ])
                )),
                TriageOption(id: "g2109", label: "Abok (20)", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g2109-q", question: "Select:", options: [
                        TriageOption(id: "g2110", label: "Applying the Magnus Hitch from ABOK Hitches using Webbi", icon: "list.bullet.clipboard.fill", destination: .technique("tools-encyclopedia-magnus-hitch-webbing")),
                        TriageOption(id: "g2111", label: "Applying the Midshipman's Hitch from ABOK Hitches using", icon: "list.bullet.clipboard.fill", destination: .technique("tools-encyclopedia-midshipmans-hitch-natural-fiber")),
                        TriageOption(id: "g2112", label: "Applying the Midshipman's Hitch from ABOK Hitches using", icon: "list.bullet.clipboard.fill", destination: .technique("tools-encyclopedia-midshipmans-hitch-paracord")),
                        TriageOption(id: "g2113", label: "Applying the Midshipman's Hitch from ABOK Hitches using", icon: "list.bullet.clipboard.fill", destination: .technique("tools-encyclopedia-midshipmans-hitch-synthetic-rope")),
                        TriageOption(id: "g2114", label: "Applying the Midshipman's Hitch from ABOK Hitches using", icon: "list.bullet.clipboard.fill", destination: .technique("tools-encyclopedia-midshipmans-hitch-webbing"))
                    ])
                )),
                TriageOption(id: "g2115", label: "Abok (21)", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g2115-q", question: "Select:", options: [
                        TriageOption(id: "g2116", label: "Applying the Farrimond Friction Hitch from ABOK Hitches", icon: "list.bullet.clipboard.fill", destination: .technique("tools-encyclopedia-farrimond-friction-hitch-paracord")),
                        TriageOption(id: "g2117", label: "Applying the Taut-line Hitch from ABOK Hitches using Na", icon: "list.bullet.clipboard.fill", destination: .technique("tools-encyclopedia-taut-line-hitch-natural-fiber")),
                        TriageOption(id: "g2118", label: "Applying the Taut-line Hitch from ABOK Hitches using Pa", icon: "list.bullet.clipboard.fill", destination: .technique("tools-encyclopedia-taut-line-hitch-paracord")),
                        TriageOption(id: "g2119", label: "Applying the Taut-line Hitch from ABOK Hitches using Sy", icon: "list.bullet.clipboard.fill", destination: .technique("tools-encyclopedia-taut-line-hitch-synthetic-rope")),
                        TriageOption(id: "g2120", label: "Applying the Taut-line Hitch from ABOK Hitches using We", icon: "list.bullet.clipboard.fill", destination: .technique("tools-encyclopedia-taut-line-hitch-webbing"))
                    ])
                )),
                TriageOption(id: "g2121", label: "Abok (22)", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g2121-q", question: "Select:", options: [
                        TriageOption(id: "g2122", label: "Applying the Farrimond Friction Hitch from ABOK Hitches", icon: "list.bullet.clipboard.fill", destination: .technique("tools-encyclopedia-farrimond-friction-hitch-natural-fiber")),
                        TriageOption(id: "g2123", label: "Applying the Farrimond Friction Hitch from ABOK Hitches", icon: "list.bullet.clipboard.fill", destination: .technique("tools-encyclopedia-farrimond-friction-hitch-synthetic-rope")),
                        TriageOption(id: "g2124", label: "Applying the Farrimond Friction Hitch from ABOK Hitches", icon: "list.bullet.clipboard.fill", destination: .technique("tools-encyclopedia-farrimond-friction-hitch-webbing")),
                        TriageOption(id: "g2125", label: "Applying the Prusik Knot from ABOK Hitches using Natura", icon: "list.bullet.clipboard.fill", destination: .technique("tools-encyclopedia-prusik-knot-natural-fiber")),
                        TriageOption(id: "g2126", label: "Applying the Prusik Knot from ABOK Hitches using Paraco", icon: "list.bullet.clipboard.fill", destination: .technique("tools-encyclopedia-prusik-knot-paracord"))
                    ])
                )),
                TriageOption(id: "g2127", label: "Abok (23)", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g2127-q", question: "Select:", options: [
                        TriageOption(id: "g2128", label: "Applying the Klemheist Knot from ABOK Hitches using Nat", icon: "list.bullet.clipboard.fill", destination: .technique("tools-encyclopedia-klemheist-knot-natural-fiber")),
                        TriageOption(id: "g2129", label: "Applying the Klemheist Knot from ABOK Hitches using Par", icon: "list.bullet.clipboard.fill", destination: .technique("tools-encyclopedia-klemheist-knot-paracord")),
                        TriageOption(id: "g2130", label: "Applying the Klemheist Knot from ABOK Hitches using Syn", icon: "list.bullet.clipboard.fill", destination: .technique("tools-encyclopedia-klemheist-knot-synthetic-rope")),
                        TriageOption(id: "g2131", label: "Applying the Prusik Knot from ABOK Hitches using Synthe", icon: "list.bullet.clipboard.fill", destination: .technique("tools-encyclopedia-prusik-knot-synthetic-rope")),
                        TriageOption(id: "g2132", label: "Applying the Prusik Knot from ABOK Hitches using Webbin", icon: "list.bullet.clipboard.fill", destination: .technique("tools-encyclopedia-prusik-knot-webbing"))
                    ])
                )),
                TriageOption(id: "g2133", label: "Abok (24)", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g2133-q", question: "Select:", options: [
                        TriageOption(id: "g2134", label: "Applying the Bachmann Hitch from ABOK Hitches using Nat", icon: "list.bullet.clipboard.fill", destination: .technique("tools-encyclopedia-bachmann-hitch-natural-fiber")),
                        TriageOption(id: "g2135", label: "Applying the Bachmann Hitch from ABOK Hitches using Par", icon: "list.bullet.clipboard.fill", destination: .technique("tools-encyclopedia-bachmann-hitch-paracord")),
                        TriageOption(id: "g2136", label: "Applying the Bachmann Hitch from ABOK Hitches using Syn", icon: "list.bullet.clipboard.fill", destination: .technique("tools-encyclopedia-bachmann-hitch-synthetic-rope")),
                        TriageOption(id: "g2137", label: "Applying the Bachmann Hitch from ABOK Hitches using Web", icon: "list.bullet.clipboard.fill", destination: .technique("tools-encyclopedia-bachmann-hitch-webbing")),
                        TriageOption(id: "g2138", label: "Applying the Klemheist Knot from ABOK Hitches using Web", icon: "list.bullet.clipboard.fill", destination: .technique("tools-encyclopedia-klemheist-knot-webbing"))
                    ])
                )),
                TriageOption(id: "g2139", label: "Abok (25)", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g2139-q", question: "Select:", options: [
                        TriageOption(id: "g2140", label: "Applying the Flemish Bend from ABOK Bends using Natural", icon: "list.bullet.clipboard.fill", destination: .technique("tools-encyclopedia-flemish-bend-natural-fiber")),
                        TriageOption(id: "g2141", label: "Applying the Flemish Bend from ABOK Bends using Paracor", icon: "list.bullet.clipboard.fill", destination: .technique("tools-encyclopedia-flemish-bend-paracord")),
                        TriageOption(id: "g2142", label: "Applying the Flemish Bend from ABOK Bends using Synthet", icon: "list.bullet.clipboard.fill", destination: .technique("tools-encyclopedia-flemish-bend-synthetic-rope")),
                        TriageOption(id: "g2143", label: "Applying the Flemish Bend from ABOK Bends using Webbing", icon: "list.bullet.clipboard.fill", destination: .technique("tools-encyclopedia-flemish-bend-webbing")),
                        TriageOption(id: "g2144", label: "Applying the Water Knot from ABOK Bends using Paracord.", icon: "list.bullet.clipboard.fill", destination: .technique("tools-encyclopedia-water-knot-paracord"))
                    ])
                )),
                TriageOption(id: "g2145", label: "Abok (26)", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g2145-q", question: "Select:", options: [
                        TriageOption(id: "g2146", label: "Applying the Harness Bend from ABOK Bends using Natural", icon: "list.bullet.clipboard.fill", destination: .technique("tools-encyclopedia-harness-bend-natural-fiber")),
                        TriageOption(id: "g2147", label: "Applying the Harness Bend from ABOK Bends using Paracor", icon: "list.bullet.clipboard.fill", destination: .technique("tools-encyclopedia-harness-bend-paracord")),
                        TriageOption(id: "g2148", label: "Applying the Water Knot from ABOK Bends using Natural F", icon: "list.bullet.clipboard.fill", destination: .technique("tools-encyclopedia-water-knot-natural-fiber")),
                        TriageOption(id: "g2149", label: "Applying the Water Knot from ABOK Bends using Synthetic", icon: "list.bullet.clipboard.fill", destination: .technique("tools-encyclopedia-water-knot-synthetic-rope")),
                        TriageOption(id: "g2150", label: "Applying the Water Knot from ABOK Bends using Webbing.", icon: "list.bullet.clipboard.fill", destination: .technique("tools-encyclopedia-water-knot-webbing"))
                    ])
                )),
                TriageOption(id: "g2151", label: "Abok (27)", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g2151-q", question: "Select:", options: [
                        TriageOption(id: "g2152", label: "Applying the Ashley's Bend from ABOK Bends using Natura", icon: "list.bullet.clipboard.fill", destination: .technique("tools-encyclopedia-ashleys-bend-natural-fiber")),
                        TriageOption(id: "g2153", label: "Applying the Ashley's Bend from ABOK Bends using Paraco", icon: "list.bullet.clipboard.fill", destination: .technique("tools-encyclopedia-ashleys-bend-paracord")),
                        TriageOption(id: "g2154", label: "Applying the Ashley's Bend from ABOK Bends using Synthe", icon: "list.bullet.clipboard.fill", destination: .technique("tools-encyclopedia-ashleys-bend-synthetic-rope")),
                        TriageOption(id: "g2155", label: "Applying the Harness Bend from ABOK Bends using Synthet", icon: "list.bullet.clipboard.fill", destination: .technique("tools-encyclopedia-harness-bend-synthetic-rope")),
                        TriageOption(id: "g2156", label: "Applying the Harness Bend from ABOK Bends using Webbing", icon: "list.bullet.clipboard.fill", destination: .technique("tools-encyclopedia-harness-bend-webbing"))
                    ])
                )),
                TriageOption(id: "g2157", label: "Abok (28)", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g2157-q", question: "Select:", options: [
                        TriageOption(id: "g2158", label: "Applying the Ashley's Bend from ABOK Bends using Webbin", icon: "list.bullet.clipboard.fill", destination: .technique("tools-encyclopedia-ashleys-bend-webbing")),
                        TriageOption(id: "g2159", label: "Applying the Hunter's Bend from ABOK Bends using Natura", icon: "list.bullet.clipboard.fill", destination: .technique("tools-encyclopedia-hunters-bend-natural-fiber")),
                        TriageOption(id: "g2160", label: "Applying the Hunter's Bend from ABOK Bends using Paraco", icon: "list.bullet.clipboard.fill", destination: .technique("tools-encyclopedia-hunters-bend-paracord")),
                        TriageOption(id: "g2161", label: "Applying the Hunter's Bend from ABOK Bends using Synthe", icon: "list.bullet.clipboard.fill", destination: .technique("tools-encyclopedia-hunters-bend-synthetic-rope")),
                        TriageOption(id: "g2162", label: "Applying the Hunter's Bend from ABOK Bends using Webbin", icon: "list.bullet.clipboard.fill", destination: .technique("tools-encyclopedia-hunters-bend-webbing"))
                    ])
                )),
                TriageOption(id: "g2163", label: "Abok (29)", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g2163-q", question: "Select:", options: [
                        TriageOption(id: "g2164", label: "Applying the Blood Knot from ABOK Bends using Natural F", icon: "list.bullet.clipboard.fill", destination: .technique("tools-encyclopedia-blood-knot-natural-fiber")),
                        TriageOption(id: "g2165", label: "Applying the Blood Knot from ABOK Bends using Paracord.", icon: "list.bullet.clipboard.fill", destination: .technique("tools-encyclopedia-blood-knot-paracord")),
                        TriageOption(id: "g2166", label: "Applying the Blood Knot from ABOK Bends using Synthetic", icon: "list.bullet.clipboard.fill", destination: .technique("tools-encyclopedia-blood-knot-synthetic-rope")),
                        TriageOption(id: "g2167", label: "Applying the Blood Knot from ABOK Bends using Webbing.", icon: "list.bullet.clipboard.fill", destination: .technique("tools-encyclopedia-blood-knot-webbing")),
                        TriageOption(id: "g2168", label: "Applying the Nail Knot from ABOK Bends using Paracord.", icon: "list.bullet.clipboard.fill", destination: .technique("tools-encyclopedia-nail-knot-paracord"))
                    ])
                )),
                TriageOption(id: "g2169", label: "Abok (30)", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g2169-q", question: "Select:", options: [
                        TriageOption(id: "g2170", label: "Applying the Albright Knot from ABOK Bends using Natura", icon: "list.bullet.clipboard.fill", destination: .technique("tools-encyclopedia-albright-knot-natural-fiber")),
                        TriageOption(id: "g2171", label: "Applying the Albright Knot from ABOK Bends using Paraco", icon: "list.bullet.clipboard.fill", destination: .technique("tools-encyclopedia-albright-knot-paracord")),
                        TriageOption(id: "g2172", label: "Applying the Nail Knot from ABOK Bends using Natural Fi", icon: "list.bullet.clipboard.fill", destination: .technique("tools-encyclopedia-nail-knot-natural-fiber")),
                        TriageOption(id: "g2173", label: "Applying the Nail Knot from ABOK Bends using Synthetic ", icon: "list.bullet.clipboard.fill", destination: .technique("tools-encyclopedia-nail-knot-synthetic-rope")),
                        TriageOption(id: "g2174", label: "Applying the Nail Knot from ABOK Bends using Webbing.", icon: "list.bullet.clipboard.fill", destination: .technique("tools-encyclopedia-nail-knot-webbing"))
                    ])
                )),
                TriageOption(id: "g2175", label: "Abok (31)", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g2175-q", question: "Select:", options: [
                        TriageOption(id: "g2176", label: "Applying the Albright Knot from ABOK Bends using Synthe", icon: "list.bullet.clipboard.fill", destination: .technique("tools-encyclopedia-albright-knot-synthetic-rope")),
                        TriageOption(id: "g2177", label: "Applying the Albright Knot from ABOK Bends using Webbin", icon: "list.bullet.clipboard.fill", destination: .technique("tools-encyclopedia-albright-knot-webbing")),
                        TriageOption(id: "g2178", label: "Applying the Short Splice from ABOK Splices using Natur", icon: "list.bullet.clipboard.fill", destination: .technique("tools-encyclopedia-short-splice-natural-fiber")),
                        TriageOption(id: "g2179", label: "Applying the Short Splice from ABOK Splices using Parac", icon: "list.bullet.clipboard.fill", destination: .technique("tools-encyclopedia-short-splice-paracord")),
                        TriageOption(id: "g2180", label: "Applying the Short Splice from ABOK Splices using Synth", icon: "list.bullet.clipboard.fill", destination: .technique("tools-encyclopedia-short-splice-synthetic-rope"))
                    ])
                )),
                TriageOption(id: "g2181", label: "Abok (32)", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g2181-q", question: "Select:", options: [
                        TriageOption(id: "g2182", label: "Applying the Eye Splice from ABOK Splices using Natural", icon: "eye.fill", destination: .technique("tools-encyclopedia-eye-splice-natural-fiber")),
                        TriageOption(id: "g2183", label: "Applying the Eye Splice from ABOK Splices using Paracor", icon: "eye.fill", destination: .technique("tools-encyclopedia-eye-splice-paracord")),
                        TriageOption(id: "g2184", label: "Applying the Eye Splice from ABOK Splices using Synthet", icon: "eye.fill", destination: .technique("tools-encyclopedia-eye-splice-synthetic-rope")),
                        TriageOption(id: "g2185", label: "Applying the Eye Splice from ABOK Splices using Webbing", icon: "eye.fill", destination: .technique("tools-encyclopedia-eye-splice-webbing")),
                        TriageOption(id: "g2186", label: "Applying the Short Splice from ABOK Splices using Webbi", icon: "list.bullet.clipboard.fill", destination: .technique("tools-encyclopedia-short-splice-webbing"))
                    ])
                )),
                TriageOption(id: "g2187", label: "Abok (33)", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g2187-q", question: "Select:", options: [
                        TriageOption(id: "g2188", label: "Applying the Cut Splice from ABOK Splices using Paracor", icon: "list.bullet.clipboard.fill", destination: .technique("tools-encyclopedia-cut-splice-paracord")),
                        TriageOption(id: "g2189", label: "Applying the Long Splice from ABOK Splices using Natura", icon: "list.bullet.clipboard.fill", destination: .technique("tools-encyclopedia-long-splice-natural-fiber")),
                        TriageOption(id: "g2190", label: "Applying the Long Splice from ABOK Splices using Paraco", icon: "list.bullet.clipboard.fill", destination: .technique("tools-encyclopedia-long-splice-paracord")),
                        TriageOption(id: "g2191", label: "Applying the Long Splice from ABOK Splices using Synthe", icon: "list.bullet.clipboard.fill", destination: .technique("tools-encyclopedia-long-splice-synthetic-rope")),
                        TriageOption(id: "g2192", label: "Applying the Long Splice from ABOK Splices using Webbin", icon: "list.bullet.clipboard.fill", destination: .technique("tools-encyclopedia-long-splice-webbing"))
                    ])
                )),
                TriageOption(id: "g2193", label: "Abok (34)", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g2193-q", question: "Select:", options: [
                        TriageOption(id: "g2194", label: "Applying the Chain Splice from ABOK Splices using Natur", icon: "list.bullet.clipboard.fill", destination: .technique("tools-encyclopedia-chain-splice-natural-fiber")),
                        TriageOption(id: "g2195", label: "Applying the Chain Splice from ABOK Splices using Parac", icon: "list.bullet.clipboard.fill", destination: .technique("tools-encyclopedia-chain-splice-paracord")),
                        TriageOption(id: "g2196", label: "Applying the Cut Splice from ABOK Splices using Natural", icon: "list.bullet.clipboard.fill", destination: .technique("tools-encyclopedia-cut-splice-natural-fiber")),
                        TriageOption(id: "g2197", label: "Applying the Cut Splice from ABOK Splices using Synthet", icon: "list.bullet.clipboard.fill", destination: .technique("tools-encyclopedia-cut-splice-synthetic-rope")),
                        TriageOption(id: "g2198", label: "Applying the Cut Splice from ABOK Splices using Webbing", icon: "list.bullet.clipboard.fill", destination: .technique("tools-encyclopedia-cut-splice-webbing"))
                    ])
                )),
                TriageOption(id: "g2199", label: "Abok (35)", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g2199-q", question: "Select:", options: [
                        TriageOption(id: "g2200", label: "Applying the Back Splice from ABOK Splices using Natura", icon: "list.bullet.clipboard.fill", destination: .technique("tools-encyclopedia-back-splice-natural-fiber")),
                        TriageOption(id: "g2201", label: "Applying the Back Splice from ABOK Splices using Paraco", icon: "list.bullet.clipboard.fill", destination: .technique("tools-encyclopedia-back-splice-paracord")),
                        TriageOption(id: "g2202", label: "Applying the Back Splice from ABOK Splices using Synthe", icon: "list.bullet.clipboard.fill", destination: .technique("tools-encyclopedia-back-splice-synthetic-rope")),
                        TriageOption(id: "g2203", label: "Applying the Chain Splice from ABOK Splices using Synth", icon: "list.bullet.clipboard.fill", destination: .technique("tools-encyclopedia-chain-splice-synthetic-rope")),
                        TriageOption(id: "g2204", label: "Applying the Chain Splice from ABOK Splices using Webbi", icon: "list.bullet.clipboard.fill", destination: .technique("tools-encyclopedia-chain-splice-webbing"))
                    ])
                )),
                TriageOption(id: "g2205", label: "Webbing", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g2205-q", question: "Select:", options: [
                        TriageOption(id: "g2206", label: "Applying the Back Splice from ABOK Splices using Webbin", icon: "list.bullet.clipboard.fill", destination: .technique("tools-encyclopedia-back-splice-webbing")),
                        TriageOption(id: "g2207", label: "An ascending friction hitch requiring only webbing or a", icon: "bandage.fill", destination: .technique("tools-knot-klemheist")),
                        TriageOption(id: "g2208", label: "Reversibly locking a loaded belay under extreme tension", icon: "link", destination: .technique("tools-knot-munter-mule"))
                    ])
                ))
                ])
            )),

            TriageOption(id: "g2209", label: "Making Tools", icon: "cross.case.fill", destination: .nextQuestion(
                TriageNode(id: "g2209-q", question: "What specifically?", options: [
                TriageOption(id: "g2210", label: "Large", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g2210-q", question: "Select:", options: [
                        TriageOption(id: "g2211", label: "Folding a waterproof container from birch bark", icon: "fish.fill", destination: .technique("tools-birch-bark-basket")),
                        TriageOption(id: "g2212", label: "Create a piercing tool from animal bone", icon: "bandage.fill", destination: .technique("tools-bone-awl")),
                        TriageOption(id: "g2213", label: "Creating a piercing tool for leatherwork and basketry.", icon: "bandage.fill", destination: .technique("tools-tool-bone-awl")),
                        TriageOption(id: "g2214", label: "Use mussel or clam shells as cutting and scraping tools", icon: "cross.case.fill", destination: .technique("tools-shell-scraper")),
                        TriageOption(id: "g2215", label: "Rain-proof storage from peeled bark", icon: "cloud.rain.fill", destination: .technique("tools-waterproof-container"))
                    ])
                )),
                TriageOption(id: "g2216", label: "Bark", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g2216-q", question: "Select:", options: [
                        TriageOption(id: "g2217", label: "Weave containers and mats from natural materials", icon: "leaf.fill", destination: .technique("tools-weaving-basics")),
                        TriageOption(id: "g2218", label: "Create usable rope from natural plant fibers", icon: "leaf.fill", destination: .technique("tools-emergency-rope")),
                        TriageOption(id: "g2219", label: "Making waterproof adhesive from tree resin", icon: "drop.fill", destination: .technique("tools-pitch-glue"))
                    ])
                )),
                TriageOption(id: "g2220", label: "Harvest", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g2220-q", question: "Select:", options: [
                        TriageOption(id: "g2221", label: "Prepare a natural water container from a gourd", icon: "cylinder.fill", destination: .technique("tools-gourd-canteen")),
                        TriageOption(id: "g2222", label: "The aboriginal epoxy for hafting tools/weapons.", icon: "drop.fill", destination: .technique("tools-tool-pine-pitch-glue")),
                        TriageOption(id: "g2223", label: "Spinning plant fibers into immensely strong bi-directio", icon: "bandage.fill", destination: .technique("tools-craft-cordage-reverse-wrap"))
                    ])
                )),
                TriageOption(id: "g2224", label: "Knife", icon: "scissors", destination: .nextQuestion(
                    TriageNode(id: "g2224-q", question: "Select:", options: [
                        TriageOption(id: "g2225", label: "Constructing a reliable knife functioning as a bone too", icon: "bandage.fill", destination: .technique("tools-encyclopedia-bone-tool-knife")),
                        TriageOption(id: "g2226", label: "Constructing a reliable knife functioning as a natural ", icon: "scissors", destination: .technique("tools-encyclopedia-natural-adhesives-knife")),
                        TriageOption(id: "g2227", label: "Constructing a reliable knife functioning as a natural ", icon: "scissors", destination: .technique("tools-encyclopedia-natural-bindings-knife")),
                        TriageOption(id: "g2228", label: "Constructing a reliable knife functioning as a stone to", icon: "scissors", destination: .technique("tools-encyclopedia-stone-tool-knife")),
                        TriageOption(id: "g2229", label: "Constructing a reliable knife functioning as a wooden t", icon: "target", destination: .technique("tools-encyclopedia-wooden-trap-knife"))
                    ])
                )),
                TriageOption(id: "g2230", label: "Point", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g2230-q", question: "Select:", options: [
                        TriageOption(id: "g2231", label: "Constructing a reliable spear point functioning as a bo", icon: "bandage.fill", destination: .technique("tools-encyclopedia-bone-tool-spear-point")),
                        TriageOption(id: "g2232", label: "Constructing a reliable spear point functioning as a na", icon: "drop.fill", destination: .technique("tools-encyclopedia-natural-adhesives-spear-point")),
                        TriageOption(id: "g2233", label: "Constructing a reliable spear point functioning as a na", icon: "cross.case.fill", destination: .technique("tools-encyclopedia-natural-bindings-spear-point")),
                        TriageOption(id: "g2234", label: "Constructing a reliable spear point functioning as a st", icon: "cross.case.fill", destination: .technique("tools-encyclopedia-stone-tool-spear-point")),
                        TriageOption(id: "g2235", label: "Constructing a reliable spear point functioning as a wo", icon: "target", destination: .technique("tools-encyclopedia-wooden-trap-spear-point"))
                    ])
                )),
                TriageOption(id: "g2236", label: "Bone", icon: "bandage.fill", destination: .nextQuestion(
                    TriageNode(id: "g2236-q", question: "Select:", options: [
                        TriageOption(id: "g2237", label: "Use shed antlers for pressure flaking and crafting", icon: "drop.fill", destination: .technique("tools-antler-tool")),
                        TriageOption(id: "g2238", label: "Make a sewing needle from animal bone for gear repair", icon: "bandage.fill", destination: .technique("tools-bone-needle-craft")),
                        TriageOption(id: "g2239", label: "Create bowls, cups, and implements from coconut shells", icon: "cross.case.fill", destination: .technique("tools-coconut-shell-bowl")),
                        TriageOption(id: "g2240", label: "Create a durable digging tool from hardwood", icon: "flame.fill", destination: .technique("tools-fire-hardened-digging-stick")),
                        TriageOption(id: "g2241", label: "Build a tool to process caught fish quickly", icon: "fish.fill", destination: .technique("tools-fish-scaler-tool"))
                    ])
                )),
                TriageOption(id: "g2242", label: "Fire", icon: "flame.fill", destination: .nextQuestion(
                    TriageNode(id: "g2242-q", question: "Select:", options: [
                        TriageOption(id: "g2243", label: "A smokeless, wind-proof underground fire pit", icon: "flame.fill", destination: .technique("tools-dakota-fire-hole")),
                        TriageOption(id: "g2244", label: "Baking moisture out of a wooden tool to increase durabi", icon: "flame.fill", destination: .technique("tools-fire-hardening")),
                        TriageOption(id: "g2245", label: "Create waterproof containers from clay — essential long", icon: "cylinder.fill", destination: .technique("tools-pottery-pit-firing")),
                        TriageOption(id: "g2246", label: "Weaving massive tensile strength rope from weeds", icon: "ant.fill", destination: .technique("tools-nettle-cordage")),
                        TriageOption(id: "g2247", label: "Creating usable cutting edges from stone", icon: "bolt.fill", destination: .technique("tools-stone-blade-knapping"))
                    ])
                )),
                TriageOption(id: "g2248", label: "Ropes", icon: "link", destination: .nextQuestion(
                    TriageNode(id: "g2248-q", question: "Select:", options: [
                        TriageOption(id: "g2249", label: "Carve a functional whistle from a stick in 10 minutes", icon: "car.fill", destination: .technique("tools-whistle-carving")),
                        TriageOption(id: "g2250", label: "Improvised light source from animal fat or plant wax", icon: "leaf.fill", destination: .technique("tools-candle-making-field")),
                        TriageOption(id: "g2251", label: "Cross a gap using three ropes — one to walk, two to hol", icon: "mountain.2.fill", destination: .technique("tools-rope-bridge")),
                        TriageOption(id: "g2252", label: "Reduce bites using field-available plant materials", icon: "ant.fill", destination: .technique("tools-natural-insect-repellent")),
                        TriageOption(id: "g2253", label: "Cook food using concentrated sunlight — no fuel needed", icon: "sun.max.fill", destination: .technique("tools-solar-reflector-oven"))
                    ])
                )),
                TriageOption(id: "g2254", label: "Abok", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g2254-q", question: "Select:", options: [
                        TriageOption(id: "g2255", label: "Applying the Square Lashing from ABOK Lashings using Na", icon: "list.bullet.clipboard.fill", destination: .technique("tools-encyclopedia-square-lashing-natural-fiber")),
                        TriageOption(id: "g2256", label: "Applying the Square Lashing from ABOK Lashings using Pa", icon: "list.bullet.clipboard.fill", destination: .technique("tools-encyclopedia-square-lashing-paracord")),
                        TriageOption(id: "g2257", label: "Applying the Square Lashing from ABOK Lashings using Sy", icon: "list.bullet.clipboard.fill", destination: .technique("tools-encyclopedia-square-lashing-synthetic-rope")),
                        TriageOption(id: "g2258", label: "Applying the Square Lashing from ABOK Lashings using We", icon: "list.bullet.clipboard.fill", destination: .technique("tools-encyclopedia-square-lashing-webbing")),
                        TriageOption(id: "g2259", label: "Permanent light source from animal fat and a wick", icon: "pawprint.fill", destination: .technique("tools-clay-lamp"))
                    ])
                )),
                TriageOption(id: "g2260", label: "Abok (2)", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g2260-q", question: "Select:", options: [
                        TriageOption(id: "g2261", label: "Applying the Diagonal Lashing from ABOK Lashings using ", icon: "list.bullet.clipboard.fill", destination: .technique("tools-encyclopedia-diagonal-lashing-natural-fiber")),
                        TriageOption(id: "g2262", label: "Applying the Diagonal Lashing from ABOK Lashings using ", icon: "list.bullet.clipboard.fill", destination: .technique("tools-encyclopedia-diagonal-lashing-paracord")),
                        TriageOption(id: "g2263", label: "Applying the Diagonal Lashing from ABOK Lashings using ", icon: "list.bullet.clipboard.fill", destination: .technique("tools-encyclopedia-diagonal-lashing-synthetic-rope")),
                        TriageOption(id: "g2264", label: "Applying the Diagonal Lashing from ABOK Lashings using ", icon: "list.bullet.clipboard.fill", destination: .technique("tools-encyclopedia-diagonal-lashing-webbing")),
                        TriageOption(id: "g2265", label: "Applying the Shear Lashing from ABOK Lashings using Par", icon: "list.bullet.clipboard.fill", destination: .technique("tools-encyclopedia-shear-lashing-paracord"))
                    ])
                )),
                TriageOption(id: "g2266", label: "Abok (3)", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g2266-q", question: "Select:", options: [
                        TriageOption(id: "g2267", label: "Applying the Shear Lashing from ABOK Lashings using Nat", icon: "list.bullet.clipboard.fill", destination: .technique("tools-encyclopedia-shear-lashing-natural-fiber")),
                        TriageOption(id: "g2268", label: "Applying the Shear Lashing from ABOK Lashings using Syn", icon: "list.bullet.clipboard.fill", destination: .technique("tools-encyclopedia-shear-lashing-synthetic-rope")),
                        TriageOption(id: "g2269", label: "Applying the Shear Lashing from ABOK Lashings using Web", icon: "list.bullet.clipboard.fill", destination: .technique("tools-encyclopedia-shear-lashing-webbing")),
                        TriageOption(id: "g2270", label: "Applying the Tripod Lashing from ABOK Lashings using Na", icon: "list.bullet.clipboard.fill", destination: .technique("tools-encyclopedia-tripod-lashing-natural-fiber")),
                        TriageOption(id: "g2271", label: "Applying the Tripod Lashing from ABOK Lashings using Pa", icon: "list.bullet.clipboard.fill", destination: .technique("tools-encyclopedia-tripod-lashing-paracord"))
                    ])
                )),
                TriageOption(id: "g2272", label: "Abok (4)", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g2272-q", question: "Select:", options: [
                        TriageOption(id: "g2273", label: "Applying the Round Lashing from ABOK Lashings using Nat", icon: "list.bullet.clipboard.fill", destination: .technique("tools-encyclopedia-round-lashing-natural-fiber")),
                        TriageOption(id: "g2274", label: "Applying the Round Lashing from ABOK Lashings using Par", icon: "list.bullet.clipboard.fill", destination: .technique("tools-encyclopedia-round-lashing-paracord")),
                        TriageOption(id: "g2275", label: "Applying the Round Lashing from ABOK Lashings using Syn", icon: "list.bullet.clipboard.fill", destination: .technique("tools-encyclopedia-round-lashing-synthetic-rope")),
                        TriageOption(id: "g2276", label: "Applying the Tripod Lashing from ABOK Lashings using Sy", icon: "list.bullet.clipboard.fill", destination: .technique("tools-encyclopedia-tripod-lashing-synthetic-rope")),
                        TriageOption(id: "g2277", label: "Applying the Tripod Lashing from ABOK Lashings using We", icon: "list.bullet.clipboard.fill", destination: .technique("tools-encyclopedia-tripod-lashing-webbing"))
                    ])
                )),
                TriageOption(id: "g2278", label: "Abok (5)", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g2278-q", question: "Select:", options: [
                        TriageOption(id: "g2279", label: "Applying the Japanese Mark II Lashing from ABOK Lashing", icon: "list.bullet.clipboard.fill", destination: .technique("tools-encyclopedia-japanese-mark-ii-lashing-natural-fiber")),
                        TriageOption(id: "g2280", label: "Applying the Japanese Mark II Lashing from ABOK Lashing", icon: "list.bullet.clipboard.fill", destination: .technique("tools-encyclopedia-japanese-mark-ii-lashing-paracord")),
                        TriageOption(id: "g2281", label: "Applying the Japanese Mark II Lashing from ABOK Lashing", icon: "list.bullet.clipboard.fill", destination: .technique("tools-encyclopedia-japanese-mark-ii-lashing-synthetic-rope")),
                        TriageOption(id: "g2282", label: "Applying the Japanese Mark II Lashing from ABOK Lashing", icon: "list.bullet.clipboard.fill", destination: .technique("tools-encyclopedia-japanese-mark-ii-lashing-webbing")),
                        TriageOption(id: "g2283", label: "Applying the Round Lashing from ABOK Lashings using Web", icon: "list.bullet.clipboard.fill", destination: .technique("tools-encyclopedia-round-lashing-webbing"))
                    ])
                )),
                TriageOption(id: "g2284", label: "Stone", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g2284-q", question: "Select:", options: [
                        TriageOption(id: "g2285", label: "Building permanent ceramic vessels without a potter's w", icon: "building.2.fill", destination: .technique("tools-craft-coil-pottery")),
                        TriageOption(id: "g2286", label: "Hardening raw clay into permanent ceramics in open fire", icon: "bandage.fill", destination: .technique("tools-craft-pit-firing")),
                        TriageOption(id: "g2287", label: "Constructing a reliable awl functioning as a stone tool", icon: "cross.case.fill", destination: .technique("tools-encyclopedia-stone-tool-awl")),
                        TriageOption(id: "g2288", label: "Constructing a reliable gouge functioning as a stone to", icon: "cross.case.fill", destination: .technique("tools-encyclopedia-stone-tool-gouge")),
                        TriageOption(id: "g2289", label: "Processing raw earth into usable, pure ceramic clay.", icon: "cross.case.fill", destination: .technique("tools-craft-clay-processing"))
                    ])
                )),
                TriageOption(id: "g2290", label: "Stone (2)", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g2290-q", question: "Select:", options: [
                        TriageOption(id: "g2291", label: "Constructing a reliable hook functioning as a stone too", icon: "fish.fill", destination: .technique("tools-encyclopedia-stone-tool-hook")),
                        TriageOption(id: "g2292", label: "Constructing a reliable mallet functioning as a stone t", icon: "cross.case.fill", destination: .technique("tools-encyclopedia-stone-tool-mallet")),
                        TriageOption(id: "g2293", label: "Constructing a reliable needle functioning as a stone t", icon: "scissors", destination: .technique("tools-encyclopedia-stone-tool-needle")),
                        TriageOption(id: "g2294", label: "Constructing a reliable scraper functioning as a stone ", icon: "cross.case.fill", destination: .technique("tools-encyclopedia-stone-tool-scraper")),
                        TriageOption(id: "g2295", label: "Constructing a reliable wedge functioning as a stone to", icon: "cross.case.fill", destination: .technique("tools-encyclopedia-stone-tool-wedge"))
                    ])
                )),
                TriageOption(id: "g2296", label: "Tool", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g2296-q", question: "Select:", options: [
                        TriageOption(id: "g2297", label: "Constructing a reliable awl functioning as a bone tool.", icon: "bandage.fill", destination: .technique("tools-encyclopedia-bone-tool-awl")),
                        TriageOption(id: "g2298", label: "Constructing a reliable gouge functioning as a bone too", icon: "bandage.fill", destination: .technique("tools-encyclopedia-bone-tool-gouge")),
                        TriageOption(id: "g2299", label: "Constructing a reliable adze functioning as a stone too", icon: "cross.case.fill", destination: .technique("tools-encyclopedia-stone-tool-adze")),
                        TriageOption(id: "g2300", label: "Constructing a reliable axe functioning as a stone tool", icon: "scissors", destination: .technique("tools-encyclopedia-stone-tool-axe")),
                        TriageOption(id: "g2301", label: "Constructing a reliable digging stick functioning as a ", icon: "cross.case.fill", destination: .technique("tools-encyclopedia-stone-tool-digging-stick"))
                    ])
                )),
                TriageOption(id: "g2302", label: "Bone (2)", icon: "bandage.fill", destination: .nextQuestion(
                    TriageNode(id: "g2302-q", question: "Select:", options: [
                        TriageOption(id: "g2303", label: "Constructing a reliable hook functioning as a bone tool", icon: "bandage.fill", destination: .technique("tools-encyclopedia-bone-tool-hook")),
                        TriageOption(id: "g2304", label: "Constructing a reliable mallet functioning as a bone to", icon: "bandage.fill", destination: .technique("tools-encyclopedia-bone-tool-mallet")),
                        TriageOption(id: "g2305", label: "Constructing a reliable needle functioning as a bone to", icon: "bandage.fill", destination: .technique("tools-encyclopedia-bone-tool-needle")),
                        TriageOption(id: "g2306", label: "Constructing a reliable scraper functioning as a bone t", icon: "bandage.fill", destination: .technique("tools-encyclopedia-bone-tool-scraper")),
                        TriageOption(id: "g2307", label: "Constructing a reliable wedge functioning as a bone too", icon: "bandage.fill", destination: .technique("tools-encyclopedia-bone-tool-wedge"))
                    ])
                )),
                TriageOption(id: "g2308", label: "Bone (3)", icon: "bandage.fill", destination: .nextQuestion(
                    TriageNode(id: "g2308-q", question: "Select:", options: [
                        TriageOption(id: "g2309", label: "Constructing a reliable adze functioning as a bone tool", icon: "bandage.fill", destination: .technique("tools-encyclopedia-bone-tool-adze")),
                        TriageOption(id: "g2310", label: "Constructing a reliable axe functioning as a bone tool.", icon: "bandage.fill", destination: .technique("tools-encyclopedia-bone-tool-axe")),
                        TriageOption(id: "g2311", label: "Constructing a reliable digging stick functioning as a ", icon: "bandage.fill", destination: .technique("tools-encyclopedia-bone-tool-digging-stick")),
                        TriageOption(id: "g2312", label: "Constructing a reliable awl functioning as a wooden tra", icon: "target", destination: .technique("tools-encyclopedia-wooden-trap-awl")),
                        TriageOption(id: "g2313", label: "Constructing a reliable gouge functioning as a wooden t", icon: "target", destination: .technique("tools-encyclopedia-wooden-trap-gouge"))
                    ])
                )),
                TriageOption(id: "g2314", label: "Wooden", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g2314-q", question: "Select:", options: [
                        TriageOption(id: "g2315", label: "Constructing a reliable hook functioning as a wooden tr", icon: "target", destination: .technique("tools-encyclopedia-wooden-trap-hook")),
                        TriageOption(id: "g2316", label: "Constructing a reliable mallet functioning as a wooden ", icon: "target", destination: .technique("tools-encyclopedia-wooden-trap-mallet")),
                        TriageOption(id: "g2317", label: "Constructing a reliable needle functioning as a wooden ", icon: "scissors", destination: .technique("tools-encyclopedia-wooden-trap-needle")),
                        TriageOption(id: "g2318", label: "Constructing a reliable scraper functioning as a wooden", icon: "target", destination: .technique("tools-encyclopedia-wooden-trap-scraper")),
                        TriageOption(id: "g2319", label: "Constructing a reliable wedge functioning as a wooden t", icon: "target", destination: .technique("tools-encyclopedia-wooden-trap-wedge"))
                    ])
                )),
                TriageOption(id: "g2320", label: "Wooden (2)", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g2320-q", question: "Select:", options: [
                        TriageOption(id: "g2321", label: "Constructing a reliable awl functioning as a natural ad", icon: "drop.fill", destination: .technique("tools-encyclopedia-natural-adhesives-awl")),
                        TriageOption(id: "g2322", label: "Constructing a reliable gouge functioning as a natural ", icon: "drop.fill", destination: .technique("tools-encyclopedia-natural-adhesives-gouge")),
                        TriageOption(id: "g2323", label: "Constructing a reliable adze functioning as a wooden tr", icon: "target", destination: .technique("tools-encyclopedia-wooden-trap-adze")),
                        TriageOption(id: "g2324", label: "Constructing a reliable axe functioning as a wooden tra", icon: "target", destination: .technique("tools-encyclopedia-wooden-trap-axe")),
                        TriageOption(id: "g2325", label: "Constructing a reliable digging stick functioning as a ", icon: "target", destination: .technique("tools-encyclopedia-wooden-trap-digging-stick"))
                    ])
                )),
                TriageOption(id: "g2326", label: "Natural", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g2326-q", question: "Select:", options: [
                        TriageOption(id: "g2327", label: "Constructing a reliable hook functioning as a natural a", icon: "fish.fill", destination: .technique("tools-encyclopedia-natural-adhesives-hook")),
                        TriageOption(id: "g2328", label: "Constructing a reliable mallet functioning as a natural", icon: "drop.fill", destination: .technique("tools-encyclopedia-natural-adhesives-mallet")),
                        TriageOption(id: "g2329", label: "Constructing a reliable needle functioning as a natural", icon: "scissors", destination: .technique("tools-encyclopedia-natural-adhesives-needle")),
                        TriageOption(id: "g2330", label: "Constructing a reliable scraper functioning as a natura", icon: "drop.fill", destination: .technique("tools-encyclopedia-natural-adhesives-scraper")),
                        TriageOption(id: "g2331", label: "Constructing a reliable wedge functioning as a natural ", icon: "drop.fill", destination: .technique("tools-encyclopedia-natural-adhesives-wedge"))
                    ])
                )),
                TriageOption(id: "g2332", label: "Natural (2)", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g2332-q", question: "Select:", options: [
                        TriageOption(id: "g2333", label: "Constructing a reliable adze functioning as a natural a", icon: "drop.fill", destination: .technique("tools-encyclopedia-natural-adhesives-adze")),
                        TriageOption(id: "g2334", label: "Constructing a reliable axe functioning as a natural ad", icon: "scissors", destination: .technique("tools-encyclopedia-natural-adhesives-axe")),
                        TriageOption(id: "g2335", label: "Constructing a reliable digging stick functioning as a ", icon: "drop.fill", destination: .technique("tools-encyclopedia-natural-adhesives-digging-stick")),
                        TriageOption(id: "g2336", label: "Constructing a reliable awl functioning as a natural bi", icon: "cross.case.fill", destination: .technique("tools-encyclopedia-natural-bindings-awl")),
                        TriageOption(id: "g2337", label: "Constructing a reliable gouge functioning as a natural ", icon: "cross.case.fill", destination: .technique("tools-encyclopedia-natural-bindings-gouge"))
                    ])
                )),
                TriageOption(id: "g2338", label: "Natural (3)", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g2338-q", question: "Select:", options: [
                        TriageOption(id: "g2339", label: "Constructing a reliable hook functioning as a natural b", icon: "fish.fill", destination: .technique("tools-encyclopedia-natural-bindings-hook")),
                        TriageOption(id: "g2340", label: "Constructing a reliable mallet functioning as a natural", icon: "cross.case.fill", destination: .technique("tools-encyclopedia-natural-bindings-mallet")),
                        TriageOption(id: "g2341", label: "Constructing a reliable needle functioning as a natural", icon: "scissors", destination: .technique("tools-encyclopedia-natural-bindings-needle")),
                        TriageOption(id: "g2342", label: "Constructing a reliable scraper functioning as a natura", icon: "cross.case.fill", destination: .technique("tools-encyclopedia-natural-bindings-scraper")),
                        TriageOption(id: "g2343", label: "Constructing a reliable wedge functioning as a natural ", icon: "cross.case.fill", destination: .technique("tools-encyclopedia-natural-bindings-wedge"))
                    ])
                )),
                TriageOption(id: "g2344", label: "Natural (4)", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g2344-q", question: "Select:", options: [
                        TriageOption(id: "g2345", label: "Fabricating a rigorous, functional cutting flake exclus", icon: "bolt.fill", destination: .technique("tools-encyclopedia-fab-flint-chert-cutting-flake")),
                        TriageOption(id: "g2346", label: "Fabricating a rigorous, functional scraper exclusively ", icon: "bolt.fill", destination: .technique("tools-encyclopedia-fab-flint-chert-scraper")),
                        TriageOption(id: "g2347", label: "Constructing a reliable adze functioning as a natural b", icon: "cross.case.fill", destination: .technique("tools-encyclopedia-natural-bindings-adze")),
                        TriageOption(id: "g2348", label: "Constructing a reliable axe functioning as a natural bi", icon: "scissors", destination: .technique("tools-encyclopedia-natural-bindings-axe")),
                        TriageOption(id: "g2349", label: "Constructing a reliable digging stick functioning as a ", icon: "cross.case.fill", destination: .technique("tools-encyclopedia-natural-bindings-digging-stick"))
                    ])
                )),
                TriageOption(id: "g2350", label: "Flint", icon: "bolt.fill", destination: .nextQuestion(
                    TriageNode(id: "g2350-q", question: "Select:", options: [
                        TriageOption(id: "g2351", label: "Fabricating a rigorous, functional chopper exclusively ", icon: "bolt.fill", destination: .technique("tools-encyclopedia-fab-flint-chert-chopper")),
                        TriageOption(id: "g2352", label: "Fabricating a rigorous, functional digging implement ex", icon: "bolt.fill", destination: .technique("tools-encyclopedia-fab-flint-chert-digging-implement")),
                        TriageOption(id: "g2353", label: "Fabricating a rigorous, functional harpoon exclusively ", icon: "bolt.fill", destination: .technique("tools-encyclopedia-fab-flint-chert-harpoon")),
                        TriageOption(id: "g2354", label: "Fabricating a rigorous, functional hook exclusively fro", icon: "bolt.fill", destination: .technique("tools-encyclopedia-fab-flint-chert-hook")),
                        TriageOption(id: "g2355", label: "Fabricating a rigorous, functional needle exclusively f", icon: "scissors", destination: .technique("tools-encyclopedia-fab-flint-chert-needle"))
                    ])
                )),
                TriageOption(id: "g2356", label: "Obsidian", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g2356-q", question: "Select:", options: [
                        TriageOption(id: "g2357", label: "Fabricating a rigorous, functional chopper exclusively ", icon: "cross.case.fill", destination: .technique("tools-encyclopedia-fab-obsidian-chopper")),
                        TriageOption(id: "g2358", label: "Fabricating a rigorous, functional cutting flake exclus", icon: "cross.case.fill", destination: .technique("tools-encyclopedia-fab-obsidian-cutting-flake")),
                        TriageOption(id: "g2359", label: "Fabricating a rigorous, functional digging implement ex", icon: "cross.case.fill", destination: .technique("tools-encyclopedia-fab-obsidian-digging-implement")),
                        TriageOption(id: "g2360", label: "Fabricating a rigorous, functional needle exclusively f", icon: "scissors", destination: .technique("tools-encyclopedia-fab-obsidian-needle")),
                        TriageOption(id: "g2361", label: "Fabricating a rigorous, functional scraper exclusively ", icon: "cross.case.fill", destination: .technique("tools-encyclopedia-fab-obsidian-scraper"))
                    ])
                )),
                TriageOption(id: "g2362", label: "Antler", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g2362-q", question: "Select:", options: [
                        TriageOption(id: "g2363", label: "Fabricating a rigorous, functional chopper exclusively ", icon: "cross.case.fill", destination: .technique("tools-encyclopedia-fab-antler-chopper")),
                        TriageOption(id: "g2364", label: "Fabricating a rigorous, functional cutting flake exclus", icon: "cross.case.fill", destination: .technique("tools-encyclopedia-fab-antler-cutting-flake")),
                        TriageOption(id: "g2365", label: "Fabricating a rigorous, functional scraper exclusively ", icon: "cross.case.fill", destination: .technique("tools-encyclopedia-fab-antler-scraper")),
                        TriageOption(id: "g2366", label: "Fabricating a rigorous, functional harpoon exclusively ", icon: "cross.case.fill", destination: .technique("tools-encyclopedia-fab-obsidian-harpoon")),
                        TriageOption(id: "g2367", label: "Fabricating a rigorous, functional hook exclusively fro", icon: "fish.fill", destination: .technique("tools-encyclopedia-fab-obsidian-hook"))
                    ])
                )),
                TriageOption(id: "g2368", label: "Antler (2)", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g2368-q", question: "Select:", options: [
                        TriageOption(id: "g2369", label: "Fabricating a rigorous, functional digging implement ex", icon: "cross.case.fill", destination: .technique("tools-encyclopedia-fab-antler-digging-implement")),
                        TriageOption(id: "g2370", label: "Fabricating a rigorous, functional hammer exclusively f", icon: "cross.case.fill", destination: .technique("tools-encyclopedia-fab-antler-hammer")),
                        TriageOption(id: "g2371", label: "Fabricating a rigorous, functional hook exclusively fro", icon: "fish.fill", destination: .technique("tools-encyclopedia-fab-antler-hook")),
                        TriageOption(id: "g2372", label: "Fabricating a rigorous, functional needle exclusively f", icon: "scissors", destination: .technique("tools-encyclopedia-fab-antler-needle")),
                        TriageOption(id: "g2373", label: "Fabricating a rigorous, functional wedge exclusively fr", icon: "cross.case.fill", destination: .technique("tools-encyclopedia-fab-antler-wedge"))
                    ])
                )),
                TriageOption(id: "g2374", label: "Bone (4)", icon: "bandage.fill", destination: .nextQuestion(
                    TriageNode(id: "g2374-q", question: "Select:", options: [
                        TriageOption(id: "g2375", label: "Fabricating a rigorous, functional harpoon exclusively ", icon: "cross.case.fill", destination: .technique("tools-encyclopedia-fab-antler-harpoon")),
                        TriageOption(id: "g2376", label: "Fabricating a rigorous, functional chopper exclusively ", icon: "bandage.fill", destination: .technique("tools-encyclopedia-fab-bone-chopper")),
                        TriageOption(id: "g2377", label: "Fabricating a rigorous, functional cutting flake exclus", icon: "bandage.fill", destination: .technique("tools-encyclopedia-fab-bone-cutting-flake")),
                        TriageOption(id: "g2378", label: "Fabricating a rigorous, functional digging implement ex", icon: "bandage.fill", destination: .technique("tools-encyclopedia-fab-bone-digging-implement")),
                        TriageOption(id: "g2379", label: "Fabricating a rigorous, functional scraper exclusively ", icon: "bandage.fill", destination: .technique("tools-encyclopedia-fab-bone-scraper"))
                    ])
                )),
                TriageOption(id: "g2380", label: "Bone (5)", icon: "bandage.fill", destination: .nextQuestion(
                    TriageNode(id: "g2380-q", question: "Select:", options: [
                        TriageOption(id: "g2381", label: "Fabricating a rigorous, functional hammer exclusively f", icon: "bandage.fill", destination: .technique("tools-encyclopedia-fab-bone-hammer")),
                        TriageOption(id: "g2382", label: "Fabricating a rigorous, functional harpoon exclusively ", icon: "bandage.fill", destination: .technique("tools-encyclopedia-fab-bone-harpoon")),
                        TriageOption(id: "g2383", label: "Fabricating a rigorous, functional hook exclusively fro", icon: "bandage.fill", destination: .technique("tools-encyclopedia-fab-bone-hook")),
                        TriageOption(id: "g2384", label: "Fabricating a rigorous, functional needle exclusively f", icon: "bandage.fill", destination: .technique("tools-encyclopedia-fab-bone-needle")),
                        TriageOption(id: "g2385", label: "Fabricating a rigorous, functional wedge exclusively fr", icon: "bandage.fill", destination: .technique("tools-encyclopedia-fab-bone-wedge"))
                    ])
                )),
                TriageOption(id: "g2386", label: "River", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g2386-q", question: "Select:", options: [
                        TriageOption(id: "g2387", label: "Fabricating a rigorous, functional chopper exclusively ", icon: "cross.case.fill", destination: .technique("tools-encyclopedia-fab-river-cobble-chopper")),
                        TriageOption(id: "g2388", label: "Fabricating a rigorous, functional cutting flake exclus", icon: "cross.case.fill", destination: .technique("tools-encyclopedia-fab-river-cobble-cutting-flake")),
                        TriageOption(id: "g2389", label: "Fabricating a rigorous, functional digging implement ex", icon: "cross.case.fill", destination: .technique("tools-encyclopedia-fab-river-cobble-digging-implement")),
                        TriageOption(id: "g2390", label: "Fabricating a rigorous, functional scraper exclusively ", icon: "cross.case.fill", destination: .technique("tools-encyclopedia-fab-river-cobble-scraper")),
                        TriageOption(id: "g2391", label: "Fabricating a rigorous, functional wedge exclusively fr", icon: "cross.case.fill", destination: .technique("tools-encyclopedia-fab-river-cobble-wedge"))
                    ])
                )),
                TriageOption(id: "g2392", label: "River (2)", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g2392-q", question: "Select:", options: [
                        TriageOption(id: "g2393", label: "Fabricating a rigorous, functional scraper exclusively ", icon: "cross.case.fill", destination: .technique("tools-encyclopedia-fab-bamboo-scraper")),
                        TriageOption(id: "g2394", label: "Fabricating a rigorous, functional hammer exclusively f", icon: "cross.case.fill", destination: .technique("tools-encyclopedia-fab-river-cobble-hammer")),
                        TriageOption(id: "g2395", label: "Fabricating a rigorous, functional harpoon exclusively ", icon: "cross.case.fill", destination: .technique("tools-encyclopedia-fab-river-cobble-harpoon")),
                        TriageOption(id: "g2396", label: "Fabricating a rigorous, functional hook exclusively fro", icon: "fish.fill", destination: .technique("tools-encyclopedia-fab-river-cobble-hook")),
                        TriageOption(id: "g2397", label: "Fabricating a rigorous, functional needle exclusively f", icon: "scissors", destination: .technique("tools-encyclopedia-fab-river-cobble-needle"))
                    ])
                )),
                TriageOption(id: "g2398", label: "Bamboo", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g2398-q", question: "Select:", options: [
                        TriageOption(id: "g2399", label: "Fabricating a rigorous, functional cutting flake exclus", icon: "cross.case.fill", destination: .technique("tools-encyclopedia-fab-bamboo-cutting-flake")),
                        TriageOption(id: "g2400", label: "Fabricating a rigorous, functional digging implement ex", icon: "cross.case.fill", destination: .technique("tools-encyclopedia-fab-bamboo-digging-implement")),
                        TriageOption(id: "g2401", label: "Fabricating a rigorous, functional hammer exclusively f", icon: "cross.case.fill", destination: .technique("tools-encyclopedia-fab-bamboo-hammer")),
                        TriageOption(id: "g2402", label: "Fabricating a rigorous, functional needle exclusively f", icon: "scissors", destination: .technique("tools-encyclopedia-fab-bamboo-needle")),
                        TriageOption(id: "g2403", label: "Fabricating a rigorous, functional wedge exclusively fr", icon: "cross.case.fill", destination: .technique("tools-encyclopedia-fab-bamboo-wedge"))
                    ])
                )),
                TriageOption(id: "g2404", label: "Hardwood", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g2404-q", question: "Select:", options: [
                        TriageOption(id: "g2405", label: "Fabricating a rigorous, functional harpoon exclusively ", icon: "cross.case.fill", destination: .technique("tools-encyclopedia-fab-bamboo-harpoon")),
                        TriageOption(id: "g2406", label: "Fabricating a rigorous, functional hook exclusively fro", icon: "fish.fill", destination: .technique("tools-encyclopedia-fab-bamboo-hook")),
                        TriageOption(id: "g2407", label: "Fabricating a rigorous, functional cutting flake exclus", icon: "cross.case.fill", destination: .technique("tools-encyclopedia-fab-hardwood-cutting-flake")),
                        TriageOption(id: "g2408", label: "Fabricating a rigorous, functional digging implement ex", icon: "cross.case.fill", destination: .technique("tools-encyclopedia-fab-hardwood-digging-implement")),
                        TriageOption(id: "g2409", label: "Fabricating a rigorous, functional scraper exclusively ", icon: "cross.case.fill", destination: .technique("tools-encyclopedia-fab-hardwood-scraper"))
                    ])
                )),
                TriageOption(id: "g2410", label: "Hardwood (2)", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g2410-q", question: "Select:", options: [
                        TriageOption(id: "g2411", label: "Fabricating a rigorous, functional hammer exclusively f", icon: "cross.case.fill", destination: .technique("tools-encyclopedia-fab-hardwood-hammer")),
                        TriageOption(id: "g2412", label: "Fabricating a rigorous, functional harpoon exclusively ", icon: "cross.case.fill", destination: .technique("tools-encyclopedia-fab-hardwood-harpoon")),
                        TriageOption(id: "g2413", label: "Fabricating a rigorous, functional hook exclusively fro", icon: "fish.fill", destination: .technique("tools-encyclopedia-fab-hardwood-hook")),
                        TriageOption(id: "g2414", label: "Fabricating a rigorous, functional needle exclusively f", icon: "scissors", destination: .technique("tools-encyclopedia-fab-hardwood-needle")),
                        TriageOption(id: "g2415", label: "Fabricating a rigorous, functional wedge exclusively fr", icon: "cross.case.fill", destination: .technique("tools-encyclopedia-fab-hardwood-wedge"))
                    ])
                )),
                TriageOption(id: "g2416", label: "Seashell", icon: "water.waves", destination: .nextQuestion(
                    TriageNode(id: "g2416-q", question: "Select:", options: [
                        TriageOption(id: "g2417", label: "Fabricating a rigorous, functional chopper exclusively ", icon: "water.waves", destination: .technique("tools-encyclopedia-fab-seashell-chopper")),
                        TriageOption(id: "g2418", label: "Fabricating a rigorous, functional cutting flake exclus", icon: "water.waves", destination: .technique("tools-encyclopedia-fab-seashell-cutting-flake")),
                        TriageOption(id: "g2419", label: "Fabricating a rigorous, functional digging implement ex", icon: "water.waves", destination: .technique("tools-encyclopedia-fab-seashell-digging-implement")),
                        TriageOption(id: "g2420", label: "Fabricating a rigorous, functional scraper exclusively ", icon: "water.waves", destination: .technique("tools-encyclopedia-fab-seashell-scraper")),
                        TriageOption(id: "g2421", label: "Fabricating a rigorous, functional wedge exclusively fr", icon: "water.waves", destination: .technique("tools-encyclopedia-fab-seashell-wedge"))
                    ])
                )),
                TriageOption(id: "g2422", label: "Seashell (2)", icon: "water.waves", destination: .nextQuestion(
                    TriageNode(id: "g2422-q", question: "Select:", options: [
                        TriageOption(id: "g2423", label: "Creating alkaline soap to prevent skin infections.", icon: "cross.case.fill", destination: .technique("tools-lye-soap")),
                        TriageOption(id: "g2424", label: "Fabricating a rigorous, functional hammer exclusively f", icon: "water.waves", destination: .technique("tools-encyclopedia-fab-seashell-hammer")),
                        TriageOption(id: "g2425", label: "Fabricating a rigorous, functional harpoon exclusively ", icon: "water.waves", destination: .technique("tools-encyclopedia-fab-seashell-harpoon")),
                        TriageOption(id: "g2426", label: "Fabricating a rigorous, functional hook exclusively fro", icon: "fish.fill", destination: .technique("tools-encyclopedia-fab-seashell-hook")),
                        TriageOption(id: "g2427", label: "Fabricating a rigorous, functional needle exclusively f", icon: "scissors", destination: .technique("tools-encyclopedia-fab-seashell-needle"))
                    ])
                ))
                ])
            )),

            TriageOption(id: "g2428", label: "Materials", icon: "cross.case.fill", destination: .nextQuestion(
                TriageNode(id: "g2428-q", question: "What specifically?", options: [
                TriageOption(id: "g2429", label: "Wood", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g2429-q", question: "Select:", options: [
                        TriageOption(id: "g2430", label: "Prevent snow blindness using carved wood or bark", icon: "flame.fill", destination: .technique("tools-improvised-goggles")),
                        TriageOption(id: "g2431", label: "End-to-end bow drill fire starting", icon: "flame.fill", destination: .technique("tools-bow-drill-complete")),
                        TriageOption(id: "g2432", label: "Convert wood to charcoal — better fuel, essential for w", icon: "flame.fill", destination: .technique("tools-charcoal-production")),
                        TriageOption(id: "g2433", label: "Ignite tinder with compressed air — ancient technology", icon: "bandage.fill", destination: .technique("tools-fire-piston"))
                    ])
                )),
                TriageOption(id: "g2434", label: "Flesh", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g2434-q", question: "Select:", options: [
                        TriageOption(id: "g2435", label: "Produce soft, waterproof leather from raw animal hide", icon: "cloud.rain.fill", destination: .technique("tools-smoke-tanning")),
                        TriageOption(id: "g2436", label: "Processing raw animal hide into supple, durable leather", icon: "cloud.rain.fill", destination: .technique("tools-brain-tanning")),
                        TriageOption(id: "g2437", label: "Drying raw hide into strong, rigid material for lashing", icon: "link", destination: .technique("tools-rawhide-making")),
                        TriageOption(id: "g2438", label: "Create rigid material for containers, lashing, and armo", icon: "link", destination: .technique("tools-rawhide-production"))
                    ])
                )),
                TriageOption(id: "g2439", label: "Drill", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g2439-q", question: "Select:", options: [
                        TriageOption(id: "g2440", label: "Mullein or cattail spindle fire starting", icon: "flame.fill", destination: .technique("tools-hand-drill-complete")),
                        TriageOption(id: "g2441", label: "Mechanically sustained friction fire", icon: "flame.fill", destination: .technique("tools-pump-drill-assembly")),
                        TriageOption(id: "g2442", label: "Friction fire with mechanical advantage — less effort t", icon: "flame.fill", destination: .technique("tools-pump-drill"))
                    ])
                )),
                TriageOption(id: "g2443", label: "Natural", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g2443-q", question: "Select:", options: [
                        TriageOption(id: "g2444", label: "The original superglue — waterproof and strong", icon: "drop.fill", destination: .technique("tools-birch-tar-adhesive")),
                        TriageOption(id: "g2445", label: "Make strong glue from pine resin and charcoal", icon: "drop.fill", destination: .technique("tools-natural-adhesive"))
                    ])
                )),
                TriageOption(id: "g2446", label: "Long", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g2446-q", question: "Select:", options: [
                        TriageOption(id: "g2447", label: "Building a casualty-carrying stretcher from field mater", icon: "figure.walk.motion", destination: .technique("tools-stretcher-carry")),
                        TriageOption(id: "g2448", label: "Building a drag-sled to transport injured people or hea", icon: "figure.walk.motion", destination: .technique("tools-travois"))
                    ])
                )),
                TriageOption(id: "g2449", label: "Hide", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g2449-q", question: "Select:", options: [
                        TriageOption(id: "g2450", label: "Strike sparks in any weather — most reliable fire start", icon: "figure.stand", destination: .technique("tools-fire-steel-technique")),
                        TriageOption(id: "g2451", label: "Strong adhesive from animal skin scraps", icon: "pawprint.fill", destination: .technique("tools-hide-glue"))
                    ])
                ))
                ])
            )),

            TriageOption(id: "g2452", label: "Mental Resilience", icon: "cross.case.fill", destination: .nextQuestion(
                TriageNode(id: "g2452-q", question: "What specifically?", options: [
                TriageOption(id: "g2453", label: "Managing", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g2453-q", question: "Select:", options: [
                        TriageOption(id: "g2454", label: "Managing primal terror when alone in complete darkness", icon: "pawprint.fill", destination: .technique("psych-night-fear")),
                        TriageOption(id: "g2455", label: "Prevent poor choices by managing mental energy", icon: "brain.fill", destination: .technique("psych-decision-mgmt")),
                        TriageOption(id: "g2456", label: "Managing shock after the sudden loss of a group member", icon: "bolt.fill", destination: .technique("psych-grief-triage")),
                        TriageOption(id: "g2457", label: "Surviving total darkness or whiteouts without losing yo", icon: "leaf.fill", destination: .technique("psych-sensory-deprivation"))
                    ])
                )),
                TriageOption(id: "g2458", label: "Management", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g2458-q", question: "Select:", options: [
                        TriageOption(id: "g2459", label: "Handle the psychological challenge of darkness in the w", icon: "brain.head.profile", destination: .technique("psych-night-anxiety-mgmt")),
                        TriageOption(id: "g2460", label: "Cope with isolation in snow caves or dark environments", icon: "cloud.rain.fill", destination: .technique("psych-sensory-deprivation-mgmt")),
                        TriageOption(id: "g2461", label: "Process grief while continuing to survive in group disa", icon: "cloud.rain.fill", destination: .technique("psych-survivor-guilt-management"))
                    ])
                )),
                TriageOption(id: "g2462", label: "Mental", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g2462-q", question: "Select:", options: [
                        TriageOption(id: "g2463", label: "Create mental anchors that sustain the will to survive", icon: "heart.fill", destination: .technique("psych-hope-anchoring")),
                        TriageOption(id: "g2464", label: "Why mental attitude is the single greatest survival fac", icon: "cloud.rain.fill", destination: .technique("psych-will-to-survive"))
                    ])
                )),
                TriageOption(id: "g2465", label: "Psychological", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g2465-q", question: "Select:", options: [
                        TriageOption(id: "g2466", label: "Use structured self-talk to maintain morale alone", icon: "heart.fill", destination: .technique("psych-solo-pep-talk")),
                        TriageOption(id: "g2467", label: "Understand the psychological stages after a traumatic e", icon: "bolt.fill", destination: .technique("psych-trauma-response-phases"))
                    ])
                )),
                TriageOption(id: "g2468", label: "Down", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g2468-q", question: "Select:", options: [
                        TriageOption(id: "g2469", label: "Calm the mind using breathing meditation", icon: "lungs.fill", destination: .technique("psych-meditation-breathing")),
                        TriageOption(id: "g2470", label: "A memorized sequence to interrupt full-blown panic atta", icon: "brain.head.profile", destination: .technique("psych-panic-stop-protocol"))
                    ])
                )),
                TriageOption(id: "g2471", label: "Without", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g2471-q", question: "Select:", options: [
                        TriageOption(id: "g2472", label: "When to stop making choices that could kill you", icon: "brain.fill", destination: .technique("psych-decision-fatigue-halt")),
                        TriageOption(id: "g2473", label: "Breaking the cycle of passive surrender", icon: "cross.case.fill", destination: .technique("psych-learned-helplessness-counter")),
                        TriageOption(id: "g2474", label: "Pre-exposure to build stress tolerance", icon: "cloud.rain.fill", destination: .technique("psych-stress-inoculation")),
                        TriageOption(id: "g2475", label: "Remember and recite the critical survival priority orde", icon: "flame.fill", destination: .technique("psych-survival-priorities-recitation"))
                    ])
                ))
                ])
            )),

            TriageOption(id: "g2476", label: "Morale", icon: "heart.fill", destination: .nextQuestion(
                TriageNode(id: "g2476-q", question: "Which best matches?", options: [
                    TriageOption(id: "g2477", label: "Convert paralyzing panic into productive fear", icon: "brain.head.profile", destination: .technique("psych-fear-vs-panic")),
                    TriageOption(id: "g2478", label: "Use rationing and food rituals to maintain hope", icon: "figure.walk.motion", destination: .technique("psych-morale-food-psychology")),
                    TriageOption(id: "g2479", label: "Maintain sanity over weeks or months alone", icon: "cross.case.fill", destination: .technique("psych-long-term-isolation")),
                    TriageOption(id: "g2480", label: "Rotating watch schedule for group survival", icon: "person.3.fill", destination: .technique("psych-night-watch-protocol")),
                    TriageOption(id: "g2481", label: "Maintain decision-making ability under severe fatigue", icon: "brain.fill", destination: .technique("psych-sleep-deprivation-coping"))
                ])
            )),

            TriageOption(id: "g2482", label: "Panic & Stress", icon: "brain.head.profile", destination: .nextQuestion(
                TriageNode(id: "g2482-q", question: "What specifically?", options: [
                TriageOption(id: "g2483", label: "Mental", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g2483-q", question: "Select:", options: [
                        TriageOption(id: "g2484", label: "Applying mental mathematics as a direct countermeasure ", icon: "cross.case.fill", destination: .technique("psych-encyclopedia-sere-extreme-pain-mental-mathematics")),
                        TriageOption(id: "g2485", label: "Applying mental mathematics as a direct countermeasure ", icon: "cross.case.fill", destination: .technique("psych-encyclopedia-sere-interrogation-mental-mathematics")),
                        TriageOption(id: "g2486", label: "Applying mental mathematics as a direct countermeasure ", icon: "cross.case.fill", destination: .technique("psych-encyclopedia-sere-isolation-mental-mathematics")),
                        TriageOption(id: "g2487", label: "Applying mental mathematics as a direct countermeasure ", icon: "star.fill", destination: .technique("psych-encyclopedia-sere-starvation-mental-mathematics")),
                        TriageOption(id: "g2488", label: "Manage the mental impact of being injured in a survival", icon: "cross.case.fill", destination: .technique("psych-coping-with-injury"))
                    ])
                )),
                TriageOption(id: "g2489", label: "Compartmentalization", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g2489-q", question: "Select:", options: [
                        TriageOption(id: "g2490", label: "Applying compartmentalization as a direct countermeasur", icon: "cross.case.fill", destination: .technique("psych-encyclopedia-sere-extreme-pain-compartmentalization")),
                        TriageOption(id: "g2491", label: "Applying compartmentalization as a direct countermeasur", icon: "cross.case.fill", destination: .technique("psych-encyclopedia-sere-interrogation-compartmentalization")),
                        TriageOption(id: "g2492", label: "Applying compartmentalization as a direct countermeasur", icon: "cross.case.fill", destination: .technique("psych-encyclopedia-sere-isolation-compartmentalization")),
                        TriageOption(id: "g2493", label: "Applying compartmentalization as a direct countermeasur", icon: "moon.fill", destination: .technique("psych-encyclopedia-sere-sleep-deprivation-compartmentalization")),
                        TriageOption(id: "g2494", label: "Applying compartmentalization as a direct countermeasur", icon: "star.fill", destination: .technique("psych-encyclopedia-sere-starvation-compartmentalization"))
                    ])
                )),
                TriageOption(id: "g2495", label: "Rhythmic", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g2495-q", question: "Select:", options: [
                        TriageOption(id: "g2496", label: "Applying rhythmic breathing as a direct countermeasure ", icon: "lungs.fill", destination: .technique("psych-encyclopedia-sere-extreme-pain-rhythmic-breathing")),
                        TriageOption(id: "g2497", label: "Applying rhythmic breathing as a direct countermeasure ", icon: "lungs.fill", destination: .technique("psych-encyclopedia-sere-interrogation-rhythmic-breathing")),
                        TriageOption(id: "g2498", label: "Applying rhythmic breathing as a direct countermeasure ", icon: "lungs.fill", destination: .technique("psych-encyclopedia-sere-isolation-rhythmic-breathing")),
                        TriageOption(id: "g2499", label: "Applying rhythmic breathing as a direct countermeasure ", icon: "lungs.fill", destination: .technique("psych-encyclopedia-sere-sleep-deprivation-rhythmic-breathing")),
                        TriageOption(id: "g2500", label: "Applying rhythmic breathing as a direct countermeasure ", icon: "lungs.fill", destination: .technique("psych-encyclopedia-sere-starvation-rhythmic-breathing"))
                    ])
                )),
                TriageOption(id: "g2501", label: "Generation", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g2501-q", question: "Select:", options: [
                        TriageOption(id: "g2502", label: "Applying anger/spite generation as a direct countermeas", icon: "cross.case.fill", destination: .technique("psych-encyclopedia-sere-extreme-pain-anger-spite-generation")),
                        TriageOption(id: "g2503", label: "Applying anger/spite generation as a direct countermeas", icon: "cross.case.fill", destination: .technique("psych-encyclopedia-sere-interrogation-anger-spite-generation")),
                        TriageOption(id: "g2504", label: "Applying anger/spite generation as a direct countermeas", icon: "cross.case.fill", destination: .technique("psych-encyclopedia-sere-isolation-anger-spite-generation")),
                        TriageOption(id: "g2505", label: "Applying anger/spite generation as a direct countermeas", icon: "moon.fill", destination: .technique("psych-encyclopedia-sere-sleep-deprivation-anger-spite-generation")),
                        TriageOption(id: "g2506", label: "Applying anger/spite generation as a direct countermeas", icon: "star.fill", destination: .technique("psych-encyclopedia-sere-starvation-anger-spite-generation"))
                    ])
                )),
                TriageOption(id: "g2507", label: "Hymn", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g2507-q", question: "Select:", options: [
                        TriageOption(id: "g2508", label: "Applying hymn/mantra repetition as a direct countermeas", icon: "cross.case.fill", destination: .technique("psych-encyclopedia-sere-extreme-pain-hymn-mantra-repetition")),
                        TriageOption(id: "g2509", label: "Applying hymn/mantra repetition as a direct countermeas", icon: "cross.case.fill", destination: .technique("psych-encyclopedia-sere-interrogation-hymn-mantra-repetition")),
                        TriageOption(id: "g2510", label: "Applying hymn/mantra repetition as a direct countermeas", icon: "cross.case.fill", destination: .technique("psych-encyclopedia-sere-isolation-hymn-mantra-repetition")),
                        TriageOption(id: "g2511", label: "Applying hymn/mantra repetition as a direct countermeas", icon: "moon.fill", destination: .technique("psych-encyclopedia-sere-sleep-deprivation-hymn-mantra-repetition")),
                        TriageOption(id: "g2512", label: "Applying hymn/mantra repetition as a direct countermeas", icon: "star.fill", destination: .technique("psych-encyclopedia-sere-starvation-hymn-mantra-repetition"))
                    ])
                )),
                TriageOption(id: "g2513", label: "Breathing", icon: "lungs.fill", destination: .nextQuestion(
                    TriageNode(id: "g2513-q", question: "Select:", options: [
                        TriageOption(id: "g2514", label: "Control the stress response in the first critical hours", icon: "heart.fill", destination: .technique("psych-acute-stress-mgmt")),
                        TriageOption(id: "g2515", label: "Down-regulating the sympathetic nervous system", icon: "lungs.fill", destination: .technique("psych-combat-breathing-tactical")),
                        TriageOption(id: "g2516", label: "Transitioning between survival states of alertness", icon: "cross.case.fill", destination: .technique("psych-combat-mindset-reset")),
                        TriageOption(id: "g2517", label: "Release physical tension to calm the mind", icon: "star.fill", destination: .technique("psych-progressive-muscle-relaxation")),
                        TriageOption(id: "g2518", label: "Advanced breathing for sustained high-stress operations", icon: "lungs.fill", destination: .technique("psych-tactical-breathing-extended"))
                    ])
                )),
                TriageOption(id: "g2519", label: "Panic", icon: "brain.head.profile", destination: .nextQuestion(
                    TriageNode(id: "g2519-q", question: "Select:", options: [
                        TriageOption(id: "g2520", label: "Interrupt panic attacks and dissociation using five sen", icon: "brain.head.profile", destination: .technique("psych-sensory-grounding")),
                        TriageOption(id: "g2521", label: "Break the panic cycle before it kills you", icon: "brain.head.profile", destination: .technique("psych-panic-management")),
                        TriageOption(id: "g2522", label: "Handle nighttime fear and hypervigilance in wilderness", icon: "sun.max.fill", destination: .technique("psych-night-anxiety-management")),
                        TriageOption(id: "g2523", label: "Separate real threats from imagined ones", icon: "cross.case.fill", destination: .technique("psych-fear-inventory")),
                        TriageOption(id: "g2524", label: "Prioritization framework under extreme stress", icon: "list.bullet.clipboard.fill", destination: .technique("psych-sere-pattern-of-survival"))
                    ])
                )),
                TriageOption(id: "g2525", label: "Apathy", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g2525-q", question: "Select:", options: [
                        TriageOption(id: "g2526", label: "Forcing the parasympathetic nervous system online.", icon: "lungs.fill", destination: .technique("psych-fear-management-box-breathing")),
                        TriageOption(id: "g2527", label: "The definitive physiological state of readiness.", icon: "cross.case.fill", destination: .technique("psych-coopers-colors")),
                        TriageOption(id: "g2528", label: "Preventing cognitive decline during extended waiting pe", icon: "cross.case.fill", destination: .technique("psych-sere-boredom-management")),
                        TriageOption(id: "g2529", label: "Balancing brutal realism with absolute faith in surviva", icon: "cross.case.fill", destination: .technique("psych-the-stockdale-paradox"))
                    ])
                ))
                ])
            )),

            TriageOption(id: "g2530", label: "Security Threats", icon: "cross.case.fill", destination: .nextQuestion(
                TriageNode(id: "g2530-q", question: "Which best matches?", options: [
                    TriageOption(id: "g2531", label: "Tactical evasion and cover utilization", icon: "eye.slash.fill", destination: .technique("rescue-active-shooter-geometry")),
                    TriageOption(id: "g2532", label: "Defuse hostile situations", icon: "cross.case.fill", destination: .technique("psych-deescalation")),
                    TriageOption(id: "g2533", label: "Early warning system for camp security", icon: "mappin.and.ellipse", destination: .technique("rescue-perimeter-alarm")),
                    TriageOption(id: "g2534", label: "Navigating fluid human crush dynamics", icon: "eye.slash.fill", destination: .technique("rescue-riot-mob-evasion"))
                ])
            )),

            TriageOption(id: "g2535", label: "Self-Rescue", icon: "figure.walk.motion", destination: .nextQuestion(
                TriageNode(id: "g2535-q", question: "What specifically?", options: [
                TriageOption(id: "g2536", label: "Stretcher", icon: "figure.walk.motion", destination: .nextQuestion(
                    TriageNode(id: "g2536-q", question: "Select:", options: [
                        TriageOption(id: "g2537", label: "Build a carrying stretcher from available materials", icon: "figure.walk.motion", destination: .technique("rescue-self-evacuation-litter")),
                        TriageOption(id: "g2538", label: "Carry an injured person safely with minimal materials", icon: "figure.walk.motion", destination: .technique("rescue-stretcher-improvised"))
                    ])
                )),
                TriageOption(id: "g2539", label: "Moving", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g2539-q", question: "Select:", options: [
                        TriageOption(id: "g2540", label: "Moving a casualty alone across terrain", icon: "figure.walk.motion", destination: .technique("rescue-litter-drag")),
                        TriageOption(id: "g2541", label: "Moving massive weight with ropes", icon: "link", destination: .technique("rescue-z-drag"))
                    ])
                )),
                TriageOption(id: "g2542", label: "Face", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g2542-q", question: "Select:", options: [
                        TriageOption(id: "g2543", label: "Carrying an unconscious person over shoulders", icon: "flame.fill", destination: .technique("rescue-firemans-carry")),
                        TriageOption(id: "g2544", label: "Carrying a conscious casualty using arms as a seat", icon: "water.waves", destination: .technique("rescue-two-person-seat-carry"))
                    ])
                )),
                TriageOption(id: "g2545", label: "Transport", icon: "figure.walk.motion", destination: .nextQuestion(
                    TriageNode(id: "g2545-q", question: "Select:", options: [
                        TriageOption(id: "g2546", label: "Securing injured for safe movement", icon: "figure.walk.motion", destination: .technique("rescue-casualty-packaging")),
                        TriageOption(id: "g2547", label: "Transport injured people or heavy loads across terrain", icon: "figure.walk.motion", destination: .technique("rescue-travois-construction"))
                    ])
                )),
                TriageOption(id: "g2548", label: "Select", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g2548-q", question: "Select:", options: [
                        TriageOption(id: "g2549", label: "Build a river-crossing or coastal raft from logs", icon: "cross.case.fill", destination: .technique("rescue-raft-building")),
                        TriageOption(id: "g2550", label: "Walk on deep snow without sinking — essential winter tr", icon: "cross.case.fill", destination: .technique("rescue-snowshoe-construction"))
                    ])
                ))
                ])
            )),

            TriageOption(id: "g2551", label: "Technical Rescue", icon: "figure.walk.motion", destination: .nextQuestion(
                TriageNode(id: "g2551-q", question: "What specifically?", options: [
                TriageOption(id: "g2552", label: "Crevasse", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g2552-q", question: "Select:", options: [
                        TriageOption(id: "g2553", label: "Integrating the Clove Hitch perfectly within a crevasse", icon: "link", destination: .technique("rescue-encyclopedia-rigging-crevasse-rescue-clove-hitch")),
                        TriageOption(id: "g2554", label: "Integrating the Double Fisherman's Bend perfectly withi", icon: "fish.fill", destination: .technique("rescue-encyclopedia-rigging-crevasse-rescue-double-fishermans-bend")),
                        TriageOption(id: "g2555", label: "Integrating the Figure-8 on a Bight perfectly within a ", icon: "figure.walk.motion", destination: .technique("rescue-encyclopedia-rigging-crevasse-rescue-figure-8-on-a-bight")),
                        TriageOption(id: "g2556", label: "Integrating the Tensionless Hitch perfectly within a cr", icon: "link", destination: .technique("rescue-encyclopedia-rigging-crevasse-rescue-tensionless-hitch")),
                        TriageOption(id: "g2557", label: "Climb out of a crevasse using prusik knots and self-res", icon: "list.bullet.clipboard.fill", destination: .technique("rescue-self-rescue-crevasse"))
                    ])
                )),
                TriageOption(id: "g2558", label: "Tensioned", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g2558-q", question: "Select:", options: [
                        TriageOption(id: "g2559", label: "Cross a gap using a tensioned rope — river crossings, c", icon: "link", destination: .technique("rescue-rope-traverse")),
                        TriageOption(id: "g2560", label: "Integrating the Bowline on a Coil perfectly within a te", icon: "link", destination: .technique("rescue-encyclopedia-rigging-tensioned-highline-bowline-on-a-coil")),
                        TriageOption(id: "g2561", label: "Integrating the Double Fisherman's Bend perfectly withi", icon: "fish.fill", destination: .technique("rescue-encyclopedia-rigging-tensioned-highline-double-fishermans-bend")),
                        TriageOption(id: "g2562", label: "Integrating the Figure-8 on a Bight perfectly within a ", icon: "cross.case.fill", destination: .technique("rescue-encyclopedia-rigging-tensioned-highline-figure-8-on-a-bight")),
                        TriageOption(id: "g2563", label: "Integrating the Tensionless Hitch perfectly within a te", icon: "link", destination: .technique("rescue-encyclopedia-rigging-tensioned-highline-tensionless-hitch"))
                    ])
                )),
                TriageOption(id: "g2564", label: "Rappel", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g2564-q", question: "Select:", options: [
                        TriageOption(id: "g2565", label: "Integrating the Bowline on a Coil perfectly within a ra", icon: "link", destination: .technique("rescue-encyclopedia-rigging-rappel-anchor-bowline-on-a-coil")),
                        TriageOption(id: "g2566", label: "Integrating the Clove Hitch perfectly within a rappel a", icon: "link", destination: .technique("rescue-encyclopedia-rigging-rappel-anchor-clove-hitch")),
                        TriageOption(id: "g2567", label: "Integrating the Double Fisherman's Bend perfectly withi", icon: "fish.fill", destination: .technique("rescue-encyclopedia-rigging-rappel-anchor-double-fishermans-bend")),
                        TriageOption(id: "g2568", label: "Integrating the Figure-8 on a Bight perfectly within a ", icon: "cross.case.fill", destination: .technique("rescue-encyclopedia-rigging-rappel-anchor-figure-8-on-a-bight")),
                        TriageOption(id: "g2569", label: "Integrating the Tensionless Hitch perfectly within a ra", icon: "link", destination: .technique("rescue-encyclopedia-rigging-rappel-anchor-tensionless-hitch"))
                    ])
                )),
                TriageOption(id: "g2570", label: "Litter", icon: "figure.walk.motion", destination: .nextQuestion(
                    TriageNode(id: "g2570-q", question: "Select:", options: [
                        TriageOption(id: "g2571", label: "Integrating the Bowline on a Coil perfectly within a li", icon: "figure.walk.motion", destination: .technique("rescue-encyclopedia-rigging-litter-hoist-z-drag-bowline-on-a-coil")),
                        TriageOption(id: "g2572", label: "Integrating the Clove Hitch perfectly within a litter h", icon: "figure.walk.motion", destination: .technique("rescue-encyclopedia-rigging-litter-hoist-z-drag-clove-hitch")),
                        TriageOption(id: "g2573", label: "Integrating the Double Fisherman's Bend perfectly withi", icon: "figure.walk.motion", destination: .technique("rescue-encyclopedia-rigging-litter-hoist-z-drag-double-fishermans-bend")),
                        TriageOption(id: "g2574", label: "Integrating the Figure-8 on a Bight perfectly within a ", icon: "figure.walk.motion", destination: .technique("rescue-encyclopedia-rigging-litter-hoist-z-drag-figure-8-on-a-bight"))
                    ])
                )),
                TriageOption(id: "g2575", label: "Rope", icon: "link", destination: .nextQuestion(
                    TriageNode(id: "g2575-q", question: "Select:", options: [
                        TriageOption(id: "g2576", label: "Rope harness for rappelling or lowering — no gear neede", icon: "figure.walk.motion", destination: .technique("rescue-knot-rescue-harness")),
                        TriageOption(id: "g2577", label: "Mechanical advantage for rescue hauling", icon: "figure.walk.motion", destination: .technique("rescue-rope-haul-system"))
                    ])
                )),
                TriageOption(id: "g2578", label: "Safe", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g2578-q", question: "Select:", options: [
                        TriageOption(id: "g2579", label: "Escaping entrapment inside a building", icon: "target", destination: .technique("rescue-breaching-interior")),
                        TriageOption(id: "g2580", label: "Safe entry into collapsed or enclosed spaces", icon: "cross.case.fill", destination: .technique("rescue-confined-space-entry")),
                        TriageOption(id: "g2581", label: "Prepare a safe landing zone for medical evacuation", icon: "figure.walk.motion", destination: .technique("rescue-heli-lz-prep")),
                        TriageOption(id: "g2582", label: "Immediate actions when someone falls into the water fro", icon: "cylinder.fill", destination: .technique("rescue-man-overboard")),
                        TriageOption(id: "g2583", label: "Finding and extracting survivors in collapsed structure", icon: "figure.walk.motion", destination: .technique("rescue-urban-rubble-rescue"))
                    ])
                )),
                TriageOption(id: "g2584", label: "Water", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g2584-q", question: "Select:", options: [
                        TriageOption(id: "g2585", label: "Cardiopulmonary resuscitation — current guidelines", icon: "lungs.fill", destination: .technique("rescue-cpr-adult")),
                        TriageOption(id: "g2586", label: "Abdominal thrusts for complete airway obstruction", icon: "lungs.fill", destination: .technique("rescue-choking-adult")),
                        TriageOption(id: "g2587", label: "Get a person off a ledge safely without technical gear", icon: "list.bullet.clipboard.fill", destination: .technique("rescue-cliff-rescue-basics")),
                        TriageOption(id: "g2588", label: "Survive falling into fast-moving water", icon: "figure.walk.motion", destination: .technique("rescue-river-rescue-self")),
                        TriageOption(id: "g2589", label: "Evacuate a compromised building safely", icon: "lungs.fill", destination: .technique("rescue-urban-escape"))
                    ])
                ))
                ])
            )),

            TriageOption(id: "g2590", label: "Urban Scavenging", icon: "building.2.fill", destination: .nextQuestion(
                TriageNode(id: "g2590-q", question: "What specifically?", options: [
                TriageOption(id: "g2591", label: "Pipe", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g2591-q", question: "Select:", options: [
                        TriageOption(id: "g2592", label: "Scavenging and deploying pvc pipe to actively combat ag", icon: "cross.case.fill", destination: .technique("tools-encyclopedia-scavenge-pvc-aggressive")),
                        TriageOption(id: "g2593", label: "Scavenging and deploying pvc pipe to actively combat ci", icon: "cross.case.fill", destination: .technique("tools-encyclopedia-scavenge-pvc-civil")),
                        TriageOption(id: "g2594", label: "Scavenging and deploying pvc pipe to actively combat co", icon: "water.waves", destination: .technique("tools-encyclopedia-scavenge-pvc-contaminated")),
                        TriageOption(id: "g2595", label: "Scavenging and deploying pvc pipe to actively combat hy", icon: "snowflake", destination: .technique("tools-encyclopedia-scavenge-pvc-hypothermia")),
                        TriageOption(id: "g2596", label: "Scavenging and deploying pvc pipe to actively combat st", icon: "cross.case.fill", destination: .technique("tools-encyclopedia-scavenge-pvc-structural"))
                    ])
                )),
                TriageOption(id: "g2597", label: "Wire", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g2597-q", question: "Select:", options: [
                        TriageOption(id: "g2598", label: "Scavenging and deploying copper wire to actively combat", icon: "cross.case.fill", destination: .technique("tools-encyclopedia-scavenge-copper-aggressive")),
                        TriageOption(id: "g2599", label: "Scavenging and deploying copper wire to actively combat", icon: "cross.case.fill", destination: .technique("tools-encyclopedia-scavenge-copper-civil")),
                        TriageOption(id: "g2600", label: "Scavenging and deploying copper wire to actively combat", icon: "water.waves", destination: .technique("tools-encyclopedia-scavenge-copper-contaminated")),
                        TriageOption(id: "g2601", label: "Scavenging and deploying copper wire to actively combat", icon: "cross.case.fill", destination: .technique("tools-encyclopedia-scavenge-copper-hyperthermia")),
                        TriageOption(id: "g2602", label: "Scavenging and deploying copper wire to actively combat", icon: "snowflake", destination: .technique("tools-encyclopedia-scavenge-copper-hypothermia")),
                        TriageOption(id: "g2603", label: "Scavenging and deploying copper wire to actively combat", icon: "cross.case.fill", destination: .technique("tools-encyclopedia-scavenge-copper-structural"))
                    ])
                )),
                TriageOption(id: "g2604", label: "Tape", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g2604-q", question: "Select:", options: [
                        TriageOption(id: "g2605", label: "Scavenging and deploying duct tape to actively combat a", icon: "cross.case.fill", destination: .technique("tools-encyclopedia-scavenge-duct-aggressive")),
                        TriageOption(id: "g2606", label: "Scavenging and deploying duct tape to actively combat c", icon: "cross.case.fill", destination: .technique("tools-encyclopedia-scavenge-duct-civil")),
                        TriageOption(id: "g2607", label: "Scavenging and deploying duct tape to actively combat c", icon: "water.waves", destination: .technique("tools-encyclopedia-scavenge-duct-contaminated")),
                        TriageOption(id: "g2608", label: "Scavenging and deploying duct tape to actively combat h", icon: "cross.case.fill", destination: .technique("tools-encyclopedia-scavenge-duct-hyperthermia")),
                        TriageOption(id: "g2609", label: "Scavenging and deploying duct tape to actively combat h", icon: "snowflake", destination: .technique("tools-encyclopedia-scavenge-duct-hypothermia")),
                        TriageOption(id: "g2610", label: "Scavenging and deploying duct tape to actively combat s", icon: "cross.case.fill", destination: .technique("tools-encyclopedia-scavenge-duct-structural"))
                    ])
                )),
                TriageOption(id: "g2611", label: "Bottles", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g2611-q", question: "Select:", options: [
                        TriageOption(id: "g2612", label: "Scavenging and deploying glass bottles to actively comb", icon: "cross.case.fill", destination: .technique("tools-encyclopedia-scavenge-glass-aggressive")),
                        TriageOption(id: "g2613", label: "Scavenging and deploying glass bottles to actively comb", icon: "cross.case.fill", destination: .technique("tools-encyclopedia-scavenge-glass-civil")),
                        TriageOption(id: "g2614", label: "Scavenging and deploying glass bottles to actively comb", icon: "water.waves", destination: .technique("tools-encyclopedia-scavenge-glass-contaminated")),
                        TriageOption(id: "g2615", label: "Scavenging and deploying glass bottles to actively comb", icon: "cross.case.fill", destination: .technique("tools-encyclopedia-scavenge-glass-hyperthermia")),
                        TriageOption(id: "g2616", label: "Scavenging and deploying glass bottles to actively comb", icon: "snowflake", destination: .technique("tools-encyclopedia-scavenge-glass-hypothermia")),
                        TriageOption(id: "g2617", label: "Scavenging and deploying glass bottles to actively comb", icon: "cross.case.fill", destination: .technique("tools-encyclopedia-scavenge-glass-structural"))
                    ])
                )),
                TriageOption(id: "g2618", label: "Screws", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g2618-q", question: "Select:", options: [
                        TriageOption(id: "g2619", label: "Scavenging and deploying drywall screws to actively com", icon: "cross.case.fill", destination: .technique("tools-encyclopedia-scavenge-drywall-aggressive")),
                        TriageOption(id: "g2620", label: "Scavenging and deploying drywall screws to actively com", icon: "cross.case.fill", destination: .technique("tools-encyclopedia-scavenge-drywall-civil")),
                        TriageOption(id: "g2621", label: "Scavenging and deploying drywall screws to actively com", icon: "snowflake", destination: .technique("tools-encyclopedia-scavenge-drywall-hypothermia")),
                        TriageOption(id: "g2622", label: "Scavenging and deploying drywall screws to actively com", icon: "cross.case.fill", destination: .technique("tools-encyclopedia-scavenge-drywall-structural"))
                    ])
                )),
                TriageOption(id: "g2623", label: "Latrine", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g2623-q", question: "Select:", options: [
                        TriageOption(id: "g2624", label: "Building a proper field latrine", icon: "mappin.and.ellipse", destination: .technique("tools-camp-latrine-construction")),
                        TriageOption(id: "g2625", label: "Cutting PVC, zip ties, or wood with string", icon: "flame.fill", destination: .technique("tools-friction-saw")),
                        TriageOption(id: "g2626", label: "Opening a padlock using an aluminum soda can.", icon: "cross.case.fill", destination: .technique("tools-padlock-shim")),
                        TriageOption(id: "g2627", label: "Baking with reflected fire heat", icon: "flame.fill", destination: .technique("tools-fire-reflector-oven")),
                        TriageOption(id: "g2628", label: "Bypassing a standard spring latch using a plastic card.", icon: "drop.fill", destination: .technique("tools-door-loiding"))
                    ])
                )),
                TriageOption(id: "g2629", label: "Battery", icon: "bolt.fill", destination: .nextQuestion(
                    TriageNode(id: "g2629-q", question: "Select:", options: [
                        TriageOption(id: "g2630", label: "Scavenging and deploying car battery to actively combat", icon: "bolt.fill", destination: .technique("tools-encyclopedia-scavenge-car-aggressive")),
                        TriageOption(id: "g2631", label: "Scavenging and deploying car battery to actively combat", icon: "bolt.fill", destination: .technique("tools-encyclopedia-scavenge-car-civil")),
                        TriageOption(id: "g2632", label: "Scavenging and deploying car battery to actively combat", icon: "bolt.fill", destination: .technique("tools-encyclopedia-scavenge-car-contaminated")),
                        TriageOption(id: "g2633", label: "Scavenging and deploying car battery to actively combat", icon: "bolt.fill", destination: .technique("tools-encyclopedia-scavenge-car-hyperthermia")),
                        TriageOption(id: "g2634", label: "Scavenging and deploying car battery to actively combat", icon: "snowflake", destination: .technique("tools-encyclopedia-scavenge-car-hypothermia"))
                    ])
                )),
                TriageOption(id: "g2635", label: "Tire", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g2635-q", question: "Select:", options: [
                        TriageOption(id: "g2636", label: "Scavenging and deploying car battery to actively combat", icon: "bolt.fill", destination: .technique("tools-encyclopedia-scavenge-car-structural")),
                        TriageOption(id: "g2637", label: "Scavenging and deploying tire inner tube to actively co", icon: "cross.case.fill", destination: .technique("tools-encyclopedia-scavenge-tire-aggressive")),
                        TriageOption(id: "g2638", label: "Scavenging and deploying tire inner tube to actively co", icon: "water.waves", destination: .technique("tools-encyclopedia-scavenge-tire-contaminated")),
                        TriageOption(id: "g2639", label: "Scavenging and deploying tire inner tube to actively co", icon: "cross.case.fill", destination: .technique("tools-encyclopedia-scavenge-tire-hyperthermia")),
                        TriageOption(id: "g2640", label: "Scavenging and deploying tire inner tube to actively co", icon: "snowflake", destination: .technique("tools-encyclopedia-scavenge-tire-hypothermia"))
                    ])
                )),
                TriageOption(id: "g2641", label: "Sheet", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g2641-q", question: "Select:", options: [
                        TriageOption(id: "g2642", label: "Scavenging and deploying sheet metal to actively combat", icon: "water.waves", destination: .technique("tools-encyclopedia-scavenge-sheet-contaminated")),
                        TriageOption(id: "g2643", label: "Scavenging and deploying sheet metal to actively combat", icon: "cross.case.fill", destination: .technique("tools-encyclopedia-scavenge-sheet-hyperthermia")),
                        TriageOption(id: "g2644", label: "Scavenging and deploying sheet metal to actively combat", icon: "snowflake", destination: .technique("tools-encyclopedia-scavenge-sheet-hypothermia")),
                        TriageOption(id: "g2645", label: "Scavenging and deploying tire inner tube to actively co", icon: "cross.case.fill", destination: .technique("tools-encyclopedia-scavenge-tire-civil")),
                        TriageOption(id: "g2646", label: "Scavenging and deploying tire inner tube to actively co", icon: "cross.case.fill", destination: .technique("tools-encyclopedia-scavenge-tire-structural"))
                    ])
                )),
                TriageOption(id: "g2647", label: "Sheet (2)", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g2647-q", question: "Select:", options: [
                        TriageOption(id: "g2648", label: "Scavenging and deploying clothing to actively combat hy", icon: "cross.case.fill", destination: .technique("tools-encyclopedia-scavenge-clothing-rags-hyperthermia")),
                        TriageOption(id: "g2649", label: "Scavenging and deploying clothing to actively combat hy", icon: "snowflake", destination: .technique("tools-encyclopedia-scavenge-clothing-rags-hypothermia")),
                        TriageOption(id: "g2650", label: "Scavenging and deploying sheet metal to actively combat", icon: "cross.case.fill", destination: .technique("tools-encyclopedia-scavenge-sheet-aggressive")),
                        TriageOption(id: "g2651", label: "Scavenging and deploying sheet metal to actively combat", icon: "cross.case.fill", destination: .technique("tools-encyclopedia-scavenge-sheet-civil")),
                        TriageOption(id: "g2652", label: "Scavenging and deploying sheet metal to actively combat", icon: "cross.case.fill", destination: .technique("tools-encyclopedia-scavenge-sheet-structural"))
                    ])
                )),
                TriageOption(id: "g2653", label: "Clothing", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g2653-q", question: "Select:", options: [
                        TriageOption(id: "g2654", label: "Scavenging and deploying bleach to actively combat hype", icon: "cross.case.fill", destination: .technique("tools-encyclopedia-scavenge-bleach-hyperthermia")),
                        TriageOption(id: "g2655", label: "Scavenging and deploying clothing to actively combat ag", icon: "cross.case.fill", destination: .technique("tools-encyclopedia-scavenge-clothing-rags-aggressive")),
                        TriageOption(id: "g2656", label: "Scavenging and deploying clothing to actively combat ci", icon: "cross.case.fill", destination: .technique("tools-encyclopedia-scavenge-clothing-rags-civil")),
                        TriageOption(id: "g2657", label: "Scavenging and deploying clothing to actively combat co", icon: "water.waves", destination: .technique("tools-encyclopedia-scavenge-clothing-rags-contaminated")),
                        TriageOption(id: "g2658", label: "Scavenging and deploying clothing to actively combat st", icon: "cross.case.fill", destination: .technique("tools-encyclopedia-scavenge-clothing-rags-structural"))
                    ])
                )),
                TriageOption(id: "g2659", label: "Bleach", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g2659-q", question: "Select:", options: [
                        TriageOption(id: "g2660", label: "Differentiating ballistic protection from visual hiding", icon: "cross.case.fill", destination: .technique("tools-cover-vs-concealment")),
                        TriageOption(id: "g2661", label: "Scavenging and deploying bleach to actively combat civi", icon: "cross.case.fill", destination: .technique("tools-encyclopedia-scavenge-bleach-civil")),
                        TriageOption(id: "g2662", label: "Scavenging and deploying bleach to actively combat cont", icon: "water.waves", destination: .technique("tools-encyclopedia-scavenge-bleach-contaminated"))
                    ])
                ))
                ])
            )),

            TriageOption(id: "g2663", label: "Visual Signals", icon: "antenna.radiowaves.left.and.right", destination: .nextQuestion(
                TriageNode(id: "g2663-q", question: "What specifically?", options: [
                TriageOption(id: "g2664", label: "Search", icon: "water.waves", destination: .nextQuestion(
                    TriageNode(id: "g2664-q", question: "Select:", options: [
                        TriageOption(id: "g2665", label: "Indicate direction of travel for search teams", icon: "flame.fill", destination: .technique("rescue-fire-arrow-signal")),
                        TriageOption(id: "g2666", label: "Building visible signals for aerial search", icon: "ant.fill", destination: .technique("rescue-signal-panel-construction")),
                        TriageOption(id: "g2667", label: "Standard symbols recognized by search aircraft worldwid", icon: "water.waves", destination: .technique("rescue-ground-to-air-signals")),
                        TriageOption(id: "g2668", label: "Activating a Search and Rescue Transponder to paint you", icon: "antenna.radiowaves.left.and.right", destination: .technique("rescue-signal-sart-operation")),
                        TriageOption(id: "g2669", label: "Staining the ocean neon green for search planes", icon: "brain.fill", destination: .technique("rescue-sea-dye"))
                    ])
                )),
                TriageOption(id: "g2670", label: "Chemlight", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g2670-q", question: "Select:", options: [
                        TriageOption(id: "g2671", label: "Deploying a chemlight buzzsaw effectively in a alpine r", icon: "list.bullet.clipboard.fill", destination: .technique("rescue-encyclopedia-signal-alpine-ridgeline-chemlight-buzzsaw")),
                        TriageOption(id: "g2672", label: "Deploying a chemlight buzzsaw effectively in a arctic t", icon: "list.bullet.clipboard.fill", destination: .technique("rescue-encyclopedia-signal-arctic-tundra-chemlight-buzzsaw")),
                        TriageOption(id: "g2673", label: "Deploying a chemlight buzzsaw effectively in a dense co", icon: "list.bullet.clipboard.fill", destination: .technique("rescue-encyclopedia-signal-dense-coniferous-forest-chemlight-buzzsaw")),
                        TriageOption(id: "g2674", label: "Deploying a chemlight buzzsaw effectively in a jungle c", icon: "list.bullet.clipboard.fill", destination: .technique("rescue-encyclopedia-signal-jungle-canopy-chemlight-buzzsaw")),
                        TriageOption(id: "g2675", label: "Deploying a chemlight buzzsaw effectively in a open des", icon: "list.bullet.clipboard.fill", destination: .technique("rescue-encyclopedia-signal-open-desert-chemlight-buzzsaw"))
                    ])
                )),
                TriageOption(id: "g2676", label: "Trenching", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g2676-q", question: "Select:", options: [
                        TriageOption(id: "g2677", label: "Deploying a shadow trenching effectively in a alpine ri", icon: "list.bullet.clipboard.fill", destination: .technique("rescue-encyclopedia-signal-alpine-ridgeline-shadow-trenching")),
                        TriageOption(id: "g2678", label: "Deploying a shadow trenching effectively in a arctic tu", icon: "list.bullet.clipboard.fill", destination: .technique("rescue-encyclopedia-signal-arctic-tundra-shadow-trenching")),
                        TriageOption(id: "g2679", label: "Deploying a shadow trenching effectively in a dense con", icon: "list.bullet.clipboard.fill", destination: .technique("rescue-encyclopedia-signal-dense-coniferous-forest-shadow-trenching")),
                        TriageOption(id: "g2680", label: "Deploying a shadow trenching effectively in a jungle ca", icon: "list.bullet.clipboard.fill", destination: .technique("rescue-encyclopedia-signal-jungle-canopy-shadow-trenching")),
                        TriageOption(id: "g2681", label: "Deploying a shadow trenching effectively in a open dese", icon: "list.bullet.clipboard.fill", destination: .technique("rescue-encyclopedia-signal-open-desert-shadow-trenching"))
                    ])
                )),
                TriageOption(id: "g2682", label: "Aircraft", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g2682-q", question: "Select:", options: [
                        TriageOption(id: "g2683", label: "Use body positions to communicate with aircraft", icon: "antenna.radiowaves.left.and.right", destination: .technique("rescue-body-signals")),
                        TriageOption(id: "g2684", label: "Using high-visibility VS-17 marker panels to flag down ", icon: "antenna.radiowaves.left.and.right", destination: .technique("rescue-signal-ground-to-air-panel")),
                        TriageOption(id: "g2685", label: "Directing aircraft toward your exact position or safe l", icon: "antenna.radiowaves.left.and.right", destination: .technique("rescue-sere-vector-signaling")),
                        TriageOption(id: "g2686", label: "Preparing rapid-ignition night signals", icon: "flame.fill", destination: .technique("rescue-sere-night-pyrotechnics")),
                        TriageOption(id: "g2687", label: "Pre-built fire platform ready for instant ignition when", icon: "flame.fill", destination: .technique("rescue-signal-fire-platform"))
                    ])
                )),
                TriageOption(id: "g2688", label: "Shape", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g2688-q", question: "Select:", options: [
                        TriageOption(id: "g2689", label: "Create standard ground-to-air signal markers", icon: "antenna.radiowaves.left.and.right", destination: .technique("rescue-attention-panel")),
                        TriageOption(id: "g2690", label: "Deploying ground-to-air panel (v-shape) from within a D", icon: "cross.case.fill", destination: .technique("rescue-encyclopedia-signal-ground-to-air-deep")),
                        TriageOption(id: "g2691", label: "Deploying ground-to-air panel (v-shape) from within a H", icon: "cross.case.fill", destination: .technique("rescue-encyclopedia-signal-ground-to-air-high")),
                        TriageOption(id: "g2692", label: "Deploying ground-to-air panel (v-shape) from within a O", icon: "cross.case.fill", destination: .technique("rescue-encyclopedia-signal-ground-to-air-open"))
                    ])
                )),
                TriageOption(id: "g2693", label: "Vehicle", icon: "car.fill", destination: .nextQuestion(
                    TriageNode(id: "g2693-q", question: "Select:", options: [
                        TriageOption(id: "g2694", label: "Arrange clothing on the ground as visual markers", icon: "antenna.radiowaves.left.and.right", destination: .technique("rescue-clothing-signals")),
                        TriageOption(id: "g2695", label: "Signal rescuers using light sources at night", icon: "link", destination: .technique("rescue-night-light-signals")),
                        TriageOption(id: "g2696", label: "Signal using mirrors, glass, and shiny objects", icon: "antenna.radiowaves.left.and.right", destination: .technique("rescue-reflective-signal")),
                        TriageOption(id: "g2697", label: "Create thick black smoke from burning rubber", icon: "flame.fill", destination: .technique("rescue-tire-fire-smoke")),
                        TriageOption(id: "g2698", label: "Use a disabled vehicle as a rescue beacon", icon: "antenna.radiowaves.left.and.right", destination: .technique("rescue-vehicle-signal-alt"))
                    ])
                )),
                TriageOption(id: "g2699", label: "Fire", icon: "flame.fill", destination: .nextQuestion(
                    TriageNode(id: "g2699-q", question: "Select:", options: [
                        TriageOption(id: "g2700", label: "Launching a 30,000 candela meteor to attract ships", icon: "list.bullet.clipboard.fill", destination: .technique("rescue-aerial-flare")),
                        TriageOption(id: "g2701", label: "How to deploy an Emergency Position Indicating Radio Be", icon: "antenna.radiowaves.left.and.right", destination: .technique("rescue-signal-epirb-activation")),
                        TriageOption(id: "g2702", label: "Writing massive letters to communicate with searchers", icon: "ant.fill", destination: .technique("rescue-ground-air-symbols")),
                        TriageOption(id: "g2703", label: "Ensuring your Personal Locator Beacon is tied to your i", icon: "antenna.radiowaves.left.and.right", destination: .technique("rescue-signal-plb-registration")),
                        TriageOption(id: "g2704", label: "Build the international three-fire distress signal", icon: "flame.fill", destination: .technique("rescue-sos-signal-fire"))
                    ])
                )),
                TriageOption(id: "g2705", label: "Distress", icon: "brain.head.profile", destination: .nextQuestion(
                    TriageNode(id: "g2705-q", question: "Select:", options: [
                        TriageOption(id: "g2706", label: "Activating Digital Selective Calling to broadcast your ", icon: "antenna.radiowaves.left.and.right", destination: .technique("rescue-signal-dsc-distress")),
                        TriageOption(id: "g2707", label: "Understanding why SOLAS flares shoot higher and burn lo", icon: "flame.fill", destination: .technique("rescue-signal-flares-solas-vs-coast-guard")),
                        TriageOption(id: "g2708", label: "Using the aiming hole in a glass mirror to flash ships ", icon: "link", destination: .technique("rescue-signal-signal-mirror-heliograph")),
                        TriageOption(id: "g2709", label: "Laying out a giant fluorescent orange 'V' sheet on the ", icon: "antenna.radiowaves.left.and.right", destination: .technique("rescue-signal-v-sheet-deployment")),
                        TriageOption(id: "g2710", label: "The international hailing and distress frequency. How t", icon: "antenna.radiowaves.left.and.right", destination: .technique("rescue-signal-vhf-channel-16"))
                    ])
                )),
                TriageOption(id: "g2711", label: "Distress (2)", icon: "brain.head.profile", destination: .nextQuestion(
                    TriageNode(id: "g2711-q", question: "Select:", options: [
                        TriageOption(id: "g2712", label: "Deploying neon dye in an oceanic grid pattern.", icon: "antenna.radiowaves.left.and.right", destination: .technique("rescue-signal-dye-marker-strategies")),
                        TriageOption(id: "g2713", label: "Hoisting metallic shapes up a mast to reflect radar wav", icon: "ant.fill", destination: .technique("rescue-signal-radar-reflectors")),
                        TriageOption(id: "g2714", label: "Using orange smoke for daytime pinpointing and wind dir", icon: "cloud.fill", destination: .technique("rescue-signal-smoke-canisters")),
                        TriageOption(id: "g2715", label: "5 short horn blasts = Danger. Continuous sounding = Dis", icon: "antenna.radiowaves.left.and.right", destination: .technique("rescue-signal-sound-signals")),
                        TriageOption(id: "g2716", label: "Attaching auto-water-activated high-intensity strobes t", icon: "antenna.radiowaves.left.and.right", destination: .technique("rescue-signal-strobe-lights"))
                    ])
                )),
                TriageOption(id: "g2717", label: "Distress (3)", icon: "brain.head.profile", destination: .nextQuestion(
                    TriageNode(id: "g2717-q", question: "Select:", options: [
                        TriageOption(id: "g2718", label: "Slowly and repeatedly raising and lowering arms outstre", icon: "antenna.radiowaves.left.and.right", destination: .technique("rescue-signal-arm-signals")),
                        TriageOption(id: "g2719", label: "Burning a tar barrel (or oily rags in a bucket) on the ", icon: "flame.fill", destination: .technique("rescue-signal-fire-on-deck")),
                        TriageOption(id: "g2720", label: "Flying the national flag upside down as a universal sig", icon: "antenna.radiowaves.left.and.right", destination: .technique("rescue-signal-inverted-ensign")),
                        TriageOption(id: "g2721", label: "Three short, three long, three short. Pause. Repeat. ( ", icon: "link", destination: .technique("rescue-signal-sos-flashlight")),
                        TriageOption(id: "g2722", label: "Three distinct blasts, repeated indefinitely. The unive", icon: "antenna.radiowaves.left.and.right", destination: .technique("rescue-signal-whistle-blasts"))
                    ])
                )),
                TriageOption(id: "g2723", label: "Jungle", icon: "leaf.fill", destination: .nextQuestion(
                    TriageNode(id: "g2723-q", question: "Select:", options: [
                        TriageOption(id: "g2724", label: "Standardized whistle patterns for distress and location", icon: "antenna.radiowaves.left.and.right", destination: .technique("rescue-whistle-signals")),
                        TriageOption(id: "g2725", label: "Securing all loose gear, putting on a helmet, and waiti", icon: "antenna.radiowaves.left.and.right", destination: .technique("rescue-signal-helicopter-hoist-prep")),
                        TriageOption(id: "g2726", label: "Preparing a safe landing zone", icon: "cross.case.fill", destination: .technique("rescue-helicopter-lz-marking")),
                        TriageOption(id: "g2727", label: "Deploying a signal mirror effectively in a jungle canop", icon: "list.bullet.clipboard.fill", destination: .technique("rescue-encyclopedia-signal-jungle-canopy-signal-mirror-heliograph")),
                        TriageOption(id: "g2728", label: "Deploying a smoke effectively in a jungle canopy enviro", icon: "list.bullet.clipboard.fill", destination: .technique("rescue-encyclopedia-signal-jungle-canopy-smoke-green-boughs"))
                    ])
                )),
                TriageOption(id: "g2729", label: "Jungle (2)", icon: "leaf.fill", destination: .nextQuestion(
                    TriageNode(id: "g2729-q", question: "Select:", options: [
                        TriageOption(id: "g2730", label: "Deploying a flares effectively in a jungle canopy envir", icon: "list.bullet.clipboard.fill", destination: .technique("rescue-encyclopedia-signal-jungle-canopy-flares")),
                        TriageOption(id: "g2731", label: "Deploying a signal mirror effectively in a open desert ", icon: "list.bullet.clipboard.fill", destination: .technique("rescue-encyclopedia-signal-open-desert-signal-mirror-heliograph")),
                        TriageOption(id: "g2732", label: "Deploying a smoke effectively in a open desert environm", icon: "list.bullet.clipboard.fill", destination: .technique("rescue-encyclopedia-signal-open-desert-smoke-green-boughs")),
                        TriageOption(id: "g2733", label: "Deploying a strobe light effectively in a jungle canopy", icon: "list.bullet.clipboard.fill", destination: .technique("rescue-encyclopedia-signal-jungle-canopy-strobe-light")),
                        TriageOption(id: "g2734", label: "Deploying a vs-17 panel effectively in a jungle canopy ", icon: "list.bullet.clipboard.fill", destination: .technique("rescue-encyclopedia-signal-jungle-canopy-vs-17-panel"))
                    ])
                )),
                TriageOption(id: "g2735", label: "Open", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g2735-q", question: "Select:", options: [
                        TriageOption(id: "g2736", label: "Deploying a flares effectively in a open desert environ", icon: "list.bullet.clipboard.fill", destination: .technique("rescue-encyclopedia-signal-open-desert-flares")),
                        TriageOption(id: "g2737", label: "Deploying a signal mirror effectively in a arctic tundr", icon: "list.bullet.clipboard.fill", destination: .technique("rescue-encyclopedia-signal-arctic-tundra-signal-mirror-heliograph")),
                        TriageOption(id: "g2738", label: "Deploying a smoke effectively in a arctic tundra enviro", icon: "list.bullet.clipboard.fill", destination: .technique("rescue-encyclopedia-signal-arctic-tundra-smoke-green-boughs")),
                        TriageOption(id: "g2739", label: "Deploying a strobe light effectively in a open desert e", icon: "list.bullet.clipboard.fill", destination: .technique("rescue-encyclopedia-signal-open-desert-strobe-light")),
                        TriageOption(id: "g2740", label: "Deploying a vs-17 panel effectively in a open desert en", icon: "list.bullet.clipboard.fill", destination: .technique("rescue-encyclopedia-signal-open-desert-vs-17-panel"))
                    ])
                )),
                TriageOption(id: "g2741", label: "Arctic", icon: "snowflake", destination: .nextQuestion(
                    TriageNode(id: "g2741-q", question: "Select:", options: [
                        TriageOption(id: "g2742", label: "Deploying a flares effectively in a arctic tundra envir", icon: "list.bullet.clipboard.fill", destination: .technique("rescue-encyclopedia-signal-arctic-tundra-flares")),
                        TriageOption(id: "g2743", label: "Deploying a signal mirror effectively in a alpine ridge", icon: "list.bullet.clipboard.fill", destination: .technique("rescue-encyclopedia-signal-alpine-ridgeline-signal-mirror-heliograph")),
                        TriageOption(id: "g2744", label: "Deploying a smoke effectively in a alpine ridgeline env", icon: "list.bullet.clipboard.fill", destination: .technique("rescue-encyclopedia-signal-alpine-ridgeline-smoke-green-boughs")),
                        TriageOption(id: "g2745", label: "Deploying a strobe light effectively in a arctic tundra", icon: "list.bullet.clipboard.fill", destination: .technique("rescue-encyclopedia-signal-arctic-tundra-strobe-light")),
                        TriageOption(id: "g2746", label: "Deploying a vs-17 panel effectively in a arctic tundra ", icon: "list.bullet.clipboard.fill", destination: .technique("rescue-encyclopedia-signal-arctic-tundra-vs-17-panel"))
                    ])
                )),
                TriageOption(id: "g2747", label: "Alpine", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g2747-q", question: "Select:", options: [
                        TriageOption(id: "g2748", label: "Deploying a flares effectively in a alpine ridgeline en", icon: "list.bullet.clipboard.fill", destination: .technique("rescue-encyclopedia-signal-alpine-ridgeline-flares")),
                        TriageOption(id: "g2749", label: "Deploying a signal mirror effectively in a dense conife", icon: "list.bullet.clipboard.fill", destination: .technique("rescue-encyclopedia-signal-dense-coniferous-forest-signal-mirror-heliograph")),
                        TriageOption(id: "g2750", label: "Deploying a smoke effectively in a dense coniferous for", icon: "list.bullet.clipboard.fill", destination: .technique("rescue-encyclopedia-signal-dense-coniferous-forest-smoke-green-boughs")),
                        TriageOption(id: "g2751", label: "Deploying a strobe light effectively in a alpine ridgel", icon: "list.bullet.clipboard.fill", destination: .technique("rescue-encyclopedia-signal-alpine-ridgeline-strobe-light")),
                        TriageOption(id: "g2752", label: "Deploying a vs-17 panel effectively in a alpine ridgeli", icon: "list.bullet.clipboard.fill", destination: .technique("rescue-encyclopedia-signal-alpine-ridgeline-vs-17-panel"))
                    ])
                )),
                TriageOption(id: "g2753", label: "Dense", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g2753-q", question: "Select:", options: [
                        TriageOption(id: "g2754", label: "Deploying a flares effectively in a dense coniferous fo", icon: "list.bullet.clipboard.fill", destination: .technique("rescue-encyclopedia-signal-dense-coniferous-forest-flares")),
                        TriageOption(id: "g2755", label: "Deploying signal fire (smoke) from within a Deep to max", icon: "flame.fill", destination: .technique("rescue-encyclopedia-signal-signal-deep")),
                        TriageOption(id: "g2756", label: "Deploying signal fire (smoke) from within a Dense to ma", icon: "flame.fill", destination: .technique("rescue-encyclopedia-signal-signal-dense")),
                        TriageOption(id: "g2757", label: "Deploying a strobe light effectively in a dense conifer", icon: "list.bullet.clipboard.fill", destination: .technique("rescue-encyclopedia-signal-dense-coniferous-forest-strobe-light")),
                        TriageOption(id: "g2758", label: "Deploying a vs-17 panel effectively in a dense conifero", icon: "list.bullet.clipboard.fill", destination: .technique("rescue-encyclopedia-signal-dense-coniferous-forest-vs-17-panel"))
                    ])
                )),
                TriageOption(id: "g2759", label: "Open (2)", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g2759-q", question: "Select:", options: [
                        TriageOption(id: "g2760", label: "Deploying signal fire (smoke) from within a High to max", icon: "flame.fill", destination: .technique("rescue-encyclopedia-signal-signal-high")),
                        TriageOption(id: "g2761", label: "Deploying signal fire (flame) from within a Open to max", icon: "flame.fill", destination: .technique("rescue-encyclopedia-signal-signal-open")),
                        TriageOption(id: "g2762", label: "Deploying whistle blast from within a Deep to maximize ", icon: "cross.case.fill", destination: .technique("rescue-encyclopedia-signal-whistle-deep")),
                        TriageOption(id: "g2763", label: "Deploying whistle blast from within a Dense to maximize", icon: "cross.case.fill", destination: .technique("rescue-encyclopedia-signal-whistle-dense")),
                        TriageOption(id: "g2764", label: "Deploying whistle blast from within a Open to maximize ", icon: "cross.case.fill", destination: .technique("rescue-encyclopedia-signal-whistle-open"))
                    ])
                )),
                TriageOption(id: "g2765", label: "Strobe", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g2765-q", question: "Select:", options: [
                        TriageOption(id: "g2766", label: "Deploying strobe light from within a Deep to maximize v", icon: "cross.case.fill", destination: .technique("rescue-encyclopedia-signal-strobe-deep")),
                        TriageOption(id: "g2767", label: "Deploying strobe light from within a Dense to maximize ", icon: "cross.case.fill", destination: .technique("rescue-encyclopedia-signal-strobe-dense")),
                        TriageOption(id: "g2768", label: "Deploying strobe light from within a High to maximize v", icon: "cross.case.fill", destination: .technique("rescue-encyclopedia-signal-strobe-high")),
                        TriageOption(id: "g2769", label: "Deploying strobe light from within a Open to maximize v", icon: "cross.case.fill", destination: .technique("rescue-encyclopedia-signal-strobe-open")),
                        TriageOption(id: "g2770", label: "Deploying whistle blast from within a High to maximize ", icon: "cross.case.fill", destination: .technique("rescue-encyclopedia-signal-whistle-high"))
                    ])
                ))
                ])
            )),

            TriageOption(id: "g2771", label: "Water Rescue", icon: "figure.walk.motion", destination: .nextQuestion(
                TriageNode(id: "g2771-q", question: "What specifically?", options: [
                TriageOption(id: "g2772", label: "Mirror", icon: "antenna.radiowaves.left.and.right", destination: .nextQuestion(
                    TriageNode(id: "g2772-q", question: "Select:", options: [
                        TriageOption(id: "g2773", label: "Deploying Heliograph (Mirror) while clinging to cooler ", icon: "antenna.radiowaves.left.and.right", destination: .technique("rescue-encyclopedia-adrift-cooler-heliograph")),
                        TriageOption(id: "g2774", label: "Deploying Heliograph (Mirror) while clinging to debris ", icon: "antenna.radiowaves.left.and.right", destination: .technique("rescue-encyclopedia-adrift-debris-heliograph")),
                        TriageOption(id: "g2775", label: "Deploying Heliograph (Mirror) while clinging to empty j", icon: "antenna.radiowaves.left.and.right", destination: .technique("rescue-encyclopedia-adrift-empty-heliograph")),
                        TriageOption(id: "g2776", label: "Deploying Heliograph (Mirror) while clinging to improvi", icon: "antenna.radiowaves.left.and.right", destination: .technique("rescue-encyclopedia-adrift-improvised-heliograph")),
                        TriageOption(id: "g2777", label: "Deploying Heliograph (Mirror) while clinging to life ra", icon: "antenna.radiowaves.left.and.right", destination: .technique("rescue-encyclopedia-adrift-life-heliograph"))
                    ])
                )),
                TriageOption(id: "g2778", label: "Meteor", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g2778-q", question: "Select:", options: [
                        TriageOption(id: "g2779", label: "Deploying Flares (Meteor) while clinging to cooler in o", icon: "antenna.radiowaves.left.and.right", destination: .technique("rescue-encyclopedia-adrift-cooler-flares")),
                        TriageOption(id: "g2780", label: "Deploying Flares (Meteor) while clinging to debris fiel", icon: "antenna.radiowaves.left.and.right", destination: .technique("rescue-encyclopedia-adrift-debris-flares")),
                        TriageOption(id: "g2781", label: "Deploying Flares (Meteor) while clinging to empty jugs ", icon: "antenna.radiowaves.left.and.right", destination: .technique("rescue-encyclopedia-adrift-empty-flares")),
                        TriageOption(id: "g2782", label: "Deploying Flares (Meteor) while clinging to improvised ", icon: "antenna.radiowaves.left.and.right", destination: .technique("rescue-encyclopedia-adrift-improvised-flares")),
                        TriageOption(id: "g2783", label: "Deploying Flares (Meteor) while clinging to life raft c", icon: "antenna.radiowaves.left.and.right", destination: .technique("rescue-encyclopedia-adrift-life-flares"))
                    ])
                )),
                TriageOption(id: "g2784", label: "Movement", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g2784-q", question: "Select:", options: [
                        TriageOption(id: "g2785", label: "Deploying Splash/Movement Disturbance while clinging to", icon: "link", destination: .technique("rescue-encyclopedia-adrift-cooler-splash/movement")),
                        TriageOption(id: "g2786", label: "Deploying Splash/Movement Disturbance while clinging to", icon: "link", destination: .technique("rescue-encyclopedia-adrift-debris-splash/movement")),
                        TriageOption(id: "g2787", label: "Deploying Splash/Movement Disturbance while clinging to", icon: "link", destination: .technique("rescue-encyclopedia-adrift-empty-splash/movement")),
                        TriageOption(id: "g2788", label: "Deploying Splash/Movement Disturbance while clinging to", icon: "link", destination: .technique("rescue-encyclopedia-adrift-improvised-splash/movement")),
                        TriageOption(id: "g2789", label: "Deploying Splash/Movement Disturbance while clinging to", icon: "link", destination: .technique("rescue-encyclopedia-adrift-life-splash/movement"))
                    ])
                )),
                TriageOption(id: "g2790", label: "Rescue", icon: "figure.walk.motion", destination: .nextQuestion(
                    TriageNode(id: "g2790-q", question: "Select:", options: [
                        TriageOption(id: "g2791", label: "Rescue someone in the water without drowning yourself", icon: "figure.walk.motion", destination: .technique("rescue-water-evacuation")),
                        TriageOption(id: "g2792", label: "Upstream pendulum and live-bait rescue", icon: "figure.walk.motion", destination: .technique("rescue-swift-water-throw-technique")),
                        TriageOption(id: "g2793", label: "Create visible markers on water surface for air rescue", icon: "figure.walk.motion", destination: .technique("rescue-water-dye-marker")),
                        TriageOption(id: "g2794", label: "Rescue a drowning person without becoming a victim your", icon: "figure.walk.motion", destination: .technique("rescue-water-rescue-reach"))
                    ])
                )),
                TriageOption(id: "g2795", label: "Marker", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g2795-q", question: "Select:", options: [
                        TriageOption(id: "g2796", label: "Deploying Sea Dye Marker while clinging to cooler in op", icon: "water.waves", destination: .technique("rescue-encyclopedia-adrift-cooler-sea")),
                        TriageOption(id: "g2797", label: "Deploying Sea Dye Marker while clinging to debris field", icon: "water.waves", destination: .technique("rescue-encyclopedia-adrift-debris-sea")),
                        TriageOption(id: "g2798", label: "Deploying Sea Dye Marker while clinging to empty jugs i", icon: "water.waves", destination: .technique("rescue-encyclopedia-adrift-empty-sea")),
                        TriageOption(id: "g2799", label: "Deploying Sea Dye Marker while clinging to improvised d", icon: "water.waves", destination: .technique("rescue-encyclopedia-adrift-improvised-sea")),
                        TriageOption(id: "g2800", label: "Deploying Sea Dye Marker while clinging to life raft ca", icon: "water.waves", destination: .technique("rescue-encyclopedia-adrift-life-sea"))
                    ])
                )),
                TriageOption(id: "g2801", label: "Flotation", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g2801-q", question: "Select:", options: [
                        TriageOption(id: "g2802", label: "Naval Special Warfare protocol for conserving energy in", icon: "ant.fill", destination: .technique("rescue-navy-drownproofing")),
                        TriageOption(id: "g2803", label: "Delaying severe hypothermia in freezing water.", icon: "bolt.fill", destination: .technique("rescue-help-huddle-position")),
                        TriageOption(id: "g2804", label: "Turn ordinary items into life-saving floats", icon: "link", destination: .technique("rescue-flotation-improvised")),
                        TriageOption(id: "g2805", label: "Inflating trousers to act as a life preserver.", icon: "flame.fill", destination: .technique("rescue-pants-flotation"))
                    ])
                ))
                ])
            )),

            TriageOption(id: "g2806", label: "Weapons", icon: "cross.case.fill", destination: .nextQuestion(
                TriageNode(id: "g2806-q", question: "What specifically?", options: [
                TriageOption(id: "g2807", label: "Long", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g2807-q", question: "Select:", options: [
                        TriageOption(id: "g2808", label: "Tactical deployment of a handgun against a long range e", icon: "eye.slash.fill", destination: .technique("tools-encyclopedia-defense-handgun-long")),
                        TriageOption(id: "g2809", label: "Tactical deployment of a machete against a long range e", icon: "eye.slash.fill", destination: .technique("tools-encyclopedia-defense-machete-hatchet-long")),
                        TriageOption(id: "g2810", label: "Tactical deployment of a rifle against a long range eva", icon: "eye.slash.fill", destination: .technique("tools-encyclopedia-defense-rifle-long")),
                        TriageOption(id: "g2811", label: "Build a ranged weapon from cordage and a pouch", icon: "leaf.fill", destination: .technique("tools-sling-weapon")),
                        TriageOption(id: "g2812", label: "Build a barbed spear that holds in the prey", icon: "bandage.fill", destination: .technique("tools-toggle-harpoon"))
                    ])
                )),
                TriageOption(id: "g2813", label: "Birds", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g2813-q", question: "Select:", options: [
                        TriageOption(id: "g2814", label: "Fabricating and employing a atlatl specifically for har", icon: "ant.fill", destination: .technique("tools-encyclopedia-weapon-atlatl-small")),
                        TriageOption(id: "g2815", label: "Fabricating and employing a blowgun specifically for ha", icon: "ant.fill", destination: .technique("tools-encyclopedia-weapon-blowgun-small")),
                        TriageOption(id: "g2816", label: "Build a throwing weapon for catching birds and small ga", icon: "cross.case.fill", destination: .technique("tools-bola")),
                        TriageOption(id: "g2817", label: "Fabricating and employing a sling specifically for harv", icon: "ant.fill", destination: .technique("tools-encyclopedia-weapon-sling-small")),
                        TriageOption(id: "g2818", label: "Fabricating and employing a throwing stick specifically", icon: "ant.fill", destination: .technique("tools-encyclopedia-weapon-throwing-small"))
                    ])
                )),
                TriageOption(id: "g2819", label: "Sling", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g2819-q", question: "Select:", options: [
                        TriageOption(id: "g2820", label: "Fabricating and employing a sling specifically for harv", icon: "ant.fill", destination: .technique("tools-encyclopedia-weapon-sling-fish/amphibians")),
                        TriageOption(id: "g2821", label: "Fabricating and employing a sling specifically for harv", icon: "ant.fill", destination: .technique("tools-encyclopedia-weapon-sling-medium")),
                        TriageOption(id: "g2822", label: "Fabricating and employing a sling specifically for harv", icon: "ant.fill", destination: .technique("tools-encyclopedia-weapon-sling-waterfowl"))
                    ])
                )),
                TriageOption(id: "g2823", label: "Atlatl", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g2823-q", question: "Select:", options: [
                        TriageOption(id: "g2824", label: "Multiplying throwing force via mechanical leverage.", icon: "cross.case.fill", destination: .technique("tools-weapon-atlatl-fabrication")),
                        TriageOption(id: "g2825", label: "Fabricating and employing a atlatl specifically for har", icon: "ant.fill", destination: .technique("tools-encyclopedia-weapon-atlatl-fish/amphibians")),
                        TriageOption(id: "g2826", label: "Fabricating and employing a atlatl specifically for har", icon: "ant.fill", destination: .technique("tools-encyclopedia-weapon-atlatl-medium")),
                        TriageOption(id: "g2827", label: "Fabricating and employing a atlatl specifically for har", icon: "ant.fill", destination: .technique("tools-encyclopedia-weapon-atlatl-waterfowl"))
                    ])
                )),
                TriageOption(id: "g2828", label: "Knife", icon: "scissors", destination: .nextQuestion(
                    TriageNode(id: "g2828-q", question: "Select:", options: [
                        TriageOption(id: "g2829", label: "Tactical deployment of a fixed blade knife against a ar", icon: "scissors", destination: .technique("tools-encyclopedia-defense-fixed-armed")),
                        TriageOption(id: "g2830", label: "Tactical deployment of a fixed blade knife against a ca", icon: "scissors", destination: .technique("tools-encyclopedia-defense-fixed-canine")),
                        TriageOption(id: "g2831", label: "Tactical deployment of a fixed blade knife against a cl", icon: "scissors", destination: .technique("tools-encyclopedia-defense-fixed-close")),
                        TriageOption(id: "g2832", label: "Tactical deployment of a fixed blade knife against a me", icon: "scissors", destination: .technique("tools-encyclopedia-defense-fixed-medium")),
                        TriageOption(id: "g2833", label: "Tactical deployment of a fixed blade knife against a mu", icon: "scissors", destination: .technique("tools-encyclopedia-defense-fixed-multiple"))
                    ])
                )),
                TriageOption(id: "g2834", label: "Handgun", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g2834-q", question: "Select:", options: [
                        TriageOption(id: "g2835", label: "Tactical deployment of a handgun against a canine (dog)", icon: "cross.case.fill", destination: .technique("tools-encyclopedia-defense-handgun-canine")),
                        TriageOption(id: "g2836", label: "Tactical deployment of a handgun against a close quarte", icon: "cross.case.fill", destination: .technique("tools-encyclopedia-defense-handgun-close")),
                        TriageOption(id: "g2837", label: "Tactical deployment of a handgun against a medium range", icon: "cross.case.fill", destination: .technique("tools-encyclopedia-defense-handgun-medium")),
                        TriageOption(id: "g2838", label: "Tactical deployment of a handgun against a multiple att", icon: "cross.case.fill", destination: .technique("tools-encyclopedia-defense-handgun-multiple")),
                        TriageOption(id: "g2839", label: "Non-returning aerodynamic throwing stick.", icon: "scope", destination: .technique("tools-weapon-hunting-boomerang"))
                    ])
                )),
                TriageOption(id: "g2840", label: "Rifle", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g2840-q", question: "Select:", options: [
                        TriageOption(id: "g2841", label: "Tactical deployment of a handgun against a armed assail", icon: "cross.case.fill", destination: .technique("tools-encyclopedia-defense-handgun-armed")),
                        TriageOption(id: "g2842", label: "Tactical deployment of a rifle against a canine (dog) a", icon: "cross.case.fill", destination: .technique("tools-encyclopedia-defense-rifle-canine")),
                        TriageOption(id: "g2843", label: "Tactical deployment of a rifle against a close quarters", icon: "cross.case.fill", destination: .technique("tools-encyclopedia-defense-rifle-close")),
                        TriageOption(id: "g2844", label: "Tactical deployment of a rifle against a medium range (", icon: "cross.case.fill", destination: .technique("tools-encyclopedia-defense-rifle-medium")),
                        TriageOption(id: "g2845", label: "Tactical deployment of a rifle against a multiple attac", icon: "cross.case.fill", destination: .technique("tools-encyclopedia-defense-rifle-multiple"))
                    ])
                )),
                TriageOption(id: "g2846", label: "Shotgun", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g2846-q", question: "Select:", options: [
                        TriageOption(id: "g2847", label: "Tactical deployment of a rifle against a armed assailan", icon: "cross.case.fill", destination: .technique("tools-encyclopedia-defense-rifle-armed")),
                        TriageOption(id: "g2848", label: "Tactical deployment of a shotgun against a canine (dog)", icon: "cross.case.fill", destination: .technique("tools-encyclopedia-defense-shotgun-canine")),
                        TriageOption(id: "g2849", label: "Tactical deployment of a shotgun against a close quarte", icon: "cross.case.fill", destination: .technique("tools-encyclopedia-defense-shotgun-close")),
                        TriageOption(id: "g2850", label: "Tactical deployment of a shotgun against a medium range", icon: "cross.case.fill", destination: .technique("tools-encyclopedia-defense-shotgun-medium")),
                        TriageOption(id: "g2851", label: "Tactical deployment of a shotgun against a multiple att", icon: "cross.case.fill", destination: .technique("tools-encyclopedia-defense-shotgun-multiple"))
                    ])
                )),
                TriageOption(id: "g2852", label: "Club", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g2852-q", question: "Select:", options: [
                        TriageOption(id: "g2853", label: "Tactical deployment of a improvised club against a cani", icon: "cross.case.fill", destination: .technique("tools-encyclopedia-defense-improvised-canine")),
                        TriageOption(id: "g2854", label: "Tactical deployment of a improvised club against a clos", icon: "cross.case.fill", destination: .technique("tools-encyclopedia-defense-improvised-close")),
                        TriageOption(id: "g2855", label: "Tactical deployment of a improvised club against a medi", icon: "cross.case.fill", destination: .technique("tools-encyclopedia-defense-improvised-medium")),
                        TriageOption(id: "g2856", label: "Tactical deployment of a improvised club against a mult", icon: "cross.case.fill", destination: .technique("tools-encyclopedia-defense-improvised-multiple")),
                        TriageOption(id: "g2857", label: "Tactical deployment of a shotgun against a armed assail", icon: "cross.case.fill", destination: .technique("tools-encyclopedia-defense-shotgun-armed"))
                    ])
                )),
                TriageOption(id: "g2858", label: "Machete", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g2858-q", question: "Select:", options: [
                        TriageOption(id: "g2859", label: "Tactical deployment of a improvised club against a arme", icon: "cross.case.fill", destination: .technique("tools-encyclopedia-defense-improvised-armed")),
                        TriageOption(id: "g2860", label: "Tactical deployment of a machete against a canine (dog)", icon: "cross.case.fill", destination: .technique("tools-encyclopedia-defense-machete-hatchet-canine")),
                        TriageOption(id: "g2861", label: "Tactical deployment of a machete against a close quarte", icon: "cross.case.fill", destination: .technique("tools-encyclopedia-defense-machete-hatchet-close")),
                        TriageOption(id: "g2862", label: "Tactical deployment of a machete against a medium range", icon: "cross.case.fill", destination: .technique("tools-encyclopedia-defense-machete-hatchet-medium")),
                        TriageOption(id: "g2863", label: "Tactical deployment of a machete against a multiple att", icon: "cross.case.fill", destination: .technique("tools-encyclopedia-defense-machete-hatchet-multiple"))
                    ])
                )),
                TriageOption(id: "g2864", label: "Pepper", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g2864-q", question: "Select:", options: [
                        TriageOption(id: "g2865", label: "Tactical deployment of a machete against a armed assail", icon: "cross.case.fill", destination: .technique("tools-encyclopedia-defense-machete-hatchet-armed")),
                        TriageOption(id: "g2866", label: "Tactical deployment of a pepper spray against a canine ", icon: "cross.case.fill", destination: .technique("tools-encyclopedia-defense-pepper-canine")),
                        TriageOption(id: "g2867", label: "Tactical deployment of a pepper spray against a close q", icon: "cross.case.fill", destination: .technique("tools-encyclopedia-defense-pepper-close")),
                        TriageOption(id: "g2868", label: "Tactical deployment of a pepper spray against a medium ", icon: "cross.case.fill", destination: .technique("tools-encyclopedia-defense-pepper-medium")),
                        TriageOption(id: "g2869", label: "Tactical deployment of a pepper spray against a multipl", icon: "cross.case.fill", destination: .technique("tools-encyclopedia-defense-pepper-multiple"))
                    ])
                )),
                TriageOption(id: "g2870", label: "Tactical", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g2870-q", question: "Select:", options: [
                        TriageOption(id: "g2871", label: "Tactical deployment of a pepper spray against a armed a", icon: "cross.case.fill", destination: .technique("tools-encyclopedia-defense-pepper-armed")),
                        TriageOption(id: "g2872", label: "Tactical deployment of a tactical flashlight against a ", icon: "link", destination: .technique("tools-encyclopedia-defense-tactical-canine")),
                        TriageOption(id: "g2873", label: "Tactical deployment of a tactical flashlight against a ", icon: "link", destination: .technique("tools-encyclopedia-defense-tactical-close")),
                        TriageOption(id: "g2874", label: "Tactical deployment of a tactical flashlight against a ", icon: "link", destination: .technique("tools-encyclopedia-defense-tactical-medium")),
                        TriageOption(id: "g2875", label: "Tactical deployment of a tactical flashlight against a ", icon: "link", destination: .technique("tools-encyclopedia-defense-tactical-multiple"))
                    ])
                )),
                TriageOption(id: "g2876", label: "Spear", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g2876-q", question: "Select:", options: [
                        TriageOption(id: "g2877", label: "Fabricating and employing a spear specifically for harv", icon: "ant.fill", destination: .technique("tools-encyclopedia-weapon-spear-fish/amphibians")),
                        TriageOption(id: "g2878", label: "Fabricating and employing a spear specifically for harv", icon: "ant.fill", destination: .technique("tools-encyclopedia-weapon-spear-medium")),
                        TriageOption(id: "g2879", label: "Fabricating and employing a spear specifically for harv", icon: "ant.fill", destination: .technique("tools-encyclopedia-weapon-spear-small")),
                        TriageOption(id: "g2880", label: "Fabricating and employing a spear specifically for harv", icon: "ant.fill", destination: .technique("tools-encyclopedia-weapon-spear-waterfowl")),
                        TriageOption(id: "g2881", label: "Tactical deployment of a tactical flashlight against a ", icon: "link", destination: .technique("tools-encyclopedia-defense-tactical-armed"))
                    ])
                )),
                TriageOption(id: "g2882", label: "Bolas", icon: "cross.case.fill", destination: .nextQuestion(
                    TriageNode(id: "g2882-q", question: "Select:", options: [
                        TriageOption(id: "g2883", label: "Fabricating and employing a bolas specifically for harv", icon: "ant.fill", destination: .technique("tools-encyclopedia-weapon-bolas-medium")),
                        TriageOption(id: "g2884", label: "Fabricating and employing a bolas specifically for harv", icon: "ant.fill", destination: .technique("tools-encyclopedia-weapon-bolas-small")),
                        TriageOption(id: "g2885", label: "Fabricating and employing a bolas specifically for harv", icon: "ant.fill", destination: .technique("tools-encyclopedia-weapon-bolas-waterfowl")),
                        TriageOption(id: "g2886", label: "Fabricating and employing a throwing stick specifically", icon: "ant.fill", destination: .technique("tools-encyclopedia-weapon-throwing-medium")),
                        TriageOption(id: "g2887", label: "Fabricating and employing a throwing stick specifically", icon: "ant.fill", destination: .technique("tools-encyclopedia-weapon-throwing-waterfowl"))
                    ])
                ))
                ])
            )),
        ])
    }

}
