extends HBaseNode

static var _title = "OBS Set current scene"
static var _type = "obs/set_current_scene"
static var _category = "OBS"
static var _icon = "obs"
static var _sources = ["obs"]

var set_program := HPortFlow.new(E.Side.INPUT)
var set_preview := HPortFlow.new(E.Side.INPUT)
var program := HPortText.new(E.Side.INPUT)
var preview := HPortText.new(E.Side.INPUT)

func _init() -> void:
	title = _title
	type = _type
	
	sources_got_active.connect(_retrieve_scene_list)
	G.OBS.scene_list_changed.connect(_update_scene_list)
	
	_retrieve_scene_list()

func _retrieve_scene_list():
	if not sources_active: return
	var r = await G.OBS.send_request("GetSceneList")
	_update_scene_list(r.scenes)

func _update_scene_list(scenes : Array):
	scenes.reverse()
	program.options = scenes.map(func (s): return s.sceneName)
	preview.options = scenes.map(func (s): return s.sceneName)

func run(_port : HBasePort) -> void:
	if _port == set_program:
		G.OBS.send_request("SetCurrentProgramScene", { "sceneName" : program.value })
	if _port == set_preview:
		G.OBS.send_request("SetCurrentPreviewScene", { "sceneName" : preview.value })
