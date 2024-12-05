extends HBaseNode

static var _title = "OBS Scene item rect"
static var _type = "obs/scene_item_rect"

func _init() -> void:
	title = _title
	type = _type
	VALS = {
		"scene": HPortText.new({
			"type": G.graph.TYPES.TEXT, 
			"side": INPUT
		}),
		"source": HPortText.new({
			"type": G.graph.TYPES.TEXT, 
			"side": INPUT
		}),
		"itemId": HPortIntSpin.new({
			"type": G.graph.TYPES.INT, 
			"side": INPUT
		}),
		"pos": HPortVec2.new({
			"type": G.graph.TYPES.VEC2, 
			"side": OUTPUT,
		}),
		"size": HPortVec2.new({
			"type": G.graph.TYPES.VEC2, 
			"side": OUTPUT
		}),
		"bounds": HPortVec2.new({
			"type": G.graph.TYPES.VEC2, 
			"side": OUTPUT
		}),
	}
	
	G.OBS.scene_list_changed.connect(_update_scene_list)
	var r = await G.OBS.send_request("GetSceneList")
	_update_scene_list(r.scenes)
	

func _update_scene_list(scenes : Array):
	scenes.reverse()
	VALS.scene.options = scenes.map(func (s): return s.sceneName)

func update() -> void:
	#if not G.OBS.is_connected: 
		#return
	
	# Update scene items
	var r = await G.OBS.send_request("GetSceneItemList", { "sceneName": VALS.scene.value })
	
	if r and (_last_port_changed == "scene" or not VALS.source.options):
		VALS.source.options = r.sceneItems.map(func (s): return s.sourceName )
		VALS.itemId.options = r.sceneItems.map(func (s): return s.sceneItemId )
	
	# Sync sourceName and sceneItemId
	if r and _last_port_changed == "source":
		VALS.itemId.value = r.sceneItems.filter(func (i): return i.sourceName == VALS.source.value).front().sceneItemId
	elif r and r.sceneItems and _last_port_changed == "itemId":
		VALS.source.value = r.sceneItems.filter(func (i): return i.sceneItemId == VALS.itemId.value).front().sourceName
	
	if _last_port_changed in ["pos", "size"]:
		pass
	else:
		var rect = await G.OBS.send_request("GetSceneItemTransform", { "sceneName": VALS.scene.value, "sceneItemId": VALS.itemId.value })
		if rect:
			VALS.pos.value = Vector2(rect.sceneItemTransform.positionX, rect.sceneItemTransform.positionY)
			VALS.size.value = Vector2(
				rect.sceneItemTransform.width - 
					(rect.sceneItemTransform.cropLeft + rect.sceneItemTransform.cropRight) * rect.sceneItemTransform.scaleX,
				rect.sceneItemTransform.height -
					(rect.sceneItemTransform.cropTop + rect.sceneItemTransform.cropBottom) * rect.sceneItemTransform.scaleY
			)
			VALS.bounds.value = Vector2(rect.sceneItemTransform.boundsWidth, rect.sceneItemTransform.boundsHeight)
	
	
