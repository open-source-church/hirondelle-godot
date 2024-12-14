extends HBasePort
class_name HPortFile

var line : LineEdit
var hbox: HBoxContainer
var btn: Button
var dialog: FileDialog

func _init(_side : E.Side, opt : Dictionary = {}):
	var _type = opt.get("type", E.CONNECTION_TYPES.TEXT)
	super(_side, _type, opt)

func get_component(_params) -> Control:
	hbox = HBoxContainer.new()
	line = LineEdit.new()
	line.custom_minimum_size = Vector2(200, 0)
	line.text_changed.connect(value_changed.emit.unbind(1))
	#line.clear_button_enabled = true
	hbox.add_child(line)
	btn = Button.new()
	btn.text = "..."
	btn.flat = true
	btn.theme_type_variation = "ButtonSmall"
	btn.modulate = Color(1, 1, 1, 0.5)
	hbox.add_child(btn)
	
	dialog = FileDialog.new()
	dialog.file_mode = FileDialog.FILE_MODE_OPEN_FILE
	dialog.use_native_dialog = true
	dialog.access = FileDialog.ACCESS_FILESYSTEM
	add_child(dialog)
	dialog.file_selected.connect(line.set_text)
	dialog.file_selected.connect(value_changed.emit.unbind(1))
	btn.pressed.connect(dialog.popup_centered_clamped)
	
	return hbox

func _on_params_changed():
	var filters = params.get("filters", [])
	if filters:
		dialog.filters = filters

func _get_value():
	return line.text

func _set_value(val):
	line.text = str(val)
	
	
