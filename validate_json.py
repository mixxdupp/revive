import json
import os
import sys

files = [
    "/Users/adithya/Documents/Revive.swiftpm/Sources/Resources/food.json",
    "/Users/adithya/Documents/Revive.swiftpm/Sources/Resources/environments.json",
    "/Users/adithya/Documents/Revive.swiftpm/Sources/Resources/firstaid.json",
    "/Users/adithya/Documents/Revive.swiftpm/Sources/Resources/tools.json",
    "/Users/adithya/Documents/Revive.swiftpm/Sources/Resources/fire.json"
]

def validate(path):
    print(f"Validating {os.path.basename(path)}...")
    if not os.path.exists(path):
        print(f"Error: {path} does not exist.")
        return False
    
    try:
        with open(path, 'r') as f:
            content = f.read()
            
        # Parse JSON
        data = json.loads(content)
        
        file_valid = True
        
        # Check basic structure (e.g. techniques and articles arrays)
        if "techniques" not in data:
            print("  Error: Missing 'techniques' array")
            file_valid = False
        if "articles" not in data:
            print("  Error: Missing 'articles' array")
            file_valid = False
            
        # Check for duplicate IDs
        ids = set()
        for t in data.get("techniques", []):
            if "id" in t:
                if t["id"] in ids:
                    print(f"  Error: Duplicate ID '{t['id']}' in techniques")
                    file_valid = False
                else:
                    ids.add(t["id"])
        
        for a in data.get("articles", []):
            if "id" in a:
                if a["id"] in ids:
                    print(f"  Error: Duplicate ID '{a['id']}' (in articles, or overlaps with techniques)")
                    file_valid = False
                else:
                    ids.add(a["id"])
                
        if file_valid:
            print("  OK")
        return file_valid
    except json.JSONDecodeError as e:
        print(f"  JSON Error: {e}")
        # Print context
        lines = content.splitlines()
        start = max(0, e.lineno - 2)
        end = min(len(lines), e.lineno + 2)
        for i in range(start, end):
            prefix = ">> " if i + 1 == e.lineno else "   "
            if i < len(lines):
                 print(f"{prefix}{i+1}: {lines[i]}")
        return False
    except Exception as e:
        print(f"  Error: {e}")
        return False

success = True
for f in files:
    if not validate(f):
        success = False

if not success:
    sys.exit(1)
print("All files valid.")
