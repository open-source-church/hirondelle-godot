extends TBaseType
class_name TProduct

## Autogenerated. Do not modify.

## Product name.
var name: String

## Bits involved in the transaction.
var bits: int

## Unique identifier for the product acquired.
var sku: String

## Flag indicating if the product is in development. If  in_development  is true,  bits  will be 0.
var in_development: bool

## Create is similar to _init but takes parameters. Useful for using with autocomplete in the editor.
static func create(name: String, bits: int, sku: String, in_development: bool) -> TProduct:
	var _new = TProduct.new()
	_new.name = name
	_new.bits = bits
	_new.sku = sku
	_new.in_development = in_development
	return _new

## Create from object (usually returned from api)
static func from_object(obj: Variant) -> TProduct:
	if not obj: return
	if not obj is Dictionary:
		print("[TProduct]: Object is not Dictionary: ", obj)
		return

	var _new = TProduct.new()

	_new.name = obj.get("name") if obj.get("name") else ""
	_new.bits = obj.get("bits") if obj.get("bits") else 0
	_new.sku = obj.get("sku") if obj.get("sku") else ""
	_new.in_development = obj.get("in_development") if obj.get("in_development") else null

	return _new
