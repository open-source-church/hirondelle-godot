extends HBaseNode

static var _title = "Boolean operations"
static var _type = "core/op/bool"
static var _category = "Core"
static var _icon = "bool"


var operator := HPortText.new(E.Side.NONE, {
	"default": "Add",
	"options": ["And", "Or", "XOR", "Not", "Equal", "Different"]
})
var multiple := HPortBool.new(E.Side.INPUT, { "description": "Use multiple vars" })
var a := HPortBool.new(E.Side.INPUT)
var b := HPortBool.new(E.Side.INPUT)
var vars := HPortDict.new(E.Side.INPUT, { "type": E.CONNECTION_TYPES.BOOL, "params" : { "show_value" : true } })
var r := HPortBool.new(E.Side.OUTPUT)

func _init() -> void:
	title = _title
	type = _type
	

func update(_last_changed: HBasePort = null) -> void:
	
	if _last_changed in [null, operator, multiple]:
		b.collapsed = multiple.value or operator.value == "Not"
		a.collapsed = multiple.value
		vars.collapsed = not multiple.value
		update_slots()
	
	var _vars: Array = vars.value.values()
	if operator.value == "And":
		if multiple.value:
			r.value = _vars.all(func (v): return v)
		else:
			r.value = a.value and b.value
	if operator.value == "Or":
		if multiple.value:
			r.value = _vars.any(func (v): return v)
		else:
			r.value = a.value or b.value
	if operator.value == "XOR":
		if multiple.value:
			r.value = _vars.count(true) == 1
		else:
			r.value = (a.value and not b.value) or (not a.value and b.value)
	if operator.value == "Not":
		if multiple.value:
			if _vars.size() != 1:
				show_warning("NOT must have exactly one var attached", 3)
			else:
				show_warning("")
				r.value = not _vars.front()
		else:
			r.value = not a.value
	if operator.value == "Equal":
		if multiple.value:
			r.value = _vars.all(func (v): return v == _vars.front())
		else:
			r.value = a.value == b.value
	if operator.value == "Different":
		if multiple.value:
			r.value = _vars.size() == 2 and _vars[0] != _vars[1]
		else:
			r.value = a.value != b.value
