extends TBaseType
class_name TChannelRaidCondition

## Autogenerated. Do not modify.

## The broadcaster user ID that created the channel raid you want to get notifications for. Use this parameter if you want to know when a specific broadcaster raids another broadcaster. The channel raid condition must include either  from_broadcaster_user_id  or  to_broadcaster_user_id .
var from_broadcaster_user_id: String

## The broadcaster user ID that received the channel raid you want to get notifications for. Use this parameter if you want to know when a specific broadcaster is raided by another broadcaster. The channel raid condition must include either  from_broadcaster_user_id  or  to_broadcaster_user_id .
var to_broadcaster_user_id: String

## Create is similar to _init but takes parameters. Useful for using with autocomplete in the editor.
static func create(from_broadcaster_user_id: String, to_broadcaster_user_id: String) -> TChannelRaidCondition:
	var _new = TChannelRaidCondition.new()
	_new.from_broadcaster_user_id = from_broadcaster_user_id
	_new.to_broadcaster_user_id = to_broadcaster_user_id
	return _new

## Create from object (usually returned from api)
static func from_object(obj: Variant) -> TChannelRaidCondition:
	if not obj: return
	if not obj is Dictionary:
		print("[TChannelRaidCondition]: Object is not Dictionary: ", obj)
		return

	var _new = TChannelRaidCondition.new()

	_new.from_broadcaster_user_id = obj.get("from_broadcaster_user_id") if obj.get("from_broadcaster_user_id") else ""
	_new.to_broadcaster_user_id = obj.get("to_broadcaster_user_id") if obj.get("to_broadcaster_user_id") else ""

	return _new
