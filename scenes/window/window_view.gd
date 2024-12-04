extends VBoxContainer

@onready var btn_open: Button = %BtnOpen
@onready var btn_close: Button = %BtnClose

@onready var h_window: HWindow = %HWindow

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	btn_open.pressed.connect(open_window)
	btn_close.pressed.connect(func (): h_window.visible = false)

func open_window():
	h_window.size = Vector2i(1280, 720)
	h_window.visible = true
	h_window.transient = false
	h_window.transparent = true
	h_window.transparent_bg = true
	
	print(h_window.position)
