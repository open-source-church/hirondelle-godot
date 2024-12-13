extends HBasePort
class_name HPortIntSpin

var spinbox : SpinBox

func _init(_side : E.Side, opt : Dictionary = {}):
	var _type = opt.get("type", E.CONNECTION_TYPES.INT)
	super(_side, _type, opt)

func get_component(_params) -> Control:
	spinbox = SpinBox.new()
	spinbox.allow_greater = true
	spinbox.allow_lesser = true
	spinbox.value_changed.connect(value_changed.emit.unbind(1))
	return spinbox

func _get_value():
	return spinbox.value

func _set_value(val):
	spinbox.value = val
