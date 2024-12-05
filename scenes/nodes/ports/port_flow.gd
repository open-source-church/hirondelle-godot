extends HBasePort
class_name HPortFlow

var label_name : Label
var label_parenthesis : Label

func _init(opt : Dictionary) -> void:
	super(opt)
	hide_label = true

func get_component(_params) -> Control:
	var box = HBoxContainer.new()
	label_name = Label.new()
	label_parenthesis = Label.new()
	label_parenthesis.add_theme_color_override("font_color", Color.DARK_GRAY)
	label_name.text = name
	label_parenthesis.text = "()"
	box.add_child(label_name)
	box.add_child(label_parenthesis)
	return box
	