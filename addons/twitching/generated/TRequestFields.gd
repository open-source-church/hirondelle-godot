extends TBaseType
class_name TRequestFields

## Autogenerated. Do not modify.

## The subscription type name.
var type: String

## The subscription type version:  1 .
var version: String

## Subscription-specific parameters. The parameters inside this object differ by subscription type and may differ by version.
var condition: TBaseType

## Transport-specific parameters.
var transport: TTransport

## Create is similar to _init but takes parameters. Useful for using with autocomplete in the editor.
static func create(type: String, version: String, condition: None, transport: TTransport) -> TRequestFields:
	var _new = TRequestFields.new()
	_new.type = type
	_new.version = version
	_new.condition = condition
	_new.transport = transport
	return _new

## Create from object (usually returned from api)
static func from_object(obj: Variant) -> TRequestFields:
	if not obj: return
	if not obj is Dictionary:
		print("[TRequestFields]: Object is not Dictionary: ", obj)
		return

	var _new = TRequestFields.new()

	_new.type = obj.get("type") if obj.get("type") else ""
	_new.version = obj.get("version") if obj.get("version") else ""
	_new.condition = obj.get("condition") if obj.get("condition") else null
	_new.transport = TTransport.from_object(obj.get("transport", {}))

	return _new
