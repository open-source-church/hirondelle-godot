extends HBaseSource
class_name HTwitchSource

## A source for twitch
##
## FIXME: how to deal with scopes ?

func _init() -> void:
	name = "twitch"

func _ready() -> void:
	while not G.twitch:
		await get_tree().process_frame
	G.twitch.auth.connected.connect(becomes_active.emit)
	G.twitch.auth.disconnected.connect(becomes_inactive.emit)

## Subclass to implement different behavior.
func get_active() -> bool:
	return G.twitch.auth.logged
