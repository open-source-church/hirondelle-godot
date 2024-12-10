@tool
extends RefCounted

# CLASS GOT AUTOGENERATED DON'T CHANGE MANUALLY. CHANGES CAN BE OVERWRITTEN EASILY.

class_name TwitchChannelEmote

## An ID that identifies this emote.
var id: String:
	set(val):
		id = val;
		changed_data["id"] = id;
## The name of the emote. This is the name that viewers type in the chat window to get the emote to appear.
var name: String:
	set(val):
		name = val;
		changed_data["name"] = name;
## The image URLs for the emote. These image URLs always provide a static, non-animated emote image with a light background.      **NOTE:** You should use the templated URL in the `template` field to fetch the image instead of using these URLs.
var images: Images:
	set(val):
		images = val;
		if images != null:
			changed_data["images"] = images.to_dict();
## The subscriber tier at which the emote is unlocked. This field contains the tier information only if `emote_type` is set to `subscriptions`, otherwise, it's an empty string.
var tier: String:
	set(val):
		tier = val;
		changed_data["tier"] = tier;
## The type of emote. The possible values are:      * bitstier — A custom Bits tier emote. * follower — A custom follower emote. * subscriptions — A custom subscriber emote.
var emote_type: String:
	set(val):
		emote_type = val;
		changed_data["emote_type"] = emote_type;
## An ID that identifies the emote set that the emote belongs to.
var emote_set_id: String:
	set(val):
		emote_set_id = val;
		changed_data["emote_set_id"] = emote_set_id;
## The formats that the emote is available in. For example, if the emote is available only as a static PNG, the array contains only `static`. But if the emote is available as a static PNG and an animated GIF, the array contains `static` and `animated`. The possible formats are:      * animated — An animated GIF is available for this emote. * static — A static PNG file is available for this emote.
var format: Array[String]:
	set(val):
		format = val;
		changed_data["format"] = [];
		if format != null:
			for value in format:
				changed_data["format"].append(value);
## The sizes that the emote is available in. For example, if the emote is available in small and medium sizes, the array contains 1.0 and 2.0\. Possible sizes are:      * 1.0 — A small version (28px x 28px) is available. * 2.0 — A medium version (56px x 56px) is available. * 3.0 — A large version (112px x 112px) is available.
var scale: Array[String]:
	set(val):
		scale = val;
		changed_data["scale"] = [];
		if scale != null:
			for value in scale:
				changed_data["scale"].append(value);
## The background themes that the emote is available in. Possible themes are:      * dark * light
var theme_mode: Array[String]:
	set(val):
		theme_mode = val;
		changed_data["theme_mode"] = [];
		if theme_mode != null:
			for value in theme_mode:
				changed_data["theme_mode"].append(value);

var changed_data: Dictionary = {};

static func from_json(d: Dictionary) -> TwitchChannelEmote:
	var result = TwitchChannelEmote.new();
	if d.has("id") && d["id"] != null:
		result.id = d["id"];
	if d.has("name") && d["name"] != null:
		result.name = d["name"];
	if d.has("images") && d["images"] != null:
		result.images = Images.from_json(d["images"]);
	if d.has("tier") && d["tier"] != null:
		result.tier = d["tier"];
	if d.has("emote_type") && d["emote_type"] != null:
		result.emote_type = d["emote_type"];
	if d.has("emote_set_id") && d["emote_set_id"] != null:
		result.emote_set_id = d["emote_set_id"];
	if d.has("format") && d["format"] != null:
		for value in d["format"]:
			result.format.append(value);
	if d.has("scale") && d["scale"] != null:
		for value in d["scale"]:
			result.scale.append(value);
	if d.has("theme_mode") && d["theme_mode"] != null:
		for value in d["theme_mode"]:
			result.theme_mode.append(value);
	return result;

func to_dict() -> Dictionary:
	return changed_data;

func to_json() -> String:
	return JSON.stringify(to_dict());

## The image URLs for the emote. These image URLs always provide a static, non-animated emote image with a light background.      **NOTE:** You should use the templated URL in the `template` field to fetch the image instead of using these URLs.
class Images extends RefCounted:
	## A URL to the small version (28px x 28px) of the emote.
	var url_1x: String:
		set(val):
			url_1x = val;
			changed_data["url_1x"] = url_1x;
	## A URL to the medium version (56px x 56px) of the emote.
	var url_2x: String:
		set(val):
			url_2x = val;
			changed_data["url_2x"] = url_2x;
	## A URL to the large version (112px x 112px) of the emote.
	var url_4x: String:
		set(val):
			url_4x = val;
			changed_data["url_4x"] = url_4x;

	var changed_data: Dictionary = {};

	static func from_json(d: Dictionary) -> Images:
		var result = Images.new();
		if d.has("url_1x") && d["url_1x"] != null:
			result.url_1x = d["url_1x"];
		if d.has("url_2x") && d["url_2x"] != null:
			result.url_2x = d["url_2x"];
		if d.has("url_4x") && d["url_4x"] != null:
			result.url_4x = d["url_4x"];
		return result;

	func to_dict() -> Dictionary:
		return changed_data;

	func to_json() -> String:
		return JSON.stringify(to_dict());

