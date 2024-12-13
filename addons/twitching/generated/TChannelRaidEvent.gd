extends TBaseType
class_name TChannelRaidEvent

## Autogenerated. Do not modify.

## The broadcaster ID that created the raid.
var from_broadcaster_user_id: String

## The broadcaster login that created the raid.
var from_broadcaster_user_login: String

## The broadcaster display name that created the raid.
var from_broadcaster_user_name: String

## The broadcaster ID that received the raid.
var to_broadcaster_user_id: String

## The broadcaster login that received the raid.
var to_broadcaster_user_login: String

## The broadcaster display name that received the raid.
var to_broadcaster_user_name: String

## The number of viewers in the raid.
var viewers: int

## Create is similar to _init but takes parameters. Useful for using with autocomplete in the editor.
static func create(from_broadcaster_user_id: String, from_broadcaster_user_login: String, from_broadcaster_user_name: String, to_broadcaster_user_id: String, to_broadcaster_user_login: String, to_broadcaster_user_name: String, viewers: int) -> TChannelRaidEvent:
	var _new = TChannelRaidEvent.new()
	_new.from_broadcaster_user_id = from_broadcaster_user_id
	_new.from_broadcaster_user_login = from_broadcaster_user_login
	_new.from_broadcaster_user_name = from_broadcaster_user_name
	_new.to_broadcaster_user_id = to_broadcaster_user_id
	_new.to_broadcaster_user_login = to_broadcaster_user_login
	_new.to_broadcaster_user_name = to_broadcaster_user_name
	_new.viewers = viewers
	return _new

## Create from object (usually returned from api)
static func from_object(obj: Variant) -> TChannelRaidEvent:
	if not obj: return
	if not obj is Dictionary:
		print("[TChannelRaidEvent]: Object is not Dictionary: ", obj)
		return

	var _new = TChannelRaidEvent.new()

	_new.from_broadcaster_user_id = obj.get("from_broadcaster_user_id") if obj.get("from_broadcaster_user_id") else ""
	_new.from_broadcaster_user_login = obj.get("from_broadcaster_user_login") if obj.get("from_broadcaster_user_login") else ""
	_new.from_broadcaster_user_name = obj.get("from_broadcaster_user_name") if obj.get("from_broadcaster_user_name") else ""
	_new.to_broadcaster_user_id = obj.get("to_broadcaster_user_id") if obj.get("to_broadcaster_user_id") else ""
	_new.to_broadcaster_user_login = obj.get("to_broadcaster_user_login") if obj.get("to_broadcaster_user_login") else ""
	_new.to_broadcaster_user_name = obj.get("to_broadcaster_user_name") if obj.get("to_broadcaster_user_name") else ""
	_new.viewers = obj.get("viewers") if obj.get("viewers") else 0

	return _new
