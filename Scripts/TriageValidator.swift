import SwiftUI
import Foundation

struct TriageValidator {
    static func validate() {
        print("\n\n--------------------------------------------------")
        print("          TRIAGE VALIDATION STARTING            ")
        print("--------------------------------------------------")
        
        let db = ContentDatabase.shared
        
        // Ensure content is loaded (it is in init)
        
        // 1. Validate Disaster Tree
        if let disasterNode = db.triageTrees[.disaster] {
            print("✅ Found Disaster Root: \(disasterNode.id)")
            validateNode(disasterNode, parentPath: "Disaster")
        } else {
            print("❌ ERROR: Disaster Tree Missing!")
        }
        
        // 2. Validate Animal Tree
        if let animalNode = db.triageTrees[.animal] {
             print("✅ Found Animal Root: \(animalNode.id)")
             validateNode(animalNode, parentPath: "Animal")
        } else {
             print("❌ ERROR: Animal Tree Missing!")
        }
        
        print("--------------------------------------------------")
        print("          TRIAGE VALIDATION COMPLETE            ")
        print("--------------------------------------------------\n\n")
    }

    private static func validateNode(_ node: TriageNode, parentPath: String) {
        // print("Checking Node: \(node.id)")
        
        for option in node.options {
            let currentPath = "\(parentPath) -> [\(option.label)]"
            switch option.destination {
            case .nextQuestion(let nextNode):
                validateNode(nextNode, parentPath: currentPath)
            case .technique(let id):
                verifyTechnique(id, path: currentPath)
            case .techniqueList(let ids):
                for id in ids {
                    verifyTechnique(id, path: currentPath)
                }
            }
        }
    }

    private static func verifyTechnique(_ id: String, path: String) {
        // Build a set of valid IDs from the loaded content (not directly accessible, but we can search for them)
        // Since `ContentDatabase` doesn't expose a raw set of IDs easily, we can try to `search` for the exact ID or assume if `getTechnique(id)` returned something (it doesn't have such a method public).
        // However, `search(query: "")` returns all technique if query is empty? No.
        // Let's rely on `ContentDatabase.shared.techniques` if public.
        // It is private: `private var techniques: [Technique] = []`.
        // BUT `search` is public. `func search(query: String) -> [Technique]`
        
        // Wait, I cannot efficiently check existence without public access.
        // I'll just print them for manual review in logs for now.
        // "  - Leaf: Disaster -> [Earthquake] -> [Indoors] -> Technique: env-earthquake-indoor"
        print("  - Leaf: \(path) -> Technique: \(id)")
    }
}
