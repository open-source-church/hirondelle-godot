extends HBaseNode

static var _title = "Progress Bar"
static var _type = "window/progress_bar"
static var _category = "Window"
static var _icon = "progressbar"

var ID : int

func _init() -> void:
	title = _title
	type = _type
	PORTS = {
		"show": HPortFlow.new({
			"type": E.CONNECTION_TYPES.FLOW, 
			"side": INPUT
		}),
		"hide": HPortFlow.new({
			"type": E.CONNECTION_TYPES.FLOW, 
			"side": INPUT
		}),
		"percentage": HPortIntSlider.new({
			"type": E.CONNECTION_TYPES.INT, 
			"side": INPUT,
			"params": { "min": 0, "max": 100 }
		}),
		"pos": HPortVec2.new({
			"type": E.CONNECTION_TYPES.VEC2,
			"default": Vector2(0, 0), 
			"side": INPUT,
		}),
		"size": HPortVec2.new({
			"type": E.CONNECTION_TYPES.VEC2, 
			"default": Vector2(500, 30),
			"side": INPUT
		}),
		"color": HPortColor.new({
			"type": E.CONNECTION_TYPES.COLOR, 
			"default": Color.PURPLE,
			"side": INPUT
		}),
		"background": HPortColor.new({
			"type": E.CONNECTION_TYPES.COLOR, 
			"default": Color.GRAY,
			"side": INPUT
		}),
		"visible": HPortBool.new({
			"type": E.CONNECTION_TYPES.BOOL, 
			"default": false,
			"side": INPUT
		}),
	}
	ID = randi()

func update_progressbar():
	var opt = {
		"x": PORTS.pos.value.x,
		"y": PORTS.pos.value.y,
		"width": PORTS.size.value.x,
		"height": PORTS.size.value.y,
		"color": PORTS.color.value,
		"bg_color": PORTS.background.value,
		"value": PORTS.percentage.value / 100.0,
		"visible": PORTS.visible.value
	}
	G.window.progress_bars[ID] = opt
	G.window.canvas_redraw()

func run(routine:String):
	if routine == "show":
		PORTS.visible.value = true

	if routine == "hide":
		PORTS.visible.value = false

func update() -> void:
	update_progressbar()
