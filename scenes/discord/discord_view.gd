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

# Permissions and guilds
@onready var list_permissions: ItemList = %ListPermissions
@onready var list_guilds: ItemList = %ListGuilds

@onready var btn_test: Button = %BtnTest

var downloader: HDownloader

var discord: HDiscordBot

const needed_permissions = [
	HDiscordBot.Permissions.CREATE_EVENTS,
	HDiscordBot.Permissions.ADD_REACTIONS,
	HDiscordBot.Permissions.READ_MESSAGE_HISTORY
]

func _ready() -> void:
	
	discord = HDiscordBot.new()
	add_child(discord)
	
	G.discord = discord
	
	discord.connected_changed.connect(on_connected_changed)
	
	txt_token.text_changed.connect(func (t): discord.token = t)
	discord.token_changed.connect(txt_token.set_text)
	txt_token.text = discord.token
	
	btn_show_token.toggled.connect(func (v): txt_token.secret = not v)
	btn_show_token.toggled.connect(func (v): txt_token.visible = not discord.valid_token or v)
	btn_disconnect.pressed.connect(func (): txt_token.clear())
	
	btn_test.pressed.connect(test_function)
	
	list_guilds.item_clicked.connect(on_guild_clicked.unbind(2))
	
	downloader = HDownloader.new()
	add_child(downloader)

func on_connected_changed(connected: bool) -> void:
	lbl_invalid_token.visible = not connected and discord.token
	container_bot_user.visible = connected
	lbl_token.visible = not connected
	txt_token.visible = not connected
	
	if connected:
		lbl_user_name.text = discord.bot.username
		update_bot_image()
		update_bot_permissions()
		get_guild_list()

func test_function() -> void:
	print("TEST")
	
	var url = "/channels/%s/messages/%s/reactions/%s/@me" % \
		[1021148008101978202, 1318619156375142491, "🐧".uri_encode()]
	print(url)
	var r = await discord.request.PUT(url)
	print(r)


func update_bot_image() -> void:
	if not discord.bot.avatar: return
	var url = "https://cdn.discordapp.com/avatars/%s/%s.png" % [discord.bot.id, discord.bot.avatar]
	var img = await downloader.get_url(url)
	if img is Image:
		user_icon.texture = ImageTexture.create_from_image(img)

func update_bot_permissions(permissions = null) -> void:
	if not permissions:
		permissions = discord.bot.permissions
	permissions = int(permissions)
	list_permissions.clear()
	for perm in HDiscordBot.Permissions.keys():
		var _perm = " ".join(perm.split("_")).capitalize()
		var has = permissions & HDiscordBot.Permissions[perm]
		var needed = HDiscordBot.Permissions[perm] in needed_permissions
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
	var r := await discord.request.GET("/users/@me/guilds", { "with_counts": true })
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
		var _i = list_guilds.add_item(g.name, icon)
