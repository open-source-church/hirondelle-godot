extends TBaseType
class_name TChannelPredictionBeginEvent

## Autogenerated. Do not modify.

## Channel Points Prediction ID.
var id: String

## The requested broadcaster ID.
var broadcaster_user_id: String

## The requested broadcaster login.
var broadcaster_user_login: String

## The requested broadcaster display name.
var broadcaster_user_name: String

## Title for the Channel Points Prediction.
var title: String

## An array of outcomes for the Channel Points Prediction.
var outcomes: TOutcomes

## The time the Channel Points Prediction started.
var started_at: String

## The time the Channel Points Prediction will automatically lock.
var locks_at: String

## Create is similar to _init but takes parameters. Useful for using with autocomplete in the editor.
static func create(id: String, broadcaster_user_id: String, broadcaster_user_login: String, broadcaster_user_name: String, title: String, outcomes: TOutcomes, started_at: String, locks_at: String) -> TChannelPredictionBeginEvent:
	var _new = TChannelPredictionBeginEvent.new()
	_new.id = id
	_new.broadcaster_user_id = broadcaster_user_id
	_new.broadcaster_user_login = broadcaster_user_login
	_new.broadcaster_user_name = broadcaster_user_name
	_new.title = title
	_new.outcomes = outcomes
	_new.started_at = started_at
	_new.locks_at = locks_at
	return _new

## Create from object (usually returned from api)
static func from_object(obj: Variant) -> TChannelPredictionBeginEvent:
	if not obj: return
	if not obj is Dictionary:
		print("[TChannelPredictionBeginEvent]: Object is not Dictionary: ", obj)
		return

	var _new = TChannelPredictionBeginEvent.new()

	_new.id = obj.get("id") if obj.get("id") else ""
	_new.broadcaster_user_id = obj.get("broadcaster_user_id") if obj.get("broadcaster_user_id") else ""
	_new.broadcaster_user_login = obj.get("broadcaster_user_login") if obj.get("broadcaster_user_login") else ""
	_new.broadcaster_user_name = obj.get("broadcaster_user_name") if obj.get("broadcaster_user_name") else ""
	_new.title = obj.get("title") if obj.get("title") else ""
	_new.outcomes = TOutcomes.from_object(obj.get("outcomes", {}))
	_new.started_at = obj.get("started_at") if obj.get("started_at") else ""
	_new.locks_at = obj.get("locks_at") if obj.get("locks_at") else ""

	return _new