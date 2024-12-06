extends HBaseNode
class_name HNodeComposeVec2

static var _title = "Vec2 Compose"
static var _type = "core/compose/vec2"

func _init() -> void:
	title = _title
	type = _type
	VALS = {
		"vec": HPortVec2.new({
			"type": G.graph.TYPES.VEC2,
			"side": INPUT
		}),
		"x": HPortFloat.new({
			"type": G.graph.TYPES.FLOAT,
			"side": INPUT
		}),
		"y": HPortFloat.new({
			"type": G.graph.TYPES.FLOAT,
			"side": INPUT
		}),
		"o_vec": HPortVec2.new({
			"type": G.graph.TYPES.VEC2,
			"side": OUTPUT
		}),
		"o_x": HPortFloat.new({
			"type": G.graph.TYPES.FLOAT,
			"side": OUTPUT
		}),
		"o_y": HPortFloat.new({
			"type": G.graph.TYPES.FLOAT,
			"side": OUTPUT
		}),
	}

func update() -> void:
	# INPUT
	if _last_port_changed == "vec":
		VALS.x.value = VALS.vec.value.x
		VALS.y.value = VALS.vec.value.y
	else:
		VALS.vec.value = Vector2(VALS.x.value, VALS.y.value)
	
	# OUTPUT
	VALS.o_vec.value = VALS.vec.value
	VALS.o_x.value = VALS.vec.value.x
	VALS.o_y.value = VALS.vec.value.y
