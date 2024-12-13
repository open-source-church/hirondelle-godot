extends HBasePort
class_name HPortDict

var hbox : HBoxContainer
@onready var dict : Dictionary = {}
@onready var dict_types : Dictionary = {}

func _init(_side : E.Side, opt : Dictionary = {}):
	var _type = opt.get("type", E.CONNECTION_TYPES.VARIANT_ARRAY)
	super(_side, _type, opt)

func get_component(_params) -> Control:
	hbox = HBoxContainer.new()
	return hbox

func _get_value():
	return dict

func _set_value(val):
	if val is Dictionary:
		dict = val

func update_labels():
	# Clear labels
	for c in hbox.get_children(): c.queue_free()
	
	if not dict_types: 
		update_from_connections(true)
	
	#var sources = get_ports_connected_to()
	for key in dict:
		
		var lbl = Label.new()
		lbl.mouse_filter = Control.MOUSE_FILTER_PASS
		lbl.tooltip_text = "Val: %s" % str(dict[key])
		lbl.text = key
		
		var stylebox = StyleBoxFlat.new()
		stylebox.bg_color = E.connection_colors[dict_types[key]].darkened(0.0)
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

func update_from_connections(no_signal = false):
	dict = {}
	dict_types = {}
	var keys = {}
	for c in get_connections_to():
		var key = keys.get_or_add(c.from_port.name, 0)
		if key:
			key = "%s_%s" % [c.from_port.name, key]
		else:
			key = c.from_port.name
		keys[c.from_port.name] += 1
		dict[key] = c.from_port.value
		dict_types[key] = c.from_port.type
	
	if not no_signal:
		value_changed.emit()

func _on_value_changed():
	update_labels()
	
