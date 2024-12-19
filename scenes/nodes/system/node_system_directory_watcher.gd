extends HBaseNode

static var _title = "Directory watcher"
static var _type = "system/directory_watcher"
static var _category = "System"
static var _icon = "folder"
static var _description = "Notify when files in a directory are created, modified or deleted. Ignores folders, and files in sub-folders."

var watcher: DirectoryWatcher
var _watching_dir: String


var start := HPortFlow.new(E.Side.INPUT)
var pause := HPortFlow.new(E.Side.INPUT)
var path := HPortPath.new(E.Side.INPUT, { "params": { "file_mode": FileDialog.FILE_MODE_OPEN_DIR }})
var watching := HPortBool.new(E.Side.INPUT)
var created := HPortFlow.new(E.Side.OUTPUT)
var modified := HPortFlow.new(E.Side.OUTPUT)
var deleted := HPortFlow.new(E.Side.OUTPUT)
var file_created := HPortArray.new(E.Side.OUTPUT, { "type": E.CONNECTION_TYPES.VARIANT_ARRAY })
var file_modified := HPortArray.new(E.Side.OUTPUT, { "type": E.CONNECTION_TYPES.VARIANT_ARRAY })
var file_deleted := HPortArray.new(E.Side.OUTPUT, { "type": E.CONNECTION_TYPES.VARIANT_ARRAY })

func _init() -> void:
	title = _title
	type = _type
	
	watcher = DirectoryWatcher.new()
	add_child(watcher, false, Node.INTERNAL_MODE_BACK)
	await watcher.ready
	watcher.set_process(false)
	watcher.files_created.connect(_on_files_created)
	watcher.files_deleted.connect(_on_files_deleted)
	watcher.files_modified.connect(_on_files_modified)
	watcher.scan_delay = 0.5

func run(_port : HBasePort) -> void:
	if _port == start:
		var _path = path.value
		if not _path:
			show_warning("Enter a path.", 5)
			watching.value = false
			return
		if not DirAccess.dir_exists_absolute(_path):
			show_error("Path does not exists.", 5)
			watching.value = false
			return
		if _watching_dir:
			watcher._directory_list = {}
		watcher.add_scan_directory(_path)
		watcher.set_process(true)
		watching.value = true
		_watching_dir = _path
		show_success("Watcher started", 5)
	if _port == pause:
		watcher.set_process(false)
		watching.value = false
		show_success("Watcher paused.", 5)

func update(_last_changed: HBasePort = null) -> void:
	if _last_changed == path:
		start.run()
	if _last_changed == watching:
		if watching.value:
			run(start)
		else:
			run(pause)

func _on_files_created(files: PackedStringArray) -> void:
	file_created.value = Array(files)
	created.emit()

func _on_files_deleted(files: PackedStringArray) -> void:
	file_deleted.value = Array(files)
	deleted.emit()

func _on_files_modified(files: PackedStringArray) -> void:
	file_modified.value = Array(files)
	modified.emit()
