extends TBaseType
class_name TStreamOnlineEvent

## Autogenerated. Do not modify.

## The id of the stream.
var id: String

## The broadcaster’s user id.
var broadcaster_user_id: String

## The broadcaster’s user login.
var broadcaster_user_login: String

## The broadcaster’s user display name.
var broadcaster_user_name: String

## The stream type. Valid values are:  live ,  playlist ,  watch_party ,  premiere ,  rerun .
var type: String

## The timestamp at which the stream went online at.
var started_at: String

## Create is similar to _init but takes parameters. Useful for using with autocomplete in the editor.
static func create(id: String, broadcaster_user_id: String, broadcaster_user_login: String, broadcaster_user_name: String, type: String, started_at: String) -> TStreamOnlineEvent:
	var _new = TStreamOnlineEvent.new()
	_new.id = id
	_new.broadcaster_user_id = broadcaster_user_id
	_new.broadcaster_user_login = broadcaster_user_login
	_new.broadcaster_user_name = broadcaster_user_name
	_new.type = type
	_new.started_at = started_at
	return _new

## Create from object (usually returned from api)
static func from_object(obj: Variant) -> TStreamOnlineEvent:
	if not obj: return
	if not obj is Dictionary:
		print("[TStreamOnlineEvent]: Object is not Dictionary: ", obj)
		return

	var _new = TStreamOnlineEvent.new()

	_new.id = obj.get("id") if obj.get("id") else ""
	_new.broadcaster_user_id = obj.get("broadcaster_user_id") if obj.get("broadcaster_user_id") else ""
	_new.broadcaster_user_login = obj.get("broadcaster_user_login") if obj.get("broadcaster_user_login") else ""
	_new.broadcaster_user_name = obj.get("broadcaster_user_name") if obj.get("broadcaster_user_name") else ""
	_new.type = obj.get("type") if obj.get("type") else ""
	_new.started_at = obj.get("started_at") if obj.get("started_at") else ""

	return _new
