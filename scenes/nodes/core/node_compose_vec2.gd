extends HBaseNode
class_name HNodeComposeVec2

static var _title = "Vec2 Compose"
static var _type = "core/compose/vec2"
static var _category = "Core"
static var _icon = "vector"

func _init() -> void:
	title = _title
	type = _type
	PORTS = {
		"vec": HPortVec2.new({
			"type": E.CONNECTION_TYPES.VEC2,
			"side": INPUT
		}),
		"x": HPortFloat.new({
			"type": E.CONNECTION_TYPES.FLOAT,
			"side": INPUT
		}),
		"y": HPortFloat.new({
			"type": E.CONNECTION_TYPES.FLOAT,
			"side": INPUT
		}),
		"o_vec": HPortVec2.new({
			"type": E.CONNECTION_TYPES.VEC2,
			"side": OUTPUT
		}),
		"o_x": HPortFloat.new({
			"type": E.CONNECTION_TYPES.FLOAT,
			"side": OUTPUT
		}),
		"o_y": HPortFloat.new({
			"type": E.CONNECTION_TYPES.FLOAT,
			"side": OUTPUT
		}),
	}

func update() -> void:
	# INPUT
	if _last_port_changed == "vec":
		PORTS.x.value = PORTS.vec.value.x
		PORTS.y.value = PORTS.vec.value.y
	else:
		PORTS.vec.value = Vector2(PORTS.x.value, PORTS.y.value)
	
	# OUTPUT
	PORTS.o_vec.value = PORTS.vec.value
	PORTS.o_x.value = PORTS.vec.value.x
	PORTS.o_y.value = PORTS.vec.value.y
