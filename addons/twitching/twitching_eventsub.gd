extends Node
class_name TwitchingEventSub
## Manages EventSub

var twitching : Twitching

var socket := WebSocketPeer.new()

const EVENTSUB_URL = "wss://eventsub.wss.twitch.tv/ws"

func _ready() -> void:
	twitching = owner
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
			print("Packet: ", socket.get_packet())
	elif state == WebSocketPeer.STATE_CLOSING:
		# Keep polling to achieve proper close.
		pass
	elif state == WebSocketPeer.STATE_CLOSED:
		var code = socket.get_close_code()
		var reason = socket.get_close_reason()
		print("WebSocket closed with code: %d, reason %s. Clean: %s" % [code, reason, code != -1])
		set_process(false) # Stop processing.
