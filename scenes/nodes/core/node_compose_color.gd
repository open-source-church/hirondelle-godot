extends HBaseNode
class_name HNodeComposeColor

static var _title = "Color Compose"
static var _type = "core/compose/color"
static var _category = "Core"
static var _icon = "color"

func _init() -> void:
	title = _title
	type = _type
	VALS = {
		"input": HPortColor.new({
			"type": G.graph.TYPES.COLOR,
			"side": INPUT,
		}),
		"r": HPortIntSpin.new({
			"type": G.graph.TYPES.INT,
			"side": INPUT,
			"default": 255
		}),
		"g": HPortIntSpin.new({
			"type": G.graph.TYPES.INT,
			"side": INPUT,
			"default": 255
		}),
		"b": HPortIntSpin.new({
			"type": G.graph.TYPES.INT,
			"side": INPUT,
			"default": 255
		}),
		"a": HPortIntSpin.new({
			"type": G.graph.TYPES.INT,
			"side": INPUT,
			"default": 255
		}),
		"output": HPortColor.new({
			"type": G.graph.TYPES.COLOR,
			"side": OUTPUT
		}),
		"o_r": HPortIntSpin.new({
			"type": G.graph.TYPES.INT,
			"side": OUTPUT
		}),
		"o_g": HPortIntSpin.new({
			"type": G.graph.TYPES.INT,
			"side": OUTPUT
		}),
		"o_b": HPortIntSpin.new({
			"type": G.graph.TYPES.INT,
			"side": OUTPUT
		}),
		"o_a": HPortIntSpin.new({
			"type": G.graph.TYPES.INT,
			"side": OUTPUT
		}),
	}

func update() -> void:
	# INPUT
	if _last_port_changed == "input":
		VALS.r.value = VALS.input.value.r8
		VALS.g.value = VALS.input.value.g8
		VALS.b.value = VALS.input.value.b8
		VALS.a.value = VALS.input.value.a8
	else:
		var color = Color()
		color.r8 = VALS.r.value
		color.g8 = VALS.g.value
		color.b8 = VALS.b.value
		color.a8 = VALS.a.value
		VALS.input.value = color
	
	# OUTPUT
	VALS.output.value = VALS.input.value
	VALS.o_r.value = VALS.input.value.r8
	VALS.o_g.value = VALS.input.value.g8
	VALS.o_b.value = VALS.input.value.b8
	VALS.o_a.value = VALS.input.value.a8
