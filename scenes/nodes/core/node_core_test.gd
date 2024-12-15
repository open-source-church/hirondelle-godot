extends HBaseNode

static var _title = "Test"
static var _type = "core/op/test"
static var _category = "Core"
static var _icon = ""
static var _description = "Test, compare and all that kind of stuff."

enum TextOp { EQUALS, REGEX, CONTAINS, IS_CONTAINED }
var TextLabels = ["Equals", "RegExp match", "Contains", "Is contained in"]
enum NumberOp { EQUALS, LESS, MORE, BETWEEN }
var NumberLabels = ["Equals", "Less than", "More than", "Is between"]
enum BoolOp { AND, OR, XOR, EQUALS }
var BoolLabels = [ "AND", "OR", "XOR", "Equals"]

func _init() -> void:
	title = _title
	type = _type
	PORTS = {
		"test": HPortFlow.new(E.Side.INPUT),
		"true": HPortFlow.new(E.Side.OUTPUT),
		"false": HPortFlow.new(E.Side.OUTPUT),
		"var": HPortDict.new(E.Side.INPUT, { "type": E.CONNECTION_TYPES.VARIANT, "multiple": false, "params": { "show_value": true } }),
		"operator": HPortIntSpin.new(E.Side.INPUT),
		"ignore_case": HPortBool.new(E.Side.INPUT, { "default": true }),
		"text": HPortText.new(E.Side.INPUT),
		"int": HPortIntSpin.new(E.Side.INPUT),
		"intb": HPortIntSpin.new(E.Side.INPUT),
		"float": HPortFloat.new(E.Side.INPUT),
		"floatb": HPortFloat.new(E.Side.INPUT),
		"bool": HPortBool.new(E.Side.INPUT),
		"result": HPortBool.new(E.Side.OUTPUT),
	}

func run(routine:String):
	if routine == "test":
		if PORTS.result.value:
			emit("true")
		else:
			emit("false")

func update(_last_changed := "") -> void:
	# Get source port
	var var_port: HBasePort
	for c in PORTS.var.get_connections_to():
		var_port = c.from_port
	var operator = PORTS.operator.value
	
	# Upate visibility
	if _last_changed in ["", "operator", "var"]:
		PORTS.operator.collapsed = not var_port
		PORTS.text.collapsed = not var_port or not var_port.type == E.CONNECTION_TYPES.TEXT
		PORTS.ignore_case.collapsed = not var_port or not var_port.type == E.CONNECTION_TYPES.TEXT
		PORTS.int.collapsed = not var_port or not var_port.type == E.CONNECTION_TYPES.INT
		PORTS.float.collapsed = not var_port or not var_port.type == E.CONNECTION_TYPES.FLOAT
		PORTS.bool.collapsed = not var_port or not var_port.type == E.CONNECTION_TYPES.BOOL
		PORTS.intb.collapsed = not var_port or not var_port.type == E.CONNECTION_TYPES.INT \
							   or not operator == NumberOp.BETWEEN
		PORTS.floatb.collapsed = not var_port or not var_port.type == E.CONNECTION_TYPES.FLOAT \
								 or not operator == NumberOp.BETWEEN
		update_slots()
	
	# Update operator options
	if _last_changed in ["var", "operator"] and PORTS.var.value:
		if var_port.type == E.CONNECTION_TYPES.TEXT:
			PORTS.operator.set_options_from_enum(TextOp, TextLabels)
			# Show options if possible
			if operator == TextOp.EQUALS and var_port.options:
				PORTS.text.options = var_port.options
			else:
				PORTS.text.options = []
			
		elif var_port.type in [E.CONNECTION_TYPES.INT, E.CONNECTION_TYPES.FLOAT]:
			PORTS.operator.set_options_from_enum(NumberOp, NumberLabels)
			# Show options if possible
			if operator == NumberOp.EQUALS and var_port.options:
				PORTS.int.options = var_port.options
				PORTS.float.options = var_port.options
			else:
				PORTS.float.options = []
			
		elif var_port.type == E.CONNECTION_TYPES.BOOL:
			PORTS.operator.set_options_from_enum(BoolOp, BoolLabels)
	
	if not var_port: return
	
	# Perform test
	var source = var_port.value
	var r: bool
	if var_port.type == E.CONNECTION_TYPES.TEXT:
		var text = PORTS.text.value
		# Ignore case?
		if PORTS.ignore_case.value:
			source = source.to_lower()
			if operator != TextOp.REGEX:
				text = text.to_lower()
		# Equals
		if operator == TextOp.EQUALS:
			r = source == text
		# Regex
		if operator == TextOp.REGEX:
			# Match line by adding ^ and $
			if text and text[0] != "^": text = "^" + text
			if text and text[-1] != "$": text = text + "$"
			if not text: text = "^$"
			if PORTS.ignore_case.value:
				text = "(?i)" + text
			var reg = RegEx.create_from_string(text)
			if not reg.is_valid():
				show_error("RegEx is not valid. See PCRE2 specs if needed.", 5)
				return
			hide_messages()
			var m = reg.search(source)
			r = m != null
		# Contains
		if operator == TextOp.CONTAINS:
			r = text in source
		# Is contained in
		if operator == TextOp.IS_CONTAINED:
			r = source in text
	
	# Numbers
	if var_port.type in [E.CONNECTION_TYPES.INT, E.CONNECTION_TYPES.FLOAT]:
		var number
		var number2
		if var_port.type == E.CONNECTION_TYPES.INT:
			number = PORTS.int.value
			number2 = PORTS.intb.value
		else:
			number = PORTS.float.value
			number2 = PORTS.floatb.value
		# Equals
		if operator == NumberOp.EQUALS:
			r = is_equal_approx(source, number)
		# Less than
		if operator == NumberOp.LESS:
			print(source, number, source < number)
			r = source < number
		# More than
		if operator == NumberOp.MORE:
			r = source > number
		# Between
		if operator == NumberOp.BETWEEN:
			r = (number < source and source < number2) or (number2 < source and source < number)
	
	# Bool
	# Only Equals 
	if var_port.type == E.CONNECTION_TYPES.BOOL:
		# AND
		if operator == BoolOp.AND:
			r = PORTS.bool.value and source
		# OR
		if operator == BoolOp.OR:
			r = PORTS.bool.value or source
		# XOR
		if operator == BoolOp.XOR:
			r = (PORTS.bool.value and not source) or (not PORTS.bool.value and source)
		# Equals
		if operator == BoolOp.EQUALS:
			r = PORTS.bool.value == source
	
	PORTS.result.value = r
	
	
