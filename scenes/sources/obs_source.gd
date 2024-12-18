extends HBaseSource
class_name HOBSSource

## A source for a node, meaning something it needs to function properly.

func _init() -> void:
	name = "obs"

func _ready() -> void:
	while not G.OBS:
		await get_tree().process_frame
	G.OBS.authenticated.connect(becomes_active.emit)
	G.OBS.disconnected.connect(becomes_inactive.emit)

## Subclass to implement different behavior.
func get_active() -> bool:
	return G.OBS.is_connected
