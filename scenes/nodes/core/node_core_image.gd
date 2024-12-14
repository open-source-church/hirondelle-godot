extends HBaseNode

static var _title = "Image tools"
static var _type = "core/image_tools"
static var _category = "Core"
static var _icon = "image"

var ID : int
#var preview : TextureRect
var downloader : HDownloader

func _init() -> void:
	title = _title
	type = _type
	PORTS = {
		"operator": HPortText.new(E.Side.NONE, {
			"options": ["Local", "Download", "Resize", "Crop", "Flip", "Rotate"],
		}),
		# Local
		"file": HPortText.new(E.Side.INPUT),
		# Download
		"url": HPortText.new(E.Side.INPUT),
		# Input image
		"image": HPortImage.new(E.Side.INPUT),
		# Resize
		"mode": HPortText.new(E.Side.INPUT, {
			"options": ["Cover", "Contain", "Stretch", "Repeat"],
		}),
		"h_align": HPortText.new(E.Side.INPUT, {
			"options": ["Left", "Center", "Right"],
			"default": "Center"
		}),
		"v_align": HPortText.new(E.Side.INPUT, {
			"options": ["Top", "Middle", "Bottom"],
			"default": "Middle"
		}),
		"size": HPortVec2.new(E.Side.INPUT),
		# Crop
		"pos": HPortVec2.new(E.Side.INPUT),
		# Flip
		"h_flip": HPortBool.new(E.Side.INPUT),
		"v_flip": HPortBool.new(E.Side.INPUT),
		# Rotate
		"rotate": HPortText.new(E.Side.INPUT, {
			"options": ["90", "180", "270"]
		}),
		# Output
		"o_image": HPortImage.new(E.Side.OUTPUT),
		"o_size": HPortVec2.new(E.Side.OUTPUT),
	}
	ID = randi()
	
	downloader = HDownloader.new()
	add_child(downloader, false, Node.INTERNAL_MODE_FRONT)

func download_image():
	var r
	if PORTS.url.value:
		show_error("")
		show_warning("Updating image...")
		r = await downloader.get_url(PORTS.url.value)
	if r is Image:
		show_warning("")
		update_image(r)
	else:
		show_warning("")
		show_error("Invalid...", 5)
		update_image(null)

func update(_last_changed := "") -> void:
	var operator = PORTS.operator.value
	var mode = PORTS.mode.value
	if _last_changed in ["operator", "", "mode"]:
		PORTS.file.collapsed = not operator == "Local"
		PORTS.url.collapsed = not operator == "Download"
		PORTS.image.collapsed = not operator in ["Resize", "Crop", "Flip", "Rotate"]
		PORTS.mode.collapsed = not operator == "Resize"
		PORTS.h_align.collapsed = not operator == "Resize" and mode == "Cover"
		PORTS.v_align.collapsed = not operator == "Resize" and mode == "Cover"
		PORTS.size.collapsed = not operator in ["Resize", "Crop"]
		PORTS.pos.collapsed = not operator == "Crop"
		PORTS.h_flip.collapsed = not operator == "Flip"
		PORTS.v_flip.collapsed = not operator == "Flip"
		PORTS.rotate.collapsed = not operator == "Rotate"
		update_slots()
	
	if _last_changed in ["url", "operator"] and operator == "Download":
		download_image()
	
	if operator == "Local":
		show_warning("Not implemented yet...")
	else:
		show_warning("")
	
	if operator in ["Resize", "Crop", "Flip", "Rotate"]:
		resize_image()

func update_image(img: Image = null) -> void:
	if img:
		print("New image: ", img.get_size())
		PORTS.o_image.value = img
		PORTS.o_size.value = img.get_size()
	else:
		PORTS.o_image.value = null
		PORTS.o_size.value = Vector2.INF
	reset_size()

func resize_image() -> void:
	print("Resize")
	var img = PORTS.image.value as Image
	if not img:
		show_warning("Please attach an image", 5)
		update_image()
		return
	
	var _img: Image = img.duplicate()
	var mode = PORTS.mode.value
	var operator = PORTS.operator.value
	var img_size = _img.get_size()
	var _size = PORTS.size.value
	var fit_width = Vector2i(_size.x, _size.x * img_size.y / img_size.x)
	var fit_height = Vector2i(_size.y * img_size.x / img_size.y, _size.y)
	var h_align = PORTS.h_align.value
	var v_align = PORTS.v_align.value
	
	if operator == "Resize" and mode == "Stretch":
		_img.resize(_size.x, _size.y)
	elif operator == "Resize" and mode == "Contain":
		if fit_width.y > _size.y:
			_img.resize(fit_height.x, fit_height.y)
		else:
			_img.resize(fit_width.x, fit_width.y)
	elif operator == "Resize" and mode == "Cover":
		if fit_width.y > _size.y:
			_img.resize(fit_width.x, fit_width.y)
		else:
			_img.resize(fit_height.x, fit_height.y)
		img_size = _img.get_size()
		var region = Rect2i()
		region.size = Vector2i(_size)
		var x: int = 0 if h_align == "Left" else img_size.x - _size.x if h_align == "Right" else (img_size.x - _size.x) / 2
		var y: int = 0 if v_align == "Top" else img_size.y - _size.y if v_align == "Bottom" else (img_size.y - _size.y) / 2
		region.position = Vector2i(x, y)
		_img = _img.get_region(region)
	elif operator == "Resize" and mode == "Repeat":
		var img2 = Image.create_empty(_size.x, _size.y, true, Image.FORMAT_RGBA8)
		for x in range(_size.x):
			for y in range(_size.y):
				img2.set_pixel(x, y, _img.get_pixel(x % img_size.x, y % img_size.y))
		_img = img2
	
	if operator == "Crop":
		var pos = PORTS.pos.value
		var region = Rect2(pos, _size)
		_img = _img.get_region(region)
	
	if operator == "Flip":
		if PORTS.h_flip.value:
			_img.flip_x()
		if PORTS.v_flip.value:
			_img.flip_y()
	
	if operator == "Rotate":
		var d = PORTS.rotate.value
		print(d)
		if d == "90":
			_img.rotate_90(CLOCKWISE)
		if d == "180":
			_img.rotate_180()
		if d == "270":
			_img.rotate_90(COUNTERCLOCKWISE)
	
	update_image(_img)
	
	
