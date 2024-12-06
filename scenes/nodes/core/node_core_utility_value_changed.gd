extends HBaseNode

static var _title = "Value changed"
static var _type = "core/utility_value_changed"
static var _category = "Core"
static var _icon = "eye"

func _init() -> void:
	title = _title
	type = _type
	VALS = {
		"changed": HPortFlow.new({
			"type": G.graph.TYPES.FLOW, 
			"side": OUTPUT
		}),
		"watch": HBasePort.new({
			"type": G.graph.TYPES.VARIANT, 
			"side": INPUT
		}),
	}

var _last_value
func update() -> void:
	print("Update: ", _last_value, " ", VALS.watch.value)
	if VALS.watch.value != _last_value:
		emit("changed")
		_last_value = VALS.watch.value
