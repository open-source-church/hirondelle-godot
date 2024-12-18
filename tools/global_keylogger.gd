extends Node
class_name HGlobalKeyLogger

## Global key logger.
## Requires python, and pynput.

static var pid: int = -1
static var running := false

static var server := UDPServer.new()
static var PORT := 9996
static var peer: PacketPeerUDP

signal _key_received(key: String)
static var singleton := HGlobalKeyLogger.new()
static var key_received := Signal(singleton._key_received)

static var keys_pressed := []

static func start():
	if running: return
	
	pid = OS.create_process("python", ["tools/python/udp_keyboard_logger.py"], true)
	print("Started listener with PID: ", pid)
	running = true
	
	server.listen(PORT)
	
	while running:
		server.poll()
		if server.is_connection_available():
			peer = server.take_connection()
		if peer:
			var packet = peer.get_packet()
			if packet:
				var key := packet.get_string_from_utf8()
				var pressed := "pressed" in key
				key = get_key(key)
				if pressed and not key in keys_pressed:
					keys_pressed.append(key)
				elif not pressed and key in keys_pressed:
					keys_pressed.erase(key)
				
				var comb := "+".join(keys_pressed)
				
				singleton.key_received.emit(comb)
		
		await Engine.get_main_loop().process_frame
	
	print("Finished key logging")

static func is_logging():
	return running

static func kill():
	if pid: OS.kill(pid)
	pid = -1
	running = false

static func restart():
	kill()
	start()

static func get_key(key: String):
	if not ":"in key: return ""
	var k = key.split(":")[1]
	k = k.replace("'", "").replace("Key.", "")
	return k

#func _init() -> void:

#func _process(_delta: float) -> void:
