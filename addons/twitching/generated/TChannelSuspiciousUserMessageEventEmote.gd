extends TBaseType
class_name TChannelSuspiciousUserMessageEventEmote

## Autogenerated. Do not modify.

## An ID that uniquely identifies this emote.
var id: String

## An ID that identifies the emote set that the emote belongs to.
var emote_set_id: String

## Create is similar to _init but takes parameters. Useful for using with autocomplete in the editor.
static func create(id: String, emote_set_id: String) -> TChannelSuspiciousUserMessageEventEmote:
	var _new = TChannelSuspiciousUserMessageEventEmote.new()
	_new.id = id
	_new.emote_set_id = emote_set_id
	return _new

## Create from object (usually returned from api)
static func from_object(obj: Variant) -> TChannelSuspiciousUserMessageEventEmote:
	if not obj: return
	if not obj is Dictionary:
		print("[TChannelSuspiciousUserMessageEventEmote]: Object is not Dictionary: ", obj)
		return

	var _new = TChannelSuspiciousUserMessageEventEmote.new()

	_new.id = obj.get("id") if obj.get("id") else ""
	_new.emote_set_id = obj.get("emote_set_id") if obj.get("emote_set_id") else ""

	return _new
