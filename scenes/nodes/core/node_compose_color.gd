extends HBaseNode
class_name HNodeComposeColor

static var _title = "Color Compose"
static var _type = "core/compose/color"
static var _category = "Core"
static var _icon = "color"

func _init() -> void:
	title = _title
	type = _type
	PORTS = {
		"input": HPortColor.new({
			"type": E.CONNECTION_TYPES.COLOR,
			"side": INPUT,
		}),
		"r": HPortIntSpin.new({
			"type": E.CONNECTION_TYPES.INT,
			"side": INPUT,
			"default": 255
		}),
		"g": HPortIntSpin.new({
			"type": E.CONNECTION_TYPES.INT,
			"side": INPUT,
			"default": 255
		}),
		"b": HPortIntSpin.new({
			"type": E.CONNECTION_TYPES.INT,
			"side": INPUT,
			"default": 255
		}),
		"a": HPortIntSpin.new({
			"type": E.CONNECTION_TYPES.INT,
			"side": INPUT,
			"default": 255
		}),
		"output": HPortColor.new({
			"type": E.CONNECTION_TYPES.COLOR,
			"side": OUTPUT
		}),
		"o_r": HPortIntSpin.new({
			"type": E.CONNECTION_TYPES.INT,
			"side": OUTPUT
		}),
		"o_g": HPortIntSpin.new({
			"type": E.CONNECTION_TYPES.INT,
			"side": OUTPUT
		}),
		"o_b": HPortIntSpin.new({
			"type": E.CONNECTION_TYPES.INT,
			"side": OUTPUT
		}),
		"o_a": HPortIntSpin.new({
			"type": E.CONNECTION_TYPES.INT,
			"side": OUTPUT
		}),
	}

func update() -> void:
	# INPUT
	if _last_port_changed == "input":
		PORTS.r.value = PORTS.input.value.r8
		PORTS.g.value = PORTS.input.value.g8
		PORTS.b.value = PORTS.input.value.b8
		PORTS.a.value = PORTS.input.value.a8
	else:
		var color = Color()
		color.r8 = PORTS.r.value
		color.g8 = PORTS.g.value
		color.b8 = PORTS.b.value
		color.a8 = PORTS.a.value
		PORTS.input.value = color
	
	# OUTPUT
	PORTS.output.value = PORTS.input.value
	PORTS.o_r.value = PORTS.input.value.r8
	PORTS.o_g.value = PORTS.input.value.g8
	PORTS.o_b.value = PORTS.input.value.b8
	PORTS.o_a.value = PORTS.input.value.a8
