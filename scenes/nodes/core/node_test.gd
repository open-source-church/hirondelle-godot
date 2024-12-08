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
		"input_flow": HPortFlow.new({
			"type": E.CONNECTION_TYPES.FLOW,
			"side": E.Side.INPUT
		}),
		"output_flow": HPortFlow.new({
			"type": E.CONNECTION_TYPES.FLOW,
			"side": E.Side.OUTPUT
		}),
		"base": HBasePort.new({
			"type": E.CONNECTION_TYPES.TEXT,
			"side": E.Side.INPUT
		}),
		"int": HPortIntSpin.new({
			"type": E.CONNECTION_TYPES.INT,
			"default": 12,
			"side": E.Side.BOTH,
			"options": [10, 11, 12, 13, 14, 15, 16],
			"description": "Une description très utile."
		}),
		"text": HPortText.new({
			"type": E.CONNECTION_TYPES.TEXT,
			"default": "Coucou",
			"side": E.Side.BOTH,
		}),
		"text_options": HPortText.new({
			"type": E.CONNECTION_TYPES.TEXT,
			"default": "Coucou",
			"side": E.Side.BOTH,
			"options": ["Add", "Substract", "Multiply", "Divide", "Modulo", "Power"]
		}),
		"vec2": HPortVec2.new({
			"type": E.CONNECTION_TYPES.VEC2,
			#"default": Vector2(12, 254),
			"side": E.Side.BOTH,
		}),
		"bool": HPortBool.new({
			"type": E.CONNECTION_TYPES.BOOL,
			#"default": Vector2(12, 254),
			"side": E.Side.INPUT,
		}),
	}

func update() -> void:
	if PORTS.int.value == 14:
		PORTS.text_options.options = ["Albert", "Le vert"]
	else:
		PORTS.text_options.options = []
