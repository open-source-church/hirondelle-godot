extends TBaseType
class_name TChannelPollProgressEvent

## Autogenerated. Do not modify.

## ID of the poll.
var id: String

## The requested broadcaster ID.
var broadcaster_user_id: String

## The requested broadcaster login.
var broadcaster_user_login: String

## The requested broadcaster display name.
var broadcaster_user_name: String

## Question displayed for the poll.
var title: String

## An array of choices for the poll. Includes vote counts.
var choices: TChoices

## Not supported.
var bits_voting: TBitsVoting

## The Channel Points voting settings for the poll.
var channel_points_voting: TChannelPointsVoting

## The time the poll started.
var started_at: String

## The time the poll will end.
var ends_at: String

## Create is similar to _init but takes parameters. Useful for using with autocomplete in the editor.
static func create(id: String, broadcaster_user_id: String, broadcaster_user_login: String, broadcaster_user_name: String, title: String, choices: TChoices, bits_voting: TBitsVoting, channel_points_voting: TChannelPointsVoting, started_at: String, ends_at: String) -> TChannelPollProgressEvent:
	var _new = TChannelPollProgressEvent.new()
	_new.id = id
	_new.broadcaster_user_id = broadcaster_user_id
	_new.broadcaster_user_login = broadcaster_user_login
	_new.broadcaster_user_name = broadcaster_user_name
	_new.title = title
	_new.choices = choices
	_new.bits_voting = bits_voting
	_new.channel_points_voting = channel_points_voting
	_new.started_at = started_at
	_new.ends_at = ends_at
	return _new

## Create from object (usually returned from api)
static func from_object(obj: Variant) -> TChannelPollProgressEvent:
	if not obj: return
	if not obj is Dictionary:
		print("[TChannelPollProgressEvent]: Object is not Dictionary: ", obj)
		return

	var _new = TChannelPollProgressEvent.new()

	_new.id = obj.get("id") if obj.get("id") else ""
	_new.broadcaster_user_id = obj.get("broadcaster_user_id") if obj.get("broadcaster_user_id") else ""
	_new.broadcaster_user_login = obj.get("broadcaster_user_login") if obj.get("broadcaster_user_login") else ""
	_new.broadcaster_user_name = obj.get("broadcaster_user_name") if obj.get("broadcaster_user_name") else ""
	_new.title = obj.get("title") if obj.get("title") else ""
	_new.choices = TChoices.from_object(obj.get("choices", {}))
	_new.bits_voting = TBitsVoting.from_object(obj.get("bits_voting", {}))
	_new.channel_points_voting = TChannelPointsVoting.from_object(obj.get("channel_points_voting", {}))
	_new.started_at = obj.get("started_at") if obj.get("started_at") else ""
	_new.ends_at = obj.get("ends_at") if obj.get("ends_at") else ""

	return _new