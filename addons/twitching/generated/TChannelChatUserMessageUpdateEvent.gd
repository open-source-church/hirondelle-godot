extends TBaseType
class_name TChannelChatUserMessageUpdateEvent

## Autogenerated. Do not modify.

## The ID of the broadcaster specified in the request.
var broadcaster_user_id: String

## The login of the broadcaster specified in the request.
var broadcaster_user_login: String

## The user name of the broadcaster specified in the request.
var broadcaster_user_name: String

## The User ID of the message sender.
var user_id: String

## The message sender’s login.
var user_login: String

## The message sender’s user name.
var user_name: String

## The message’s status. Possible values are: approved denied invalid
var status: String

## The ID of the message that was flagged by automod.
var message_id: String

## The body of the message.
var message: Array[TChannelChatUserMessageUpdateEventMessage]

## Create is similar to _init but takes parameters. Useful for using with autocomplete in the editor.
static func create(broadcaster_user_id: String, broadcaster_user_login: String, broadcaster_user_name: String, user_id: String, user_login: String, user_name: String, status: String, message_id: String, message: Array[TChannelChatUserMessageUpdateEventMessage]) -> TChannelChatUserMessageUpdateEvent:
	var _new = TChannelChatUserMessageUpdateEvent.new()
	_new.broadcaster_user_id = broadcaster_user_id
	_new.broadcaster_user_login = broadcaster_user_login
	_new.broadcaster_user_name = broadcaster_user_name
	_new.user_id = user_id
	_new.user_login = user_login
	_new.user_name = user_name
	_new.status = status
	_new.message_id = message_id
	_new.message = message
	return _new

## Create from object (usually returned from api)
static func from_object(obj: Variant) -> TChannelChatUserMessageUpdateEvent:
	if not obj: return
	if not obj is Dictionary:
		print("[TChannelChatUserMessageUpdateEvent]: Object is not Dictionary: ", obj)
		return

	var _new = TChannelChatUserMessageUpdateEvent.new()

	_new.broadcaster_user_id = obj.get("broadcaster_user_id") if obj.get("broadcaster_user_id") else ""
	_new.broadcaster_user_login = obj.get("broadcaster_user_login") if obj.get("broadcaster_user_login") else ""
	_new.broadcaster_user_name = obj.get("broadcaster_user_name") if obj.get("broadcaster_user_name") else ""
	_new.user_id = obj.get("user_id") if obj.get("user_id") else ""
	_new.user_login = obj.get("user_login") if obj.get("user_login") else ""
	_new.user_name = obj.get("user_name") if obj.get("user_name") else ""
	_new.status = obj.get("status") if obj.get("status") else ""
	_new.message_id = obj.get("message_id") if obj.get("message_id") else ""
	_new.message = [] as Array[TChannelChatUserMessageUpdateEventMessage]
	for o in obj.get("message", []):
		_new.message.append(TChannelChatUserMessageUpdateEventMessage.from_object(o))

	return _new