extends Node
class_name TwitchingEventSub
## Manages EventSub

var twitching : Twitching
var socket := WebSocketPeer.new()
var subscriber : TwitchingEventSubSubscriber
var session_id : String

const EVENTSUB_URL = "wss://eventsub.wss.twitch.tv/ws"

func _init(_twitching: Twitching):
	twitching = _twitching

func _ready() -> void:
	subscriber = TwitchingEventSubSubscriber.new()
	add_child(subscriber)
	
	#connect_websocket()

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
			print("Packet: ", msg)
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
		
		var _list = await subscriber.list()
		print(JSON.stringify(_list, ""))
		#var id = await subscriber.subscribe("channel.chat.message", "1", {
			#"broadcaster_user_id" : "499044140",
			#"user_id": "499044140",
		#})
		#print("Subscription success? ", id)
		#var r = await subscriber.unsubscribe("358908d6-1bbb-4f48-a1d2-64abaa1bd5b7")
		#print("Unsubscription success? ", r)
		#subscriber.unsubscribe_all()
