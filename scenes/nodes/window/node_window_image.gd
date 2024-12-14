extends HBaseNode

static var _title = "Image"
static var _type = "window/image"
static var _category = "Window"
static var _icon = "image"

var ID : int

func _init() -> void:
	title = _title
	type = _type
	PORTS = {
		"show": HPortFlow.new(E.Side.INPUT),
		"hide": HPortFlow.new(E.Side.INPUT),
		"image": HPortImage.new(E.Side.INPUT),
		"pos": HPortVec2.new(E.Side.INPUT),
		"size": HPortVec2.new(E.Side.INPUT),
		"visible": HPortBool.new(E.Side.BOTH),
	}
	ID = randi()

func run(routine:String):
	if routine == "show":
		PORTS.visible.value = true

	if routine == "hide":
		PORTS.visible.value = false

func update(_last_changed: = "") -> void:
	update_image()

func update_image() -> void:
	var _size = PORTS.size.value
	#var texture = preview.texture
	var img = PORTS.image.value
	var texture
	if img:
		#var img = texture.get_image()
		if _size:
			img.resize(_size.x, _size.y)
		texture = ImageTexture.create_from_image(img)
	
	var opt = {
		"position": PORTS.pos.value,
		"size": PORTS.size.value,
		"width": PORTS.size.value.x,
		"height": PORTS.size.value.y,
		"texture": texture,
		"visible": PORTS.visible.value
	}
	G.window.images[ID] = opt
	G.window.canvas_redraw()

func _exit_tree() -> void:
	G.window.images.erase(ID)
	G.window.canvas_redraw()
