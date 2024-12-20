extends GraphEdit
class_name HGraphEdit

@onready var selection_rect: TextureRect # = $PortSelectionRect

var connections : HGraphConnections

signal double_clicked_at(pos: Vector2)

func _ready() -> void:
	# Setup valid connections
	add_valid_connection_type(E.CONNECTION_TYPES.INT, E.CONNECTION_TYPES.FLOAT)
	add_valid_connection_type(E.CONNECTION_TYPES.TEXT, E.CONNECTION_TYPES.FLOAT)
	add_valid_connection_type(E.CONNECTION_TYPES.FLOAT, E.CONNECTION_TYPES.INT)
	add_valid_connection_type(E.CONNECTION_TYPES.TEXT, E.CONNECTION_TYPES.INT)
	add_valid_connection_type(E.CONNECTION_TYPES.INT, E.CONNECTION_TYPES.VARIANT)
	add_valid_connection_type(E.CONNECTION_TYPES.FLOAT, E.CONNECTION_TYPES.VARIANT)
	add_valid_connection_type(E.CONNECTION_TYPES.BOOL, E.CONNECTION_TYPES.VARIANT)
	add_valid_connection_type(E.CONNECTION_TYPES.VEC2, E.CONNECTION_TYPES.VARIANT)
	add_valid_connection_type(E.CONNECTION_TYPES.TEXT, E.CONNECTION_TYPES.VARIANT)
	add_valid_connection_type(E.CONNECTION_TYPES.COLOR, E.CONNECTION_TYPES.VARIANT)
	add_valid_connection_type(E.CONNECTION_TYPES.IMAGE, E.CONNECTION_TYPES.VARIANT)
	popup_request.connect(show_popup) # FIXME: see comment in show_popup
	
	# Initial settings
	minimap_enabled = false
	zoom_min = 0.05
	#zoom_max = 50
	show_menu = false
	
	# Setup connections
	connections = HGraphConnections.new()
	connections.graph = self
	
	# Setup selection rect
	selection_rect = TextureRect.new()
	selection_rect.texture = G.get_icon_from_atlas(G.PORTS_TEXTURE, 0, 1, 32, 32)
	selection_rect.z_index = 0
	selection_rect.visible = false
	add_child(selection_rect)
	
	# Setup signals
	child_entered_tree.connect(_on_child_enter_tree)
	connection_request.connect(_on_connection_request)
	copy_nodes_request.connect(_on_copy_nodes_request)
	delete_nodes_request.connect(_on_delete_nodes_request)
	disconnection_request.connect(_on_disconnection_request)
	duplicate_nodes_request.connect(_on_duplicate_nodes_request)
	paste_nodes_request.connect(_on_paste_nodes_request)

func _process(_delta: float) -> void:
	# Makes grid lighter when zooming out (otherwise the screen is saturated)
	if zoom < 0.5:
		add_theme_color_override("grid_major", Color(1, 1, 1, 0.2 * zoom))
		add_theme_color_override("grid_minor", Color(1, 1, 1, 0.05 * zoom))

func _on_child_enter_tree(node : Node):
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

func add_node(node_type: String, pos := Vector2.INF) -> HBaseNode:
	var resource = NodeManager.get_node_by_type(node_type)
	if not resource: 
		print("Node_type invalid: %s" % node_type)
		return
	var node = resource.new()
	add_child(node)
	# At mouse position
	#node.position_offset = (get_local_mouse_position() + scroll_offset) / zoom
	# At position
	if pos != Vector2.INF:
		node.position_offset = (pos + scroll_offset) / zoom
	# At center
	else:
		node.position_offset = (size / 2 + scroll_offset) / zoom
	return node

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_RIGHT and not event.pressed:
			print("Popup Menu")

## FIXME: doesn't work with multiple windows: some components lose ability to focus ..?
func show_popup(_at_position: Vector2) -> void:
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
	if _to_port.type != E.CONNECTION_TYPES.FLOW and not _to_port.is_multiple:
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
var dragging := false
func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		# Ports
		var hover_port = get_hover_port(event.position)
		if hover_port:
			selection_rect.scale = Vector2.ONE * zoom
			selection_rect.position = -scroll_offset + hover_port.node.position_offset * zoom + hover_port.node.get_port_position(hover_port.side, hover_port.index) * zoom - selection_rect.size / 2 * zoom
			var color = E.connection_colors[hover_port.node.get_port_type(hover_port.side, hover_port.index)]
			selection_rect.modulate = Color(color, 0.3)
			mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
		else:
			mouse_default_cursor_shape = Control.CURSOR_ARROW
		selection_rect.visible = hover_port != {}
	
		# Connection: change mouse cursor when hovering
		var connection = get_closest_connection_at_point(event.position)
		if connection:
			mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
		
		# Check if we are dragging (otherwise emit pointer click on node when creating connections)
		if event.button_mask & MOUSE_BUTTON_MASK_LEFT:
			dragging = true
	
	if event is InputEventMouseButton:
		if event.double_click:
			double_clicked_at.emit(event.position)
			get_viewport().set_input_as_handled()
		elif event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
			# Port click
			var hover_port = get_hover_port(event.position)
			if not dragging and hover_port:
				var _port = hover_port.node.get_port(hover_port.side, hover_port.index)
				hover_port.node.port_clicked.emit(hover_port.node.get_port(hover_port.index, hover_port.side))
			
			# Connection: remove connection
			var connection = get_closest_connection_at_point(event.position)
			if not hover_port and connection:
				connections.remove_connection_godot(connection.from_node, connection.from_port, connection.to_node, connection.to_port)
			
			# Dragging
			dragging = false

## Return a node's port that is hovered by `pos` (global).
func get_hover_port(pos : Vector2) -> Dictionary:
	var _pos = (pos + scroll_offset) / zoom
	for node in get_nodes():
		for i in node.get_input_port_count():
			if (node.position_offset + node.get_input_port_position(i) - _pos).length() < 10:
				return { "node": node, "side": E.Side.INPUT, "index": i }
		for i in node.get_output_port_count():
			if (node.position_offset + node.get_output_port_position(i) - _pos).length() < 10:
				return { "node": node, "side": E.Side.OUTPUT, "index": i }
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

func local_to_graph(pos: Vector2) -> Vector2:
	return pos * zoom - scroll_offset

## Saves graph in user dir
func save() -> Dictionary:
	var to_save = {
		"name": name,
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
	
	return to_save

## Loads graph from user dir
func load(data : Dictionary):
	clear()
	
	name = data.get("name", "Unnamed")
	
	for n in data.nodes:
		print("Loading node: ", n.name)
		var node := add_node(n.type)
		node.name = n.name
		node.load(n)
	
	for c in data.connections:
		connections.add_connection_names(c.from_node, c.from_port, c.to_node, c.to_port, c.get("visible", true))
	
	if data.has("settings") and data.settings.has("zoom"):
		zoom = data.settings.zoom
	if data.has("settings") and data.settings.has("scroll_offset_x"):
		scroll_offset.x = data.settings.scroll_offset_x
		scroll_offset.y = data.settings.scroll_offset_y

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
		connections.add_connection_names(c.from_node, c.from_port, c.to_node, c.to_port, c.get("visible", true))

func _on_duplicate_nodes_request() -> void:
	var clipboard = DisplayServer.clipboard_get()
	_on_copy_nodes_request()
	_on_paste_nodes_request()
	DisplayServer.clipboard_set(clipboard)
