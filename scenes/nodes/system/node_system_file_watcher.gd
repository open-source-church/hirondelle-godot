extends HBaseNode

static var _title = "File watcher"
static var _type = "system/file_watcher"
static var _category = "System"
static var _icon = "file"
static var _description = "Notify when a file is modified."

## Interval to check, in seconds
var interval := 0.3


var start := HPortFlow.new(E.Side.INPUT)
var pause := HPortFlow.new(E.Side.INPUT)
var path := HPortPath.new(E.Side.INPUT, { "params": { "file_mode": FileDialog.FILE_MODE_OPEN_FILE }})
var watching := HPortBool.new(E.Side.INPUT)
var created := HPortFlow.new(E.Side.OUTPUT)
var modified := HPortFlow.new(E.Side.OUTPUT)
var deleted := HPortFlow.new(E.Side.OUTPUT)

func _init() -> void:
	title = _title
	type = _type
	

func run(_port : HBasePort) -> void:
	if _port == start:
		set_process(true)
		watching.value = true
		show_success("Watcher started", 5)
	if _port == pause:
		set_process(false)
		watching.value = false
		show_success("Watcher paused", 5)

func update(_last_changed: HBasePort = null) -> void:
	if _last_changed == watching:
		if watching.value:
			run(start)
		else:
			run(pause)

var _last_check: float
var _last_modified:int = -1
func _process(delta: float) -> void:
	
	if not path.value:
		show_warning("Provide a path", 5)
		watching.value = false
		set_process(false)
		return
	
	if _last_check > interval:
		var _mod_time = FileAccess.get_modified_time(path.value)
		if _last_modified == -1:
			# First run, do nothing
			pass
		if _mod_time and _last_modified == 0:
			created.emit()
		elif _mod_time > _last_modified:
			modified.emit()
		elif not _mod_time and _last_modified > 0:
			deleted.emit()
		_last_check = 0
		_last_modified = _mod_time
	else:
		_last_check += delta
