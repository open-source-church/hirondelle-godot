extends HBaseNode
class_name HNodeOperatorFloat

static var _title = "FLOAT Operations"
static var _type = "core/op/float"
static var _category = "Core"
static var _icon = "float"

func _init() -> void:
	title = _title
	type = _type
	PORTS = {
		"operator": HPortText.new(E.Side.NONE, {
			"default": "Add", 
			"options": ["Add", "Substract", "Multiply", "Divide", "Power"]
		} ),
		"a": HPortFloat.new(E.Side.INPUT, { "default": 0 }),
		"b": HPortFloat.new(E.Side.INPUT, { "default": 0 }),
		"r": HPortFloat.new(E.Side.OUTPUT, { "default": 0 })
	}

func update(_last_changed: = "") -> void:
	error.text = ""
	if PORTS.operator.value == "Add":
		PORTS.r.value = PORTS.a.value + PORTS.b.value
	if PORTS.operator.value == "Substract":
		PORTS.r.value = PORTS.a.value - PORTS.b.value
	if PORTS.operator.value == "Multiply":
		PORTS.r.value = PORTS.a.value * PORTS.b.value
	if PORTS.operator.value == "Divide":
		if PORTS.b.value:
			PORTS.r.value = PORTS.a.value / PORTS.b.value
		else:
			PORTS.r.value = 42
			error.text = "Pas glop de diviser par 0."
	if PORTS.operator.value == "Power":
		PORTS.r.value = PORTS.a.value ** PORTS.b.value
