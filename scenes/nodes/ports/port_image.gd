extends HBasePort
class_name HPortImage

var image: Image
var preview: TextureRect
var label: Label

func _init(_side : E.Side, opt : Dictionary = {}):
	var _type = opt.get("type", E.CONNECTION_TYPES.IMAGE)
	super(_side, _type, opt)

func get_component(_params) -> Control:
	var box = VBoxContainer.new()
	preview = TextureRect.new()
	preview.expand_mode = TextureRect.EXPAND_FIT_HEIGHT_PROPORTIONAL
	preview.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	preview.custom_minimum_size = Vector2(200, 0)
	label = Label.new()
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.add_theme_font_size_override("font_size", 12)
	label.modulate = Color(1, 1, 1, .7)
	box.add_child(preview)
	box.add_child(label)
	return box

func _get_value():
	return image

func _set_value(val: Image):
	print("[Image %s] Set value: " % get_parent().name, val)
	image = val
	if image:
		preview.texture = ImageTexture.create_from_image(value)
		var _size = image.get_size()
		label.text = "%s x %s" % [_size.x, _size.y]
	else:
		preview.texture = null
		label.text = ""
	reset_size()
	get_parent().reset_size()

#func _on_value_changed():
	#print("On value changed")
