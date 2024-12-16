extends HBaseNode
class_name HNodeOperatorVec2

static var _title = "Vec2 Operations"
static var _type = "core/op/vec2"
static var _category = "Core"
static var _icon = "vector"
static var _description = "Vector (x, y) operations: compose, decompose, add, substract, multiply and divide."


var operator := HPortText.new(E.Side.NONE, {
	"default": "Add",
	"options": ["Compose", "Decompose", "Add", "Substract", "Multiply", "Divide"]
})
var a := HPortVec2.new(E.Side.INPUT)
var x := HPortFloat.new(E.Side.INPUT)
var y := HPortFloat.new(E.Side.INPUT)
var b := HPortVec2.new(E.Side.INPUT)
var o_v := HPortVec2.new(E.Side.OUTPUT)
var o_x := HPortFloat.new(E.Side.OUTPUT)
var o_y := HPortFloat.new(E.Side.OUTPUT)

func _init() -> void:
	title = _title
	type = _type
	

func update(_last_changed: HBasePort = null) -> void:
	if _last_changed in [operator, null]:
		a.collapsed = operator.value in ["Compose"]
		x.collapsed = operator.value not in ["Compose"]
		y.collapsed = operator.value not in ["Compose"]
		b.collapsed = operator.value in ["Compose", "Decompose"]
		o_v.collapsed = operator.value in ["Decompose"]
		o_x.collapsed = operator.value not in ["Decompose"]
		o_y.collapsed = operator.value not in ["Decompose"]
		update_slots()
	
	if operator.value == "Compose":
		o_v.value = Vector2(x.value, y.value)
	if operator.value == "Decompose":
		o_x.value = a.value.x
		o_y.value = a.value.y
	if operator.value == "Add":
		o_v.value = a.value + b.value
	if operator.value == "Substract":
		o_v.value = a.value - b.value
	if operator.value == "Multiply":
		o_v.value = a.value * b.value
	if operator.value == "Divide":
		if b.value.x and b.value.y:
			o_v.value = a.value / b.value
			show_warning("")
		else:
			o_v.value = Vector2(42, 42)
			show_warning("Pas glop de diviser par 0.", 3)
	if operator.value == "Power":
		o_v.value = Vector2(a.value.x ** b.value.x, a.value.x ** b.value.x)
