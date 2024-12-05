extends HBaseNode
class_name HNodeTest

static var _title = "Test Node"
static var _type = "core/test"

func _init() -> void:
	title = _title
	type = _type
	VALS = {
		"input_flow": HPortFlow.new({
			"type": G.graph.TYPES.FLOW,
			"side": E.Side.INPUT
		}),
		"output_flow": HPortFlow.new({
			"type": G.graph.TYPES.FLOW,
			"side": E.Side.OUTPUT
		}),
		"base": HBasePort.new({
			"type": G.graph.TYPES.TEXT,
			"side": E.Side.INPUT
		}),
		"int": HPortIntSpin.new({
			"type": G.graph.TYPES.INT,
			"default": 12,
			"side": E.Side.BOTH,
			"options": [10, 11, 12, 13, 14, 15, 16],
			"description": "Une description très utile."
		}),
		"text": HPortText.new({
			"type": G.graph.TYPES.TEXT,
			"default": "Coucou",
			"side": E.Side.BOTH,
		}),
		"text_options": HPortText.new({
			"type": G.graph.TYPES.TEXT,
			"default": "Coucou",
			"side": E.Side.BOTH,
			"options": ["Add", "Substract", "Multiply", "Divide", "Modulo", "Power"]
		}),
		"vec2": HPortVec2.new({
			"type": G.graph.TYPES.VEC2,
			#"default": Vector2(12, 254),
			"side": E.Side.BOTH,
		}),
		"bool": HPortBool.new({
			"type": G.graph.TYPES.BOOL,
			#"default": Vector2(12, 254),
			"side": E.Side.INPUT,
		}),
	}

func update() -> void:
	if VALS.int.value == 14:
		VALS.text_options.options = ["Albert", "Le vert"]
	else:
		VALS.text_options.options = []
