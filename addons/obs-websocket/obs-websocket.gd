extends Node
class_name OBSWebSocket

enum WebSocketOpCode {
	Hello = 0, Identify = 1, Identified = 2, Reidentify = 3, Event = 5,
	Request = 6, RequestResponse = 7, RequestBatch = 8, RequestBatchResponse = 9
}

enum EventSubscription {
	None = 0, General = 1 << 0, Config = 1 << 1, Scenes = 1 << 2, Inputs = 1 << 3, Transitions = 1 << 4,
	Filters = 1 << 5, Outputs = 1 << 6, SceneItems = 1 << 7, MediaInputs = 1 << 8, Vendors = 1 << 9, 
	Ui = 1 << 10, All = 2047, InputVolumeMeters = 1 << 16, InputActiveStateChanged = 1 << 17,
	InputShowStateChanged = 1 << 18, SceneItemTransformChanged = 1 << 19
}

@export var host = "localhost"
@export var port = 4455
@export var password = "password"
@export var logging = false

signal connected
signal authenticated
signal disconnected
signal message_received(message)
signal event(data)

var socket : WebSocketPeer = WebSocketPeer.new()
var server_url : String = "ws://127.0.0.1:4444"  # Remplace l'adresse et le port selon ta configuration OBS
var is_connected := false

func _ready() -> void:
	pass

var _eventSubscriptions
## Connect to OBS. eventSubscriptions is a bitwise combination of EventSubscription
func connect_obs(eventSubscriptions = EventSubscription.All):
	var err = socket.connect_to_url("ws://%s:%s" % [host, port], TLSOptions.client())
	if err != OK:
		print("Impossible de se connecter au serveur WebSocket.")
		return
	_eventSubscriptions = eventSubscriptions
	is_connected = true
	connected.emit()

func disconnect_obs(code :int = 1000, reason := "" ):
	socket.close(code, reason)

func _log(data):
	if logging:
		print(data)

func _process(delta: float) -> void:
	if is_connected:
		socket.poll()
		
		var state = socket.get_ready_state()
		if state == WebSocketPeer.STATE_OPEN:
			while socket.get_available_packet_count():
				var msg :Variant = JSON.parse_string(socket.get_packet().get_string_from_utf8())
				process_msg(msg)
		elif state == WebSocketPeer.STATE_CLOSING:
			# Keep polling to achieve proper close.
			pass
		elif state == WebSocketPeer.STATE_CLOSED:
			var code = socket.get_close_code()
			var reason = socket.get_close_reason()
			print("WebSocket closed with code: %d, reason %s. Clean: %s" % [code, reason, code != -1])
			is_connected = false
			disconnected.emit()

func process_msg(msg : Variant) -> void:
	_log("Processing message: %s \n" % msg)
	# HELLO WITH AUTH
	if msg.get("op") == WebSocketOpCode.Hello:
		if msg.d.get("authentication"):
			var challenge = msg.d.authentication.challenge
			var salt = msg.d.authentication.salt
			var combined_secret := "%s%s" % [password, salt]
			var base64_secret := Marshalls.raw_to_base64(combined_secret.sha256_buffer())
			var combined_auth := "%s%s" % [base64_secret, challenge]
			var auth = Marshalls.raw_to_base64(combined_auth.sha256_buffer())
			send_msg(WebSocketOpCode.Identify, {
				"rpcVersion": 1,
				"authentication": auth,
				"eventSubscriptions": _eventSubscriptions
			})
		else:
			send_msg(1, { 
				"rpcVersion": 1,
				"eventSubscriptions": _eventSubscriptions
				})
	
	## AUTHENTICATED
	if msg.get("op") == WebSocketOpCode.Identified:
		authenticated.emit()

	# EVENT
	if msg.get("op") == WebSocketOpCode.Event:
		event.emit(msg.get("d"))
		
		process_event(msg.get("d"))

	# REQUEST
	if msg.get("op") == WebSocketOpCode.RequestResponse:
		requests[msg.d.requestId] = msg.d
		
func send_msg(op, msg : Dictionary) -> void:
	_log("Sending message - OP %s : %s \n" % [op, msg])
	socket.send_text(JSON.stringify({
		"op": op,
		"d": msg
	}))

var requests = {}

func send_request(type : String, data := {} ):
	var requestID = "%s-%s" % [Time.get_ticks_msec(), randi()]
	requests[requestID] = null
	send_msg(WebSocketOpCode.Request, {
		"requestType": type,
		"requestId": requestID,
		"requestData": data
	})
	while requests[requestID] == null:
		await get_tree().create_timer(0.01).timeout
	var r = requests[requestID]
	requests.erase(requestID)
	return r.get("responseData")

func wait_for_request(requestID : String):
	while requests[requestID] == null:
		await get_tree().create_timer(0.1).timeout

# Signaux générés à partir de la documentation OBS WebSocket via generate_from_doc.py
signal exit_started()
signal vendor_event(vendor_name : String, event_type : String, event_data : Dictionary)
signal custom_event(event_data : Dictionary)
signal current_scene_collection_changing(scene_collection_name : String)
signal current_scene_collection_changed(scene_collection_name : String)
signal scene_collection_list_changed(scene_collections : Variant)
signal current_profile_changing(profile_name : String)
signal current_profile_changed(profile_name : String)
signal profile_list_changed(profiles : Variant)
signal scene_created(scene_name : String, scene_uuid : String, is_group : bool)
signal scene_removed(scene_name : String, scene_uuid : String, is_group : bool)
signal scene_name_changed(scene_uuid : String, old_scene_name : String, scene_name : String)
signal current_program_scene_changed(scene_name : String, scene_uuid : String)
signal current_preview_scene_changed(scene_name : String, scene_uuid : String)
signal scene_list_changed(scenes : Variant)
signal input_created(input_name : String, input_uuid : String, input_kind : String, unversioned_input_kind : String, input_settings : Dictionary, default_input_settings : Dictionary)
signal input_removed(input_name : String, input_uuid : String)
signal input_name_changed(input_uuid : String, old_input_name : String, input_name : String)
signal input_settings_changed(input_name : String, input_uuid : String, input_settings : Dictionary)
signal input_active_state_changed(input_name : String, input_uuid : String, video_active : bool)
signal input_show_state_changed(input_name : String, input_uuid : String, video_showing : bool)
signal input_mute_state_changed(input_name : String, input_uuid : String, input_muted : bool)
signal input_volume_changed(input_name : String, input_uuid : String, input_volume_mul : int, input_volume_db : int)
signal input_audio_balance_changed(input_name : String, input_uuid : String, input_audio_balance : int)
signal input_audio_sync_offset_changed(input_name : String, input_uuid : String, input_audio_sync_offset : int)
signal input_audio_tracks_changed(input_name : String, input_uuid : String, input_audio_tracks : Dictionary)
signal input_audio_monitor_type_changed(input_name : String, input_uuid : String, monitor_type : String)
signal input_volume_meters(inputs : Variant)
signal current_scene_transition_changed(transition_name : String, transition_uuid : String)
signal current_scene_transition_duration_changed(transition_duration : int)
signal scene_transition_started(transition_name : String, transition_uuid : String)
signal scene_transition_ended(transition_name : String, transition_uuid : String)
signal scene_transition_video_ended(transition_name : String, transition_uuid : String)
signal source_filter_list_reindexed(source_name : String, filters : Variant)
signal source_filter_created(source_name : String, filter_name : String, filter_kind : String, filter_index : int, filter_settings : Dictionary, default_filter_settings : Dictionary)
signal source_filter_removed(source_name : String, filter_name : String)
signal source_filter_name_changed(source_name : String, old_filter_name : String, filter_name : String)
signal source_filter_settings_changed(source_name : String, filter_name : String, filter_settings : Dictionary)
signal source_filter_enable_state_changed(source_name : String, filter_name : String, filter_enabled : bool)
signal scene_item_created(scene_name : String, scene_uuid : String, source_name : String, source_uuid : String, scene_item_id : int, scene_item_index : int)
signal scene_item_removed(scene_name : String, scene_uuid : String, source_name : String, source_uuid : String, scene_item_id : int)
signal scene_item_list_reindexed(scene_name : String, scene_uuid : String, scene_items : Variant)
signal scene_item_enable_state_changed(scene_name : String, scene_uuid : String, scene_item_id : int, scene_item_enabled : bool)
signal scene_item_lock_state_changed(scene_name : String, scene_uuid : String, scene_item_id : int, scene_item_locked : bool)
signal scene_item_selected(scene_name : String, scene_uuid : String, scene_item_id : int)
signal scene_item_transform_changed(scene_name : String, scene_uuid : String, scene_item_id : int, scene_item_transform : Dictionary)
signal stream_state_changed(output_active : bool, output_state : String)
signal record_state_changed(output_active : bool, output_state : String, output_path : String)
signal record_file_changed(new_output_path : String)
signal replay_buffer_state_changed(output_active : bool, output_state : String)
signal virtualcam_state_changed(output_active : bool, output_state : String)
signal replay_buffer_saved(saved_replay_path : String)
signal media_input_playback_started(input_name : String, input_uuid : String)
signal media_input_playback_ended(input_name : String, input_uuid : String)
signal media_input_action_triggered(input_name : String, input_uuid : String, media_action : String)
signal studio_mode_state_changed(studio_mode_enabled : bool)
signal screenshot_saved(saved_screenshot_path : String)

func process_event(event : Dictionary):
	if event.eventType == "ExitStarted":
		exit_started.emit()
	if event.eventType == "VendorEvent":
		vendor_event.emit(event.eventData.vendorName, event.eventData.eventType, event.eventData.eventData)
	if event.eventType == "CustomEvent":
		custom_event.emit(event.eventData.eventData)
	if event.eventType == "CurrentSceneCollectionChanging":
		current_scene_collection_changing.emit(event.eventData.sceneCollectionName)
	if event.eventType == "CurrentSceneCollectionChanged":
		current_scene_collection_changed.emit(event.eventData.sceneCollectionName)
	if event.eventType == "SceneCollectionListChanged":
		scene_collection_list_changed.emit(event.eventData.sceneCollections)
	if event.eventType == "CurrentProfileChanging":
		current_profile_changing.emit(event.eventData.profileName)
	if event.eventType == "CurrentProfileChanged":
		current_profile_changed.emit(event.eventData.profileName)
	if event.eventType == "ProfileListChanged":
		profile_list_changed.emit(event.eventData.profiles)
	if event.eventType == "SceneCreated":
		scene_created.emit(event.eventData.sceneName, event.eventData.sceneUuid, event.eventData.isGroup)
	if event.eventType == "SceneRemoved":
		scene_removed.emit(event.eventData.sceneName, event.eventData.sceneUuid, event.eventData.isGroup)
	if event.eventType == "SceneNameChanged":
		scene_name_changed.emit(event.eventData.sceneUuid, event.eventData.oldSceneName, event.eventData.sceneName)
	if event.eventType == "CurrentProgramSceneChanged":
		current_program_scene_changed.emit(event.eventData.sceneName, event.eventData.sceneUuid)
	if event.eventType == "CurrentPreviewSceneChanged":
		current_preview_scene_changed.emit(event.eventData.sceneName, event.eventData.sceneUuid)
	if event.eventType == "SceneListChanged":
		scene_list_changed.emit(event.eventData.scenes)
	if event.eventType == "InputCreated":
		input_created.emit(event.eventData.inputName, event.eventData.inputUuid, event.eventData.inputKind, event.eventData.unversionedInputKind, event.eventData.inputSettings, event.eventData.defaultInputSettings)
	if event.eventType == "InputRemoved":
		input_removed.emit(event.eventData.inputName, event.eventData.inputUuid)
	if event.eventType == "InputNameChanged":
		input_name_changed.emit(event.eventData.inputUuid, event.eventData.oldInputName, event.eventData.inputName)
	if event.eventType == "InputSettingsChanged":
		input_settings_changed.emit(event.eventData.inputName, event.eventData.inputUuid, event.eventData.inputSettings)
	if event.eventType == "InputActiveStateChanged":
		input_active_state_changed.emit(event.eventData.inputName, event.eventData.inputUuid, event.eventData.videoActive)
	if event.eventType == "InputShowStateChanged":
		input_show_state_changed.emit(event.eventData.inputName, event.eventData.inputUuid, event.eventData.videoShowing)
	if event.eventType == "InputMuteStateChanged":
		input_mute_state_changed.emit(event.eventData.inputName, event.eventData.inputUuid, event.eventData.inputMuted)
	if event.eventType == "InputVolumeChanged":
		input_volume_changed.emit(event.eventData.inputName, event.eventData.inputUuid, event.eventData.inputVolumeMul, event.eventData.inputVolumeDb)
	if event.eventType == "InputAudioBalanceChanged":
		input_audio_balance_changed.emit(event.eventData.inputName, event.eventData.inputUuid, event.eventData.inputAudioBalance)
	if event.eventType == "InputAudioSyncOffsetChanged":
		input_audio_sync_offset_changed.emit(event.eventData.inputName, event.eventData.inputUuid, event.eventData.inputAudioSyncOffset)
	if event.eventType == "InputAudioTracksChanged":
		input_audio_tracks_changed.emit(event.eventData.inputName, event.eventData.inputUuid, event.eventData.inputAudioTracks)
	if event.eventType == "InputAudioMonitorTypeChanged":
		input_audio_monitor_type_changed.emit(event.eventData.inputName, event.eventData.inputUuid, event.eventData.monitorType)
	if event.eventType == "InputVolumeMeters":
		input_volume_meters.emit(event.eventData.inputs)
	if event.eventType == "CurrentSceneTransitionChanged":
		current_scene_transition_changed.emit(event.eventData.transitionName, event.eventData.transitionUuid)
	if event.eventType == "CurrentSceneTransitionDurationChanged":
		current_scene_transition_duration_changed.emit(event.eventData.transitionDuration)
	if event.eventType == "SceneTransitionStarted":
		scene_transition_started.emit(event.eventData.transitionName, event.eventData.transitionUuid)
	if event.eventType == "SceneTransitionEnded":
		scene_transition_ended.emit(event.eventData.transitionName, event.eventData.transitionUuid)
	if event.eventType == "SceneTransitionVideoEnded":
		scene_transition_video_ended.emit(event.eventData.transitionName, event.eventData.transitionUuid)
	if event.eventType == "SourceFilterListReindexed":
		source_filter_list_reindexed.emit(event.eventData.sourceName, event.eventData.filters)
	if event.eventType == "SourceFilterCreated":
		source_filter_created.emit(event.eventData.sourceName, event.eventData.filterName, event.eventData.filterKind, event.eventData.filterIndex, event.eventData.filterSettings, event.eventData.defaultFilterSettings)
	if event.eventType == "SourceFilterRemoved":
		source_filter_removed.emit(event.eventData.sourceName, event.eventData.filterName)
	if event.eventType == "SourceFilterNameChanged":
		source_filter_name_changed.emit(event.eventData.sourceName, event.eventData.oldFilterName, event.eventData.filterName)
	if event.eventType == "SourceFilterSettingsChanged":
		source_filter_settings_changed.emit(event.eventData.sourceName, event.eventData.filterName, event.eventData.filterSettings)
	if event.eventType == "SourceFilterEnableStateChanged":
		source_filter_enable_state_changed.emit(event.eventData.sourceName, event.eventData.filterName, event.eventData.filterEnabled)
	if event.eventType == "SceneItemCreated":
		scene_item_created.emit(event.eventData.sceneName, event.eventData.sceneUuid, event.eventData.sourceName, event.eventData.sourceUuid, event.eventData.sceneItemId, event.eventData.sceneItemIndex)
	if event.eventType == "SceneItemRemoved":
		scene_item_removed.emit(event.eventData.sceneName, event.eventData.sceneUuid, event.eventData.sourceName, event.eventData.sourceUuid, event.eventData.sceneItemId)
	if event.eventType == "SceneItemListReindexed":
		scene_item_list_reindexed.emit(event.eventData.sceneName, event.eventData.sceneUuid, event.eventData.sceneItems)
	if event.eventType == "SceneItemEnableStateChanged":
		scene_item_enable_state_changed.emit(event.eventData.sceneName, event.eventData.sceneUuid, event.eventData.sceneItemId, event.eventData.sceneItemEnabled)
	if event.eventType == "SceneItemLockStateChanged":
		scene_item_lock_state_changed.emit(event.eventData.sceneName, event.eventData.sceneUuid, event.eventData.sceneItemId, event.eventData.sceneItemLocked)
	if event.eventType == "SceneItemSelected":
		scene_item_selected.emit(event.eventData.sceneName, event.eventData.sceneUuid, event.eventData.sceneItemId)
	if event.eventType == "SceneItemTransformChanged":
		scene_item_transform_changed.emit(event.eventData.sceneName, event.eventData.sceneUuid, event.eventData.sceneItemId, event.eventData.sceneItemTransform)
	if event.eventType == "StreamStateChanged":
		stream_state_changed.emit(event.eventData.outputActive, event.eventData.outputState)
	if event.eventType == "RecordStateChanged":
		record_state_changed.emit(event.eventData.outputActive, event.eventData.outputState, event.eventData.outputPath)
	if event.eventType == "RecordFileChanged":
		record_file_changed.emit(event.eventData.newOutputPath)
	if event.eventType == "ReplayBufferStateChanged":
		replay_buffer_state_changed.emit(event.eventData.outputActive, event.eventData.outputState)
	if event.eventType == "VirtualcamStateChanged":
		virtualcam_state_changed.emit(event.eventData.outputActive, event.eventData.outputState)
	if event.eventType == "ReplayBufferSaved":
		replay_buffer_saved.emit(event.eventData.savedReplayPath)
	if event.eventType == "MediaInputPlaybackStarted":
		media_input_playback_started.emit(event.eventData.inputName, event.eventData.inputUuid)
	if event.eventType == "MediaInputPlaybackEnded":
		media_input_playback_ended.emit(event.eventData.inputName, event.eventData.inputUuid)
	if event.eventType == "MediaInputActionTriggered":
		media_input_action_triggered.emit(event.eventData.inputName, event.eventData.inputUuid, event.eventData.mediaAction)
	if event.eventType == "StudioModeStateChanged":
		studio_mode_state_changed.emit(event.eventData.studioModeEnabled)
	if event.eventType == "ScreenshotSaved":
		screenshot_saved.emit(event.eventData.savedScreenshotPath)
