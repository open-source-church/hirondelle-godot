extends Node
class_name HBaseSource

## A source for a node, meaning something it needs to function properly.

## Whether the source is active or not.
## Emits the [member becomes_active] / [member becomes_inactive] on change.
var active := true: set=set_active, get=get_active

## Source became active
signal becomes_active
## Source became inactive
signal becomes_inactive

func _init() -> void:
	name = "base"

func set_active(val: bool) -> void:
	if val != active and val:
		becomes_active.emit()
	elif val != active and not val:
		becomes_active.emit()
	active = val

## Subclass to implement different behavior.
func get_active() -> bool:
	return true
