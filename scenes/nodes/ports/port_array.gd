extends HBasePort
class_name HPortArray

var hbox : HBoxContainer
var array : Array

func _init(_side : E.Side, opt : Dictionary = {}):
	var _type = opt.get("type", E.CONNECTION_TYPES.VARIANT_ARRAY)
	super(_side, _type, opt)

func get_component(_params) -> Control:
	hbox = HBoxContainer.new()
	update_labels()
	return hbox

func _get_value():
	return array

func _set_value(val):
	if val is Array:
		array = val

func update_labels():
	# Clear labels
	for c in hbox.get_children(): c.queue_free()
	
	for v in array:
		
		var lbl = Label.new()
		lbl.text = str(v)
		
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

func _on_value_changed():
	update_labels()
