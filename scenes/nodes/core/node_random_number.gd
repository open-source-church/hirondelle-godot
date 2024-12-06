extends HBaseNode
class_name HNodeRandomNumber


static var _title = "Random number"
static var _type = "core/random/number"
static var _category = "Core"
static var _icon = "random"

func _init() -> void:
	title = _title
	type = _type
	VALS = {
		"rand": HPortFlow.new({
			"type": G.graph.TYPES.FLOW,
			"side": INPUT,
			"description": "Generate random number"
		}),
		"min": HPortFloat.new({
			"type": G.graph.TYPES.FLOAT,
			"default": 0.0,
			"side": INPUT,
			"description": "Minimum value"
		}),
		"max": HPortFloat.new({
			"type": G.graph.TYPES.FLOAT,
			"default": 100.0,
			"side": INPUT,
			"description": "Maximum value"
		}),
		"float": HPortBool.new({
			"type": G.graph.TYPES.BOOL,
			"default": false,
			"side": INPUT,
			"description": "Retourne un nombre à virgule"
		}),
		"r": HPortFloat.new({
			"type": G.graph.TYPES.FLOAT,
			"side": OUTPUT
		})
	}

func run(routine:String):
	if routine == "rand":
		var r = randf_range(VALS.min.value, VALS.max.value)
		if not VALS.float.value: 
			r = floor(r)
		
		VALS.r.value = r

func update() -> void:
	if _last_port_changed == "float":
		VALS.r.type = HGraphEdit.TYPES.INT if not VALS.float.value else HGraphEdit.TYPES.FLOAT
		update_slots()
