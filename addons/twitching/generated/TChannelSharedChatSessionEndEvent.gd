extends TBaseType
class_name TChannelSharedChatSessionEndEvent

## Autogenerated. Do not modify.

## The unique identifier for the shared chat session.
var session_id: String

## The User ID of the channel in the subscription condition which is no longer active in the shared chat session.
var broadcaster_user_id: String

## The display name of the channel in the subscription condition which is no longer active in the shared chat session.
var broadcaster_user_name: String

## The user login of the channel in the subscription condition which is no longer active in the shared chat session.
var broadcaster_user_login: String

## The User ID of the host channel.
var host_broadcaster_user_id: String

## The display name of the host channel.
var host_broadcaster_user_name: String

## The user login of the host channel.
var host_broadcaster_user_login: String

## Create is similar to _init but takes parameters. Useful for using with autocomplete in the editor.
static func create(session_id: String, broadcaster_user_id: String, broadcaster_user_name: String, broadcaster_user_login: String, host_broadcaster_user_id: String, host_broadcaster_user_name: String, host_broadcaster_user_login: String) -> TChannelSharedChatSessionEndEvent:
	var _new = TChannelSharedChatSessionEndEvent.new()
	_new.session_id = session_id
	_new.broadcaster_user_id = broadcaster_user_id
	_new.broadcaster_user_name = broadcaster_user_name
	_new.broadcaster_user_login = broadcaster_user_login
	_new.host_broadcaster_user_id = host_broadcaster_user_id
	_new.host_broadcaster_user_name = host_broadcaster_user_name
	_new.host_broadcaster_user_login = host_broadcaster_user_login
	return _new

## Create from object (usually returned from api)
static func from_object(obj: Variant) -> TChannelSharedChatSessionEndEvent:
	if not obj: return
	if not obj is Dictionary:
		print("[TChannelSharedChatSessionEndEvent]: Object is not Dictionary: ", obj)
		return

	var _new = TChannelSharedChatSessionEndEvent.new()

	_new.session_id = obj.get("session_id") if obj.get("session_id") else ""
	_new.broadcaster_user_id = obj.get("broadcaster_user_id") if obj.get("broadcaster_user_id") else ""
	_new.broadcaster_user_name = obj.get("broadcaster_user_name") if obj.get("broadcaster_user_name") else ""
	_new.broadcaster_user_login = obj.get("broadcaster_user_login") if obj.get("broadcaster_user_login") else ""
	_new.host_broadcaster_user_id = obj.get("host_broadcaster_user_id") if obj.get("host_broadcaster_user_id") else ""
	_new.host_broadcaster_user_name = obj.get("host_broadcaster_user_name") if obj.get("host_broadcaster_user_name") else ""
	_new.host_broadcaster_user_login = obj.get("host_broadcaster_user_login") if obj.get("host_broadcaster_user_login") else ""

	return _new
