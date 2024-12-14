extends HBaseNode
class_name HNodeOperatorVec2

static var _title = "Vec2 Operations"
static var _type = "core/op/vec2"
static var _category = "Core"
static var _icon = "vector"

func _init() -> void:
	title = _title
	type = _type
	PORTS = {
		"operator": HPortText.new(E.Side.NONE, {
			"default": "Add",
			"options": ["Add", "Substract", "Multiply", "Divide"]
		}),
		"a": HPortVec2.new(E.Side.INPUT),
		"b": HPortVec2.new(E.Side.INPUT),
		"r": HPortVec2.new(E.Side.OUTPUT),
	}

func update(_last_changed := "") -> void:
	error.text = ""
	if PORTS.operator.value == "Add":
		PORTS.r.value = PORTS.a.value + PORTS.b.value
	if PORTS.operator.value == "Substract":
		PORTS.r.value = PORTS.a.value - PORTS.b.value
	if PORTS.operator.value == "Multiply":
		PORTS.r.value = PORTS.a.value * PORTS.b.value
	if PORTS.operator.value == "Divide":
		if PORTS.b.value.x and PORTS.b.value.y:
			PORTS.r.value = PORTS.a.value / PORTS.b.value
		else:
			PORTS.r.value = Vector2(42, 42)
			error.text = "Pas glop de diviser par 0."
	if PORTS.operator.value == "Power":
		PORTS.r.value = Vector2(PORTS.a.value.x ** PORTS.b.value.x, PORTS.a.value.x ** PORTS.b.value.x)
