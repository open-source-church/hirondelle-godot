extends Node

var graph : HGraphEdit

var OBS : OBSWebSocket

const NODES = [
	# Core
	preload("res://scenes/nodes/core/node_operator_float.gd"),
	preload("res://scenes/nodes/core/node_operator_int.gd"),
	preload("res://scenes/nodes/core/node_random_number.gd"),
	# OBS
	preload("res://scenes/nodes/OBS/node_obs_current_scene_changed.gd"),
	preload("res://scenes/nodes/OBS/node_obs_studio_mode.gd"),
	preload("res://scenes/nodes/OBS/node_obs_streaming.gd"),
	preload("res://scenes/nodes/OBS/node_obs_set_current_scene.gd")
]
