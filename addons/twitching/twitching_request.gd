extends Node
class_name TwitchingRequest
## Handles twitch api requests

## Useful: https://twitch-api-swagger.surge.sh/scalar/

const HOST = "https://api.twitch.tv"
const URL_MASK = "/helix/%s"

var twitching : Twitching

func _init(_twitching : Twitching):
	twitching = _twitching

func GET(url: String, request_obj: Dictionary = {}) -> TwitchingHTTPResponse:
	return await request(twitching, url, HTTPClient.METHOD_GET, request_obj)
func POST(url: String, request_obj: Dictionary = {}) -> TwitchingHTTPResponse:
	return await request(twitching, url, HTTPClient.METHOD_POST, request_obj)
func DELETE(url: String, request_obj: Dictionary = {}) -> TwitchingHTTPResponse:
	return await request(twitching, url, HTTPClient.METHOD_DELETE, request_obj)
func PATCH(url: String, request_obj: Dictionary = {}) -> TwitchingHTTPResponse:
	return await request(twitching, url, HTTPClient.METHOD_PATCH, request_obj)

static func request(twitching : Twitching, url: String, 
			method: HTTPClient.Method = HTTPClient.METHOD_GET, request_obj: Dictionary = {}) -> TwitchingHTTPResponse:
	var err = 0
	var http = HTTPClient.new() # Create the Client.
	http.connect_to_host(HOST, 443, TLSOptions.client())
	while http.get_status() == HTTPClient.STATUS_CONNECTING or http.get_status() == HTTPClient.STATUS_RESOLVING:
		http.poll()
		await twitching.get_tree().process_frame
	
	# Removes first "/" if provided
	var _url := url
	if url and url[0] == "/": _url = url.substr(1)
	_url = URL_MASK % _url
	# Encodes parameter if method is GET
	var _request_obj = request_obj.duplicate()
	if request_obj and method == HTTPClient.METHOD_GET:
		_url += "?%s" % http.query_string_from_dict(request_obj)
		_request_obj = {}
	
	var body : String = JSON.stringify(_request_obj) if _request_obj else ""
	
	http.request(method, _url, twitching.auth.get_headers(), body)
	
	while http.get_status() == HTTPClient.STATUS_REQUESTING:
		# Keep polling for as long as the request is being processed.
		http.poll()
		await twitching.get_tree().process_frame
	
	var _headers: Dictionary
	var _response_code: int
	var _response_obj: Dictionary
	
	if http.has_response():
		# If there is a response...

		_headers = http.get_response_headers_as_dictionary() # Get response headers.
		_response_code = http.get_response_code()
		
		# Authorization invalid
		if _response_code == 401:
			# Trie to use the refresh token
			print("[TwitchingRequest] Requesting refresh token...")
			var success  = await twitching.auth.use_refresh_token()
			# New access token, try again
			if success:
				return await request(twitching, url, method, request_obj)
			# Failed
			else:
				return TwitchingHTTPResponse.new(_response_code, _headers, _response_obj)
			
		var rb = PackedByteArray() # Array that will hold the data.
		while http.get_status() == HTTPClient.STATUS_BODY:
			# While there is body left to be read
			http.poll()
			# Get a chunk.
			var chunk = http.read_response_body_chunk()
			if chunk.size() == 0:
				await twitching.get_tree().process_frame
			else:
				rb = rb + chunk # Append to read buffer.

		var text = rb.get_string_from_utf8()
		if text:
			_response_obj = JSON.parse_string(text)
	
	return TwitchingHTTPResponse.new(_response_code, _headers, _response_obj)
