@tool
extends RefCounted

# CLASS GOT AUTOGENERATED DON'T CHANGE MANUALLY. CHANGES CAN BE OVERWRITTEN EASILY.

class_name TwitchGetGlobalChatBadgesResponse

## The list of chat badges. The list is sorted in ascending order by `set_id`, and within a set, the list is sorted in ascending order by `id`.
var data: Array[TwitchChatBadge]:
	set(val):
		data = val;
		changed_data["data"] = [];
		if data != null:
			for value in data:
				changed_data["data"].append(value.to_dict());

var changed_data: Dictionary = {};

static func from_json(d: Dictionary) -> TwitchGetGlobalChatBadgesResponse:
	var result = TwitchGetGlobalChatBadgesResponse.new();
	if d.has("data") && d["data"] != null:
		for value in d["data"]:
			result.data.append(TwitchChatBadge.from_json(value));
	return result;

func to_dict() -> Dictionary:
	return changed_data;

func to_json() -> String:
	return JSON.stringify(to_dict());

