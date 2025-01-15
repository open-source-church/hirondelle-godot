extends Node

const VECTOR_WHITE_ICONS = preload("res://themes/kenney-game-icons/vector_whiteIcons.svg")
const PORTS_TEXTURE =  preload("res://themes/ports.svg")

var window : HWindow
var OBS : OBSWebSocket
var twitch: Twitching
var discord: HDiscordBot

func get_icon_from_atlas(atlas : Resource, x : int, y : int, atlas_size : int, icon_width : int) -> Texture2D:
	var icon = AtlasTexture.new()
	icon.atlas = atlas
	icon.region = Rect2(x * atlas_size, y * atlas_size, atlas_size, atlas_size)
	icon = ImageTexture.create_from_image(icon.get_image())
	icon.set_size_override(Vector2i(icon_width, icon_width))
	return icon

const ICON_NAMES = [
	"empty,arrow-right,arrow-left,arrow-up,arrow-down,carret-right,carret-left,carret-up,carret-down,carret-up-down,carret-left-right,array,list,menu-horizontal,menu-vertical,pause,edit",
	"float,arrow-up-left,arrow-up-right,arrow-down-right,arrow-down-left,reduce,expand,minus,plus,magnify-minus,magnify-plus,magnify-equal,magnify,person,people,group",
	"int,,check,cross-no,reset,save,lock,unlock",
	"color,tablet,phone,contrast,home,music,no-music,bin,bin-open,exclamation,question,warning,quit,download,upload,info",
	"random,no-sound,sound,stop,forward,backward,next,previous,power,network-low,network-medium,network-high,movie,clip,exit,enter",
	"text,gamepad,gamepad-1,gamepad-2,gamepad-3,gamepad-4",
	"vector,button-a,button-b",
	"eye,progressbar,time,hourglass,obs,nodes,image,twitch,fireworks,confettis,bool,discord,file,folder,keyboard,clipboard"
]
var icon_names: Dictionary
func get_main_icon(icon : String, width : int) -> Texture2D:
	# Generate icon names
	if not icon_names:
		for i in range(ICON_NAMES.size()):
			var row = ICON_NAMES[i].split(",")
			for j in range(row.size()):
				if row[j]:
					icon_names[row[j]] = Vector2i(j, i)
	
	var p = icon_names.get(icon, Vector2i(0, 0))
	return get_icon_from_atlas(VECTOR_WHITE_ICONS, p.x, p.y, 64, width)

func reverse_icon(icon : Texture2D) -> Texture2D:
	var img = icon.get_image()
	img.flip_x()
	var icon2 = ImageTexture.create_from_image(img)
	icon2.set_size_override(icon.get_size())
	return icon2
