extends TBaseType
class_name TChannelAdBreakBeginCondition

## Autogenerated. Do not modify.

## The ID of the broadcaster that you want to get Channel Ad Break begin notifications for. Maximum: 1
var broadcaster_id: String

## Create is similar to _init but takes parameters. Useful for using with autocomplete in the editor.
static func create(broadcaster_id: String) -> TChannelAdBreakBeginCondition:
	var _new = TChannelAdBreakBeginCondition.new()
	_new.broadcaster_id = broadcaster_id
	return _new

## Create from object (usually returned from api)
static func from_object(obj: Variant) -> TChannelAdBreakBeginCondition:
	if not obj: return
	if not obj is Dictionary:
		print("[TChannelAdBreakBeginCondition]: Object is not Dictionary: ", obj)
		return

	var _new = TChannelAdBreakBeginCondition.new()

	_new.broadcaster_id = obj.get("broadcaster_id") if obj.get("broadcaster_id") else ""

	return _new
