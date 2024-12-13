extends TBaseType
class_name TAutomodMessageUpdateEventV2Cheermote

## Autogenerated. Do not modify.

## The name portion of the Cheermote string that you use in chat to cheer Bits. The full Cheermote string is the concatenation of {prefix} + {number of Bits}.    For example , if the prefix is “Cheer” and you want to cheer 100 Bits, the full Cheermote string is Cheer100. When the Cheermote string is entered in chat, Twitch converts it to the image associated with the Bits tier that was cheered.
var prefix: String

## The amount of bits cheered.
var bits: int

## The tier level of the cheermote.
var tier: int

## Create is similar to _init but takes parameters. Useful for using with autocomplete in the editor.
static func create(prefix: String, bits: int, tier: int) -> TAutomodMessageUpdateEventV2Cheermote:
	var _new = TAutomodMessageUpdateEventV2Cheermote.new()
	_new.prefix = prefix
	_new.bits = bits
	_new.tier = tier
	return _new

## Create from object (usually returned from api)
static func from_object(obj: Variant) -> TAutomodMessageUpdateEventV2Cheermote:
	if not obj: return
	if not obj is Dictionary:
		print("[TAutomodMessageUpdateEventV2Cheermote]: Object is not Dictionary: ", obj)
		return

	var _new = TAutomodMessageUpdateEventV2Cheermote.new()

	_new.prefix = obj.get("prefix") if obj.get("prefix") else ""
	_new.bits = obj.get("bits") if obj.get("bits") else 0
	_new.tier = obj.get("tier") if obj.get("tier") else 0

	return _new
