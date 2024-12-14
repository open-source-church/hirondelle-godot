extends HBaseNode

static var _title = "Fireworks"
static var _type = "window/fireworks"
static var _category = "Window"
static var _icon = "fireworks"

var ID : int

func _init() -> void:
	title = _title
	type = _type
	PORTS = {
		"start": HPortFlow.new(E.Side.INPUT),
		"stop": HPortFlow.new(E.Side.INPUT),
		"one_shot": HPortBool.new(E.Side.INPUT, { "default": true }),
		"number": HPortIntSpin.new(E.Side.INPUT, { "default": 25 }),
		"color": HPortColor.new(E.Side.INPUT, { "default": Color.ORANGE_RED }),
		"color_variation": HPortRatioSlider.new(E.Side.INPUT, { "default": 0.3 }),
		"active": HPortBool.new(E.Side.BOTH),
	}
	G.window.fireworks.trails.finished.connect(func (): PORTS.active.value = false)

func run(routine:String):
	if routine == "start":
		PORTS.active.value = true

	if routine == "stop":
		PORTS.active.value = false

func update(_last_changed: = "") -> void:
	G.window.fireworks.trails.one_shot = PORTS.one_shot.value
	G.window.fireworks.trails.amount = PORTS.number.value
	var p: ParticleProcessMaterial = G.window.fireworks.explosion.process_material
	p.color = PORTS.color.value
	p.hue_variation_min = - PORTS.color_variation.value / 2
	p.hue_variation_max = + PORTS.color_variation.value / 2
	if _last_changed == "active":
		G.window.fireworks.emitting = PORTS.active.value
