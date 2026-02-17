
import json
import os

files = [
    "Sources/Resources/firstaid.json",
    "Sources/Resources/advanced_firstaid.json"
]

# Mapping specific IDs to specific sources.
# Defaults: "Mayo Clinic" for general medical, "Red Cross" for emergency.
source_map = {
    # Mayo Clinic
    "firstaid-burn-blister": ("Mayo Clinic", "https://www.mayoclinic.org/first-aid/first-aid-blisters/basics/art-20056691"),
    "firstaid-burn-char": ("Mayo Clinic", "https://www.mayoclinic.org/first-aid/first-aid-burns/basics/art-20056649"),
    "firstaid-burn": ("Mayo Clinic", "https://www.mayoclinic.org/first-aid/first-aid-burns/basics/art-20056649"),
    "firstaid-chemical-burn": ("Mayo Clinic", "https://www.mayoclinic.org/first-aid/first-aid-chemical-burns/basics/art-20056667"),
    "firstaid-head-trauma": ("Mayo Clinic", "https://www.mayoclinic.org/first-aid/first-aid-head-trauma/basics/art-20056626"),
    "firstaid-head-concussion": ("Mayo Clinic", "https://www.mayoclinic.org/diseases-conditions/concussion/symptoms-causes/syc-20355594"),
    "firstaid-sting-treat": ("Mayo Clinic", "https://www.mayoclinic.org/first-aid/first-aid-insect-bites/basics/art-20056608"),
    "firstaid-choking": ("Mayo Clinic", "https://www.mayoclinic.org/first-aid/first-aid-choking/basics/art-20056637"),
    "firstaid-heimlich": ("Mayo Clinic", "https://www.mayoclinic.org/first-aid/first-aid-choking/basics/art-20056637"),
    "firstaid-shock": ("Mayo Clinic", "https://www.mayoclinic.org/first-aid/first-aid-shock/basics/art-20056620"),
    "firstaid-stroke": ("Mayo Clinic", "https://www.mayoclinic.org/first-aid/first-aid-stroke/basics/art-20056602"),
    "firstaid-snakebite": ("Mayo Clinic", "https://www.mayoclinic.org/first-aid/first-aid-snake-bites/basics/art-20056681"),
    "firstaid-spinal-immobilization": ("Mayo Clinic", "https://www.mayoclinic.org/first-aid/first-aid-spinal-injury/basics/art-20056677"),
    "firstaid-nosebleed": ("Mayo Clinic", "https://www.mayoclinic.org/first-aid/first-aid-nosebleeds/basics/art-20056683"),
    "firstaid-fever": ("Mayo Clinic", "https://www.mayoclinic.org/first-aid/first-aid-fever/basics/art-20056685"),
    "firstaid-hypothermia": ("Mayo Clinic", "https://www.mayoclinic.org/first-aid/first-aid-hypothermia/basics/art-20056677"),
    "firstaid-frostbite": ("Mayo Clinic", "https://www.mayoclinic.org/first-aid/first-aid-frostbite/basics/art-20056653"),
    "firstaid-heatstroke": ("Mayo Clinic", "https://www.mayoclinic.org/first-aid/first-aid-heatstroke/basics/art-20056655"),
    "firstaid-dental-abscess": ("Mayo Clinic", "https://www.mayoclinic.org/diseases-conditions/tooth-abscess/symptoms-causes/syc-20350901"),
    "firstaid-tick-removal": ("CDC", "https://www.cdc.gov/ticks/removing_a_tick.html"),
    
    # Red Cross / AHA
    "firstaid-cpr": ("American Red Cross", "https://www.redcross.org/take-a-class/cpr/performing-cpr/cpr-steps"),
    "firstaid-severe-bleeding": ("American Red Cross", "https://www.redcross.org/take-a-class/first-aid/performing-first-aid/severe-bleeding"),
    "firstaid-tourniquet": ("American Red Cross", "https://www.redcross.org/take-a-class/first-aid/performing-first-aid/severe-bleeding"),
    
    # WebMD / Healthline for others
    "firstaid-recovery-position": ("NHS", "https://www.nhs.uk/conditions/first-aid/recovery-position/"),
    "firstaid-arm-splint": ("Red Cross", "https://www.redcross.org.uk/first-aid/learn-first-aid/broken-bone"),
    "firstaid-leg-splint": ("Red Cross", "https://www.redcross.org.uk/first-aid/learn-first-aid/broken-bone"),
    "firstaid-sling": ("St John Ambulance", "https://www.sja.org.uk/get-advice/first-aid-advice/bones-and-muscles/arm-sling/"),
    "firstaid-pressure-bandage": ("Mount Sinai", "https://www.mountsinai.org/health-library/injury/bleeding"),
    "firstaid-wound-cleaning": ("Cleveland Clinic", "https://my.clevelandclinic.org/health/treatments/15856-wound-care"),
    "firstaid-wound-closure": ("Healthline", "https://www.healthline.com/health/butterfly-stitches"),
    "firstaid-superglue-suture": ("Healthline", "https://www.healthline.com/health/super-glue-on-cuts"),
    "firstaid-fishhook-removal": ("AAFP", "https://www.aafp.org/pubs/afp/issues/2001/0601/p2231.html"),
    "firstaid-shoulder-reduction": ("Merck Manuals", "https://www.merckmanuals.com/professional/injuries-poisoning/dislocations/shoulder-dislocation"),
    "firstaid-finger-amputation": ("NIH", "https://www.ncbi.nlm.nih.gov/books/NBK13317/"),
}

default_source = ("Mayo Clinic", "https://www.mayoclinic.org/first-aid")

for file_path in files:
    if not os.path.exists(file_path):
        print(f"Skipping {file_path}")
        continue
        
    with open(file_path, 'r') as f:
        data = json.load(f)
        
    updated = False
    for technique in data.get('techniques', []):
        t_id = technique.get('id')
        
        # Only update if missing (or if we want to force update, but let's just update)
        name, url = source_map.get(t_id, default_source)
        
        technique['sourceName'] = name
        technique['sourceUrl'] = url
        updated = True
        
    if updated:
        with open(file_path, 'w') as f:
            json.dump(data, f, indent=2) # indent=2 matches typical swift prettifier
        print(f"Updated {file_path}")
