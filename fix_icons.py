import os
import shutil
import json
from PIL import Image

# Paths
root = "/Users/adithya/Documents/Revive.swiftpm"
source_icon = os.path.join(root, "Sources/Resources/Assets.xcassets/AppIcon.appiconset/icon.png")
target_appiconset = os.path.join(root, "Assets.xcassets/AppIcon.appiconset")

# Ensure target exists
os.makedirs(target_appiconset, exist_ok=True)

# Read image
img = Image.open(source_icon)

sizes = [
    ("icon_60_2x.png", 120, "ios", "iphone", "60x60", "2x"),
    ("icon_76_2x.png", 152, "ios", "ipad", "76x76", "2x"),
    ("icon_83.5_2x.png", 167, "ios", "ipad", "83.5x83.5", "2x"),
    ("icon_1024.png", 1024, "ios", "ios-marketing", "1024x1024", "1x")
]

images_json = []

for filename, size_px, platform, idiom, size_str, scale in sizes:
    resized = img.resize((size_px, size_px), Image.Resampling.LANCZOS)
    resized.save(os.path.join(target_appiconset, filename))
    
    images_json.append({
        "filename": filename,
        "idiom": idiom,
        "platform": platform,
        "size": size_str,
        "scale": scale
    })

# Write Contents.json
contents = {
    "images": images_json,
    "info": {
        "author": "xcode",
        "version": 1
    }
}

with open(os.path.join(target_appiconset, "Contents.json"), "w") as f:
    json.dump(contents, f, indent=2)

# Remove the duplicates
duplicate_assets = os.path.join(root, "Sources/Resources/Assets.xcassets")
if os.path.exists(duplicate_assets):
    shutil.rmtree(duplicate_assets)

print("Icons fixed and duplicate assets deleted.")
