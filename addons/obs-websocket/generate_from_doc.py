import re
import requests

# URL de la documentation OBS WebSocket
DOC_URL = "https://raw.githubusercontent.com/obsproject/obs-websocket/refs/heads/master/docs/generated/protocol.md"


# Fonction pour convertir un nom en snake_case
def to_snake_case(name):
    return re.sub(r'(?<!^)(?=[A-Z])', '_', name).lower()

# Fonction pour convertir les types OBS en types Godot
def convert_type(obs_type):
    type_map = {
        "String": "String",
        "Boolean": "bool",
        "Number": "int",
        "Double": "float",
        "Object": "Dictionary",
        "Array": "Array",
        "Mixed": "Variant",  # Utilisé pour les types mixtes
    }
    return type_map.get(obs_type, "Variant")  # Par défaut, Variant

# Télécharger la documentation
response = requests.get(DOC_URL)
doc_text = response.text

# Extraire la section Events
events_section = re.search(r"# Events.*?(?=# Requests|\Z)", doc_text, re.S)
if not events_section:
    raise ValueError("Section # Events introuvable dans la documentation.")
events_text = events_section.group(0)

# Analyser les événements
signals = []
current_event = None
for line in events_text.splitlines():
    line = line.strip()

    # Détecter le début d'un événement
    event_match = re.match(r"^### (\w+)", line)
    if event_match:
        if current_event:
            signals.append(current_event)
        current_event = {
            "name": to_snake_case(event_match.group(1)),
            "CamelName": event_match.group(1),
            "fields": []
        }
        continue

    # Détecter les champs des données
    field_match = re.match(r"^\| (\w+) \| (.+?) \| (.+) \|", line)
    if field_match and current_event and field_match.group(3) != "Description":
        field_name = to_snake_case(field_match.group(1))
        field_camel_name = field_match.group(1)
        field_type = convert_type(field_match.group(2))
        current_event["fields"].append((field_name, field_type, field_camel_name))

# Ajouter le dernier événement
if current_event:
    signals.append(current_event)

# Générer le code GDScript
output_lines = ["# Signaux générés à partir de la documentation OBS WebSocket via generate_from_doc.py"]
for signal in signals:
    signal_name = signal["name"]
    fields = signal["fields"]
    field_defs = ", ".join(f"{name} : {type_}" for name, type_, cname in fields)
    output_lines.append(f"signal {signal_name}({field_defs})")


# Générer la fonction qui process tout ça
output_lines.append("")
output_lines.append("func process_event(event : Dictionary):")
for signal in signals:
    output_lines.append("\tif event.eventType == \"" + signal["CamelName"] + "\":")
    args = ", ".join([f"event.eventData.{field[2]}" for field in signal["fields"]])
    output_lines.append(f"\t\t{signal["name"]}.emit({args})")



# Sauvegarder dans un fichier ou afficher
output_file = "generated_signals.gd"
with open(output_file, "w", encoding="utf-8") as f:
    f.write("\n".join(output_lines))

print(f"Signaux générés et sauvegardés dans {output_file}")
