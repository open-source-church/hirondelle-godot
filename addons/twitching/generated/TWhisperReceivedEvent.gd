extends TBaseType
class_name TWhisperReceivedEvent

## Autogenerated. Do not modify.

## The ID of the user sending the message.
var from_user_id: String

## The name of the user sending the message.
var from_user_name: String

## The login of the user sending the message.
var from_user_login: String

## The ID of the user receiving the message.
var to_user_id: String

## The name of the user receiving the message.
var to_user_name: String

## The login of the user receiving the message.
var to_user_login: String

## The whisper ID.
var whisper_id: String

## Object containing whisper information.
var whisper: TWhisperReceivedEventWhisper

## Create is similar to _init but takes parameters. Useful for using with autocomplete in the editor.
static func create(from_user_id: String, from_user_name: String, from_user_login: String, to_user_id: String, to_user_name: String, to_user_login: String, whisper_id: String, whisper: TWhisperReceivedEventWhisper) -> TWhisperReceivedEvent:
	var _new = TWhisperReceivedEvent.new()
	_new.from_user_id = from_user_id
	_new.from_user_name = from_user_name
	_new.from_user_login = from_user_login
	_new.to_user_id = to_user_id
	_new.to_user_name = to_user_name
	_new.to_user_login = to_user_login
	_new.whisper_id = whisper_id
	_new.whisper = whisper
	return _new

## Create from object (usually returned from api)
static func from_object(obj: Variant) -> TWhisperReceivedEvent:
	if not obj: return
	if not obj is Dictionary:
		print("[TWhisperReceivedEvent]: Object is not Dictionary: ", obj)
		return

	var _new = TWhisperReceivedEvent.new()

	_new.from_user_id = obj.get("from_user_id") if obj.get("from_user_id") else ""
	_new.from_user_name = obj.get("from_user_name") if obj.get("from_user_name") else ""
	_new.from_user_login = obj.get("from_user_login") if obj.get("from_user_login") else ""
	_new.to_user_id = obj.get("to_user_id") if obj.get("to_user_id") else ""
	_new.to_user_name = obj.get("to_user_name") if obj.get("to_user_name") else ""
	_new.to_user_login = obj.get("to_user_login") if obj.get("to_user_login") else ""
	_new.whisper_id = obj.get("whisper_id") if obj.get("whisper_id") else ""
	_new.whisper = TWhisperReceivedEventWhisper.from_object(obj.get("whisper", {}))

	return _new
