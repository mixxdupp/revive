import json
import os

file_path = 'Sources/Resources/environments.json'

with open(file_path, 'r') as f:
    data = json.load(f)

articles = data.get('articles', [])
techniques = data.get('techniques', [])

# Identify misplaced techniques
# Techniques have "name", Articles have "title"
valid_articles = []
misplaced_techniques = []

for item in articles:
    if 'title' in item:
        valid_articles.append(item)
    elif 'name' in item:
        misplaced_techniques.append(item)
    else:
        # Unknown item, keep it in articles just in case? 
        # Or print warning.
        print(f"Warning: Unknown item structure: {item.keys()}")
        valid_articles.append(item)

print(f"Found {len(valid_articles)} valid articles.")
print(f"Found {len(misplaced_techniques)} misplaced techniques.")

# Move them
data['articles'] = valid_articles
data['techniques'] = techniques + misplaced_techniques

# Save
with open(file_path, 'w') as f:
    json.dump(data, f, indent=2)

print("Fixed JSON saved.")
