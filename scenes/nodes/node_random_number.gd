extends HBaseNode
class_name HNodeRandomNumber


static var _title = "Random number"
static var _type = "core/random/number"

func _init() -> void:
	title = _title
	type = _type
	COMPONENTS = {
		"min": Port.new({
			"type": G.graph.TYPES.INT,
			"default": 0,
			"side": INPUT,
			"description": "Minimum value"
		}),
		"max": Port.new({
			"type": G.graph.TYPES.INT,
			"default": 100,
			"side": INPUT,
			"description": "Maximum value"
		}),
		"float": Port.new({
			"type": G.graph.TYPES.BOOL,
			"default": false,
			"side": INPUT,
			"description": "Retourne un nombre à virgule"
		}),
		"r": Port.new({
			"type": G.graph.TYPES.FLOAT,
			"default": null,
			"side": OUTPUT
		})
	}

func update() -> void:
	var r = randf_range(VALS.min.value, VALS.max.value)
	if not VALS.float.value: r = floor(r)
	VALS.r.value = r
	
