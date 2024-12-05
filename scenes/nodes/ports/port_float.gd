extends HBasePort
class_name HPortFloat

var line : LineEdit

func get_component(_params) -> Control:
	line = LineEdit.new()
	line.custom_minimum_size = Vector2(200, 0)
	return line

func _get_value():
	return float(line.text)

func _set_value(val):
	line.text = str(val)
