extends Node
class_name HDiscordBot


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

var secret_storage_path := "user://discord_secrets"

var token: String:
	set(val):
		if val != token: 
			token = val
			save_token()
			print("Setting token: ", token)
			token_changed.emit(token)

## Meaning there is a valid token
var valid_token: bool:
	set(val):
		if val != valid_token:
			if val: connected.emit()
			else: disconnected.emit()
		valid_token = val
		connected_changed.emit(valid_token)

signal token_changed(token: String)
signal connected
signal disconnected
signal connected_changed(connected: bool)
var bot: Dictionary


const API := "https://discord.com/api/v10"

var request: HRequest


func _ready() -> void:
	request = HRequest.new(self)
	request.url_mask = "https://discord.com/api/v10%s"
	
	token_changed.connect(on_token_changed.unbind(1))
	restore_tokens()


func on_token_changed() -> void:
	# Update client headers
	request.headers = [
		"Content-Type: application/json",
		"User-Agent: DiscordBot",
		"Authorization: Bot %s" % token]
	
	if not token:
		valid_token = false
		return
	
	# get bot info
	var r := await request.GET("/oauth2/applications/@me")
	if r.response_code == 200:
		var response = r.to_json()
		bot = response.bot
		bot.permissions = int(response.install_params.permissions)
		valid_token = true
		
	else:
		valid_token = false

func save_token() -> void:
	var secret_file = ConfigFile.new()
	secret_file.load_encrypted_pass(secret_storage_path, "1234") # FIXME: what to use?
	secret_file.set_value("auth", "bot_token", token)
	secret_file.save_encrypted_pass(secret_storage_path, "1234")

func restore_tokens():
	var secret_file = ConfigFile.new()
	if secret_file.load_encrypted_pass(secret_storage_path, "1234") != OK: # FIXME: what to use?
		return
	token = secret_file.get_value("auth", "bot_token", "")
