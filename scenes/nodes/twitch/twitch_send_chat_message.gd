extends HBaseNode

static var _title = "Send message"
static var _type = "twitch/send_chat_message"
static var _category = "Twitch"
static var _icon = "twitch"

func _init() -> void:
	title = _title
	type = _type
	PORTS = {
		"send": HPortFlow.new(E.Side.INPUT),
		"message": HPortText.new(E.Side.INPUT),
		"reply_to": HPortText.new(E.Side.INPUT),
	}

func run(routine:String):
	if routine == "send":
		show_warning("Sending...")
		show_error("")
		var r = await G.twitch.request.POST("/chat/messages", {
			"broadcaster_id": G.twitch.auth.user.id,
			"sender_id": G.twitch.auth.user.id,
			"message": PORTS.message.value,
			"reply_parent_message_id": PORTS.reply_to.value
		})
		if r.response_code == 200:
			show_warning("")
			show_success("Sent !", 3)
		else:
			show_warning("")
			show_error(r.response.message, 10)
			
		
