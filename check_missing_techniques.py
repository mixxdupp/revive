import os
import glob
import json
import re

swift_file = "/Users/adithya/Documents/Revive.swiftpm/Sources/Models/ContentDatabase.swift"
json_dir = "/Users/adithya/Documents/Revive.swiftpm/Sources/Resources"

# Extract all technique IDs referenced in swift
swift_content = open(swift_file).read()
technique_refs = set(re.findall(r'\.technique\("([^"]+)"\)', swift_content))
lists = set(re.findall(r'\.techniqueList\(\[([^\]]+)\]\)', swift_content))
for l in lists:
    items = re.findall(r'"([^"]+)"', l)
    for i in items:
        technique_refs.add(i)

print(f"Found {len(technique_refs)} unique technique IDs referenced in Swift.")

# Extract all valid technique IDs from JSON files
valid_ids = set()
for j_file in glob.glob(os.path.join(json_dir, "*.json")):
    try:
        data = json.load(open(j_file))
        if "techniques" in data:
            for t in data["techniques"]:
                valid_ids.add(t["id"])
    except Exception as e:
        pass

print(f"Found {len(valid_ids)} unique technique IDs in JSONs.")

missing = technique_refs - valid_ids
print("\n--- MISSING TECHNIQUE IDs ---")
for m in sorted(missing):
    print(m)
