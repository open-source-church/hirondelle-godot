extends Node
class_name TwitchingAuth
## Manages authentification part

var client : HTTPRequest
var twitching : Twitching
var downloader: HDownloader

enum FlowStep { INITIALIZATION, WAITING_FOR_TOKEN, DONE, REFRESH }
var step : FlowStep

## Scopes requested
var requested_scopes = [TwitchingScopes.USER_READ_CHAT, TwitchingScopes.USER_WRITE_CHAT]

## Polling interval while waiting for access token
@onready var poll_interval_ms := 5000
var _last_poll : int

## Temporary code used for authentification
var device_code : String

## Tokens
var access_token := ""
var refresh_token := ""
var expires_at := 0
var scopes := []
var secret_storage_path := "user://twitch_secrets"

var token_valid: bool:
	get(): return Time.get_unix_time_from_system() < expires_at

var user: TwitchingUser

var logged : bool:
	get(): return user != null

signal device_code_requested(response: TwitchingDeviceCodeResponse)
signal access_tokens_received(access: String, refresh: String)
signal tokens_changed
signal user_changed
signal token_refreshed (success: bool)

func _init(_twitching: Twitching):
	twitching = _twitching

func _ready() -> void:
	client = HTTPRequest.new()
	client.request_completed.connect(_on_request_completed)
	add_child(client)
	
	downloader = HDownloader.new()
	add_child(downloader)
	
	tokens_changed.connect(update_user)
	
	restore_tokens.call_deferred()

func _process(delta: float) -> void:
	if step == FlowStep.WAITING_FOR_TOKEN:
		if not _last_poll: _last_poll = Time.get_ticks_msec()
		if Time.get_ticks_msec() > _last_poll + poll_interval_ms:
			_last_poll = Time.get_ticks_msec()
			_get_access_token_request()

func request_access_tokens(scopes : Array[TwitchingScopes.Scope] = []) -> void:
	if scopes:
		requested_scopes = scopes
	# Only strategy implemented
	DCF_authorize()

## Authorization using Device Code Grant Flow
## See: https://dev.twitch.tv/docs/authentication/getting-tokens-oauth/#device-code-grant-flow
func DCF_authorize() -> void:
	var url = "https://id.twitch.tv/oauth2/device?client_id=%s&scopes=%s" % [
		twitching.CLIENT_ID,
		format_scopes(requested_scopes)
	]
	step = FlowStep.INITIALIZATION
	client.request(url, [], HTTPClient.METHOD_POST)

func _get_access_token_request():
	var url = "https://id.twitch.tv/oauth2/token?client_id=%s&scopes=%s&device_code=%s&grant_type=%s" % [
		twitching.CLIENT_ID,
		format_scopes(requested_scopes),
		device_code,
		"urn:ietf:params:oauth:grant-type:device_code"
	]
	client.request(url, [], HTTPClient.METHOD_POST)

## Use refresh token to get new access token. Returns true if succeeds.
func use_refresh_token() -> bool:
	var url = "https://id.twitch.tv/oauth2/token?client_id=%s&grant_type=%s&refresh_token=%s" % [
		twitching.CLIENT_ID,
		"refresh_token",
		refresh_token.uri_encode()
	]
	step = FlowStep.REFRESH
	client.request(url, [], HTTPClient.METHOD_POST)
	return await token_refreshed

func format_scopes(scopes: Array):
	return " ".join(scopes.map(func (s): return s.value)).uri_encode()

func _on_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
	if not result == HTTPRequest.RESULT_SUCCESS:
		print("[TwitchingAuth] Error: request did not succeed: ", response_code)
		print(response_code, headers)
		return
	
	var response := JSON.parse_string(body.get_string_from_utf8())
	#print(step, response_code, response)
	
	if step == FlowStep.INITIALIZATION:
		var res = TwitchingDeviceCodeResponse.new(response)
		device_code = res.device_code
		device_code_requested.emit(res)
		step = FlowStep.WAITING_FOR_TOKEN
	
	elif step == FlowStep.WAITING_FOR_TOKEN:
		if response_code == 400:
			# still waiting for the response
			if response.message == "authorization_pending":
				return
		
		if response_code == 200:
			get_tokens_from_response(response)
			step = FlowStep.DONE
	
	elif step == FlowStep.REFRESH:
		if response_code == 400:
			# Invalid refresh token
			print("[TwitchingAuth] Error: invalid refresh token :(")
			token_refreshed.emit(false)
		
		if response_code == 200:
			get_tokens_from_response(response)
			step = FlowStep.DONE
			token_refreshed.emit(true)

func get_tokens_from_response(response : Dictionary) -> void:
	access_token = response.access_token
	refresh_token = response.refresh_token
	expires_at = roundi(Time.get_unix_time_from_system() + response.expires_in)
	scopes = response.scope
	access_tokens_received.emit(access_token, refresh_token)
	tokens_changed.emit()
	store_tokens()

func get_headers() -> Array:
	return [
		"Authorization: Bearer %s" % access_token,
		"Content-Type: application/json",
		"Client-Id: %s" % twitching.CLIENT_ID
	]

## Stores tokens encrypted in user directory
func store_tokens():
	var secret_file = ConfigFile.new()
	secret_file.load_encrypted_pass(secret_storage_path, twitching.CLIENT_ID)
	secret_file.set_value("auth", "access_token", access_token)
	secret_file.set_value("auth", "refresh_token", refresh_token)
	secret_file.set_value("auth", "scopes", scopes)
	secret_file.set_value("auth", "expires_at", expires_at)
	secret_file.save_encrypted_pass(secret_storage_path, twitching.CLIENT_ID)

## Restores tokens encrypted in user directory
func restore_tokens():
	var secret_file = ConfigFile.new()
	if secret_file.load_encrypted_pass(secret_storage_path, twitching.CLIENT_ID) != OK:
		return
	access_token = secret_file.get_value("auth", "access_token", "")
	refresh_token = secret_file.get_value("auth", "refresh_token", "")
	scopes = secret_file.get_value("auth", "scopes", [])
	expires_at = secret_file.get_value("auth", "expires_at", 0)
	tokens_changed.emit()

func update_user():
	var user_data = await twitching.request.GET("/users")
	if user_data.response_code == 200:
		user = TwitchingUser.new(user_data.response.data.front())
	else:
		user = null
	user_changed.emit()

func logout():
	access_token = ""
	refresh_token = ""
	expires_at = 0
	scopes = []
	store_tokens()
	tokens_changed.emit()
