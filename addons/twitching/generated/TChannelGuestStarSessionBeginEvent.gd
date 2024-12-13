extends TBaseType
class_name TChannelGuestStarSessionBeginEvent

## Autogenerated. Do not modify.

## The broadcaster user ID.
var broadcaster_user_id: String

## The broadcaster display name.
var broadcaster_user_name: String

## The broadcaster login.
var broadcaster_user_login: String

## ID representing the unique session that was started.
var session_id: String

## RFC3339 timestamp indicating the time the session began.
var started_at: String

## Create is similar to _init but takes parameters. Useful for using with autocomplete in the editor.
static func create(broadcaster_user_id: String, broadcaster_user_name: String, broadcaster_user_login: String, session_id: String, started_at: String) -> TChannelGuestStarSessionBeginEvent:
	var _new = TChannelGuestStarSessionBeginEvent.new()
	_new.broadcaster_user_id = broadcaster_user_id
	_new.broadcaster_user_name = broadcaster_user_name
	_new.broadcaster_user_login = broadcaster_user_login
	_new.session_id = session_id
	_new.started_at = started_at
	return _new

## Create from object (usually returned from api)
static func from_object(obj: Variant) -> TChannelGuestStarSessionBeginEvent:
	if not obj: return
	if not obj is Dictionary:
		print("[TChannelGuestStarSessionBeginEvent]: Object is not Dictionary: ", obj)
		return

	var _new = TChannelGuestStarSessionBeginEvent.new()

	_new.broadcaster_user_id = obj.get("broadcaster_user_id") if obj.get("broadcaster_user_id") else ""
	_new.broadcaster_user_name = obj.get("broadcaster_user_name") if obj.get("broadcaster_user_name") else ""
	_new.broadcaster_user_login = obj.get("broadcaster_user_login") if obj.get("broadcaster_user_login") else ""
	_new.session_id = obj.get("session_id") if obj.get("session_id") else ""
	_new.started_at = obj.get("started_at") if obj.get("started_at") else ""

	return _new
