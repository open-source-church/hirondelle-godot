extends HBaseNode

static var _title = "File watcher"
static var _type = "system/file_watcher"
static var _category = "System"
static var _icon = "eye"
static var _description = "Notify when a file is modified."

## Interval to check, in seconds
var interval := 0.3

func _init() -> void:
	title = _title
	type = _type
	PORTS = {
		"start": HPortFlow.new(E.Side.INPUT),
		"pause": HPortFlow.new(E.Side.INPUT),
		"path": HPortPath.new(E.Side.INPUT, { "params": { "file_mode": FileDialog.FILE_MODE_OPEN_FILE }}),
		"watching": HPortBool.new(E.Side.INPUT),
		"created": HPortFlow.new(E.Side.OUTPUT),
		"modified": HPortFlow.new(E.Side.OUTPUT),
		"deleted": HPortFlow.new(E.Side.OUTPUT),
	}

func run(routine:String):
	if routine == "start":
		set_process(true)
		PORTS.watching.value = true
		show_success("Watcher started", 5)
	if routine == "pause":
		set_process(false)
		PORTS.watching.value = false
		show_success("Watcher paused", 5)

func update(_last_changed := "") -> void:
	if _last_changed == "watching":
		if PORTS.watching.value:
			run("start")
		else:
			run("pause")

var _last_check: float
var _last_modified:int = -1
func _process(delta: float) -> void:
	
	if not PORTS.path.value:
		show_warning("Provide a path", 5)
		PORTS.watching.value = false
		set_process(false)
		return
	
	if _last_check > interval:
		var modified = FileAccess.get_modified_time(PORTS.path.value)
		if _last_modified == -1:
			# First run, do nothing
			pass
		if modified and _last_modified == 0:
			emit("created")
		elif modified > _last_modified:
			emit("modified")
		elif not modified and _last_modified > 0:
			emit("deleted")
		_last_check = 0
		_last_modified = modified
	else:
		_last_check += delta
