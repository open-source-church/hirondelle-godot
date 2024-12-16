extends HBaseNode
class_name HNodeOperatorArray

static var _title = "Array Operations"
static var _type = "core/op/array"
static var _category = "Core"
static var _icon = "array"


var start_loop := HPortFlow.new(E.Side.INPUT)
var next := HPortFlow.new(E.Side.INPUT)
var for_each := HPortFlow.new(E.Side.OUTPUT)
var arrays := HPortDict.new(E.Side.INPUT, {
	"multiple": true
})
var index := HPortIntSlider.new(E.Side.INPUT)
var loop := HPortBool.new(E.Side.INPUT, { "default": false })
var merged := HPortArray.new(E.Side.OUTPUT)
var value := HPortText.new(E.Side.OUTPUT)
var idx := HPortIntSpin.new(E.Side.OUTPUT)
var count := HPortIntSpin.new(E.Side.OUTPUT)

func _init() -> void:
	title = _title
	type = _type
	

func run(_port: HBasePort):
	if _port == start_loop:
		index.value = 0
		for_each.emit()
	if _port == next:
		var i = index.value + 1
		if i < count.value:
			index.value = i
			for_each.emit()
		elif loop.value:
			index.value = 0
			for_each.emit()

func update(_last_changed: HBasePort = null) -> void:
	var _merged := []
	for arr in arrays.value:
		_merged.append_array(arrays.value[arr])
	
	index.params = { "min": 0, "max": len(_merged) - 1 }
	
	# Get Value
	if _merged:
		merged.value = _merged
		value.value = _merged[index.value]
		idx.value = index.value
		count.value = len(_merged)
		
