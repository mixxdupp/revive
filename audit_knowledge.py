import json
import os
import glob
import re

RESOURCES_DIR = "/Users/adithya/Documents/Revive.swiftpm/Sources/Resources"
SWIFT_DIR = "/Users/adithya/Documents/Revive.swiftpm/Sources"

def audit_knowledge_base():
    defined_techniques = set()
    defined_articles = set()

    # 1. Gather all defined items from JSONs
    json_files = glob.glob(os.path.join(RESOURCES_DIR, "*.json"))
    for path in json_files:
        filename = os.path.basename(path)
        if filename == "domains.json": continue
        
        try:
            with open(path, 'r', encoding='utf-8') as f:
                data = json.load(f)
                for t in data.get("techniques", []):
                    defined_techniques.add(t.get("id"))
                for a in data.get("articles", []):
                    defined_articles.add(a.get("id"))
        except Exception as e:
            print(f"Error parsing {filename}: {e}")

    print(f"Loaded {len(defined_techniques)} Techniques and {len(defined_articles)} Articles from JSON files.\n")

    # 2. Gather all referenced items
    # Items can be referenced in:
    # A) EmergencyTree.swift (The triage flow destinations)
    # B) Inside other JSONs (e.g. "relatedTechniqueIDs" in articles or "relatedIds" in techniques)
    
    referenced_techniques = set()
    referenced_articles = set()

    # Check JSON internally linked items
    for path in json_files:
        filename = os.path.basename(path)
        if filename == "domains.json": continue
        try:
            with open(path, 'r', encoding='utf-8') as f:
                data = json.load(f)
                
                for t in data.get("techniques", []):
                    for rel in t.get("relatedIds", []):
                        referenced_techniques.add(rel)
                
                for a in data.get("articles", []):
                    for rel in a.get("relatedTechniqueIDs", []):
                        referenced_techniques.add(rel)
        except Exception:
            pass

    # Check EmergencyTree.swift for triage flow references
    emergency_tree_path = os.path.join(SWIFT_DIR, "Models/EmergencyTree.swift")
    if os.path.exists(emergency_tree_path):
        with open(emergency_tree_path, 'r', encoding='utf-8') as f:
            content = f.read()
            
            # Find .technique("id")
            tech_matches = re.findall(r'\.technique\("([^"]+)"\)', content)
            referenced_techniques.update(tech_matches)
            
            # Find .techniqueList(["id1", "id2"])
            tech_list_matches = re.findall(r'\.techniqueList\(\[([^\]]+)\]\)', content)
            for m in tech_list_matches:
                items = re.findall(r'"([^"]+)"', m)
                referenced_techniques.update(items)
                
            # Find .article("id")
            art_matches = re.findall(r'\.article\("([^"]+)"\)', content)
            referenced_articles.update(art_matches)
            
            # Find .articleList(["id1", "id2"])
            art_list_matches = re.findall(r'\.articleList\(\[([^\]]+)\]\)', content)
            for m in art_list_matches:
                items = re.findall(r'"([^"]+)"', m)
                referenced_articles.update(items)
    else:
        print("⚠️ EmergencyTree.swift not found. Checking all Source files instead.")
        # Fallback to scanning all swift files
        swift_files = glob.glob(os.path.join(SWIFT_DIR, "**/*.swift"), recursive=True)
        for path in swift_files:
            with open(path, 'r', encoding='utf-8') as f:
                content = f.read()
                
                tech_matches = re.findall(r'\.technique\("([^"]+)"\)', content)
                referenced_techniques.update(tech_matches)
                
                tech_list_matches = re.findall(r'\.techniqueList\(\[([^\]]+)\]\)', content)
                for m in tech_list_matches:
                    items = re.findall(r'"([^"]+)"', m)
                    referenced_techniques.update(items)
                    
                art_matches = re.findall(r'\.article\("([^"]+)"\)', content)
                referenced_articles.update(art_matches)
                
                art_list_matches = re.findall(r'\.articleList\(\[([^\]]+)\]\)', content)
                for m in art_list_matches:
                    items = re.findall(r'"([^"]+)"', m)
                    referenced_articles.update(items)

    # Note: Techniques and Articles are ALWAYS visible in the Library Tab. 
    # The Library parses the JSON and shows everything physically defined.
    # Therefore, zero items are truly "unseen" or "inaccessible" if they exist in the JSON.
    # What we are testing here is: Are there items that belong to the triage graph that are missing,
    # OR are there items that are *only* found via manual library browse but NEVER recommended via triage?
    
    # 3. Analyze Results
    
    missing_techniques = referenced_techniques - defined_techniques
    missing_articles = referenced_articles - defined_articles
    
    orphaned_techniques = defined_techniques - referenced_techniques
    orphaned_articles = defined_articles - referenced_articles
    
    print("--- 🚨 CRITICAL ERRORS: Missing Data (Reference exists, but item doesn't exist) ---")
    if missing_techniques:
        print(f"❌ {len(missing_techniques)} Missing Techniques referenced in code/data but missing in JSON:")
        for t in sorted(missing_techniques): print(f"  - {t}")
    else: print("✅ Zero missing techniques.")
        
    if missing_articles:
        print(f"\n❌ {len(missing_articles)} Missing Articles referenced in code/data but missing in JSON:")
        for a in sorted(missing_articles): print(f"  - {a}")
    else: print("✅ Zero missing articles.")

    print("\n--- ⚠️ WARNINGS: Orphaned Content (Exists in JSON, but never recommended via Triage or Related links) ---")
    print("Note: These are still accessible via the Library tab.")
    if orphaned_techniques:
        print(f"⚠️ {len(orphaned_techniques)} Techniques are only discoverable via Library browse:")
        for t in sorted(orphaned_techniques): print(f"  - {t}")
    else: print("✅ All techniques are integrated into the recommendation graph.")
        
    if orphaned_articles:
        print(f"\n⚠️ {len(orphaned_articles)} Articles are only discoverable via Library browse:")
        for a in sorted(orphaned_articles): print(f"  - {a}")
    else: print("✅ All articles are integrated into the recommendation graph.")

if __name__ == "__main__":
    audit_knowledge_base()
