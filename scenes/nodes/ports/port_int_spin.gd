extends HBasePort
class_name HPortIntSpin

var spinbox : SpinBox

func _init(side : E.Side, opt : Dictionary = {}):
	var _type = opt.get("type", E.CONNECTION_TYPES.INT)
	super(side, _type, opt)

func get_component(_params) -> Control:
	spinbox = SpinBox.new()
	spinbox.allow_greater = true
	spinbox.allow_lesser = true
	return spinbox

func _get_value():
	return spinbox.value

func _set_value(val):
	spinbox.value = val
