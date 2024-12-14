extends TBaseType
class_name TChannelSubscribeCondition

## Autogenerated. Do not modify.

## The broadcaster user ID for the channel you want to get subscribe notifications for.
var broadcaster_user_id: String

## Create is similar to _init but takes parameters. Useful for using with autocomplete in the editor.
static func create(broadcaster_user_id: String) -> TChannelSubscribeCondition:
	var _new = TChannelSubscribeCondition.new()
	_new.broadcaster_user_id = broadcaster_user_id
	return _new

## Create from object (usually returned from api)
static func from_object(obj: Variant) -> TChannelSubscribeCondition:
	if not obj: return
	if not obj is Dictionary:
		print("[TChannelSubscribeCondition]: Object is not Dictionary: ", obj)
		return

	var _new = TChannelSubscribeCondition.new()

	_new.broadcaster_user_id = obj.get("broadcaster_user_id") if obj.get("broadcaster_user_id") else ""

	return _new