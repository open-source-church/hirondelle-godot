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

var graph : HGraphEdit

## Unique identifier for node type
var type = ""

## Unique identifier for node. Unique in the whole graph.
#var id : String
# Use name instead

#var COMPONENTS := {}
var PORTS := {}

var warning : Label
var error : Label
var success : Label

signal port_clicked(name:String)

signal collapsed_changed(bool)
var btn_collapse : CheckButton

var collapsed := false
func set_collapsed(val: bool):
	collapsed = val
	# Update separtion
	#var h = 0 if collapsed else 6
	#add_theme_constant_override("separation", h)

func _ready() -> void:
	graph = get_parent()
	# Title box
	var hbox = get_titlebar_hbox()
	btn_collapse = CheckButton.new()
	btn_collapse.flat = true
	btn_collapse.toggled.connect(set_collapsed)
	btn_collapse.toggled.connect(collapsed_changed.emit, CONNECT_DEFERRED)
	
	if "_icon" in self:
		var texture = TextureRect.new()
		texture.texture = G.get_main_icon(self["_icon"], 24)
		texture.stretch_mode = TextureRect.STRETCH_KEEP_CENTERED
		texture.modulate = G.get_node_color(self)
		hbox.add_child(texture)
		hbox.move_child(texture, 0)
	
	hbox.add_child(btn_collapse)
	
	add_theme_constant_override("separation", 0)
	resizable = true
	
	setup()


# FIXME: _draw_port seems buggy ..?
#func _draw_port(slot_index: int, position: Vector2i, left: bool, color: Color) -> void:
	#var port = get_children().filter(func (c): return c is HBasePort)[slot_index]
	#if port:
		#print(" * ", left, ": ", slot_index, " ", E.CONNECTION_TYPES.keys()[port.type], " at ", position)
		#if port.type == E.CONNECTION_TYPES.FLOW:
			#draw_circle(position, 7, color)
		#else:
			#draw_circle(position, 5, color)

## Generate internal nodes and stuff based on COMPONENTS instructions.
func setup():
	print("Setting up: ", name)
	clear_all_slots()
	
	for _name in PORTS:
		var p = PORTS[_name]
		p.name = _name
		add_child(p)
		collapsed_changed.connect(p.set_node_collapsed)
		
		if p.side in [E.Side.INPUT, E.Side.BOTH, E.Side.NONE]:
			p.value_changed.connect(_update.bind(_name)) # CONNECT_DEFERRED
		if p.side in [E.Side.OUTPUT, E.Side.BOTH]:
			p.value_changed.connect(propagate_value.bind(_name)) # CONNECT_DEFERRED
	
	success = Label.new()
	success.add_theme_color_override("font_color", Color.GREEN)
	success.add_theme_font_size_override("font_size", 12)
	add_child(success)
	success.visible = false
		
	warning = Label.new()
	warning.add_theme_color_override("font_color", Color.ORANGE)
	warning.add_theme_font_size_override("font_size", 12)
	add_child(warning)
	warning.visible = false
	
	error = Label.new()
	error.add_theme_color_override("font_color", Color.RED)
	error.add_theme_font_size_override("font_size", 12)
	add_child(error)
	error.visible = false
	
	port_clicked.connect(on_port_clicked)
	
	update()
	update_slots()

func on_port_clicked(port_name : String) -> void:
	var val = PORTS[port_name]
	if val.type == E.CONNECTION_TYPES.FLOW and val.side == E.Side.INPUT:
		run(port_name)
	if val.type == E.CONNECTION_TYPES.FLOW and val.side == E.Side.OUTPUT:
		emit(port_name)

func get_port_icon(n := 0, width := 10) -> Texture2D:
	return G.get_icon_from_atlas(G.PORTS_TEXTURE, n, 0, 32, width)

## Turn on and off slots and give them the proper color
func update_slots() -> void:
	clear_all_slots()
	
	var slot_index := 0
	for c in get_children():
		if c is HBasePort and not c.collapsed:
			set_slot_enabled_left(slot_index, c.side in [E.Side.INPUT, E.Side.BOTH])
			set_slot_enabled_right(slot_index, c.side in [E.Side.OUTPUT, E.Side.BOTH])
			set_slot_type_left(slot_index, c.type)
			set_slot_type_right(slot_index, c.type)
			set_slot_color_left(slot_index, E.connection_colors[c.type])
			set_slot_color_right(slot_index, E.connection_colors[c.type])
			
			var _icon
			if c.type == E.CONNECTION_TYPES.FLOW:
				_icon = get_port_icon(3, 15)
			elif c.is_dictionary:
				_icon = get_port_icon(2, 12)
			else:
				icon = get_port_icon(0, 10)
			set_slot_custom_icon_right(slot_index, _icon)
			set_slot_custom_icon_left(slot_index, _icon)
		
		# Godot counts every Control children
		if c is Control:
			slot_index += 1
	
	# If we want to hide connections when port is hidden:
	#graph.connections.update_node_slots_visibility(self)
	# If we want to remove connections when port is hidden:
	graph.connections.remove_connections_to_hidden_slots(self)
	
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
	for c in graph.connections.list_from_node_and_port(self, PORTS[_name]):
		if c.from_port.type == E.CONNECTION_TYPES.FLOW: continue
		# Update value
		c.to_port.update_from_connections()
		# Visual feedbacks
		c.to_port.animate_update()
		c.animate()

## Virtual. Called when input value changed.
func update() -> void:
	pass

## Virtual. Called when a subroutine (input FLOW port) is activated.
func run(_routine : String) -> void:
	pass

func animate_run() -> void:
	var tween = create_tween()
	tween.tween_property(self, "self_modulate", Color.WHITE, 0.3).from(Color(0.2, 1.0, 0.2))

func emit(routine : String) -> void:
	for c in graph.connections.list_from_node_and_port(self, PORTS[routine]):
		c.to_node.run.call_deferred(c.to_port.name)
		c.animate()
		c.to_node.animate_run()

## Adapts get_output_port_slot to take into account invisible slots
func get_output_port(idx : int) -> Node:
	var k := 0
	for c in PORTS.values():
		if not c.collapsed and c.side in [E.Side.OUTPUT, E.Side.BOTH]:
			if k == idx:
				return c
			k += 1
	return null

func get_input_port(idx : int) -> Node:
	var k := 0
	for c in PORTS.values():
		if not c.collapsed and c.side in [E.Side.INPUT, E.Side.BOTH]:
			if k == idx: return c
			k += 1
	return null

## Return the port number with given name. Useful to create connections.
func get_port_number(port_name : String, side := E.Side.INPUT) -> int:
	var _input = 0
	var _output = 0
	for _name in PORTS:
		var v = PORTS[_name]
		if v.collapsed: continue
		if v.name == port_name:
			return _input if side == E.Side.INPUT else _output
		if v.side in [E.Side.INPUT, E.Side.BOTH]: _input += 1
		if v.side in [E.Side.OUTPUT, E.Side.BOTH]: _output += 1
	
	return -1

## Return the name of the given port.
## FIXME: might not work on "BOTH" side.
func get_port_name(side, index : int) -> String:
	var _input = 0
	var _output = 0
	for _name in PORTS:
		var v = PORTS[_name]
		if v.collapsed: continue
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

#func _process(_delta: float) -> void:
	#error.visible = error.text != ""
	#warning.visible = warning.text != ""

func show_success(msg: String, duration := 0) -> void:
	show_message(success, msg, duration)

func show_warning(msg: String, duration := 0) -> void:
	show_message(warning, msg, duration)

func show_error(msg: String, duration := 0) -> void:
	show_message(error, msg, duration)

func show_message(label:Label, msg: String, duration := 0.0) -> void:
	# Nothing to do
	if not label.text and not msg: return
	# Actions
	var _hide := label.text and not msg
	var _temporary := msg and duration
	const HIDE_DURATION = 0.3
	# Operations
	var tween = create_tween()
	tween.set_parallel(false)
	tween.tween_property(label, "visible", true, 0)
	tween.tween_property(label, "modulate", Color.WHITE, 0)
	if not _hide: # We directly change the message
		tween.tween_property(label, "text", msg, 0)
	if _hide or _temporary:
		tween.tween_interval(duration)
		tween.tween_property(label, "modulate", Color.TRANSPARENT, HIDE_DURATION).from(Color.WHITE).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_IN)
		#tween.set_parallel(true).tween_property(label, "position", label.position + Vector2(0, -30), HIDE_DURATION).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_IN)
		
		tween.set_parallel(false).tween_property(label, "visible", false, 0)
		tween.tween_method(reset_size.unbind(1), 0, 0, 0)
		tween.tween_property(label, "text", "", 0)

func save() -> Dictionary:
	var s = {
		"type": type,
		"vals": {},
		"pos": { "x": position_offset.x, "y": position_offset.y },
		"name": name
	}
	for v in PORTS:
		if PORTS[v].type == E.CONNECTION_TYPES.VEC2:
			s.vals[v] = { "x": PORTS[v].value.x, "y": PORTS[v].value.y }
		elif PORTS[v].type == E.CONNECTION_TYPES.COLOR:
			s.vals[v] = PORTS[v].value.to_html()
		else:
			s.vals[v] = PORTS[v].value
	
	return s

func load(data : Dictionary) -> void:
	position_offset = Vector2(data.pos.x, data.pos.y)
	for _name in data.vals:
		if not _name in PORTS: 
			print("Found value of '%s' in the save file while loading node '%s', but it's not in the node definition. This should not happen." % [name, type])
			continue
		if PORTS[_name].type == E.CONNECTION_TYPES.VEC2:
			PORTS[_name].value = Vector2(data.vals[_name].x, data.vals[_name].y)
		elif PORTS[_name].type == E.CONNECTION_TYPES.COLOR:
			PORTS[_name].value = Color(data.vals[_name])
		elif PORTS[_name].type == E.CONNECTION_TYPES.IMAGE:
			PORTS[_name].value = null
		else:
			PORTS[_name].value = data.vals[_name]
		# Update the node with each value set to be sure it's properly displayed
		_last_port_changed = _name
		update()
