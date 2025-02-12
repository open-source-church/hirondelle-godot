extends TBaseType
class_name THypeTrainProgressEvent

## Autogenerated. Do not modify.

## The Hype Train ID.
var id: String

## The requested broadcaster ID.
var broadcaster_user_id: String

## The requested broadcaster login.
var broadcaster_user_login: String

## The requested broadcaster display name.
var broadcaster_user_name: String

## The current level of the Hype Train.
var level: int

## Total points contributed to the Hype Train.
var total: int

## The number of points contributed to the Hype Train at the current level.
var progress: int

## The number of points required to reach the next level.
var goal: int

## The contributors with the most points contributed.
var top_contributions: TTopContributions

## The most recent contribution.
var last_contribution: TLastContribution

## The time when the Hype Train started.
var started_at: String

## The time when the Hype Train expires. The expiration is extended when the Hype Train reaches a new level.
var expires_at: String

## Indicates if the Hype Train is a Golden Kappa Train.
var is_golden_kappa_train: bool

## Create is similar to _init but takes parameters. Useful for using with autocomplete in the editor.
static func create(id: String, broadcaster_user_id: String, broadcaster_user_login: String, broadcaster_user_name: String, level: int, total: int, progress: int, goal: int, top_contributions: TTopContributions, last_contribution: TLastContribution, started_at: String, expires_at: String, is_golden_kappa_train: bool) -> THypeTrainProgressEvent:
	var _new = THypeTrainProgressEvent.new()
	_new.id = id
	_new.broadcaster_user_id = broadcaster_user_id
	_new.broadcaster_user_login = broadcaster_user_login
	_new.broadcaster_user_name = broadcaster_user_name
	_new.level = level
	_new.total = total
	_new.progress = progress
	_new.goal = goal
	_new.top_contributions = top_contributions
	_new.last_contribution = last_contribution
	_new.started_at = started_at
	_new.expires_at = expires_at
	_new.is_golden_kappa_train = is_golden_kappa_train
	return _new

## Create from object (usually returned from api)
static func from_object(obj: Variant) -> THypeTrainProgressEvent:
	if not obj: return
	if not obj is Dictionary:
		print("[THypeTrainProgressEvent]: Object is not Dictionary: ", obj)
		return

	var _new = THypeTrainProgressEvent.new()

	_new.id = obj.get("id") if obj.get("id") else ""
	_new.broadcaster_user_id = obj.get("broadcaster_user_id") if obj.get("broadcaster_user_id") else ""
	_new.broadcaster_user_login = obj.get("broadcaster_user_login") if obj.get("broadcaster_user_login") else ""
	_new.broadcaster_user_name = obj.get("broadcaster_user_name") if obj.get("broadcaster_user_name") else ""
	_new.level = obj.get("level") if obj.get("level") else 0
	_new.total = obj.get("total") if obj.get("total") else 0
	_new.progress = obj.get("progress") if obj.get("progress") else 0
	_new.goal = obj.get("goal") if obj.get("goal") else 0
	_new.top_contributions = TTopContributions.from_object(obj.get("top_contributions", {}))
	_new.last_contribution = TLastContribution.from_object(obj.get("last_contribution", {}))
	_new.started_at = obj.get("started_at") if obj.get("started_at") else ""
	_new.expires_at = obj.get("expires_at") if obj.get("expires_at") else ""
	_new.is_golden_kappa_train = obj.get("is_golden_kappa_train") if obj.get("is_golden_kappa_train") else null

	return _new
