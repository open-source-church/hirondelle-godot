extends HBaseNode

static var _title = "Channel message"
static var _type = "twitch/channel_chat_message"
static var _category = "Twitch"
static var _icon = "twitch"


var new_message := HPortFlow.new(E.Side.OUTPUT)
var user_id := HPortText.new(E.Side.OUTPUT)
var login := HPortText.new(E.Side.OUTPUT)
var username := HPortText.new(E.Side.OUTPUT)
var message := HPortText.new(E.Side.OUTPUT)
var message_id := HPortText.new(E.Side.OUTPUT)
var color := HPortColor.new(E.Side.OUTPUT)

func _init() -> void:
	title = _title
	type = _type
	
	var condition = TChannelChatMessageCondition.create(G.twitch.auth.user.id, G.twitch.auth.user.id)
	G.twitch.eventsub.subs.CHANNEL_CHAT_MESSAGE.subscribe(condition)
	G.twitch.eventsub.subs.CHANNEL_CHAT_MESSAGE.event.connect(_on_channel_message)

func _on_channel_message(event: TChannelChatMessageEvent):
	user_id.value = event.chatter_user_id
	login.value = event.chatter_user_login
	username.value = event.chatter_user_name
	message.value = event.message.text
	message_id.value = event.message_id
	if event.color:
		color.value = event.color
	
	new_message.emit()
