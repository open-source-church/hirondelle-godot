extends RefCounted
class_name TwitchingDownloader

static func download(url: String) -> Variant:
	var err = 0
	var http = HTTPClient.new() # Create the Client.
	
	var host = url.substr(0, 8) + url.substr(8).split("/")[0]
	url = "/" + "/".join(url.substr(8).split("/").slice(1))
	
	err = http.connect_to_host(host)
	assert(err == OK)
	
	while http.get_status() == HTTPClient.STATUS_CONNECTING or http.get_status() == HTTPClient.STATUS_RESOLVING:
		http.poll()
		await Engine.get_main_loop().create_timer(0.1).timeout
	
	assert(http.get_status() == HTTPClient.STATUS_CONNECTED) # Check if the connection was made successfully.
	http.request(HTTPClient.METHOD_GET, url, [])
	
	while http.get_status() == HTTPClient.STATUS_REQUESTING:
		# Keep polling for as long as the request is being processed.
		http.poll()
		await Engine.get_main_loop().create_timer(0.1).timeout
	
	var headers: Dictionary
	var response_code: int
	
	if http.has_response():
		# If there is a response...

		headers = http.get_response_headers_as_dictionary() # Get response headers.
		response_code = http.get_response_code()
		
		var rb = PackedByteArray() # Array that will hold the data.

		while http.get_status() == HTTPClient.STATUS_BODY:
			# While there is body left to be read
			http.poll()
			# Get a chunk.
			var chunk = http.read_response_body_chunk()
			if chunk.size() == 0:
				await Engine.get_main_loop().create_timer(0.1).timeout
			else:
				rb = rb + chunk # Append to read buffer.

		return parse_response(rb, headers)
	
	return null

static func parse_response(response: PackedByteArray, headers: Dictionary) -> Variant:
	var ctype = headers["Content-Type"]
	if ctype == "image/png":
		var image = Image.new()
		var error = image.load_png_from_buffer(response)
		if error != OK:
			push_error("Couldn't load the image.")
		return image
	
	elif ctype in ["image/jpg", "image/jpeg"]:
		var image = Image.new()
		var error = image.load_jpg_from_buffer(response)
		if error != OK:
			push_error("Couldn't load the image.")
		return image
	
	else:
		# Unmanaged content
		print("[TwitchingDownloader] Unrecognized content type: ", ctype)
		return null
