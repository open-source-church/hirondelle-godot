extends HBoxContainer

@onready var txt_x: LineEdit = $TxtX
@onready var txt_y: LineEdit = $TxtY

var value : Vector2:
	set(val):
		value = val
		if not is_node_ready(): await ready
		txt_x.text = str(val.x)
		txt_y.text = str(val.y)

	get():
		return Vector2(float(txt_x.text), float(txt_y.text))
