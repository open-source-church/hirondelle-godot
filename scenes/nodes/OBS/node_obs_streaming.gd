extends HBaseNode

static var _title = "OBS Streaming"
static var _type = "obs/streaming_status"

func _init() -> void:
	title = _title
	type = _type
	COMPONENTS = {
		"start": Port.new({
			"type": G.graph.TYPES.FLOW, 
			"side": INPUT
		}),
		"stop": Port.new({
			"type": G.graph.TYPES.FLOW, 
			"side": INPUT
		}),
		"started": Port.new({
			"type": G.graph.TYPES.FLOW, 
			"side": OUTPUT
		}),
		"stopped": Port.new({
			"type": G.graph.TYPES.FLOW, 
			"side": OUTPUT
		}),
		"streaming": Port.new({
			"type": G.graph.TYPES.BOOL, 
			"side": OUTPUT
		})
	}
	G.OBS.stream_state_changed.connect(_state_changed)

func _state_changed(_enabled, _state : String):
	VALS.streaming.value = _enabled
	if _enabled: emit("started")
	else: emit("stopped")

func run(routine:String):
	if routine == "start":
		G.OBS.send_request("StartStream")
	if routine == "stop":
		G.OBS.send_request("StopStream")
