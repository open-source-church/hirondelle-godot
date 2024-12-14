extends TBaseType
class_name TAutomodMessageHoldEventV2Message

## Autogenerated. Do not modify.

## The contents of the message caught by automod.
var text: String

## Metadata surrounding the potential inappropriate fragments of the message.
var fragments: Array[TAutomodMessageHoldEventV2Fragments]

## Create is similar to _init but takes parameters. Useful for using with autocomplete in the editor.
static func create(text: String, fragments: Array[TAutomodMessageHoldEventV2Fragments]) -> TAutomodMessageHoldEventV2Message:
	var _new = TAutomodMessageHoldEventV2Message.new()
	_new.text = text
	_new.fragments = fragments
	return _new

## Create from object (usually returned from api)
static func from_object(obj: Variant) -> TAutomodMessageHoldEventV2Message:
	if not obj: return
	if not obj is Dictionary:
		print("[TAutomodMessageHoldEventV2Message]: Object is not Dictionary: ", obj)
		return

	var _new = TAutomodMessageHoldEventV2Message.new()

	_new.text = obj.get("text") if obj.get("text") else ""
	_new.fragments = [] as Array[TAutomodMessageHoldEventV2Fragments]
	for o in obj.get("fragments", []):
		_new.fragments.append(TAutomodMessageHoldEventV2Fragments.from_object(o))

	return _new