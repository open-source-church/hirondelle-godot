extends TBaseType
class_name TWhisperReceivedEventWhisper

## Autogenerated. Do not modify.

## The body of the whisper message.
var text: String

## Create is similar to _init but takes parameters. Useful for using with autocomplete in the editor.
static func create(text: String) -> TWhisperReceivedEventWhisper:
	var _new = TWhisperReceivedEventWhisper.new()
	_new.text = text
	return _new

## Create from object (usually returned from api)
static func from_object(obj: Variant) -> TWhisperReceivedEventWhisper:
	if not obj: return
	if not obj is Dictionary:
		print("[TWhisperReceivedEventWhisper]: Object is not Dictionary: ", obj)
		return

	var _new = TWhisperReceivedEventWhisper.new()

	_new.text = obj.get("text") if obj.get("text") else ""

	return _new
