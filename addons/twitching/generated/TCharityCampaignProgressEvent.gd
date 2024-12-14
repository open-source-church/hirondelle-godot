extends TBaseType
class_name TCharityCampaignProgressEvent

## Autogenerated. Do not modify.

## An ID that identifies the charity campaign.
var id: String

## An ID that identifies the broadcaster that’s running the campaign.
var broadcaster_id: String

## The broadcaster’s login name.
var broadcaster_login: String

## The broadcaster’s display name.
var broadcaster_name: String

## The charity’s name.
var charity_name: String

## A description of the charity.
var charity_description: String

## A URL to an image of the charity’s logo. The image’s type is PNG and its size is 100px X 100px.
var charity_logo: String

## A URL to the charity’s website.
var charity_website: String

## An object that contains the current amount of donations that the campaign has received.
var current_amount: TCharityCampaignProgressEventCurrentAmount

## An object that contains the campaign’s target fundraising goal.
var target_amount: TCharityCampaignProgressEventTargetAmount

## Create is similar to _init but takes parameters. Useful for using with autocomplete in the editor.
static func create(id: String, broadcaster_id: String, broadcaster_login: String, broadcaster_name: String, charity_name: String, charity_description: String, charity_logo: String, charity_website: String, current_amount: TCharityCampaignProgressEventCurrentAmount, target_amount: TCharityCampaignProgressEventTargetAmount) -> TCharityCampaignProgressEvent:
	var _new = TCharityCampaignProgressEvent.new()
	_new.id = id
	_new.broadcaster_id = broadcaster_id
	_new.broadcaster_login = broadcaster_login
	_new.broadcaster_name = broadcaster_name
	_new.charity_name = charity_name
	_new.charity_description = charity_description
	_new.charity_logo = charity_logo
	_new.charity_website = charity_website
	_new.current_amount = current_amount
	_new.target_amount = target_amount
	return _new

## Create from object (usually returned from api)
static func from_object(obj: Variant) -> TCharityCampaignProgressEvent:
	if not obj: return
	if not obj is Dictionary:
		print("[TCharityCampaignProgressEvent]: Object is not Dictionary: ", obj)
		return

	var _new = TCharityCampaignProgressEvent.new()

	_new.id = obj.get("id") if obj.get("id") else ""
	_new.broadcaster_id = obj.get("broadcaster_id") if obj.get("broadcaster_id") else ""
	_new.broadcaster_login = obj.get("broadcaster_login") if obj.get("broadcaster_login") else ""
	_new.broadcaster_name = obj.get("broadcaster_name") if obj.get("broadcaster_name") else ""
	_new.charity_name = obj.get("charity_name") if obj.get("charity_name") else ""
	_new.charity_description = obj.get("charity_description") if obj.get("charity_description") else ""
	_new.charity_logo = obj.get("charity_logo") if obj.get("charity_logo") else ""
	_new.charity_website = obj.get("charity_website") if obj.get("charity_website") else ""
	_new.current_amount = TCharityCampaignProgressEventCurrentAmount.from_object(obj.get("current_amount", {}))
	_new.target_amount = TCharityCampaignProgressEventTargetAmount.from_object(obj.get("target_amount", {}))

	return _new