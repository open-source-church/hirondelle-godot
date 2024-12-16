extends HBaseNode

static var _title = "Time interval"
static var _type = "core/time_interval"
static var _category = "Time"
static var _icon = "time"

var timer : Timer


var start := HPortFlow.new(E.Side.INPUT)
var stop := HPortFlow.new(E.Side.INPUT)
var ping := HPortFlow.new(E.Side.OUTPUT)
var time := HPortIntSpin.new(E.Side.INPUT, {
	"default": 1000, 
	"description": "Time in milisecond"
})
var active := HPortBool.new(E.Side.BOTH, { "default": false })

func _init() -> void:
	title = _title
	type = _type
	
	timer = Timer.new()
	add_child(timer, false, Node.INTERNAL_MODE_BACK)
	timer.one_shot = false
	timer.timeout.connect(ping.emit)

func run(_port : HBasePort) -> void:
	if _port == start:
		timer.start(time.value / 1000.0)
		active.value = true

	if _port == stop:
		timer.stop()
		active.value = false

func update(_last_changed: HBasePort = null) -> void:
	if _last_changed == active:
		if active.value: timer.start(time.value / 1000.0)
		else: timer.stop()
