extends HBasePort
class_name HPortText

## Displays a Text as a LineEdit
##
## Params:
## * max_length: maximum number of characters. 0 = no limit.

var line : LineEdit

func _init(_side : E.Side, opt : Dictionary = {}):
	var _type = opt.get("type", E.CONNECTION_TYPES.TEXT)
	super(_side, _type, opt)

func get_component(_params) -> Control:
	line = LineEdit.new()
	line.custom_minimum_size = Vector2(200, 0)
	line.text_changed.connect(value_changed.emit.unbind(1))
	return line

func _on_params_changed() -> void:
	line.max_length = params.get("max_length", 0)
	line.secret = params.get("secret", false)

func _get_value():
	return line.text

func _set_value(val):
	line.text = str(val)
