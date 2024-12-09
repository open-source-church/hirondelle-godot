extends HBasePort
class_name HPortFlow

var label_name : Label
var label_parenthesis : Label

func _init(side : E.Side, opt : Dictionary = {}):
	var _type = opt.get("type", E.CONNECTION_TYPES.FLOW)
	super(side, _type, opt)
	hide_label = true

func get_component(_params) -> Control:
	var box = HBoxContainer.new()
	label_name = Label.new()
	label_parenthesis = Label.new()
	label_parenthesis.add_theme_color_override("font_color", Color.DARK_GRAY)
	label_name.text = name
	label_parenthesis.text = "()"
	label_name.tooltip_text = description
	label_name.mouse_filter = Control.MOUSE_FILTER_PASS
	box.add_child(label_name)
	box.add_child(label_parenthesis)
	return box
	
