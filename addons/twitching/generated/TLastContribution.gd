extends TBaseType
class_name TLastContribution

## Autogenerated. Do not modify.

## The ID of the user that made the contribution.
var user_id: String

## The user’s login name.
var user_login: String

## The user’s display name.
var user_name: String

## The contribution method used. Possible values are:   bits  — Cheering with Bits. subscription  — Subscription activity like subscribing or gifting subscriptions. other  — Covers other contribution methods not listed.
var type: String

## The total amount contributed. If  type  is  bits ,  total  represents the amount of Bits used. If  type  is  subscription ,  total  is 500, 1000, or 2500 to represent tier 1, 2, or 3 subscriptions, respectively.
var total: int

## Create is similar to _init but takes parameters. Useful for using with autocomplete in the editor.
static func create(user_id: String, user_login: String, user_name: String, type: String, total: int) -> TLastContribution:
	var _new = TLastContribution.new()
	_new.user_id = user_id
	_new.user_login = user_login
	_new.user_name = user_name
	_new.type = type
	_new.total = total
	return _new

## Create from object (usually returned from api)
static func from_object(obj: Variant) -> TLastContribution:
	if not obj: return
	if not obj is Dictionary:
		print("[TLastContribution]: Object is not Dictionary: ", obj)
		return

	var _new = TLastContribution.new()

	_new.user_id = obj.get("user_id") if obj.get("user_id") else ""
	_new.user_login = obj.get("user_login") if obj.get("user_login") else ""
	_new.user_name = obj.get("user_name") if obj.get("user_name") else ""
	_new.type = obj.get("type") if obj.get("type") else ""
	_new.total = obj.get("total") if obj.get("total") else 0

	return _new