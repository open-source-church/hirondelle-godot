extends Control

# Main bar
@onready var btn_save: Button = %BtnSave
@onready var btn_load: Button = %BtnLoad
@onready var btn_clear: Button = %BtnClear
@onready var btn_menu: Button = %BtnMenu
@onready var btn_window: Button = %BtnWindow
@onready var btn_add_node: Button = %BtnAddNode

# Containers and stuff
@onready var graph_container: TabContainer = %GraphContainer
@onready var settings: MarginContainer = %Settings
@onready var h_window: HWindow = %HWindow

# Left menu
@onready var menu_panel: PanelContainer = %MenuPanel
@onready var btn_menu_nodes: Button = %BtnMenuNodes
@onready var btn_menu_settings: Button = %BtnMenuSettings

# Graphlist container
@onready var graph_list_container: VBoxContainer = %GraphListContainer
@onready var btn_add_graph: Button = %BtnAddGraph
@onready var btn_remove_graph: Button = %BtnRemoveGraph
@onready var graph_tree: Tree = %GraphTree

# Popup window
const ADD_NODE_POPUP = preload("res://scenes/controls/add_node_popup.tscn")
var popup_add_node : Window

## List of all the graphs
@onready var graphs : Array[HGraphEdit] = []
## Currently displayed graph
var current_graph : HGraphEdit

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	btn_save.pressed.connect(save)
	btn_load.pressed.connect(load_graphs)
	btn_clear.pressed.connect(clear)
	btn_menu.toggled.connect(menu_panel.set_visible)
	btn_window.toggled.connect(h_window.set_visible)
	h_window.visibility_changed.connect(func (): btn_window.set_pressed_no_signal(h_window.visible))
	
	# Left menu
	btn_menu_nodes.pressed.connect(show_main_tab.bind(graph_container))
	btn_menu_settings.pressed.connect(show_main_tab.bind(settings))
	show_main_tab(graph_container)
	
	# Graph list
	add_graph()
	graph_container.tab_changed.connect(graph_tab_changed)
	graph_tree.item_selected.connect(graph_tree_item_selected)
	graph_tree.item_activated.connect(graph_tree_item_activated)
	graph_tree.item_edited.connect(graph_tree_item_edited)
	btn_add_graph.pressed.connect(add_graph)
	btn_remove_graph.pressed.connect(remove_graph)
	
	# Popup window
	btn_add_node.pressed.connect(show_add_node_popup)
	popup_add_node = ADD_NODE_POPUP.instantiate()
	popup_add_node.visible = false
	popup_add_node.add_node.connect(add_node)
	add_child(popup_add_node)


#region SAVE AND LOAD

func save() -> void:
	var save_file = FileAccess.open("user://savegame.save", FileAccess.WRITE)
	
	var to_save = {
		"graphs": [],
		"settings": {}
	}
	
	for g in graphs:
		to_save.graphs.append(g.save())
	
	if current_graph:
		to_save.settings.current_graph = current_graph.name
	
	save_file.store_line(JSON.stringify(to_save, "\t"))
	print(save_file.get_path_absolute())

func load_graphs() -> void:
	var load_file = FileAccess.open("user://savegame.save", FileAccess.READ)
	var content = load_file.get_as_text()
	content = JSON.parse_string(content)
	print("Loading from: ", load_file.get_path_absolute())
	
	remove_all_graphs()
	
	var _settings = content.get("settings", {})
	var _current_graph_name = _settings.get("current_graph", "")
	
	# Load graphs
	for g_data in content.graphs:
		var g = add_graph()
		g.load(g_data)
		if g.name == _current_graph_name:
			g.set_visible.call_deferred(true)
	
	update_graph_list()

#endregion

#region CURRENT GRAPH FUNCTIONS
func clear() -> void:
	current_graph.clear()

func add_node(node_type: String) -> void:
	current_graph.add_node(node_type)
#endregion

# MAIN MENU

## Switches main tab (graph or settings)
func show_main_tab(tab : Control) -> void:
	tab.visible = true
	btn_menu_nodes.button_pressed = tab == graph_container
	btn_menu_settings.button_pressed = tab == settings
	graph_list_container.visible = tab == graph_container

#region GRAPH LIST

func add_graph() -> HGraphEdit:
	var g = HGraphEdit.new()
	graphs.append(g)
	graph_container.add_child(g)
	g.name = "New graph"
	current_graph = g
	update_graph_list()
	current_graph.visible = true
	return g
	
func remove_graph() -> void:
	graphs.erase(current_graph)
	update_graph_list()
	current_graph.free()

func remove_all_graphs() -> void:
	for g in graphs:
		g.free()
	graphs.clear()
	current_graph = null
	update_graph_list()

func update_graph_list() -> void:
	graph_tree.clear()
	var _root = graph_tree.create_item()
	for g in graphs:
		var i = graph_tree.create_item()
		i.set_text(0, g.name)
		i.set_metadata(0, g)
		if g == current_graph:
			i.select(0)

func graph_tree_item_selected():
	var selected = graph_tree.get_selected()
	if selected:
		var g = selected.get_metadata(0)
		# Check if object has just been freed
		if not is_instance_valid(g): return
		g.visible = true
		current_graph = g

## Item activated by dbl-click
func graph_tree_item_activated():
	graph_tree.edit_selected(true)

## Called after an item edit event. We update item name.
func graph_tree_item_edited():
	var item = graph_tree.get_edited()
	var _name = item.get_text(0)
	if not _name: _name = "Unnamed"
	current_graph.name = _name
	# Take back the name from Godot, it case it changed because of duplicate
	item.set_text(0, current_graph.name)

func graph_tab_changed(idx : int):
	if idx == -1 or idx >= graph_tree.get_root().get_child_count(): 
		current_graph = null
		return
	var i = graph_tree.get_root().get_child(idx)
	i.select(0)
#endregion

#region ADD NODE POPUP

func show_add_node_popup() -> void:
	popup_add_node.position = DisplayServer.window_get_position() + DisplayServer.window_get_size() / 2 - popup_add_node.size / 2
	popup_add_node.show()
	popup_add_node.focus_filter()
#endregion
