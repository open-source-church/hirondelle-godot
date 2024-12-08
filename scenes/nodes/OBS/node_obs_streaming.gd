extends HBaseNode

static var _title = "OBS Streaming"
static var _type = "obs/streaming_status"
static var _category = "OBS"
static var _icon = "obs"

func _init() -> void:
	title = _title
	type = _type
	PORTS = {
		"start": HPortFlow.new({
			"type": E.CONNECTION_TYPES.FLOW, 
			"side": INPUT
		}),
		"stop": HPortFlow.new({
			"type": E.CONNECTION_TYPES.FLOW, 
			"side": INPUT
		}),
		"started": HPortFlow.new({
			"type": E.CONNECTION_TYPES.FLOW, 
			"side": OUTPUT
		}),
		"stopped": HPortFlow.new({
			"type": E.CONNECTION_TYPES.FLOW, 
			"side": OUTPUT
		}),
		"streaming": HPortBool.new({
			"type": E.CONNECTION_TYPES.BOOL, 
			"side": OUTPUT
		})
	}
	G.OBS.stream_state_changed.connect(_state_changed)

func _state_changed(_enabled, _state : String):
	PORTS.streaming.value = _enabled
	if _enabled: emit("started")
	else: emit("stopped")

func run(routine:String):
	if routine == "start":
		G.OBS.send_request("StartStream")
	if routine == "stop":
		G.OBS.send_request("StopStream")
