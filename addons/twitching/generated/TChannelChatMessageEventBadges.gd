extends TBaseType
class_name TChannelChatMessageEventBadges

## Autogenerated. Do not modify.

## An ID that identifies this set of chat badges. For example, Bits or Subscriber.
var set_id: String

## An ID that identifies this version of the badge. The ID can be any value. For example, for Bits, the ID is the Bits tier level, but for World of Warcraft, it could be Alliance or Horde.
var id: String

## Contains metadata related to the chat badges in the badges tag. Currently, this tag contains metadata only for subscriber badges, to indicate the number of months the user has been a subscriber.
var info: String

## Create is similar to _init but takes parameters. Useful for using with autocomplete in the editor.
static func create(set_id: String, id: String, info: String) -> TChannelChatMessageEventBadges:
	var _new = TChannelChatMessageEventBadges.new()
	_new.set_id = set_id
	_new.id = id
	_new.info = info
	return _new

## Create from object (usually returned from api)
static func from_object(obj: Variant) -> TChannelChatMessageEventBadges:
	if not obj: return
	if not obj is Dictionary:
		print("[TChannelChatMessageEventBadges]: Object is not Dictionary: ", obj)
		return

	var _new = TChannelChatMessageEventBadges.new()

	_new.set_id = obj.get("set_id") if obj.get("set_id") else ""
	_new.id = obj.get("id") if obj.get("id") else ""
	_new.info = obj.get("info") if obj.get("info") else ""

	return _new
