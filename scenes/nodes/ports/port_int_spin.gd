extends HBasePort
class_name HPortIntSpin

var spinbox : SpinBox

func get_component(_params) -> Control:
	spinbox = SpinBox.new()
	spinbox.allow_greater = true
	spinbox.allow_lesser = true
	return spinbox

func _get_value():
	return spinbox.value

func _set_value(val):
	spinbox.value = val
