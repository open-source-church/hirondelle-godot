extends GraphNode
class_name HBaseNode

## Base class for Hirondelle Nodes.
## HBaseNodes have:
## * type
## * ...
## * func update: called when on of the input vars change
## * fun run: called with "flow" node, for main actions

enum { INPUT, OUTPUT, BOTH, NONE }

class Port:
	var side := INPUT
	var type : HGraphEdit.TYPES
	var visible := true
	var options : Array
	var default
	var description
	func _init(opt : Dictionary) -> void:
		side = opt.get("side", INPUT)
		type = opt.type
		visible = opt.get("visible", true)
		options = opt.get("options", [])
		default = opt.get("default", null)
		description = opt.get("description", "")

## Unique identifier for node type
var type = ""

## Unique identifier for node. Unique in the whole graph.
#var id : String
# Use name instead

var description := ""

var COMPONENTS := {}
var VALS := {}

var warning : Label
var error : Label

const BASE_PORT = preload("res://scenes/nodes/ports/base_port.tscn")

signal port_clicked(name:String)

func _ready() -> void:
	setup()

## Generate internal nodes and stuff based on COMPONENTS instructions.
func setup():
	clear_all_slots()
	
	for _name in COMPONENTS:
		var c = COMPONENTS[_name]
		
		var slot := BASE_PORT.instantiate()
		slot.side = c.side
		slot.type = c.type
		slot.name = _name
		add_child(slot)
		slot.options = c.options
		slot.visible = c.visible
		slot.description = c.description
		if c.default:
			slot.value = c.default
		VALS[_name] = slot
		if c.side in [INPUT, BOTH, NONE]:
			slot.value_changed.connect(_update, CONNECT_DEFERRED)
		if c.side in [OUTPUT, BOTH]:
			slot.value_changed.connect(propagate_value.bind(_name), CONNECT_DEFERRED)
	
	warning = Label.new()
	warning.add_theme_color_override("font_color", Color.ORANGE)
	add_child(warning)
	warning.visible = false
	
	error = Label.new()
	error.add_theme_color_override("font_color", Color.RED)
	add_child(error)
	error.visible = false
	
	port_clicked.connect(on_port_clicked)
	
	update()
	update_slots()

func on_port_clicked(port_name : String) -> void:
	var val = VALS[port_name]
	if val.type == G.graph.TYPES.FLOW and val.side == INPUT:
		run(port_name)
	if val.type == G.graph.TYPES.FLOW and val.side == OUTPUT:
		emit(port_name)

## Turn on and off slots and give them the proper color
func update_slots() -> void:
	clear_all_slots()
	var slot_index := 0
	for _name in COMPONENTS:
		var c = COMPONENTS[_name]
		VALS[_name].visible = c.visible
		if c is Port and c.visible:
			set_slot_enabled_left(slot_index, c.side in [INPUT, BOTH])
			set_slot_enabled_right(slot_index, c.side in [OUTPUT, BOTH])
			set_slot_type_left(slot_index, c.type)
			set_slot_type_right(slot_index, c.type)
			set_slot_color_left(slot_index, G.graph.colors[c.type])
			set_slot_color_right(slot_index, G.graph.colors[c.type])
			slot_index += 1

func _update() -> void:
	#await get_tree().process_frame
	#print(Time.get_ticks_msec(), " _UPDATE")
	
	# Process node values
	update()
	
	# If necessary
	#update_slots()

func propagate_value(_name : String) -> void:
	print("Propagating value: ", _name)
	var port = get_port_number(_name)
	for c in G.graph.get_connections_from_node_and_port(name, port):
		var _c = G.graph.full_connection(c)
		_c.to_port.value = _c.from_port.value

## Virtual. Called when input value changed.
func update() -> void:
	pass

## Virtual. Called when a subroutine (input FLOW port) is activated.
func run(_routine : String) -> void:
	pass

func emit(routine : String) -> void:
	var connections = G.graph.get_connections_from_node_and_port(name, get_port_number(routine))
	for c in connections:
		var _c = G.graph.full_connection(c)
		_c.to_node.run.call_deferred(_c.to_port.name)

## Adapts get_output_port_slot to take into account invisible slots
func get_output_port(idx : int) -> Node:
	var k := 0
	for c in VALS.values():
		if c.visible and c.side in [OUTPUT, BOTH]:
			if k == idx: return c
			k += 1
	return null

func get_input_port(idx : int) -> Node:
	var k := 0
	for c in VALS.values():
		if c.visible and c.side in [INPUT, BOTH]:
			if k == idx: return c
			k += 1
	return null

## Return the port number with given name. Useful to create connections.
## FIXME: might not work on "BOTH" side.
func get_port_number(port_name : String) -> int:
	var _input = 0
	var _output = 0
	for _name in VALS:
		var v = VALS[_name]
		if _name == port_name:
			return _input if v.side == INPUT else _output
		if v.side in [INPUT, BOTH]: _input += 1
		if v.side in [OUTPUT, BOTH]: _output += 1
	return -1

## Return the name of the given port.
## FIXME: might not work on "BOTH" side.
func get_port_name(side, index : int) -> String:
	var _input = 0
	var _output = 0
	for _name in VALS:
		var v = VALS[_name]
		if v.side in [INPUT, BOTH] and side == INPUT and index == _input: return _name
		if v.side in [OUTPUT, BOTH] and side == OUTPUT and index == _output: return _name
		if v.side in [INPUT, BOTH]: _input += 1
		if v.side in [OUTPUT, BOTH]: _output += 1
	return ""

# Helper functions
func get_port_position(side, index : int):
	if side == INPUT: return get_input_port_position(index)
	if side == OUTPUT: return get_output_port_position(index)
func get_port_type(side, index : int):
	if side == INPUT: return get_input_port_type(index)
	if side == OUTPUT: return get_output_port_type(index)

func _process(_delta: float) -> void:
	error.visible = error.text != ""
	warning.visible = warning.text != ""

func save() -> Dictionary:
	var s = {
		"type": type,
		"vals": {},
		"pos": { "x": position_offset.x, "y": position_offset.y },
		"name": name
	}
	for v in VALS:
		s.vals[v] = VALS[v].value
	
	return s

	
