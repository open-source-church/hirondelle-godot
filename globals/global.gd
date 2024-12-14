extends Node

const VECTOR_WHITE_ICONS = preload("res://themes/kenney-game-icons/vector_whiteIcons.svg")
const PORTS_TEXTURE =  preload("res://themes/ports.svg")

var window : HWindow
var OBS : OBSWebSocket
var twitch: Twitching

const NODES = [
	preload("res://scenes/nodes/core/node_test.gd"),
	## Core
	preload("res://scenes/nodes/core/node_operator_float.gd"),
	preload("res://scenes/nodes/core/node_operator_int.gd"),
	preload("res://scenes/nodes/core/node_random_number.gd"),
	preload("res://scenes/nodes/core/node_core_time_wait.gd"),
	preload("res://scenes/nodes/core/node_core_time_interval.gd"),
	preload("res://scenes/nodes/core/node_core_utility_value_changed.gd"),
	preload("res://scenes/nodes/core/node_operator_text.gd"),
	preload("res://scenes/nodes/core/node_operator_array.gd"),
	preload("res://scenes/nodes/core/node_operator_vec2.gd"),
	preload("res://scenes/nodes/core/node_color.gd"),
	preload("res://scenes/nodes/core/node_core_image.gd"),
	## OBS
	preload("res://scenes/nodes/OBS/node_obs_current_scene_changed.gd"),
	preload("res://scenes/nodes/OBS/node_obs_studio_mode.gd"),
	preload("res://scenes/nodes/OBS/node_obs_streaming.gd"),
	preload("res://scenes/nodes/OBS/node_obs_set_current_scene.gd"),
	preload("res://scenes/nodes/OBS/node_obs_scene_item_rect.gd"),
	## WINDOW
	preload("res://scenes/nodes/window/node_window_image.gd"),
	preload("res://scenes/nodes/window/node_window_progressbar.gd"),
	preload("res://scenes/nodes/window/node_window_play_sound.gd"),
	preload("res://scenes/nodes/window/node_window_fireworks.gd"),
	## TWITCH
	preload("res://scenes/nodes/twitch/twitch_channel_follow.gd"),
	preload("res://scenes/nodes/twitch/twitch_channel_chat_message.gd"),
	preload("res://scenes/nodes/twitch/twitch_send_chat_message.gd")
]

func get_icon_from_atlas(atlas : Resource, x : int, y : int, atlas_size : int, icon_width : int) -> Texture2D:
	var icon = AtlasTexture.new()
	icon.atlas = atlas
	icon.region = Rect2(x * atlas_size, y * atlas_size, atlas_size, atlas_size)
	icon = ImageTexture.create_from_image(icon.get_image())
	icon.set_size_override(Vector2i(icon_width, icon_width))
	return icon

func get_main_icon(icon : String, width : int) -> Texture2D:
	var p = Vector2i(0, 0)
	if icon == "array": p = Vector2i(11, 0)
	if icon == "float": p = Vector2i(0, 1)
	if icon == "int": p = Vector2i(0, 2)
	if icon == "color": p = Vector2i(0, 3)
	if icon == "random": p = Vector2i(0, 4)
	if icon == "text": p = Vector2i(0, 5)
	if icon == "vector": p = Vector2i(0, 6)
	if icon == "eye": p = Vector2i(0, 7)
	if icon == "progressbar": p = Vector2i(1, 7)
	if icon == "time": p = Vector2i(2, 7)
	if icon == "hourglass": p = Vector2i(3, 7)
	if icon == "obs": p = Vector2i(4, 7)
	if icon == "reset": p = Vector2i(4, 2)
	if icon == "sound": p = Vector2i(2, 4)
	if icon == "image": p = Vector2i(6, 7)
	if icon == "check": p = Vector2i(2, 2)
	if icon == "cross-no": p = Vector2i(3, 2)
	if icon == "twitch": p = Vector2i(7, 7)
	if icon == "fireworks": p = Vector2i(8, 7)
	return get_icon_from_atlas(VECTOR_WHITE_ICONS, p.x, p.y, 64, width)

func get_node_color(node):
	if "text" in node._type:
		return E.connection_colors[E.CONNECTION_TYPES.TEXT]
	if "int" in node._type:
		return E.connection_colors[E.CONNECTION_TYPES.INT]
	if "vec2" in node._type:
		return E.connection_colors[E.CONNECTION_TYPES.VEC2]
	if "float" in node._type:
		return E.connection_colors[E.CONNECTION_TYPES.FLOAT]
	if "bool" in node._type:
		return E.connection_colors[E.CONNECTION_TYPES.BOOL]
	return Color.WHITE

func reverse_icon(icon : Texture2D) -> Texture2D:
	var img = icon.get_image()
	img.flip_x()
	var icon2 = ImageTexture.create_from_image(img)
	icon2.set_size_override(icon.get_size())
	return icon2
