@tool
extends HBoxContainer

# Margins
@onready var left_margin: Control = $LeftMargin
@onready var right_margin: Control = $RightMargin
# Components
@onready var spin_box_int: SpinBox = $SpinBoxInt
@onready var spin_box_float: SpinBox = $SpinBoxFloat
@onready var line_edit: LineEdit = $LineEdit
@onready var color_picker_button: ColorPickerButton = $ColorPickerButton
@onready var option_button: OptionButton = $OptionButton
@onready var check_button: CheckButton = $CheckButton
@onready var label: Label = $Label
@onready var label_flow: Label = $LabelFlow
@onready var label_flow_2: Label = $LabelFlow2
@onready var vec_2: HBoxContainer = $Vec2

enum SIDE { INPUT, OUTPUT, BOTH, NONE }
@export var side : SIDE:
	set(val):
		side = val
		if not is_node_ready(): await ready
		left_margin.visible = val in [SIDE.OUTPUT, SIDE.BOTH]
		right_margin.visible = val in [SIDE.INPUT, SIDE.BOTH]
		
@export var type : HGraphEdit.TYPES:
	set(val):
		type = val
		if not is_node_ready(): await ready
		update_view()

var description : String:
	set(val):
		description = val
		spin_box_int.tooltip_text = description
		spin_box_float.tooltip_text = description
		line_edit.tooltip_text = description
		color_picker_button.tooltip_text = description
		option_button.tooltip_text = description
		check_button.tooltip_text = description
		label.tooltip_text = description
		label_flow.tooltip_text = description

signal value_changed

func _ready() -> void:
	#spin_box_int.value_changed.connect(value_changed.emit.unbind(1))
	#spin_box_float.value_changed.connect(value_changed.emit.unbind(1))
	#line_edit.text_changed.connect(value_changed.emit.unbind(1))
	#color_picker_button.color_changed.connect(value_changed.emit.unbind(1))
	#option_button.item_selected.connect(value_changed.emit.unbind(1))
	#check_button.toggled.connect(value_changed.emit.unbind(1))
	
	spin_box_float.value_changed.connect(func(_value:float):
		spin_box_float.get_line_edit().text = '%.2f' % _value
	, CONNECT_DEFERRED)
	
	label.text = "%s:" % name
	label_flow.text = "%s" % name

var _last_value
func _process(_delta: float) -> void:
	if value != _last_value:
		value_changed.emit()
		_last_value = value

func update_view():
	
	option_button.visible = options.size()
	spin_box_int.visible = not options.size() and type == HGraphEdit.TYPES.INT
	spin_box_float.visible = type == HGraphEdit.TYPES.FLOAT
	line_edit.visible = not options.size() and type == HGraphEdit.TYPES.TEXT
	color_picker_button.visible = type == HGraphEdit.TYPES.COLOR
	check_button.visible = type == HGraphEdit.TYPES.BOOL
	label.visible = type != HGraphEdit.TYPES.FLOW
	label_flow.visible = type == HGraphEdit.TYPES.FLOW
	label_flow_2.visible = type == HGraphEdit.TYPES.FLOW
	vec_2.visible = type == HGraphEdit.TYPES.VEC2


var value: get=_get_value, set=_set_value

func _get_value() -> Variant:
	if options:
		return options[option_button.selected].value
	if type == HGraphEdit.TYPES.INT:
		return int(spin_box_int.value)
	if type == HGraphEdit.TYPES.FLOAT:
		return spin_box_float.value
	if type == HGraphEdit.TYPES.TEXT:
		return line_edit.text
	if type == HGraphEdit.TYPES.COLOR:
		return color_picker_button.color
	if type == HGraphEdit.TYPES.TEXT_LIST:
		#return option_button.get_item_text(option_button.selected)
		return options[option_button.selected].value
	if type == HGraphEdit.TYPES.BOOL:
		return check_button.button_pressed
	if type == HGraphEdit.TYPES.VEC2:
		return vec_2.value
	return null

func _set_value(val):
	var changed = val != value
	if not changed: return
	if options:
		set_option(val)
		return
	
	if type == HGraphEdit.TYPES.INT:
		spin_box_int.value = val
	if type == HGraphEdit.TYPES.FLOAT:
		spin_box_float.value = val
	if type == HGraphEdit.TYPES.TEXT:
		line_edit.text = val
	if type == HGraphEdit.TYPES.COLOR:
		color_picker_button.color = val
	if type == HGraphEdit.TYPES.TEXT_LIST:
		set_option(val)
	if type == HGraphEdit.TYPES.BOOL:
		check_button.button_pressed = val
	if type == HGraphEdit.TYPES.VEC2:
		vec_2.value = val
	#value_changed.emit()

func set_option(val):
	for i in options.size():
		if options[i].value == val: 
			option_button.select(i)
			return
	#for i in option_button.item_count:
		#if option_button.get_item_text(i) == val:
			#option_button.select(i)
			#return

var options:Array : set=_set_options

## _options is either an Array of value, or an Array of Dictionary { "label": lbl, "value": val }
func _set_options(_options):
	if _options and _options[0] is Dictionary:
		pass
	elif _options and _options[0]:
		_options = _options.map(func (o): return { "label": o, "value": o })
	else:
		_options = []
	if _options == options:
		return
	options = _options
	option_button.clear()
	for o in options:
		option_button.add_item(str(o.label))
	update_view()
