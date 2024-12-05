extends HBaseNode
class_name HNodeOperatorInt

static var _title = "INT Operations"
static var _type = "core/op/int"

func _init() -> void:
	title = _title
	type = _type
	VALS = {
		"operator": HPortText.new({
			"type": G.graph.TYPES.TEXT,
			"default": "Add",
			"side": NONE, 
			"options": ["Add", "Substract", "Multiply", "Divide", "Modulo", "Power"]
		}),
		"a": HPortIntSpin.new({
			"type": G.graph.TYPES.INT,
			"default": 0,
			"side": INPUT
		}),
		"b": HPortIntSpin.new({
			"type": G.graph.TYPES.INT,
			"default": 0,
			"side": INPUT
		}),
		"r": HPortIntSpin.new({
			"type": G.graph.TYPES.INT,
			"default": 0,
			"side": OUTPUT
		})
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
	if VALS.operator.value == "Modulo":
		VALS.r.value = VALS.a.value % VALS.b.value
	if VALS.operator.value == "Divide":
		if VALS.b.value:
			VALS.r.value = VALS.a.value / VALS.b.value
		else:
			VALS.r.value = 42
			error.text = "Pas glop de diviser par 0."
	if VALS.operator.value == "Power":
		VALS.r.value = VALS.a.value ** VALS.b.value
