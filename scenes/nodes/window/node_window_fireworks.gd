extends HBaseNode

static var _title = "Fireworks"
static var _type = "window/fireworks"
static var _category = "Window"
static var _icon = "fireworks"

var ID : int


var start := HPortFlow.new(E.Side.INPUT)
var stop := HPortFlow.new(E.Side.INPUT)
var one_shot := HPortBool.new(E.Side.INPUT, { "default": true })
var number := HPortIntSpin.new(E.Side.INPUT, { "default": 25 })
var color := HPortColor.new(E.Side.INPUT, { "default": Color.ORANGE_RED })
var color_variation := HPortRatioSlider.new(E.Side.INPUT, { "default": 0.3 })
var active := HPortBool.new(E.Side.BOTH)

func _init() -> void:
	title = _title
	type = _type
	
	G.window.fireworks.trails.finished.connect(func (): active.value = false)

func run(_port : HBasePort) -> void:
	if _port == start:
		active.value = true

	if _port == stop:
		active.value = false

func update(_last_changed: HBasePort = null) -> void:
	G.window.fireworks.trails.one_shot = one_shot.value
	G.window.fireworks.trails.amount = number.value
	var p: ParticleProcessMaterial = G.window.fireworks.explosion.process_material
	p.color = color.value
	p.hue_variation_min = - color_variation.value / 2
	p.hue_variation_max = + color_variation.value / 2
	if _last_changed == active:
		G.window.fireworks.emitting = active.value
