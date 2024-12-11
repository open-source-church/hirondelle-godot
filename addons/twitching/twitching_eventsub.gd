extends Node
class_name TwitchingEventSub
## Manages EventSub

var twitching : Twitching
var socket := WebSocketPeer.new()
var subscriber : TwitchingEventSubSubscriber
var session_id : String

const EVENTSUB_URL = "wss://eventsub.wss.twitch.tv/ws"

# Settings
var auto_connect := true

func _init(_twitching: Twitching):
	twitching = _twitching

func _ready() -> void:
	subscriber = TwitchingEventSubSubscriber.new(twitching)
	add_child(subscriber)
	
	if auto_connect:
		connect_websocket()

func connect_websocket() -> void:
	print("Connecting websocket")
	set_process(true)
	socket.connect_to_url(EVENTSUB_URL)

func disconnect_websocket() -> void:
	print("Disonnecting websocket")
	socket.close()

func _process(delta):
	socket.poll()
	var state = socket.get_ready_state()
	if state == WebSocketPeer.STATE_OPEN:
		while socket.get_available_packet_count():
			var msg = JSON.parse_string(socket.get_packet().get_string_from_utf8())
			treat_twitch_message(msg)
	
	elif state == WebSocketPeer.STATE_CLOSING:
		# Keep polling to achieve proper close.
		pass
	elif state == WebSocketPeer.STATE_CLOSED:
		var code = socket.get_close_code()
		var reason = socket.get_close_reason()
		print("WebSocket closed with code: %d, reason %s. Clean: %s" % [code, reason, code != -1])
		session_id = ""
		set_process(false) # Stop processing.

## Treats twitch websocket messages. See https://dev.twitch.tv/docs/eventsub/handling-websocket-events/
func treat_twitch_message(msg : Dictionary):
	var msg_type = msg.get("metadata", {}).get("message_type", "")
	if msg_type == "session_welcome":
		session_id = msg.get("payload", {}).get("session", {}).get("id", "")
		
		create_subscriptions()
	
	elif msg_type == "session_keepalive":
		# Everything alright
		pass
	
	else:
		print("[EventSub] Websocket message:", msg)

func create_subscriptions():
	# Unsubscribe all, because past subscriptions are still in memory
	await subscriber.unsubscribe_all()
	# Channel read message
	await subscriber.subscribe("channel.chat.message", "1", {
		"broadcaster_user_id" : "499044140",
		"user_id": "499044140",
	})
	
