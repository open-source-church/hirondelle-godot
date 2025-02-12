extends TBaseType
class_name TMessage

## Autogenerated. Do not modify.

## The text of the resubscription chat message.
var text: String

## An array that includes the emote ID and start and end positions for where the emote appears in the text.
var emotes: TEmotes

## Create is similar to _init but takes parameters. Useful for using with autocomplete in the editor.
static func create(text: String, emotes: TEmotes) -> TMessage:
	var _new = TMessage.new()
	_new.text = text
	_new.emotes = emotes
	return _new

## Create from object (usually returned from api)
static func from_object(obj: Variant) -> TMessage:
	if not obj: return
	if not obj is Dictionary:
		print("[TMessage]: Object is not Dictionary: ", obj)
		return

	var _new = TMessage.new()

	_new.text = obj.get("text") if obj.get("text") else ""
	_new.emotes = TEmotes.from_object(obj.get("emotes", {}))

	return _new
