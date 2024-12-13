import requests
import json
import sys
import os
from bs4 import BeautifulSoup
import argparse

parser = argparse.ArgumentParser(
    prog="Hirondelle Twitch Scrapper",
    description="Parses the twitch documentation and tries to make sense of it."
    )
parser.add_argument("-a", "--all", action="store_true", help="Generate all")
parser.add_argument("-s", "--scopes", action="store_true", help="Generate scopes")
parser.add_argument("-e", "--eventsub", action="store_true", help="Generate EventSub types")
parser.add_argument("-c", "--cache", action="store_true", help="Use cache file")
parser.add_argument("-cc", "--clean-cache", action="store_true", help="Clean cache files")

args = parser.parse_args()

# URL de la documentation Twitch EventSub
SUBSCRIPTION_TYPES_URL = "https://dev.twitch.tv/docs/eventsub/eventsub-subscription-types"
EVENTSUB_REF_URL = "https://dev.twitch.tv/docs/eventsub/eventsub-reference/"
SCOPES_URL = "https://dev.twitch.tv/docs/authentication/scopes/"

DIRNAME = os.path.dirname(sys.argv[0])

def to_cache(filename, content):
    path = os.path.join(DIRNAME, filename)
    with open(path, "w") as f:
        f.write(content)

def from_cache(filename):
    path = os.path.join(DIRNAME, filename)
    with open(path, "r") as f:
        return f.read()

def clean_cache():
    for f in ["scopes.html", "eventsub-ref.html", "eventsub-types.html",
              "subs.json", "references.json", "scopes.json"]:
        path = os.path.join(DIRNAME, f)
        os.remove(path)

def write_file(filename, content):
    path = os.path.join(DIRNAME, "../generated", filename)
    os.makedirs(os.path.dirname(path), exist_ok=True)
    with open(path, "w") as f:
        f.write(content)

def get_url(url):
    response = requests.get(url)
    # response.encoding = response.apparent_encoding
    response.raise_for_status()  # Vérifie si la requête a réussi
    return response.content.decode('utf-8')


def get_url_with_cache(url, filename, use_cache=False):
    content = ""
    if use_cache:
        content = from_cache(filename)
    else:
        content = get_url(url)
        to_cache(filename, content)
    return content

def scrape_eventsub_types(use_cache=True):
    content = get_url_with_cache(SUBSCRIPTION_TYPES_URL,"eventsub-types.html", use_cache)

    soup = BeautifulSoup(content, 'html.parser')

    subscriptions = []

    # Read first table
    table = soup.find_all("table")[0]
    for tr in table.tbody.find_all("tr"):
        td = tr.find_all("td")
        sub = {
            "type": td[0].a.string,
            "name": td[1].string,
            "version": td[2].string,
            "description": td[3].string,
            "class_name": get_class_name(td[0].a.string)
        }

        doc1 = soup.find("h3", string=sub["name"])
        sub["doclink"] = "#"+doc1["id"]

        # Authorization
        auth = doc1.find_next_sibling("h3")
        content = get_content_til_next_h3(auth)
        sub["scopes"] = []
        for p in content:
            for t in p.find_all(lambda t: t.name in ["code", "strong"]):
                if ":" in t.text and not t.text in sub["scopes"]:
                    sub["scopes"].append(t.text)

        # Request Body
        body = auth.find_next_sibling(lambda x: x.name == "h3" and "Request Body" in x.text)
        table = body.find_next_sibling("table")
        sub["request"] = []
        object_param = None
        for tr in table.tbody.find_all("tr"):
            td = tr.find_all("td")
            param = {
                "name": "".join(td[0].strings),
                "type": td[1].a.string.lower() if td[1].a else td[1].string.lower(),
                "required": td[2].string.lower(),
                "description": "".join(td[3].strings),
                "link": td[1].a["href"] if td[1].a else None,
                "id": td[1].a["href"].split("#")[1] if td[1].a else None,
                "class_name": get_class_name(td[1].a["href"].split("#")[1]) if td[1].a else None
                }
            # Some request avec Object, and then the next arguments starts with
            # non-breakable spaces, and they are object parameters.
            if param["type"] == "object":
                param["object"] = {
                    "params": [],
                    "class_name": sub["class_name"] + param["name"].capitalize()
                    }
                param["class_name"] = sub["class_name"] + param["name"].capitalize()
                object_param = param

            if " " in param["name"]:
                param["name"] = param["name"].strip()
                object_param["object"]["params"].append(param)
            else:
                sub["request"].append(param)


        # Payload
        payload = auth.find_next_sibling(lambda x: x.name == "h3" and "Payload" in x.text)
        table = payload.find_next_sibling("table")
        sub["payload"] = []
        for tr in table.tbody.find_all("tr"):
            td = tr.find_all("td")
            sub["payload"].append({
                "name": td[0].string,
                "type": td[1].a.string.lower() if td[1].a else td[1].string.lower(),
                "description": td[2].string,
                "link": td[1].a["href"] if td[1].a else None,
                "id": td[1].a["href"].split("#")[1] if td[1].a else None,
                "class_name": get_class_name(td[1].a["href"].split("#")[1]) if td[1].a else None
                })

        subscriptions.append(sub)

    return subscriptions

def get_content_til_next_h3(tag):
    r = []
    while tag.next_sibling.name != "h3":
        if tag.next_sibling.name:
            r.append(tag.next_sibling)
        tag = tag.next_sibling
    return r


def update_references(subs, references):

    # # First we add condition
    # for sub in subs:
    #     # title
    #     title = soup.find(lambda t: t.name == "h3" and sub["type"] in t.string and "Condition" in t.string)
    #     cond = [p for p in sub["request"] if p["name"] == "condition"][0]
    #
    #     if not title and cond["link"]:
    #         id = cond["link"].split("#")[1]
    #         title = soup.find(lambda t: t.name == "h3" and t["id"] == id)
    #
    #     if not title:
    #         # It's one of those porely formatted with "Object", see above.
    #         continue
    #
    #     # table
    #     table = title.find_next_sibling("table")
    #     cond["params"] = get_reference_table(table)
    #
    #
    # # Then we add Event
    # for sub in subs:
    #     event = [p for p in sub["payload"] if p["type"].lower() == "event"][0]
    #     id = event["link"].split("#")[1]
    #     # manually fix a broken link
    #     if id == "shoutout-sent": id = "shoutout-create"
    #
    #     title = soup.find(lambda t: t.name in ["h3", "h2"] and t["id"] == id)
    #
    #     table = title.find_next_sibling("table")
    #     event["params"] = get_reference_table(table)

    for sub in subs:
        # Update request
        for p in sub["request"]:
            if p["id"]:
                p["object"] = get_reference(p["id"], references)
        # Update payload
        for p in sub["payload"]:
            if p["id"]:
                p["object"] = get_reference(p["id"], references)

def get_reference(id, references):
    # manually fix a broken link
    if id == "shoutout-sent": id = "shoutout-create"
    r = [ref for ref in references if ref["id"] == id]
    if not r:
        print("REF NOT FOUND:", id)
        return None
    return r[0]

def scrape_references(use_cache=True):
    content = get_url_with_cache(EVENTSUB_REF_URL,"eventsub-ref.html", use_cache)

    soup = BeautifulSoup(content, 'html.parser')

    references = []

    # Find all tables
    for table in soup.find_all("table"):
        # Get the previous title
        title = table.find_previous_sibling(lambda t: t.name in ["h2", "h3"])
        # Get references
        refs = get_reference_table(table, title.string)

        references.append({
            "name": title.string,
            "id": title["id"],
            "params": refs,
            "class_name": get_class_name(title["id"]),
            "doclink": "#"+title["id"]
        })

        # Manual fix
        # this table is not displayed as the others...
        if title.string == "Drop Entitlement Grant Event" and len(refs) > 2:
            obj = references.pop(len(references) - 1)
            references[-1]["params"][1]["object"] = obj
            obj["class_name"] = "TDropEntitlementGrantEventData"



    return references

def get_class_name(id):
    # Manual fix
    if id == "shoutout-sent": id = "shoutout-create"
    if " " in id:
        id = id.replace("_", " ")
        return "T"+"".join([i.capitalize() for i in id.split(" ")])
    else:
        return "T"+"".join([i.capitalize() for i in id.split("-")])

def get_reference_table(table, name):
    r = []
    for tr in table.tbody.find_all("tr"):
        td = tr.find_all("td")
        has_required = len(td) == 4
        obj = {
            "name": "".join(td[0].strings),
            "type": "".join(td[1].strings).lower().strip(),
            "description": " ".join(td[3 if has_required else 2].strings)
        }
        # Manual fixes:
        if obj["type"] == "[]string": obj["type"] = "string[]"
        if obj["description"] == "The structured chat message.":
            obj["type"] = "object"
        if obj["name"] == "charity_donation" and "Information about the announcement event" in obj["description"]:
            obj["type"] = "object"
        if obj["name"] == "message" and "An object that contains the user message and emote information needed" in obj["description"]:
            obj["type"] = "object"

        if has_required:
            obj["required"] = td[2].string.lower()

        r.append(obj)

        # There is a link, so it's an object
        if td[1].a:
            id = td[1].a["href"][1:]
            obj["link"] = td[1].a["href"]
            obj["id"] = id

    # Check if there are objects
    r = format_objects_in_table(r, name)

    return r

def format_objects_in_table(params, name):
    _new = []
    _children = []
    parent = None
    for p in params:

        if p["name"][:3] in ["   ", "   "]:
            p["name"] = p["name"][3:]
            # parent.append(p)
            _children.append(p)

        elif parent:
            parent["object"]["params"] = format_objects_in_table(_children, name)
            _children = []
            parent = None
            _new.append(p)

        else:
            _new.append(p)

        if not parent and "object" in p["type"]:
            p["object"] = {
                "class_name": get_class_name(name + " " + p["name"]),
                "params": []
            }
            parent = p

    if len(_children):
        parent["object"]["params"] = format_objects_in_table(_children, name)

    # if has_changed:
    #     dump(_new)
    return _new



def get_params_from_table(soup, id):
    pass

def dump(val):
    print(json.dumps(val, indent=2))

# Flattens the param list by extracting embeded objects types.
# Returns the new list, as well as a list of extracted types.
def flatten_param_list(params):
    _new = []
    _types = []
    for p in params:
        if not p.get("object"):
            continue
        if not p["object"].get("class_name"):
            print("Error: no classname here:", p)
        if len(p["object"]["params"]) == 0:
            # No params
            del p["object"]
            continue

        p["class_name"] = p["object"]["class_name"]

        _class = p["object"]
        _types.append(_class)

        # Recursively do the same
        _params, _new_types = flatten_param_list(_class["params"])
        _types.extend(_new_types)
        _class["params"] = _params

        del p["object"]

    return params, _types


def generate_types(use_cache):

    # Get Subscription Types
    if not use_cache:
        subs = scrape_eventsub_types(use_cache)
        to_cache("subs.json", json.dumps(subs, indent=2))
    else:
        subs = json.loads(from_cache("subs.json"))
    print("Loaded:", len(subs), "subscription types")

    # Get references

    if not use_cache:
        references = scrape_references(use_cache)
        to_cache("references.json", json.dumps(references, indent=2))
    else:
        references = json.loads(from_cache("references.json"))
    print("Loaded:", len(references), "references.")

    # Extract references when they are embeded
    _extracted_types = []
    for sub in subs:
        if sub.get("request"):
            _params, _types = flatten_param_list(sub["request"])
            _extracted_types.extend(_types)
            sub["request"] = _params
        if sub.get("payload"):
            _params, _types = flatten_param_list(sub["payload"])
            _extracted_types.extend(_types)
            sub["payload"] = _params

    print("Extrait", len(_extracted_types), "nouveaux types des subscriptions types.")
    # Adds only types that are not there yet
    for t in _extracted_types:
        if not len([r for r in references if r["class_name"] == t["class_name"]]):
            references.append(t)

    _extracted_types = []
    for ref in references:
        _params, _types = flatten_param_list(ref["params"])
        _extracted_types.extend(_types)
        ref["params"] = _params
    # Adds only types that are not there yet
    for t in _extracted_types:
        if not len([r for r in references if r["class_name"] == t["class_name"]]):
            references.append(t)

    print("Extrait", len(_extracted_types), "nouveaux types des references.")
    print()

    # Connect links
    for ref in references:
        for param in [p for p in ref["params"] if p.get("link") and not p.get("class_name")]:
            t = [r for r in references if r.get("id") == param["id"]]
            if not t:
                print(" * Not found:", param["id"])
                continue
            param["class_name"] = t[0]["class_name"]

    # Supprimer les doublons dans les références
    class_names = [ref["class_name"] for ref in references]
    doubles = set([name for name in class_names if class_names.count(name) > 1])

    print("Classes doubles:", len(doubles), "#FIXME")
    for d in doubles:
        print(" * ", d)
    print()

    print("Total subscription types:", len(subs))
    print("Total types references:", len(references))
    print()

    to_cache("subs.json", json.dumps(subs, indent=2))
    to_cache("references.json", json.dumps(references, indent=2))

    # References checks
    _base_types = []
    _without_class_names = []
    _required = []
    for ref in references:
        for p in ref["params"]:
            if p.get("required"):
                _required.append(p["required"])
            if not p.get("link"):
                _base_types.append(p["type"])
            elif not p.get("class_name"):
                _without_class_names.append(p["type"])

    _base_types = set(_base_types)
    _required = set(_required)
    _without_class_names = set(_without_class_names)

    print("References checks:")
    print(" * Required:", len(_required), _required)
    print(" * Basic types:", len(_base_types), _base_types)
    print(" * Without class_name:", len(_without_class_names), _without_class_names)
    print()

    # Update sub types with references
    # update_references(subs, references)

    # to_cache("subs2.json", json.dumps(subs, indent=2))

    # Subscriptions types checks
    _base_types = []
    _required = []
    _special_types = []
    _objects_without_params = []
    for sub in subs:
        for r in sub["request"]:
            _required.append(r["required"])
            if not r["link"]:
                _base_types.append(r["type"])
            else:
                _special_types.append(r["type"])
            if r["type"] != "string" and not r.get("object") and not r.get("class_name"):
                _objects_without_params.append(r)
        for r in sub["payload"]:
            if not r["link"]:
                _base_types.append(r["type"])
            else:
                _special_types.append(r["type"])

    _base_types = set(_base_types)
    _special_types = set(_special_types)
    _required = set(_required)

    print("Subscription types checks:")
    print(" * Required:", len(_required), _required)
    print(" * Basic types:", len(_base_types), _base_types)
    print(" * Special types:", len(_special_types), _special_types)
    print(" * Objects without params:", len(_objects_without_params))
    for o in _objects_without_params:
        print("   * ", o)
    print()

    ## Generate type classes
    template = """extends TBaseType
class_name {class_name}

## Autogenerated. Do not modify.

"""
    for ref in references:

        if not ref.get("class_name"):
            print(ref)

        content = template.format(class_name = ref["class_name"])

        _vars = {}
        for p in ref["params"]:
            if p["name"] in _vars: continue
            _vars[p["name"]] = p

            _type = None
            if p["type"] == "object[]" and p.get("class_name"):
                _type = f"Array[{p["class_name"]}]"
            elif p.get("class_name"):
                _type = p["class_name"]
            elif p["type"] in ["condition", "event"]:
                _type = "TBaseType"
            else:
                _type = get_type(p["type"])

            if not _type:
                # pass
                print(p)

            content += f"## {p["description"]}\n"
            content += f"var {p["name"]}: {_type}\n\n"

        content += "## Create is similar to _init but takes parameters. Useful for using with autocomplete in the editor.\n"
        _var_list = []
        for var_name in _vars:
            var = _vars[var_name]
            if var["type"] == "object[]" and var.get("class_name"):
                _var_list.append(f"{var_name}: Array[{var["class_name"]}]")
            elif var["type"] == "string[]":
                _var_list.append(f"{var_name}: Array[String]")
            elif var.get("class_name"):
                _var_list.append(f"{var_name}: {var["class_name"]}")
            else:
                _var_list.append(f"{var_name}: {get_type(var["type"])}")
        content += f"static func create({", ".join(_var_list)}) -> {ref["class_name"]}:\n"
        content += f"\tvar _new = {ref["class_name"]}.new()\n"
        for var_name in _vars:
            content += f"\t_new.{var_name} = {var_name}\n"
        content += "\treturn _new\n\n"

        content += "## Create from object (usually returned from api)\n"
        content += f"static func from_object(obj: Variant) -> {ref["class_name"]}:\n"
        content += "\tif not obj: return\n"
        content += "\tif not obj is Dictionary:\n"
        content += f"\t\tprint(\"[{ref["class_name"]}]: Object is not Dictionary: \", obj)\n"
        content += "\t\treturn\n\n"
        content += f"\tvar _new = {ref["class_name"]}.new()\n\n"

        for var_name in _vars:
            var = _vars[var_name]
            # Array object
            if var["type"] == "object[]" and var.get("class_name"):
                content += f"\t_new.{var_name} = [] as Array[{var["class_name"]}]\n"
                content += f"\tfor o in obj.get(\"{var_name}\", []):\n"
                content += f"\t\t_new.{var_name}.append({var["class_name"]}.from_object(o))\n"

                # content += f"\t{var_name} = obj.get(\"{var_name}\", []).map(func (o): return {var["class_name"]}.new(o)) as Array[{var["class_name"]}]\n"
            # Array string
            elif var["type"] == "string[]":
                content += f"\t_new.{var_name} = [] as Array[String]\n"
                content += f"\tfor o in obj.get(\"{var_name}\", []):\n"
                content += f"\t\t_new.{var_name}.append(o)\n"

            # Class
            elif var.get("class_name"):
                content += f"\t_new.{var_name} = {var["class_name"]}.from_object(obj.get(\"{var_name}\", {{}}))\n"
            # Base type
            else:
                content += f"\t_new.{var_name} = obj.get(\"{var_name}\") if obj.get(\"{var_name}\") else {get_default_type(var["type"])}\n"

        content += "\n\treturn _new\n"

        write_file(f"{ref["class_name"]}.gd", content)

        # Generate subscription
        content = """extends RefCounted
class_name TwitchingSubs

## Autogenerated list of subscription types.
##
## Used to create twitch EventSub subscriptions.[br]
## Use with one of the static vars.[br]
## [codeblock]
## var condition = TChannelChatMessageCondition.new()
## condition.broadcaster_user_id = "499044140"
## condition.user_id = "499044140"
## # subscriber is the subscriber in Twitching.eventsub.subscriber
## await TwitchingSubs.CHANNEL_CHAT_MESSAGE.subscribe(subscriber, condition)
## [/codeblock]
## You can also write:
## [codeblock]
## var condition = TChannelChatMessageCondition.create("499044140", "499044140")
## await TwitchingSubs.CHANNEL_CHAT_MESSAGE.subscribe(subscriber, condition)
## [/codeblock]

class Sub:
	var type: String
	var name: String
	var version: String
	var description: String
	var payload_class: RefCounted
	var condition_class: RefCounted

	func _init(_type: String, _name: String, _version: String, _description: String, _payload_class: RefCounted, _condition_class: RefCounted):
		type = _type
		name = _name
		version = _version
		description = _description
		payload_class = _payload_class
		condition_class = _condition_class

	func subscribe(subscriber: TwitchingEventSubSubscriber, condition: TBaseType):
		return await subscriber.subscribe(type, version, condition.to_object())

"""
        for sub in subs:
            var_name = "_".join([n.upper() for n in sub["type"].split(" ")])
            condition_class = [p for p in sub["request"] if p["name"] == "condition"][0]["class_name"]
            payload_class = [p for p in sub["payload"] if p["type"] == "event"][0]["class_name"]

            content += f"## {sub["description"]}[br]\n"
            content += f"## See [{condition_class}] and [{payload_class}].\n"
            content += f"static var {var_name} := Sub.new(\"{sub["name"]}\", \"{sub["type"]}\", \"{sub["version"]}\", \"{sub["description"]}\", {payload_class}, {condition_class})\n\n"

        write_file("Subs.gd", content)


def get_default_type(_type):
    TYPES = {
        "int": "0",
        "integer": "0",
        "boolean": "null",
        "bool": "null",
        "int (or null)": "0",
        "string": "\"\"",
        "string[]": "[]",
        "object": "null"
    }
    return TYPES.get(_type, "null")

def get_type(_type):
    TYPES = {
        "int": "int",
        "integer": "int",
        "boolean": "bool",
        "bool": "bool",
        "int (or null)": "int",
        "string": "String",
        "string[]": "Array[String]",
        "object": "Variant"
    }
    return TYPES.get(_type)


def scrape_scopes(use_cache=True):
    content = get_url_with_cache(SCOPES_URL,"scopes.html", use_cache)
    soup = BeautifulSoup(content, 'html.parser')

    scopes = []

    table = soup.find("table")
    for tr in table.tbody.find_all("tr"):
        td = tr.find_all("td")
        scope = td[0].string

        description = None
        api = []
        eventsub = []
        _current = None

        for x in td[1].stripped_strings:
            if not description:
                description = x
            elif x == "API":
                _current = api
            elif x == "EventSub":
                _current = eventsub
            else:
                _current.append(x)

        scopes.append({
            "name": scope,
            "description": description,
            "api": api,
            "eventsub": eventsub
            })
    return scopes


def generate_scopes(use_cache=False):
    scopes = scrape_scopes(use_cache)

    content = """extends RefCounted
class_name TwitchingScopes

## Scopes used by Twitch.

## Autogenerated from https://dev.twitch.tv/docs/authentication/scopes/
## Do not modify manually, it may change.

# Name of the scope
var name: String
## Description
var description: String
## Which API use it
var API: Array
## Which EventSub use it
var EventSub: Array

func _init(_name: String, _description: String, _API: Array, _EventSub: Array):
	name = _name
	description = _description
	API = _API
	EventSub = _EventSub

func _to_string() -> String:
	return name

static func format_scopes(array: Array[TwitchingScopes]):
	return " ".join(array).uri_encode()

"""

    for s in scopes:
        varname = "_".join([i.upper() for i in s["name"].split(":")])
        content += f"## {s["description"]}\n"
        content += f"static var {varname} := TwitchingScopes.new(\"{s["name"]}\", \"{s["description"]}\", {s["api"]}, {s["eventsub"]})\n\n"

    to_cache("scopes.json", json.dumps(scopes, indent=2))
    write_file("Scopes.gd", content)

if args.clean_cache:
    clean_cache()
if args.scopes or args.all:
    generate_scopes(use_cache=args.cache)
if args.eventsub or args.all:
    generate_types(use_cache=args.cache)
