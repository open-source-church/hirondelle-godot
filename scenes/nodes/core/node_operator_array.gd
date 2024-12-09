extends HBaseNode
class_name HNodeOperatorArray

static var _title = "Array Operations"
static var _type = "core/op/array"
static var _category = "Core"
static var _icon = "array"

func _init() -> void:
	title = _title
	type = _type
	PORTS = {
		"start_loop": HPortFlow.new(E.Side.INPUT),
		"next": HPortFlow.new(E.Side.INPUT),
		"for_each": HPortFlow.new(E.Side.OUTPUT),
		"arrays": HPortDict.new(E.Side.INPUT, {
			"default": false,
			"dictionary": true
		}),
		"index": HPortIntSlider.new(E.Side.INPUT),
		"loop": HPortBool.new(E.Side.INPUT, { "default": false }),
		"merged": HPortArray.new(E.Side.OUTPUT),
		"value": HPortText.new(E.Side.OUTPUT),
		"idx": HPortIntSpin.new(E.Side.OUTPUT),
		"count": HPortIntSpin.new(E.Side.OUTPUT)
	}

func run(subroutine : String):
	if subroutine == "start_loop":
		PORTS.index.value = 0
		emit("for_each")
	if subroutine == "next":
		var i = PORTS.index.value + 1
		if i < PORTS.count.value:
			PORTS.index.value = i
			emit("for_each")
		elif PORTS.loop.value:
			PORTS.index.value = 0
			emit("for_each")

func update() -> void:
	if _last_port_changed == "operator":
		pass
		update_slots()
	
	var merged := []
	for arr in PORTS.arrays.value:
		merged.append_array(PORTS.arrays.value[arr])
	
	PORTS.index.params = { "min": 0, "max": len(merged) - 1 }
	
	# Get Value
	if merged:
		PORTS.merged.value = merged
		PORTS.value.value = merged[PORTS.index.value]
		PORTS.idx.value = PORTS.index.value
		PORTS.count.value = len(merged)
		
