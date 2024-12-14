extends TBaseType
class_name TImage

## Autogenerated. Do not modify.

## URL for the image at 1x size.
var url_1x: String

## URL for the image at 2x size.
var url_2x: String

## URL for the image at 4x size.
var url_4x: String

## Create is similar to _init but takes parameters. Useful for using with autocomplete in the editor.
static func create(url_1x: String, url_2x: String, url_4x: String) -> TImage:
	var _new = TImage.new()
	_new.url_1x = url_1x
	_new.url_2x = url_2x
	_new.url_4x = url_4x
	return _new

## Create from object (usually returned from api)
static func from_object(obj: Variant) -> TImage:
	if not obj: return
	if not obj is Dictionary:
		print("[TImage]: Object is not Dictionary: ", obj)
		return

	var _new = TImage.new()

	_new.url_1x = obj.get("url_1x") if obj.get("url_1x") else ""
	_new.url_2x = obj.get("url_2x") if obj.get("url_2x") else ""
	_new.url_4x = obj.get("url_4x") if obj.get("url_4x") else ""

	return _new