extends TBaseType
class_name TChannelChatMessageEventMessage

## Autogenerated. Do not modify.

## The chat message in plain text.
var text: String

## Ordered list of chat message fragments.
var fragments: Array[TChannelChatMessageEventFragments]

## Create is similar to _init but takes parameters. Useful for using with autocomplete in the editor.
static func create(text: String, fragments: Array[TChannelChatMessageEventFragments]) -> TChannelChatMessageEventMessage:
	var _new = TChannelChatMessageEventMessage.new()
	_new.text = text
	_new.fragments = fragments
	return _new

## Create from object (usually returned from api)
static func from_object(obj: Variant) -> TChannelChatMessageEventMessage:
	if not obj: return
	if not obj is Dictionary:
		print("[TChannelChatMessageEventMessage]: Object is not Dictionary: ", obj)
		return

	var _new = TChannelChatMessageEventMessage.new()

	_new.text = obj.get("text") if obj.get("text") else ""
	_new.fragments = [] as Array[TChannelChatMessageEventFragments]
	for o in obj.get("fragments", []):
		_new.fragments.append(TChannelChatMessageEventFragments.from_object(o))

	return _new
