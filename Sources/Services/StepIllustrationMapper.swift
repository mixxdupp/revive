import SwiftUI

struct StepIllustrationMapper {
    
    /// Returns the most relevant SF Symbol for a given step based on its content.
    static func icon(for step: TechniqueStep, in domain: SurvivalDomain) -> String {
        // 1. Check specific manual overrides first (Critical fixes)
        if let manualIcon = manualOverrides[step.id] {
            return manualIcon
        }
        
        // Normalize text for analysis
        let text = (step.instruction + " " + step.helpDetail + " " + (step.illustrationDescription ?? "")).lowercased()
        let words = Set(text.components(separatedBy: CharacterSet.alphanumerics.inverted).filter { !$0.isEmpty })
        
        // 2. Exact Object Matches (High Confidence Nouns)
        // These are specific physical objects that should almost always have their own icon
        if words.contains("whistle") { return "speaker.wave.3.fill" }
        if words.contains("mirror") || words.contains("reflective") { return "sun.max.circle.fill" }
        if words.contains("phone") || words.contains("mobile") || words.contains("cell") { return "iphone" }
        if words.contains("map") { return "map.fill" }
        if words.contains("compass") { return "safari.fill" }
        if words.contains("battery") { return "battery.100" }
        if words.contains("flashlight") || words.contains("torch") { return "flashlight.on.fill" }
        // 'knife' not always available, scissors suggests cutting tool
        if words.contains("knife") || words.contains("blade") { return "scissors" } 
        // Rope knotting icon
        if words.contains("rope") || words.contains("cord") || words.contains("paracord") { return "figure.stand.line.dotted.figure.stand" }
        
        // 3. Domain-Specific Rules (Context Matters)
        switch domain {
        case .firstAid:
            if words.contains("cpr") || words.contains("compressions") || text.contains("chest compression") { return "heart.fill" }
            if words.contains("breath") || words.contains("breathing") || words.contains("airway") { return "lungs.fill" }
            if words.contains("pulse") || words.contains("check") && words.contains("circulation") { return "waveform.path.ecg" }
            if words.contains("bleed") || words.contains("pressure") { return "drop.fill" }
            if words.contains("wrap") || words.contains("bandage") || words.contains("dress") { return "bandage.fill" }
            if words.contains("splint") || words.contains("immobilize") { return "plank" } // System icon? fallback to 'bandage'
            if words.contains("tourniquet") { return "circles.hexagonpath.fill" } // Abstract tight binding
            if words.contains("check") || words.contains("assess") || words.contains("monitor") { return "eye.fill" }
            if words.contains("shock") { return "bolt.heart.fill" }
            // General first aid fallback
            if words.contains("help") || words.contains("call") { return "phone.fill" }
            
        case .fire:
            if words.contains("drill") || words.contains("spin") || words.contains("friction") { return "flame" }
            if words.contains("spark") || words.contains("strike") { return "sparkles" }
            if words.contains("tinder") || words.contains("kindling") || words.contains("nest") { return "leaf.fill" }
            if words.contains("notch") || words.contains("carve") || words.contains("cut") { return "scissors" }
            if words.contains("blow") || words.contains("oxygen") { return "wind" }
            if words.contains("structure") || words.contains("lay") || words.contains("stack") { return "square.stack.3d.up.fill" }
            
        case .rescue:
            if words.contains("signal") {
                if words.contains("fire") { return "flame" }
                if words.contains("ground") || words.contains("visual") { return "eye.fill" }
                if words.contains("radio") || words.contains("broadcast") { return "antenna.radiowaves.left.and.right" }
                // Default visual signal
                return "hand.wave.fill" 
            }
            if words.contains("sos") { return "exclamationmark.triangle.fill" }
            if words.contains("sound") || words.contains("noise") { return "speaker.wave.3.fill" }
            
        case .shelter:
            if words.contains("dig") || words.contains("snow") || words.contains("pile") { return "hammer.fill" } // Construction
            if words.contains("branch") || words.contains("leaf") || words.contains("foliage") { return "leaf.fill" }
            if words.contains("tarp") || words.contains("cover") || words.contains("roof") { return "tent.fill" }
            if words.contains("bed") || words.contains("insulation") || words.contains("sleep") { return "bed.double.fill" }
            
        case .water:
            if words.contains("boil") || words.contains("heat") { return "flame" }
            if words.contains("filter") || words.contains("strain") { return "line.3.horizontal.decrease.circle" }
            if words.contains("collect") || words.contains("rain") || words.contains("dew") { return "cloud.rain.fill" }
            if words.contains("dig") { return "hammer.fill" }
            
        case .navigation:
            if words.contains("sun") || words.contains("shadow") { return "sun.max.fill" }
            if words.contains("star") || words.contains("north") { return "star.fill" }
            if words.contains("walk") || words.contains("travel") || words.contains("move") { return "figure.walk" }
            if words.contains("landmark") || words.contains("feature") { return "mountain.2.fill" }
            
        case .food:
            // High specificity for Food to avoid "fork.knife" everywhere
            if words.contains("fishing") || words.contains("hook") || words.contains("line") { return "fish.fill" }
            if words.contains("trap") || words.contains("snare") || words.contains("trigger") { return "hare.fill" }
            if words.contains("plant") || words.contains("berry") || words.contains("mushroom") { return "leaf.fill" }
            if words.contains("cook") || words.contains("roast") || words.contains("eat") { return "fork.knife" }
            
        default:
            break
        }
        
        // 4. Global Fallback Actions (Low Priority)
        // Only trigger these if NO domain-specific rule matched
        if words.contains("cut") || words.contains("slice") { return "scissors" }
        if words.contains("tie") || words.contains("knot") { return "lasso" }
        if words.contains("dig") { return "hammer.fill" }
        if words.contains("look") || words.contains("search") || words.contains("find") { return "magnifyingglass" }
        if words.contains("wait") || words.contains("stop") { return "hand.raised.fill" }
        if words.contains("go") || words.contains("run") { return "figure.walk" }
        if words.contains("sleep") || words.contains("rest") { return "bed.double.fill" }
        
        // 5. Domain Default Icons
        switch domain {
        case .fire: return "flame"
        case .water: return "drop.fill"
        case .shelter: return "tent.fill"
        case .food: return "fork.knife"
        case .firstAid: return "cross.case.fill"
        case .navigation: return "location.fill"
        case .rescue: return "antenna.radiowaves.left.and.right"
        case .psychology: return "brain.head.profile"
        case .tools: return "hammer.fill"
        case .environments: return "mountain.2.fill"
        }
    }
    
    // Manual overrides for specific tricky steps
    private static let manualOverrides: [String: String] = [
        "firstaid-cpr-step-3": "heart.fill",      // Compressions
        "firstaid-cpr-step-4": "lungs.fill",      // Breaths
        "firstaid-cpr-step-5": "arrow.triangle.2.circlepath", // Cycle
        "rescue-signal-mirror-step-1": "sun.max.circle.fill",
        "rescue-signal-mirror-step-3": "sun.max.fill"
    ]
    
    /// Returns a default icon for the domain (used as fallback).
    static func defaultIcon(for domain: SurvivalDomain) -> String {
        switch domain {
        case .fire: return "flame"
        case .water: return "drop.fill"
        case .shelter: return "tent.fill"
        case .food: return "fork.knife"
        case .firstAid: return "cross.case.fill"
        case .navigation: return "location.fill"
        case .rescue: return "antenna.radiowaves.left.and.right"
        case .psychology: return "brain.head.profile"
        case .tools: return "hammer.fill"
        case .environments: return "mountain.2.fill"
        }
    }
}
