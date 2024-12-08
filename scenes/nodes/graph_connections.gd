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
		return {
			"from_node": from_node.name,
			"to_node": to_node.name,
			"from_port": from_node.get_port_number(from_port.name),
			"to_port": to_node.get_port_number(to_port.name)
		}
	
	func to_names() -> Dictionary:
		return {
			"from_node": from_node.name,
			"to_node": to_node.name,
			"from_port": from_port.name,
			"to_port": to_port.name,
			"visible": visible
		}
	
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
		if to_port.is_dictionary:
			to_port.update_from_connections()
	
	## [param use_last]: dont query for new godot values, but use last. Useful when port visibility has change.
	func hide(use_last := false):
		visible = false
		disconnect_in_graph(use_last)
	
	func show():
		visible = true
		connect_in_graph()

## The list of [member Connections]
@onready var connections : Array[Connection] = []

## A reference to the [HGraphEdit] those connections belong to.
var graph : HGraphEdit

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

# CREATE CONNECTIONS

func create_connection_from_godot(from_node_name: StringName, from_port_number: int, to_node_name: StringName, to_port_number: int, visible := true) -> Connection:
	var _from_node := graph.get_node_by_id(from_node_name)
	var _to_node := graph.get_node_by_id(to_node_name)
	return Connection.new(graph, _from_node, _from_node.get_output_port(from_port_number), _to_node, _to_node.get_input_port(to_port_number), visible)

func create_connection_from_names(from_node_name: String, from_port_name: String, to_node_name: String, to_port_name: String, visible := true) -> Connection:
	var _from_node := graph.get_node_by_id(from_node_name)
	var _to_node := graph.get_node_by_id(to_node_name)
	return Connection.new(graph, _from_node, _from_node.PORTS[from_port_name], _to_node, _to_node.PORTS[to_port_name], visible)

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
	connection.from_node.propagate_value(connection.from_port.name)

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
func update_node_slots_visibility(node : HBaseNode) -> void:
	for port in node.PORTS.values():
		for c in list_to_and_from_port(port):
			if port.visible and not c.visible:
				# Port just turned visible
				c.show()
			elif not port.visible and c.visible:
				# Port just got hidden
				c.hide(true)

## Remove all connections to slots that are hidden
func remove_connections_to_hidden_slots(node : HBaseNode):
	for port in node.PORTS.values():
		for c in list_to_and_from_port(port):
			if not port.visible:
				remove_connection(c, true)

# LOAD AND SAVE

func save(selected_only := false) -> Array:
	var r = []
	for c in connections:
		if selected_only and (not c.from_node.selected or not c.to_node.selected):
			continue
		r.append(c.to_names())
	return r
