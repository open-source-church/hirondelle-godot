extends Node
class_name OBSWebSocket

@export var host = "localhost"
@export var port = 4455
@export var password = "password"
@export var logging = false

signal connected
signal authenticated
signal disconnected
signal message_received(message)
signal event(data)

var socket : WebSocketPeer = WebSocketPeer.new()
var server_url : String = "ws://127.0.0.1:4444"  # Remplace l'adresse et le port selon ta configuration OBS
var _connected := false
var thread: Thread

func _ready() -> void:
	thread = Thread.new()

func connect_obs():
	var err = socket.connect_to_url("ws://%s:%s" % [host, port], TLSOptions.client())
	if err != OK:
		print("Impossible de se connecter au serveur WebSocket.")
		return
	_connected = true
	connected.emit()

func _log(data):
	if logging:
		print(data)

func _process(delta: float) -> void:
	if _connected:
		socket.poll()
		
		var state = socket.get_ready_state()
		if state == WebSocketPeer.STATE_OPEN:
			while socket.get_available_packet_count():
				var msg :Variant = JSON.parse_string(socket.get_packet().get_string_from_utf8())
				process_msg(msg)
		elif state == WebSocketPeer.STATE_CLOSING:
			# Keep polling to achieve proper close.
			pass
		elif state == WebSocketPeer.STATE_CLOSED:
			var code = socket.get_close_code()
			var reason = socket.get_close_reason()
			print("WebSocket closed with code: %d, reason %s. Clean: %s" % [code, reason, code != -1])
			_connected = false
			disconnected.emit()

func process_msg(msg : Variant) -> void:
	_log("Processing message: %s \n" % msg)
	# HELLO WITH AUTH
	if msg.get("op") == 0:
		if msg.d.get("authentication"):
			var challenge = msg.d.authentication.challenge
			var salt = msg.d.authentication.salt
			var combined_secret := "%s%s" % [password, salt]
			var base64_secret := Marshalls.raw_to_base64(combined_secret.sha256_buffer())
			var combined_auth := "%s%s" % [base64_secret, challenge]
			var auth = Marshalls.raw_to_base64(combined_auth.sha256_buffer())
			send_msg(1, {
				"rpcVersion": 1,
				"authentication": auth,
				#"eventSubscriptions": 0
			})
		else:
			send_msg(1, { "rpcVersion": 1 })
	
	## AUTHENTICATED
	if msg.get("op") == 2:
		authenticated.emit()
	# EVENT
	if msg.get("op") == 5:
		event.emit(msg.get("d"))
	# REQUEST
	if msg.get("op") == 7:
		requests[msg.d.requestId] = msg.d
		
func send_msg(op, msg : Dictionary) -> void:
	_log("Sending message - OP %s : %s \n" % [op, msg])
	socket.send_text(JSON.stringify({
		"op": op,
		"d": msg
	}))

var requests = {}
#func send_request(type : String, data := {} ):
	#thread.start(_send_request.bind(type, data))

func send_request(type : String, data := {} ):
	var requestID = "%s-%s" % [Time.get_ticks_msec(), randi()]
	requests[requestID] = null
	send_msg(6, {
		"requestType": type,
		"requestId": requestID,
		"requestData": data
	})
	while requests[requestID] == null:
		await get_tree().create_timer(0.01).timeout
	var r = requests[requestID]
	requests.erase(requestID)
	return r

func wait_for_request(requestID : String):
	while requests[requestID] == null:
		await get_tree().create_timer(0.1).timeout
	
# Thread must be disposed (or "joined"), for portability.
func _exit_tree():
	thread.wait_to_finish()
