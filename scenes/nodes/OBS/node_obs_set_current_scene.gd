extends HBaseNode

static var _title = "OBS Set current scene"
static var _type = "obs/set_current_scene"
static var _category = "OBS"
static var _icon = "obs"

func _init() -> void:
	title = _title
	type = _type
	PORTS = {
		"set_program": HPortFlow.new(E.Side.INPUT),
		"set_preview": HPortFlow.new(E.Side.INPUT),
		"program": HPortText.new(E.Side.INPUT),
		"preview": HPortText.new(E.Side.INPUT),
	}
	
	G.OBS.scene_list_changed.connect(_update_scene_list)
	var r = await G.OBS.send_request("GetSceneList")
	_update_scene_list(r.scenes)

func _update_scene_list(scenes : Array):
	scenes.reverse()
	PORTS.program.options = scenes.map(func (s): return s.sceneName)
	PORTS.preview.options = scenes.map(func (s): return s.sceneName)

func run(routine:String):
	if routine == "set_program":
		G.OBS.send_request("SetCurrentProgramScene", { "sceneName" : PORTS.program.value })
	if routine == "set_preview":
		G.OBS.send_request("SetCurrentPreviewScene", { "sceneName" : PORTS.preview.value })
