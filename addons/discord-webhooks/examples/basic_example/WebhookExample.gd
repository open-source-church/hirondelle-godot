extends Node

const WEBHOOK_URL: String = "https://discord.com/api/webhooks/1318492153965445151/3k3GFrN_dgVDd7-MB2X1ab_Bc6_-faAAak-DxfWIT6oa6NBNzwUEx6-kAA3oxgP5Dmb-"

var webhook: DiscordWebHook = null


func _ready() -> void:
	webhook = DiscordWebHook.new(WEBHOOK_URL)
	webhook.message("Hello from godot!")
	webhook.username("Hirondelle")
	webhook.post()
