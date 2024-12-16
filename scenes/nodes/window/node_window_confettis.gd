extends HBaseNode

static var _title = "Confettis"
static var _type = "window/confettis"
static var _category = "Window"
static var _icon = "confettis"

var ID : int


var start := HPortFlow.new(E.Side.INPUT)
var amount := HPortIntSpin.new(E.Side.INPUT, { "default": 20, "description": "The amount of confettis per color and per side." })
var colors := HPortArray.new(E.Side.INPUT, { "type": E.CONNECTION_TYPES.COLOR, "multiple": true, "description": "Attach as many color as you want. If you dont provide color, 3 basic colors will be used." })
var color_variation := HPortRatioSlider.new(E.Side.INPUT, { "default": 0.1, "params": { 
	"label": true, "reset": true }
})
var speed := HPortFloatSlider.new(E.Side.INPUT, { "default": 1.0, "params": { 
	"min": 0.2, "max": 10.0, "label": true, "exponential": true, "reset": true }
})
var scale_min := HPortIntSpin.new(E.Side.INPUT, { "default": 3 })
var scale_max := HPortIntSpin.new(E.Side.INPUT, { "default": 7 })
var active := HPortBool.new(E.Side.BOTH)

func _init() -> void:
	title = _title
	type = _type
	

func run(_port : HBasePort) -> void:
	if _port == start:
		G.window.confettis.create(amount.value, colors.value, color_variation.value, scale_min.value, scale_max.value, speed.value)

func update(_last_changed: HBasePort = null) -> void:
	if _last_changed == active and active.value:
		active.value = false
