extends MenuButton

enum Actions { SelectAll, Group }

signal select_all
signal group

func _init() -> void:
	get_popup().id_pressed.connect(on_id_pressed)
	
	add_item("Select all", Actions.SelectAll, KEY_A, [KEY_CTRL])
	add_item("Group", Actions.Group, KEY_G, [KEY_CTRL])
	

func add_item(title: String, action: Actions, keycode:Key = KEY_NONE, modifiers : Array[Key] = []) -> void:
	var shortcut = Shortcut.new()
	if keycode:
		var key = InputEventKey.new()
		shortcut.events.append(key)
		if KEY_CTRL in modifiers:
			key.ctrl_pressed = true
		if KEY_SHIFT in modifiers:
			key.shift_pressed = true
		if KEY_META in modifiers:
			key.meta_pressed = true
		if KEY_ALT in modifiers:
			key.alt_pressed = true
		key.keycode = keycode
	get_popup().add_item(title, action)
	get_popup().set_item_shortcut(get_popup().item_count - 1, shortcut, true)

func on_id_pressed(id: int) -> void:
	if id == Actions.SelectAll: select_all.emit()
	if id == Actions.Group: group.emit()
