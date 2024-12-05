extends HBaseNode

static var _title = "Value changed"
static var _type = "core/utility_value_changed"

func _init() -> void:
	title = _title
	type = _type
	COMPONENTS = {
		"changed": Port.new({
			"type": G.graph.TYPES.FLOW, 
			"side": OUTPUT
		}),
		"watch": Port.new({
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
