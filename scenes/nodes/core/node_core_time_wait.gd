extends HBaseNode

static var _title = "Wait..."
static var _type = "core/time_wait"
static var _category = "Time"
static var _icon = "hourglass"

var timer : Timer

func _init() -> void:
	title = _title
	type = _type
	PORTS = {
		"start": HPortFlow.new(E.Side.INPUT, {
			"description": "Starts the timer."
		}),
		"stop": HPortFlow.new(E.Side.INPUT),
		"started": HPortFlow.new(E.Side.OUTPUT),
		"finished": HPortFlow.new(E.Side.OUTPUT),
		"time": HPortIntSpin.new(E.Side.INPUT, {
			"default": 1000, 
			"description": "Time in milisecond"
		}),
		"elapsed": HPortIntSlider.new(E.Side.OUTPUT, {
			"params": { "min": 0, "max": 1000 }
		}),
		"running": HPortBool.new(E.Side.OUTPUT)
	}
	timer = Timer.new()
	add_child(timer, false, Node.INTERNAL_MODE_BACK)
	timer.one_shot = true
	timer.timeout.connect(emit.bind("finished"))

func run(routine:String):
	if routine == "start":
		timer.start(PORTS.time.value / 1000.0)
		emit("started")

	if routine == "stop":
		timer.stop()

func update(_last_changed := "") -> void:
	PORTS.elapsed.params = { "min": 0, "max": PORTS.time.value }

func _process(_delta: float) -> void:
	PORTS.elapsed.value = int(PORTS.time.value - timer.time_left * 1000)
	PORTS.running.value = not timer.is_stopped()
