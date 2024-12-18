extends Node
class_name HDownloader

var http_request : HTTPRequest

signal content_downloaded(Variant)

var content : Variant

func _ready():
	# Create an HTTP request node and connect its completion signal.
	http_request = HTTPRequest.new()
	add_child(http_request)
	http_request.request_completed.connect(self._http_request_completed)

func get_url(url : String):
	content = null
	
	http_request.cancel_request()
	var error = http_request.request(url)
	if error != OK:
		push_error("An error occurred in the HTTP request.")
	
	await http_request.request_completed
	
	return content

## Extract the value of [param prop] in [param headers].
func get_header_prop(headers: PackedStringArray, prop: String) -> String:
	var regex = RegEx.new()
	regex.compile("%s:\\s*(.*)" % prop.to_lower()) 
	
	for h in headers:
		var result = regex.search(h.to_lower())
		if result:
			return result.strings[1].to_lower()
	return ""

# Called when the HTTP request is completed.
func _http_request_completed(result: int, _response_code: int, headers: PackedStringArray, body: PackedByteArray):
	#print("Request completed: ", result, response_code, headers)
	
	if  result != HTTPRequest.RESULT_SUCCESS:
		push_error("Error somewhere.")
	
	var ctype = get_header_prop(headers, "content-type")
	#print(headers)
	print("Downloaded content-type: ", ctype)
	
	if ctype == "application/json":
		var r = JSON.parse_string(body.get_string_from_utf8())
		content_downloaded.emit(r)
		content = r
	
	if ctype == "image/png":
		var image = Image.new()
		var error = image.load_png_from_buffer(body)
		if error != OK:
			push_error("Couldn't load the image.")
		content_downloaded.emit(image)
		content = image
	
	if ctype in ["image/jpg", "image/jpeg"]:
		var image = Image.new()
		var error = image.load_jpg_from_buffer(body)
		if error != OK:
			push_error("Couldn't load the image.")
		content_downloaded.emit(image)
		content = image
	
	if ctype in ["image/webp"]:
		var image = Image.new()
		var error = image.load_webp_from_buffer(body)
		if error != OK:
			push_error("Couldn't load the image.")
		content_downloaded.emit(image)
		content = image
	
	if ctype in ["audio/mpeg"]:
		var stream := AudioStreamMP3.new()
		stream.data = body
		content_downloaded.emit(stream)
		content = stream
