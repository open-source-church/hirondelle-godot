extends PanelContainer

@onready var toggle_button: Button = %ToggleButton
@onready var container: HBoxContainer = %Container
@onready var btn_refresh: Button = %BtnRefresh
@onready var lst_rewards: ItemList = %LstRewards
@onready var btn_add_reward: Button = %BtnAddReward
@onready var reward_container: MarginContainer = %RewardContainer
@onready var txt_title: LineEdit = %TxtTitle
@onready var spn_cost: SpinBox = %SpnCost
@onready var btn_enabled: CheckButton = %BtnEnabled
@onready var btn_color: ColorPickerButton = %BtnColor
@onready var btn_max_per_stream: CheckButton = %BtnMaxPerStream
@onready var btn_max_per_user_per_stream: CheckButton = %BtnMaxPerUserPerStream
@onready var btn_global_cooldown: CheckButton = %BtnGlobalCooldown
@onready var btn_skip_request_queue: CheckButton = %BtnSkipRequestQueue
@onready var btn_save: Button = %BtnSave
@onready var lbl_unavailable: Label = %LblUnavailable
@onready var list_container: VBoxContainer = %ListContainer
@onready var btn_reset: Button = %BtnReset
@onready var btn_user_input: CheckButton = %BtnUserInput
@onready var txt_user_input: LineEdit = %TxtUserInput
@onready var spn_max_per_stream: SpinBox = %SpnMaxPerStream
@onready var spn_max_per_user_per_stream: SpinBox = %SpnMaxPerUserPerStream
@onready var spn_global_cooldown: SpinBox = %SpnGlobalCooldown
@onready var btn_remove_reward: Button = %BtnRemoveReward
@onready var btn_is_paused: CheckButton = %BtnIsPaused


@export var twitch : Twitching

var rewards := []
var edited_id: String

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	toggle_button.toggled.connect(toggle_container)
	container.visible = false
	btn_refresh.pressed.connect(refresh_rewards)
	btn_add_reward.pressed.connect(new_reward)
	twitch.auth.user_changed.connect(update_ui)
	lst_rewards.item_selected.connect(edit_reward)
	btn_reset.pressed.connect(reset_reward)
	btn_save.pressed.connect(save_reward)
	btn_remove_reward.pressed.connect(remove_reward)
	update_ui()

func toggle_container(val: bool) -> void:
	container.visible = val
	if val:
		size_flags_vertical = SIZE_EXPAND_FILL
	else:
		size_flags_vertical = SIZE_SHRINK_BEGIN
	print(size_flags_vertical)

func update_ui() -> void:
	var partner := twitch.auth.user and twitch.auth.user.broadcaster_type != ""
	lbl_unavailable.visible = not partner
	list_container.visible = partner
	reward_container.visible = false

func refresh_rewards() -> void:
	var r = await twitch.request.GET("/channel_points/custom_rewards", { 
		"broadcaster_id" : twitch.auth.user.id,
		"only_manageable_rewards": true })
	if r.response_code == 200:
		rewards = r.response.data
		update_list()

func new_reward() -> void:
	await twitch.request.POST("/channel_points/custom_rewards", {
		"broadcaster_id" : twitch.auth.user.id,
		"title": "New reward (edit me)",
		"cost": 100
	})
	await refresh_rewards()

func edit_reward(idx: int) -> void:
	reward_container.visible = true
	var reward = rewards[idx]
	edited_id = reward.id
	txt_title.text = reward.title
	spn_cost.value = reward.cost
	btn_enabled.button_pressed = reward.is_enabled
	btn_color.color = Color(reward.background_color)
	btn_is_paused.button_pressed = reward.is_paused
	btn_user_input.button_pressed = reward.is_user_input_required
	txt_user_input.text = reward.prompt
	btn_max_per_stream.button_pressed = reward.max_per_stream_setting.is_enabled
	spn_max_per_stream.value = reward.max_per_stream_setting.max_per_stream
	btn_max_per_user_per_stream.button_pressed = reward.max_per_user_per_stream_setting.is_enabled
	spn_max_per_user_per_stream.value = reward.max_per_user_per_stream_setting.max_per_user_per_stream
	btn_global_cooldown.button_pressed = reward.global_cooldown_setting.is_enabled
	spn_global_cooldown.value = reward.global_cooldown_setting.global_cooldown_seconds
	btn_skip_request_queue.button_pressed = reward.should_redemptions_skip_request_queue
	
func reset_reward() -> void:
	var i = rewards.map(func (r): return r.id).find(edited_id)
	edit_reward(i)

func remove_reward() -> void:
	var i = lst_rewards.get_selected_items()
	if not i: return
	i = i[0]
	await twitch.request.DELETE("/channel_points/custom_rewards", {
		"broadcaster_id" : twitch.auth.user.id,
		"id": rewards[i].id
	})
	refresh_rewards()

func save_reward() -> void:
	var r = await twitch.request.PATCH("/channel_points/custom_rewards", {
		"broadcaster_id" : twitch.auth.user.id,
		"id": edited_id,
		"title": txt_title.text,
		"cost": spn_cost.value,
		"is_enabled": btn_enabled.button_pressed,
		"background_color": "#"+btn_color.color.to_html(false),
		"is_paused": btn_is_paused.button_pressed,
		"is_user_input_required": btn_user_input.button_pressed,
		"prompt": txt_user_input.text,
		"is_max_per_stream_enabled": btn_max_per_stream.button_pressed,
		"max_per_stream": spn_max_per_stream.value,
		"is_max_per_user_per_stream_enabled": btn_max_per_user_per_stream.button_pressed,
		"max_per_user_per_stream": spn_max_per_user_per_stream.value,
		"is_global_cooldown_enabled": btn_global_cooldown.button_pressed,
		"global_cooldown_seconds": spn_global_cooldown.value,
		"should_redemptions_skip_request_queue": btn_skip_request_queue.button_pressed
	})
	print(r)
	print("#"+btn_color.color.to_html()	)
	refresh_rewards()

func update_list():
	lst_rewards.clear()
	for r in rewards:
		var icon = "check" if r.is_enabled else "cross-no"
		var i = lst_rewards.add_item(r.title, G.get_main_icon(icon, 16))
		if not r.is_enabled:
			lst_rewards.set_item_custom_fg_color(i, Color.GRAY)
			lst_rewards.set_item_icon_modulate(i, Color.GRAY)
	if not rewards.size():
		reward_container.visible = false
