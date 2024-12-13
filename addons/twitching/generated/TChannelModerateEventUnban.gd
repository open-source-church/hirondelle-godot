extends TBaseType
class_name TChannelModerateEventUnban

## Autogenerated. Do not modify.

## The ID of the user being unbanned.
var user_id: String

## The login of the user being unbanned.
var user_login: String

## The user name of the user being unbanned.
var user_name: String

## Create is similar to _init but takes parameters. Useful for using with autocomplete in the editor.
static func create(user_id: String, user_login: String, user_name: String) -> TChannelModerateEventUnban:
	var _new = TChannelModerateEventUnban.new()
	_new.user_id = user_id
	_new.user_login = user_login
	_new.user_name = user_name
	return _new

## Create from object (usually returned from api)
static func from_object(obj: Variant) -> TChannelModerateEventUnban:
	if not obj: return
	if not obj is Dictionary:
		print("[TChannelModerateEventUnban]: Object is not Dictionary: ", obj)
		return

	var _new = TChannelModerateEventUnban.new()

	_new.user_id = obj.get("user_id") if obj.get("user_id") else ""
	_new.user_login = obj.get("user_login") if obj.get("user_login") else ""
	_new.user_name = obj.get("user_name") if obj.get("user_name") else ""

	return _new
