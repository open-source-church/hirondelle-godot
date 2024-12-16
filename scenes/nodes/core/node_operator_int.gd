extends HBaseNode
class_name HNodeOperatorInt

static var _title = "INT Operations"
static var _type = "core/op/int"
static var _category = "Core"
static var _icon = "int"


var operator := HPortText.new(E.Side.NONE, {
	"default": "Add",
	"options": ["Add", "Substract", "Multiply", "Divide", "Modulo", "Power"]
})
var a := HPortIntSpin.new(E.Side.INPUT, { "default": 0 })
var b := HPortIntSpin.new(E.Side.INPUT, { "default": 0 })
var r := HPortIntSpin.new(E.Side.OUTPUT, { "default": 0 })

func _init() -> void:
	title = _title
	type = _type
	

func update(_last_changed: HBasePort = null) -> void:
	if operator.value == "Add":
		r.value = a.value + b.value
	if operator.value == "Substract":
		r.value = a.value - b.value
	if operator.value == "Multiply":
		r.value = a.value * b.value
	if operator.value == "Modulo":
		r.value = a.value % b.value
	if operator.value == "Divide":
		if b.value:
			r.value = a.value / b.value
			show_error("")
		else:
			r.value = 42
			show_error("Pas glop de diviser par 0.")
	if operator.value == "Power":
		r.value = a.value ** b.value
