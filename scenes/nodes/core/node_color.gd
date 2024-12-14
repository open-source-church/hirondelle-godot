extends HBaseNode
class_name HNodeComposeColor

static var _title = "Color operations"
static var _type = "core/color"
static var _category = "Core"
static var _icon = "color"

func _init() -> void:
	title = _title
	type = _type
	PORTS = {
		"operator": HPortText.new(E.Side.NONE, {
			"options": ["Compose", "Decompose", "Blend", "Lerp", "Lighten", "Darken"]
		}),
		"c1": HPortColor.new(E.Side.INPUT, { "default": Color.CYAN }),
		"c2": HPortColor.new(E.Side.INPUT, { "default": Color.MAGENTA }),
		"r": HPortIntSpin.new(E.Side.INPUT, { "default": 255 }),
		"g": HPortIntSpin.new(E.Side.INPUT, { "default": 255 }),
		"b": HPortIntSpin.new(E.Side.INPUT, { "default": 255 }),
		"a": HPortIntSpin.new(E.Side.INPUT, { "default": 255 }),
		"html": HPortText.new(E.Side.INPUT, { "default": "" }),
		"value": HPortIntSlider.new(E.Side.INPUT),
		# Output
		"o_color": HPortColor.new(E.Side.OUTPUT),
		"o_r": HPortIntSpin.new(E.Side.OUTPUT),
		"o_g": HPortIntSpin.new(E.Side.OUTPUT),
		"o_b": HPortIntSpin.new(E.Side.OUTPUT),
		"o_a": HPortIntSpin.new(E.Side.OUTPUT),
		"o_html": HPortText.new(E.Side.OUTPUT),
	}

func update(_last_changed := "") -> void:
	var operator = PORTS.operator.value
	if _last_changed in ["operator", ""]:
		PORTS.c1.collapsed = operator in ["Compose"]
		PORTS.c2.collapsed = operator in ["Compose", "Decompose", "Lighten", "Darken"]
		PORTS.r.collapsed = not operator in ["Compose"]
		PORTS.g.collapsed = not operator in ["Compose"]
		PORTS.b.collapsed = not operator in ["Compose"]
		PORTS.a.collapsed = not operator in ["Compose"]
		PORTS.html.collapsed = not operator in ["Compose"]
		PORTS.value.collapsed = operator in ["Compose", "Decompose", "Blend"]
		PORTS.o_color.collapsed = operator in ["Decompose"]
		PORTS.o_r.collapsed = not operator in ["Decompose"]
		PORTS.o_g.collapsed = not operator in ["Decompose"]
		PORTS.o_b.collapsed = not operator in ["Decompose"]
		PORTS.o_a.collapsed = not operator in ["Decompose"]
		PORTS.o_html.collapsed = not operator in ["Decompose"]
		update_slots()
	
	# INPUT
	if operator == "Compose":
		if _last_changed == "html":
			var color = Color(PORTS.html.value)
			PORTS.o_color.value = color
			PORTS.r.value = color.r8
			PORTS.g.value = color.g8
			PORTS.b.value = color.b8
			PORTS.a.value = color.a8
		else:
			var color = Color()
			color.r8 = PORTS.r.value
			color.g8 = PORTS.g.value
			color.b8 = PORTS.b.value
			color.a8 = PORTS.a.value
			PORTS.html.value = color.to_html()
			PORTS.o_color.value = color
	if operator == "Decompose":
		var color = Color(PORTS.c1.value)
		PORTS.o_color.value = color
		PORTS.o_r.value = color.r8
		PORTS.o_g.value = color.g8
		PORTS.o_b.value = color.b8
		PORTS.o_a.value = color.a8
		PORTS.o_html.value = color.to_html()
	if operator == "Blend":
		var color = Color(PORTS.c1.value)
		color = color.blend(PORTS.c2.value)
		PORTS.o_color.value = color
	if operator == "Lerp":
		var color = Color(PORTS.c1.value)
		color = color.lerp(PORTS.c2.value, PORTS.value.value / 100.0)
		PORTS.o_color.value = color
	if operator == "Lighten":
		var color = Color(PORTS.c1.value)
		color = color.lightened(PORTS.value.value / 100.0)
		PORTS.o_color.value = color
	if operator == "Darken":
		var color = Color(PORTS.c1.value)
		color = color.darkened(PORTS.value.value / 100.0)
		PORTS.o_color.value = color
	#if _last_changed == "input":
		#PORTS.r.value = PORTS.input.value.r8
		#PORTS.g.value = PORTS.input.value.g8
		#PORTS.b.value = PORTS.input.value.b8
		#PORTS.a.value = PORTS.input.value.a8
	#else:
		#var color = Color()
		#color.r8 = PORTS.r.value
		#color.g8 = PORTS.g.value
		#color.b8 = PORTS.b.value
		#color.a8 = PORTS.a.value
		#PORTS.input.value = color
	
	# OUTPUT
	#PORTS.o_color.value = PORTS.input.value
	#PORTS.o_r.value = PORTS.input.value.r8
	#PORTS.o_g.value = PORTS.input.value.g8
	#PORTS.o_b.value = PORTS.input.value.b8
	#PORTS.o_a.value = PORTS.input.value.a8
