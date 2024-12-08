extends HBaseNode

static var _title = "Time interval"
static var _type = "core/time_interval"
static var _category = "Time"
static var _icon = "time"

var timer : Timer

func _init() -> void:
	title = _title
	type = _type
	PORTS = {
		"start": HPortFlow.new({
			"type": E.CONNECTION_TYPES.FLOW, 
			"side": INPUT
		}),
		"stop": HPortFlow.new({
			"type": E.CONNECTION_TYPES.FLOW, 
			"side": INPUT
		}),
		"ping": HPortFlow.new({
			"type": E.CONNECTION_TYPES.FLOW, 
			"side": OUTPUT
		}),
		"time": HPortIntSpin.new({
			"type": E.CONNECTION_TYPES.INT,
			"default": 1000, 
			"side": INPUT, 
			"description": "Time in milisecond"
		}),
		"active": HPortBool.new({
			"type": E.CONNECTION_TYPES.BOOL, 
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
		timer.start(PORTS.time.value / 1000.0)
		PORTS.active.value = true

	if routine == "stop":
		timer.stop()
		PORTS.active.value = false

func update() -> void:
	print(_last_port_changed)
	if _last_port_changed == "active":
		if PORTS.active.value: timer.start(PORTS.time.value / 1000.0)
		else: timer.stop()
