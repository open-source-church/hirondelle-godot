extends HBasePort
class_name HPortVec2

var txt_x : LineEdit
var txt_y : LineEdit

func _init(_side : E.Side, opt : Dictionary = {}):
	var _type = opt.get("type", E.CONNECTION_TYPES.VEC2)
	super(_side, _type, opt)

func get_component(_params) -> Control:
	var box = HBoxContainer.new()
	txt_x = LineEdit.new()
	txt_x.alignment = HORIZONTAL_ALIGNMENT_CENTER
	txt_x.tooltip_text = "x"
	var lbl = Label.new()
	lbl.text = ":"
	txt_y = LineEdit.new()
	txt_y.tooltip_text = "y"
	txt_y.alignment = HORIZONTAL_ALIGNMENT_CENTER
	box.add_child(txt_x)
	box.add_child(lbl)
	box.add_child(txt_y)
	return box

func _get_value():
	return Vector2(float(txt_x.text), float(txt_y.text))

func _set_value(val):
	txt_x.text = str(val.x)
	txt_y.text = str(val.y)
