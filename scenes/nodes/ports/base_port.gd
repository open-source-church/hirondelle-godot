extends HBoxContainer
class_name HBasePort

## To subclass:
## * get_value
## * set_value
## * get_component
## * _on_params_changed if needed

var default : Variant
var params : Dictionary:
	set(val):
		params = val
		if not is_node_ready(): await ready
		_on_params_changed()
func _on_params_changed() -> void: pass

## Hides the name label
var hide_label := false
var option_button : OptionButton
var custom_component : Control

## Port is holding a dictionary instead of just a single value.
##
## Dictionaries allows for multiple connections.
var is_dictionary := false

var graph : HGraphEdit

var collapsed := false:
	set(val):
		collapsed = val
		update_view()
		await get_tree().process_frame
		reset_size()
		get_parent().reset_size()

func set_collapsed(val: bool):
	collapsed = val

func _init(_side : E.Side, _type : E.CONNECTION_TYPES, opt : Dictionary = {}) -> void:
	side = _side
	type = _type
	visible = opt.get("visible", true)
	options = opt.get("options", [])
	description = opt.get("description", "")
	default = opt.get("default", null)
	params = opt.get("params", {})
	hide_label = opt.get("hide_label", false)
	is_dictionary = opt.get("dictionary", false)
	custom_minimum_size = Vector2(0, 0)
	value_changed.connect(_on_value_changed)

func _ready() -> void:
	update_view()
	reset_value()

## Set [member value] to [member default].
func reset_value() -> void:
	if default != null: value = default

var side := E.Side.INPUT:
	set(val):
		side = val
		update_view()
		
var type : E.CONNECTION_TYPES:
	set(val):
		type = val
		update_view()

var description : String:
	set(val):
		description = val
		update_view()

func _set(prop : StringName, val: Variant) -> bool:
	if prop == "name": 
		name = val
		update_view()
		return true
	return false

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
	if value is Dictionary or value is Array:
		_last_val = value.duplicate()
	else:
		_last_val = value
	
	if not custom_component.is_node_ready(): return
	if options: set_option_button_val(val, option_button)
	if val != _last_val:
		_set_value(val)
		value_changed.emit()
func _set_value(_val):
	pass

## Performs type conversion to ensure the value is in the proper type
func type_cast(val):
	return val

## Returns a list of all connections to that port
func get_connections_to():
	var node = get_parent() as HBaseNode
	return node.graph.connections.list_to_port(self)

## Subclass to implement comportement from multiple connections
func update_from_connections():
	for c in get_connections_to():
		value = c.from_port.value

var options:Array : set=_set_options

## _options is either an Array of value, or an Array of Dictionary { "label": lbl, "value": val }
func _set_options(_options):
	if not is_node_ready(): await ready
	
	var _value = value
	
	if _options and _options[0] is Dictionary:
		pass
	elif _options and _options[0]:
		_options = _options.map(func (o): return { "label": o, "value": o })
	else:
		_options = []
	
	if _options == options:
		return
	
	options = _options
	
	_on_options_changed(_value)

func _on_options_changed(_last_val) -> void:
	custom_component.visible = options.size() == 0
	option_button.visible = options.size() > 0
	populate_option_button(option_button)
	set_option_button_val(_last_val, option_button)

## Helper function to populate an option button
func populate_option_button(btn : OptionButton):
	btn.clear()
	for o in options:
		btn.add_item(str(o.label))
	
	#update_view()

## Helper function to set the val on an option button
func set_option_button_val(val, btn : OptionButton):
	for i in options.size():
		if options[i].value == val: 
			btn.select(i)
			return

func get_option_button_val(btn : OptionButton):
	return options[btn.selected].value

#var _last_value
#func _process(_delta: float) -> void:
	#if value != _last_value:
		#value_changed.emit()
		#_on_value_changed()
		#if value is Dictionary or value is Array:
			#_last_value = value.duplicate()
		#else:
			#_last_value = value

func _on_value_changed():
	pass

## Creates the proper nodes for the port.
func update_view():
	if not is_node_ready(): return
	
	# Clear nodes
	for c in get_children():
		c.queue_free()
	
	# Left Margin
	if side in [E.Side.OUTPUT, E.Side.BOTH]:
		var left_margin = Control.new()
		left_margin.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		#left_margin.custom_minimum_size = Vector2(50, 0)
		left_margin.visible = not collapsed
		add_child(left_margin)
	
	var vbox = HBoxContainer.new()
	add_child(vbox)
	if not hide_label:
		var lbl = Label.new()
		lbl.text = "%s" % name
		lbl.add_theme_font_size_override("font_size", 12)
		lbl.add_theme_color_override("font_color", Color.GRAY)
		lbl.tooltip_text = description
		lbl.mouse_filter = Control.MOUSE_FILTER_PASS
		vbox.add_child(lbl)
	# Custom component
	custom_component = get_component(params)
	vbox.add_child(custom_component)
	option_button = OptionButton.new()
	option_button.visible = false
	vbox.add_child(option_button)
	option_button.item_selected.connect(value_changed.emit.unbind(1))
	option_button.item_focused.connect(value_changed.emit.unbind(1))
	vbox.visible = not collapsed
	
	# FIXME: why was this needed ?
	#if _last_value:
		#value = _last_value
	
	# Right Margin
	if side in [E.Side.INPUT, E.Side.BOTH]:
		var right_margin = Control.new()
		right_margin.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		#right_margin.custom_minimum_size = Vector2(50, 0)
		add_child(right_margin)
		right_margin.visible = not collapsed
	

## Subclass that.
## If component is editable, then when changed don't forget to emit:
## value_changed.emit (no arguments, so unbind if necessary)
## for example: text_edit.text_changed.connect(value_changed.emit.unbind(1))
func get_component(_params : Dictionary) -> Control:
	var lbl = Label.new()
	return lbl
