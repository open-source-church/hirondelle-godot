extends GraphEdit
class_name HGraphEdit

## Connexion types
enum TYPES {
	FLOW,
	TEXT,
	INT,
	FLOAT,
	COLOR,
	VEC2,
	BOOL,
	VARIANT,
	VARIANT_ARRAY
}

const colors = {
	TYPES.FLOW: Color.GREEN,
	TYPES.TEXT: Color.PURPLE,
	TYPES.INT: Color.YELLOW,
	TYPES.COLOR: Color.BLUE,
	TYPES.FLOAT: Color.ORANGE,
	TYPES.BOOL: Color.CYAN,
	TYPES.VEC2: Color.BROWN,
	TYPES.VARIANT: Color.GRAY,
	TYPES.VARIANT_ARRAY: Color.DIM_GRAY,
}

@export var add_node_button : MenuButton
@onready var selection_rect: TextureRect = $PortSelectionRect

func _ready() -> void:
	G.graph = self
	add_valid_connection_type(TYPES.INT, TYPES.FLOAT)
	add_valid_connection_type(TYPES.INT, TYPES.VARIANT)
	add_valid_connection_type(TYPES.FLOAT, TYPES.VARIANT)
	add_valid_connection_type(TYPES.BOOL, TYPES.VARIANT)
	add_valid_connection_type(TYPES.VEC2, TYPES.VARIANT)
	add_valid_connection_type(TYPES.TEXT, TYPES.VARIANT)
	add_valid_connection_type(TYPES.COLOR, TYPES.VARIANT)
	add_node_button.add_node.connect(add_node)
	#popup_request.connect(show_popup) # FIXME: see comment in show_popup

func on_child_enter_tree(node : Node):
	if node is HBaseNode:
		node.name = get_unique_name(node)

func get_unique_name(node : HBaseNode) -> String:
	# Count the number of node of that type
	var n = get_nodes().filter(func (_n): return _n.type == node.type).size()
	return "%s-%d" % [node.type, n]

## Returns all nodes in this graph
func get_nodes() -> Array[HBaseNode]:
	var r : Array[HBaseNode] = []
	for c in get_children().filter(func (n): return n is HBaseNode):
		r.append(c)
	return r

func add_node(node_type: String) -> HBaseNode:
	var resource = G.NODES.filter(func (r): return r._type == node_type)
	if not resource: 
		print("Node_type invalid")
		return
	var node = resource.front().new()
	add_child(node)
	# At mouse position
	#node.position_offset = (get_local_mouse_position() + scroll_offset) / zoom
	# At center
	node.position_offset = (size / 2 + scroll_offset) / zoom
	return node

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_RIGHT and not event.pressed:
			print("Popup Menu")

## FIXME: doesn't work with multiple windows: some components lose ability to focus ..?
func show_popup(at_position: Vector2) -> void:
	var popup = add_node_button.get_popup()
	#popup.position = at_position
	popup.position = Vector2(get_window().position) + at_position
	popup.show()

func get_connections_from_node_and_port(from_node: String, from_port: int) -> Array:
	return get_connection_list().filter(func (c): return c.from_node == from_node and c.from_port == from_port)

func get_connections_from_node(from_node: String) -> Array:
	return get_connection_list().filter(func (c): return c.from_node == from_node)

func get_full_connections_from_node(from_node: String) -> Array:
	return map_full(get_connections_from_node(from_node))

func get_connections_to_node_and_port(to_node: String, to_port: int) -> Array:
	return get_connection_list().filter(func (c): return c.to_node == to_node and c.to_port == to_port)

func _on_connection_request(from_node: StringName, from_port: int, to_node: StringName, to_port: int) -> void:
	print("Connection request FROM %s at %d TO %s at %d" % [from_node, from_port, to_node, to_port])
	
	var _to_node = get_node_by_id(to_node)
	var _to_port = _to_node.get_input_port(to_port)
	
	if _to_port.type == TYPES.FLOW or _to_port.is_dictionary:
		pass
	else:
		# Clear existing connections
		for c in get_connections_to_node_and_port(to_node, to_port):
			var _c = full_connection(c)
			if not _c.to_port.type == TYPES.FLOW:
				disconnect_node(c.from_node, c.from_port, c.to_node, c.to_port)
	
	# Make connection
	connect_node(from_node, from_port, to_node, to_port)
	update_values_from_connection({"from_node": from_node, "from_port": from_port, "to_node": to_node, "to_port": to_port})

func update_values_from_connection(connection : Dictionary) -> void:
	update_values_from_full_connection(full_connection(connection))
	
func update_values_from_full_connection(connection : Dictionary) -> void:
	connection.from_node.propagate_value(connection.from_port.name)

func map_full(connections : Array) -> Array:
	return connections.map(func (c): return full_connection(c))

func get_node_by_id(id: String) -> HBaseNode:
	return get_node(NodePath(id))

## Map a connection to its real objects (nodes and controls)
func full_connection(connection : Dictionary) -> Dictionary:
	var c := {}
	c.from_node = get_node_by_id(connection.from_node)
	c.to_node = get_node_by_id(connection.to_node)
	c.from_port = c.from_node.get_output_port(connection.from_port)
	c.to_port = c.to_node.get_input_port(connection.to_port)
	return c

func _on_disconnection_request(from_node: StringName, from_port: int, to_node: StringName, to_port: int) -> void:
	print("Disconnection request FROM %s at %d TO %s at %d" % [from_node, from_port, to_node, to_port])
	disconnect_node(from_node, from_port, to_node, to_port)
	# Check if port is dictionary to update
	var _to_node = get_node_by_id(to_node)
	var _to_port = _to_node.get_input_port(to_port)
	if _to_port.is_dictionary:
		var connections = map_full(get_connections_to_node_and_port(to_node, to_port))
		_to_port.update_from_connections()
		#_to_port.value = {}
		#for c in connections:
			#print(" * ", c.from_node.name, " ", c.from_port.name)
			#c.from_node.propagate_value(c.from_port.name)

## Removes all nodes and connections.
func clear():
	clear_connections()
	for c in get_children():
		if c is HBaseNode:
			c.queue_free()

## Saves graph in user dir
func save():
	var save_file = FileAccess.open("user://savegame.save", FileAccess.WRITE)
	var to_save = {
		"nodes": [],
		"connections": [],
		"settings": {
			"scroll_offset_x": scroll_offset.x,
			"scroll_offset_y": scroll_offset.y,
			"zoom": zoom
		}
	}
	
	for n in get_children():
		if n.has_method("save"):
			to_save.nodes.append(n.save())
	
	for c in get_connection_list():
		var _c = full_connection(c)
		to_save.connections.append({
			"from_node": _c.from_node.name,
			"to_node": _c.to_node.name,
			"from_port": _c.from_port.name,
			"to_port": _c.to_port.name
		})
	
	save_file.store_line(JSON.stringify(to_save, "\t"))
	print(save_file.get_path_absolute())

## Loads graph from user dir
func load():
	clear()
	var load_file = FileAccess.open("user://savegame.save", FileAccess.READ)
	var content = load_file.get_as_text()
	content = JSON.parse_string(content)
	print("Loading from: ", load_file.get_path_absolute())
	
	for n in content.nodes:
		print("Loading node: ", n.name)
		var node := add_node(n.type)
		node.position_offset = Vector2(n.pos.x, n.pos.y)
		node.name = n.name
		for _name in n.vals:
			if not _name in node.VALS: 
				print("Found value of '%s' in the save file while loading node '%s', but it's not in the node definition. This should not happen." % [_name, node._type])
				continue
			if node.VALS[_name].type == TYPES.VEC2:
				node.VALS[_name].value = Vector2(n.vals[_name].x, n.vals[_name].y)
			elif node.VALS[_name].type == TYPES.COLOR:
				node.VALS[_name].value = Color(n.vals[_name])
			else:
				node.VALS[_name].value = n.vals[_name]
			# Update the node with each value set to be sure it's properly displayed
			node._last_port_changed = _name
			node.update()
	
	for c in content.connections:
		var from = get_node_by_id(c.from_node)
		var to = get_node_by_id(c.to_node)
		connect_node(c.from_node, from.get_port_number(c.from_port), c.to_node, to.get_port_number(c.to_port))
	
	if content.has("settings") and content.settings.has("zoom"):
		zoom = content.settings.zoom
	if content.has("settings") and content.settings.has("scroll_offset_x"):
		scroll_offset.x = content.settings.scroll_offset_x
		scroll_offset.y = content.settings.scroll_offset_y

## Clickable ports
func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		var hover_port = get_hover_port(event.position)
		if hover_port:
			selection_rect.scale = Vector2.ONE * zoom
			selection_rect.position = -scroll_offset + hover_port.node.position_offset * zoom + hover_port.node.get_port_position(hover_port.side, hover_port.index) * zoom - selection_rect.size / 2 * zoom
			mouse_default_cursor_shape = Control.CURSOR_CROSS
		else:
			mouse_default_cursor_shape = Control.CURSOR_ARROW
		selection_rect.visible = hover_port != {}
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
			var hover_port = get_hover_port(event.position)
			if hover_port:
				hover_port.node.port_clicked.emit(hover_port.node.get_port_name(hover_port.side, hover_port.index))

## Return a node's port that is hovered by `pos` (global).
func get_hover_port(pos : Vector2) -> Dictionary:
	var _pos = (pos + scroll_offset) / zoom
	for node in get_nodes():
		for i in node.get_input_port_count():
			if (node.position_offset + node.get_input_port_position(i) - _pos).length() < 10:
				return { "node": node, "side": HBaseNode.INPUT, "index": i }
		for i in node.get_output_port_count():
			if (node.position_offset + node.get_output_port_position(i) - _pos).length() < 10:
				return { "node": node, "side": HBaseNode.OUTPUT, "index": i }
	return {}
