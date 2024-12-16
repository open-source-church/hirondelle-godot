extends HBaseNode

static var _title = "Test Node 2"
static var _type = "core/test_2"
static var _category = "Core"
static var _description = "Un node pour tester des trucs."

var input_flow := HPortFlow.new(E.Side.INPUT)
var int_a := HPortIntSpin.new(E.Side.INPUT)

func _init() -> void:
	title = _title
	type = _type

func update(_last_changed: HBasePort = null) -> void:
	if _last_changed:
		print("UPDATE %s: %s" % [_last_changed, _last_changed.value])
	
	if _last_changed and _last_changed != int_a:
		int_a.value += 1
