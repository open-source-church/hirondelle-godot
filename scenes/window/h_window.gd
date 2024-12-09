extends Window
class_name HWindow

@onready var fireworks: Node2D = %Fireworks
@onready var canvas: Control = %canvas

var progress_bars := {}
var images := {}

func _ready() -> void:
	G.window = self
	
	size_changed.connect(on_size_changed)
	canvas.draw.connect(on_canvas_draw)
	close_requested.connect(hide)

func canvas_redraw():
	canvas.queue_redraw()

func on_size_changed():
	fireworks.scale = Vector2(size.x / 1280.0, size.y / 720.0)

func on_canvas_draw() -> void:
	for id in progress_bars:
		var pb = progress_bars[id]
		if not pb.visible: continue
		canvas.draw_rect(Rect2(pb.x, pb.y, pb.width, pb.height), Color(pb.bg_color), true)
		canvas.draw_rect(Rect2(pb.x, pb.y, pb.width * pb.value, pb.height), Color(pb.color), true)
	
	for id in images:
		var img = images[id]
		if not img.visible: continue
		canvas.draw_texture(img.texture, img.position)
		#canvas.draw_texture_rect(img.texture, Rect2(img.position, img.size), false)
