extends HBaseNode

static var _title = "Wait..."
static var _type = "core/time_wait"

var timer : Timer

func _init() -> void:
	title = _title
	type = _type
	VALS = {
		"start": HPortFlow.new({
			"type": G.graph.TYPES.FLOW, 
			"side": INPUT,
			"description": "Starts the timer."
		}),
		"stop": HPortFlow.new({
			"type": G.graph.TYPES.FLOW, 
			"side": INPUT
		}),
		"started": HPortFlow.new({
			"type": G.graph.TYPES.FLOW, 
			"side": OUTPUT
		}),
		"finished": HPortFlow.new({
			"type": G.graph.TYPES.FLOW, 
			"side": OUTPUT
		}),
		"time": HPortIntSpin.new({
			"type": G.graph.TYPES.INT,
			"default": 1000, 
			"side": INPUT, 
			"description": "Time in milisecond"
		}),
		"elapsed": HPortIntSlider.new({
			"type": G.graph.TYPES.INT, 
			"side": OUTPUT,
			"params": { "min": 0, "max": 1000 }
		}),
		"running": HPortBool.new({
			"type": G.graph.TYPES.BOOL, 
			"side": OUTPUT
		})
	}
	timer = Timer.new()
	add_child(timer)
	timer.one_shot = true
	timer.timeout.connect(emit.bind("finished"))

func run(routine:String):
	if routine == "start":
		timer.start(VALS.time.value / 1000.0)
		emit("started")

	if routine == "stop":
		timer.stop()

func update() -> void:
	VALS.elapsed.params = { "min": 0, "max": VALS.time.value }

func _process(_delta: float) -> void:
	VALS.elapsed.value = int(VALS.time.value - timer.time_left * 1000)
	VALS.running.value = not timer.is_stopped()
