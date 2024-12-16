extends HBaseNode

static var _title = "Value changed"
static var _type = "core/utility_value_changed"
static var _category = "Core"
static var _icon = "eye"


var changed := HPortFlow.new(E.Side.OUTPUT)
var watch := HPortArray.new(E.Side.INPUT, { 
	"type": E.CONNECTION_TYPES.VARIANT,
	"multiple": true
})

func _init() -> void:
	title = _title
	type = _type
	

var _last_value
func update(_last_changed: HBasePort = null) -> void:
	if watch.value != _last_value:
		changed.emit()
		_last_value = watch.value.duplicate()
