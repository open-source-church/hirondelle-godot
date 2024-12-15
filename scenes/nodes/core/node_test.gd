extends HBaseNode
class_name HNodeTest

static var _title = "Test Node"
static var _type = "core/test"
static var _category = "Core"
static var _description = "Un node pour tester des trucs."

func _init() -> void:
	title = _title
	type = _type
	PORTS = {
		"input_flow": HPortFlow.new(E.Side.INPUT),
		"output_flow": HPortFlow.new(E.Side.OUTPUT),
		"int": HPortIntSpin.new(E.Side.BOTH, {
			"default": 12,
			"options": [10, 11, 12, 13, 14, 15, 16],
			"description": "Une description très utile."
		}),
		"text": HPortText.new(E.Side.BOTH, { "default": "Coucou" }),
		"text_options": HPortText.new(E.Side.BOTH, {
			"default": "Coucou",
			"options": ["Add", "Substract", "Multiply", "Divide", "Modulo", "Power"]
		}),
		"vec2": HPortVec2.new(E.Side.BOTH),
		"bool": HPortBool.new(E.Side.INPUT),
		"float": HPortFloat.new(E.Side.BOTH),
	}

func update(_last_changed := "") -> void:
	return
	if PORTS.int.value == 14:
		PORTS.text_options.options = ["Albert", "Le vert"]
	else:
		PORTS.text_options.options = []
