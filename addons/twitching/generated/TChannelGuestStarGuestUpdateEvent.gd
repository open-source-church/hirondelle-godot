extends TBaseType
class_name TChannelGuestStarGuestUpdateEvent

## Autogenerated. Do not modify.

## The non-host broadcaster user ID.
var broadcaster_user_id: String

## The non-host broadcaster display name.
var broadcaster_user_name: String

## The non-host broadcaster login.
var broadcaster_user_login: String

## ID representing the unique session that was started.
var session_id: String

## The user ID of the moderator who updated the guest’s state (could be the host).  null  if the update was performed by the guest.
var moderator_user_id: String

## The moderator display name. null  if the update was performed by the guest.
var moderator_user_name: String

## The moderator login.  null  if the update was performed by the guest.
var moderator_user_login: String

## The user ID of the guest who transitioned states in the session.  null  if the slot is now empty.
var guest_user_id: String

## The guest display name.  null  if the slot is now empty.
var guest_user_name: String

## The guest login.  null  if the slot is now empty.
var guest_user_login: String

## The ID of the slot assignment the guest is assigned to.  null  if the guest is in the INVITED, REMOVED, READY, or ACCEPTED state.
var slot_id: String

## The current state of the user after the update has taken place.  null  if the slot is now empty. Can otherwise be one of the following:  invited  — The guest has transitioned to the invite queue. This can take place when the guest was previously assigned a slot, but have been removed from the call and are sent back to the invite queue. accepted  — The guest has accepted the invite and is currently in the process of setting up to join the session. ready  — The guest has signaled they are ready and can be assigned a slot. backstage  — The guest has been assigned a slot in the session, but is not currently seen live in the broadcasting software. live  — The guest is now live in the host's broadcasting software. removed  — The guest was removed from the call or queue. accepted  — The guest has accepted the invite to the call.
var state: String

## User ID of the host channel.
var host_user_id: String

## The host display name.
var host_user_name: String

## The host login.
var host_user_login: String

## Flag that signals whether the host is allowing the slot’s video to be seen by participants within the session.  null   if the guest is not slotted.
var host_video_enabled: bool

## Flag that signals whether the host is allowing the slot’s audio to be heard by participants within the session.  null   if the guest is not slotted.
var host_audio_enabled: bool

## Value between 0-100 that represents the slot’s audio level as heard by participants within the session.  null   if the guest is not slotted.
var host_volume: int

## Create is similar to _init but takes parameters. Useful for using with autocomplete in the editor.
static func create(broadcaster_user_id: String, broadcaster_user_name: String, broadcaster_user_login: String, session_id: String, moderator_user_id: String, moderator_user_name: String, moderator_user_login: String, guest_user_id: String, guest_user_name: String, guest_user_login: String, slot_id: String, state: String, host_user_id: String, host_user_name: String, host_user_login: String, host_video_enabled: bool, host_audio_enabled: bool, host_volume: int) -> TChannelGuestStarGuestUpdateEvent:
	var _new = TChannelGuestStarGuestUpdateEvent.new()
	_new.broadcaster_user_id = broadcaster_user_id
	_new.broadcaster_user_name = broadcaster_user_name
	_new.broadcaster_user_login = broadcaster_user_login
	_new.session_id = session_id
	_new.moderator_user_id = moderator_user_id
	_new.moderator_user_name = moderator_user_name
	_new.moderator_user_login = moderator_user_login
	_new.guest_user_id = guest_user_id
	_new.guest_user_name = guest_user_name
	_new.guest_user_login = guest_user_login
	_new.slot_id = slot_id
	_new.state = state
	_new.host_user_id = host_user_id
	_new.host_user_name = host_user_name
	_new.host_user_login = host_user_login
	_new.host_video_enabled = host_video_enabled
	_new.host_audio_enabled = host_audio_enabled
	_new.host_volume = host_volume
	return _new

## Create from object (usually returned from api)
static func from_object(obj: Variant) -> TChannelGuestStarGuestUpdateEvent:
	if not obj: return
	if not obj is Dictionary:
		print("[TChannelGuestStarGuestUpdateEvent]: Object is not Dictionary: ", obj)
		return

	var _new = TChannelGuestStarGuestUpdateEvent.new()

	_new.broadcaster_user_id = obj.get("broadcaster_user_id") if obj.get("broadcaster_user_id") else ""
	_new.broadcaster_user_name = obj.get("broadcaster_user_name") if obj.get("broadcaster_user_name") else ""
	_new.broadcaster_user_login = obj.get("broadcaster_user_login") if obj.get("broadcaster_user_login") else ""
	_new.session_id = obj.get("session_id") if obj.get("session_id") else ""
	_new.moderator_user_id = obj.get("moderator_user_id") if obj.get("moderator_user_id") else ""
	_new.moderator_user_name = obj.get("moderator_user_name") if obj.get("moderator_user_name") else ""
	_new.moderator_user_login = obj.get("moderator_user_login") if obj.get("moderator_user_login") else ""
	_new.guest_user_id = obj.get("guest_user_id") if obj.get("guest_user_id") else ""
	_new.guest_user_name = obj.get("guest_user_name") if obj.get("guest_user_name") else ""
	_new.guest_user_login = obj.get("guest_user_login") if obj.get("guest_user_login") else ""
	_new.slot_id = obj.get("slot_id") if obj.get("slot_id") else ""
	_new.state = obj.get("state") if obj.get("state") else ""
	_new.host_user_id = obj.get("host_user_id") if obj.get("host_user_id") else ""
	_new.host_user_name = obj.get("host_user_name") if obj.get("host_user_name") else ""
	_new.host_user_login = obj.get("host_user_login") if obj.get("host_user_login") else ""
	_new.host_video_enabled = obj.get("host_video_enabled") if obj.get("host_video_enabled") else null
	_new.host_audio_enabled = obj.get("host_audio_enabled") if obj.get("host_audio_enabled") else null
	_new.host_volume = obj.get("host_volume") if obj.get("host_volume") else 0

	return _new