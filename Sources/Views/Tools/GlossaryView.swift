import SwiftUI

struct GlossaryView: View {
    @ObservedObject var contentDB = ContentDatabase.shared
    @State private var searchText = ""
    @State private var expandedTermID: String?
    @Environment(\.dismiss) var dismiss
    
    var filteredTerms: [GlossaryTerm] {
        if searchText.isEmpty {
            return contentDB.glossaryTerms
        } else {
            return contentDB.glossaryTerms.filter {
                $0.term.localizedCaseInsensitiveContains(searchText) ||
                $0.definition.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    /// Group filtered terms by first letter
    var groupedTerms: [(letter: String, terms: [GlossaryTerm])] {
        let grouped = Dictionary(grouping: filteredTerms) { term -> String in
            let first = term.term.prefix(1).uppercased()
            return first.rangeOfCharacter(from: .letters) != nil ? first : "#"
        }
        return grouped.map { (letter: $0.key, terms: $0.value) }
            .sorted { $0.letter < $1.letter }
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            DesignSystem.backgroundPrimary.edgesIgnoringSafeArea(.all)
            
            ScrollView {
                VStack(spacing: 0) {
                    // Search Bar
                    searchBar
                        .padding(.top, 60)
                        .padding(.bottom, 8)
                    
                    // Term count
                    HStack {
                        Text("\(filteredTerms.count) terms")
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundStyle(DesignSystem.textTertiary)
                        Spacer()
                        if !searchText.isEmpty {
                            Text("Tap to expand")
                                .font(.caption2)
                                .foregroundStyle(DesignSystem.textTertiary)
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 12)
                    
                    // Alphabetical sections
                    LazyVStack(spacing: 0, pinnedViews: .sectionHeaders) {
                        ForEach(groupedTerms, id: \.letter) { group in
                            Section {
                                VStack(spacing: 10) {
                                    ForEach(group.terms) { item in
                                        termCard(item)
                                    }
                                }
                                .padding(.horizontal, 20)
                                .padding(.bottom, 16)
                            } header: {
                                sectionHeader(group.letter)
                            }
                        }
                    }
                    .padding(.bottom, 40)
                }
            }
            
            // Pinned Header
            headerBar
        }
        .navigationBarHidden(true)
    }
    
    // MARK: - Search Bar
    
    private var searchBar: some View {
        HStack(spacing: 10) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 16, weight: .medium))
                .foregroundStyle(DesignSystem.textTertiary)
                .accessibilityHidden(true)
            
            TextField("Search glossary…", text: $searchText)
                .font(.system(size: 16))
                .foregroundStyle(DesignSystem.textPrimary)
                .autocorrectionDisabled()
            
            if !searchText.isEmpty {
                Button {
                    withAnimation(.easeOut(duration: 0.2)) {
                        searchText = ""
                    }
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 16))
                        .foregroundStyle(DesignSystem.textTertiary)
                        .accessibilityLabel("Clear search")
                }
            }
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 11)
        .background(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(Color(uiColor: .tertiarySystemGroupedBackground))
        )
        .padding(.horizontal, 20)
    }
    
    // MARK: - Section Header
    
    private func sectionHeader(_ letter: String) -> some View {
        HStack {
            Text(letter)
                .font(.system(size: 14, weight: .bold, design: .rounded))
                .foregroundStyle(DesignSystem.textTertiary)
                .frame(width: 28, height: 28)
                .background(
                    Circle()
                        .fill(Color(uiColor: .tertiarySystemGroupedBackground))
                )
            
            Rectangle()
                .fill(DesignSystem.separator)
                .frame(height: 0.5)
            
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 6)
        .background(
            DesignSystem.backgroundPrimary
                .opacity(0.95)
        )
    }
    
    // MARK: - Term Card
    
    private func termCard(_ item: GlossaryTerm) -> some View {
        let isExpanded = expandedTermID == item.id
        
        return Button {
            withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                expandedTermID = isExpanded ? nil : item.id
            }
        } label: {
            VStack(alignment: .leading, spacing: 0) {
                // Term row
                HStack(alignment: .center) {
                    // Accent bar
                    RoundedRectangle(cornerRadius: 2, style: .continuous)
                        .fill(accentColor(for: item.term))
                        .frame(width: 3, height: 20)
                    
                    Text(item.term)
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundStyle(DesignSystem.textPrimary)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.down")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundStyle(DesignSystem.textTertiary)
                        .rotationEffect(.degrees(isExpanded ? 180 : 0))
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 14)
                
                // Definition (expanded)
                if isExpanded {
                    Text(highlightedDefinition(item.definition))
                        .font(.system(size: 15))
                        .foregroundStyle(DesignSystem.textSecondary)
                        .fixedSize(horizontal: false, vertical: true)
                        .lineSpacing(5)
                        .padding(.horizontal, 16)
                        .padding(.bottom, 14)
                        .padding(.leading, 7) // align with text after accent bar
                        .transition(.opacity.combined(with: .move(edge: .top)))
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(Color(uiColor: .secondarySystemGroupedBackground))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .stroke(isExpanded ? accentColor(for: item.term).opacity(0.3) : Color.clear, lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
        .accessibilityLabel(item.term)
        .accessibilityHint(isExpanded ? "Collapse definition" : "Expand to see definition")
    }
    
    // MARK: - Header Bar
    
    private var headerBar: some View {
        HStack {
            Button(action: { dismiss() }) {
                HStack(spacing: 4) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 18, weight: .semibold))
                        .accessibilityHidden(true)
                    Text("Back")
                        .font(.system(size: 17, weight: .medium))
                }
                .foregroundStyle(DesignSystem.textPrimary)
            }
            
            Spacer()
        }
        .overlay(
            HStack(spacing: 6) {
                Image(systemName: "character.book.closed.fill")
                    .font(.system(size: 14))
                    .foregroundStyle(DesignSystem.textSecondary)
                    .accessibilityHidden(true)
                Text("Glossary")
                    .font(.system(size: 20, weight: .semibold, design: .serif))
                    .foregroundStyle(DesignSystem.textPrimary)
            }
        )
        .padding(.horizontal, 20)
        .padding(.bottom, 12)
        .frame(height: 44)
        .background(.ultraThinMaterial)
        .background(
            Rectangle()
                .fill(.ultraThinMaterial)
                .edgesIgnoringSafeArea(.top)
        )
    }
    
    // MARK: - Helpers
    
    /// Returns an accent color based on the term's domain category
    private func accentColor(for term: String) -> Color {
        let t = term.lowercased()
        // First Aid / Medical
        if ["cpr", "tourniquet", "shock", "triage", "anaphylaxis", "epinephrine", "epipen",
            "heimlich", "splint", "sling", "rice", "avulsion", "laceration", "abrasion",
            "hemostasis", "hemostatic", "pressure bandage", "occlusive", "hape", "hace",
            "ams", "recovery position", "crepitus", "debridement", "edema", "gangrene",
            "compartment", "cravat", "sam splint", "pulse oximeter", "spo2", "gcs",
            "fast", "avpu", "tachycardia", "bradycardia", "dyspnea", "barotrauma",
            "envenomation", "hypothermia", "hyperthermia", "frostbite", "dehydration",
            "fracture", "dislocation", "sprain", "strain", "ligament", "tendon",
            "hemorrhage", "arterial", "venous", "capillary", "sepsis", "pneumothorax",
            "abscess", "cellulitis", "tetanus", "rabies", "concussion", "necrosis",
            "allergen", "inflammation", "infection", "vital signs", "pulse", "contagious",
            "blunt trauma", "penetrating trauma", "contusion", "sternum", "femur",
            "clavicle", "tibia", "radial", "carotid", "trachea", "esophagus",
            "abdomen", "thorax", "extremity", "distal", "proximal", "anterior",
            "posterior", "dorsal", "ventral", "saline", "antiseptic", "analgesic",
            "antihistamine", "ibuprofen", "acetaminophen", "betadine",
            "irrigate", "palpate", "aspirate", "immobilize", "suture", "cauterize",
            "traction", "compress", "flush", "incision", "stabilize", "assess",
            "administer", "monitor", "expose", "dress", "evacuate", "medevac", "litter",
            "hypoglycemia", "hypovolemic", "hypothermic", "constricting band",
            "pit viper", "coral snake", "brown recluse", "black widow", "nematocyst"]
            .contains(where: { t.contains($0) }) {
            return DesignSystem.firstAidDomain
        }
        // Fire
        if ["tinder", "kindling", "fuel", "ferro", "char cloth", "fire lay", "bow drill",
            "hand drill", "ember", "fire reflector", "fatwood", "dakota", "flint",
            "combustion", "creosote", "flash point", "punk wood", "char",
            "spindle", "percussion", "knapping", "flaking", "obsidian", "chert"]
            .contains(where: { t.contains($0) }) {
            return DesignSystem.fireDomain
        }
        // Shelter
        if ["shelter", "lean-to", "a-frame", "bivy", "bivouac", "debris hut", "quinzhee",
            "snow cave", "mylar", "windbreak", "ground insulation", "thatch",
            "wattle", "ridgepole", "insulate", "notch", "toggle", "leverage",
            "conduction", "convection", "radiation", "evaporation", "condensation",
            "wind chill", "ambient"]
            .contains(where: { t.contains($0) }) {
            return DesignSystem.shelterDomain
        }
        // Water
        if ["potable", "pathogen", "solar still", "turbidity", "electrolyte", "ors",
            "water purification", "seep", "transpiration", "iodine", "giardia",
            "cryptosporidium", "purify", "sterilize", "disinfect", "watershed",
            "tributary", "estuary", "brine", "catchment"]
            .contains(where: { t.contains($0) }) {
            return DesignSystem.waterDomain
        }
        // Navigation
        if ["bearing", "declination", "waypoint", "azimuth", "dead reckoning",
            "terrain association", "contour", "utm", "pace count", "topographic",
            "magnetic north", "true north", "landmark", "terrain", "cairn"]
            .contains(where: { t.contains($0) }) {
            return DesignSystem.navigationDomain
        }
        // Food / Foraging / Plants
        if ["universal edibility", "cambium", "tuber", "snare", "deadfall", "pemmican",
            "hardtack", "edible", "forage", "genus", "species", "acorn", "leaching",
            "lichen", "rhizome", "bulb", "frond", "sap", "bark", "thistle", "nettle",
            "yarrow", "plantain", "cattail", "mullein", "comfrey", "chamomile",
            "sorrel", "dandelion", "burdock", "chicory", "pine needle", "tannin",
            "alkaloid", "reishi", "bamboo", "husk", "pith", "clove", "turmeric",
            "render", "jerky", "offal", "marrow", "grub", "larvae", "smoke"]
            .contains(where: { t.contains($0) }) {
            return DesignSystem.foodDomain
        }
        // Rescue / Signaling
        if ["signal mirror", "ground-to-air", "plb", "epirb", "sos",
            "belay", "rappel", "carabiner", "extricate"]
            .contains(where: { t.contains($0) }) {
            return DesignSystem.rescueDomain
        }
        // Psychology
        if ["survival mindset", "normalcy bias", "rule of threes", "stop, drop",
            "debilitating", "panic"]
            .contains(where: { t.contains($0) }) {
            return DesignSystem.psychologyDomain
        }
        // Environment / Geography
        if ["biome", "boreal", "alpine", "arctic", "tropical", "arid", "marsh",
            "ravine", "canopy", "undergrowth", "permafrost", "habitat",
            "precipitation", "humidity", "gale", "squall", "whiteout",
            "leeward", "windward", "scree", "talus", "eddy", "strainer"]
            .contains(where: { t.contains($0) }) {
            return DesignSystem.environmentDomain
        }
        // Tools / Knots / Equipment
        if ["bowline", "clove", "taut-line", "prusik", "cordage", "paracord",
            "latrine", "cathole", "bushcraft", "cache", "parang", "kukri",
            "lashing", "splice", "webbing", "bight", "standing end", "working end",
            "load-bearing", "sheepshank", "whipping", "sheath", "tarp", "canteen",
            "awl", "adze", "whetstone", "baton", "gauge", "improvise",
            "tincture", "poultice", "decoction", "infusion"]
            .contains(where: { t.contains($0) }) {
            return DesignSystem.toolsDomain
        }
        return DesignSystem.textTertiary
    }
    
    /// If user is searching, highlight the matching portion in the definition
    private func highlightedDefinition(_ text: String) -> AttributedString {
        var attributed = AttributedString(text)
        guard !searchText.isEmpty else { return attributed }
        
        let searchLower = searchText.lowercased()
        let textLower = text.lowercased()
        
        var searchStart = textLower.startIndex
        while let range = textLower.range(of: searchLower, range: searchStart..<textLower.endIndex) {
            let attrStart = AttributedString.Index(range.lowerBound, within: attributed)
            let attrEnd = AttributedString.Index(range.upperBound, within: attributed)
            if let attrStart = attrStart, let attrEnd = attrEnd {
                attributed[attrStart..<attrEnd].foregroundColor = UIColor.label
                attributed[attrStart..<attrEnd].font = .system(size: 15, weight: .semibold)
            }
            searchStart = range.upperBound
        }
        
        return attributed
    }
}
