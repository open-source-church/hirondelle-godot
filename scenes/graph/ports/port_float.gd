extends HBasePort
class_name HPortFloat

var line : LineEdit

func _init(_side : E.Side, opt : Dictionary = {}):
	var _type = opt.get("type", E.CONNECTION_TYPES.FLOAT)
	super(_side, _type, opt)

func get_component(_params) -> Control:
	line = LineEdit.new()
	line.custom_minimum_size = Vector2(200, 0)
	line.text_changed.connect(value_changed.emit.unbind(1))
	return line

func _get_value():
	return float(line.text)

func _set_value(val):
	line.text = str(val)

## Performs type conversion to ensure the value is in the proper type
func type_cast(val):
	return float(val)
