extends HBaseNode

static var _title = "Value changed"
static var _type = "core/utility_value_changed"
static var _category = "Core"
static var _icon = "eye"

func _init() -> void:
	title = _title
	type = _type
	PORTS = {
		"changed": HPortFlow.new(E.Side.OUTPUT),
		"watch": HBasePort.new(E.Side.INPUT, E.CONNECTION_TYPES.VARIANT),
	}

var _last_value
func update(_last_changed := "") -> void:
	print("Update: ", _last_value, " ", PORTS.watch.value)
	if PORTS.watch.value != _last_value:
		emit("changed")
		_last_value = PORTS.watch.value
