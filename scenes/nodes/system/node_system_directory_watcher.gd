extends HBaseNode

static var _title = "Directory watcher"
static var _type = "system/directory_watcher"
static var _category = "System"
static var _icon = "eye"
static var _description = "Notify when files in a directory are created, modified or deleted. Ignores folders, and files in sub-folders."

var watcher: DirectoryWatcher
var _watching_dir: String

func _init() -> void:
	title = _title
	type = _type
	PORTS = {
		"start": HPortFlow.new(E.Side.INPUT),
		"pause": HPortFlow.new(E.Side.INPUT),
		"path": HPortPath.new(E.Side.INPUT, { "params": { "file_mode": FileDialog.FILE_MODE_OPEN_DIR }}),
		"watching": HPortBool.new(E.Side.INPUT),
		"created": HPortFlow.new(E.Side.OUTPUT),
		"modified": HPortFlow.new(E.Side.OUTPUT),
		"deleted": HPortFlow.new(E.Side.OUTPUT),
		"file_created": HPortArray.new(E.Side.OUTPUT, { "type": E.CONNECTION_TYPES.VARIANT_ARRAY }),
		"file_modified": HPortArray.new(E.Side.OUTPUT, { "type": E.CONNECTION_TYPES.VARIANT_ARRAY }),
		"file_deleted": HPortArray.new(E.Side.OUTPUT, { "type": E.CONNECTION_TYPES.VARIANT_ARRAY }),
	}
	watcher = DirectoryWatcher.new()
	add_child(watcher, false, Node.INTERNAL_MODE_BACK)
	await watcher.ready
	watcher.set_process(false)
	watcher.files_created.connect(_on_files_created)
	watcher.files_deleted.connect(_on_files_deleted)
	watcher.files_modified.connect(_on_files_modified)
	watcher.scan_delay = 0.5

func run(routine:String):
	if routine == "start":
		var path = PORTS.path.value
		if not path:
			show_warning("Enter a path.", 5)
			PORTS.watching.value = false
			return
		if not DirAccess.dir_exists_absolute(path):
			show_error("Path does not exists.", 5)
			PORTS.watching.value = false
			return
		if _watching_dir:
			watcher._directory_list = {}
		watcher.add_scan_directory(path)
		watcher.set_process(true)
		PORTS.watching.value = true
		_watching_dir = path
		show_success("Watcher started", 5)
	if routine == "pause":
		watcher.set_process(false)
		PORTS.watching.value = false
		show_success("Watcher paused.", 5)

func update(_last_changed := "") -> void:
	if _last_changed == "path":
		run("start")
	if _last_changed == "watching":
		if PORTS.watching.value:
			run("start")
		else:
			run("pause")

func _on_files_created(files: PackedStringArray) -> void:
	PORTS.file_created.value = Array(files)
	emit("created")

func _on_files_deleted(files: PackedStringArray) -> void:
	PORTS.file_deleted.value = Array(files)
	emit("deleted")

func _on_files_modified(files: PackedStringArray) -> void:
	PORTS.file_modified.value = Array(files)
	emit("modified")
