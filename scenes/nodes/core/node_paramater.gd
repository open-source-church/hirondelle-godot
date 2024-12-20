extends HBaseNode

static var _title = "Input/Output parameter"
static var _type = "core/parameter"
static var _category = "Core"
static var _icon = ""

enum ParamSide { INPUT, OUTPUT }
var ParamSideLabels := [ "Input", "Output" ]


var side_ := HPortIntSpin.new(E.Side.NONE, { "options_enum": ParamSide, "options_labels": ParamSideLabels })
var type_ := HPortIntSpin.new(E.Side.NONE, { "options_enum": E.CONNECTION_TYPES, "options_labels": E.CONNECTION_TYPES.keys().map(func (k: String): return k.capitalize() ) })

var flow := HPortFlow.new(E.Side.OUTPUT, { "group": "port", "editable_name": true, "description": "Flow port. Double clic to edit name." })
var default_int := HPortIntSpin.new(E.Side.INPUT, { "group": [ "port", "default" ] })
var int_ := HPortIntSpin.new(E.Side.OUTPUT, { "group": "port" })
var default_float := HPortFloat.new(E.Side.INPUT, { "group": [ "port", "default" ] })
var float_ := HPortFloat.new(E.Side.OUTPUT, { "group": "port" })
var default_text := HPortText.new(E.Side.INPUT, { "group": [ "port", "default" ] })
var text_ := HPortText.new(E.Side.OUTPUT, { "group": "port" })
var default_vec2 := HPortVec2.new(E.Side.INPUT, { "group": [ "port", "default" ] })
var vec2_ := HPortVec2.new(E.Side.OUTPUT, { "group": "port" })
var default_color := HPortColor.new(E.Side.INPUT, { "group": [ "port", "default" ] })
var color_ := HPortColor.new(E.Side.OUTPUT, { "group": "port" })
var default_bool := HPortBool.new(E.Side.INPUT, { "group": [ "port", "default" ] })
var bool_ := HPortBool.new(E.Side.OUTPUT, { "group": "port" })
var default_image := HPortImage.new(E.Side.INPUT, { "group": [ "port", "default" ] })
var image_ := HPortImage.new(E.Side.OUTPUT, { "group": "port" })
var default_array := HPortArray.new(E.Side.INPUT, { "group": [ "port", "default" ] })
var array_ := HPortArray.new(E.Side.OUTPUT, { "group": "port" })

func _init() -> void:
	title = _title
	type = _type
	
	print(E.CONNECTION_TYPES.keys())
	

func update(_last_changed: HBasePort = null) -> void:
	if _last_changed in [type_, side_, null]:
		for n in get_ports_in_group("port"):
			n.collapsed = not n.type == type_.value
			n.side = E.Side.INPUT if side_.value == E.Side.OUTPUT else E.Side.OUTPUT
		
		for n in get_ports_in_group("default"):
			n.collapsed = n.collapsed or side_.value == E.Side.OUTPUT
			n.side = E.Side.INPUT
		update_slots()
