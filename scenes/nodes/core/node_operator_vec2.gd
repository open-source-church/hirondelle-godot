extends HBaseNode
class_name HNodeOperatorVec2

static var _title = "Vec2 Operations"
static var _type = "core/op/vec2"
static var _category = "Core"
static var _icon = "vector"
static var _description = "Vector (x, y) operations: compose, decompose, add, substract, multiply and divide."

func _init() -> void:
	title = _title
	type = _type
	PORTS = {
		"operator": HPortText.new(E.Side.NONE, {
			"default": "Add",
			"options": ["Compose", "Decompose", "Add", "Substract", "Multiply", "Divide"]
		}),
		"a": HPortVec2.new(E.Side.INPUT),
		"x": HPortFloat.new(E.Side.INPUT),
		"y": HPortFloat.new(E.Side.INPUT),
		"b": HPortVec2.new(E.Side.INPUT),
		"o_v": HPortVec2.new(E.Side.OUTPUT),
		"o_x": HPortFloat.new(E.Side.OUTPUT),
		"o_y": HPortFloat.new(E.Side.OUTPUT),
	}

func update(_last_changed := "") -> void:
	var operator = PORTS.operator.value
	if _last_changed in ["operator", ""]:
		PORTS.a.collapsed = operator in ["Compose"]
		PORTS.x.collapsed = operator not in ["Compose"]
		PORTS.y.collapsed = operator not in ["Compose"]
		PORTS.b.collapsed = operator in ["Compose", "Decompose"]
		PORTS.o_v.collapsed = operator in ["Decompose"]
		PORTS.o_x.collapsed = operator not in ["Decompose"]
		PORTS.o_y.collapsed = operator not in ["Decompose"]
		update_slots()
	
	if operator == "Compose":
		PORTS.o_v.value = Vector2(PORTS.x.value, PORTS.y.value)
	if operator == "Decompose":
		PORTS.o_x.value = PORTS.a.value.x
		PORTS.o_y.value = PORTS.a.value.y
	if operator == "Add":
		PORTS.o_v.value = PORTS.a.value + PORTS.b.value
	if operator == "Substract":
		PORTS.o_v.value = PORTS.a.value - PORTS.b.value
	if operator == "Multiply":
		PORTS.o_v.value = PORTS.a.value * PORTS.b.value
	if operator == "Divide":
		if PORTS.b.value.x and PORTS.b.value.y:
			PORTS.o_v.value = PORTS.a.value / PORTS.b.value
			show_warning("")
		else:
			PORTS.o_v.value = Vector2(42, 42)
			show_warning("Pas glop de diviser par 0.", 3)
	if operator == "Power":
		PORTS.o_v.value = Vector2(PORTS.a.value.x ** PORTS.b.value.x, PORTS.a.value.x ** PORTS.b.value.x)
