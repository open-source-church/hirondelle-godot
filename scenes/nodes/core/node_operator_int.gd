extends HBaseNode
class_name HNodeOperatorInt

static var _title = "INT Operations"
static var _type = "core/op/int"
static var _category = "Core"
static var _icon = "int"

func _init() -> void:
	title = _title
	type = _type
	PORTS = {
		"operator": HPortText.new(E.Side.NONE, {
			"default": "Add",
			"options": ["Add", "Substract", "Multiply", "Divide", "Modulo", "Power"]
		}),
		"a": HPortIntSpin.new(E.Side.INPUT, { "default": 0 }),
		"b": HPortIntSpin.new(E.Side.INPUT, { "default": 0 }),
		"r": HPortIntSpin.new(E.Side.OUTPUT, { "default": 0 })
	}

func update() -> void:
	if PORTS.operator.value == "Add":
		PORTS.r.value = PORTS.a.value + PORTS.b.value
	if PORTS.operator.value == "Substract":
		PORTS.r.value = PORTS.a.value - PORTS.b.value
	if PORTS.operator.value == "Multiply":
		PORTS.r.value = PORTS.a.value * PORTS.b.value
	if PORTS.operator.value == "Modulo":
		PORTS.r.value = PORTS.a.value % PORTS.b.value
	if PORTS.operator.value == "Divide":
		if PORTS.b.value:
			PORTS.r.value = PORTS.a.value / PORTS.b.value
			show_error("")
		else:
			PORTS.r.value = 42
			show_error("Pas glop de diviser par 0.")
	if PORTS.operator.value == "Power":
		PORTS.r.value = PORTS.a.value ** PORTS.b.value
