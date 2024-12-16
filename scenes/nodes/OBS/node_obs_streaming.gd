extends HBaseNode

static var _title = "OBS Streaming"
static var _type = "obs/streaming_status"
static var _category = "OBS"
static var _icon = "obs"


var start := HPortFlow.new(E.Side.INPUT)
var stop := HPortFlow.new(E.Side.INPUT)
var started := HPortFlow.new(E.Side.OUTPUT)
var stopped := HPortFlow.new(E.Side.OUTPUT)
var streaming := HPortBool.new(E.Side.OUTPUT)

func _init() -> void:
	title = _title
	type = _type
	
	G.OBS.stream_state_changed.connect(_state_changed)

func _state_changed(_enabled, _state : String):
	streaming.value = _enabled
	if _enabled: started.emit()
	else: stopped.emit()

func run(_port : HBasePort) -> void:
	if _port == start:
		G.OBS.send_request("StartStream")
	if _port == stop:
		G.OBS.send_request("StopStream")
