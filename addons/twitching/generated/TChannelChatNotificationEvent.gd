extends TBaseType
class_name TChannelChatNotificationEvent

## Autogenerated. Do not modify.

## The broadcaster user ID.
var broadcaster_user_id: String

## The broadcaster display name.
var broadcaster_user_name: String

## The broadcaster login.
var broadcaster_user_login: String

## The user ID of the user that sent the message.
var chatter_user_id: String

## The user login of the user that sent the message.
var chatter_user_name: String

## Whether or not the chatter is anonymous.
var chatter_is_anonymous: bool

## The color of the user’s name in the chat room.
var color: String

## The color of the user’s name in the chat room.
var badges: Array[TChannelChatNotificationEventBadges]

## The message Twitch shows in the chat room for this notice.
var system_message: String

## A UUID that identifies the message.
var message_id: String

## The structured chat message.
var message: TChannelChatNotificationEventMessage

## The type of notice. Possible values are:  sub resub sub_gift community_sub_gift gift_paid_upgrade prime_paid_upgrade raid unraid pay_it_forward announcement bits_badge_tier charity_donation shared_chat_sub shared_chat_resub shared_chat_sub_gift shared_chat_community_sub_gift shared_chat_gift_paid_upgrade shared_chat_prime_paid_upgrade shared_chat_raid shared_chat_pay_it_forward shared_chat_announcement
var notice_type: String

## Information about the sub event. Null if  notice_type  is not  sub .
var sub: TChannelChatNotificationEventSub

## Information about the resub event. Null if  notice_type  is not  resub .
var resub: TChannelChatNotificationEventResub

## Information about the gift sub event. Null if notice_type is not sub_gift.
var sub_gift: TChannelChatNotificationEventSubGift

## Information about the community gift sub event. Null if  notice_type  is not  community_sub_gift .
var community_sub_gift: TChannelChatNotificationEventCommunitySubGift

## Information about the community gift paid upgrade event. Null if  notice_type  is not  gift_paid_upgrade .
var gift_paid_upgrade: TChannelChatNotificationEventGiftPaidUpgrade

## Information about the Prime gift paid upgrade event. Null if  notice_type  is not  prime_paid_upgrade
var prime_paid_upgrade: TChannelChatNotificationEventPrimePaidUpgrade

## Information about the pay it forward event. Null if  notice_type  is not  pay_it_forward
var pay_it_forward: TChannelChatNotificationEventPayItForward

## Information about the raid event. Null if  notice_type  is not  raid
var raid: TChannelChatNotificationEventRaid

## Returns an empty payload if   notice_type  is not  unraid , otherwise returns null.
var unraid: Variant

## Information about the announcement event. Null if  notice_type  is not {::nomarkdown} announcement
var announcement: TChannelChatNotificationEventAnnouncement

## Information about the bits badge tier event. Null if  notice_type  is not  bits_badge_tier
var bits_badge_tier: TChannelChatNotificationEventBitsBadgeTier

## Information about the announcement event. Null if  notice_type  is not  charity_donation
var charity_donation: TChannelChatNotificationEventCharityDonation

## Optional . The broadcaster user ID of the channel the message was sent from. Is null when the message notification happens in the same channel as the broadcaster. Is not null when in a shared chat session, and the action happens in the channel of a participant other than the broadcaster.
var source_broadcaster_user_id: String

## Optional . The user name of the broadcaster of the channel the message was sent from. Is null when the message notification happens in the same channel as the broadcaster. Is not null when in a shared chat session, and the action happens in the channel of a participant other than the broadcaster.
var source_broadcaster_user_name: String

## Optional . The login of the broadcaster of the channel the message was sent from. Is null when the message notification happens in the same channel as the broadcaster. Is not null when in a shared chat session, and the action happens in the channel of a participant other than the broadcaster.
var source_broadcaster_user_login: String

## Optional . The UUID that identifies the source message from the channel the message was sent from. Is null when the message happens in the same channel as the broadcaster. Is not null when in a shared chat session, and the action happens in the channel of a participant other than the broadcaster.
var source_message_id: String

## Optional . The list of chat badges for the chatter in the channel the message was sent from. Is null when the message happens in the same channel as the broadcaster. Is not null when in a shared chat session, and the action happens in the channel of a participant other than the broadcaster.
var source_badges: TChannelChatNotificationEventSourceBadges

## Optional . Information about the  shared_chat_sub  event. Is null if  notice_type  is not  shared_chat_sub . This field has the same information as the  sub  field but for a notice that happened for a channel in a shared chat session other than the broadcaster in the subscription condition.
var shared_chat_sub: Variant

## Optional . Information about the  shared_chat_resub  event. Is null if  notice_type  is not  shared_chat_resub . This field has the same information as the  resub  field but for a notice that happened for a channel in a shared chat session other than the broadcaster in the subscription condition.
var shared_chat_resub: Variant

## Optional . Information about the  shared_chat_sub_gift  event. Is null if  notice_type  is not  shared_chat_sub_gift . This field has the same information as the  chat_sub_gift  field but for a notice that happened for a channel in a shared chat session other than the broadcaster in the subscription condition.
var shared_chat_sub_gift: Variant

## Optional . Information about the  shared_chat_community_sub_gift  event. Is null if  notice_type  is not  shared_chat_community_sub_gift . This field has the same information as the  community_sub_gift  field but for a notice that happened for a channel in a shared chat session other than the broadcaster in the subscription condition.
var shared_chat_community_sub_gift: Variant

## Optional . Information about the  shared_chat_gift_paid_upgrade  event. Is null if  notice_type  is not  shared_chat_gift_paid_upgrade . This field has the same information as the  gift_paid_upgrade  field but for a notice that happened for a channel in a shared chat session other than the broadcaster in the subscription condition.
var shared_chat_gift_paid_upgrade: Variant

## Optional . Information about the  shared_chat_chat_prime_paid_upgrade  event. Is null if  notice_type  is not  shared_chat_prime_paid_upgrade . This field has the same information as the  prime_paid_upgrade  field but for a notice that happened for a channel in a shared chat session other than the broadcaster in the subscription condition.
var shared_chat_prime_paid_upgrade: Variant

## Optional . Information about the  shared_chat_pay_it_forward  event. Is null if  notice_type  is not  shared_chat_pay_it_forward . This field has the same information as the  pay_it_forward  field but for a notice that happened for a channel in a shared chat session other than the broadcaster in the subscription condition.
var shared_chat_pay_it_forward: Variant

## Optional . Information about the  shared_chat_raid  event. Is null if  notice_type  is not  shared_chat_raid . This field has the same information as the  raid  field but for a notice that happened for a channel in a shared chat session other than the broadcaster in the subscription condition.
var shared_chat_raid: Variant

## Optional . Information about the  shared_chat_announcement  event. Is null if  notice_type  is not  shared_chat_announcement . This field has the same information as the  announcement  field but for a notice that happened for a channel in a shared chat session other than the broadcaster in the subscription condition.
var shared_chat_announcement: Variant

## Create is similar to _init but takes parameters. Useful for using with autocomplete in the editor.
static func create(broadcaster_user_id: String, broadcaster_user_name: String, broadcaster_user_login: String, chatter_user_id: String, chatter_user_name: String, chatter_is_anonymous: bool, color: String, badges: Array[TChannelChatNotificationEventBadges], system_message: String, message_id: String, message: TChannelChatNotificationEventMessage, notice_type: String, sub: TChannelChatNotificationEventSub, resub: TChannelChatNotificationEventResub, sub_gift: TChannelChatNotificationEventSubGift, community_sub_gift: TChannelChatNotificationEventCommunitySubGift, gift_paid_upgrade: TChannelChatNotificationEventGiftPaidUpgrade, prime_paid_upgrade: TChannelChatNotificationEventPrimePaidUpgrade, pay_it_forward: TChannelChatNotificationEventPayItForward, raid: TChannelChatNotificationEventRaid, unraid: Variant, announcement: TChannelChatNotificationEventAnnouncement, bits_badge_tier: TChannelChatNotificationEventBitsBadgeTier, charity_donation: TChannelChatNotificationEventCharityDonation, source_broadcaster_user_id: String, source_broadcaster_user_name: String, source_broadcaster_user_login: String, source_message_id: String, source_badges: TChannelChatNotificationEventSourceBadges, shared_chat_sub: Variant, shared_chat_resub: Variant, shared_chat_sub_gift: Variant, shared_chat_community_sub_gift: Variant, shared_chat_gift_paid_upgrade: Variant, shared_chat_prime_paid_upgrade: Variant, shared_chat_pay_it_forward: Variant, shared_chat_raid: Variant, shared_chat_announcement: Variant) -> TChannelChatNotificationEvent:
	var _new = TChannelChatNotificationEvent.new()
	_new.broadcaster_user_id = broadcaster_user_id
	_new.broadcaster_user_name = broadcaster_user_name
	_new.broadcaster_user_login = broadcaster_user_login
	_new.chatter_user_id = chatter_user_id
	_new.chatter_user_name = chatter_user_name
	_new.chatter_is_anonymous = chatter_is_anonymous
	_new.color = color
	_new.badges = badges
	_new.system_message = system_message
	_new.message_id = message_id
	_new.message = message
	_new.notice_type = notice_type
	_new.sub = sub
	_new.resub = resub
	_new.sub_gift = sub_gift
	_new.community_sub_gift = community_sub_gift
	_new.gift_paid_upgrade = gift_paid_upgrade
	_new.prime_paid_upgrade = prime_paid_upgrade
	_new.pay_it_forward = pay_it_forward
	_new.raid = raid
	_new.unraid = unraid
	_new.announcement = announcement
	_new.bits_badge_tier = bits_badge_tier
	_new.charity_donation = charity_donation
	_new.source_broadcaster_user_id = source_broadcaster_user_id
	_new.source_broadcaster_user_name = source_broadcaster_user_name
	_new.source_broadcaster_user_login = source_broadcaster_user_login
	_new.source_message_id = source_message_id
	_new.source_badges = source_badges
	_new.shared_chat_sub = shared_chat_sub
	_new.shared_chat_resub = shared_chat_resub
	_new.shared_chat_sub_gift = shared_chat_sub_gift
	_new.shared_chat_community_sub_gift = shared_chat_community_sub_gift
	_new.shared_chat_gift_paid_upgrade = shared_chat_gift_paid_upgrade
	_new.shared_chat_prime_paid_upgrade = shared_chat_prime_paid_upgrade
	_new.shared_chat_pay_it_forward = shared_chat_pay_it_forward
	_new.shared_chat_raid = shared_chat_raid
	_new.shared_chat_announcement = shared_chat_announcement
	return _new

## Create from object (usually returned from api)
static func from_object(obj: Variant) -> TChannelChatNotificationEvent:
	if not obj: return
	if not obj is Dictionary:
		print("[TChannelChatNotificationEvent]: Object is not Dictionary: ", obj)
		return

	var _new = TChannelChatNotificationEvent.new()

	_new.broadcaster_user_id = obj.get("broadcaster_user_id") if obj.get("broadcaster_user_id") else ""
	_new.broadcaster_user_name = obj.get("broadcaster_user_name") if obj.get("broadcaster_user_name") else ""
	_new.broadcaster_user_login = obj.get("broadcaster_user_login") if obj.get("broadcaster_user_login") else ""
	_new.chatter_user_id = obj.get("chatter_user_id") if obj.get("chatter_user_id") else ""
	_new.chatter_user_name = obj.get("chatter_user_name") if obj.get("chatter_user_name") else ""
	_new.chatter_is_anonymous = obj.get("chatter_is_anonymous") if obj.get("chatter_is_anonymous") else null
	_new.color = obj.get("color") if obj.get("color") else ""
	_new.badges = [] as Array[TChannelChatNotificationEventBadges]
	for o in obj.get("badges", []):
		_new.badges.append(TChannelChatNotificationEventBadges.from_object(o))
	_new.system_message = obj.get("system_message") if obj.get("system_message") else ""
	_new.message_id = obj.get("message_id") if obj.get("message_id") else ""
	_new.message = TChannelChatNotificationEventMessage.from_object(obj.get("message", {}))
	_new.notice_type = obj.get("notice_type") if obj.get("notice_type") else ""
	_new.sub = TChannelChatNotificationEventSub.from_object(obj.get("sub", {}))
	_new.resub = TChannelChatNotificationEventResub.from_object(obj.get("resub", {}))
	_new.sub_gift = TChannelChatNotificationEventSubGift.from_object(obj.get("sub_gift", {}))
	_new.community_sub_gift = TChannelChatNotificationEventCommunitySubGift.from_object(obj.get("community_sub_gift", {}))
	_new.gift_paid_upgrade = TChannelChatNotificationEventGiftPaidUpgrade.from_object(obj.get("gift_paid_upgrade", {}))
	_new.prime_paid_upgrade = TChannelChatNotificationEventPrimePaidUpgrade.from_object(obj.get("prime_paid_upgrade", {}))
	_new.pay_it_forward = TChannelChatNotificationEventPayItForward.from_object(obj.get("pay_it_forward", {}))
	_new.raid = TChannelChatNotificationEventRaid.from_object(obj.get("raid", {}))
	_new.unraid = obj.get("unraid") if obj.get("unraid") else null
	_new.announcement = TChannelChatNotificationEventAnnouncement.from_object(obj.get("announcement", {}))
	_new.bits_badge_tier = TChannelChatNotificationEventBitsBadgeTier.from_object(obj.get("bits_badge_tier", {}))
	_new.charity_donation = TChannelChatNotificationEventCharityDonation.from_object(obj.get("charity_donation", {}))
	_new.source_broadcaster_user_id = obj.get("source_broadcaster_user_id") if obj.get("source_broadcaster_user_id") else ""
	_new.source_broadcaster_user_name = obj.get("source_broadcaster_user_name") if obj.get("source_broadcaster_user_name") else ""
	_new.source_broadcaster_user_login = obj.get("source_broadcaster_user_login") if obj.get("source_broadcaster_user_login") else ""
	_new.source_message_id = obj.get("source_message_id") if obj.get("source_message_id") else ""
	_new.source_badges = TChannelChatNotificationEventSourceBadges.from_object(obj.get("source_badges", {}))
	_new.shared_chat_sub = obj.get("shared_chat_sub") if obj.get("shared_chat_sub") else null
	_new.shared_chat_resub = obj.get("shared_chat_resub") if obj.get("shared_chat_resub") else null
	_new.shared_chat_sub_gift = obj.get("shared_chat_sub_gift") if obj.get("shared_chat_sub_gift") else null
	_new.shared_chat_community_sub_gift = obj.get("shared_chat_community_sub_gift") if obj.get("shared_chat_community_sub_gift") else null
	_new.shared_chat_gift_paid_upgrade = obj.get("shared_chat_gift_paid_upgrade") if obj.get("shared_chat_gift_paid_upgrade") else null
	_new.shared_chat_prime_paid_upgrade = obj.get("shared_chat_prime_paid_upgrade") if obj.get("shared_chat_prime_paid_upgrade") else null
	_new.shared_chat_pay_it_forward = obj.get("shared_chat_pay_it_forward") if obj.get("shared_chat_pay_it_forward") else null
	_new.shared_chat_raid = obj.get("shared_chat_raid") if obj.get("shared_chat_raid") else null
	_new.shared_chat_announcement = obj.get("shared_chat_announcement") if obj.get("shared_chat_announcement") else null

	return _new
