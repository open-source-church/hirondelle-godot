extends Node
class_name Twitching
## A Godot library for [limited] Twitch functionnalities

## Application client identification, from https://dev.twitch.tv/console/apps
const CLIENT_ID = "1rhr59814cpxizvresldeljmxxx4tn"

var connected := false
var auth : TwitchingAuth
var eventsub : TwitchingEventSub

var request : TwitchingRequest

func _ready() -> void:
	auth = TwitchingAuth.new(self)
	add_child(auth)
	
	eventsub = TwitchingEventSub.new(self)
	add_child(eventsub)
	
	request = TwitchingRequest.new(self)
	add_child(request)

func logout() -> void:
	auth.logout()
	eventsub.disconnect_websocket()
