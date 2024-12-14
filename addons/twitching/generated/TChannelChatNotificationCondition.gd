extends TBaseType
class_name TChannelChatNotificationCondition

## Autogenerated. Do not modify.

## User ID of the channel to receive chat notification events for.
var broadcaster_user_id: String

## The user ID to read chat as.
var user_id: String

## Create is similar to _init but takes parameters. Useful for using with autocomplete in the editor.
static func create(broadcaster_user_id: String, user_id: String) -> TChannelChatNotificationCondition:
	var _new = TChannelChatNotificationCondition.new()
	_new.broadcaster_user_id = broadcaster_user_id
	_new.user_id = user_id
	return _new

## Create from object (usually returned from api)
static func from_object(obj: Variant) -> TChannelChatNotificationCondition:
	if not obj: return
	if not obj is Dictionary:
		print("[TChannelChatNotificationCondition]: Object is not Dictionary: ", obj)
		return

	var _new = TChannelChatNotificationCondition.new()

	_new.broadcaster_user_id = obj.get("broadcaster_user_id") if obj.get("broadcaster_user_id") else ""
	_new.user_id = obj.get("user_id") if obj.get("user_id") else ""

	return _new