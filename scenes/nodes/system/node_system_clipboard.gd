extends HBaseNode

## A node to use clipboard.
## Monitoring when clipboard has images is quite slow, so the interval is a bit low (twice per second)

static var _title = "Clipboard management"
static var _type = "system/clipboard"
static var _category = "System"
static var _icon = "clipboard"
static var _description = "Read and write to/from the clipboard"

# Ports
var get_ := HPortFlow.new(E.Side.INPUT)
var set_ := HPortFlow.new(E.Side.INPUT, { "description": "Works only for text, for now (limitation in Godot)."})
var changed := HPortFlow.new(E.Side.OUTPUT)
var monitor := HPortBool.new(E.Side.INPUT, { "default": false, "description": "Caution: monitor is a bit slow when there are images in the clipboard." })
var text := HPortText.new(E.Side.BOTH)
var image := HPortImage.new(E.Side.OUTPUT)

static var MONITOR_IMAGE_INTERVAL_S := 0.5
const MONITOR_INTERVAL_S := 0.1

func _init() -> void:
	title = _title
	type = _type
	

func run(_port: HBasePort) -> void:
	if _port == get_:
		if DisplayServer.clipboard_has_image():
			image.value = DisplayServer.clipboard_get_image()
			text.value = ""
		else:
			image.value = null
			text.value = DisplayServer.clipboard_get()
	if _port == set_:
		DisplayServer.clipboard_set(text.value)

func update(_last_changed: HBasePort = null) -> void:
	if _last_changed == monitor:
		set_process(monitor.value)
		changed.collapsed = not monitor.value
		update_slots()

var _next_check_in := 0.0
func _process(_delta: float) -> void:
	if _next_check_in > 0:
		_next_check_in -= _delta
		return
	
	if DisplayServer.clipboard_has_image():
		if has_clipboard_image_changed(image.value):
			image.value = _last_image
			text.value = ""
			changed.emit()
	else:
		var _text := DisplayServer.clipboard_get()
		if _text != text.value:
			text.value = _text
			image.value = null
			changed.emit()
	
	_next_check_in = MONITOR_INTERVAL_S


static var _last_check: int
static var _last_image: Image
static var _last_text: String
## Check if clipboard image has changed. In a static place because clipboard
## is the same for all nodes, and clipboard_get_image() is a bit costly.
static func has_clipboard_image_changed(_content: Image) -> bool:
	if Time.get_ticks_msec() - _last_check > MONITOR_IMAGE_INTERVAL_S * 1000:
		_last_image = DisplayServer.clipboard_get_image()
		_last_check = Time.get_ticks_msec()
	if not are_images_equal(_content, _last_image):
		return true
	return false

## Function to guess if two images are equal, in a fast and imprecise way.
static func are_images_equal(img1: Image, img2: Image) -> bool:
	if not img1 or not img2: return false
	if img1.get_format() != img2.get_format(): return false
	if img1.get_data_size() != img2.get_data_size(): return false
	if img1.get_size() != img2.get_size(): return false
	# compares 10 random pixels
	for i in range(10):
		var p = Vector2i(randi() % img1.get_width(), randi() % img1.get_height())
		if img1.get_pixelv(p) != img2.get_pixelv(p): return false
	return true
