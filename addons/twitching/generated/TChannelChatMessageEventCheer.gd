extends TBaseType
class_name TChannelChatMessageEventCheer

## Autogenerated. Do not modify.

## The amount of Bits the user cheered.
var bits: int

## Create is similar to _init but takes parameters. Useful for using with autocomplete in the editor.
static func create(bits: int) -> TChannelChatMessageEventCheer:
	var _new = TChannelChatMessageEventCheer.new()
	_new.bits = bits
	return _new

## Create from object (usually returned from api)
static func from_object(obj: Variant) -> TChannelChatMessageEventCheer:
	if not obj: return
	if not obj is Dictionary:
		print("[TChannelChatMessageEventCheer]: Object is not Dictionary: ", obj)
		return

	var _new = TChannelChatMessageEventCheer.new()

	_new.bits = obj.get("bits") if obj.get("bits") else 0

	return _new