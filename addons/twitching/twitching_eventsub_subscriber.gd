extends Node
class_name TwitchingEventSubSubscriber
## Manages EventSub

# Get user id: https://www.streamweasels.com/tools/convert-twitch-username-%20to-user-id/
# Twitch API reference: https://dev.twitch.tv/docs/api/reference/

var eventsub : TwitchingEventSub

var client : HTTPRequest
var logging := true

const EVENTSUB_URL = "https://api.twitch.tv/helix/eventsub/subscriptions"

signal subscription_completed

var subscription_success : bool
var subscription_id : String
var subscription_list := []

func _ready() -> void:
	eventsub = get_parent()
	client = HTTPRequest.new()
	add_child(client)
	client.request_completed.connect(_on_request_completed)

## Creates and EventSub subscription. Cf. https://dev.twitch.tv/docs/api/reference/#create-eventsub-subscription
## Subscription types: https://dev.twitch.tv/docs/eventsub/eventsub-subscription-types
## Event sub reference: https://dev.twitch.tv/docs/eventsub/eventsub-reference

func subscribe(_name : String, _version := "1", _condition := {}) -> String:
	var request = {
		"type": _name,
		"version": _version,
		"condition": _condition,
		"transport": {
			"method": "websocket",
			"session_id": eventsub.session_id
		}
	}
	client.request(EVENTSUB_URL, eventsub.twitching.auth.get_headers(), HTTPClient.METHOD_POST, JSON.stringify(request))
	await subscription_completed
	return subscription_id

func unsubscribe(id : String) -> bool:
	var request = {
		"id": id,
	}
	client.request(EVENTSUB_URL, eventsub.twitching.auth.get_headers(), HTTPClient.METHOD_DELETE, JSON.stringify(request))
	await subscription_completed
	return subscription_success

func list() -> Array:
	client.request(EVENTSUB_URL, eventsub.twitching.auth.get_headers())
	await subscription_completed
	return subscription_list
	
func unsubscribe_all():
	var _list = await list()
	for c in _list:
		_log(" * Unsubscribing: %s" % c.id)
		await unsubscribe(c.id)
	_log("Done")

func _on_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
	if not result == HTTPRequest.RESULT_SUCCESS:
		return
	
	var response
	if body: response = JSON.parse_string(body.get_string_from_utf8())
	
	_log(response_code)
	_log(response)
	
	# Subscription successful
	if response_code == 202:
		subscription_success = true
		subscription_id = response.get("data", []).front().get("id", "")
		print("Subscription id: ", subscription_id)
	# Unsubscription successful
	elif response_code == 204:
		subscription_success = true
	# List successful
	elif response_code == 200:
		subscription_list = response.data
	else:
		_log(response_code)
		_log(response)
		subscription_success = false
		subscription_id = ""
		subscription_list = []
	
	subscription_completed.emit()

func _log(msg):
	if not logging: return
	# b, i, u, s, indent, code, url, center, right, color, bgcolor, fgcolor
	# black, red, green, yellow, blue, magenta, pink, purple, cyan, white, orange, gray
	print_rich("[color=cyan][i][TwitchingEventSubSubscriber][/i] %s[/color]" % str(msg))
