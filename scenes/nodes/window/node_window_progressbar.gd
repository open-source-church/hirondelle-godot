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
		"show": HPortFlow.new(E.Side.INPUT),
		"hide": HPortFlow.new(E.Side.INPUT),
		"value": HPortRatioSlider.new(E.Side.INPUT, { "label": true } ),
		"pos": HPortVec2.new(E.Side.INPUT, { "default": Vector2(0, 0) }),
		"size": HPortVec2.new(E.Side.INPUT, { "default": Vector2(500, 30) }),
		"color": HPortColor.new(E.Side.INPUT, { "default": Color.PURPLE }),
		"background": HPortColor.new(E.Side.INPUT, { "default": Color.GRAY }),
		"border": HPortColor.new(E.Side.INPUT, { "default": Color.BLACK }),
		"radius": HPortIntSpin.new(E.Side.INPUT, { "default": 0 }),
		"border_width": HPortIntSpin.new(E.Side.INPUT, { "default": 0 }),
		"visible": HPortBool.new(E.Side.INPUT, { "default": false }),
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
		"border_color": PORTS.border.value,
		"border_width": PORTS.border_width.value,
		"radius": PORTS.radius.value,
		"value": PORTS.value.value,
		"visible": PORTS.visible.value
	}
	G.window.progress_bars[ID] = opt
	G.window.canvas_redraw()

func run(routine:String):
	if routine == "show":
		PORTS.visible.value = true

	if routine == "hide":
		PORTS.visible.value = false

func update(_last_changed: = "") -> void:
	update_progressbar()

func _exit_tree() -> void:
	G.window.progress_bars.erase(ID)
	G.window.canvas_redraw()
