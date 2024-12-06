extends HBasePort
class_name HPortColor

var hbox : HBoxContainer
var btn : ColorPickerButton

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
