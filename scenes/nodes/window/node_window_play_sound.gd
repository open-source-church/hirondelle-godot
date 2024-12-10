extends HBaseNode

static var _title = "Sound"
static var _type = "window/play_sound"
static var _category = "Window"
static var _icon = "sound"

var ID : int
var audio : AudioStreamPlayer
var downloader : HDownloader

func _init() -> void:
	title = _title
	type = _type
	PORTS = {
		"play": HPortFlow.new(E.Side.INPUT),
		"stop": HPortFlow.new(E.Side.INPUT),
		"started": HPortFlow.new(E.Side.OUTPUT),
		"finished": HPortFlow.new(E.Side.OUTPUT),
		"source": HPortText.new(E.Side.INPUT, {
			"options": ["Local", "URL"]
		}),
		"file": HPortText.new(E.Side.INPUT),
		"url": HPortText.new(E.Side.INPUT),
		"length": HPortIntSpin.new(E.Side.OUTPUT),
		"playback": HPortIntSlider.new(E.Side.OUTPUT),
		"volume": HPortIntSlider.new(E.Side.INPUT, { 
			"default": 80,
			"params": {"max": 100, "reset": true, "label": true }
		}),
		"pitch": HPortIntSlider.new(E.Side.INPUT, {
			"default": 100,
			"params": {"min": 10, "max": 300, "reset": true, "label": true }
		}),
	}
	ID = randi()
	
	audio = AudioStreamPlayer.new()
	audio.finished.connect(emit.bind("finished"))
	add_child(audio)
	
	downloader = HDownloader.new()
	add_child(downloader)

func run(routine:String):
	if routine == "play":
		if audio.stream:
			audio.volume_db = linear_to_db(PORTS.volume.value / 100.0)
			audio.pitch_scale = PORTS.pitch.value / 100.0
			emit("started")
			audio.play()

	if routine == "stop":
		audio.stop()

func download_sound():
	var r = await downloader.get_url(PORTS.url.value)
	if r is AudioStream:
		audio.stream = r
		PORTS.length.value = get_stream_length()
		PORTS.playback.params = { "max": get_stream_length() }

func update() -> void:
	if _last_port_changed == "source":
		PORTS.file.visible = PORTS.source.value == "Local"
		PORTS.url.visible = PORTS.source.value == "URL"
		update_slots()
	
	if _last_port_changed == "url":
		download_sound()
	
	if _last_port_changed == "pitch" and audio.stream:
		PORTS.length.value = get_stream_length()

func _process(delta: float) -> void:
	PORTS.playback.value = audio.get_playback_position() * 1000 * 100 / PORTS.pitch.value
	PORTS.playback.params = { "max": get_stream_length() }

func get_stream_length() -> int:
	if not audio.stream: return 0
	return audio.stream.get_length() * 1000 * 100 / PORTS.pitch.value
