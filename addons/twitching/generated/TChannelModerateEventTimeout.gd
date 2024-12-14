extends TBaseType
class_name TChannelModerateEventTimeout

## Autogenerated. Do not modify.

## The ID of the user being timed out.
var user_id: String

## The login of the user being timed out.
var user_login: String

## The user name of the user being timed out.
var user_name: String

## Optional .. The reason given for the timeout.
var reason: String

## The time at which the timeout ends.
var expires_at: String

## Create is similar to _init but takes parameters. Useful for using with autocomplete in the editor.
static func create(user_id: String, user_login: String, user_name: String, reason: String, expires_at: String) -> TChannelModerateEventTimeout:
	var _new = TChannelModerateEventTimeout.new()
	_new.user_id = user_id
	_new.user_login = user_login
	_new.user_name = user_name
	_new.reason = reason
	_new.expires_at = expires_at
	return _new

## Create from object (usually returned from api)
static func from_object(obj: Variant) -> TChannelModerateEventTimeout:
	if not obj: return
	if not obj is Dictionary:
		print("[TChannelModerateEventTimeout]: Object is not Dictionary: ", obj)
		return

	var _new = TChannelModerateEventTimeout.new()

	_new.user_id = obj.get("user_id") if obj.get("user_id") else ""
	_new.user_login = obj.get("user_login") if obj.get("user_login") else ""
	_new.user_name = obj.get("user_name") if obj.get("user_name") else ""
	_new.reason = obj.get("reason") if obj.get("reason") else ""
	_new.expires_at = obj.get("expires_at") if obj.get("expires_at") else ""

	return _new