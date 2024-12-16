extends HBaseNode
class_name HNodeTest

static var _title = "Test Node"
static var _type = "core/test"
static var _category = "Core"
static var _description = "Un node pour tester des trucs."


var input_flow := HPortFlow.new(E.Side.INPUT)
var output_flow := HPortFlow.new(E.Side.OUTPUT)
var int_n := HPortIntSpin.new(E.Side.BOTH, {
	"default": 12,
	"options": [10, 11, 12, 13, 14, 15, 16],
	"description": "Une description très utile."
})
var text := HPortText.new(E.Side.BOTH, { "default": "Coucou" })
var text_options := HPortText.new(E.Side.BOTH, {
	"default": "Coucou",
	"options": ["Add", "Substract", "Multiply", "Divide", "Modulo", "Power"]
})
var vec2 := HPortVec2.new(E.Side.BOTH)
var bool_v := HPortBool.new(E.Side.INPUT)
var float_v := HPortFloat.new(E.Side.BOTH)

func _init() -> void:
	title = _title
	type = _type
	

func update(_last_changed: HBasePort = null) -> void:
	return
	if int_n.value == 14:
		text_options.options = ["Albert", "Le vert"]
	else:
		text_options.options = []
