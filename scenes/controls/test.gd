extends Control

@onready var btn_save: Button = %BtnSave
@onready var btn_load: Button = %BtnLoad
@onready var graph_edit: HGraphEdit = %GraphEdit
@onready var btn_clear: Button = %BtnClear
@onready var menu_panel: PanelContainer = %MenuPanel
@onready var btn_menu: Button = %BtnMenu
@onready var btn_window: Button = %BtnWindow
@onready var h_window: HWindow = %HWindow
@onready var btn_add_node: Button = %BtnAddNode
@onready var graph_list: VBoxContainer = %GraphList

@onready var btn_menu_nodes: Button = %BtnMenuNodes
@onready var btn_menu_settings: Button = %BtnMenuSettings
@onready var nodes: TabContainer = %Nodes
@onready var settings: MarginContainer = %Settings

const ADD_NODE_POPUP = preload("res://scenes/controls/add_node_popup.tscn")
var popup_add_node : Window

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	btn_save.pressed.connect(graph_edit.save)
	btn_load.pressed.connect(graph_edit.load)
	btn_clear.pressed.connect(graph_edit.clear)
	btn_menu.toggled.connect(menu_panel.set_visible)
	btn_window.toggled.connect(h_window.set_visible)
	btn_add_node.pressed.connect(show_add_node_popup)
	# Left menu
	btn_menu_nodes.pressed.connect(show_tab.bind(nodes))
	btn_menu_settings.pressed.connect(show_tab.bind(settings))
	show_tab(nodes)
	
	popup_add_node = ADD_NODE_POPUP.instantiate()
	popup_add_node.visible = false
	popup_add_node.add_node.connect(graph_edit.add_node)
	add_child(popup_add_node)

func show_add_node_popup() -> void:
	popup_add_node.position = DisplayServer.window_get_position() + DisplayServer.window_get_size() / 2 - popup_add_node.size / 2
	popup_add_node.show()
	popup_add_node.focus_filter()

func show_tab(tab : Control) -> void:
	tab.visible = true
	btn_menu_nodes.button_pressed = tab == nodes
	btn_menu_settings.button_pressed = tab == settings
	graph_list.visible = tab == nodes
