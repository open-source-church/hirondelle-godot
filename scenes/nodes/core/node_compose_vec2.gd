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
		"vec": HPortVec2.new(E.Side.INPUT),
		"x": HPortFloat.new(E.Side.INPUT),
		"y": HPortFloat.new(E.Side.INPUT),
		"o_vec": HPortVec2.new(E.Side.OUTPUT),
		"o_x": HPortFloat.new(E.Side.OUTPUT),
		"o_y": HPortFloat.new(E.Side.OUTPUT),
	}

func update(_last_changed := "") -> void:
	# INPUT
	if _last_changed == "vec":
		PORTS.x.value = PORTS.vec.value.x
		PORTS.y.value = PORTS.vec.value.y
	else:
		PORTS.vec.value = Vector2(PORTS.x.value, PORTS.y.value)
	
	# OUTPUT
	PORTS.o_vec.value = PORTS.vec.value
	PORTS.o_x.value = PORTS.vec.value.x
	PORTS.o_y.value = PORTS.vec.value.y
