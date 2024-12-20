extends Label
class_name HEditableLabel

var editable := false
var line: LineEdit

signal edited(new_text: String)

func _init(_editable: = false) -> void:
	editable = _editable
	mouse_filter = MOUSE_FILTER_PASS
	line = LineEdit.new()
	add_child(line)
	line.visible = false
	line.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	line.text_submitted.connect(update_label)
	line.focus_exited.connect(cancel_update)
	line.select_all_on_focus = true
	gui_input.connect(on_gui_input)
	

func on_gui_input(event: InputEvent) -> void:
	if not editable: return
	if event is InputEventMouseButton:
		if event.double_click == true:
			edit()
			get_viewport().set_input_as_handled()
			
func edit():
	line.size = size + Vector2(30, 0)
	line.position = Vector2(0, size.y)
	line.add_theme_font_size_override("font_size", get_theme_font_size("font_size"))
	line.text = text
	line.select_all()
	line.visible = true
	line.grab_focus()

func cancel_update():
	line.visible = false

func update_label(new_text: String):
	text = new_text
	line.visible = false
	edited.emit(new_text)
