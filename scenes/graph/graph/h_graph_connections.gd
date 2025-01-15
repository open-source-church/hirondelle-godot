extends Node
class_name HGraphConnections
## Connections
##
## There are 3 ways to store connections:[br][br]
##
## 1. Godot: StringName, int, StringName, int. Godot's internal way.[br]
## 2. Objects: HBaseNode, HBasePort, HBaseNode, HBasePort. Most used.[br]
## 3. Names: String, String, String, String. Used in saving.[br]

## Connection class to keep track of connections internally.
class Connection:
	var graph : HGraphEdit
	var from_node : HBaseNode
	var to_node : HBaseNode
	var from_port : HBasePort
	var to_port : HBasePort
	var visible := true
	var _last_godot_values : Dictionary
	
	func _init(_graph: HGraphEdit, _from_node: HBaseNode, _from_port: HBasePort, _to_node: HBaseNode, _to_port: HBasePort, _visible := true):
		graph = _graph
		from_node = _from_node
		to_node = _to_node
		from_port = _from_port
		to_port = _to_port
		visible = _visible
	
	func equals(connection : Connection):
		return (from_node == connection.from_node and to_node == connection.to_node
				and from_port == connection.from_port and to_port == connection.to_port)
	
	func to_godot() -> Dictionary:
		var r = {
			"from_node": from_node.name,
			"to_node": to_node.name,
			"from_port": from_node.get_port_number(from_port.name, E.Side.OUTPUT),
			"to_port": to_node.get_port_number(to_port.name, E.Side.INPUT)
		}
		return r
	
	func to_names() -> Dictionary:
		var _s = {
			"from_node": from_node.name,
			"to_node": to_node.name,
			"from_port": from_port.name,
			"to_port": to_port.name,
		}
		if not visible: _s.visible = false
		return _s
	
	func connect_in_graph():
		if not visible: return
		var c = to_godot()
		graph.connect_node(c.from_node, c.from_port, c.to_node, c.to_port)
		_last_godot_values = c
	
	## [param use_last]: dont query for new godot values, but use last. Useful when port visibility has change.
	func disconnect_in_graph(use_last := false):
		var c = to_godot()
		if use_last: c = _last_godot_values
		graph.disconnect_node(c.from_node, c.from_port, c.to_node, c.to_port)
		# Check if port is dictionary to update
		#if to_port.is_multiple: (Doesn't work with HDictPort with single value)
		# FIXME: Update anyway ? Is it a bad idea?
		to_port.update_from_connections()
	
	## [param use_last]: dont query for new godot values, but use last. Useful when port visibility has change.
	func hide(use_last := false):
		visible = false
		disconnect_in_graph(use_last)
	
	func show():
		visible = true
		connect_in_graph()
	
	func animate():
		if not visible: return
		var n = 3 if from_port.type == E.CONNECTION_TYPES.FLOW else 2
		for i in range(n):
			do_animation()
			await graph.get_tree().create_timer(0.1).timeout
	
	func get_connection_line() -> PackedVector2Array:
		var _c = to_godot()
		var from = from_node.position_offset + from_node.get_output_port_position(_c.from_port)
		var to = to_node.position_offset + to_node.get_input_port_position(_c.to_port)
		var points = Array(graph.get_connection_line(from, to))
		points = points.map(func (p): return graph.local_to_graph(p))
		return PackedVector2Array(points)
	
	func do_animation() -> void:
		var flow = from_port.type == E.CONNECTION_TYPES.FLOW
		var duration = 0.5 if flow else 0.3
		var size = 16 if flow else 10
		# Adapts a bit size to zoom
		if graph.zoom > 1:
			size = size / (graph.zoom + 1) * 2.0
		var points := get_connection_line()
		var _size = size * graph.zoom
		var img := TextureRect.new()
		var _atlas_x = 3 if flow else 0
		img.texture = G.get_icon_from_atlas(G.PORTS_TEXTURE, _atlas_x, 0, 32, _size)
		img.size = Vector2.ONE * _size
		img.position -= Vector2(_size/2.0, _size/2.0)
		img.pivot_offset = Vector2(_size/2.0, _size/2.0)
		img.modulate = E.connection_colors[from_port.type]
		var modulate_to = E.connection_colors[to_port.type]
		var path = Path2D.new()
		img.z_index = 120
		path.curve = Curve2D.new()
		for p in points:
			path.curve.add_point(p)
		var follow = PathFollow2D.new()
		path.add_child(follow)
		follow.add_child(img)
		graph.add_child(path)
		var tween1 = graph.create_tween()
		var tween2 = graph.create_tween()
		tween1.tween_property(follow, "progress_ratio", 1.0, duration).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)
		tween1.set_parallel(true).tween_property(img, "modulate", modulate_to, duration)
		
		#tween.set_parallel(true).tween_property(img, "scale", Vector2.ONE * 2, duration)
		tween2.tween_property(path, "modulate", Color(1, 1, 1, 0.5), duration / 2.0).from(Color.WHITE)
		tween2.tween_property(path, "modulate", Color.WHITE, duration / 2.0).from(Color(1, 1, 1, 0.5))
		#tween2.tween_property(img, "scale", Vector2.ONE * 0.8, duration / 2).from(Vector2.ONE * 1.0)
		#tween2.tween_property(img, "scale", Vector2.ONE * 1.0, duration / 2).from(Vector2.ONE * 0.8)
		await tween1.finished
		path.queue_free()

## The list of [member Connections]
@onready var connections : Array[Connection] = []

## A reference to the [HGraphEdit] those connections belong to.
var graph : HGraphEdit

func _init(_graph: HGraphEdit) -> void:
	graph = _graph

func list() -> Array[Connection]:
	return connections

func list_from_node(node : HBaseNode) -> Array[Connection]:
	return connections.filter( func(c): return c.from_node == node)

func list_to_node(node : HBaseNode) -> Array[Connection]:
	return connections.filter( func(c): return c.to_node == node)

func list_from_node_and_port(node: HBaseNode, port : HBasePort) -> Array[Connection]:
	return connections.filter( func(c): return c.from_node == node and c.from_port == port)
	
func list_to_node_and_port(node: HBaseNode, port : HBasePort) -> Array[Connection]:
	return connections.filter( func(c): return c.to_node == node and c.to_port == port)

func list_from_port(port : HBasePort) -> Array[Connection]:
	return connections.filter( func(c): return c.from_port == port)
	
func list_to_port(port : HBasePort) -> Array[Connection]:
	return connections.filter( func(c): return c.to_port == port)

func list_to_and_from_port(port : HBasePort) -> Array[Connection]:
	return connections.filter( func(c): return c.to_port == port or c.from_port == port)

func list_to_and_from_nodes(_nodes : Array[HBaseNode]) -> Array[Connection]:
	return connections.filter( func(c: Connection): return c.from_node in _nodes or c.to_node in _nodes)

# CREATE CONNECTIONS

func create_connection_from_godot(from_node_name: StringName, from_port_number: int, to_node_name: StringName, to_port_number: int, visible := true) -> Connection:
	var _from_node := graph.get_node_by_id(from_node_name)
	var _to_node := graph.get_node_by_id(to_node_name)
	return Connection.new(graph, _from_node, _from_node.get_output_port(from_port_number), _to_node, _to_node.get_input_port(to_port_number), visible)

func create_connection_from_names(from_node_name: String, from_port_name: String, to_node_name: String, to_port_name: String, visible := true) -> Connection:
	var _from_node := graph.get_node_by_id(from_node_name)
	var _to_node := graph.get_node_by_id(to_node_name)
	return Connection.new(graph, _from_node, _from_node.port(from_port_name), _to_node, _to_node.port(to_port_name), visible)

func create_connection(from_node: HBaseNode, from_port: HBasePort, to_node: HBaseNode, to_port: HBasePort, visible := true) -> Connection:
	return Connection.new(graph, from_node, from_port, to_node, to_port, visible)

# CONNECT

func add_connection_godot(from_node: StringName, from_port: int, to_node: StringName, to_port: int):
	var c = create_connection_from_godot(from_node, from_port, to_node, to_port)
	add_connection(c)

func add_connection_names(from_node_name: String, from_port_name: String, to_node_name: String, to_port_name: String, visible := true):
	var c = create_connection_from_names(from_node_name, from_port_name, to_node_name, to_port_name, visible)
	add_connection(c)

func add_connection(connection : Connection):
	# Store connection
	connections.append(connection)
	# Update graph edit internal
	connection.connect_in_graph()
	# Propagate value
	connection.from_port.propagate_value()

# DISCONNECT

func remove_connection_godot(from_node: StringName, from_port: int, to_node: StringName, to_port: int):
	var c = create_connection_from_godot(from_node, from_port, to_node, to_port)
	remove_connection(c)

## [param use_last_godot_values]: see [HGraphConnections.Connection][param .disconnect_in_graph].
func remove_connection(connection : Connection, use_last_godot_values := false):
	# Remove connection
	connections = connections.filter(func (c): return not c.equals(connection))
	# Update graph edit internal
	connection.disconnect_in_graph(use_last_godot_values)

func disconnect_node(node : HBaseNode) -> void:
	# Disconnect from
	for c in list_from_node(node) + list_to_node(node):
		remove_connection(c)

func clear():
	connections.clear()
	graph.clear_connections()

# HIDE AND SHOW

## Hides or shows connections when port visibility change.
## FIXME: probably buggy.
func update_node_slots_visibility(node : HBaseNode) -> void:
	for port in node.ports.list():
		for c in list_to_and_from_port(port):
			if port.visible and not c.visible:
				# Port just turned visible
				c.show()
			elif not port.visible and c.visible:
				# Port just got hidden
				c.hide(true)

## Remove all connections to slots that are hidden
func remove_connections_to_hidden_slots(node : HBaseNode):
	for port in node.ports.list():
		for c in list_to_and_from_port(port):
			if port.collapsed:
				remove_connection(c, true)

func update_connections_based_on_nodes_visibility() -> void:
	for c in connections:
		if c.from_node.visible and c.to_node.visible:
			c.show()
		else:
			c.hide()

# LOAD AND SAVE

func save(selected_only := false) -> Array:
	var r = []
	for c in connections:
		if selected_only and (not c.from_node.selected or not c.to_node.selected):
			continue
		r.append(c.to_names())
	return r
