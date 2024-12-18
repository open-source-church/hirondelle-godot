extends HBaseNode

static var _title = "Send message"
static var _type = "twitch/send_chat_message"
static var _category = "Twitch"
static var _icon = "twitch"
static var _sources = ["twitch"]


var send := HPortFlow.new(E.Side.INPUT)
var message := HPortText.new(E.Side.INPUT)
var reply_to := HPortText.new(E.Side.INPUT)

func _init() -> void:
	title = _title
	type = _type
	

func run(_port : HBasePort) -> void:
	if _port == send:
		show_warning("Sending...")
		show_error("")
		var r = await G.twitch.request.POST("/chat/messages", {
			"broadcaster_id": G.twitch.auth.user.id,
			"sender_id": G.twitch.auth.user.id,
			"message": message.value,
			"reply_parent_message_id": reply_to.value
		})
		if r.response_code == 200:
			show_warning("")
			show_success("Sent !", 3)
		else:
			show_warning("")
			show_error(r.response.message, 10)
			
		
