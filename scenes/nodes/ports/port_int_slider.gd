extends HBasePort
class_name HPortIntSlider

var hbox : HBoxContainer
var slider : HSlider
var lbl_value : Label
var btn_reset : Button


func _init(side : E.Side, opt : Dictionary = {}):
	var _type = opt.get("type", E.CONNECTION_TYPES.INT)
	super(side, _type, opt)

func get_component(_params : Dictionary) -> Control:
	hbox = HBoxContainer.new()
	slider = HSlider.new()
	slider.custom_minimum_size = Vector2(100, 0)
	slider.rounded = true
	slider.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	slider.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	hbox.add_child(slider)
	lbl_value = Label.new()
	lbl_value.add_theme_font_size_override("font_size", 10)
	lbl_value.add_theme_color_override("font_color", Color(1, 1, 1, 0.5))
	lbl_value.visible = false
	hbox.add_child(lbl_value)
	btn_reset = Button.new()
	btn_reset.icon = G.get_main_icon("reset", 16)
	btn_reset.flat = true
	btn_reset.theme_type_variation = "ButtonSmall"
	btn_reset.modulate = Color(1, 1, 1, 0.5)
	btn_reset.visible = false
	hbox.add_child(btn_reset)
	slider.value_changed.connect(func (v): lbl_value.text = str(v))
	btn_reset.pressed.connect(reset_value)
	
	return hbox

func _on_params_changed():
	slider.min_value = params.get("min", 0)
	slider.max_value = params.get("max", 100)
	btn_reset.visible = params.get("reset", false)
	lbl_value.visible = params.get("label", false)

func _get_value():
	return slider.value

func _set_value(val):
	slider.value = val
