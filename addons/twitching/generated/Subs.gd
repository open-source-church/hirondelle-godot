extends Node
class_name TwitchingSubs

## Autogenerated list of subscription types.
##
## Used to create twitch EventSub subscriptions.[br]
## Use with one of the static vars.[br]
## [codeblock]
## var condition = TChannelChatMessageCondition.new()
## condition.broadcaster_user_id = "499044140"
## condition.user_id = "499044140"
## await TwitchingSubs.CHANNEL_CHAT_MESSAGE.subscribe(condition)
## [/codeblock]
## You can also write:
## [codeblock]
## var condition = TChannelChatMessageCondition.create("499044140", "499044140")
## await TwitchingSubs.CHANNEL_CHAT_MESSAGE.subscribe(condition)
## [/codeblock]
## [b]Signals[/b]
## Connect signals like that:
## [codeblock]
## # Called for a specific event
## TwitchingSubs.CHANNEL_CHAT_MESSAGE.event.connect()
## # Called for all events
## TwitchingSubs.event.connect()
## [/codeblock]

var twitching: Twitching

## Parse websocket notification message.[br]
## See: https://dev.twitch.tv/docs/eventsub/handling-websocket-events/#notification-message
func parse_event(msg: Dictionary) -> TBaseType:
	var _type = msg["metadata"]["subscription_type"]
	var _version = msg["metadata"]["subscription_version"]
	var _event_obj = msg["payload"]["event"]

	var sub: TSubs.Sub = TSubs.Sub._all.filter(func (s): return s.type == _type)[0]
	var _event = sub.payload_class.from_object(_event_obj)

	# Emit signals
	event.emit(_type, _version, _event)
	sub.event.emit(_event)

	return _event

signal event(type:String, version: String, event: TBaseType)

func _init(_twitching: Twitching):
	twitching = _twitching

	AUTOMOD_MESSAGE_HOLD = TSubs.AutomodMessageHold.new(twitching)
	AUTOMOD_MESSAGE_HOLD_V2 = TSubs.AutomodMessageHoldV2.new(twitching)
	AUTOMOD_MESSAGE_UPDATE = TSubs.AutomodMessageUpdate.new(twitching)
	AUTOMOD_MESSAGE_UPDATE_V2 = TSubs.AutomodMessageUpdateV2.new(twitching)
	AUTOMOD_SETTINGS_UPDATE = TSubs.AutomodSettingsUpdate.new(twitching)
	AUTOMOD_TERMS_UPDATE = TSubs.AutomodTermsUpdate.new(twitching)
	CHANNEL_UPDATE = TSubs.ChannelUpdate.new(twitching)
	CHANNEL_FOLLOW = TSubs.ChannelFollow.new(twitching)
	CHANNEL_AD_BREAK_BEGIN = TSubs.ChannelAdBreakBegin.new(twitching)
	CHANNEL_CHAT_CLEAR = TSubs.ChannelChatClear.new(twitching)
	CHANNEL_CHAT_CLEAR_USER_MESSAGES = TSubs.ChannelChatClearUserMessages.new(twitching)
	CHANNEL_CHAT_MESSAGE = TSubs.ChannelChatMessage.new(twitching)
	CHANNEL_CHAT_MESSAGE_DELETE = TSubs.ChannelChatMessageDelete.new(twitching)
	CHANNEL_CHAT_NOTIFICATION = TSubs.ChannelChatNotification.new(twitching)
	CHANNEL_CHAT_SETTINGS_UPDATE = TSubs.ChannelChatSettingsUpdate.new(twitching)
	CHANNEL_CHAT_USER_MESSAGE_HOLD = TSubs.ChannelChatUserMessageHold.new(twitching)
	CHANNEL_CHAT_USER_MESSAGE_UPDATE = TSubs.ChannelChatUserMessageUpdate.new(twitching)
	CHANNEL_SHARED_CHAT_SESSION_BEGIN = TSubs.ChannelSharedChatSessionBegin.new(twitching)
	CHANNEL_SHARED_CHAT_SESSION_UPDATE = TSubs.ChannelSharedChatSessionUpdate.new(twitching)
	CHANNEL_SHARED_CHAT_SESSION_END = TSubs.ChannelSharedChatSessionEnd.new(twitching)
	CHANNEL_SUBSCRIBE = TSubs.ChannelSubscribe.new(twitching)
	CHANNEL_SUBSCRIPTION_END = TSubs.ChannelSubscriptionEnd.new(twitching)
	CHANNEL_SUBSCRIPTION_GIFT = TSubs.ChannelSubscriptionGift.new(twitching)
	CHANNEL_SUBSCRIPTION_MESSAGE = TSubs.ChannelSubscriptionMessage.new(twitching)
	CHANNEL_CHEER = TSubs.ChannelCheer.new(twitching)
	CHANNEL_RAID = TSubs.ChannelRaid.new(twitching)
	CHANNEL_BAN = TSubs.ChannelBan.new(twitching)
	CHANNEL_UNBAN = TSubs.ChannelUnban.new(twitching)
	CHANNEL_UNBAN_REQUEST_CREATE = TSubs.ChannelUnbanRequestCreate.new(twitching)
	CHANNEL_UNBAN_REQUEST_RESOLVE = TSubs.ChannelUnbanRequestResolve.new(twitching)
	CHANNEL_MODERATE = TSubs.ChannelModerate.new(twitching)
	CHANNEL_MODERATE_V2 = TSubs.ChannelModerateV2.new(twitching)
	CHANNEL_MODERATOR_ADD = TSubs.ChannelModeratorAdd.new(twitching)
	CHANNEL_MODERATOR_REMOVE = TSubs.ChannelModeratorRemove.new(twitching)
	CHANNEL_GUEST_STAR_SESSION_BEGIN = TSubs.ChannelGuestStarSessionBegin.new(twitching)
	CHANNEL_GUEST_STAR_SESSION_END = TSubs.ChannelGuestStarSessionEnd.new(twitching)
	CHANNEL_GUEST_STAR_GUEST_UPDATE = TSubs.ChannelGuestStarGuestUpdate.new(twitching)
	CHANNEL_GUEST_STAR_SETTINGS_UPDATE = TSubs.ChannelGuestStarSettingsUpdate.new(twitching)
	CHANNEL_POINTS_AUTOMATIC_REWARD_REDEMPTION = TSubs.ChannelPointsAutomaticRewardRedemption.new(twitching)
	CHANNEL_POINTS_CUSTOM_REWARD_ADD = TSubs.ChannelPointsCustomRewardAdd.new(twitching)
	CHANNEL_POINTS_CUSTOM_REWARD_UPDATE = TSubs.ChannelPointsCustomRewardUpdate.new(twitching)
	CHANNEL_POINTS_CUSTOM_REWARD_REMOVE = TSubs.ChannelPointsCustomRewardRemove.new(twitching)
	CHANNEL_POINTS_CUSTOM_REWARD_REDEMPTION_ADD = TSubs.ChannelPointsCustomRewardRedemptionAdd.new(twitching)
	CHANNEL_POINTS_CUSTOM_REWARD_REDEMPTION_UPDATE = TSubs.ChannelPointsCustomRewardRedemptionUpdate.new(twitching)
	CHANNEL_POLL_BEGIN = TSubs.ChannelPollBegin.new(twitching)
	CHANNEL_POLL_PROGRESS = TSubs.ChannelPollProgress.new(twitching)
	CHANNEL_POLL_END = TSubs.ChannelPollEnd.new(twitching)
	CHANNEL_PREDICTION_BEGIN = TSubs.ChannelPredictionBegin.new(twitching)
	CHANNEL_PREDICTION_PROGRESS = TSubs.ChannelPredictionProgress.new(twitching)
	CHANNEL_PREDICTION_LOCK = TSubs.ChannelPredictionLock.new(twitching)
	CHANNEL_PREDICTION_END = TSubs.ChannelPredictionEnd.new(twitching)
	CHANNEL_SUSPICIOUS_USER_MESSAGE = TSubs.ChannelSuspiciousUserMessage.new(twitching)
	CHANNEL_SUSPICIOUS_USER_UPDATE = TSubs.ChannelSuspiciousUserUpdate.new(twitching)
	CHANNEL_VIP_ADD = TSubs.ChannelVipAdd.new(twitching)
	CHANNEL_VIP_REMOVE = TSubs.ChannelVipRemove.new(twitching)
	CHANNEL_WARNING_ACKNOWLEDGEMENT = TSubs.ChannelWarningAcknowledgement.new(twitching)
	CHANNEL_WARNING_SEND = TSubs.ChannelWarningSend.new(twitching)
	CHARITY_DONATION = TSubs.CharityDonation.new(twitching)
	CHARITY_CAMPAIGN_START = TSubs.CharityCampaignStart.new(twitching)
	CHARITY_CAMPAIGN_PROGRESS = TSubs.CharityCampaignProgress.new(twitching)
	CHARITY_CAMPAIGN_STOP = TSubs.CharityCampaignStop.new(twitching)
	CONDUIT_SHARD_DISABLED = TSubs.ConduitShardDisabled.new(twitching)
	DROP_ENTITLEMENT_GRANT = TSubs.DropEntitlementGrant.new(twitching)
	EXTENSION_BITS_TRANSACTION_CREATE = TSubs.ExtensionBitsTransactionCreate.new(twitching)
	GOAL_BEGIN = TSubs.GoalBegin.new(twitching)
	GOAL_PROGRESS = TSubs.GoalProgress.new(twitching)
	GOAL_END = TSubs.GoalEnd.new(twitching)
	HYPE_TRAIN_BEGIN = TSubs.HypeTrainBegin.new(twitching)
	HYPE_TRAIN_PROGRESS = TSubs.HypeTrainProgress.new(twitching)
	HYPE_TRAIN_END = TSubs.HypeTrainEnd.new(twitching)
	SHIELD_MODE_BEGIN = TSubs.ShieldModeBegin.new(twitching)
	SHIELD_MODE_END = TSubs.ShieldModeEnd.new(twitching)
	SHOUTOUT_CREATE = TSubs.ShoutoutCreate.new(twitching)
	SHOUTOUT_RECEIVED = TSubs.ShoutoutReceived.new(twitching)
	STREAM_ONLINE = TSubs.StreamOnline.new(twitching)
	STREAM_OFFLINE = TSubs.StreamOffline.new(twitching)
	USER_AUTHORIZATION_GRANT = TSubs.UserAuthorizationGrant.new(twitching)
	USER_AUTHORIZATION_REVOKE = TSubs.UserAuthorizationRevoke.new(twitching)
	USER_UPDATE = TSubs.UserUpdate.new(twitching)
	WHISPER_RECEIVED = TSubs.WhisperReceived.new(twitching)

## A user is notified if a message is caught by automod for review.[br]
## See [TAutomodMessageHoldCondition] and [TAutomodMessageHoldEvent].
var AUTOMOD_MESSAGE_HOLD : TSubs.AutomodMessageHold

## A user is notified if a message is caught by automod for review.  Only public blocked terms trigger notifications, not private ones.[br]
## See [TAutomodMessageHoldCondition] and [TAutomodMessageHoldEventV2].
var AUTOMOD_MESSAGE_HOLD_V2 : TSubs.AutomodMessageHoldV2

## A message in the automod queue had its status changed.[br]
## See [TAutomodMessageUpdateCondition] and [TAutomodMessageUpdateEvent].
var AUTOMOD_MESSAGE_UPDATE : TSubs.AutomodMessageUpdate

## A message in the automod queue had its status changed. Only public blocked terms trigger notifications, not private ones.[br]
## See [TAutomodMessageUpdateCondition] and [TAutomodMessageUpdateEventV2].
var AUTOMOD_MESSAGE_UPDATE_V2 : TSubs.AutomodMessageUpdateV2

## A notification is sent when a broadcaster’s automod settings are updated.[br]
## See [TAutomodSettingsUpdateCondition] and [TAutomodSettingsUpdateEvent].
var AUTOMOD_SETTINGS_UPDATE : TSubs.AutomodSettingsUpdate

## A notification is sent when a broadcaster’s automod terms are updated. Changes to private terms are not sent.[br]
## See [TAutomodTermsUpdateCondition] and [TAutomodTermsUpdateEvent].
var AUTOMOD_TERMS_UPDATE : TSubs.AutomodTermsUpdate

## A broadcaster updates their channel properties e.g., category, title, content classification labels, broadcast, or language.[br]
## See [TChannelUpdateCondition] and [TChannelUpdateEvent].
var CHANNEL_UPDATE : TSubs.ChannelUpdate

## A specified channel receives a follow.[br]
## See [TChannelFollowCondition] and [TChannelFollowEvent].
var CHANNEL_FOLLOW : TSubs.ChannelFollow

## A midroll commercial break has started running.[br]
## See [TChannelAdBreakBeginCondition] and [TChannelAdBreakBeginEvent].
var CHANNEL_AD_BREAK_BEGIN : TSubs.ChannelAdBreakBegin

## A moderator or bot has cleared all messages from the chat room.[br]
## See [TChannelChatClearCondition] and [TChannelChatClearEvent].
var CHANNEL_CHAT_CLEAR : TSubs.ChannelChatClear

## A moderator or bot has cleared all messages from a specific user.[br]
## See [TChannelChatClearUserMessagesCondition] and [TChannelChatClearUserMessagesEvent].
var CHANNEL_CHAT_CLEAR_USER_MESSAGES : TSubs.ChannelChatClearUserMessages

## Any user sends a message to a specific chat room.[br]
## See [TChannelChatMessageCondition] and [TChannelChatMessageEvent].
var CHANNEL_CHAT_MESSAGE : TSubs.ChannelChatMessage

## A moderator has removed a specific message.[br]
## See [TChannelChatMessageDeleteCondition] and [TChannelChatMessageDeleteEvent].
var CHANNEL_CHAT_MESSAGE_DELETE : TSubs.ChannelChatMessageDelete

## A notification for when an event that appears in chat has occurred.[br]
## See [TChannelChatNotificationCondition] and [TChannelChatNotificationEvent].
var CHANNEL_CHAT_NOTIFICATION : TSubs.ChannelChatNotification

## A notification for when a broadcaster’s chat settings are updated.[br]
## See [TChannelChatSettingsUpdateCondition] and [TChannelChatSettingsUpdateEvent].
var CHANNEL_CHAT_SETTINGS_UPDATE : TSubs.ChannelChatSettingsUpdate

## A user is notified if their message is caught by automod.[br]
## See [TChannelChatUserMessageHoldCondition] and [TChannelChatUserMessageHoldEvent].
var CHANNEL_CHAT_USER_MESSAGE_HOLD : TSubs.ChannelChatUserMessageHold

## A user is notified if their message’s automod status is updated.[br]
## See [TChannelChatUserMessageUpdateCondition] and [TChannelChatUserMessageUpdateEvent].
var CHANNEL_CHAT_USER_MESSAGE_UPDATE : TSubs.ChannelChatUserMessageUpdate

## A notification when a channel becomes active in an active shared chat session.[br]
## See [TChannelSharedChatSessionBeginCondition] and [TChannelSharedChatSessionBeginEvent].
var CHANNEL_SHARED_CHAT_SESSION_BEGIN : TSubs.ChannelSharedChatSessionBegin

## A notification when the active shared chat session the channel is in changes.[br]
## See [TChannelSharedChatSessionUpdateCondition] and [TChannelSharedChatSessionUpdateEvent].
var CHANNEL_SHARED_CHAT_SESSION_UPDATE : TSubs.ChannelSharedChatSessionUpdate

## A notification when a channel leaves a shared chat session or the session ends.[br]
## See [TChannelSharedChatSessionEndCondition] and [TChannelSharedChatSessionEndEvent].
var CHANNEL_SHARED_CHAT_SESSION_END : TSubs.ChannelSharedChatSessionEnd

## A notification is sent when a specified channel receives a subscriber. This does not include resubscribes.[br]
## See [TChannelSubscribeCondition] and [TChannelSubscribeEvent].
var CHANNEL_SUBSCRIBE : TSubs.ChannelSubscribe

## A notification when a subscription to the specified channel ends.[br]
## See [TChannelSubscriptionEndCondition] and [TChannelSubscriptionEndEvent].
var CHANNEL_SUBSCRIPTION_END : TSubs.ChannelSubscriptionEnd

## A notification when a viewer gives a gift subscription to one or more users in the specified channel.[br]
## See [TChannelSubscriptionGiftCondition] and [TChannelSubscriptionGiftEvent].
var CHANNEL_SUBSCRIPTION_GIFT : TSubs.ChannelSubscriptionGift

## A notification when a user sends a resubscription chat message in a specific channel.[br]
## See [TChannelSubscriptionMessageCondition] and [TChannelSubscriptionMessageEvent].
var CHANNEL_SUBSCRIPTION_MESSAGE : TSubs.ChannelSubscriptionMessage

## A user cheers on the specified channel.[br]
## See [TChannelCheerCondition] and [TChannelCheerEvent].
var CHANNEL_CHEER : TSubs.ChannelCheer

## A broadcaster raids another broadcaster’s channel.[br]
## See [TChannelRaidCondition] and [TChannelRaidEvent].
var CHANNEL_RAID : TSubs.ChannelRaid

## A viewer is banned from the specified channel.[br]
## See [TChannelBanCondition] and [TChannelBanEvent].
var CHANNEL_BAN : TSubs.ChannelBan

## A viewer is unbanned from the specified channel.[br]
## See [TChannelUnbanCondition] and [TChannelUnbanEvent].
var CHANNEL_UNBAN : TSubs.ChannelUnban

## A user creates an unban request.[br]
## See [TChannelUnbanRequestCreateCondition] and [TChannelUnbanRequestCreateEvent].
var CHANNEL_UNBAN_REQUEST_CREATE : TSubs.ChannelUnbanRequestCreate

## An unban request has been resolved.[br]
## See [TChannelUnbanRequestResolveCondition] and [TChannelUnbanRequestResolveEvent].
var CHANNEL_UNBAN_REQUEST_RESOLVE : TSubs.ChannelUnbanRequestResolve

## A moderator performs a moderation action in a channel.[br]
## See [TChannelModerateCondition] and [TChannelModerateEvent].
var CHANNEL_MODERATE : TSubs.ChannelModerate

## A moderator performs a moderation action in a channel. Includes warnings.[br]
## See [TChannelModerateV2Condition] and [TChannelModerateEventV2].
var CHANNEL_MODERATE_V2 : TSubs.ChannelModerateV2

## Moderator privileges were added to a user on a specified channel.[br]
## See [TChannelModeratorAddCondition] and [TChannelModeratorAddEvent].
var CHANNEL_MODERATOR_ADD : TSubs.ChannelModeratorAdd

## Moderator privileges were removed from a user on a specified channel.[br]
## See [TChannelModeratorRemoveCondition] and [TChannelModeratorRemoveEvent].
var CHANNEL_MODERATOR_REMOVE : TSubs.ChannelModeratorRemove

## The host began a new Guest Star session.[br]
## See [TChannelGuestStarSessionBeginCondition] and [TChannelGuestStarSessionBeginEvent].
var CHANNEL_GUEST_STAR_SESSION_BEGIN : TSubs.ChannelGuestStarSessionBegin

## A running Guest Star session has ended.[br]
## See [TChannelGuestStarSessionEndCondition] and [TChannelGuestStarSessionEndEvent].
var CHANNEL_GUEST_STAR_SESSION_END : TSubs.ChannelGuestStarSessionEnd

## A guest or a slot is updated in an active Guest Star session.[br]
## See [TChannelGuestStarGuestUpdateCondition] and [TChannelGuestStarGuestUpdateEvent].
var CHANNEL_GUEST_STAR_GUEST_UPDATE : TSubs.ChannelGuestStarGuestUpdate

## The host preferences for Guest Star have been updated.[br]
## See [TChannelGuestStarSettingsUpdateCondition] and [TChannelGuestStarSettingsUpdateEvent].
var CHANNEL_GUEST_STAR_SETTINGS_UPDATE : TSubs.ChannelGuestStarSettingsUpdate

## A viewer has redeemed an automatic channel points reward on the specified channel.[br]
## See [TChannelPointsAutomaticRewardRedemptionAddCondition] and [TChannelPointsAutomaticRewardRedemptionAddEvent].
var CHANNEL_POINTS_AUTOMATIC_REWARD_REDEMPTION : TSubs.ChannelPointsAutomaticRewardRedemption

## A custom channel points reward has been created for the specified channel.[br]
## See [TChannelPointsCustomRewardAddCondition] and [TChannelPointsCustomRewardAddEvent].
var CHANNEL_POINTS_CUSTOM_REWARD_ADD : TSubs.ChannelPointsCustomRewardAdd

## A custom channel points reward has been updated for the specified channel.[br]
## See [TChannelPointsCustomRewardUpdateCondition] and [TChannelPointsCustomRewardUpdateEvent].
var CHANNEL_POINTS_CUSTOM_REWARD_UPDATE : TSubs.ChannelPointsCustomRewardUpdate

## A custom channel points reward has been removed from the specified channel.[br]
## See [TChannelPointsCustomRewardRemoveCondition] and [TChannelPointsCustomRewardRemoveEvent].
var CHANNEL_POINTS_CUSTOM_REWARD_REMOVE : TSubs.ChannelPointsCustomRewardRemove

## A viewer has redeemed a custom channel points reward on the specified channel.[br]
## See [TChannelPointsCustomRewardRedemptionAddCondition] and [TChannelPointsCustomRewardRedemptionAddEvent].
var CHANNEL_POINTS_CUSTOM_REWARD_REDEMPTION_ADD : TSubs.ChannelPointsCustomRewardRedemptionAdd

## A redemption of a channel points custom reward has been updated for the specified channel.[br]
## See [TChannelPointsCustomRewardRedemptionUpdateCondition] and [TChannelPointsCustomRewardRedemptionUpdateEvent].
var CHANNEL_POINTS_CUSTOM_REWARD_REDEMPTION_UPDATE : TSubs.ChannelPointsCustomRewardRedemptionUpdate

## A poll started on a specified channel.[br]
## See [TChannelPollBeginCondition] and [TChannelPollBeginEvent].
var CHANNEL_POLL_BEGIN : TSubs.ChannelPollBegin

## Users respond to a poll on a specified channel.[br]
## See [TChannelPollProgressCondition] and [TChannelPollProgressEvent].
var CHANNEL_POLL_PROGRESS : TSubs.ChannelPollProgress

## A poll ended on a specified channel.[br]
## See [TChannelPollEndCondition] and [TChannelPollEndEvent].
var CHANNEL_POLL_END : TSubs.ChannelPollEnd

## A Prediction started on a specified channel.[br]
## See [TChannelPredictionBeginCondition] and [TChannelPredictionBeginEvent].
var CHANNEL_PREDICTION_BEGIN : TSubs.ChannelPredictionBegin

## Users participated in a Prediction on a specified channel.[br]
## See [TChannelPredictionProgressCondition] and [TChannelPredictionProgressEvent].
var CHANNEL_PREDICTION_PROGRESS : TSubs.ChannelPredictionProgress

## A Prediction was locked on a specified channel.[br]
## See [TChannelPredictionLockCondition] and [TChannelPredictionLockEvent].
var CHANNEL_PREDICTION_LOCK : TSubs.ChannelPredictionLock

## A Prediction ended on a specified channel.[br]
## See [TChannelPredictionEndCondition] and [TChannelPredictionEndEvent].
var CHANNEL_PREDICTION_END : TSubs.ChannelPredictionEnd

## A chat message has been sent by a suspicious user.[br]
## See [TChannelSuspiciousUserMessageCondition] and [TChannelSuspiciousUserMessageEvent].
var CHANNEL_SUSPICIOUS_USER_MESSAGE : TSubs.ChannelSuspiciousUserMessage

## A suspicious user has been updated.[br]
## See [TChannelSuspiciousUserUpdateCondition] and [TChannelSuspiciousUserUpdateEvent].
var CHANNEL_SUSPICIOUS_USER_UPDATE : TSubs.ChannelSuspiciousUserUpdate

## A VIP is added to the channel.[br]
## See [TChannelVipAddCondition] and [TChannelVipAddEvent].
var CHANNEL_VIP_ADD : TSubs.ChannelVipAdd

## A VIP is removed from the channel.[br]
## See [TChannelVipRemoveCondition] and [TChannelVipRemoveEvent].
var CHANNEL_VIP_REMOVE : TSubs.ChannelVipRemove

## A user awknowledges a warning. Broadcasters and moderators can see the warning’s details.[br]
## See [TChannelWarningAcknowledgeCondition] and [TChannelWarningAcknowledgeEvent].
var CHANNEL_WARNING_ACKNOWLEDGEMENT : TSubs.ChannelWarningAcknowledgement

## A user is sent a warning. Broadcasters and moderators can see the warning’s details.[br]
## See [TChannelWarningSendCondition] and [TChannelWarningSendEvent].
var CHANNEL_WARNING_SEND : TSubs.ChannelWarningSend

## Sends an event notification when a user donates to the broadcaster’s charity campaign.[br]
## See [TCharityDonationCondition] and [TCharityDonationEvent].
var CHARITY_DONATION : TSubs.CharityDonation

## Sends an event notification when the broadcaster starts a charity campaign.[br]
## See [TCharityCampaignStartCondition] and [TCharityCampaignStartEvent].
var CHARITY_CAMPAIGN_START : TSubs.CharityCampaignStart

## Sends an event notification when progress is made towards the campaign’s goal or when the broadcaster changes the fundraising goal.[br]
## See [TCharityCampaignProgressCondition] and [TCharityCampaignProgressEvent].
var CHARITY_CAMPAIGN_PROGRESS : TSubs.CharityCampaignProgress

## Sends an event notification when the broadcaster stops a charity campaign.[br]
## See [TCharityCampaignStopCondition] and [TCharityCampaignStopEvent].
var CHARITY_CAMPAIGN_STOP : TSubs.CharityCampaignStop

## Sends a notification when EventSub disables a shard due to the status of the underlying transport changing.[br]
## See [TConduitShardDisabledCondition] and [TConduitShardDisabledEvent].
var CONDUIT_SHARD_DISABLED : TSubs.ConduitShardDisabled

## An entitlement for a Drop is granted to a user.[br]
## See [TDropEntitlementGrantCondition] and [TDropEntitlementGrantEvent].
var DROP_ENTITLEMENT_GRANT : TSubs.DropEntitlementGrant

## A Bits transaction occurred for a specified Twitch Extension.[br]
## See [TExtensionBitsTransactionCreateCondition] and [TExtensionBitsTransactionCreateEvent].
var EXTENSION_BITS_TRANSACTION_CREATE : TSubs.ExtensionBitsTransactionCreate

## Get notified when a broadcaster begins a goal.[br]
## See [TGoalsCondition] and [TGoalsEvent].
var GOAL_BEGIN : TSubs.GoalBegin

## Get notified when progress (either positive or negative) is made towards a broadcaster’s goal.[br]
## See [TGoalsCondition] and [TGoalsEvent].
var GOAL_PROGRESS : TSubs.GoalProgress

## Get notified when a broadcaster ends a goal.[br]
## See [TGoalsCondition] and [TGoalsEvent].
var GOAL_END : TSubs.GoalEnd

## A Hype Train begins on the specified channel.[br]
## See [THypeTrainBeginCondition] and [THypeTrainBeginEvent].
var HYPE_TRAIN_BEGIN : TSubs.HypeTrainBegin

## A Hype Train makes progress on the specified channel.[br]
## See [THypeTrainProgressCondition] and [THypeTrainProgressEvent].
var HYPE_TRAIN_PROGRESS : TSubs.HypeTrainProgress

## A Hype Train ends on the specified channel.[br]
## See [THypeTrainEndCondition] and [THypeTrainEndEvent].
var HYPE_TRAIN_END : TSubs.HypeTrainEnd

## Sends a notification when the broadcaster activates Shield Mode.[br]
## See [TShieldModeBeginCondition] and [TShieldMode].
var SHIELD_MODE_BEGIN : TSubs.ShieldModeBegin

## Sends a notification when the broadcaster deactivates Shield Mode.[br]
## See [TShieldModeEndCondition] and [TShieldMode].
var SHIELD_MODE_END : TSubs.ShieldModeEnd

## Sends a notification when the specified broadcaster sends a Shoutout.[br]
## See [TShoutoutCreateCondition] and [TShoutoutCreate].
var SHOUTOUT_CREATE : TSubs.ShoutoutCreate

## Sends a notification when the specified broadcaster receives a Shoutout.[br]
## See [TShoutoutReceivedCondition] and [TShoutoutReceived].
var SHOUTOUT_RECEIVED : TSubs.ShoutoutReceived

## The specified broadcaster starts a stream.[br]
## See [TStreamOnlineCondition] and [TStreamOnlineEvent].
var STREAM_ONLINE : TSubs.StreamOnline

## The specified broadcaster stops a stream.[br]
## See [TStreamOfflineCondition] and [TStreamOfflineEvent].
var STREAM_OFFLINE : TSubs.StreamOffline

## A user’s authorization has been granted to your client id.[br]
## See [TUserAuthorizationGrantCondition] and [TUserAuthorizationGrantEvent].
var USER_AUTHORIZATION_GRANT : TSubs.UserAuthorizationGrant

## A user’s authorization has been revoked for your client id.[br]
## See [TUserAuthorizationRevokeCondition] and [TUserAuthorizationRevokeEvent].
var USER_AUTHORIZATION_REVOKE : TSubs.UserAuthorizationRevoke

## A user has updated their account.[br]
## See [TUserUpdateCondition] and [TUserUpdateEvent].
var USER_UPDATE : TSubs.UserUpdate

## A user receives a whisper.[br]
## See [TWhisperReceivedCondition] and [TWhisperReceivedEvent].
var WHISPER_RECEIVED : TSubs.WhisperReceived

