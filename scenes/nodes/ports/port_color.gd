extends HBasePort
class_name HPortColor

var hbox : HBoxContainer
var btn : ColorPickerButton

func _init(_side : E.Side, opt : Dictionary = {}):
	var _type = opt.get("type", E.CONNECTION_TYPES.COLOR)
	super(_side, _type, opt)

func get_component(_params) -> Control:
	hbox = HBoxContainer.new()
	btn = ColorPickerButton.new()
	btn.text = "Pick"
	hbox.add_child(btn)
	return hbox

func _get_value():
	return btn.color

func _set_value(val):
	btn.color = val
