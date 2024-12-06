extends HBaseNode
class_name HNodeOperatorArray

static var _title = "Array Operations"
static var _type = "core/op/array"
static var _category = "Core"
static var _icon = "array"

func _init() -> void:
	title = _title
	type = _type
	VALS = {
		"start_loop": HPortFlow.new({
			"type": G.graph.TYPES.FLOW,
			"side": INPUT
		}),
		"next": HPortFlow.new({
			"type": G.graph.TYPES.FLOW,
			"side": INPUT
		}),
		"for_each": HPortFlow.new({
			"type": G.graph.TYPES.FLOW,
			"side": OUTPUT
		}),
		"arrays": HPortDict.new({
			"type": G.graph.TYPES.VARIANT_ARRAY,
			"default": false,
			"side": INPUT,
			"dictionary": true
		}),
		"index": HPortIntSlider.new({
			"type": G.graph.TYPES.INT,
			"side": INPUT,
		}),
		"loop": HPortBool.new({
			"type": G.graph.TYPES.BOOL,
			"default": false,
			"side": INPUT
		}),
		"merged": HPortArray.new({
			"type": G.graph.TYPES.VARIANT_ARRAY,
			"side": OUTPUT
		}),
		"value": HPortText.new({
			"type": G.graph.TYPES.VARIANT,
			"side": OUTPUT
		}),
		"idx": HPortIntSpin.new({
			"type": G.graph.TYPES.INT,
			"side": OUTPUT
		}),
		"count": HPortIntSpin.new({
			"type": G.graph.TYPES.INT,
			"side": OUTPUT
		})
	}

func run(subroutine : String):
	if subroutine == "start_loop":
		VALS.index.value = 0
		emit("for_each")
	if subroutine == "next":
		var i = VALS.index.value + 1
		if i < VALS.count.value:
			VALS.index.value = i
			emit("for_each")
		elif VALS.loop.value:
			VALS.index.value = 0
			emit("for_each")

func update() -> void:
	if _last_port_changed == "operator":
		pass
		update_slots()
	
	var merged := []
	for arr in VALS.arrays.value:
		merged.append_array(VALS.arrays.value[arr])
	
	VALS.index.params = { "min": 0, "max": len(merged) - 1 }
	
	# Get Value
	if merged:
		VALS.merged.value = merged
		VALS.value.value = merged[VALS.index.value]
		VALS.idx.value = VALS.index.value
		VALS.count.value = len(merged)
		
