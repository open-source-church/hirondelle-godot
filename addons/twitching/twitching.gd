extends Node
class_name Twitching
## A Godot library for [limited] Twitch functionnalities


## Application client identification, from https://dev.twitch.tv/console/apps
const CLIENT_ID = "1rhr59814cpxizvresldeljmxxx4tn"

var connected := false
var auth : TwitchingAuth
var eventsub : TwitchingEventSub

func _ready() -> void:
	print("Twitching ready")
	auth = TwitchingAuth.new()
	add_child(auth)
	
	eventsub = TwitchingEventSub.new()
	add_child(eventsub)
