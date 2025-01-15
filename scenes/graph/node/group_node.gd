extends HBaseNode
class_name HGroupNode

## Group Node

## Keep a map of ports: node_port (source) -> group_port
var map_sources: Dictionary = {}
## Keep a map of ports: group_port -> node_port (source)
var map_ports: Dictionary = {}

func _init() -> void:
	type = "internal/group"
	title = "New group"

func _ready() -> void:
	super()
	theme_type_variation = "GraphNodeGroup"
	# Title box
	var hbox = get_titlebar_hbox()
	var btn_open_graph = Button.new()
	btn_open_graph.icon = G.get_main_icon("expand", 24)
	btn_open_graph.flat = true
	hbox.add_child(btn_open_graph)
	
	btn_open_graph.pressed.connect(graph.groups.switch_to.bind(name))

#func update(_last_changed: HBasePort = null) -> void:
	#if _last_changed:
		#map_ports[_last_changed].value = _last_changed.value

func update_ports() -> void:
	for n: HParameterNode in graph.get_nodes().filter(func (n: HBaseNode): return n is HParameterNode and n.is_in_group(name)):
		var source := n.get_current_parameter_port()
		
		# Create port. Wish there was a better way to do that.
		var _port: HBasePort
		var _side := E.Side.INPUT if source.side == E.Side.OUTPUT else E.Side.OUTPUT
		if source is HPortFloat:
			_port = HPortFloat.new(_side, source._opt)
		if source is HPortImage:
			_port = HPortImage.new(_side, source._opt)
		if source is HPortArray:
			_port = HPortArray.new(_side, source._opt)
		if source is HPortBool:
			_port = HPortBool.new(_side, source._opt)
		if source is HPortColor:
			_port = HPortColor.new(_side, source._opt)
		if source is HPortDict:
			_port = HPortDict.new(_side, source._opt)
		if source is HPortIntSlider:
			_port = HPortIntSlider.new(_side, source._opt)
		if source is HPortFloatSlider:
			_port = HPortFloatSlider.new(_side, source._opt)
		if source is HPortRatioSlider:
			_port = HPortRatioSlider.new(_side, source._opt)
		if source is HPortIntSpin:
			_port = HPortIntSpin.new(_side, source._opt)
		if source is HPortVec2:
			_port = HPortVec2.new(_side, source._opt)
		if source is HPortText:
			_port = HPortText.new(_side, source._opt)
		if source is HPortTextMultiLine:
			_port = HPortTextMultiLine.new(_side, source._opt)
		if source is HPortPath:
			_port = HPortPath.new(_side, source._opt)
		
		_port.display_name = source.display_name
		_port.editable_name = false
		ports.add_port(source.display_name, _port)
		
		move_child(_port, 0)
		
		map_sources[source] = _port
		map_ports[_port] = source
		
		if _side == E.Side.INPUT:
			_port.value_changed.connect(func (): source.value = _port.value)
		else:
			source.value_changed.connect(func (): _port.value = source.value)
	
	update_slots()

func get_port_from_source(source: HBasePort) -> HBasePort:
	var p = map_sources.get(source)
	if not p:
		print("Port not found in group for port %s" % source.name)
		return null
	return p
