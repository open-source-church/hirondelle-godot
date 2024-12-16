extends HBaseNode

static var _title = "Image tools"
static var _type = "core/image_tools"
static var _category = "Core"
static var _icon = "image"

var ID : int
#var preview : TextureRect
var downloader : HDownloader


var operator := HPortText.new(E.Side.NONE, {
	"options": ["Local", "Download", "Resize", "Crop", "Flip", "Rotate"],
})
# Local
var file := HPortPath.new(E.Side.INPUT, { "params": { 
	"filters": ["*.jpg,*.jpeg,*.png,*.webp,*.svg,*.bmp;Images"]
	}})
# Download
var url := HPortText.new(E.Side.INPUT)
# Input image
var image := HPortImage.new(E.Side.INPUT)
# Resize
var mode := HPortText.new(E.Side.INPUT, {
	"options": ["Cover", "Contain", "Stretch", "Repeat"],
})
var h_align := HPortText.new(E.Side.INPUT, {
	"options": ["Left", "Center", "Right"],
	"default": "Center"
})
var v_align := HPortText.new(E.Side.INPUT, {
	"options": ["Top", "Middle", "Bottom"],
	"default": "Middle"
})
var size_ := HPortVec2.new(E.Side.INPUT)
# Crop
var pos := HPortVec2.new(E.Side.INPUT)
# Flip
var h_flip := HPortBool.new(E.Side.INPUT)
var v_flip := HPortBool.new(E.Side.INPUT)
# Rotate
var rotate := HPortText.new(E.Side.INPUT, {
	"options": ["90", "180", "270"]
})
# Output
var o_image := HPortImage.new(E.Side.OUTPUT)
var o_size := HPortVec2.new(E.Side.OUTPUT)

func _init() -> void:
	title = _title
	type = _type
	
	ID = randi()
	
	downloader = HDownloader.new()
	add_child(downloader, false, Node.INTERNAL_MODE_FRONT)

func download_image():
	var r
	if url.value:
		show_error("")
		show_warning("Updating image...")
		r = await downloader.get_url(url.value)
	if r is Image:
		show_warning("")
		update_image(r)
	else:
		show_warning("")
		show_error("Invalid...", 5)
		update_image(null)

func open_image():
	print("Trying to open: ", file.value)
	var img = Image.load_from_file(file.value)
	if not img:
		show_error("File can't be openend :(", 5)
		update_image(null)
		return
	show_error("")
	update_image(img)

func update(_last_changed: HBasePort = null) -> void:
	
	if _last_changed in [operator, null, mode]:
		file.collapsed = not operator.value == "Local"
		url.collapsed = not operator.value == "Download"
		image.collapsed = not operator.value in ["Resize", "Crop", "Flip", "Rotate"]
		mode.collapsed = not operator.value == "Resize"
		h_align.collapsed = not operator.value == "Resize" and mode.value == "Cover"
		v_align.collapsed = not operator.value == "Resize" and mode.value == "Cover"
		size_.collapsed = not operator.value in ["Resize", "Crop"]
		pos.collapsed = not operator.value == "Crop"
		h_flip.collapsed = not operator.value == "Flip"
		v_flip.collapsed = not operator.value == "Flip"
		rotate.collapsed = not operator.value == "Rotate"
		update_slots()
	
	if _last_changed in [url, operator] and operator.value == "Download":
		download_image()
	
	if _last_changed in [file, operator] and operator.value == "Local":
		open_image()
	
	if operator.value in ["Resize", "Crop", "Flip", "Rotate"]:
		resize_image()

func update_image(img: Image = null) -> void:
	if img:
		o_image.value = img
		o_size.value = img.get_size()
	else:
		o_image.value = null
		o_size.value = Vector2.INF
	reset_size()

func resize_image() -> void:
	var img = image.value as Image
	if not img:
		show_warning("Please attach an image", 5)
		update_image()
		return
	
	var _img: Image = img.duplicate()
	
	var img_size = _img.get_size()
	var _size = size_.value
	var fit_width = Vector2i(_size.x, _size.x * img_size.y / img_size.x)
	var fit_height = Vector2i(_size.y * img_size.x / img_size.y, _size.y)
	
	if operator.value == "Resize" and mode.value == "Stretch":
		_img.resize(_size.x, _size.y)
	elif operator.value == "Resize" and mode.value == "Contain":
		if fit_width.y > _size.y:
			_img.resize(fit_height.x, fit_height.y)
		else:
			_img.resize(fit_width.x, fit_width.y)
	elif operator.value == "Resize" and mode.value == "Cover":
		if fit_width.y > _size.y:
			_img.resize(fit_width.x, fit_width.y)
		else:
			_img.resize(fit_height.x, fit_height.y)
		img_size = _img.get_size()
		var region = Rect2i()
		region.size = Vector2i(_size)
		var x: int = 0 if h_align.value == "Left" else img_size.x - _size.x if h_align.value == "Right" else (img_size.x - _size.x) / 2
		var y: int = 0 if v_align.value == "Top" else img_size.y - _size.y if v_align.value == "Bottom" else (img_size.y - _size.y) / 2
		region.position = Vector2i(x, y)
		_img = _img.get_region(region)
	elif operator.value == "Resize" and mode.value == "Repeat":
		var img2 = Image.create_empty(_size.x, _size.y, true, Image.FORMAT_RGBA8)
		for x in range(_size.x):
			for y in range(_size.y):
				img2.set_pixel(x, y, _img.get_pixel(x % img_size.x, y % img_size.y))
		_img = img2
	
	if operator.value == "Crop":
		var _pos = pos.value
		var region = Rect2(_pos, _size)
		_img = _img.get_region(region)
	
	if operator.value == "Flip":
		if h_flip.value:
			_img.flip_x()
		if v_flip.value:
			_img.flip_y()
	
	if operator.value == "Rotate":
		var d = rotate.value
		print(d)
		if d == "90":
			_img.rotate_90(CLOCKWISE)
		if d == "180":
			_img.rotate_180()
		if d == "270":
			_img.rotate_90(COUNTERCLOCKWISE)
	
	update_image(_img)
	
	
