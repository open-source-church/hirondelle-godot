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

@onready var btn_menu_nodes: Button = %BtnMenuNodes
@onready var btn_menu_obs: Button = %BtnMenuOBS
@onready var nodes: VBoxContainer = %Nodes
@onready var obs: MarginContainer = %OBS

const ADD_NODE_POPUP = preload("res://scenes/controls/add_node_popup.tscn")
var popup_add_node : Window

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	btn_save.pressed.connect(graph_edit.save)
	btn_load.pressed.connect(graph_edit.load)
	btn_clear.pressed.connect(graph_edit.clear)
	btn_menu.toggled.connect(menu_panel.set_visible)
	btn_window.toggled.connect(h_window.set_visible)
	btn_menu_nodes.toggled.connect(nodes.set_visible)
	btn_menu_obs.toggled.connect(obs.set_visible)
	btn_add_node.pressed.connect(show_add_node_popup)
	
	popup_add_node = ADD_NODE_POPUP.instantiate()
	popup_add_node.visible = false
	popup_add_node.add_node.connect(graph_edit.add_node)
	add_child(popup_add_node)

func show_add_node_popup() -> void:
	popup_add_node.position = DisplayServer.window_get_position() + DisplayServer.window_get_size() / 2 - popup_add_node.size / 2
	popup_add_node.show()
	popup_add_node.focus_filter()

func _process(_delta: float) -> void:
	btn_menu_nodes.button_pressed = nodes.visible
	btn_menu_obs.button_pressed = obs.visible
