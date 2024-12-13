extends TBaseType
class_name TAutomodMessageUpdateEventV2BlockedTerm

## Autogenerated. Do not modify.

## The list of blocked terms found in the message.
var terms_found: Array[TAutomodMessageUpdateEventV2TermsFound]

## Create is similar to _init but takes parameters. Useful for using with autocomplete in the editor.
static func create(terms_found: Array[TAutomodMessageUpdateEventV2TermsFound]) -> TAutomodMessageUpdateEventV2BlockedTerm:
	var _new = TAutomodMessageUpdateEventV2BlockedTerm.new()
	_new.terms_found = terms_found
	return _new

## Create from object (usually returned from api)
static func from_object(obj: Variant) -> TAutomodMessageUpdateEventV2BlockedTerm:
	if not obj: return
	if not obj is Dictionary:
		print("[TAutomodMessageUpdateEventV2BlockedTerm]: Object is not Dictionary: ", obj)
		return

	var _new = TAutomodMessageUpdateEventV2BlockedTerm.new()

	_new.terms_found = [] as Array[TAutomodMessageUpdateEventV2TermsFound]
	for o in obj.get("terms_found", []):
		_new.terms_found.append(TAutomodMessageUpdateEventV2TermsFound.from_object(o))

	return _new
