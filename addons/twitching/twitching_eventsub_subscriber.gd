extends Node
class_name TwitchingEventSubSubscriber
## Manages EventSub

# Get user id: https://www.streamweasels.com/tools/convert-twitch-username-%20to-user-id/
# Twitch API reference: https://dev.twitch.tv/docs/api/reference/

var twitching : Twitching

var client : HTTPRequest
var logging := true

const EVENTSUB_URL = "eventsub/subscriptions"

func _init(_twitching: Twitching):
	twitching = _twitching

func _ready() -> void:
	client = HTTPRequest.new()
	add_child(client)

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
			"session_id": twitching.eventsub.session_id
		}
	}
	var r = await twitching.request.POST(EVENTSUB_URL, request)
	if r.response_code == 202:
		return r.response.data[0].id
	else:
		_log("Subscribe error:")
		_log(r)
		return ""

func unsubscribe(id : String) -> bool:
	var request = {
		"id": id,
	}
	var r = await twitching.request.DELETE(EVENTSUB_URL, request)
	if r.response_code == 204:
		return true
	else:
		_log("Unsubscribe error:")
		_log(r)
		return false

func list() -> Array:
	var r = await twitching.request.GET(EVENTSUB_URL)
	if r.response_code == 200:
		return r.response.data
	else:
		_log("List error:")
		_log(r)
		return []
	
func unsubscribe_all():
	var _list = await list()
	for c in _list:
		_log(" * Unsubscribing: %s" % c.id)
		await unsubscribe(c.id)
	_log("Done")

func _log(msg):
	if not logging: return
	# b, i, u, s, indent, code, url, center, right, color, bgcolor, fgcolor
	# black, red, green, yellow, blue, magenta, pink, purple, cyan, white, orange, gray
	print_rich("[color=cyan][i][TwitchingEventSubSubscriber][/i] %s[/color]" % str(msg))
