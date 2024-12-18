extends VBoxContainer

# Tokens
@onready var txt_token: LineEdit = %TxtToken
@onready var btn_show_token: Button = %BtnShowToken
@onready var lbl_invalid_token: Label = %LblInvalidToken
@onready var container_bot_user: HBoxContainer = %ContainerBotUser
@onready var user_icon: TextureRect = %UserIcon
@onready var lbl_user_name: Label = %LblUserName
@onready var lbl_token: Label = %LblToken
@onready var btn_disconnect: Button = %BtnDisconnect
var secret_storage_path := "user://discord_secrets"
signal token_changed

# Permissions and guilds
@onready var list_permissions: ItemList = %ListPermissions
@onready var list_guilds: ItemList = %ListGuilds

@onready var btn_test: Button = %BtnTest

var valid_token: bool
var bot: Dictionary


const API := "https://discord.com/api/v10"

var client: HRequest
var downloader: HDownloader

enum Permissions {
	CREATE_INSTANT_INVITE = 1 << 0,
	KICK_MEMBERS = 1 << 1,
	BAN_MEMBERS = 1 << 2,
	ADMINISTRATOR = 1 << 3,
	MANAGE_CHANNELS = 1 << 4,
	MANAGE_GUILD = 1 << 5,
	ADD_REACTIONS = 1 << 6,
	VIEW_AUDIT_LOG = 1 << 7,
	PRIORITY_SPEAKER = 1 << 8,
	STREAM = 1 << 9,
	VIEW_CHANNEL = 1 << 10,
	SEND_MESSAGES = 1 << 11,
	SEND_TTS_MESSAGES = 1 << 12,
	MANAGE_MESSAGES = 1 << 13,
	EMBED_LINKS = 1 << 14,
	ATTACH_FILES = 1 << 15,
	READ_MESSAGE_HISTORY = 1 << 16,
	MENTION_EVERYONE = 1 << 17,
	USE_EXTERNAL_EMOJIS = 1 << 18,
	VIEW_GUILD_INSIGHTS = 1 << 19,
	CONNECT = 1 << 20,
	SPEAK = 1 << 21,
	MUTE_MEMBERS = 1 << 22,
	DEAFEN_MEMBERS = 1 << 23,
	MOVE_MEMBERS = 1 << 24,
	USE_VAD = 1 << 25,
	CHANGE_NICKNAME = 1 << 26,
	MANAGE_NICKNAMES = 1 << 27,
	MANAGE_ROLES = 1 << 28,
	MANAGE_WEBHOOKS = 1 << 29,
	MANAGE_GUILD_EXPRESSIONS = 1 << 30,
	USE_APPLICATION_COMMANDS = 1 << 31,
	REQUEST_TO_SPEAK = 1 << 32,
	MANAGE_EVENTS = 1 << 33,
	MANAGE_THREADS = 1 << 34,
	CREATE_PUBLIC_THREADS = 1 << 35,
	CREATE_PRIVATE_THREADS = 1 << 36,
	USE_EXTERNAL_STICKERS = 1 << 37,
	SEND_MESSAGES_IN_THREADS = 1 << 38,
	USE_EMBEDDED_ACTIVITIES = 1 << 39,
	MODERATE_MEMBERS = 1 << 40,
	VIEW_CREATOR_MONETIZATION_ANALYTICS = 1 << 41,
	USE_SOUNDBOARD = 1 << 42,
	CREATE_GUILD_EXPRESSIONS = 1 << 43,
	CREATE_EVENTS = 1 << 44,
	USE_EXTERNAL_SOUNDS = 1 << 45,
	SEND_VOICE_MESSAGES = 1 << 46,
	SEND_POLLS = 1 << 49,
	USE_EXTERNAL_APPS = 1 << 50,
}

const needed_permissions = [
	Permissions.CREATE_EVENTS,
	Permissions.ADD_REACTIONS,
	Permissions.READ_MESSAGE_HISTORY
]

func _ready() -> void:
	txt_token.text_changed.connect(save_token.unbind(1))
	txt_token.text_changed.connect(on_token_changed.unbind(1))
	token_changed.connect(on_token_changed)
	
	btn_show_token.toggled.connect(func (v): txt_token.secret = not v)
	btn_show_token.toggled.connect(func (v): txt_token.visible = not valid_token or v)
	btn_disconnect.pressed.connect(func (): txt_token.clear())
	
	btn_test.pressed.connect(test_function)
	
	list_guilds.item_clicked.connect(on_guild_clicked.unbind(2))
	
	client = HRequest.new(self)
	client.url_mask = "https://discord.com/api/v10%s"
	
	downloader = HDownloader.new()
	add_child(downloader)
	
	restore_tokens()

func test_function() -> void:
	print("TEST")
	#var emojis = await client.GET("/guilds/772809551081897994/emojis")
	#print(emojis)
	
	var url = "/channels/%s/messages/%s/reactions/%s/@me" % \
		[1021148008101978202, 1318619156375142491, "🐧".uri_encode()]
	print(url)
	var r = await client.PUT(url)
	print(r)

func on_token_changed() -> void:
	# Update client headers
	client.headers = [
		"Content-Type: application/json",
		"User-Agent: DiscordBot",
		"Authorization: Bot %s" % txt_token.text]
	
	if not txt_token.text:
		container_bot_user.visible = false
		lbl_token.visible = true
		lbl_invalid_token.visible = false
		txt_token.visible = true
		valid_token = false
		return
	
	# get bot info
	var r := await client.GET("/oauth2/applications/@me")
	if r.response_code == 200:
		var response = r.to_json()
		bot = response.bot
		bot.permissions = int(response.install_params.permissions)
		lbl_user_name.text = bot.username
		valid_token = true
		update_bot_image()
		update_bot_permissions()
		get_guild_list()
		
	else:
		valid_token = false
	
	lbl_invalid_token.visible = not valid_token
	container_bot_user.visible = valid_token
	lbl_token.visible = not valid_token
	txt_token.visible = not valid_token

func update_bot_image() -> void:
	if not bot.avatar: return
	var url = "https://cdn.discordapp.com/avatars/%s/%s.png" % [bot.id, bot.avatar]
	var img = await downloader.get_url(url)
	if img is Image:
		user_icon.texture = ImageTexture.create_from_image(img)

func update_bot_permissions(permissions = null) -> void:
	if not permissions:
		permissions = bot.permissions
	permissions = int(permissions)
	list_permissions.clear()
	for perm in Permissions.keys():
		var _perm = " ".join(perm.split("_")).capitalize()
		var has = permissions & Permissions[perm]
		var needed = Permissions[perm] in needed_permissions
		var icon = "check" if (has or not needed) else "cross-no"
		var i = list_permissions.add_item(_perm, G.get_main_icon(icon, 16))
		var color = Color.GREEN if has else Color.RED if needed else Color.GRAY
		list_permissions.set_item_custom_fg_color(i, color)
	

var guilds := []

var _last_guild_selected: int
func on_guild_clicked(index: int) -> void:
	if index == _last_guild_selected:
		list_guilds.deselect(index)
		update_bot_permissions()
		_last_guild_selected = -1
	else:
		update_bot_permissions(guilds[index].permissions)
		_last_guild_selected = index

func get_guild_list() -> void:
	var r := await client.GET("/users/@me/guilds", { "with_counts": true })
	if not r.response_code == 200:
		push_error(r)
		return
	guilds = r.to_json()
	
	list_guilds.clear()
	for g in guilds:
		var url = "https://cdn.discordapp.com/icons/%s/%s.png?size=64" % [g.id, g.icon]
		var img = await downloader.get_url(url)
		var icon: Texture2D
		if img is Image:
			icon = ImageTexture.create_from_image(img)
		var i = list_guilds.add_item(g.name, icon)

func save_token() -> void:
	var secret_file = ConfigFile.new()
	secret_file.load_encrypted_pass(secret_storage_path, "1234") # FIXME: what to use?
	secret_file.set_value("auth", "bot_token", txt_token.text)
	secret_file.save_encrypted_pass(secret_storage_path, "1234")

func restore_tokens():
	var secret_file = ConfigFile.new()
	if secret_file.load_encrypted_pass(secret_storage_path, "1234") != OK: # FIXME: what to use?
		return
	txt_token.text = secret_file.get_value("auth", "bot_token", "")
	token_changed.emit()
