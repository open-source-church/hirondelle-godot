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
		"input": HPortColor.new(E.Side.INPUT),
		"r": HPortIntSpin.new(E.Side.INPUT, { "default": 255 }),
		"g": HPortIntSpin.new(E.Side.INPUT, { "default": 255 }),
		"b": HPortIntSpin.new(E.Side.INPUT, { "default": 255 }),
		"a": HPortIntSpin.new(E.Side.INPUT, { "default": 255 }),
		"output": HPortColor.new(E.Side.OUTPUT),
		"o_r": HPortIntSpin.new(E.Side.OUTPUT),
		"o_g": HPortIntSpin.new(E.Side.OUTPUT),
		"o_b": HPortIntSpin.new(E.Side.OUTPUT),
		"o_a": HPortIntSpin.new(E.Side.OUTPUT),
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
