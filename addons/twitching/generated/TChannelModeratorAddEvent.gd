extends TBaseType
class_name TChannelModeratorAddEvent

## Autogenerated. Do not modify.

## The requested broadcaster ID.
var broadcaster_user_id: String

## The requested broadcaster login.
var broadcaster_user_login: String

## The requested broadcaster display name.
var broadcaster_user_name: String

## The user ID of the new moderator.
var user_id: String

## The user login of the new moderator.
var user_login: String

## The display name of the new moderator.
var user_name: String

## Create is similar to _init but takes parameters. Useful for using with autocomplete in the editor.
static func create(broadcaster_user_id: String, broadcaster_user_login: String, broadcaster_user_name: String, user_id: String, user_login: String, user_name: String) -> TChannelModeratorAddEvent:
	var _new = TChannelModeratorAddEvent.new()
	_new.broadcaster_user_id = broadcaster_user_id
	_new.broadcaster_user_login = broadcaster_user_login
	_new.broadcaster_user_name = broadcaster_user_name
	_new.user_id = user_id
	_new.user_login = user_login
	_new.user_name = user_name
	return _new

## Create from object (usually returned from api)
static func from_object(obj: Variant) -> TChannelModeratorAddEvent:
	if not obj: return
	if not obj is Dictionary:
		print("[TChannelModeratorAddEvent]: Object is not Dictionary: ", obj)
		return

	var _new = TChannelModeratorAddEvent.new()

	_new.broadcaster_user_id = obj.get("broadcaster_user_id") if obj.get("broadcaster_user_id") else ""
	_new.broadcaster_user_login = obj.get("broadcaster_user_login") if obj.get("broadcaster_user_login") else ""
	_new.broadcaster_user_name = obj.get("broadcaster_user_name") if obj.get("broadcaster_user_name") else ""
	_new.user_id = obj.get("user_id") if obj.get("user_id") else ""
	_new.user_login = obj.get("user_login") if obj.get("user_login") else ""
	_new.user_name = obj.get("user_name") if obj.get("user_name") else ""

	return _new
