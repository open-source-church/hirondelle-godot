extends HBaseNode

static var _title = "Image"
static var _type = "window/image"
static var _category = "Window"
static var _icon = "image"

var ID : int


var show_ := HPortFlow.new(E.Side.INPUT)
var hide_ := HPortFlow.new(E.Side.INPUT)
var image := HPortImage.new(E.Side.INPUT)
var pos := HPortVec2.new(E.Side.INPUT)
var size_ := HPortVec2.new(E.Side.INPUT)
var visible_ := HPortBool.new(E.Side.BOTH)

func _init() -> void:
	title = _title
	type = _type
	
	ID = randi()

func run(_port : HBasePort) -> void:
	if _port == show_:
		visible_.value = true

	if _port == hide_:
		visible_.value = false

func update(_last_changed: HBasePort = null) -> void:
	update_image()

func update_image() -> void:
	var _size = size_.value
	#var texture = preview.texture
	var img = image.value
	var texture
	if img:
		#var img = texture.get_image()
		if _size:
			img.resize(_size.x, _size.y)
		texture = ImageTexture.create_from_image(img)
	
	var opt = {
		"position": pos.value,
		"size": size_.value,
		"width": size_.value.x,
		"height": size_.value.y,
		"texture": texture,
		"visible": visible_.value
	}
	G.window.images[ID] = opt
	G.window.canvas_redraw()

func _exit_tree() -> void:
	G.window.images.erase(ID)
	G.window.canvas_redraw()
