extends HBaseNode

static var _title = "Wait..."
static var _type = "core/time_wait"

var timer : Timer

func _init() -> void:
	title = _title
	type = _type
	COMPONENTS = {
		"start": Port.new({
			"type": G.graph.TYPES.FLOW, 
			"side": INPUT
		}),
		"stop": Port.new({
			"type": G.graph.TYPES.FLOW, 
			"side": INPUT
		}),
		"started": Port.new({
			"type": G.graph.TYPES.FLOW, 
			"side": OUTPUT
		}),
		"finished": Port.new({
			"type": G.graph.TYPES.FLOW, 
			"side": OUTPUT
		}),
		"time": Port.new({
			"type": G.graph.TYPES.INT,
			"default": 1000, 
			"side": INPUT, 
			"description": "Time in milisecond"
		}),
		"elapsed": Port.new({
			"type": G.graph.TYPES.INT, 
			"side": OUTPUT
		}),
		"running": Port.new({
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
	pass

func _process(delta: float) -> void:
	VALS.elapsed.value = int(VALS.time.value - timer.time_left * 1000)
	VALS.running.value = not timer.is_stopped()
