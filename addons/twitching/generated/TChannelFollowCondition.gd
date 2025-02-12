extends TBaseType
class_name TChannelFollowCondition

## Autogenerated. Do not modify.

## The broadcaster user ID for the channel you want to get follow notifications for.
var broadcaster_user_id: String

## The ID of the moderator of the channel you want to get follow notifications for. If you have authorization from the broadcaster rather than a moderator, specify the broadcaster’s user ID here.
var moderator_user_id: String

## Create is similar to _init but takes parameters. Useful for using with autocomplete in the editor.
static func create(broadcaster_user_id: String, moderator_user_id: String) -> TChannelFollowCondition:
	var _new = TChannelFollowCondition.new()
	_new.broadcaster_user_id = broadcaster_user_id
	_new.moderator_user_id = moderator_user_id
	return _new

## Create from object (usually returned from api)
static func from_object(obj: Variant) -> TChannelFollowCondition:
	if not obj: return
	if not obj is Dictionary:
		print("[TChannelFollowCondition]: Object is not Dictionary: ", obj)
		return

	var _new = TChannelFollowCondition.new()

	_new.broadcaster_user_id = obj.get("broadcaster_user_id") if obj.get("broadcaster_user_id") else ""
	_new.moderator_user_id = obj.get("moderator_user_id") if obj.get("moderator_user_id") else ""

	return _new
