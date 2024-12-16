extends HBaseNode
class_name HNodeOperatorText

static var _title = "Text Operations"
static var _type = "core/op/text"
static var _category = "Core"
static var _icon = "text"


var text := HPortText.new(E.Side.INPUT)
var vars := HPortDict.new(E.Side.INPUT, { 
	"type": E.CONNECTION_TYPES.VARIANT, 
	"multiple": true
})
var split := HPortBool.new(E.Side.INPUT, {  "default": false })
var delimiter := HPortText.new(E.Side.INPUT, { "collapsed": true })
var trim := HPortBool.new(E.Side.INPUT, { "default": false })
var r_text := HPortText.new(E.Side.OUTPUT)
var r_array := HPortArray.new(E.Side.OUTPUT)

func _init() -> void:
	title = _title
	type = _type
	

func update(_last_changed: HBasePort = null) -> void:
	if _last_changed in [split, null]:
		delimiter.collapsed = not split.value
		r_array.collapsed = not split.value
		r_text.collapsed = split.value
		update_slots()
	
	var t : String = text.value
	for _name in vars.value:
		t = t.replace("[%s]" % _name, str(vars.value[_name]))
	if trim.value:
		t = t.strip_edges()
	
	# Normal text
	if not split.value:
		r_text.value = t
	
	# Split
	else:
		var r = t.split(delimiter.value)
		if trim.value: 
			for i in r.size():
				r[i] = r[i].strip_edges()
		r_array.value = Array(r)
