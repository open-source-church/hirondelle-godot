extends HBaseNode

## Discord webhook
##
## @tutorial "Discord Webhooks": https://discord.com/developers/docs/resources/webhook#execute-webhook
## @tutorial "Visualiser": https://leovoel.github.io/embed-visualizer/

static var _title = "Post discord message (Webhook)"
static var _type = "core/discord/webhook"
static var _category = "Discord"
static var _icon = "discord"
static var _description = "Posts messages and stuff with discord webbhooks."

# Enums
enum Action { MESSAGE, EMBED, FIELD }
var ActionLabels = [ "Message", "Create Embed", "Add field" ]

# Type
var type_ := HPortIntSpin.new(E.Side.NONE, { 
	"options_enum": Action, "options_labels": ActionLabels })
# Ports
var post := HPortFlow.new(E.Side.INPUT, { "group" : "base" })
var edit := HPortFlow.new(E.Side.INPUT, { "group" : "base" })
var delete := HPortFlow.new(E.Side.INPUT, { "group" : "base" })
var done := HPortFlow.new(E.Side.OUTPUT, { "group" : "base" })
var webhook_url := HPortText.new(E.Side.INPUT, { 
	"group" : "base", 
	"description" : "The url of the webhook. Get that in your discord server settings.",
	"params": { "secret": true }
	})
var content := HPortTextMultiLine.new(E.Side.INPUT, { "group" : "base", "description" : "the message contents (up to 2000 characters)", "params": { "max_length": 12 } })
var message_id := HPortText.new(E.Side.BOTH, { "group" : "base", "description" : "The id of the message (needed to edit)" })
# Webhook identity
var _identity_cat := HPortCategory.new("Identity", { "group" : "base" })
var username := HPortText.new(E.Side.INPUT, { "group" : "base", "description" : "override the default username of the webhook" })
var avatar_url := HPortText.new(E.Side.INPUT, { "group" : "base", "description" : "override the default avatar of the webhook" })
# Options
var _message_cat := HPortCategory.new("Options", { "group" : "base" })
var tts := HPortBool.new(E.Side.INPUT, { "group" : "base", "description" : "True if this is a TTS message" })
var embeds := HPortArray.new(E.Side.INPUT, { "group" : "base", "multiple": true, "description" : "Array of Embeded content" })

# Embeds
var embed_title :=  HPortText.new(E.Side.INPUT, { "group" : "embed", "description" : "title of embed" })
var embed_description :=  HPortText.new(E.Side.INPUT, { "group" : "embed", "description" : "description of embed" })
var embed_url :=  HPortText.new(E.Side.INPUT, { "group" : "embed", "description" : "url of embed" })
var embed_color :=  HPortColor.new(E.Side.INPUT, { "group" : "embed", "description" : "color of embed" })
var _embed_image_cat := HPortCategory.new("Image", { "group" : "embed" })
var embed_image :=  HPortText.new(E.Side.INPUT, { "group" : "embed", "description" : "image url of embed (https)" })
var _embed_author_cat := HPortCategory.new("Author", { "group" : "embed" })
var embed_author_name :=  HPortText.new(E.Side.INPUT, { "group" : "embed", "description" : "name of author" })
var embed_author_link :=  HPortText.new(E.Side.INPUT, { "group" : "embed", "description" : "url link of author (https)" })
var embed_author_icon :=  HPortText.new(E.Side.INPUT, { "group" : "embed", "description" : "url icon (https)" })
var _embed_footer_cat := HPortCategory.new("Footer", { "group" : "embed" })
var embed_footer_name :=  HPortText.new(E.Side.INPUT, { "group" : "embed", "description" : "footer text" })
var embed_footer_icon :=  HPortText.new(E.Side.INPUT, { "group" : "embed", "description" : "url icon of footer (https)" })
var fields := HPortArray.new(E.Side.INPUT, { "group" : "embed", "multiple": true, "description" : "Array of Fields content (max: 25)" })
var _embed_output_cat := HPortCategory.new("Output", { "group" : "embed" })
var embed :=  HPortDict.new(E.Side.OUTPUT, { "group" : "embed", "multiple": false })

# Fields
var field_name :=  HPortText.new(E.Side.INPUT, { "group" : "field", "description" : "name of the field" })
var field_value :=  HPortText.new(E.Side.INPUT, { "group" : "field", "description" : "value of the field" })
var field_inline :=  HPortBool.new(E.Side.INPUT, { "group" : "field", "description" : "whether or not this field should display inline" })
var field :=  HPortDict.new(E.Side.OUTPUT, { "group" : "field", "multiple": false })

var request : HTTPRequest

func _init() -> void:
	title = _title
	type = _type
	
	request = HTTPRequest.new()
	add_child(request, false, Node.INTERNAL_MODE_FRONT)
	request.use_threads = true
	request.request_completed.connect(_request_completed)


const HEADERS: PackedStringArray = ["Accept: application/json", "Content-Type: application/json"]
func _request_completed(_result: int, response_code: int, _headers: PackedStringArray, body: PackedByteArray) -> void:
	var rtext = JSON.parse_string(body.get_string_from_utf8())

	# Created or edited
	if response_code == 200:
		message_id.value = rtext.get("id", "")
		show_success("Success !", 3)
		done.emit()
	# Deleted
	elif response_code == 204:
		show_success("And it is gone.")
		done.emit()
	else:
		show_error("Error: %s" % rtext, 5)
		print(rtext)

func run(_port : HBasePort) -> void:
	var msg = DiscordWebHook.new(webhook_url.value)
	#var r
	
	# Delete
	if _port == delete:
		request.request(webhook_url.value + "/messages/" + message_id.value, HEADERS, HTTPClient.METHOD_DELETE)
		return
	
	# Post or Edit
	if username.value:
		msg.username(username.value).profile_picture(avatar_url.value)
	msg.message(content.value).tts(tts.value)
	
	if embeds.value.size() > 10:
		show_error("Maximum of 10 embeds, sorry", 5)
		return
	
	for e in embeds.value:
		var _embed := msg.add_embed()
		if e.get("title"): _embed.title(e.title)
		if e.get("description"): _embed.description(e.description)
		if e.get("url"): _embed.url(e.url)
		if e.get("color"): _embed.color(e.color)
		if e.get("image"): _embed.image(e.image)
		if e.get("author_name"): _embed.author(e.author_name, e.get("author_url", ""), e.get("author_icon_url", ""))
		if e.get("footer_name"): _embed.footer(e.footer_name, e.get("footer_url", ""))
		
		for f in e.get("fields", []):
			_embed.add_field(f.name, f.value, f.inline)
	
	# Using HTTPRequest because otherwise it blocks the thread and lags...
	# Assume for now it's not needed for delete..
	if _port == post:
		#r = await msg.post()
		request.request(webhook_url.value + "?wait=true", HEADERS, HTTPClient.METHOD_POST, JSON.stringify(msg.get_parsed_data()))
	elif _port == edit:
		#r = await msg.edit(message_id.value)
		request.request(webhook_url.value + "/messages/" + message_id.value, HEADERS, HTTPClient.METHOD_PATCH, JSON.stringify(msg.get_parsed_data()))
	
	return

func update(_last_changed: HBasePort = null) -> void:
	if _last_changed in [type_, null]:
		get_ports_in_group("base").map(func (n): n.collapsed = type_.value != Action.MESSAGE)
		get_ports_in_group("embed").map(func (n): n.collapsed = type_.value != Action.EMBED)
		get_ports_in_group("field").map(func (n): n.collapsed = type_.value != Action.FIELD)
		update_slots()
	
	if type_.value == Action.EMBED:
		var _e = {
			"title": embed_title.value,
			"description": embed_description.value,
			"url": embed_url.value,
			"color": embed_color.value,
			"image": embed_image.value,
			"author_name": embed_author_name.value,
			"author_url": embed_author_link.value,
			"author_icon_url": embed_author_icon.value,
			"footer_name": embed_footer_name.value,
			"footer_url": embed_footer_icon.value,
			"fields": []
		}
		
		for f in fields.value:
			if f:
				_e.fields.append(f)
		
		# Remove empty values
		var _to_remove = []
		for k in _e:
			if not _e[k]:
				_to_remove.append(k)
		_to_remove.map(func (k): _e.erase(k))
		# Checks https
		for k: String in ["url", "image", "author_url", "author_icon_url", "footer_url"]:
			if _e.has(k) and _e[k].left(8).to_lower() != "https://":
				show_error("%s must be https://" % k, 5)
				return
		hide_messages()
		embed.value = _e
	
	
	if type_.value == Action.FIELD:
		var _f = {
			"name": field_name.value,
			"value": field_value.value,
			"inline": field_inline.value
		}
		# Checks value
		if not field_name.value or not field_value.value:
			show_error("Name and value cannot be empty.", 5)
			return
		hide_messages()
		
		field.value = _f
	
	
