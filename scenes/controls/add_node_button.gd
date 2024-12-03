extends MenuButton

# FIXME: quick n dirty



signal add_node(node_type)

func _init() -> void:
	var menu = get_popup()
	menu.add_separator("Core")
	var i = 0
	for c in G.NODES:
		menu.add_item(c._title, i)
		i += 1
	
	menu.id_pressed.connect(menu_pressed)

func menu_pressed(id:int) -> void:
	add_node.emit(G.NODES[id]._type)
