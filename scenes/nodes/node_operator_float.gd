extends HBaseNode
class_name HNodeOperatorFloat
static var _title = "FLOAT Operations"
static var _type = "core/op/float"

func _init() -> void:
	title = _title
	type = _type
	COMPONENTS = {
		"operator": Port.new({ 
			"type": G.graph.TYPES.TEXT_LIST,
			"default": "Add", 
			"side": NONE, 
			"options": ["Add", "Substract", "Multiply", "Divide", "Power"]
		} ),
		"a": Port.new({
			"type": G.graph.TYPES.FLOAT, 
			"default": 0,
			"side": INPUT
		}),
		"b": Port.new({
			"type": G.graph.TYPES.FLOAT, 
			"default": 0,
			"side": INPUT
		}),
		"r": Port.new({
			"type": G.graph.TYPES.FLOAT, 
			"default": 0, 
			"side": OUTPUT
		})
	}

func update() -> void:
	error.text = ""
	if VALS.operator.value == "Add":
		VALS.r.value = VALS.a.value + VALS.b.value
	if VALS.operator.value == "Substract":
		VALS.r.value = VALS.a.value - VALS.b.value
	if VALS.operator.value == "Multiply":
		VALS.r.value = VALS.a.value * VALS.b.value
	if VALS.operator.value == "Divide":
		if VALS.b.value:
			VALS.r.value = VALS.a.value / VALS.b.value
		else:
			VALS.r.value = 42
			error.text = "Pas glop de diviser par 0."
	if VALS.operator.value == "Power":
		VALS.r.value = VALS.a.value ** VALS.b.value
