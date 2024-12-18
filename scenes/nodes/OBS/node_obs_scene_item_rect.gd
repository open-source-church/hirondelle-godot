extends HBaseNode

static var _title = "OBS Scene item rect"
static var _type = "obs/scene_item_rect"
static var _category = "OBS"
static var _icon = "obs"
static var _sources = ["obs"]


var scene := HPortText.new(E.Side.INPUT)
var source := HPortText.new(E.Side.INPUT)
var itemId := HPortIntSpin.new(E.Side.INPUT)
var pos := HPortVec2.new(E.Side.OUTPUT)
var size_ := HPortVec2.new(E.Side.OUTPUT)
var bounds := HPortVec2.new(E.Side.OUTPUT)

func _init() -> void:
	title = _title
	type = _type
	
	sources_got_active.connect(_retrieve_scene_list)
	G.OBS.scene_list_changed.connect(_update_scene_list)
	
	_retrieve_scene_list()

func _retrieve_scene_list():
	if not sources_active: return
	var r = await G.OBS.send_request("GetSceneList")
	_update_scene_list(r.scenes)

func _update_scene_list(scenes : Array):
	scenes.reverse()
	scene.options = scenes.map(func (s): return s.sceneName)

func update(_last_changed: HBasePort = null) -> void:
	#if not G.OBS.is_connected: 
		#return
	
	# Update scene items
	var r = await G.OBS.send_request("GetSceneItemList", { "sceneName": scene.value })
	
	if r and (_last_changed == scene or not source.options):
		source.options = r.sceneItems.map(func (s): return s.sourceName )
		itemId.options = r.sceneItems.map(func (s): return s.sceneItemId )
	
	# Sync sourceName and sceneItemId
	if r and _last_changed == source:
		itemId.value = r.sceneItems.filter(func (i): return i.sourceName == source.value).front().sceneItemId
	elif r and r.sceneItems and _last_changed == itemId:
		source.value = r.sceneItems.filter(func (i): return i.sceneItemId == itemId.value).front().sourceName
	
	if _last_changed in [pos, size]:
		pass
	else:
		var rect = await G.OBS.send_request("GetSceneItemTransform", { "sceneName": scene.value, "sceneItemId": itemId.value })
		if rect:
			pos.value = Vector2(rect.sceneItemTransform.positionX, rect.sceneItemTransform.positionY)
			size_.value = Vector2(
				rect.sceneItemTransform.width - 
					(rect.sceneItemTransform.cropLeft + rect.sceneItemTransform.cropRight) * rect.sceneItemTransform.scaleX,
				rect.sceneItemTransform.height -
					(rect.sceneItemTransform.cropTop + rect.sceneItemTransform.cropBottom) * rect.sceneItemTransform.scaleY
			)
			bounds.value = Vector2(rect.sceneItemTransform.boundsWidth, rect.sceneItemTransform.boundsHeight)
	
	
