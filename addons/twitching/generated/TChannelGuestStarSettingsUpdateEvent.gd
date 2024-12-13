extends TBaseType
class_name TChannelGuestStarSettingsUpdateEvent

## Autogenerated. Do not modify.

## User ID of the host channel.
var broadcaster_user_id: String

## The broadcaster display name
var broadcaster_user_name: String

## he broadcaster login.
var broadcaster_user_login: String

## Flag determining if Guest Star moderators have access to control whether a guest is live once assigned to a slot.
var is_moderator_send_live_enabled: bool

## Number of slots the Guest Star call interface will allow the host to add to a call.
var slot_count: int

## Flag determining if browser sources subscribed to sessions on this channel should output audio.
var is_browser_source_audio_enabled: bool

## This setting determines how the guests within a session should be laid out within a group browser source. Can be one of the following values:  tiled  — All live guests are tiled within the browser source with the same size.  screenshare  — All live guests are tiled within the browser source with the same size. If there is an active screen share, it is sized larger than the other guests. horizontal_top  — Indicates the group layout will contain all participants in a top-aligned horizontal stack. horizontal_bottom  — Indicates the group layout will contain all participants in a bottom-aligned horizontal stack. vertical_left  — Indicates the group layout will contain all participants in a left-aligned vertical stack. vertical_right  — Indicates the group layout will contain all participants in a right-aligned vertical stack.
var group_layout: String

## Create is similar to _init but takes parameters. Useful for using with autocomplete in the editor.
static func create(broadcaster_user_id: String, broadcaster_user_name: String, broadcaster_user_login: String, is_moderator_send_live_enabled: bool, slot_count: int, is_browser_source_audio_enabled: bool, group_layout: String) -> TChannelGuestStarSettingsUpdateEvent:
	var _new = TChannelGuestStarSettingsUpdateEvent.new()
	_new.broadcaster_user_id = broadcaster_user_id
	_new.broadcaster_user_name = broadcaster_user_name
	_new.broadcaster_user_login = broadcaster_user_login
	_new.is_moderator_send_live_enabled = is_moderator_send_live_enabled
	_new.slot_count = slot_count
	_new.is_browser_source_audio_enabled = is_browser_source_audio_enabled
	_new.group_layout = group_layout
	return _new

## Create from object (usually returned from api)
static func from_object(obj: Variant) -> TChannelGuestStarSettingsUpdateEvent:
	if not obj: return
	if not obj is Dictionary:
		print("[TChannelGuestStarSettingsUpdateEvent]: Object is not Dictionary: ", obj)
		return

	var _new = TChannelGuestStarSettingsUpdateEvent.new()

	_new.broadcaster_user_id = obj.get("broadcaster_user_id") if obj.get("broadcaster_user_id") else ""
	_new.broadcaster_user_name = obj.get("broadcaster_user_name") if obj.get("broadcaster_user_name") else ""
	_new.broadcaster_user_login = obj.get("broadcaster_user_login") if obj.get("broadcaster_user_login") else ""
	_new.is_moderator_send_live_enabled = obj.get("is_moderator_send_live_enabled") if obj.get("is_moderator_send_live_enabled") else null
	_new.slot_count = obj.get("slot_count") if obj.get("slot_count") else 0
	_new.is_browser_source_audio_enabled = obj.get("is_browser_source_audio_enabled") if obj.get("is_browser_source_audio_enabled") else null
	_new.group_layout = obj.get("group_layout") if obj.get("group_layout") else ""

	return _new
