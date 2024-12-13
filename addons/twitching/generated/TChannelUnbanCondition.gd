extends TBaseType
class_name TChannelUnbanCondition

## Autogenerated. Do not modify.

## The broadcaster user ID for the channel you want to get unban notifications for.
var broadcaster_user_id: String

## Create is similar to _init but takes parameters. Useful for using with autocomplete in the editor.
static func create(broadcaster_user_id: String) -> TChannelUnbanCondition:
	var _new = TChannelUnbanCondition.new()
	_new.broadcaster_user_id = broadcaster_user_id
	return _new

## Create from object (usually returned from api)
static func from_object(obj: Variant) -> TChannelUnbanCondition:
	if not obj: return
	if not obj is Dictionary:
		print("[TChannelUnbanCondition]: Object is not Dictionary: ", obj)
		return

	var _new = TChannelUnbanCondition.new()

	_new.broadcaster_user_id = obj.get("broadcaster_user_id") if obj.get("broadcaster_user_id") else ""

	return _new
