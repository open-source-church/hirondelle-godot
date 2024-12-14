extends RefCounted
class_name TwitchingScopes

## Scopes used by Twitch.

## Autogenerated from https://dev.twitch.tv/docs/authentication/scopes/
## Do not modify manually, it may change.

# Name of the scope
var name: String
## Description
var description: String
## Which API use it
var API: Array
## Which EventSub use it
var EventSub: Array

func _init(_name: String, _description: String, _API: Array, _EventSub: Array):
	name = _name
	description = _description
	API = _API
	EventSub = _EventSub

func _to_string() -> String:
	return name

static func format_scopes(array: Array[TwitchingScopes]):
	return " ".join(array).uri_encode()

## View analytics data for the Twitch Extensions owned by the authenticated account.
static var ANALYTICS_READ_EXTENSIONS := TwitchingScopes.new("analytics:read:extensions", "View analytics data for the Twitch Extensions owned by the authenticated account.", ['Get Extension Analytics'], [])

## View analytics data for the games owned by the authenticated account.
static var ANALYTICS_READ_GAMES := TwitchingScopes.new("analytics:read:games", "View analytics data for the games owned by the authenticated account.", ['Get Game Analytics'], [])

## View Bits information for a channel.
static var BITS_READ := TwitchingScopes.new("bits:read", "View Bits information for a channel.", ['Get Bits Leaderboard'], ['Channel Cheer'])

## Joins your channel’s chatroom as a bot user, and perform chat-related actions as that user.
static var CHANNEL_BOT := TwitchingScopes.new("channel:bot", "Joins your channel’s chatroom as a bot user, and perform chat-related actions as that user.", ['Send Chat Message'], ['Channel Chat Clear', 'Channel Chat Clear User Messages', 'Channel Chat Message', 'Channel Chat Message Delete', 'Channel Chat Notification', 'Channel Chat Settings Update'])

## Manage ads schedule on a channel.
static var CHANNEL_MANAGE_ADS := TwitchingScopes.new("channel:manage:ads", "Manage ads schedule on a channel.", ['Snooze Next Ad'], [])

## Read the ads schedule and details on your channel.
static var CHANNEL_READ_ADS := TwitchingScopes.new("channel:read:ads", "Read the ads schedule and details on your channel.", ['Get Ad Schedule'], ['Channel Ad Break Begin'])

## Manage a channel’s broadcast configuration, including updating channel configuration and managing stream markers and stream tags.
static var CHANNEL_MANAGE_BROADCAST := TwitchingScopes.new("channel:manage:broadcast", "Manage a channel’s broadcast configuration, including updating channel configuration and managing stream markers and stream tags.", ['Modify Channel Information', 'Create Stream Marker', 'Replace Stream Tags'], [])

## Read charity campaign details and user donations on your channel.
static var CHANNEL_READ_CHARITY := TwitchingScopes.new("channel:read:charity", "Read charity campaign details and user donations on your channel.", ['Get Charity Campaign', 'Get Charity Campaign Donations'], ['Charity Donation', 'Charity Campaign Start', 'Charity Campaign Progress', 'Charity Campaign Stop'])

## Run commercials on a channel.
static var CHANNEL_EDIT_COMMERCIAL := TwitchingScopes.new("channel:edit:commercial", "Run commercials on a channel.", ['Start Commercial'], [])

## View a list of users with the editor role for a channel.
static var CHANNEL_READ_EDITORS := TwitchingScopes.new("channel:read:editors", "View a list of users with the editor role for a channel.", ['Get Channel Editors'], [])

## Manage a channel’s Extension configuration, including activating Extensions.
static var CHANNEL_MANAGE_EXTENSIONS := TwitchingScopes.new("channel:manage:extensions", "Manage a channel’s Extension configuration, including activating Extensions.", ['Get User Active Extensions', 'Update User Extensions'], [])

## View Creator Goals for a channel.
static var CHANNEL_READ_GOALS := TwitchingScopes.new("channel:read:goals", "View Creator Goals for a channel.", ['Get Creator Goals'], ['Goal Begin', 'Goal Progress', 'Goal End'])

## Read Guest Star details for your channel.
static var CHANNEL_READ_GUEST_STAR := TwitchingScopes.new("channel:read:guest_star", "Read Guest Star details for your channel.", ['Get Channel Guest Star Settings', 'Get Guest Star Session', 'Get Guest Star Invites'], ['Channel Guest Star Session Begin', 'Channel Guest Star Session End', 'Channel Guest Star Guest Update', 'Channel Guest Star Settings Update'])

## Manage Guest Star for your channel.
static var CHANNEL_MANAGE_GUEST_STAR := TwitchingScopes.new("channel:manage:guest_star", "Manage Guest Star for your channel.", ['Update Channel Guest Star Settings', 'Create Guest Star Session', 'End Guest Star Session', 'Send Guest Star Invite', 'Delete Guest Star Invite', 'Assign Guest Star Slot', 'Update Guest Star Slot', 'Delete Guest Star Slot', 'Update Guest Star Slot Settings'], ['Channel Guest Star Session Begin', 'Channel Guest Star Session End', 'Channel Guest Star Guest Update', 'Channel Guest Star Settings Update'])

## View Hype Train information for a channel.
static var CHANNEL_READ_HYPE_TRAIN := TwitchingScopes.new("channel:read:hype_train", "View Hype Train information for a channel.", ['Get Hype Train Events'], ['Hype Train Begin', 'Hype Train Progress', 'Hype Train End'])

## Add or remove the moderator role from users in your channel.
static var CHANNEL_MANAGE_MODERATORS := TwitchingScopes.new("channel:manage:moderators", "Add or remove the moderator role from users in your channel.", ['Add Channel Moderator', 'Remove Channel Moderator', 'Get Moderators'], [])

## View a channel’s polls.
static var CHANNEL_READ_POLLS := TwitchingScopes.new("channel:read:polls", "View a channel’s polls.", ['Get Polls'], ['Channel Poll Begin', 'Channel Poll Progress', 'Channel Poll End'])

## Manage a channel’s polls.
static var CHANNEL_MANAGE_POLLS := TwitchingScopes.new("channel:manage:polls", "Manage a channel’s polls.", ['Get Polls', 'Create Poll', 'End Poll'], ['Channel Poll Begin', 'Channel Poll Progress', 'Channel Poll End'])

## View a channel’s Channel Points Predictions.
static var CHANNEL_READ_PREDICTIONS := TwitchingScopes.new("channel:read:predictions", "View a channel’s Channel Points Predictions.", ['Get Channel Points Predictions'], ['Channel Prediction Begin', 'Channel Prediction Progress', 'Channel Prediction Lock', 'Channel Prediction End'])

## Manage of channel’s Channel Points Predictions
static var CHANNEL_MANAGE_PREDICTIONS := TwitchingScopes.new("channel:manage:predictions", "Manage of channel’s Channel Points Predictions", ['Get Channel Points Predictions', 'Create Channel Points Prediction', 'End Channel Points Prediction'], ['Channel Prediction Begin', 'Channel Prediction Progress', 'Channel Prediction Lock', 'Channel Prediction End'])

## Manage a channel raiding another channel.
static var CHANNEL_MANAGE_RAIDS := TwitchingScopes.new("channel:manage:raids", "Manage a channel raiding another channel.", ['Start a raid', 'Cancel a raid'], [])

## View Channel Points custom rewards and their redemptions on a channel.
static var CHANNEL_READ_REDEMPTIONS := TwitchingScopes.new("channel:read:redemptions", "View Channel Points custom rewards and their redemptions on a channel.", ['Get Custom Reward', 'Get Custom Reward Redemption'], ['Channel Points Automatic Reward Redemption', 'Channel Points Custom Reward Add', 'Channel Points Custom Reward Update', 'Channel Points Custom Reward Remove', 'Channel Points Custom Reward Redemption Add', 'Channel Points Custom Reward Redemption Update'])

## Manage Channel Points custom rewards and their redemptions on a channel.
static var CHANNEL_MANAGE_REDEMPTIONS := TwitchingScopes.new("channel:manage:redemptions", "Manage Channel Points custom rewards and their redemptions on a channel.", ['Get Custom Reward', 'Get Custom Reward Redemption', 'Create Custom Rewards', 'Delete Custom Reward', 'Update Custom Reward', 'Update Redemption Status'], ['Channel Points Automatic Reward Redemption', 'Channel Points Custom Reward Add', 'Channel Points Custom Reward Update', 'Channel Points Custom Reward Remove', 'Channel Points Custom Reward Redemption Add', 'Channel Points Custom Reward Redemption Update'])

## Manage a channel’s stream schedule.
static var CHANNEL_MANAGE_SCHEDULE := TwitchingScopes.new("channel:manage:schedule", "Manage a channel’s stream schedule.", ['Update Channel Stream Schedule', 'Create Channel Stream Schedule Segment', 'Update Channel Stream Schedule Segment', 'Delete Channel Stream Schedule Segment'], [])

## View an authorized user’s stream key.
static var CHANNEL_READ_STREAM_KEY := TwitchingScopes.new("channel:read:stream_key", "View an authorized user’s stream key.", ['Get Stream Key'], [])

## View a list of all subscribers to a channel and check if a user is subscribed to a channel.
static var CHANNEL_READ_SUBSCRIPTIONS := TwitchingScopes.new("channel:read:subscriptions", "View a list of all subscribers to a channel and check if a user is subscribed to a channel.", ['Get Broadcaster Subscriptions'], ['Channel Subscribe', 'Channel Subscription End', 'Channel Subscription Gift', 'Channel Subscription Message'])

## Manage a channel’s videos, including deleting videos.
static var CHANNEL_MANAGE_VIDEOS := TwitchingScopes.new("channel:manage:videos", "Manage a channel’s videos, including deleting videos.", ['Delete Videos'], [])

## Read the list of VIPs in your channel.
static var CHANNEL_READ_VIPS := TwitchingScopes.new("channel:read:vips", "Read the list of VIPs in your channel.", ['Get VIPs'], ['Channel VIP Add', 'Channel VIP Remove'])

## Add or remove the VIP role from users in your channel.
static var CHANNEL_MANAGE_VIPS := TwitchingScopes.new("channel:manage:vips", "Add or remove the VIP role from users in your channel.", ['Get VIPs', 'Add Channel VIP', 'Remove Channel VIP'], ['Channel VIP Add', 'Channel VIP Remove'])

## Manage Clips for a channel.
static var CLIPS_EDIT := TwitchingScopes.new("clips:edit", "Manage Clips for a channel.", ['Create Clip'], [])

## View a channel’s moderation data including Moderators, Bans, Timeouts, and Automod settings.
static var MODERATION_READ := TwitchingScopes.new("moderation:read", "View a channel’s moderation data including Moderators, Bans, Timeouts, and Automod settings.", ['Check AutoMod Status', 'Get Banned Users', 'Get Moderators'], ['Channel Moderator Add', 'Channel Moderator Remove'])

## Send announcements in channels where you have the moderator role.
static var MODERATOR_MANAGE_ANNOUNCEMENTS := TwitchingScopes.new("moderator:manage:announcements", "Send announcements in channels where you have the moderator role.", ['Send Chat Announcement'], [])

## Manage messages held for review by AutoMod in channels where you are a moderator.
static var MODERATOR_MANAGE_AUTOMOD := TwitchingScopes.new("moderator:manage:automod", "Manage messages held for review by AutoMod in channels where you are a moderator.", ['Manage Held AutoMod Messages'], ['AutoMod Message Hold', 'AutoMod Message Update', 'AutoMod Terms Update'])

## View a broadcaster’s AutoMod settings.
static var MODERATOR_READ_AUTOMOD_SETTINGS := TwitchingScopes.new("moderator:read:automod_settings", "View a broadcaster’s AutoMod settings.", ['Get AutoMod Settings'], ['AutoMod Settings Update'])

## Manage a broadcaster’s AutoMod settings.
static var MODERATOR_MANAGE_AUTOMOD_SETTINGS := TwitchingScopes.new("moderator:manage:automod_settings", "Manage a broadcaster’s AutoMod settings.", ['Update AutoMod Settings'], [])

## Read the list of bans or unbans in channels where you have the moderator role.
static var MODERATOR_READ_BANNED_USERS := TwitchingScopes.new("moderator:read:banned_users", "Read the list of bans or unbans in channels where you have the moderator role.", [], ['Channel Moderate', 'Channel Moderate v2'])

## Ban and unban users.
static var MODERATOR_MANAGE_BANNED_USERS := TwitchingScopes.new("moderator:manage:banned_users", "Ban and unban users.", ['Get Banned Users', 'Ban User', 'Unban User'], ['Channel Moderate', 'Channel Moderate v2'])

## View a broadcaster’s list of blocked terms.
static var MODERATOR_READ_BLOCKED_TERMS := TwitchingScopes.new("moderator:read:blocked_terms", "View a broadcaster’s list of blocked terms.", ['Get Blocked Terms'], ['Channel Moderate'])

## Read deleted chat messages in channels where you have the moderator role.
static var MODERATOR_READ_CHAT_MESSAGES := TwitchingScopes.new("moderator:read:chat_messages", "Read deleted chat messages in channels where you have the moderator role.", [], ['Channel Moderate'])

## Manage a broadcaster’s list of blocked terms.
static var MODERATOR_MANAGE_BLOCKED_TERMS := TwitchingScopes.new("moderator:manage:blocked_terms", "Manage a broadcaster’s list of blocked terms.", ['Get Blocked Terms', 'Add Blocked Term', 'Remove Blocked Term'], ['Channel Moderate'])

## Delete chat messages in channels where you have the moderator role
static var MODERATOR_MANAGE_CHAT_MESSAGES := TwitchingScopes.new("moderator:manage:chat_messages", "Delete chat messages in channels where you have the moderator role", ['Delete Chat Messages'], ['Channel Moderate'])

## View a broadcaster’s chat room settings.
static var MODERATOR_READ_CHAT_SETTINGS := TwitchingScopes.new("moderator:read:chat_settings", "View a broadcaster’s chat room settings.", ['Get Chat Settings'], ['Channel Moderate'])

## Manage a broadcaster’s chat room settings.
static var MODERATOR_MANAGE_CHAT_SETTINGS := TwitchingScopes.new("moderator:manage:chat_settings", "Manage a broadcaster’s chat room settings.", ['Update Chat Settings'], ['Channel Moderate'])

## View the chatters in a broadcaster’s chat room.
static var MODERATOR_READ_CHATTERS := TwitchingScopes.new("moderator:read:chatters", "View the chatters in a broadcaster’s chat room.", ['Get Chatters'], [])

## Read the followers of a broadcaster.
static var MODERATOR_READ_FOLLOWERS := TwitchingScopes.new("moderator:read:followers", "Read the followers of a broadcaster.", ['Get Channel Followers'], ['Channel Follow'])

## Read Guest Star details for channels where you are a Guest Star moderator.
static var MODERATOR_READ_GUEST_STAR := TwitchingScopes.new("moderator:read:guest_star", "Read Guest Star details for channels where you are a Guest Star moderator.", ['Get Channel Guest Star Settings', 'Get Guest Star Session', 'Get Guest Star Invites'], ['Channel Guest Star Session Begin', 'Channel Guest Star Session End', 'Channel Guest Star Guest Update', 'Channel Guest Star Settings Update'])

## Manage Guest Star for channels where you are a Guest Star moderator.
static var MODERATOR_MANAGE_GUEST_STAR := TwitchingScopes.new("moderator:manage:guest_star", "Manage Guest Star for channels where you are a Guest Star moderator.", ['Send Guest Star Invite', 'Delete Guest Star Invite', 'Assign Guest Star Slot', 'Update Guest Star Slot', 'Delete Guest Star Slot', 'Update Guest Star Slot Settings'], ['Channel Guest Star Session Begin', 'Channel Guest Star Session End', 'Channel Guest Star Guest Update', 'Channel Guest Star Settings Update'])

## Read the list of moderators in channels where you have the moderator role.
static var MODERATOR_READ_MODERATORS := TwitchingScopes.new("moderator:read:moderators", "Read the list of moderators in channels where you have the moderator role.", [], ['Channel Moderate', 'Channel Moderate v2'])

## View a broadcaster’s Shield Mode status.
static var MODERATOR_READ_SHIELD_MODE := TwitchingScopes.new("moderator:read:shield_mode", "View a broadcaster’s Shield Mode status.", ['Get Shield Mode Status'], ['Shield Mode Begin', 'Shield Mode End'])

## Manage a broadcaster’s Shield Mode status.
static var MODERATOR_MANAGE_SHIELD_MODE := TwitchingScopes.new("moderator:manage:shield_mode", "Manage a broadcaster’s Shield Mode status.", ['Update Shield Mode Status'], ['Shield Mode Begin', 'Shield Mode End'])

## View a broadcaster’s shoutouts.
static var MODERATOR_READ_SHOUTOUTS := TwitchingScopes.new("moderator:read:shoutouts", "View a broadcaster’s shoutouts.", [], ['Shoutout Create', 'Shoutout Received'])

## Manage a broadcaster’s shoutouts.
static var MODERATOR_MANAGE_SHOUTOUTS := TwitchingScopes.new("moderator:manage:shoutouts", "Manage a broadcaster’s shoutouts.", ['Send a Shoutout'], ['Shoutout Create', 'Shoutout Received'])

## Read chat messages from suspicious users and see users flagged as suspicious in channels where you have the moderator role.
static var MODERATOR_READ_SUSPICIOUS_USERS := TwitchingScopes.new("moderator:read:suspicious_users", "Read chat messages from suspicious users and see users flagged as suspicious in channels where you have the moderator role.", [], ['Channel Suspicious User Message', 'Channel Suspicious User Update'])

## View a broadcaster’s unban requests.
static var MODERATOR_READ_UNBAN_REQUESTS := TwitchingScopes.new("moderator:read:unban_requests", "View a broadcaster’s unban requests.", ['Get Unban Requests'], ['Channel Unban Request Create', 'Channel Unban Request Resolve', 'Channel Moderate'])

## Manage a broadcaster’s unban requests.
static var MODERATOR_MANAGE_UNBAN_REQUESTS := TwitchingScopes.new("moderator:manage:unban_requests", "Manage a broadcaster’s unban requests.", ['Resolve Unban Requests'], ['Channel Unban Request Create', 'Channel Unban Request Resolve', 'Channel Moderate'])

## Read the list of VIPs in channels where you have the moderator role.
static var MODERATOR_READ_VIPS := TwitchingScopes.new("moderator:read:vips", "Read the list of VIPs in channels where you have the moderator role.", [], ['Channel Moderate', 'Channel Moderate v2'])

## Read warnings in channels where you have the moderator role.
static var MODERATOR_READ_WARNINGS := TwitchingScopes.new("moderator:read:warnings", "Read warnings in channels where you have the moderator role.", [], ['Channel Moderate v2', 'Channel Warning Acknowledge', 'Channel Warning Send'])

## Warn users in channels where you have the moderator role.
static var MODERATOR_MANAGE_WARNINGS := TwitchingScopes.new("moderator:manage:warnings", "Warn users in channels where you have the moderator role.", ['Warn Chat User'], ['Channel Moderate v2', 'Channel Warning Acknowledge', 'Channel Warning Send'])

## Join a specified chat channel as your user and appear as a bot, and perform chat-related actions as your user.
static var USER_BOT := TwitchingScopes.new("user:bot", "Join a specified chat channel as your user and appear as a bot, and perform chat-related actions as your user.", ['Send Chat Message'], ['Channel Chat Clear', 'Channel Chat Clear User Messages', 'Channel Chat Message', 'Channel Chat Message Delete', 'Channel Chat Notification', 'Channel Chat Settings Update', 'Channel Chat User Message Hold', 'Channel Chat User Message Update'])

## Manage a user object.
static var USER_EDIT := TwitchingScopes.new("user:edit", "Manage a user object.", ['Update User'], [])

## View and edit a user’s broadcasting configuration, including Extension configurations.
static var USER_EDIT_BROADCAST := TwitchingScopes.new("user:edit:broadcast", "View and edit a user’s broadcasting configuration, including Extension configurations.", ['Get User Extensions', 'Get User Active Extensions', 'Update User Extensions'], [])

## View the block list of a user.
static var USER_READ_BLOCKED_USERS := TwitchingScopes.new("user:read:blocked_users", "View the block list of a user.", ['Get User Block List'], [])

## Manage the block list of a user.
static var USER_MANAGE_BLOCKED_USERS := TwitchingScopes.new("user:manage:blocked_users", "Manage the block list of a user.", ['Block User', 'Unblock User'], [])

## View a user’s broadcasting configuration, including Extension configurations.
static var USER_READ_BROADCAST := TwitchingScopes.new("user:read:broadcast", "View a user’s broadcasting configuration, including Extension configurations.", ['Get Stream Markers', 'Get User Extensions', 'Get User Active Extensions'], [])

## Receive chatroom messages and informational notifications relating to a channel’s chatroom.
static var USER_READ_CHAT := TwitchingScopes.new("user:read:chat", "Receive chatroom messages and informational notifications relating to a channel’s chatroom.", [], ['Channel Chat Clear', 'Channel Chat Clear User Messages', 'Channel Chat Message', 'Channel Chat Message Delete', 'Channel Chat Notification', 'Channel Chat Settings Update', 'Channel Chat User Message Hold', 'Channel Chat User Message Update'])

## Update the color used for the user’s name in chat.
static var USER_MANAGE_CHAT_COLOR := TwitchingScopes.new("user:manage:chat_color", "Update the color used for the user’s name in chat.", ['Update User Chat Color'], [])

## View a user’s email address.
static var USER_READ_EMAIL := TwitchingScopes.new("user:read:email", "View a user’s email address.", ['Get Users', '(optional)', 'Update User', '(optional)'], ['User Update', '(optional)'])

## View emotes available to a user
static var USER_READ_EMOTES := TwitchingScopes.new("user:read:emotes", "View emotes available to a user", ['Get User Emotes'], [])

## View the list of channels a user follows.
static var USER_READ_FOLLOWS := TwitchingScopes.new("user:read:follows", "View the list of channels a user follows.", ['Get Followed Channels', 'Get Followed Streams'], [])

## Read the list of channels you have moderator privileges in.
static var USER_READ_MODERATED_CHANNELS := TwitchingScopes.new("user:read:moderated_channels", "Read the list of channels you have moderator privileges in.", ['Get Moderated Channels'], [])

## View if an authorized user is subscribed to specific channels.
static var USER_READ_SUBSCRIPTIONS := TwitchingScopes.new("user:read:subscriptions", "View if an authorized user is subscribed to specific channels.", ['Check User Subscription'], [])

## Receive whispers sent to your user.
static var USER_READ_WHISPERS := TwitchingScopes.new("user:read:whispers", "Receive whispers sent to your user.", [], ['Whisper Received'])

## Receive whispers sent to your user, and send whispers on your user’s behalf.
static var USER_MANAGE_WHISPERS := TwitchingScopes.new("user:manage:whispers", "Receive whispers sent to your user, and send whispers on your user’s behalf.", ['Send Whisper'], ['Whisper Received'])

## Send chat messages to a chatroom.
static var USER_WRITE_CHAT := TwitchingScopes.new("user:write:chat", "Send chat messages to a chatroom.", ['Send Chat Message'], [])
