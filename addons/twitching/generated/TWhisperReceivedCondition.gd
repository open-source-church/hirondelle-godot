extends TBaseType
class_name TWhisperReceivedCondition

## Autogenerated. Do not modify.

## The user_id of the person receiving whispers.
var user_id: String

## Create is similar to _init but takes parameters. Useful for using with autocomplete in the editor.
static func create(user_id: String) -> TWhisperReceivedCondition:
	var _new = TWhisperReceivedCondition.new()
	_new.user_id = user_id
	return _new

## Create from object (usually returned from api)
static func from_object(obj: Variant) -> TWhisperReceivedCondition:
	if not obj: return
	if not obj is Dictionary:
		print("[TWhisperReceivedCondition]: Object is not Dictionary: ", obj)
		return

	var _new = TWhisperReceivedCondition.new()

	_new.user_id = obj.get("user_id") if obj.get("user_id") else ""

	return _new
