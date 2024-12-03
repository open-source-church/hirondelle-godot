extends Control

@onready var btn_save: Button = %BtnSave
@onready var btn_load: Button = %BtnLoad
@onready var graph_edit: HGraphEdit = %GraphEdit
@onready var btn_clear: Button = %BtnClear

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	btn_save.pressed.connect(graph_edit.save)
	btn_load.pressed.connect(graph_edit.load)
	btn_clear.pressed.connect(graph_edit.clear)
	
	
