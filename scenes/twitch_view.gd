extends VBoxContainer

# Login
@onready var login_container: HBoxContainer = %LoginContainer
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

# Logged
@onready var logged_container: HBoxContainer = %LoggedContainer
@onready var lbl_user_name: Label = %LblUserName
@onready var btn_disconnect: Button = %BtnDisconnect
@onready var btn_show_tokens: Button = %BtnShowTokens
@onready var access_token_container: PanelContainer = %AccessTokenContainer
@onready var texture_user: TextureRect = %TextureUser
@onready var rewards_container: PanelContainer = %RewardsContainer

@onready var twitch: Twitching = $Twitching
var connected := false

var scopes : Array[TwitchingScopes.Scope] = [
	TwitchingScopes.USER_READ_CHAT, TwitchingScopes.USER_WRITE_CHAT,
	TwitchingScopes.CHANNEL_READ_REDEMPTIONS, TwitchingScopes.CHANNEL_MANAGE_REDEMPTIONS
	]

func _ready() -> void:
	twitch.auth.device_code_requested.connect(_on_device_code_requested)
	twitch.auth.tokens_changed.connect(device_code_pannel.hide)
	twitch.auth.tokens_changed.connect(_on_tokens_changed)
	twitch.auth.user_changed.connect(_on_user_changed)
	_on_tokens_changed()
	
	# UI connections
	btn_connect.pressed.connect(login)
	btn_open_browser_for_code.pressed.connect(_open_browser_for_code_verification)
	device_code_pannel.visible = false
	btn_show_tokens.toggled.connect(access_token_container.set_visible)
	access_token_container.visible = false
	btn_refresh_token.pressed.connect(twitch.auth.use_refresh_token)
	btn_disconnect.pressed.connect(twitch.logout)
	#var test = await twitch.request.GET("/users")
	#print("Response: ", test)

func login() -> void:
	print("Login with %d scopes" % scopes.size())
	twitch.auth.request_access_tokens(scopes)
	
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

func _on_user_changed() -> void:
	if twitch.auth.user:
		logged_container.visible = true
		login_container.visible = false
		rewards_container.visible = true
		lbl_user_name.text = twitch.auth.user.login
		texture_user.texture = twitch.auth.user.profile_image_texture
	else:
		logged_container.visible = false
		login_container.visible = true
		rewards_container.visible = false
