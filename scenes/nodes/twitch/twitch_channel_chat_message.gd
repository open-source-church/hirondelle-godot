extends HBaseNode

static var _title = "Channel message"
static var _type = "twitch/channel_chat_message"
static var _category = "Twitch"
static var _icon = "twitch"

func _init() -> void:
	title = _title
	type = _type
	PORTS = {
		"new_message": HPortFlow.new(E.Side.OUTPUT),
		"user_id": HPortText.new(E.Side.OUTPUT),
		"login": HPortText.new(E.Side.OUTPUT),
		"username": HPortText.new(E.Side.OUTPUT),
		"message": HPortText.new(E.Side.OUTPUT),
		"message_id": HPortText.new(E.Side.OUTPUT),
		"color": HPortColor.new(E.Side.OUTPUT)
	}
	var condition = TChannelChatMessageCondition.create(G.twitch.auth.user.id, G.twitch.auth.user.id)
	G.twitch.eventsub.subs.CHANNEL_CHAT_MESSAGE.subscribe(condition)
	G.twitch.eventsub.subs.CHANNEL_CHAT_MESSAGE.event.connect(_on_channel_message)

func _on_channel_message(event: TChannelChatMessageEvent):
	PORTS.user_id.value = event.chatter_user_id
	PORTS.login.value = event.chatter_user_login
	PORTS.username.value = event.chatter_user_name
	PORTS.message.value = event.message.text
	PORTS.message_id.value = event.message_id
	if event.color:
		PORTS.color.value = event.color
	
	emit("new_message")
