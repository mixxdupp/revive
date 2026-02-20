import os
import glob
import json
import re

swift_file = "/Users/adithya/Documents/Revive.swiftpm/Sources/Models/ContentDatabase.swift"
json_dir = "/Users/adithya/Documents/Revive.swiftpm/Sources/Resources"

swift_content = open(swift_file).read()

# Extract technique references
technique_refs = set(re.findall(r'\.technique\("([^"]+)"\)', swift_content))
tech_lists = re.findall(r'\.techniqueList\(\[([^\]]+)\]\)', swift_content)
for l in tech_lists:
    items = re.findall(r'"([^"]+)"', l)
    for i in items:
        technique_refs.add(i)

# Extract article references
article_refs = set(re.findall(r'\.article\("([^"]+)"\)', swift_content))
art_lists = re.findall(r'\.articleList\(\[([^\]]+)\]\)', swift_content)
for l in art_lists:
    items = re.findall(r'"([^"]+)"', l)
    for i in items:
        article_refs.add(i)

valid_tech_ids = set()
valid_art_ids = set()

for j_file in glob.glob(os.path.join(json_dir, "*.json")):
    try:
        data = json.load(open(j_file))
        if "techniques" in data:
            for t in data["techniques"]:
                valid_tech_ids.add(t["id"])
        if "articles" in data:
            for a in data["articles"]:
                valid_art_ids.add(a["id"])
    except Exception as e:
        pass

missing_tech = technique_refs - valid_tech_ids
missing_art = article_refs - valid_art_ids

print("MISSING TECHNIQUES:")
for m in sorted(missing_tech):
    print(" -", m)

print("\nMISSING ARTICLES:")
for m in sorted(missing_art):
    print(" -", m)
