extends HBasePort
class_name HPortTextMultiLine

## Displays a Text as a LineEdit
##
## Params:
## *

var text : TextEdit

func _init(_side : E.Side, opt : Dictionary = {}):
	var _type = opt.get("type", E.CONNECTION_TYPES.TEXT)
	super(_side, _type, opt)

func get_component(_params) -> Control:
	text = TextEdit.new()
	text.custom_minimum_size = Vector2(250, 20)
	text.text_changed.connect(value_changed.emit)
	text.mouse_force_pass_scroll_events = false
	text.add_theme_font_size_override("font_size", 14)
	text.scroll_fit_content_height = true
	text.resized.connect(_reset_size)
	return text

func _get_value():
	return text.text

func _set_value(val):
	text.text = str(val)
