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


var test := HPortFlow.new(E.Side.INPUT)
var true_ := HPortFlow.new(E.Side.OUTPUT)
var false_ := HPortFlow.new(E.Side.OUTPUT)
var var_ := HPortDict.new(E.Side.INPUT, { "type": E.CONNECTION_TYPES.VARIANT, "multiple": false, "params": { "show_value": true } })
var operator := HPortIntSpin.new(E.Side.INPUT)
var ignore_case := HPortBool.new(E.Side.INPUT, { "default": true })
var text := HPortText.new(E.Side.INPUT)
var int_ := HPortIntSpin.new(E.Side.INPUT)
var intb := HPortIntSpin.new(E.Side.INPUT)
var float_ := HPortFloat.new(E.Side.INPUT)
var floatb := HPortFloat.new(E.Side.INPUT)
var bool_ := HPortBool.new(E.Side.INPUT)
var result := HPortBool.new(E.Side.OUTPUT)

func _init() -> void:
	title = _title
	type = _type
	

func run(_port : HBasePort) -> void:
	if _port == test:
		if result.value:
			true_.emit()
		else:
			false_.emit()

func update(_last_changed: HBasePort = null) -> void:
	# Get source port
	var var_port: HBasePort
	for c in var_.get_connections_to():
		var_port = c.from_port
	
	# Upate visibility
	if _last_changed in [null, operator, var_]:
		operator.collapsed = not var_port
		text.collapsed = not var_port or not var_port.type == E.CONNECTION_TYPES.TEXT
		ignore_case.collapsed = not var_port or not var_port.type == E.CONNECTION_TYPES.TEXT
		int_.collapsed = not var_port or not var_port.type == E.CONNECTION_TYPES.INT
		float_.collapsed = not var_port or not var_port.type == E.CONNECTION_TYPES.FLOAT
		bool_.collapsed = not var_port or not var_port.type == E.CONNECTION_TYPES.BOOL
		intb.collapsed = not var_port or not var_port.type == E.CONNECTION_TYPES.INT \
							   or not operator.value == NumberOp.BETWEEN
		floatb.collapsed = not var_port or not var_port.type == E.CONNECTION_TYPES.FLOAT \
								 or not operator.value == NumberOp.BETWEEN
		update_slots()
	
	# Update operator options
	if _last_changed in [var_, operator] and var_.value:
		if var_port.type == E.CONNECTION_TYPES.TEXT:
			operator.set_options_from_enum(TextOp, TextLabels)
			# Show options if possible
			if operator.value == TextOp.EQUALS and var_port.options:
				text.options = var_port.options
			else:
				text.options = []
			
		elif var_port.type in [E.CONNECTION_TYPES.INT, E.CONNECTION_TYPES.FLOAT]:
			operator.set_options_from_enum(NumberOp, NumberLabels)
			# Show options if possible
			if operator.value == NumberOp.EQUALS and var_port.options:
				int_.options = var_port.options
				float_.options = var_port.options
			else:
				float_.options = []
			
		elif var_port.type == E.CONNECTION_TYPES.BOOL:
			operator.set_options_from_enum(BoolOp, BoolLabels)
	
	if not var_port: return
	
	# Perform test
	var source = var_port.value
	var r: bool
	if var_port.type == E.CONNECTION_TYPES.TEXT:
		var _text = text.value
		# Ignore case?
		if ignore_case.value:
			source = source.to_lower()
			if operator.value != TextOp.REGEX:
				_text = _text.to_lower()
		# Equals
		if operator.value == TextOp.EQUALS:
			r = source == _text
		# Regex
		if operator.value == TextOp.REGEX:
			# Match line by adding ^ and $
			if _text and _text[0] != "^": _text = "^" + _text
			if _text and _text[-1] != "$": _text = _text + "$"
			if not _text: _text = "^$"
			if ignore_case.value:
				_text = "(?i)" + _text
			var reg = RegEx.create_from_string(_text)
			if not reg.is_valid():
				show_error("RegEx is not valid. See PCRE2 specs if needed.", 5)
				return
			hide_messages()
			var m = reg.search(source)
			r = m != null
		# Contains
		if operator.value == TextOp.CONTAINS:
			r = _text in source
		# Is contained in
		if operator.value == TextOp.IS_CONTAINED:
			r = source in _text
	
	# Numbers
	if var_port.type in [E.CONNECTION_TYPES.INT, E.CONNECTION_TYPES.FLOAT]:
		var number
		var number2
		if var_port.type == E.CONNECTION_TYPES.INT:
			number = int_.value
			number2 = intb.value
		else:
			number = float_.value
			number2 = floatb.value
		# Equals
		if operator.value == NumberOp.EQUALS:
			r = is_equal_approx(source, number)
		# Less than
		if operator.value == NumberOp.LESS:
			r = source < number
		# More than
		if operator.value == NumberOp.MORE:
			r = source > number
		# Between
		if operator.value == NumberOp.BETWEEN:
			r = (number < source and source < number2) or (number2 < source and source < number)
	
	# Bool
	# Only Equals 
	if var_port.type == E.CONNECTION_TYPES.BOOL:
		# AND
		if operator.value == BoolOp.AND:
			r = bool_.value and source
		# OR
		if operator.value == BoolOp.OR:
			r = bool_.value or source
		# XOR
		if operator.value == BoolOp.XOR:
			r = (bool_.value and not source) or (not bool_.value and source)
		# Equals
		if operator.value == BoolOp.EQUALS:
			r = bool_.value == source
	
	result.value = r
	
	
