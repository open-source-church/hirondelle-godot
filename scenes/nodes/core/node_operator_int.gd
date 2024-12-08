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
		"operator": HPortText.new({
			"type": E.CONNECTION_TYPES.TEXT,
			"default": "Add",
			"side": NONE, 
			"options": ["Add", "Substract", "Multiply", "Divide", "Modulo", "Power"]
		}),
		"a": HPortIntSpin.new({
			"type": E.CONNECTION_TYPES.INT,
			"default": 0,
			"side": INPUT
		}),
		"b": HPortIntSpin.new({
			"type": E.CONNECTION_TYPES.INT,
			"default": 0,
			"side": INPUT
		}),
		"r": HPortIntSpin.new({
			"type": E.CONNECTION_TYPES.INT,
			"default": 0,
			"side": OUTPUT
		})
	}

func update() -> void:
	error.text = ""
	#COMPONENTS.x.visible = PORTS.operator.value == "Add"
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
		else:
			PORTS.r.value = 42
			error.text = "Pas glop de diviser par 0."
	if PORTS.operator.value == "Power":
		PORTS.r.value = PORTS.a.value ** PORTS.b.value
