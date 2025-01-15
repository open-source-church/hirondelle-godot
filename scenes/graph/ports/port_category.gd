extends HBasePort
class_name HPortCategory

## A simple port that's not really a port, but just to display a category
##
## Params:
## * align: left, center or right

var title: String
var button: Button
var align

var icon_open := G.get_main_icon("carret_down", 16)
var icon_collapsed := G.get_main_icon("carret_right", 16)

func _init(text: String, opt := {}, _align := HORIZONTAL_ALIGNMENT_CENTER):
	title = text
	align = _align
	opt.hide_label = true
	super(E.Side.NONE, E.CONNECTION_TYPES.TEXT, opt)

func get_component(_params) -> Control:
	#var label := Label.new()
	#label.text = title.to_upper()
	#label.add_theme_font_size_override("font_size", 12)
	#label.add_theme_color_override("font_color", Color.DIM_GRAY)
	#label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	#label.horizontal_alignment = align
	#return label
	var container = MarginContainer.new()
	container.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	container.add_theme_constant_override("margin_top", 6)
	#container.add_theme_constant_override("margin_left", 6)
	#container.add_theme_constant_override("margin_right", 6)
	button = Button.new()
	button.flat = true
	button.text = title.to_upper()
	button.alignment = align
	button.add_theme_font_size_override("font_size", 12)
	button.add_theme_color_override("font_color", Color.DIM_GRAY)
	button.add_theme_color_override("font_pressed_color", Color.DIM_GRAY)
	button.add_theme_color_override("font_focus_color", Color.DIM_GRAY)
	button.add_theme_color_override("font_hover_color", Color.GRAY)
	button.add_theme_color_override("font_hover_pressed_color", Color.GRAY)
	button.add_theme_color_override("icon_normal_color", Color.DIM_GRAY)
	button.add_theme_color_override("icon_pressed_color", Color.DIM_GRAY)
	button.add_theme_color_override("icon_focus_color", Color.DIM_GRAY)
	button.add_theme_color_override("icon_hover_color", Color.GRAY)
	button.theme_type_variation = "ButtonSmall"
	button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	button.toggle_mode = true
	button.button_pressed = true
	button.icon = icon_open
	#button.icon_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	button.toggled.connect(open_category)
	container.add_child(button)
	return container

func open_category(_open: bool):
	if _open:
		button.icon = icon_open
	else:
		button.icon = icon_collapsed
	
	for n in get_ports_in_category():
		n.set_node_collapsed(not _open)
	
	node.update_slots()

func get_ports_in_category() -> Array[HBasePort]:
	var nodes: Array[HBasePort] = []
	var under_me = false
	for n in node.get_children():
		if under_me and n is HBasePort and not n is HPortCategory:
			nodes.append(n)
		elif under_me and n is HBasePort:
			return nodes
		if n == self:
			under_me = true
	return nodes
