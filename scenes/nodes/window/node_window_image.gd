extends HBaseNode

static var _title = "Image"
static var _type = "window/image"
static var _category = "Window"
static var _icon = ""

var ID : int
var preview : TextureRect
var downloader : HDownloader

func _init() -> void:
	title = _title
	type = _type
	PORTS = {
		"show": HPortFlow.new(E.Side.INPUT),
		"hide": HPortFlow.new(E.Side.INPUT),
		"source": HPortText.new(E.Side.INPUT, {
			"options": ["Local", "URL"]
		}),
		"file": HPortText.new(E.Side.INPUT),
		"url": HPortText.new(E.Side.INPUT),
		"source_size": HPortVec2.new(E.Side.OUTPUT),
		"pos": HPortVec2.new(E.Side.INPUT),
		"size": HPortVec2.new(E.Side.INPUT),
		"visible": HPortBool.new(E.Side.BOTH),
	}
	ID = randi()
	
	preview = TextureRect.new()
	preview.expand_mode = TextureRect.EXPAND_FIT_HEIGHT_PROPORTIONAL
	#collapsed_changed.connect(func (v): preview.visible = not v)
	add_child(preview)
	
	downloader = HDownloader.new()

	add_child(downloader)

func run(routine:String):
	if routine == "show":
		PORTS.visible.value = true

	if routine == "hide":
		PORTS.visible.value = false

func download_image():
	var r = await downloader.get_url(PORTS.url.value)
	if r is Image:
		preview.texture = ImageTexture.create_from_image(r)
		PORTS.source_size.value = r.get_size()
	else:
		preview.texture = null
	reset_size()

func update() -> void:
	if _last_port_changed == "source":
		PORTS.file.visible = PORTS.source.value == "Local"
		PORTS.url.visible = PORTS.source.value == "URL"
		update_slots()
	
	if _last_port_changed == "url":
		download_image()
	
	update_image()

func update_image() -> void:
	var _size = PORTS.size.value
	var texture = preview.texture
	if texture:
		var img = texture.get_image()
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
