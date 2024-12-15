extends HBaseNode

static var _title = "Boolean operations"
static var _type = "core/op/bool"
static var _category = "Core"
static var _icon = "bool"

func _init() -> void:
	title = _title
	type = _type
	PORTS = {
		"operator": HPortText.new(E.Side.NONE, {
			"default": "Add",
			"options": ["And", "Or", "XOR", "Not", "Equal", "Different"]
		}),
		"multiple": HPortBool.new(E.Side.INPUT, { "description": "Use multiple vars" }),
		"a": HPortBool.new(E.Side.INPUT),
		"b": HPortBool.new(E.Side.INPUT),
		"vars": HPortDict.new(E.Side.INPUT, { "type": E.CONNECTION_TYPES.BOOL, "params" : { "show_value" : true } }),
		"r": HPortBool.new(E.Side.OUTPUT)
	}

func update(_last_changed: = "") -> void:
	var multiple = PORTS.multiple.value
	
	if _last_changed in ["", "operator", "multiple"]:
		PORTS.b.collapsed = multiple or PORTS.operator.value == "Not"
		PORTS.a.collapsed = multiple
		PORTS.vars.collapsed = not multiple
		update_slots()
	
	var vars: Array = PORTS.vars.value.values()
	if PORTS.operator.value == "And":
		if multiple:
			PORTS.r.value = vars.all(func (v): return v)
		else:
			PORTS.r.value = PORTS.a.value and PORTS.b.value
	if PORTS.operator.value == "Or":
		if multiple:
			PORTS.r.value = vars.any(func (v): return v)
		else:
			PORTS.r.value = PORTS.a.value or PORTS.b.value
	if PORTS.operator.value == "XOR":
		if multiple:
			PORTS.r.value = vars.count(true) == 1
		else:
			PORTS.r.value = (PORTS.a.value and not PORTS.b.value) or (not PORTS.a.value and PORTS.b.value)
	if PORTS.operator.value == "Not":
		if multiple:
			if vars.size() != 1:
				show_warning("NOT must have exactly one var attached", 3)
			else:
				show_warning("")
				PORTS.r.value = not vars.front()
		else:
			PORTS.r.value = not PORTS.a.value
	if PORTS.operator.value == "Equal":
		if multiple:
			PORTS.r.value = vars.all(func (v): return v == vars.front())
		else:
			PORTS.r.value = PORTS.a.value == PORTS.b.value
	if PORTS.operator.value == "Different":
		if multiple:
			PORTS.r.value = vars.size() == 2 and vars[0] != vars[1]
		else:
			PORTS.r.value = PORTS.a.value != PORTS.b.value
