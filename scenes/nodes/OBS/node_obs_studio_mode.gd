extends HBaseNode

static var _title = "OBS Studio mode"
static var _type = "obs/studio_mode"
static var _category = "OBS"
static var _icon = "obs"
static var _sources = ["obs"]


var activate := HPortFlow.new(E.Side.INPUT)
var deactivate := HPortFlow.new(E.Side.INPUT)
var changed := HPortFlow.new(E.Side.OUTPUT)
var enabled := HPortBool.new(E.Side.BOTH)

func _init() -> void:
	title = _title
	type = _type
	
	G.OBS.studio_mode_state_changed.connect(_state_changed)

func _state_changed(_enabled):
	enabled.value = _enabled
	changed.emit()

func run(_port : HBasePort) -> void:
	if _port == activate:
		G.OBS.send_request("SetStudioModeEnabled", { "studioModeEnabled" : true })
	if _port == deactivate:
		G.OBS.send_request("SetStudioModeEnabled", { "studioModeEnabled" : false })

func update(_last_changed: HBasePort = null) -> void:
	G.OBS.send_request("SetStudioModeEnabled", { "studioModeEnabled" : enabled.value })
