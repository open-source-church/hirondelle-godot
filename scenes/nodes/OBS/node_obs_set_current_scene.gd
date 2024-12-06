extends HBaseNode

static var _title = "OBS Set current scene"
static var _type = "obs/set_current_scene"
static var _category = "OBS"
static var _icon = "obs"

func _init() -> void:
	title = _title
	type = _type
	VALS = {
		"set_program": HPortFlow.new({
			"type": G.graph.TYPES.FLOW, 
			"side": INPUT
		}),
		"set_preview": HPortFlow.new({
			"type": G.graph.TYPES.FLOW, 
			"side": INPUT
		}),
		"program": HPortText.new({
			"type": G.graph.TYPES.TEXT, 
			"side": INPUT,
		}),
		"preview": HPortText.new({
			"type": G.graph.TYPES.TEXT, 
			"side": INPUT
		}),
	}
	
	G.OBS.scene_list_changed.connect(_update_scene_list)
	var r = await G.OBS.send_request("GetSceneList")
	_update_scene_list(r.scenes)

func _update_scene_list(scenes : Array):
	scenes.reverse()
	VALS.program.options = scenes.map(func (s): return s.sceneName)
	VALS.preview.options = scenes.map(func (s): return s.sceneName)

func run(routine:String):
	if routine == "set_program":
		G.OBS.send_request("SetCurrentProgramScene", { "sceneName" : VALS.program.value })
	if routine == "set_preview":
		G.OBS.send_request("SetCurrentPreviewScene", { "sceneName" : VALS.preview.value })

func update() -> void:
	pass
