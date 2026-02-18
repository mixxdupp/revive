import Foundation

struct TechniqueIconMapper {
    static func icon(for techniqueId: String) -> String? {
        // Map specific technique IDs to SF Symbols
        switch techniqueId {
        
        // FIRE
        case "fire-bowdrill": return "flame"
        case "fire-magnifying": return "magnifyingglass.circle.fill"
        case "fire-ferrorod": return "sparkles"
        case "fire-teepee": return "cone.fill"
        case "fire-log-cabin": return "square.grid.3x3.fill"
        case "fire-long-fire": return "rectangle.fill"
        case "fire-dakota-hole": return "arrow.down.to.line.compact"
        case "fire-battery": return "battery.100"
        
        // SHELTER
        case "shelter-debris-aframe": return "triangle.fill"
        case "shelter-lean-to": return "arrow.up.right.and.arrow.down.left.rectangle.fill"
        case "shelter-snow-trench": return "rectangle.portrait.and.arrow.right.fill"
        case "shelter-igloo": return "house.fill"
        case "shelter-mylar-wrap": return "sparkle"
        case "shelter-hammock": return "figure.mind.and.body"
        
        // WATER
        case "water-boiling": return "flame"
        case "water-solar-still": return "sun.max.circle.fill"
        case "water-transpiration-bag": return "leaf.circle.fill"
        case "water-charcoal-filter": return "line.3.horizontal.decrease.circle.fill"
        case "water-iodine": return "pills.fill"
        
        // FIRST AID
        case "firstaid-cpr": return "heart.text.square.fill"
        case "firstaid-tourniquet": return "bandage.fill" // or specialized icon
        case "firstaid-pressure-bandage": return "cross.case.fill"
        case "firstaid-hypothermia": return "thermometer.snowflake"
        case "firstaid-burn": return "flame"
        case "firstaid-snakebite": return "ant.fill" // closest to snake?
        
        // NAVIGATION
        case "nav-north-star": return "star.fill"
        case "nav-compass-use": return "location.north.circle.fill"
        case "nav-sun-position": return "sun.max.fill"
        case "nav-stick-shadow": return "guitars.fill" // shadow... stick... maybe clock?
        case "nav-map-reading": return "map.fill"
        
        // FOOD
        case "food-common-edibles": return "leaf.fill"
        case "food-insect-eating": return "ant.fill"
        case "food-fishing-spear": return "arrow.up.left.and.arrow.down.right"
        case "food-trap-deadfall": return "square.and.line.vertical.and.square.fill"
        
        // TOOLS
        case "tools-bow-making": return "arrow.up.right"
        case "tools-stone-axe": return "hammer.fill"
        case "tools-cordage": return "scribble"
        
        // PSYCHOLOGY
        case "psych-box-breathing": return "square.fill"
        case "psych-ooda-loop": return "arrow.triangle.2.circlepath"
        
        // RESCUE
        case "rescue-signal-mirror": return "sparkle"
        case "rescue-whistle": return "speaker.wave.3.fill"
        case "rescue-smoke-signal": return "smoke.fill"
        case "rescue-sos": return "sos.circle.fill"
        
        default: return nil
        }
    }
}
