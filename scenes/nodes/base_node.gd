extends GraphNode
class_name HBaseNode

## Base class for Hirondelle Nodes.
## HBaseNodes have:
## * type
## * ...
## * func update: called when on of the input vars change
## * fun run: called with "flow" node, for main actions

enum { INPUT, OUTPUT, BOTH, NONE }

#var _title = ""
#var _type = ""
var category = ""
var icon = ""
var description = ""

## Unique identifier for node type
var type = ""

## Unique identifier for node. Unique in the whole graph.
#var id : String
# Use name instead

#var COMPONENTS := {}
var VALS := {}

var warning : Label
var error : Label

const BASE_PORT = preload("res://scenes/nodes/ports/base_port.tscn")

signal port_clicked(name:String)

signal collapsed_changed(bool)
var btn_collapse : CheckButton

func _update_separation():
	var h = 0 if btn_collapse.button_pressed else 6
	add_theme_constant_override("separation", h)

func _ready() -> void:
	
	var hbox = get_titlebar_hbox()
	btn_collapse = CheckButton.new()
	btn_collapse.flat = true
	btn_collapse.toggled.connect(_update_separation.unbind(1))
	btn_collapse.toggled.connect(collapsed_changed.emit, CONNECT_DEFERRED)
	if "_icon" in self:
		var texture = TextureRect.new()
		texture.texture = G.get_main_icon(self["_icon"], 24)
		texture.stretch_mode = TextureRect.STRETCH_KEEP_CENTERED
		texture.modulate = G.get_node_color(self)
		hbox.add_child(texture)
		hbox.move_child(texture, 0)
	hbox.add_child(btn_collapse)
	
	add_theme_constant_override("separation", 6)
	resizable = true
	
	setup()


# FIXME: _draw_port seems buggy ..?
#func _draw_port(slot_index: int, position: Vector2i, left: bool, color: Color) -> void:
	#var port = get_children().filter(func (c): return c is HBasePort)[slot_index]
	#if port:
		#print(" * ", left, ": ", slot_index, " ", G.graph.TYPES.keys()[port.type], " at ", position)
		#if port.type == G.graph.TYPES.FLOW:
			#draw_circle(position, 7, color)
		#else:
			#draw_circle(position, 5, color)

## Generate internal nodes and stuff based on COMPONENTS instructions.
func setup():
	clear_all_slots()
	
	for _name in VALS:
		var p = VALS[_name]
		p.name = _name
		add_child(p)
		collapsed_changed.connect(p.set_collapsed)
		
		if p.side in [E.Side.INPUT, E.Side.BOTH, E.Side.NONE]:
			p.value_changed.connect(_update.bind(_name)) # CONNECT_DEFERRED
		if p.side in [E.Side.OUTPUT, E.Side.BOTH]:
			p.value_changed.connect(propagate_value.bind(_name)) # CONNECT_DEFERRED
	
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
	if val.type == G.graph.TYPES.FLOW and val.side == E.Side.INPUT:
		run(port_name)
	if val.type == G.graph.TYPES.FLOW and val.side == E.Side.OUTPUT:
		emit(port_name)

func get_port_icon(n := 0, width := 10) -> Texture2D:
	return G.get_icon_from_atlas(preload("res://themes/ports.svg"), n, 0, 32, width)

func _reverse_icon(icon : Texture2D) -> Texture2D:
	var img = icon.get_image()
	img.flip_x()
	var icon2 = ImageTexture.create_from_image(img)
	icon2.set_size_override(icon.get_size())
	return icon2

## Turn on and off slots and give them the proper color
func update_slots() -> void:
	clear_all_slots()
	
	var slot_index := 0
	for _name in VALS:
		var c = VALS[_name]
		#VALS[_name].visible = c.visible
		if c.visible:
			set_slot_enabled_left(slot_index, c.side in [E.Side.INPUT, E.Side.BOTH])
			set_slot_enabled_right(slot_index, c.side in [E.Side.OUTPUT, E.Side.BOTH])
			set_slot_type_left(slot_index, c.type)
			set_slot_type_right(slot_index, c.type)
			set_slot_color_left(slot_index, G.graph.colors[c.type])
			set_slot_color_right(slot_index, G.graph.colors[c.type])
			var icon
			if c.type == G.graph.TYPES.FLOW:
				icon = get_port_icon(3, 15)
			elif c.is_dictionary:
				icon = get_port_icon(2, 10)
			else:
				icon = get_port_icon(0, 10)
			#var icon_width = 14 if c.type == G.graph.TYPES.FLOW else 10
			#var icon_idx = 2 if c.is_dictionary else 0
			#var icon = get_port_icon(icon_idx, icon_width)
			set_slot_custom_icon_right(slot_index, icon)
			set_slot_custom_icon_left(slot_index, icon)
				
			slot_index += 1
	reset_size()

var _last_port_changed := ""
func _update(_last_changed := "") -> void:
	#await get_tree().process_frame
	#print(Time.get_ticks_msec(), " _UPDATE")
	
	# Process node values
	_last_port_changed = _last_changed
	update()
	
	# If necessary
	#update_slots()

func propagate_value(_name : String) -> void:
	#if not is_node_ready(): await ready
	
	var port = get_port_number(_name)
	for c in G.graph.get_connections_from_node_and_port(name, port):
		var _c = G.graph.full_connection(c)
		_c.to_port.update_from_connections()
		#if _c.to_port.is_dictionary:
			## Updating dictionary
			#_c.to_port.value[_name] = _c.from_port.value
		#else:
			## Updating normal value
			#_c.to_port.value = _c.from_port.value

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
		if c.visible and c.side in [E.Side.OUTPUT, E.Side.BOTH]:
			if k == idx:
				return c
			k += 1
	return null

func get_input_port(idx : int) -> Node:
	var k := 0
	for c in VALS.values():
		if c.visible and c.side in [E.Side.INPUT, E.Side.BOTH]:
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
		if not v.visible: continue
		if _name == port_name:
			return _input if v.side == E.Side.INPUT else _output
		if v.side in [E.Side.INPUT, E.Side.BOTH]: _input += 1
		if v.side in [E.Side.OUTPUT, E.Side.BOTH]: _output += 1
	return -1

## Return the name of the given port.
## FIXME: might not work on "BOTH" side.
func get_port_name(side, index : int) -> String:
	var _input = 0
	var _output = 0
	for _name in VALS:
		var v = VALS[_name]
		if not v.visible: continue
		if v.side in [E.Side.INPUT, E.Side.BOTH] and side == E.Side.INPUT and index == _input: return _name
		if v.side in [E.Side.OUTPUT, E.Side.BOTH] and side == E.Side.OUTPUT and index == _output: return _name
		if v.side in [E.Side.INPUT, E.Side.BOTH]: _input += 1
		if v.side in [E.Side.OUTPUT, E.Side.BOTH]: _output += 1
	return ""

# Helper functions
func get_port_position(side, index : int):
	if side == E.Side.INPUT: return get_input_port_position(index)
	if side == E.Side.OUTPUT: return get_output_port_position(index)
func get_port_type(side, index : int):
	if side == E.Side.INPUT: return get_input_port_type(index)
	if side == E.Side.OUTPUT: return get_output_port_type(index)

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
		if VALS[v].type == HGraphEdit.TYPES.VEC2:
			s.vals[v] = { "x": VALS[v].value.x, "y": VALS[v].value.y }
		elif VALS[v].type == HGraphEdit.TYPES.COLOR:
			s.vals[v] = VALS[v].value.to_html()
		else:
			s.vals[v] = VALS[v].value
	
	return s

	
