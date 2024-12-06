extends HBaseNode

static var _title = "Progress Bar"
static var _type = "window/progress_bar"
static var _category = "Window"
static var _icon = "progressbar"

var ID : int

func _init() -> void:
	title = _title
	type = _type
	VALS = {
		"show": HPortFlow.new({
			"type": G.graph.TYPES.FLOW, 
			"side": INPUT
		}),
		"hide": HPortFlow.new({
			"type": G.graph.TYPES.FLOW, 
			"side": INPUT
		}),
		"percentage": HPortIntSlider.new({
			"type": G.graph.TYPES.INT, 
			"side": INPUT,
			"params": { "min": 0, "max": 100 }
		}),
		"pos": HPortVec2.new({
			"type": G.graph.TYPES.VEC2,
			"default": Vector2(0, 0), 
			"side": INPUT,
		}),
		"size": HPortVec2.new({
			"type": G.graph.TYPES.VEC2, 
			"default": Vector2(500, 30),
			"side": INPUT
		}),
		"color": HPortColor.new({
			"type": G.graph.TYPES.COLOR, 
			"default": Color.PURPLE,
			"side": INPUT
		}),
		"background": HPortColor.new({
			"type": G.graph.TYPES.COLOR, 
			"default": Color.GRAY,
			"side": INPUT
		}),
		"visible": HPortBool.new({
			"type": G.graph.TYPES.BOOL, 
			"default": false,
			"side": INPUT
		}),
	}
	ID = randi()

func update_progressbar():
	var opt = {
		"x": VALS.pos.value.x,
		"y": VALS.pos.value.y,
		"width": VALS.size.value.x,
		"height": VALS.size.value.y,
		"color": VALS.color.value,
		"bg_color": VALS.background.value,
		"value": VALS.percentage.value / 100.0,
		"visible": VALS.visible.value
	}
	G.window.progress_bars[ID] = opt
	G.window.canvas_redraw()

func run(routine:String):
	if routine == "show":
		VALS.visible.value = true

	if routine == "hide":
		VALS.visible.value = false

func update() -> void:
	update_progressbar()
