extends TBaseType
class_name TAutomodSettingsUpdateEvent

## Autogenerated. Do not modify.

## The ID of the broadcaster specified in the request.
var broadcaster_user_id: String

## The login of the broadcaster specified in the request.
var broadcaster_user_login: String

## The user name of the broadcaster specified in the request.
var broadcaster_user_name: String

## The ID of the moderator who changed the channel settings.
var moderator_user_id: String

## The moderator’s login.
var moderator_user_login: String

## The moderator’s user name.
var moderator_user_name: String

## The Automod level for hostility involving name calling or insults.
var bullying: int

## The default AutoMod level for the broadcaster. This field is null if the broadcaster has set one or more of the individual settings.
var overall_level: int

## The Automod level for discrimination against disability.
var disability: int

## The Automod level for racial discrimination.
var race_ethnicity_or_religion: int

## The Automod level for discrimination against women.
var misogyny: int

## The AutoMod level for discrimination based on sexuality, sex, or gender.
var sexuality_sex_or_gender: int

## The Automod level for hostility involving aggression.
var aggression: int

## The Automod level for sexual content.
var sex_based_terms: int

## The Automod level for profanity.
var swearing: int

## Create is similar to _init but takes parameters. Useful for using with autocomplete in the editor.
static func create(broadcaster_user_id: String, broadcaster_user_login: String, broadcaster_user_name: String, moderator_user_id: String, moderator_user_login: String, moderator_user_name: String, bullying: int, overall_level: int, disability: int, race_ethnicity_or_religion: int, misogyny: int, sexuality_sex_or_gender: int, aggression: int, sex_based_terms: int, swearing: int) -> TAutomodSettingsUpdateEvent:
	var _new = TAutomodSettingsUpdateEvent.new()
	_new.broadcaster_user_id = broadcaster_user_id
	_new.broadcaster_user_login = broadcaster_user_login
	_new.broadcaster_user_name = broadcaster_user_name
	_new.moderator_user_id = moderator_user_id
	_new.moderator_user_login = moderator_user_login
	_new.moderator_user_name = moderator_user_name
	_new.bullying = bullying
	_new.overall_level = overall_level
	_new.disability = disability
	_new.race_ethnicity_or_religion = race_ethnicity_or_religion
	_new.misogyny = misogyny
	_new.sexuality_sex_or_gender = sexuality_sex_or_gender
	_new.aggression = aggression
	_new.sex_based_terms = sex_based_terms
	_new.swearing = swearing
	return _new

## Create from object (usually returned from api)
static func from_object(obj: Variant) -> TAutomodSettingsUpdateEvent:
	if not obj: return
	if not obj is Dictionary:
		print("[TAutomodSettingsUpdateEvent]: Object is not Dictionary: ", obj)
		return

	var _new = TAutomodSettingsUpdateEvent.new()

	_new.broadcaster_user_id = obj.get("broadcaster_user_id") if obj.get("broadcaster_user_id") else ""
	_new.broadcaster_user_login = obj.get("broadcaster_user_login") if obj.get("broadcaster_user_login") else ""
	_new.broadcaster_user_name = obj.get("broadcaster_user_name") if obj.get("broadcaster_user_name") else ""
	_new.moderator_user_id = obj.get("moderator_user_id") if obj.get("moderator_user_id") else ""
	_new.moderator_user_login = obj.get("moderator_user_login") if obj.get("moderator_user_login") else ""
	_new.moderator_user_name = obj.get("moderator_user_name") if obj.get("moderator_user_name") else ""
	_new.bullying = obj.get("bullying") if obj.get("bullying") else 0
	_new.overall_level = obj.get("overall_level") if obj.get("overall_level") else 0
	_new.disability = obj.get("disability") if obj.get("disability") else 0
	_new.race_ethnicity_or_religion = obj.get("race_ethnicity_or_religion") if obj.get("race_ethnicity_or_religion") else 0
	_new.misogyny = obj.get("misogyny") if obj.get("misogyny") else 0
	_new.sexuality_sex_or_gender = obj.get("sexuality_sex_or_gender") if obj.get("sexuality_sex_or_gender") else 0
	_new.aggression = obj.get("aggression") if obj.get("aggression") else 0
	_new.sex_based_terms = obj.get("sex_based_terms") if obj.get("sex_based_terms") else 0
	_new.swearing = obj.get("swearing") if obj.get("swearing") else 0

	return _new
