extends HBaseNode
class_name HNodeRandomNumber


static var _title = "Random number"
static var _type = "core/random/number"
static var _category = "Core"
static var _icon = "random"

func _init() -> void:
	title = _title
	type = _type
	PORTS = {
		"rand": HPortFlow.new({
			"type": E.CONNECTION_TYPES.FLOW,
			"side": INPUT,
			"description": "Generate random number"
		}),
		"min": HPortFloat.new({
			"type": E.CONNECTION_TYPES.FLOAT,
			"default": 0.0,
			"side": INPUT,
			"description": "Minimum value"
		}),
		"max": HPortFloat.new({
			"type": E.CONNECTION_TYPES.FLOAT,
			"default": 100.0,
			"side": INPUT,
			"description": "Maximum value"
		}),
		"float": HPortBool.new({
			"type": E.CONNECTION_TYPES.BOOL,
			"default": false,
			"side": INPUT,
			"description": "Retourne un nombre à virgule"
		}),
		"r": HPortFloat.new({
			"type": E.CONNECTION_TYPES.FLOAT,
			"side": OUTPUT
		})
	}

func run(routine:String):
	if routine == "rand":
		var r = randf_range(PORTS.min.value, PORTS.max.value)
		if not PORTS.float.value: 
			r = floor(r)
		
		PORTS.r.value = r

func update() -> void:
	if _last_port_changed == "float":
		PORTS.r.type = E.CONNECTION_TYPES.INT if not PORTS.float.value else E.CONNECTION_TYPES.FLOAT
		update_slots()
