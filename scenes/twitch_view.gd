extends VBoxContainer

# Connection buttons
@onready var btn_connect: Button = %BtnConnect

# Device Code stuff
@onready var device_code_pannel: PanelContainer = %DeviceCodePannel
@onready var txt_request_code_url: LineEdit = %TxtRequestCodeURL
@onready var lbl_code: Label = %LblCode
@onready var btn_open_browser_for_code: Button = %BtnOpenBrowserForCode

# Access Tokens stuff
@onready var txt_access_token: LineEdit = %TxtAccessToken
@onready var txt_refresh_token: LineEdit = %TxtRefreshToken
@onready var txt_expire_token: LineEdit = %TxtExpireToken
@onready var txt_scopes_token: LineEdit = %TxtScopesToken
@onready var btn_refresh_token: Button = %BtnRefreshToken
@onready var lbl_valid_token: Label = %LblValidToken

var twitch : Twitching
var connected := false

func _ready() -> void:
	twitch = Twitching.new()
	add_child(twitch)
	twitch.auth.device_code_requested.connect(_on_device_code_requested)
	twitch.auth.tokens_changed.connect(device_code_pannel.hide)
	twitch.auth.tokens_changed.connect(_on_tokens_changed)
	_on_tokens_changed()
	
	btn_refresh_token.pressed.connect(twitch.auth.use_refresh_token)
	
	# UI connections
	btn_connect.pressed.connect(login)
	btn_open_browser_for_code.pressed.connect(_open_browser_for_code_verification)
	device_code_pannel.visible = false
	# SUB

func login() -> void:
	print("Login")
	twitch.auth.get_access_tokens()
	
func _process(_delta: float) -> void:
	pass

func _on_device_code_requested(device_code_response : TwitchingDeviceCodeResponse) -> void:
	device_code_pannel.visible = true
	txt_request_code_url.text = device_code_response.verification_uri
	lbl_code.text = device_code_response.user_code

func _open_browser_for_code_verification() -> void:
	OS.shell_open(txt_request_code_url.text)

func _on_tokens_changed() -> void:
	txt_access_token.text = twitch.auth.access_token
	txt_refresh_token.text = twitch.auth.refresh_token
	txt_expire_token.text = Time.get_datetime_string_from_unix_time(twitch.auth.expires_at, true)
	txt_scopes_token.text = " ".join(twitch.auth.scopes)
	lbl_valid_token.text = "valid" if twitch.auth.token_valid else "invalid"
	lbl_valid_token.add_theme_color_override("font_color", Color.GREEN if twitch.auth.token_valid else Color.RED)

func _on_event(type: String, data: Dictionary):
	print("NEW EVENT: ", type)
	print(data)
	print("\n")

func _on_chat_message(from_user: String, message: String, tags):
	print("NEW CHAT MESSAGE from %s: %s" % [from_user, message])
	print("Tags: ", tags)
	print("\n")
