extends HBaseNode

static var _title = "Confettis"
static var _type = "window/confettis"
static var _category = "Window"
static var _icon = "confettis"

var ID : int

func _init() -> void:
	title = _title
	type = _type
	PORTS = {
		"start": HPortFlow.new(E.Side.INPUT),
		"amount": HPortIntSpin.new(E.Side.INPUT, { "default": 20, "description": "The amount of confettis per color and per side." }),
		"colors": HPortArray.new(E.Side.INPUT, { "type": E.CONNECTION_TYPES.COLOR, "dictionary": true, "description": "Attach as many color as you want. If you dont provide color, 3 basic colors will be used." }),
		"color_variation": HPortRatioSlider.new(E.Side.INPUT, { "default": 0.1, "params": { 
				"label": true, "reset": true }
			}),
		"speed": HPortFloatSlider.new(E.Side.INPUT, { "default": 1.0, "params": { 
			"min": 0.2, "max": 10.0, "label": true, "exponential": true, "reset": true }
		}),
		"scale_min": HPortIntSpin.new(E.Side.INPUT, { "default": 3 }),
		"scale_max": HPortIntSpin.new(E.Side.INPUT, { "default": 7 })
	}

func run(routine:String):
	if routine == "start":
		G.window.confettis.create(PORTS.amount.value, PORTS.colors.value, PORTS.color_variation.value, PORTS.scale_min.value, PORTS.scale_max.value, PORTS.speed.value)

func update(_last_changed: = "") -> void:
	if _last_changed == "active" and PORTS.active.value:
		PORTS.active.value = false
