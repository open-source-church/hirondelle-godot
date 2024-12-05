extends HBasePort
class_name HPortBool

var toggle : CheckButton

func get_component(_params) -> Control:
	toggle = CheckButton.new()
	toggle.flat = true
	return toggle

func _get_value():
	return toggle.button_pressed

func _set_value(val):
	toggle.button_pressed = val
