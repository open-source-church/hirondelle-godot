extends HBaseNode

static var _title = "OBS Current Scene"
static var _type = "obs/current_scene"

func _init() -> void:
	title = _title
	type = _type
	COMPONENTS = {
		"changed": Port.new({
			"type": G.graph.TYPES.FLOW, 
			"side": OUTPUT
		}),
		"program": Port.new({
			"type": G.graph.TYPES.TEXT, 
			"side": OUTPUT
		}),
		"preview": Port.new({
			"type": G.graph.TYPES.TEXT, 
			"side": OUTPUT
		}),
	}
	G.OBS.current_program_scene_changed.connect(_program_scene_changed)
	G.OBS.current_preview_scene_changed.connect(_preview_scene_changed)

func _program_scene_changed(new_name, _uuid):
	VALS.program.value = new_name
	emit("changed")
func _preview_scene_changed(new_name, _uuid):
	VALS.preview.value = new_name
	emit("changed")

func update() -> void:
	pass
