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
		"start": HPortFlow.new({
			"type": E.CONNECTION_TYPES.FLOW, 
			"side": INPUT,
			"description": "Starts the timer."
		}),
		"stop": HPortFlow.new({
			"type": E.CONNECTION_TYPES.FLOW, 
			"side": INPUT
		}),
		"started": HPortFlow.new({
			"type": E.CONNECTION_TYPES.FLOW, 
			"side": OUTPUT
		}),
		"finished": HPortFlow.new({
			"type": E.CONNECTION_TYPES.FLOW, 
			"side": OUTPUT
		}),
		"time": HPortIntSpin.new({
			"type": E.CONNECTION_TYPES.INT,
			"default": 1000, 
			"side": INPUT, 
			"description": "Time in milisecond"
		}),
		"elapsed": HPortIntSlider.new({
			"type": E.CONNECTION_TYPES.INT, 
			"side": OUTPUT,
			"params": { "min": 0, "max": 1000 }
		}),
		"running": HPortBool.new({
			"type": E.CONNECTION_TYPES.BOOL, 
			"side": OUTPUT
		})
	}
	timer = Timer.new()
	add_child(timer)
	timer.one_shot = true
	timer.timeout.connect(emit.bind("finished"))

func run(routine:String):
	if routine == "start":
		timer.start(PORTS.time.value / 1000.0)
		emit("started")

	if routine == "stop":
		timer.stop()

func update() -> void:
	PORTS.elapsed.params = { "min": 0, "max": PORTS.time.value }

func _process(_delta: float) -> void:
	PORTS.elapsed.value = int(PORTS.time.value - timer.time_left * 1000)
	PORTS.running.value = not timer.is_stopped()
