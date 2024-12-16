extends HBaseNode
class_name HNodeOperatorFloat

static var _title = "FLOAT Operations"
static var _type = "core/op/float"
static var _category = "Core"
static var _icon = "float"


var operator := HPortText.new(E.Side.NONE, {
	"default": "Add", 
	"options": ["Add", "Substract", "Multiply", "Divide", "Power"]
} )
var a := HPortFloat.new(E.Side.INPUT, { "default": 0 })
var b := HPortFloat.new(E.Side.INPUT, { "default": 0 })
var r := HPortFloat.new(E.Side.OUTPUT, { "default": 0 })

func _init() -> void:
	title = _title
	type = _type
	

func update(_last_changed: HBasePort = null) -> void:
	error.text = ""
	if operator.value == "Add":
		r.value = a.value + b.value
	if operator.value == "Substract":
		r.value = a.value - b.value
	if operator.value == "Multiply":
		r.value = a.value * b.value
	if operator.value == "Divide":
		if b.value:
			r.value = a.value / b.value
		else:
			r.value = 42
			error.text = "Pas glop de diviser par 0."
	if operator.value == "Power":
		r.value = a.value ** b.value
