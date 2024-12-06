extends HBaseNode

static var _title = "Time interval"
static var _type = "core/time_interval"
static var _category = "Time"
static var _icon = "time"

var timer : Timer

func _init() -> void:
	title = _title
	type = _type
	VALS = {
		"start": HPortFlow.new({
			"type": G.graph.TYPES.FLOW, 
			"side": INPUT
		}),
		"stop": HPortFlow.new({
			"type": G.graph.TYPES.FLOW, 
			"side": INPUT
		}),
		"ping": HPortFlow.new({
			"type": G.graph.TYPES.FLOW, 
			"side": OUTPUT
		}),
		"time": HPortIntSpin.new({
			"type": G.graph.TYPES.INT,
			"default": 1000, 
			"side": INPUT, 
			"description": "Time in milisecond"
		}),
		"active": HPortBool.new({
			"type": G.graph.TYPES.BOOL, 
			"side": BOTH,
			"default": false
		}),
	}
	timer = Timer.new()
	add_child(timer)
	timer.one_shot = false
	timer.timeout.connect(emit.bind("ping"))

func run(routine:String):
	if routine == "start":
		timer.start(VALS.time.value / 1000.0)
		VALS.active.value = true

	if routine == "stop":
		timer.stop()
		VALS.active.value = false

func update() -> void:
	print(_last_port_changed)
	if _last_port_changed == "active":
		if VALS.active.value: timer.start(VALS.time.value / 1000.0)
		else: timer.stop()
