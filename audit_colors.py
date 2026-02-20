import json
import os
import glob
from pathlib import Path

# The expected color mapping derived from DesignSystem.swift and SurvivalDomain.swift
# These are the iOS system colors that the app uses for each domain.
EXPECTED_COLORS = {
    "fire": "orange",
    "shelter": "green",
    "water": "blue",
    "navigation": "yellow",
    "firstAid": "red",
    "food": "purple",
    "rescue": "indigo",
    "psychology": "brown",
    "environments": "cyan",
    "tools": "gray"
}

# The domains.json structure differs slightly as it holds 'domains' object
# The content JSONs hold arrays of objects with 'domain' property.

RESOURCES_DIR = "/Users/adithya/Documents/Revive.swiftpm/Sources/Resources"

def audit_domains_json():
    print("--- Auditing domains.json ---")
    domains_file = os.path.join(RESOURCES_DIR, "domains.json")
    if not os.path.exists(domains_file):
        print("⚠️ domains.json not found!\n")
        return

    with open(domains_file, 'r', encoding='utf-8') as f:
        data = json.load(f)
        
    mismatches = 0
    domains = data.get("domains", [])
    for d in domains:
        domain_id = d.get("id")
        color = d.get("color")
        
        expected = EXPECTED_COLORS.get(domain_id)
        if expected and color and color.lower() != expected.lower():
            print(f"❌ Mismatch in domains.json for '{domain_id}': Expected '{expected}', Found '{color}'")
            mismatches += 1
            
    if mismatches == 0:
        print("✅ All domains in domains.json match the DesignSystem colors!\n")
    else:
        print(f"Found {mismatches} mismatches in domains.json\n")


def audit_content_jsons():
    print("--- Auditing Content JSONs ---")
    json_files = glob.glob(os.path.join(RESOURCES_DIR, "*.json"))
    
    mismatches = 0
    for path in json_files:
        filename = os.path.basename(path)
        if filename == "domains.json" or filename == "Localizable.xcstrings":
            continue
            
        with open(path, 'r', encoding='utf-8') as f:
            try:
                data = json.load(f)
            except json.JSONDecodeError:
                print(f"⚠️ Could not parse {filename}")
                continue
                
        # Check techniques
        for t in data.get("techniques", []):
            domain_id = t.get("domain")
            if domain_id and "color" in t: # Only check if the JSON actually defines a color override
                color = t.get("color")
                expected = EXPECTED_COLORS.get(domain_id)
                if expected and color and color.lower() != expected.lower():
                    print(f"❌ Technique '{t.get('id')}' ({filename}): Expected '{expected}', Found '{color}'")
                    mismatches += 1
        
        # Check articles
        for a in data.get("articles", []):
            domain_id = a.get("domain")
            if domain_id and "color" in a:
                color = a.get("color")
                expected = EXPECTED_COLORS.get(domain_id)
                if expected and color and color.lower() != expected.lower():
                    print(f"❌ Article '{a.get('id')}' ({filename}): Expected '{expected}', Found '{color}'")
                    mismatches += 1

    if mismatches == 0:
        print("✅ All Content JSONs match the expected colors (or don't override them)!\n")
    else:
        print(f"Found {mismatches} mismatches in content JSONs\n")

if __name__ == "__main__":
    audit_domains_json()
    audit_content_jsons()
