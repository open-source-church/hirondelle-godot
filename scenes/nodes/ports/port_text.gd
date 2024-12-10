extends HBasePort
class_name HPortText

var line : LineEdit

func _init(_side : E.Side, opt : Dictionary = {}):
	var _type = opt.get("type", E.CONNECTION_TYPES.TEXT)
	super(_side, _type, opt)

func get_component(_params) -> Control:
	line = LineEdit.new()
	line.custom_minimum_size = Vector2(200, 0)
	return line

func _get_value():
	return line.text

func _set_value(val):
	line.text = str(val)
