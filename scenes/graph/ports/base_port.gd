extends MarginContainer
class_name HBasePort

## To subclass:
## * get_value
## * set_value
## * get_component
## * _on_params_changed if needed

# Controls

## Option button, to use with [member options]
var option_button: OptionButton
## The custom component that is returned by subclasses
var custom_component: Control
## References to the [HBaseNode] this port belongs to
var node: HBaseNode
## References to the [HGraphEdit] this port belongs to
var graph: HGraphEdit
## Containers.[br]
## [ Margin [ HBox [ VBox [ ] ] ] ]
var main_hbox: HBoxContainer
var main_vbox : HBoxContainer

# Props

## Port is holding a dictionary instead of just a single value.[br]
## Dictionaries allows for multiple connections.
var is_multiple := false

## Ports default value
var default : Variant

## Set [member value] to [member default].
func reset_value() -> void:
	if default != null: value = default

## Ports params. Allow for customization depending on the port type.[br]
## As of now, params include: min/max for sliders, ... #FIXME
var params : Dictionary:
	set(val):
		params = val
		if not is_node_ready(): await ready
		_on_params_changed()
func _on_params_changed() -> void: pass

## Hides the name label in the port
var hide_label := false

## The side(s) of the port. INPUT, OUTPUT, BOTH, NONE.
var side := E.Side.INPUT:
	set(val):
		side = val
		update_view()

## The type of connection this port accepts
var type : E.CONNECTION_TYPES:
	set(val):
		type = val
		update_view()

## Description
var description : String:
	set(val):
		description = val
		update_view()

## Customizes the behavior of [method Object.set].[br]
## When name is changed, we update the view to display the new name
func _set(prop : StringName, val: Variant) -> bool:
	if prop == "name": 
		name = val
		update_view()
		return true
	return false

## Whether the port is collapsed. In can be changed internally on a port basis.
## This is because in [GraphNode]s, [Control] cannot really be hidded, or it messes up the whole
## thing.[br]
## A collapsed port cannot have connections.[br]
## See also [method set_node_collapsed].
var collapsed := false:
	set(val):
		collapsed = val
		main_vbox.visible = not collapsed
		var margin = 0 if collapsed else 3
		add_theme_constant_override("margin_bottom", margin)
		add_theme_constant_override("margin_top", margin)
		_reset_size()

func set_collapsed(val: bool):
	collapsed = val

## Whether the whole node is collapsed. To keep it different than [member collapsed], we
## hide [member main_hbox] (for node) instead of [member main_vbox] (for port specific).
func set_node_collapsed(val: bool):
	main_hbox.visible = not val
	_reset_size()

## Try to signal everyone that things have changed size here.
func _reset_size() -> void:
	# Quite ugly, but otherwise doesn't really work
	reset_size()
	node.reset_size()
	await get_tree().process_frame
	reset_size()
	node.reset_size()

func _init(_side : E.Side, _type : E.CONNECTION_TYPES, opt : Dictionary = {}) -> void:
	side = _side
	type = _type
	#collapsed = opt.get("collapsed", false)
	options = opt.get("options", [])
	options_enum = opt.get("options_enum", {})
	options_labels = opt.get("options_labels", [])
	if options_enum and options_labels:
		print("Setting option enum")
		set_options_from_enum(options_enum, options_labels)
	description = opt.get("description", "")
	default = opt.get("default", null)
	params = opt.get("params", {})
	hide_label = opt.get("hide_label", false)
	is_multiple = opt.get("multiple", false)
	custom_minimum_size = Vector2(0, 0)
	value_changed.connect(_on_value_changed)
	if opt.get("group"):
		add_to_group(opt.group)
	
	add_theme_constant_override("margin_bottom", 3)
	add_theme_constant_override("margin_top", 3)

func _ready() -> void:
	node = get_parent()
	graph = node.graph
	update_view()
	reset_value()

signal value_changed

var value: get=_base_get_value, set=_base_set_value

func _base_get_value() -> Variant:
	if not custom_component.is_node_ready(): return
	if options: return _get_options_value()
	else: return _get_value()

func _get_value(): return null
func _get_options_value() -> Variant:
	return get_option_button_val(option_button)

func _base_set_value(val):
	val = type_cast(val)
	
	var _last_val
	if value is Dictionary or value is Array or value is Image:
		_last_val = value.duplicate()
	else:
		_last_val = value
	
	if not custom_component.is_node_ready(): return
	if options: set_option_button_val(val, option_button)
	
	if typeof(val) != typeof(_last_val) or val != _last_val:
		_set_value(val)
		value_changed.emit()

func _set_value(_val):
	pass

## Performs type conversion to ensure the value is in the proper type
func type_cast(val):
	return val

## Calls node connected by FLOW to this port.
func emit():
	animate_update()
	for c in graph.connections.list_from_node_and_port(node, self):
		c.to_node.run.call_deferred(c.to_port)
		c.animate()
		c.to_node.animate_run()

## Propagates values, following connections
func propagate_value() -> void:
	for c in graph.connections.list_from_node_and_port(node, self):
		if c.from_port.type == E.CONNECTION_TYPES.FLOW: continue
		# Update value
		c.to_port.update_from_connections()
		# Visual feedbacks
		c.to_port.animate_update()
		c.animate()

## Subclass to implement comportement from multiple connections
func update_from_connections():
	for c in get_connections_to():
		value = c.from_port.value

## Returns a list of all connections to that port
func get_connections_to():
	return node.graph.connections.list_to_port(self)

## Provides visual feedback when the value is updated.
func animate_update() -> void:
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color.WHITE, 0.5).from(Color(0.2, 1.0, 0.2))

var options:Array : set=_set_options

func create_options_button():
	option_button = OptionButton.new()
	option_button.visible = false
	main_vbox.add_child(option_button)
	option_button.item_selected.connect(value_changed.emit.unbind(1))
	option_button.item_focused.connect(value_changed.emit.unbind(1))

## Performs transformation on options, to allow for different inputs:[br]
## _options can be either an Array of value, or an Array of Dictionary { "label": lbl, "value": val }
func _set_options(_options):
	if not is_node_ready(): await ready
	var _value = value
	if _options and _options[0] is Dictionary:
		# Already a dictionary, nothing to do
		pass
	elif _options and _options[0]:
		_options = _options.map(func (o): return { "label": o, "value": o })
	else:
		_options = []
	
	if _options and not option_button:
		create_options_button()
	
	if _options == options:
		return
	
	options = _options
	_on_options_changed(_value)

var options_enum: Dictionary
var options_labels: Array
# Enum can be used for options. For the labels, an array with the same number of values must be provided.
func set_options_from_enum(_enum: Dictionary, _labels: Array):
	if not _enum: return
	if _enum.size() != _labels.size():
		push_error("_enum and _labels don't have the same number of values")
	var _options = []
	for i in _enum.size():
		_options.append({
			"label": _labels[i],
			"value": _enum.values()[i]
		})
	options = _options

func _on_options_changed(_last_val) -> void:
	# Hide or shows the custom component and option button, if there are options
	custom_component.visible = options.size() == 0
	option_button.visible = options.size() > 0
	populate_option_button(option_button)
	set_option_button_val(_last_val, option_button)

## Populates an option button
func populate_option_button(btn : OptionButton):
	btn.clear()
	for o in options:
		btn.add_item(str(o.label))

## Helper function to set the val on an option button
func set_option_button_val(val, btn : OptionButton):
	for i in options.size():
		if options[i].value == val: 
			btn.select(i)
			return

func get_option_button_val(btn : OptionButton):
	return options[btn.selected].value

## Can be subclassed to implement custom port behaviors.
func _on_value_changed():
	pass

## Creates the proper nodes for the port.
func update_view():
	if not is_node_ready(): return
	
	# Keep track of value
	var _value
	if custom_component:
		_value = value
	
	# Clear nodes
	for c in get_children():
		c.queue_free()
	
	main_hbox = HBoxContainer.new()
	main_hbox.name = "MainHBox"
	add_child(main_hbox)
	
	# Left Margin
	if side in [E.Side.OUTPUT, E.Side.BOTH]:
		var left_margin = Control.new()
		left_margin.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		#left_margin.custom_minimum_size = Vector2(50, 0)
		left_margin.visible = not collapsed
		main_hbox.add_child(left_margin)
	
	main_vbox = HBoxContainer.new()
	main_vbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	main_hbox.add_child(main_vbox)
	if not hide_label:
		var lbl = Label.new()
		lbl.text = "%s" % name.replace("_", " ").strip_edges()
		lbl.add_theme_font_size_override("font_size", 12)
		lbl.add_theme_color_override("font_color", Color.GRAY)
		lbl.tooltip_text = description
		lbl.mouse_filter = Control.MOUSE_FILTER_PASS
		main_vbox.add_child(lbl)
	
	# Custom component
	custom_component = get_component(params)
	main_vbox.add_child(custom_component)
	if options:
		create_options_button()
	main_vbox.visible = not collapsed
	
	# Put value back
	if _value:
		value = _value
	
	# Right Margin
	if side in [E.Side.INPUT, E.Side.BOTH]:
		var right_margin = Control.new()
		right_margin.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		#right_margin.custom_minimum_size = Vector2(50, 0)
		main_hbox.add_child(right_margin)
		right_margin.visible = not collapsed

## Subclass that.
## If component is editable, then when changed don't forget to emit:
## value_changed.emit (no arguments, so unbind if necessary)
## for example: text_edit.text_changed.connect(value_changed.emit.unbind(1))
func get_component(_params : Dictionary) -> Control:
	var lbl = Label.new()
	return lbl
