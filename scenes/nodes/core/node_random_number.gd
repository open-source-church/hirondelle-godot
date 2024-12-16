extends HBaseNode
class_name HNodeRandomNumber


static var _title = "Random number"
static var _type = "core/random/number"
static var _category = "Core"
static var _icon = "random"


var rand := HPortFlow.new(E.Side.INPUT, {
	"description": "Generate random number"
})
var min_number := HPortFloat.new(E.Side.INPUT, {
	"default": 0.0,
	"description": "Minimum value"
})
var max_number := HPortFloat.new(E.Side.INPUT, {
	"default": 100.0,
	"description": "Maximum value"
})
var float_number := HPortBool.new(E.Side.INPUT, {
	"default": false,
	"description": "Retourne un nombre à virgule"
})
var r := HPortFloat.new(E.Side.OUTPUT)

func _init() -> void:
	title = _title
	type = _type
	

func run(_port : HBasePort) -> void:
	if _port == rand:
		print("New random number")
		var _r = randf_range(min_number.value, max_number.value)
		if not float_number.value: 
			_r = floor(_r)
		
		r.value = _r

func update(_last_changed: HBasePort = null) -> void:
	if _last_changed in [float_number, null]:
		r.type = E.CONNECTION_TYPES.INT if not float_number.value else E.CONNECTION_TYPES.FLOAT
		update_slots()
