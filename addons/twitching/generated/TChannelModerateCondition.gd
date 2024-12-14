extends TBaseType
class_name TChannelModerateCondition

## Autogenerated. Do not modify.

## The user ID of the broadcaster.
var broadcaster_user_id: String

## The user ID of the moderator.
var moderator_user_id: String

## Create is similar to _init but takes parameters. Useful for using with autocomplete in the editor.
static func create(broadcaster_user_id: String, moderator_user_id: String) -> TChannelModerateCondition:
	var _new = TChannelModerateCondition.new()
	_new.broadcaster_user_id = broadcaster_user_id
	_new.moderator_user_id = moderator_user_id
	return _new

## Create from object (usually returned from api)
static func from_object(obj: Variant) -> TChannelModerateCondition:
	if not obj: return
	if not obj is Dictionary:
		print("[TChannelModerateCondition]: Object is not Dictionary: ", obj)
		return

	var _new = TChannelModerateCondition.new()

	_new.broadcaster_user_id = obj.get("broadcaster_user_id") if obj.get("broadcaster_user_id") else ""
	_new.moderator_user_id = obj.get("moderator_user_id") if obj.get("moderator_user_id") else ""

	return _new