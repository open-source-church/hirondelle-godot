extends TBaseType
class_name TChannelChatClearUserMessagesCondition

## Autogenerated. Do not modify.

## User ID of the channel to receive chat clear user messages events for.
var broadcaster_user_id: String

## The user ID to read chat as.
var user_id: String

## Create is similar to _init but takes parameters. Useful for using with autocomplete in the editor.
static func create(broadcaster_user_id: String, user_id: String) -> TChannelChatClearUserMessagesCondition:
	var _new = TChannelChatClearUserMessagesCondition.new()
	_new.broadcaster_user_id = broadcaster_user_id
	_new.user_id = user_id
	return _new

## Create from object (usually returned from api)
static func from_object(obj: Variant) -> TChannelChatClearUserMessagesCondition:
	if not obj: return
	if not obj is Dictionary:
		print("[TChannelChatClearUserMessagesCondition]: Object is not Dictionary: ", obj)
		return

	var _new = TChannelChatClearUserMessagesCondition.new()

	_new.broadcaster_user_id = obj.get("broadcaster_user_id") if obj.get("broadcaster_user_id") else ""
	_new.user_id = obj.get("user_id") if obj.get("user_id") else ""

	return _new
