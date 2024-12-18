extends VBoxContainer

@onready var txt_host: LineEdit = %TxtHost
@onready var txt_port: LineEdit = %TxtPort
@onready var txt_password: LineEdit = %TxtPassword
@onready var btn_connect: Button = %BtnConnect
@onready var btn_disconnect: Button = %BtnDisconnect

@onready var WS: OBSWebSocket = $OBSWebSocket

var info := {}
## Auto reconnect time in seconds
var auto_connect_time:float = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	G.OBS = WS
	
	btn_connect.pressed.connect(obs_connect)
	btn_disconnect.pressed.connect(WS.disconnect_obs)
	WS.authenticated.connect(get_info)
	
	WS.authenticated.connect(_on_connected)
	WS.disconnected.connect(_on_disconnected)
	
	obs_connect()

func _on_connected() -> void:
	btn_connect.visible = false
	btn_disconnect.visible = true

func _on_disconnected() -> void:
	btn_connect.visible = true
	btn_disconnect.visible = false
	if auto_connect_time:
		get_tree().create_timer(auto_connect_time).timeout.connect(obs_connect)

func obs_connect() -> void:
	WS.host = txt_host.text
	WS.port = txt_port.text
	WS.password = txt_password.text
	WS.connect_obs()

func get_info():
	var requests = [
		"GetProfileList",
		"GetSceneCollectionList",
		"GetSceneList",
		"GetVideoSettings",
		"GetStudioModeEnabled",
		"GetInputList",
		"GetInputKindList",
		"GetVersion"
	]
	for r in requests:
		print("Requesting: ", r)
		var d = await WS.send_request(r)
		if not d: continue
		for k in d:
			info[k] = d[k]
	if info.get("base_Height"):
		info.ratio = info.baseWidth / info.baseHeight
	
	#print(JSON.stringify(data, " "))
	


## FIXME: error on loading data, don't understand.
func get_screenshot():
	var d = await WS.send_request("GetSourceScreenshot", {
		"sourceName": info.currentProgramSceneName,
		"imageFormat": "jpg",
		"imageWidth": 100,
		"imageHeight": 100 / info.ratio,
		"imageCompressionQuality": 40,
	})
	var image_data = d.responseData.imageData.replace("data:image/jpg;base64,", "")
	print(image_data)
	#print(image_data.size())
	var img = Image.new()
	img.load_jpg_from_buffer(image_data.to_ascii_buffer())
	#program_texture.texture = ImageTexture.create_from_image(img)
