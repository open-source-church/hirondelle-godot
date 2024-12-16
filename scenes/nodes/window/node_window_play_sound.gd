extends HBaseNode

static var _title = "Sound"
static var _type = "window/play_sound"
static var _category = "Window"
static var _icon = "sound"

var ID : int
var audio : AudioStreamPlayer
var downloader : HDownloader


var play := HPortFlow.new(E.Side.INPUT)
var stop := HPortFlow.new(E.Side.INPUT)
var started := HPortFlow.new(E.Side.OUTPUT)
var finished := HPortFlow.new(E.Side.OUTPUT)
var source := HPortText.new(E.Side.NONE, {
	"options": ["Local", "URL"]
})
var file := HPortPath.new(E.Side.INPUT, { "params": { "filters": ["*.mp3,*.wav,*.ogg;Fichier audio"] }})
var url := HPortText.new(E.Side.INPUT)
var length := HPortIntSpin.new(E.Side.OUTPUT)
var playback := HPortIntSlider.new(E.Side.OUTPUT)
var volume := HPortIntSlider.new(E.Side.INPUT, { 
	"default": 80,
	"params": {"max": 100, "reset": true, "label": true }
})
var pitch := HPortIntSlider.new(E.Side.INPUT, {
	"default": 100,
	"params": {"min": 10, "max": 300, "reset": true, "label": true }
})

func _init() -> void:
	title = _title
	type = _type
	
	ID = randi()
	
	audio = AudioStreamPlayer.new()
	audio.finished.connect(finished.emit)
	add_child(audio, false, Node.INTERNAL_MODE_FRONT)
	
	downloader = HDownloader.new()
	add_child(downloader, false, Node.INTERNAL_MODE_FRONT)

func run(_port : HBasePort) -> void:
	if _port == play:
		if audio.stream:
			audio.volume_db = linear_to_db(volume.value / 100.0)
			audio.pitch_scale = pitch.value / 100.0
			started.emit()
			audio.play()

	if _port == stop:
		audio.stop()

func download_sound():
	var r = await downloader.get_url(url.value)
	if r is AudioStream:
		set_stream(r)

func open_sound():
	var filename: String = file.value
	var f = FileAccess.open(filename, FileAccess.READ)
	var stream: AudioStream
	if filename.ends_with(".mp3"):
		stream = AudioStreamMP3.new()
	if filename.ends_with(".ogg"):
		stream = AudioStreamOggVorbis.new()
	if filename.ends_with(".wav"):
		stream = AudioStreamWAV.new()
	stream.data = f.get_buffer(f.get_length())
	set_stream(stream)
	
func set_stream(stream: AudioStream):
	audio.stream = stream
	length.value = get_stream_length()
	playback.params = { "max": get_stream_length() }

func update(_last_changed: HBasePort = null) -> void:
	if _last_changed in [source, null]:
		file.collapsed = not source.value == "Local"
		url.collapsed = not source.value == "URL"
		update_slots()
	
	if _last_changed in [source, url] and source.value == "URL":
		download_sound()
	
	if _last_changed in [source, file] and source.value == "Local":
		open_sound()
	
	if _last_changed == pitch and audio.stream:
		length.value = get_stream_length()

func _process(_delta: float) -> void:
	playback.value = audio.get_playback_position() * 1000 * 100 / pitch.value
	playback.params = { "max": get_stream_length() }

func get_stream_length() -> int:
	if not audio.stream: return 0
	return audio.stream.get_length() * 1000 * 100 / pitch.value
