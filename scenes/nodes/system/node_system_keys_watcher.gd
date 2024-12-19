extends HBaseNode

static var _title = "Keys pressed watcher"
static var _type = "system/keys_pressed"
static var _category = "System"
static var _icon = "keyboard"
static var _description = "Notify when keys are pressed."

# Ports
var restart := HPortFlow.new(E.Side.INPUT, { "description": "Restarts keylogger if unresponsive. Should not happend, in an ideal world."})
var pressed := HPortFlow.new(E.Side.OUTPUT)
var keys := HPortText.new(E.Side.INPUT)
var now := HPortText.new(E.Side.OUTPUT)

func _init() -> void:
	title = _title
	type = _type
	
	HGlobalKeyLogger.key_received.connect(_key_received)
	HGlobalKeyLogger.start()

func run(_port: HBasePort) -> void:
	if _port == restart:
		HGlobalKeyLogger.restart()

func _key_received(key_comb: String) -> void:
	
	now.value = key_comb
	if key_comb == keys.value:
		pressed.emit()
