extends Popup

@onready var txt_filter: LineEdit = %TxtFilter
@onready var lst_nodes: ItemList = %LstNodes
@onready var lbl_description: RichTextLabel = %LblDescription
@onready var texture_rect: TextureRect = %TextureRect
@onready var btn_show_inactive_sources: Button = %BtnShowInactiveSources

var node_list = NodeManager.nodes.duplicate()
const VECTOR_WHITE_ICONS = preload("res://themes/kenney-game-icons/vector_whiteIcons.svg")


signal add_node(node_type : String)

func _ready() -> void:
	update_node_list()
	txt_filter.text_changed.connect(update_node_list.unbind(1))
	btn_show_inactive_sources.toggled.connect(update_node_list.unbind(1))
	
	node_list.sort_custom(func(a, b): return a._title.naturalnocasecmp_to(b._title) < 0)
	node_list.sort_custom(func(a, b): return a._category.naturalnocasecmp_to(b._category) < 0)
	
	lst_nodes.item_activated.connect(return_node)
	lst_nodes.item_selected.connect(select_item)

func update_node_list() -> void:
	lst_nodes.clear()
	
	var _node_list = node_list.filter(func (_i): return filter(_i))
	
	if not btn_show_inactive_sources.button_pressed:
		_node_list = _node_list.filter(func (n): return NodeManager.get_sources_active_for_node(n))
	
	var last_category = null
	
	var i = 0
	for n in _node_list:
		if n._category != last_category:
			last_category = n._category
			# Category header
			lst_nodes.add_item(n._category, null, false)
			lst_nodes.set_item_disabled(i, true)
			i += 1
		
		var icon = null
		if "_icon" in n: icon = G.get_main_icon(n._icon, 20)
		lst_nodes.add_item(n._title, icon)
		lst_nodes.set_item_metadata(i, n._type)
		lst_nodes.set_item_icon_modulate(i, NodeManager.get_node_color(n))
		# Sources
		if "_sources" in n:
			var sources_active = NodeManager.get_sources_active_for_node(n)
			if not sources_active:
				lst_nodes.set_item_custom_fg_color(i, Color.RED)
		i += 1

func get_icon(x := 0, y := 0) -> Texture2D:
	var icon := AtlasTexture.new()
	icon.atlas = VECTOR_WHITE_ICONS
	icon.region = Rect2(x * 64, y * 64, 64, 64)
	return icon

func filter(node) -> bool:
	var txt = txt_filter.text.to_lower()
	if not txt: return true
	if txt in node._title.to_lower(): return true
	if txt in node._category.to_lower(): return true
	if txt in node._type.to_lower(): return true
	if "_description" in node and txt in node._description.to_lower(): return true
	
	return false

func return_node(idx : int) -> void:
	add_node.emit(lst_nodes.get_item_metadata(idx))
	hide()
	
func select_item(idx : int) -> void:
	var n = node_list.filter(func (_n): return _n._type == lst_nodes.get_item_metadata(idx)).front()
	if not n: return
	
	var description = "%s\n" % n._title
	description += "[font size=\"14px\"][color=\"gray\"][i]%s[/i][/color]\n" % n._type
	if "_description" in n:
		description += n._description
	lbl_description.text = description
	var description_just_shown = not lbl_description.visible
	if "_icon" in n:
		texture_rect.texture = G.get_main_icon(n._icon, 48)
	
	if description_just_shown:
		await lst_nodes.resized
	lst_nodes.ensure_current_is_visible()

func focus_filter() -> void:
	txt_filter.text = ""
	update_node_list()
	txt_filter.grab_focus()
