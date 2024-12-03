extends HBaseNode

static var _title = "OBS Studio mode"
static var _type = "obs/studio_mode"

func _init() -> void:
	title = _title
	type = _type
	COMPONENTS = {
		"activate": Port.new({
			"type": G.graph.TYPES.FLOW, 
			"side": INPUT
		}),
		"deactivate": Port.new({
			"type": G.graph.TYPES.FLOW, 
			"side": INPUT
		}),
		"changed": Port.new({
			"type": G.graph.TYPES.FLOW, 
			"side": OUTPUT
		}),
		"enabled": Port.new({
			"type": G.graph.TYPES.BOOL, 
			"side": BOTH
		})
	}
	G.OBS.studio_mode_state_changed.connect(_state_changed)

func _state_changed(_enabled):
	VALS.enabled.value = _enabled
	emit("changed")

func run(routine:String):
	if routine == "activate":
		G.OBS.send_request("SetStudioModeEnabled", { "studioModeEnabled" : true })
	if routine == "deactivate":
		G.OBS.send_request("SetStudioModeEnabled", { "studioModeEnabled" : false })

func update() -> void:
	G.OBS.send_request("SetStudioModeEnabled", { "studioModeEnabled" : VALS.enabled.value })
