@tool
extends RefCounted

# CLASS GOT AUTOGENERATED DON'T CHANGE MANUALLY. CHANGES CAN BE OVERWRITTEN EASILY.

class_name TwitchDropsEntitlement

## An ID that identifies the entitlement.
var id: String:
	set(val):
		id = val;
		changed_data["id"] = id;
## An ID that identifies the benefit (reward).
var benefit_id: String:
	set(val):
		benefit_id = val;
		changed_data["benefit_id"] = benefit_id;
## The UTC date and time (in RFC3339 format) of when the entitlement was granted.
var timestamp: Variant:
	set(val):
		timestamp = val;
		changed_data["timestamp"] = timestamp;
## An ID that identifies the user who was granted the entitlement.
var user_id: String:
	set(val):
		user_id = val;
		changed_data["user_id"] = user_id;
## An ID that identifies the game the user was playing when the reward was entitled.
var game_id: String:
	set(val):
		game_id = val;
		changed_data["game_id"] = game_id;
## The entitlement’s fulfillment status. Possible values are:       * CLAIMED * FULFILLED
var fulfillment_status: String:
	set(val):
		fulfillment_status = val;
		changed_data["fulfillment_status"] = fulfillment_status;
## The UTC date and time (in RFC3339 format) of when the entitlement was last updated.
var last_updated: Variant:
	set(val):
		last_updated = val;
		changed_data["last_updated"] = last_updated;

var changed_data: Dictionary = {};

static func from_json(d: Dictionary) -> TwitchDropsEntitlement:
	var result = TwitchDropsEntitlement.new();
	if d.has("id") && d["id"] != null:
		result.id = d["id"];
	if d.has("benefit_id") && d["benefit_id"] != null:
		result.benefit_id = d["benefit_id"];
	if d.has("timestamp") && d["timestamp"] != null:
		result.timestamp = d["timestamp"];
	if d.has("user_id") && d["user_id"] != null:
		result.user_id = d["user_id"];
	if d.has("game_id") && d["game_id"] != null:
		result.game_id = d["game_id"];
	if d.has("fulfillment_status") && d["fulfillment_status"] != null:
		result.fulfillment_status = d["fulfillment_status"];
	if d.has("last_updated") && d["last_updated"] != null:
		result.last_updated = d["last_updated"];
	return result;

func to_dict() -> Dictionary:
	return changed_data;

func to_json() -> String:
	return JSON.stringify(to_dict());

