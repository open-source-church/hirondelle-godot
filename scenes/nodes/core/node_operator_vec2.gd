extends HBaseNode
class_name HNodeOperatorVec2

static var _title = "Vec2 Operations"
static var _type = "core/op/vec2"

func _init() -> void:
	title = _title
	type = _type
	VALS = {
		"operator": HPortText.new({
			"type": G.graph.TYPES.TEXT,
			"default": "Add",
			"side": NONE, 
			"options": ["Add", "Substract", "Multiply", "Divide"]
		}),
		"a": HPortVec2.new({
			"type": G.graph.TYPES.VEC2,
			"side": INPUT
		}),
		"b": HPortVec2.new({
			"type": G.graph.TYPES.VEC2,
			"side": INPUT
		}),
		"r": HPortVec2.new({
			"type": G.graph.TYPES.VEC2,
			"side": OUTPUT
		}),
	}

func update() -> void:
	error.text = ""
	#COMPONENTS.x.visible = VALS.operator.value == "Add"
	if VALS.operator.value == "Add":
		VALS.r.value = VALS.a.value + VALS.b.value
	if VALS.operator.value == "Substract":
		VALS.r.value = VALS.a.value - VALS.b.value
	if VALS.operator.value == "Multiply":
		VALS.r.value = VALS.a.value * VALS.b.value
	if VALS.operator.value == "Divide":
		if VALS.b.value.x and VALS.b.value.y:
			VALS.r.value = VALS.a.value / VALS.b.value
		else:
			VALS.r.value = Vector2(42, 42)
			error.text = "Pas glop de diviser par 0."
	if VALS.operator.value == "Power":
		VALS.r.value = Vector2(VALS.a.value.x ** VALS.b.value.x, VALS.a.value.x ** VALS.b.value.x)
