extends Window
class_name HWindow

@onready var fireworks: HFireworksParticles = %Fireworks
@onready var canvas: Control = %canvas
@onready var confettis: HConfettisParticles = %Confettis

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
	# Progress bar
	for id in progress_bars:
		var pb = progress_bars[id]
		if not pb.visible: continue
		draw_progress_bar(pb)
	
	for id in images:
		var img = images[id]
		if not img.visible: continue
		if not img.texture: continue
		canvas.draw_texture(img.texture, img.position)

func draw_progress_bar(pb):
	var sb = StyleBoxFlat.new()
	sb.bg_color = pb.bg_color
	sb.border_color = pb.border_color
	sb.set_border_width_all(pb.border_width)
	sb.set_corner_radius_all(pb.radius)
	canvas.draw_style_box(sb, Rect2(pb.x, pb.y, pb.width, pb.height))
	
	sb.bg_color = pb.color
	sb.set_border_width_all(0)
	sb.set_corner_radius_all(pb.radius - pb.border_width)
	canvas.draw_style_box(sb, 
		Rect2(pb.x + pb.border_width, pb.y + pb.border_width,
		(pb.width - 2 * pb.border_width) * pb.value, pb.height - 2 * pb.border_width))
	
	sb.set_border_width_all(pb.border_width)
	sb.set_corner_radius_all(pb.radius)
	sb.draw_center = false
	canvas.draw_style_box(sb, Rect2(pb.x, pb.y, pb.width, pb.height))
