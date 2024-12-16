extends HBaseNode

static var _title = "Progress Bar"
static var _type = "window/progress_bar"
static var _category = "Window"
static var _icon = "progressbar"

var ID : int


var show_ := HPortFlow.new(E.Side.INPUT)
var hide_ := HPortFlow.new(E.Side.INPUT)
var value := HPortRatioSlider.new(E.Side.INPUT, { "label": true } )
var pos := HPortVec2.new(E.Side.INPUT, { "default": Vector2(0, 0) })
var size_ := HPortVec2.new(E.Side.INPUT, { "default": Vector2(500, 30) })
var color := HPortColor.new(E.Side.INPUT, { "default": Color.PURPLE })
var background := HPortColor.new(E.Side.INPUT, { "default": Color.GRAY })
var border := HPortColor.new(E.Side.INPUT, { "default": Color.BLACK })
var radius := HPortIntSpin.new(E.Side.INPUT, { "default": 0 })
var border_width := HPortIntSpin.new(E.Side.INPUT, { "default": 0 })
var visible_ := HPortBool.new(E.Side.INPUT, { "default": false })

func _init() -> void:
	title = _title
	type = _type
	
	ID = randi()

func update_progressbar():
	var opt = {
		"x": pos.value.x,
		"y": pos.value.y,
		"width": size_.value.x,
		"height": size_.value.y,
		"color": color.value,
		"bg_color": background.value,
		"border_color": border.value,
		"border_width": border_width.value,
		"radius": radius.value,
		"value": value.value,
		"visible": visible_.value
	}
	G.window.progress_bars[ID] = opt
	G.window.canvas_redraw()

func run(_port : HBasePort) -> void:
	if _port == show_:
		visible_.value = true

	if _port == hide_:
		visible_.value = false

func update(_last_changed: HBasePort = null) -> void:
	update_progressbar()

func _exit_tree() -> void:
	G.window.progress_bars.erase(ID)
	G.window.canvas_redraw()
