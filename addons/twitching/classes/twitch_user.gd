extends RefCounted
class_name TwitchingUser

## An ID that identifies the user.
var id: String
## The user's login name.
var login: String
## The user's display name.
var display_name: String
## The type of user. Possible values are: admin, global_mod, staff, "" (normal user)
var type: String
## The type of broadcaster. Possible values are: affiliate, partner, "" (normal broadcaster)
var broadcaster_type: String
## The user's description of their channel.
var description: String
## A URL to the user's profile image.
var profile_image_url: String:
	set=update_profile_image_url
## A URL to the user's offline image.
var offline_image_url: String
## The user's verified email address.
## The object includes this field only if the user access token includes the user:read:email scope.
var email: String
## The UTC date and time that the user's account was created. The timestamp is in RFC3339 format.
var created_at: String

var profile_image_texture := ImageTexture.new()

func _init(obj : Dictionary) -> void:
	id = obj.id
	login = obj.login
	display_name = obj.display_name
	type = obj.type
	broadcaster_type = obj.broadcaster_type
	description = obj.description
	profile_image_url = obj.profile_image_url
	offline_image_url = obj.offline_image_url
	email = obj.get("email", "")
	created_at = obj.created_at

func update_profile_image_url(url: String) -> void:
	profile_image_url = url
	
	var img = await TwitchingDownloader.download(url)
	if img:
		profile_image_texture.set_image(img)
