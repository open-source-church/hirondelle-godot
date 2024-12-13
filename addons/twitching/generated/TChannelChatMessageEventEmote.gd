extends TBaseType
class_name TChannelChatMessageEventEmote

## Autogenerated. Do not modify.

## An ID that uniquely identifies this emote.
var id: String

## An ID that identifies the emote set that the emote belongs to.
var emote_set_id: String

## The ID of the broadcaster who owns the emote.
var owner_id: String

## The formats that the emote is available in. For example, if the emote is available only as a static PNG, the array contains only static. But if the emote is available as a static PNG and an animated GIF, the array contains static and animated. The possible formats are:  animated - An animated GIF is available for this emote. static - A static PNG file is available for this emote.
var format: Array[String]

## Create is similar to _init but takes parameters. Useful for using with autocomplete in the editor.
static func create(id: String, emote_set_id: String, owner_id: String, format: Array[String]) -> TChannelChatMessageEventEmote:
	var _new = TChannelChatMessageEventEmote.new()
	_new.id = id
	_new.emote_set_id = emote_set_id
	_new.owner_id = owner_id
	_new.format = format
	return _new

## Create from object (usually returned from api)
static func from_object(obj: Variant) -> TChannelChatMessageEventEmote:
	if not obj: return
	if not obj is Dictionary:
		print("[TChannelChatMessageEventEmote]: Object is not Dictionary: ", obj)
		return

	var _new = TChannelChatMessageEventEmote.new()

	_new.id = obj.get("id") if obj.get("id") else ""
	_new.emote_set_id = obj.get("emote_set_id") if obj.get("emote_set_id") else ""
	_new.owner_id = obj.get("owner_id") if obj.get("owner_id") else ""
	_new.format = [] as Array[String]
	for o in obj.get("format", []):
		_new.format.append(o)

	return _new
