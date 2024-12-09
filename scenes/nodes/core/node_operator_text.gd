extends HBaseNode
class_name HNodeOperatorText

static var _title = "Text Operations"
static var _type = "core/op/text"
static var _category = "Core"
static var _icon = "text"

func _init() -> void:
	title = _title
	type = _type
	PORTS = {
		"text": HPortText.new(E.Side.INPUT),
		"vars": HPortDict.new(E.Side.INPUT, { "dictionary": true }),
		"split": HPortBool.new(E.Side.INPUT, {  "default": false }),
		"delimiter": HPortText.new(E.Side.INPUT, { "visible": false }),
		"trim": HPortBool.new(E.Side.INPUT, { "default": false }),
		"r_text": HPortText.new(E.Side.OUTPUT),
		"r_array": HPortArray.new(E.Side.OUTPUT)
	}

func update() -> void:
	if _last_port_changed == "split":
		PORTS.delimiter.visible = PORTS.split.value
		PORTS.r_array.visible = PORTS.split.value
		PORTS.r_text.visible = not PORTS.split.value
		update_slots()
	
	var t : String = PORTS.text.value
	for _name in PORTS.vars.value:
		t = t.replace("[%s]" % _name, str(PORTS.vars.value[_name]))
	if PORTS.trim.value:
		t = t.strip_edges()
	
	# Normal text
	if not PORTS.split.value:
		PORTS.r_text.value = t
	
	# Split
	else:
		var r = t.split(PORTS.delimiter.value)
		if PORTS.trim.value: 
			for i in r.size():
				r[i] = r[i].strip_edges()
		PORTS.r_array.value = Array(r)
