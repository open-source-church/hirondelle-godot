extends TBaseType
class_name TStreamOfflineEvent

## Autogenerated. Do not modify.

## The broadcaster’s user id.
var broadcaster_user_id: String

## The broadcaster’s user login.
var broadcaster_user_login: String

## The broadcaster’s user display name.
var broadcaster_user_name: String

## Create is similar to _init but takes parameters. Useful for using with autocomplete in the editor.
static func create(broadcaster_user_id: String, broadcaster_user_login: String, broadcaster_user_name: String) -> TStreamOfflineEvent:
	var _new = TStreamOfflineEvent.new()
	_new.broadcaster_user_id = broadcaster_user_id
	_new.broadcaster_user_login = broadcaster_user_login
	_new.broadcaster_user_name = broadcaster_user_name
	return _new

## Create from object (usually returned from api)
static func from_object(obj: Variant) -> TStreamOfflineEvent:
	if not obj: return
	if not obj is Dictionary:
		print("[TStreamOfflineEvent]: Object is not Dictionary: ", obj)
		return

	var _new = TStreamOfflineEvent.new()

	_new.broadcaster_user_id = obj.get("broadcaster_user_id") if obj.get("broadcaster_user_id") else ""
	_new.broadcaster_user_login = obj.get("broadcaster_user_login") if obj.get("broadcaster_user_login") else ""
	_new.broadcaster_user_name = obj.get("broadcaster_user_name") if obj.get("broadcaster_user_name") else ""

	return _new
