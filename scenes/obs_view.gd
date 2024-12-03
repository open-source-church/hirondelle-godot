extends VBoxContainer

@onready var txt_host: LineEdit = %TxtHost
@onready var txt_port: LineEdit = %TxtPort
@onready var txt_password: LineEdit = %TxtPassword
@onready var btn_connect: Button = %BtnConnect
@onready var btn_test: Button = %BtnTest
@onready var program_texture: TextureRect = %ProgramTexture

@onready var WS: OBSWebSocket = $OBSWebSocket

var data := {}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	btn_connect.pressed.connect(obs_connect)
	btn_test.pressed.connect(test_cmd)
	WS.authenticated.connect(get_info)

func obs_connect() -> void:
	WS.host = txt_host.text
	WS.port = txt_port.text
	WS.password = txt_password.text
	WS.connect_obs()

func get_info():
	var info = {}
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
		#print(d)
		for k in d.responseData:
			data[k] = d.responseData[k]
	data.ratio = data.baseWidth / data.baseHeight
	#print(JSON.stringify(data))
	
	var d = await WS.send_request("GetSourceScreenshot", {
		"sourceName": data.currentProgramSceneName,
		"imageFormat": "jpg",
		"imageWidth": 100,
		"imageHeight": 100 / data.ratio,
		"imageCompressionQuality": 40,
	})
	print(d.responseData.imageData)
	var image_data = d.responseData.imageData.to_ascii_buffer()
	print(image_data.size())
	var img = Image.new()
	img.load_jpg_from_buffer(image_data)
	program_texture.texture = ImageTexture.create_from_image(img)
	
	

func test_cmd():
	var r = await WS.send_request("GetSceneList")
	print(r)
