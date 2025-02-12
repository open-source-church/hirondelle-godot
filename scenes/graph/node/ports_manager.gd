extends RefCounted
class_name HPortsManager

var node: HBaseNode

func _init(_node: HBaseNode) -> void:
	node = _node

func _ready() -> void:
	find_and_add_ports()

func find_and_add_ports() -> void:
	# Find every HBasePorts declared
	for p in node.get_property_list():
		if p.class_name and node[p.name] is HBasePort:
			add_port(p.name, node[p.name])

func list() -> Array[HBasePort]:
	var r: Array[HBasePort] = []
	node.get_children().filter(func (n): return n is HBasePort).map(func (n): r.append(n))
	return r

func add_port(_name:String, port: HBasePort) -> void:
	#ports.append(port)
	
	port.name = _name
	node.add_child(port)
	
	node.collapsed_changed.connect(port.set_node_collapsed)
		
	# Update node on input value change
	if port.side in [E.Side.INPUT, E.Side.BOTH, E.Side.NONE]:
		port.value_changed.connect(node.update.bind(port))
	# Propagate values on ouput value change
	if port.side in [E.Side.OUTPUT, E.Side.BOTH]:
		port.value_changed.connect(port.propagate_value)

func get_by_name(_name: String) -> HBasePort:
	var _port = list().filter(func (p): return p.name == _name)
	if not _port:
		push_error("%s not found in ports of %s" % [_name, node.name])
		return null
	return _port.front()
