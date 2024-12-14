extends TBaseType
class_name TChannelUpdateEvent

## Autogenerated. Do not modify.

## The broadcaster’s user ID.
var broadcaster_user_id: String

## The broadcaster’s user login.
var broadcaster_user_login: String

## The broadcaster’s user display name.
var broadcaster_user_name: String

## The channel’s stream title.
var title: String

## The channel’s broadcast language.
var language: String

## The channel’s category ID.
var category_id: String

## The category name.
var category_name: String

## Array of content classification label IDs currently applied on the Channel. To retrieve a list of all possible IDs, use the  Get Content Classification Labels  API endpoint.
var content_classification_labels: Array[String]

## Create is similar to _init but takes parameters. Useful for using with autocomplete in the editor.
static func create(broadcaster_user_id: String, broadcaster_user_login: String, broadcaster_user_name: String, title: String, language: String, category_id: String, category_name: String, content_classification_labels: Array[String]) -> TChannelUpdateEvent:
	var _new = TChannelUpdateEvent.new()
	_new.broadcaster_user_id = broadcaster_user_id
	_new.broadcaster_user_login = broadcaster_user_login
	_new.broadcaster_user_name = broadcaster_user_name
	_new.title = title
	_new.language = language
	_new.category_id = category_id
	_new.category_name = category_name
	_new.content_classification_labels = content_classification_labels
	return _new

## Create from object (usually returned from api)
static func from_object(obj: Variant) -> TChannelUpdateEvent:
	if not obj: return
	if not obj is Dictionary:
		print("[TChannelUpdateEvent]: Object is not Dictionary: ", obj)
		return

	var _new = TChannelUpdateEvent.new()

	_new.broadcaster_user_id = obj.get("broadcaster_user_id") if obj.get("broadcaster_user_id") else ""
	_new.broadcaster_user_login = obj.get("broadcaster_user_login") if obj.get("broadcaster_user_login") else ""
	_new.broadcaster_user_name = obj.get("broadcaster_user_name") if obj.get("broadcaster_user_name") else ""
	_new.title = obj.get("title") if obj.get("title") else ""
	_new.language = obj.get("language") if obj.get("language") else ""
	_new.category_id = obj.get("category_id") if obj.get("category_id") else ""
	_new.category_name = obj.get("category_name") if obj.get("category_name") else ""
	_new.content_classification_labels = [] as Array[String]
	for o in obj.get("content_classification_labels", []):
		_new.content_classification_labels.append(o)

	return _new