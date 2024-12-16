extends HBaseNode

static var _title = "Wait..."
static var _type = "core/time_wait"
static var _category = "Time"
static var _icon = "hourglass"

var timer : Timer


var start := HPortFlow.new(E.Side.INPUT, {
	"description": "Starts the timer."
})
var stop := HPortFlow.new(E.Side.INPUT)
var started := HPortFlow.new(E.Side.OUTPUT)
var finished := HPortFlow.new(E.Side.OUTPUT)
var time := HPortIntSpin.new(E.Side.INPUT, {
	"default": 1000, 
	"description": "Time in milisecond"
})
var elapsed := HPortIntSlider.new(E.Side.OUTPUT, {
	"params": { "min": 0, "max": 1000 }
})
var running := HPortBool.new(E.Side.OUTPUT)

func _init() -> void:
	title = _title
	type = _type
	
	timer = Timer.new()
	add_child(timer, false, Node.INTERNAL_MODE_BACK)
	timer.one_shot = true
	timer.timeout.connect(finished.emit)

func run(_port : HBasePort) -> void:
	if _port == start:
		timer.start(time.value / 1000.0)
		started.emit()

	if _port == stop:
		timer.stop()

func update(_last_changed: HBasePort = null) -> void:
	elapsed.params = { "min": 0, "max": time.value }

func _process(_delta: float) -> void:
	elapsed.value = int(time.value - timer.time_left * 1000)
	running.value = not timer.is_stopped()
