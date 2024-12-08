extends HBaseNode

static var _title = "OBS Scene item rect"
static var _type = "obs/scene_item_rect"
static var _category = "OBS"
static var _icon = "obs"

func _init() -> void:
	title = _title
	type = _type
	PORTS = {
		"scene": HPortText.new({
			"type": E.CONNECTION_TYPES.TEXT, 
			"side": INPUT
		}),
		"source": HPortText.new({
			"type": E.CONNECTION_TYPES.TEXT, 
			"side": INPUT
		}),
		"itemId": HPortIntSpin.new({
			"type": E.CONNECTION_TYPES.INT, 
			"side": INPUT
		}),
		"pos": HPortVec2.new({
			"type": E.CONNECTION_TYPES.VEC2, 
			"side": OUTPUT,
		}),
		"size": HPortVec2.new({
			"type": E.CONNECTION_TYPES.VEC2, 
			"side": OUTPUT
		}),
		"bounds": HPortVec2.new({
			"type": E.CONNECTION_TYPES.VEC2, 
			"side": OUTPUT
		}),
	}
	
	G.OBS.scene_list_changed.connect(_update_scene_list)
	var r = await G.OBS.send_request("GetSceneList")
	_update_scene_list(r.scenes)
	

func _update_scene_list(scenes : Array):
	scenes.reverse()
	PORTS.scene.options = scenes.map(func (s): return s.sceneName)

func update() -> void:
	#if not G.OBS.is_connected: 
		#return
	
	# Update scene items
	var r = await G.OBS.send_request("GetSceneItemList", { "sceneName": PORTS.scene.value })
	
	if r and (_last_port_changed == "scene" or not PORTS.source.options):
		PORTS.source.options = r.sceneItems.map(func (s): return s.sourceName )
		PORTS.itemId.options = r.sceneItems.map(func (s): return s.sceneItemId )
	
	# Sync sourceName and sceneItemId
	if r and _last_port_changed == "source":
		PORTS.itemId.value = r.sceneItems.filter(func (i): return i.sourceName == PORTS.source.value).front().sceneItemId
	elif r and r.sceneItems and _last_port_changed == "itemId":
		PORTS.source.value = r.sceneItems.filter(func (i): return i.sceneItemId == PORTS.itemId.value).front().sourceName
	
	if _last_port_changed in ["pos", "size"]:
		pass
	else:
		var rect = await G.OBS.send_request("GetSceneItemTransform", { "sceneName": PORTS.scene.value, "sceneItemId": PORTS.itemId.value })
		if rect:
			PORTS.pos.value = Vector2(rect.sceneItemTransform.positionX, rect.sceneItemTransform.positionY)
			PORTS.size.value = Vector2(
				rect.sceneItemTransform.width - 
					(rect.sceneItemTransform.cropLeft + rect.sceneItemTransform.cropRight) * rect.sceneItemTransform.scaleX,
				rect.sceneItemTransform.height -
					(rect.sceneItemTransform.cropTop + rect.sceneItemTransform.cropBottom) * rect.sceneItemTransform.scaleY
			)
			PORTS.bounds.value = Vector2(rect.sceneItemTransform.boundsWidth, rect.sceneItemTransform.boundsHeight)
	
	
