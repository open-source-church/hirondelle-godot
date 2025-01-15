extends RefCounted
class_name HGraphGroups
## Groups manager
##
## Allors to have sub graphs.

## A reference to the [HGraphEdit] those groups belong to.
var graph : HGraphEdit

## ID of the current graph bottom level
var main_id := "main"
## ID of the group currently displayed
var current_group_id: String

## Container to show group breadcrumbs
var group_panel: HBoxContainer

func _init(_graph: HGraphEdit) -> void:
	graph = _graph
	# Add group pannel
	var margin = MarginContainer.new()
	margin.add_theme_constant_override("margin_top", 6)
	margin.add_theme_constant_override("margin_right", 12)
	group_panel = HBoxContainer.new()
	margin.add_child(group_panel)
	graph.add_child(margin)
	margin.set_anchors_preset(Control.PRESET_TOP_WIDE)
	margin.layout_direction = Control.LAYOUT_DIRECTION_RTL
	group_panel.layout_direction = Control.LAYOUT_DIRECTION_RTL

func create() -> void:
	var selected = graph.get_selected_nodes()
	if not selected:
		print("Nothing selected, no group to create.")
		return
	
	# Create group node
	var group = HGroupNode.new()
	graph.add_child(group)
	group.add_to_group(current_group_id)
	group.position_offset = graph.get_nodes_median_position(selected)
	
	# Get all connections to those nodes
	var _connections := graph.connections.list_to_and_from_nodes(selected)
	
	# Keep those that are to nodes not in the selection
	_connections = _connections.filter(func (c: HGraphConnections.Connection): return c.from_node not in selected or c.to_node not in selected)
	
	# Create Paramater Nodes
	var _param_nodes := {}
	for c in _connections:
		graph.connections.remove_connection(c)
		if c.from_node in selected:
			# Output parameter
			if c.from_port in _param_nodes: continue
			var param = HParameterNode.new()
			graph.add_child(param)
			param.add_to_group(group.name)
			
			param.side_.value = E.Side.OUTPUT
			param.type_.value = c.to_port.type
			param.position_offset = c.to_node.position_offset
			param.get_current_parameter_port().display_name = c.from_port.display_name
			_param_nodes[c.from_port] = param
			
		else:
			# Input parameter
			if c.from_port in _param_nodes: continue
			var param = HParameterNode.new()
			graph.add_child(param)
			param.add_to_group(group.name)
			
			param.side_.value = E.Side.INPUT
			param.type_.value = c.from_port.type
			param.position_offset = c.from_node.position_offset
			param.get_current_parameter_port().display_name = c.to_port.display_name
			_param_nodes[c.from_port] = param
	
	# Update group node
	group.update_ports()
	# Make connections
	for c in _connections:
		if c.from_node in selected:
			# Output parameter
			var _param: HParameterNode = _param_nodes[c.from_port]
			var _connection = graph.connections.create_connection(c.from_node, c.from_port, _param, _param.get_current_parameter_port())
			graph.connections.add_connection(_connection)
			_connection = graph.connections.create_connection(group, group.get_port_from_source(_param.get_current_parameter_port()), c.to_node, c.to_port)
			graph.connections.add_connection(_connection)
		else:
			# Input parameter
			var _param: HParameterNode = _param_nodes[c.from_port]
			var _connection = graph.connections.create_connection(_param, _param.get_current_parameter_port(), c.to_node, c.to_port)
			graph.connections.add_connection(_connection)
			_connection = graph.connections.create_connection(c.from_node, c.from_port, group, group.get_port_from_source(_param.get_current_parameter_port()))
			graph.connections.add_connection(_connection)
		graph.connections.remove_connection(c)
	
	# Assign nodes to group
	for n in selected:
		n.remove_from_group(current_group_id)
		n.add_to_group(group.name)
	
	switch_to(current_group_id)

func switch_to(group_id: String) -> void:
	current_group_id = group_id
	
	# Hide all nodes
	graph.get_nodes().map(func (n: HBaseNode): n.visible = false; n.draggable = false; n.selectable = false)
	# Show nodes belonging in group
	graph.get_nodes_in_group(group_id).map(func (n: HBaseNode): n.visible = true; n.draggable = true; n.selectable = true)
	
	graph.connections.update_connections_based_on_nodes_visibility()
	
	# Updating bread crumbs
	for c in group_panel.get_children():
		c.queue_free()
	var group_node := get_group_node(group_id)
	while group_node != null:
		var ctrl: Control
		if group_node.name == group_id:
			ctrl = Label.new()
		else:
			ctrl = Button.new()
			ctrl.theme_type_variation = "ButtonSmall"
			ctrl.pressed.connect(switch_to.bind(group_node.name))
		ctrl.text = group_node.title
		group_panel.add_child(ctrl)
		var lbl = Label.new()
		lbl.text = " > "
		group_panel.add_child(lbl)
		group_node = get_group_node(group_node.get_groups()[0])
	if group_id != main_id:
		var btn = Button.new()
		btn.theme_type_variation = "ButtonSmall"
		btn.text = "Main"
		btn.pressed.connect(switch_to.bind(main_id))
		group_panel.add_child(btn)

## Return the [HGroupNode] matching [param group_id].
func get_group_node(group_id: String) -> HGroupNode:
	for n in graph.get_nodes():
		if n is HGroupNode and n.name == group_id: return n
	return null
