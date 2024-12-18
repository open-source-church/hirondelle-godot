extends Node
class_name HNodeManager

const NODES_PATH := "res://scenes/nodes/"
const SOURCES_PATH := "res://scenes/sources/"

## List of node resources. Dynamically loaded on start.
var nodes: Array[Resource] = []
## List of sources. Dynamically loaded on start.
var sources: Array[HBaseSource] = []

## Whether logging to console is enabled
var log_enabled := true

func _ready() -> void:
	load_nodes_resources_from_res()
	load_sources_from_res()

## Loads sources from folder. Used [member SOURCES_PATH].
func load_sources_from_res() -> void:
	var _names = []
	for src in DirAccess.get_files_at(SOURCES_PATH):
		var _path = SOURCES_PATH.path_join(src)
		var source : HBaseSource = load(_path).new()
		if source.name in _names:
			log_("There is already a source with name %s. Yet you want to add another one: <%s>. Ignoring it." % [
				source.name, src])
			continue
		sources.append(source)
		add_child(source)
		_names.append(source.name)
	log_("Loaded %d sources." % len(sources))

## Returns the resource of the node of the given [param node_type].
func get_source_by_name(_name: String) -> HBaseSource:
	var source = sources.filter(func (s: HBaseSource): return s.name.to_lower() == _name.to_lower())
	if source: return source.front()
	log_("Asked for source named <%s>, but it is not found." % _name)
	return null

## Returns true if all sources are active for [param node].[br]
## [param node] can be be [Resources] or [HBaseNode].
func get_sources_active_for_node(node) -> bool:
	if not "_sources" in node: return true
	return node._sources.all(func (s: String): return get_source_by_name(s).active)
	
## Loads nodes from folder. Used [member NODES_PATH].
func load_nodes_resources_from_res() -> void:
	var _types = []
	for dir in DirAccess.get_directories_at(NODES_PATH):
		var _path := NODES_PATH.path_join(dir)
		for node in DirAccess.get_files_at(_path):
			var _node_path = _path.path_join(node)
			var rsc := load(_node_path)
			if rsc._type in _types:
				log_("There is already a node with node_type %s: <%s>. Yet you want to add another one: <%s>. Ignoring it." % [
					rsc._type, get_node_by_type(rsc._type)._title, rsc._title])
				continue
			nodes.append(rsc)
			_types.append(rsc._type)
	log_("Loaded %d nodes." % len(nodes))

## Returns the resource of the node of the given [param node_type].
func get_node_by_type(node_type: String) -> Resource:
	var resource = nodes.filter(func (r): return r._type == node_type)
	if resource: return resource.front()
	log_("Asked for node_type %s, but it is not found." % node_type)
	return null

## Guesses node color depending on it's type. [param node] can be [Resource] or [HBaseNode].
func get_node_color(node):
	if "text" in node._type:
		return E.connection_colors[E.CONNECTION_TYPES.TEXT]
	if "int" in node._type:
		return E.connection_colors[E.CONNECTION_TYPES.INT]
	if "vec2" in node._type:
		return E.connection_colors[E.CONNECTION_TYPES.VEC2]
	if "float" in node._type:
		return E.connection_colors[E.CONNECTION_TYPES.FLOAT]
	if "bool" in node._type:
		return E.connection_colors[E.CONNECTION_TYPES.BOOL]
	return Color.WHITE

## Prints [param msg] to the console if [member log_enabled] is true.
func log_(msg: String) -> void:
	if not log_enabled: return
	print_rich("[color=orange][NodeManager] %s[/color]" % msg)
