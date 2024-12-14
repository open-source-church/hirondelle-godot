extends HBaseNode

static var _title = "Channel follow"
static var _type = "twitch/channel_follow"
static var _category = "Twitch"
static var _icon = "twitch"

func _init() -> void:
	title = _title
	type = _type
	PORTS = {
		"new_follow": HPortFlow.new(E.Side.OUTPUT),
		"user_id": HPortText.new(E.Side.OUTPUT),
		"login": HPortText.new(E.Side.OUTPUT),
		"username": HPortText.new(E.Side.OUTPUT),
		"follow_at": HPortText.new(E.Side.OUTPUT),
		
	}
	var condition = TChannelFollowCondition.create(G.twitch.auth.user.id, G.twitch.auth.user.id)
	G.twitch.eventsub.subs.CHANNEL_FOLLOW.subscribe(condition)
	G.twitch.eventsub.subs.CHANNEL_FOLLOW.event.connect(_on_channel_follow)

func _on_channel_follow(event: TChannelFollowEvent):
	PORTS.user_id.value = event.user_id
	PORTS.login.value = event.user_login
	PORTS.username.value = event.user_name
	PORTS.follow_at.value = event.followed_at
	
	emit("new_follow")
