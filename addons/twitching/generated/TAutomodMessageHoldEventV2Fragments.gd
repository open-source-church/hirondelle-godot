extends TBaseType
class_name TAutomodMessageHoldEventV2Fragments

## Autogenerated. Do not modify.

## One of three options: text emote cheermote
var type: String

## Message text in a fragment.
var text: String

## Optional. Metadata pertaining to the emote.
var emote: TAutomodMessageHoldEventV2Emote

## Optional. Metadata pertaining to the cheermote.
var cheermote: TAutomodMessageHoldEventV2Cheermote

## Create is similar to _init but takes parameters. Useful for using with autocomplete in the editor.
static func create(type: String, text: String, emote: TAutomodMessageHoldEventV2Emote, cheermote: TAutomodMessageHoldEventV2Cheermote) -> TAutomodMessageHoldEventV2Fragments:
	var _new = TAutomodMessageHoldEventV2Fragments.new()
	_new.type = type
	_new.text = text
	_new.emote = emote
	_new.cheermote = cheermote
	return _new

## Create from object (usually returned from api)
static func from_object(obj: Variant) -> TAutomodMessageHoldEventV2Fragments:
	if not obj: return
	if not obj is Dictionary:
		print("[TAutomodMessageHoldEventV2Fragments]: Object is not Dictionary: ", obj)
		return

	var _new = TAutomodMessageHoldEventV2Fragments.new()

	_new.type = obj.get("type") if obj.get("type") else ""
	_new.text = obj.get("text") if obj.get("text") else ""
	_new.emote = TAutomodMessageHoldEventV2Emote.from_object(obj.get("emote", {}))
	_new.cheermote = TAutomodMessageHoldEventV2Cheermote.from_object(obj.get("cheermote", {}))

	return _new