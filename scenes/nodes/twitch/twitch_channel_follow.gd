extends HBaseNode

static var _title = "Channel follow"
static var _type = "twitch/channel_follow"
static var _category = "Twitch"
static var _icon = "twitch"
static var _sources = ["twitch"]


var new_follow := HPortFlow.new(E.Side.OUTPUT)
var user_id := HPortText.new(E.Side.OUTPUT)
var login := HPortText.new(E.Side.OUTPUT)
var username := HPortText.new(E.Side.OUTPUT)
var follow_at := HPortText.new(E.Side.OUTPUT)
		

func _init() -> void:
	title = _title
	type = _type
	
	var condition = TChannelFollowCondition.create(G.twitch.auth.user.id, G.twitch.auth.user.id)
	G.twitch.eventsub.subs.CHANNEL_FOLLOW.subscribe(condition)
	G.twitch.eventsub.subs.CHANNEL_FOLLOW.event.connect(_on_channel_follow)

func _on_channel_follow(event: TChannelFollowEvent):
	user_id.value = event.user_id
	login.value = event.user_login
	username.value = event.user_name
	follow_at.value = event.followed_at
	
	new_follow.emit()
