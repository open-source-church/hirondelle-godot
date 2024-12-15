extends HBaseNode

static var _title = "OBS Current Scene"
static var _type = "obs/current_scene"
static var _category = "OBS"
static var _icon = "obs"

func _init() -> void:
	title = _title
	type = _type
	PORTS = {
		"changed": HPortFlow.new(E.Side.OUTPUT),
		"program": HPortText.new(E.Side.OUTPUT),
		"preview": HPortText.new(E.Side.OUTPUT),
	}
	G.OBS.current_program_scene_changed.connect(_program_scene_changed)
	G.OBS.current_preview_scene_changed.connect(_preview_scene_changed)
	var _scene = await G.OBS.send_request("GetCurrentProgramScene")
	if _scene:
		PORTS.program.value = _scene.sceneName
	_scene = await G.OBS.send_request("GetCurrentPreviewScene")
	if _scene:
		PORTS.program.value = _scene.sceneName
	G.OBS.scene_list_changed.connect(_update_scene_list)
	var r = await G.OBS.send_request("GetSceneList")
	_update_scene_list(r.scenes)

func _update_scene_list(scenes : Array):
	scenes.reverse()
	PORTS.program.options = scenes.map(func (s): return s.sceneName)
	PORTS.preview.options = scenes.map(func (s): return s.sceneName)

func _program_scene_changed(new_name, _uuid):
	PORTS.program.value = new_name
	emit("changed")
func _preview_scene_changed(new_name, _uuid):
	PORTS.preview.value = new_name
	emit("changed")
