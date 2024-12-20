extends HBasePort
class_name HPortFlow

var label_name : Label
var label_parenthesis : Label

func _init(_side : E.Side, opt : Dictionary = {}):
	var _type = opt.get("type", E.CONNECTION_TYPES.FLOW)
	super(_side, _type, opt)
	hide_label = true

func get_component(_params) -> Control:
	var box = HBoxContainer.new()
	label_name = HEditableLabel.new(editable_name)
	label_parenthesis = Label.new()
	label_parenthesis.add_theme_color_override("font_color", Color.DARK_GRAY)
	label_name.text = display_name.replace("_", " ").strip_edges()
	label_parenthesis.text = "()"
	label_name.tooltip_text = description
	label_name.mouse_filter = Control.MOUSE_FILTER_PASS
	label_name.edited.connect(func (t): display_name = t)
	if side == E.Side.OUTPUT:
		box.alignment = BoxContainer.ALIGNMENT_END
		box.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		#box.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	box.add_child(label_name)
	box.add_child(label_parenthesis)
	return box
	
