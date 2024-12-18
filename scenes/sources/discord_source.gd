extends HBaseSource
class_name HDiscordBotSource

## A source for twitch
##
## FIXME: how to deal with scopes ?

func _init() -> void:
	name = "discord_bot"

func _ready() -> void:
	while not G.discord:
		await get_tree().process_frame
	G.discord.connected.connect(becomes_active.emit)
	G.discord.disconnected.connect(becomes_inactive.emit)

func get_active() -> bool:
	return G.discord.valid_token
