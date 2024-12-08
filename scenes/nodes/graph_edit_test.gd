extends GraphEdit
class_name HGraphEdit

@onready var selection_rect: TextureRect = $PortSelectionRect

var connections : HGraphConnections

func _ready() -> void:
	add_valid_connection_type(E.CONNECTION_TYPES.INT, E.CONNECTION_TYPES.FLOAT)
	add_valid_connection_type(E.CONNECTION_TYPES.INT, E.CONNECTION_TYPES.VARIANT)
	add_valid_connection_type(E.CONNECTION_TYPES.FLOAT, E.CONNECTION_TYPES.VARIANT)
	add_valid_connection_type(E.CONNECTION_TYPES.BOOL, E.CONNECTION_TYPES.VARIANT)
	add_valid_connection_type(E.CONNECTION_TYPES.VEC2, E.CONNECTION_TYPES.VARIANT)
	add_valid_connection_type(E.CONNECTION_TYPES.TEXT, E.CONNECTION_TYPES.VARIANT)
	add_valid_connection_type(E.CONNECTION_TYPES.COLOR, E.CONNECTION_TYPES.VARIANT)
	popup_request.connect(show_popup) # FIXME: see comment in show_popup
	
	connections = HGraphConnections.new()
	connections.graph = self

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
	print("FIXME: show popup")
	#var popup = add_node_button.get_popup()
	##popup.position = at_position
	#popup.position = Vector2(get_window().position) + at_position
	#popup.show()

func _on_connection_request(from_node: StringName, from_port: int, to_node: StringName, to_port: int) -> void:
	print("Connection request FROM %s at %d TO %s at %d" % [from_node, from_port, to_node, to_port])
	
	var _to_node = get_node_by_id(to_node)
	var _to_port = _to_node.get_input_port(to_port)
	
	# Clear existing connections if needed
	if _to_port.type != E.CONNECTION_TYPES.FLOW and not _to_port.is_dictionary:
		for c in connections.list_to_node_and_port(_to_node, _to_port):
			connections.remove_connection(c)
	
	# Make connection
	connections.add_connection_godot(from_node, from_port, to_node, to_port)

func get_node_by_id(id: String) -> HBaseNode:
	return get_node(NodePath(id))

func _on_disconnection_request(from_node: StringName, from_port: int, to_node: StringName, to_port: int) -> void:
	print("Disconnection request FROM %s at %d TO %s at %d" % [from_node, from_port, to_node, to_port])
	connections.remove_connection_godot(from_node, from_port, to_node, to_port)

## Removes all nodes and connections.
func clear():
	connections.clear()
	for c in get_children():
		if c is HBaseNode:
			c.queue_free()

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


func _on_delete_nodes_request(nodes: Array[StringName]) -> void:
	print("Delete node request: ", nodes)
	
	for n in nodes:
		var _n = get_node(NodePath(n))
		# Remove connections
		connections.disconnect_node(_n)
		# Remove node
		_n.queue_free()

func get_selected_nodes() -> Array[Node]:
	return get_children().filter(func (c): return c is HBaseNode and c.selected)

func get_mouse_position() -> Vector2:
	return (get_local_mouse_position() + scroll_offset) / zoom

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
	
	to_save.connections = connections.save()
	
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
		node.name = n.name
		node.load(n)
	
	for c in content.connections:
		connections.add_connection_names(c.from_node, c.from_port, c.to_node, c.to_port, c.get("visible", true))
	
	if content.has("settings") and content.settings.has("zoom"):
		zoom = content.settings.zoom
	if content.has("settings") and content.settings.has("scroll_offset_x"):
		scroll_offset.x = content.settings.scroll_offset_x
		scroll_offset.y = content.settings.scroll_offset_y

func _on_copy_nodes_request() -> void:
	var to_copy = {
		"nodes": [],
		"connections": [],
	}
	var selected = get_selected_nodes()
	
	for n in selected:
		to_copy.nodes.append(n.save())
	
	to_copy.connections = connections.save(true)
	
	DisplayServer.clipboard_set(JSON.stringify(to_copy, "  "))

func _on_paste_nodes_request() -> void:
	var to_paste = JSON.parse_string(DisplayServer.clipboard_get())
	if not to_paste:
		print("Paste: invalid content - not JSON")
		return
	if not "nodes" in to_paste or not "connections" in to_paste:
		print("Paste: invalid content")
		return
	
	set_selected(null)
	
	# Get center of nodes, and mouse position, to position pasted nodes relatively
	var center := Vector2()
	for n in to_paste.nodes:
		center += Vector2(n.pos.x, n.pos.y)
	center = center / to_paste.nodes.size()
	var delta_pos := get_mouse_position() - center
	
	# Node need to get new names (uniques), so we keep them in a map in order to
	# update connections accordingly.
	var name_map = {}
	for n in to_paste.nodes:
		var node := add_node(n.type)
		name_map[n.name] = node.name
		node.load(n)
		node.position_offset += delta_pos
		node.selected = true
	
	for c in to_paste.connections:
		c.from_node = name_map.get(c.from_node, c.from_node)
		c.to_node = name_map.get(c.to_node, c.to_node)
		var from = get_node_by_id(c.from_node)
		var to = get_node_by_id(c.to_node)
		connections.add_connection_names(c.from_node, c.from_port, c.to_node, c.to_port, c.get("visible", true))

func _on_duplicate_nodes_request() -> void:
	var clipboard = DisplayServer.clipboard_get()
	_on_copy_nodes_request()
	_on_paste_nodes_request()
	DisplayServer.clipboard_set(clipboard)
