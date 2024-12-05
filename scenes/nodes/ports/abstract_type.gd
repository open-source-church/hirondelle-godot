extends HBoxContainer

var value: set=set_value, get=get_value

func set_value(val) -> void:
	value = val

func get_value():
	return value

var enabled := true : set=set_enabled, get=get_enabled

func set_enabled(val : bool):
	enabled = val

func get_enabled():
	return enabled
