extends TBaseType
class_name TAutomodMessageHoldEventV2Boundaries

## Autogenerated. Do not modify.

## Index in the message for the start of the problem (0 indexed, inclusive).
var start_pos: int

## Index in the message for the end of the problem (0 indexed, inclusive).
var end_pos: int

## Create is similar to _init but takes parameters. Useful for using with autocomplete in the editor.
static func create(start_pos: int, end_pos: int) -> TAutomodMessageHoldEventV2Boundaries:
	var _new = TAutomodMessageHoldEventV2Boundaries.new()
	_new.start_pos = start_pos
	_new.end_pos = end_pos
	return _new

## Create from object (usually returned from api)
static func from_object(obj: Variant) -> TAutomodMessageHoldEventV2Boundaries:
	if not obj: return
	if not obj is Dictionary:
		print("[TAutomodMessageHoldEventV2Boundaries]: Object is not Dictionary: ", obj)
		return

	var _new = TAutomodMessageHoldEventV2Boundaries.new()

	_new.start_pos = obj.get("start_pos") if obj.get("start_pos") else 0
	_new.end_pos = obj.get("end_pos") if obj.get("end_pos") else 0

	return _new
