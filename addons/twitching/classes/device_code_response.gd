extends RefCounted
class_name TwitchingDeviceCodeResponse

## From: https://dev.twitch.tv/docs/authentication/getting-tokens-oauth/#device-code-grant-flow

## The identifier for a given user.
var device_code : String
## Time until the code is no longer valid
var expires_in : int
## Time until another valid code can be requested
var interval : int
## The code that the user will use to authenticate
var user_code : String
## The address you will send users to, to authenticate
var verification_uri : String

func _init(obj : Dictionary) -> void:
	device_code = obj.device_code
	expires_in = obj.expires_in
	interval = obj.interval
	user_code = obj.user_code
	verification_uri = obj.verification_uri
