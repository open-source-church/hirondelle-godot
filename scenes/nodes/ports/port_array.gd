extends HBasePort
class_name HPortArray

## Displays an array
##
## Params:
## * show_index (default: false): displays the index (and value in tooltip).

var hbox : HFlowContainer
var array : Array

var _showing_index := false
var _max_item_for_full_display := 12
var _max_item_for_index := 50

func _init(_side : E.Side, opt : Dictionary = {}):
	var _type = opt.get("type", E.CONNECTION_TYPES.VARIANT_ARRAY)
	super(_side, _type, opt)

func get_component(_params) -> Control:
	hbox = HFlowContainer.new()
	hbox.custom_minimum_size = Vector2(300, 0)
	if side == E.Side.OUTPUT:
		hbox.alignment = FlowContainer.ALIGNMENT_END
	hbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	update_labels()
	return hbox

func _get_value():
	return array

func _set_value(val):
	if val is Array:
		array = val

func _on_params_changed() -> void:
	update_labels()

func update_labels():
	# Clear labels
	for c in hbox.get_children(): c.free()
	
	if array.size() > _max_item_for_index:
		var lbl = Label.new()
		lbl.text = "%d items" % len(array)
		hbox.add_child(lbl)
		_showing_index = false
		_reset_size()
		return
	
	for i in array.size():
		var v = array[i]
		
		var lbl = Label.new()
		
		if array.size() > _max_item_for_full_display or params.get("show_index", false):
			lbl.text = str(i)
			_showing_index = true
		else:
			lbl.text = str(v)
			lbl.clip_text = true
			lbl.text_overrun_behavior = TextServer.OVERRUN_TRIM_WORD_ELLIPSIS
			lbl.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			lbl.custom_minimum_size = Vector2(80, 0)
			_showing_index = false
		
		lbl.tooltip_text = str(v)
		lbl.mouse_filter = Control.MOUSE_FILTER_PASS
		
		var stylebox = StyleBoxFlat.new()
		#stylebox.bg_color = E.connection_colors[s.type].darkened(0.0)
		stylebox.bg_color.a = 0.3
		stylebox.content_margin_bottom = 3
		stylebox.content_margin_left = 6
		stylebox.content_margin_right = 6
		stylebox.content_margin_top = 3
		stylebox.corner_radius_bottom_left = 3
		stylebox.corner_radius_bottom_right = 3
		stylebox.corner_radius_top_left = 3
		stylebox.corner_radius_top_right = 3
		lbl.add_theme_stylebox_override("normal", stylebox)
		
		hbox.add_child(lbl)
	
	_reset_size()

func update_from_connections():
	array.clear()
	for c in get_connections_to():
		array.append(c.from_port.value)
	value_changed.emit()
	update_labels()

func _on_value_changed():
	update_labels()
