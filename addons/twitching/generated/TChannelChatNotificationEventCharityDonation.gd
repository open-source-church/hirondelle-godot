extends TBaseType
class_name TChannelChatNotificationEventCharityDonation

## Autogenerated. Do not modify.

## Name of the charity.
var charity_name: String

## An object that contains the amount of money that the user paid.
var amount: TChannelChatNotificationEventAmount

## Create is similar to _init but takes parameters. Useful for using with autocomplete in the editor.
static func create(charity_name: String, amount: TChannelChatNotificationEventAmount) -> TChannelChatNotificationEventCharityDonation:
	var _new = TChannelChatNotificationEventCharityDonation.new()
	_new.charity_name = charity_name
	_new.amount = amount
	return _new

## Create from object (usually returned from api)
static func from_object(obj: Variant) -> TChannelChatNotificationEventCharityDonation:
	if not obj: return
	if not obj is Dictionary:
		print("[TChannelChatNotificationEventCharityDonation]: Object is not Dictionary: ", obj)
		return

	var _new = TChannelChatNotificationEventCharityDonation.new()

	_new.charity_name = obj.get("charity_name") if obj.get("charity_name") else ""
	_new.amount = TChannelChatNotificationEventAmount.from_object(obj.get("amount", {}))

	return _new
