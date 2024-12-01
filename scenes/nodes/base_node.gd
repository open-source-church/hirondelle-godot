extends GraphNode
class_name HBaseNode

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

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	setup()


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
	
	warning = Label.new()
	warning.add_theme_color_override("font_color", Color.ORANGE)
	add_child(warning)
	warning.visible = false
	
	error = Label.new()
	error.add_theme_color_override("font_color", Color.RED)
	add_child(error)
	error.visible = false
	
	update()
	update_slots()

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
	# Process node values
	update()
	
	# If necessary
	#update_slots()
	
	# Refresh connections
	update_connections()

func update_connections() -> void:
	for c in G.graph.get_full_connections_from_node(name):
		c.to_port.value = c.from_port.value

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

func get_port_number(name : String) -> int:
	var _input = 0
	var _output = 0
	for _name in VALS:
		var v = VALS[_name]
		if _name == name:
			return _input if v.side == INPUT else _output
		if v.side in [INPUT, BOTH]: _input += 1
		if v.side in [OUTPUT, BOTH]: _output += 1
	return -1

func update() -> void:
	pass

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
