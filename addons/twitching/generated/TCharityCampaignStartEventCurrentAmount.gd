extends TBaseType
class_name TCharityCampaignStartEventCurrentAmount

## Autogenerated. Do not modify.

## The monetary amount. The amount is specified in the currency’s minor unit. For example, the minor units for USD is cents, so if the amount is $5.50 USD,  value  is set to 550.
var value: int

## The number of decimal places used by the currency. For example, USD uses two decimal places. Use this number to translate  value  from minor units to major units by using the formula: value / 10^decimal_places
var decimal_places: int

## The ISO-4217 three-letter currency code that identifies the type of currency in  value .
var currency: String

## Create is similar to _init but takes parameters. Useful for using with autocomplete in the editor.
static func create(value: int, decimal_places: int, currency: String) -> TCharityCampaignStartEventCurrentAmount:
	var _new = TCharityCampaignStartEventCurrentAmount.new()
	_new.value = value
	_new.decimal_places = decimal_places
	_new.currency = currency
	return _new

## Create from object (usually returned from api)
static func from_object(obj: Variant) -> TCharityCampaignStartEventCurrentAmount:
	if not obj: return
	if not obj is Dictionary:
		print("[TCharityCampaignStartEventCurrentAmount]: Object is not Dictionary: ", obj)
		return

	var _new = TCharityCampaignStartEventCurrentAmount.new()

	_new.value = obj.get("value") if obj.get("value") else 0
	_new.decimal_places = obj.get("decimal_places") if obj.get("decimal_places") else 0
	_new.currency = obj.get("currency") if obj.get("currency") else ""

	return _new
