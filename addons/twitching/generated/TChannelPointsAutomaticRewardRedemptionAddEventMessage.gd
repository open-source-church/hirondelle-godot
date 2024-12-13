extends TBaseType
class_name TChannelPointsAutomaticRewardRedemptionAddEventMessage

## Autogenerated. Do not modify.

## The text of the chat message.
var text: String

## An array that includes the emote ID and start and end positions for where the emote appears in the text.
var emotes: Array[TChannelPointsAutomaticRewardRedemptionAddEventEmotes]

## Create is similar to _init but takes parameters. Useful for using with autocomplete in the editor.
static func create(text: String, emotes: Array[TChannelPointsAutomaticRewardRedemptionAddEventEmotes]) -> TChannelPointsAutomaticRewardRedemptionAddEventMessage:
	var _new = TChannelPointsAutomaticRewardRedemptionAddEventMessage.new()
	_new.text = text
	_new.emotes = emotes
	return _new

## Create from object (usually returned from api)
static func from_object(obj: Variant) -> TChannelPointsAutomaticRewardRedemptionAddEventMessage:
	if not obj: return
	if not obj is Dictionary:
		print("[TChannelPointsAutomaticRewardRedemptionAddEventMessage]: Object is not Dictionary: ", obj)
		return

	var _new = TChannelPointsAutomaticRewardRedemptionAddEventMessage.new()

	_new.text = obj.get("text") if obj.get("text") else ""
	_new.emotes = [] as Array[TChannelPointsAutomaticRewardRedemptionAddEventEmotes]
	for o in obj.get("emotes", []):
		_new.emotes.append(TChannelPointsAutomaticRewardRedemptionAddEventEmotes.from_object(o))

	return _new
