extends HBasePort
class_name HPortDict

var hbox : HBoxContainer
@onready var dict : Dictionary = {}
@onready var dict_types : Dictionary = {}

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
		update_from_connections()
	
	#var sources = get_ports_connected_to()
	for key in dict:
		
		var lbl = Label.new()
		lbl.mouse_filter = Control.MOUSE_FILTER_PASS
		lbl.tooltip_text = "Val: %s" % str(dict[key])
		lbl.text = key
		
		var stylebox = StyleBoxFlat.new()
		stylebox.bg_color = G.graph.colors[dict_types[key]].darkened(0.0)
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

func update_from_connections():
	dict = {}
	dict_types = {}
	var keys = {}
	for port in get_ports_connected_to():
		var key = keys.get_or_add(port.name, 0)
		if key:
			key = "%s_%s" % [port.name, key]
		else:
			key = port.name
		keys[port.name] += 1
		dict[key] = port.value
		dict_types[key] = port.type

func _on_value_changed():
	update_labels()
	
