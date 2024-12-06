extends HBaseNode
class_name HNodeOperatorText

static var _title = "Text Operations"
static var _type = "core/op/text"

func _init() -> void:
	title = _title
	type = _type
	VALS = {
		"text": HPortText.new({
			"type": G.graph.TYPES.TEXT,
			"side": INPUT
		}),
		"vars": HPortDict.new({
			"type": G.graph.TYPES.VARIANT,
			"side": INPUT,
			"dictionary": true
		}),
		"split": HPortBool.new({
			"type": G.graph.TYPES.BOOL,
			"default": false,
			"side": INPUT
		}),
		"delimiter": HPortText.new({
			"type": G.graph.TYPES.TEXT,
			"side": INPUT,
			"visible": false
		}),
		"trim": HPortBool.new({
			"type": G.graph.TYPES.BOOL,
			"default": false,
			"side": INPUT
		}),
		"r_text": HPortText.new({
			"type": G.graph.TYPES.TEXT,
			"side": OUTPUT
		}),
		"r_array": HPortArray.new({
			"type": G.graph.TYPES.VARIANT_ARRAY,
			"side": OUTPUT
		})
	}

func update() -> void:
	if _last_port_changed == "split":
		VALS.delimiter.visible = VALS.split.value
		VALS.r_array.visible = VALS.split.value
		VALS.r_text.visible = not VALS.split.value
		update_slots()
	
	var t : String = VALS.text.value
	for _name in VALS.vars.value:
		t = t.replace("[%s]" % _name, str(VALS.vars.value[_name]))
	if VALS.trim.value:
		t = t.strip_edges()
	
	# Normal text
	if not VALS.split.value:
		VALS.r_text.value = t
	
	# Split
	else:
		var r = t.split(VALS.delimiter.value)
		if VALS.trim.value: 
			for i in r.size():
				r[i] = r[i].strip_edges()
		VALS.r_array.value = Array(r)
