extends MenuButton

# FIXME: quick n dirty



signal add_node(node_type)

func _init() -> void:
	var menu = get_popup()
	menu.add_separator("Core")
	for c in G.NODES_CORES:
		menu.add_item(c._title)
	
	menu.id_pressed.connect(menu_pressed)

func menu_pressed(id:int) -> void:
	add_node.emit(G.NODES_CORES[id-1]._type)
