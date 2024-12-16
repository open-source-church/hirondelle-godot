extends HBaseNode
class_name HNodeComposeColor

static var _title = "Color operations"
static var _type = "core/color"
static var _category = "Core"
static var _icon = "color"


var operator := HPortText.new(E.Side.NONE, {
	"options": ["Compose", "Decompose", "Blend", "Lerp", "Lighten", "Darken"]
})
var c1 := HPortColor.new(E.Side.INPUT, { "default": Color.CYAN })
var c2 := HPortColor.new(E.Side.INPUT, { "default": Color.MAGENTA })
var r := HPortIntSpin.new(E.Side.INPUT, { "default": 255 })
var g := HPortIntSpin.new(E.Side.INPUT, { "default": 255 })
var b := HPortIntSpin.new(E.Side.INPUT, { "default": 255 })
var a := HPortIntSpin.new(E.Side.INPUT, { "default": 255 })
var html := HPortText.new(E.Side.INPUT, { "default": "" })
var value := HPortIntSlider.new(E.Side.INPUT)
		# Output
var o_color := HPortColor.new(E.Side.OUTPUT)
var o_r := HPortIntSpin.new(E.Side.OUTPUT)
var o_g := HPortIntSpin.new(E.Side.OUTPUT)
var o_b := HPortIntSpin.new(E.Side.OUTPUT)
var o_a := HPortIntSpin.new(E.Side.OUTPUT)
var o_html := HPortText.new(E.Side.OUTPUT)

func _init() -> void:
	title = _title
	type = _type
	

func update(_last_changed: HBasePort = null) -> void:
	if _last_changed in [operator, null]:
		c1.collapsed = operator.value in ["Compose"]
		c2.collapsed = operator.value in ["Compose", "Decompose", "Lighten", "Darken"]
		r.collapsed = not operator.value in ["Compose"]
		g.collapsed = not operator.value in ["Compose"]
		b.collapsed = not operator.value in ["Compose"]
		a.collapsed = not operator.value in ["Compose"]
		html.collapsed = not operator.value in ["Compose"]
		value.collapsed = operator.value in ["Compose", "Decompose", "Blend"]
		o_color.collapsed = operator.value in ["Decompose"]
		o_r.collapsed = not operator.value in ["Decompose"]
		o_g.collapsed = not operator.value in ["Decompose"]
		o_b.collapsed = not operator.value in ["Decompose"]
		o_a.collapsed = not operator.value in ["Decompose"]
		o_html.collapsed = not operator.value in ["Decompose"]
		update_slots()
	
	# INPUT
	if operator.value == "Compose":
		if _last_changed == html:
			var color = Color(html.value)
			o_color.value = color
			r.value = color.r8
			g.value = color.g8
			b.value = color.b8
			a.value = color.a8
		else:
			var color = Color()
			color.r8 = r.value
			color.g8 = g.value
			color.b8 = b.value
			color.a8 = a.value
			html.value = color.to_html()
			o_color.value = color
	if operator.value == "Decompose":
		var color = Color(c1.value)
		o_color.value = color
		o_r.value = color.r8
		o_g.value = color.g8
		o_b.value = color.b8
		o_a.value = color.a8
		o_html.value = color.to_html()
	if operator.value == "Blend":
		var color = Color(c1.value)
		color = color.blend(c2.value)
		o_color.value = color
	if operator.value == "Lerp":
		var color = Color(c1.value)
		color = color.lerp(c2.value, value.value / 100.0)
		o_color.value = color
	if operator.value == "Lighten":
		var color = Color(c1.value)
		color = color.lightened(value.value / 100.0)
		o_color.value = color
	if operator.value == "Darken":
		var color = Color(c1.value)
		color = color.darkened(value.value / 100.0)
		o_color.value = color
	#if _last_changed == input:
		#r.value = input.value.r8
		#g.value = input.value.g8
		#b.value = input.value.b8
		#a.value = input.value.a8
	#else:
		#var color = Color()
		#color.r8 = r.value
		#color.g8 = g.value
		#color.b8 = b.value
		#color.a8 = a.value
		#input.value = color
	
	# OUTPUT
	#o_color.value = input.value
	#o_r.value = input.value.r8
	#o_g.value = input.value.g8
	#o_b.value = input.value.b8
	#o_a.value = input.value.a8
