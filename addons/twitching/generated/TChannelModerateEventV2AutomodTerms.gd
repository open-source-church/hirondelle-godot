extends TBaseType
class_name TChannelModerateEventV2AutomodTerms

## Autogenerated. Do not modify.

## Either “add” or “remove”.
var action: String

## Either “blocked” or “permitted”.
var list: String

## Terms being added or removed.
var terms: Array[String]

## Whether the terms were added due to an Automod message approve/deny action.
var from_automod: bool

## Create is similar to _init but takes parameters. Useful for using with autocomplete in the editor.
static func create(action: String, list: String, terms: Array[String], from_automod: bool) -> TChannelModerateEventV2AutomodTerms:
	var _new = TChannelModerateEventV2AutomodTerms.new()
	_new.action = action
	_new.list = list
	_new.terms = terms
	_new.from_automod = from_automod
	return _new

## Create from object (usually returned from api)
static func from_object(obj: Variant) -> TChannelModerateEventV2AutomodTerms:
	if not obj: return
	if not obj is Dictionary:
		print("[TChannelModerateEventV2AutomodTerms]: Object is not Dictionary: ", obj)
		return

	var _new = TChannelModerateEventV2AutomodTerms.new()

	_new.action = obj.get("action") if obj.get("action") else ""
	_new.list = obj.get("list") if obj.get("list") else ""
	_new.terms = [] as Array[String]
	for o in obj.get("terms", []):
		_new.terms.append(o)
	_new.from_automod = obj.get("from_automod") if obj.get("from_automod") else null

	return _new
