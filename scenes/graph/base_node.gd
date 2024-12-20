extends GraphNode
class_name HBaseNode

## Base class for Hirondelle Nodes.
## HBaseNodes have:
## * type
## * ...
## * func update: called when on of the input vars change
## * fun run: called with "flow" node, for main actions

## Reference to [HGraphEdit]
var graph : HGraphEdit

# Metadata

## Unique identifier for node type
var type = ""
## Category
var category = ""
## Icon
var icon = ""
## Description
var description = ""

# Where we keep track of port's compontent
var ports: HPortsManager
## Get port by name
func port(_name: String) -> HBasePort:
	return ports.get_by_name(_name)

# Child components

# Labels for warnings
var warning : Label
var error : Label
var success : Label
# Collapse button in title bar
var btn_collapse : CheckButton

# Signals

## Emitted on port clicked
signal port_clicked(port: HBasePort)
## Emitted when the node collapse status has changed
signal collapsed_changed(bool)

# Whether the node is collapsed
var collapsed := false
func set_collapsed(val: bool):
	collapsed = val

# Sources

var sources: Array[HBaseSource] = []
var inactive_icon: TextureRect
signal sources_got_active
signal sources_got_inactve
var sources_active: = false

func update_active_status():
	var active: bool = sources.all(func (s: HBaseSource): return s.active)
	inactive_icon.visible = not active
	sources_active = active
	if active: 
		sources_got_active.emit()
	else:
		sources_got_inactve.emit()
		inactive_icon.tooltip_text = "Node cannot function properly because of inactive sources: %s" % ", ".join(sources.filter(func (s): return not s.active).map(func (s): return s.name))

func add_source_by_name(_name: String):
	var source = NodeManager.get_source_by_name(_name)
	if not source in sources: sources.append(source)

func _ready() -> void:
	graph = get_parent()
	
	ports = HPortsManager.new(self)
	add_child(ports, false, Node.INTERNAL_MODE_FRONT)
	
	# Title box
	var hbox = get_titlebar_hbox()
	btn_collapse = CheckButton.new()
	btn_collapse.flat = true
	btn_collapse.toggled.connect(set_collapsed)
	btn_collapse.toggled.connect(collapsed_changed.emit, CONNECT_DEFERRED)
	
	# Icon
	if "_icon" in self:
		var texture = TextureRect.new()
		texture.texture = G.get_main_icon(self["_icon"], 24)
		texture.stretch_mode = TextureRect.STRETCH_KEEP_CENTERED
		texture.modulate = NodeManager.get_node_color(self)
		hbox.add_child(texture)
		hbox.move_child(texture, 0)
	
	# Inactive source
	inactive_icon = TextureRect.new()
	inactive_icon.texture = G.get_main_icon("warning", 24)
	inactive_icon.stretch_mode = TextureRect.STRETCH_KEEP_CENTERED
	inactive_icon.modulate = Color.RED
	hbox.add_child(inactive_icon)
	hbox.move_child(inactive_icon, 0)
	
	hbox.add_child(btn_collapse)
	
	add_theme_constant_override("separation", 0)
	resizable = true
	
	setup()

## Generate internal nodes and stuff
func setup():
	print("Setting up: ", name)
	clear_all_slots()
	
	# Labels
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
	
	# Adds sources from static var
	if "_sources" in self:
		for s_name in self["_sources"]:
			add_source_by_name(s_name)
	
	# Connects sources
	for s in sources:
		s.becomes_active.connect(update_active_status)
		s.becomes_inactive.connect(update_active_status)
	update_active_status()
	
	# Initial update
	update()
	update_slots()

func on_port_clicked(_port : HBasePort) -> void:
	# Clicking on a Flow Port: on input, run node. On output: emit signal to run other nodes.
	if _port.type == E.CONNECTION_TYPES.FLOW and _port.side == E.Side.INPUT:
		run(_port)
		_port.animate_update()
	if _port.type == E.CONNECTION_TYPES.FLOW and _port.side == E.Side.OUTPUT:
		_port.emit()

## Turn on and off slots and give them the proper color
func update_slots() -> void:
	clear_all_slots()
	
	var slot_index := 0
	for c in get_children():
		if c is HBasePort and c.collapsed:
			set_slot_enabled_left(slot_index, false)
			set_slot_enabled_right(slot_index, false)
		elif c is HBasePort and not c.collapsed:
			set_slot_enabled_left(slot_index, c.side in [E.Side.INPUT, E.Side.BOTH])
			set_slot_enabled_right(slot_index, c.side in [E.Side.OUTPUT, E.Side.BOTH])
			set_slot_type_left(slot_index, c.type)
			set_slot_type_right(slot_index, c.type)
			set_slot_color_left(slot_index, E.connection_colors[c.type])
			set_slot_color_right(slot_index, E.connection_colors[c.type])
			
			var _icon
			if c.type == E.CONNECTION_TYPES.FLOW:
				_icon = G.get_icon_from_atlas(G.PORTS_TEXTURE, 3, 0, 32, 15)
			elif c.is_multiple:
				_icon = G.get_icon_from_atlas(G.PORTS_TEXTURE, 2, 0, 32, 12)
			else:
				_icon = G.get_icon_from_atlas(G.PORTS_TEXTURE, 0, 0, 32, 10)
			set_slot_custom_icon_right(slot_index, _icon)
			set_slot_custom_icon_left(slot_index, _icon)
		
		# Godot counts every Control children
		if c is Control:
			slot_index += 1
	
	# How to handle connections to hidden/collapsed slots ?
	
	# If we want to hide connections when port is hidden:
	#graph.connections.update_node_slots_visibility(self)
	
	# If we want to remove connections when port is hidden:
	graph.connections.remove_connections_to_hidden_slots(self)
	
	reset_size()

## Virtual. Called when input value changed.
func update(_last_changed: HBasePort = null) -> void:
	pass

## Virtual. Called when a subroutine (input FLOW port) is activated.
func run(_port : HBasePort) -> void:
	pass

## Visual feedback when the node is being run
func animate_run() -> void:
	var tween = create_tween()
	tween.tween_property(self, "self_modulate", Color.WHITE, 0.3).from(Color(0.2, 1.0, 0.2))

func get_port(idx: int, side := E.Side.INPUT) -> HBasePort:
	if side == E.Side.INPUT:
		return get_input_port(idx)
	else:
		return get_output_port(idx)

## Adapts get_output_port_slot to take into account invisible/collapsed slots
func get_output_port(idx : int) -> HBasePort:
	var k := 0
	for c in ports.list():
		if not c.collapsed and c.side in [E.Side.OUTPUT, E.Side.BOTH]:
			if k == idx:
				return c
			k += 1
	return null

## Adapts get_input_port_slot to take into account invisible/collapsed slots
func get_input_port(idx : int) -> HBasePort:
	var k := 0
	for c in ports.list():
		if not c.collapsed and c.side in [E.Side.INPUT, E.Side.BOTH]:
			if k == idx: return c
			k += 1
	return null

## Return the port number with given name. Useful to create connections.
func get_port_number(port_name : String, side := E.Side.INPUT) -> int:
	var _input = 0
	var _output = 0
	for p in ports.list():
		if p.collapsed: continue
		if p.name == port_name:
			return _input if side == E.Side.INPUT else _output
		if p.side in [E.Side.INPUT, E.Side.BOTH]: _input += 1
		if p.side in [E.Side.OUTPUT, E.Side.BOTH]: _output += 1
	
	return -1

# Helper functions
func get_port_position(side, index : int):
	if side == E.Side.INPUT: return get_input_port_position(index)
	if side == E.Side.OUTPUT: return get_output_port_position(index)
func get_port_type(side, index : int):
	if side == E.Side.INPUT: return get_input_port_type(index)
	if side == E.Side.OUTPUT: return get_output_port_type(index)

# Labels
func hide_messages():
	show_message(success, "", 0, true)
	show_message(warning, "", 0, true)
	show_message(error, "", 0, true)

func show_success(msg: String, duration := 0, hide_others := true) -> void:
	if hide_others: hide_messages()
	show_message(success, msg, duration)

func show_warning(msg: String, duration := 0, hide_others := true) -> void:
	if hide_others: hide_messages()
	show_message(warning, msg, duration)

func show_error(msg: String, duration := 0, hide_others := true) -> void:
	if hide_others: hide_messages()
	show_message(error, msg, duration)

var _label_tweens := []
func show_message(label:Label, msg: String, duration := 0.0, immediate := false) -> void:
	if immediate:
		for t: Tween in _label_tweens:
			t.kill()
		_label_tweens = []
		label.text = msg
		label.visible = msg != ""
		reset_size()
		return
	# Nothing to do
	if not label.text and not msg: return
	# Actions
	var _hide := label.text and not msg
	var _temporary := msg and duration
	const HIDE_DURATION = 0.3
	# Operations
	var tween = create_tween()
	_label_tweens.append(tween)
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
	tween.tween_callback(_label_tweens.erase.bind(tween))

# Utility

func get_ports_in_group(group: String) -> Array[HBasePort]:
	var r: Array[HBasePort] = []
	for n in get_tree().get_nodes_in_group(group):
		if n is HBasePort and is_ancestor_of(n):
			r.append(n)
	return r

# Save and Load

func save() -> Dictionary:
	var s = {
		"type": type,
		"vals": {},
		"ports": {},
		"pos": { "x": position_offset.x, "y": position_offset.y },
		"name": name,
	}
	if collapsed: s.collapsed = true
	for p in ports.list():
		# Save value
		if p.side in [E.Side.INPUT, E.Side.BOTH, E.Side.NONE]:
			var val
			if p.value is Array or p.value is Dictionary:
				# We don't save Arrays and Dictionnary because they are supposed to be fed by connections ?
				# FIXME: is it always the case?
				continue
			if p.type == E.CONNECTION_TYPES.VEC2:
				val = { "x": p.value.x, "y": p.value.y }
			elif p.type == E.CONNECTION_TYPES.COLOR:
				val = p.value.to_html()
			elif p.type != E.CONNECTION_TYPES.FLOW:
				val = p.value
			
			s.vals[p.name] = val
		
		# Save display name
		if p.display_name != p.name:
			s.ports[p.name] = { "display_name": p.display_name }
	
	if not s.ports: s.erase("ports")
	
	return s

func load(data : Dictionary) -> void:
	position_offset = Vector2(data.pos.x, data.pos.y)
	
	for _name in data.get("ports", {}):
		var _port = port(_name)
		var _display_name = data.ports[_name].get("display_name", "")
		if _display_name: port(_name).display_name = _display_name
	
	for _name in data.vals:
		var _port = port(_name)
		if not _port: 
			print("Found value of '%s' in the save file while loading node '%s', but it's not in the node definition. This should not happen." % [_name, type])
			continue
		if _port.type == E.CONNECTION_TYPES.VEC2:
			_port.value = Vector2(data.vals[_name].x, data.vals[_name].y)
		elif _port.type == E.CONNECTION_TYPES.COLOR:
			_port.value = Color(data.vals[_name])
		elif _port.type == E.CONNECTION_TYPES.IMAGE:
			_port.value = null
		else:
			_port.value = data.vals[_name]
		# Update the node with each value set to be sure it's properly displayed
		update(_port)
	
	btn_collapse.button_pressed = data.get("collapsed", false)
