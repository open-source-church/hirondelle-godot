extends HBoxContainer
class_name HBasePort

## To subclass:
## * get_value
## * set_value
## * get_component


var default : Variant
var params : Dictionary:
	set(val):
		params = val
		if not is_node_ready(): await ready
		_on_params_changed()
func _on_params_changed() -> void: pass

var hide_label := false
var option_button : OptionButton
var custom_component : Control

func _init(opt : Dictionary) -> void:
	side = opt.get("side", E.Side.INPUT)
	type = opt.type
	visible = opt.get("visible", true)
	options = opt.get("options", [])
	description = opt.get("description", "")
	default = opt.get("default", null)
	params = opt.get("params", {})
	hide_label = opt.get("hide_label", false)

func _ready() -> void:
	update_view()
	if default != null: value = default


var side := E.Side.INPUT:
	set(val):
		side = val
		update_view()
		
var type : HGraphEdit.TYPES:
	set(val):
		type = val
		update_view()

var description : String:
	set(val):
		description = val
		update_view()

func _set(prop : StringName, value: Variant) -> bool:
	if prop == "name": 
		name = value
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
	if not custom_component.is_node_ready(): return
	_set_value(val)
func _set_value(val):
	pass


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

func _on_options_changed(_last_value) -> void:
	custom_component.visible = options.size() == 0
	option_button.visible = options.size() > 0
	populate_option_button(option_button)
	set_option_button_val(_last_value, option_button)

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

var _last_value
func _process(_delta: float) -> void:
	if value != _last_value:
		value_changed.emit()
		_last_value = value

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
		add_child(left_margin)
	
	
	var vbox = HBoxContainer.new()
	add_child(vbox)
	if not hide_label:
		var lbl = Label.new()
		lbl.text = "%s:" % name
		lbl.tooltip_text = description
		lbl.mouse_filter = Control.MOUSE_FILTER_PASS
		vbox.add_child(lbl)
	# Custom component
	custom_component = get_component(params)
	vbox.add_child(custom_component)
	option_button = OptionButton.new()
	option_button.visible = false
	vbox.add_child(option_button)
	
	if _last_value:
		value = _last_value
	
	# Right Margin
	if side in [E.Side.INPUT, E.Side.BOTH]:
		var right_margin = Control.new()
		right_margin.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		add_child(right_margin)

## Subclass that
func get_component(_params : Dictionary) -> Control:
	var lbl = Label.new()
	return lbl
