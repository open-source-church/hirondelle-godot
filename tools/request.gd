extends Node
class_name HRequest
## Handles api requests

var parent : Node

class HTTPResponse:
	var response_code: int
	var headers: Dictionary
	var body: PackedByteArray

	func _init(_response_code:int, _headers: Dictionary, _body: PackedByteArray):
		response_code = _response_code
		headers = _headers
		body = _body
	
	func to_json():
		var r = JSON.parse_string(body.get_string_from_utf8())
		if not r:
			return body.get_string_from_utf8()
		return r

	func _to_string() -> String:
		return JSON.stringify({
			"response_code": response_code,
			"headers": headers,
			"response": to_json()
		}, "\t")

var url_mask := "/%s"
var headers: PackedStringArray = []

var _requests := {}

func _init(_parent : Node):
	parent = _parent
	parent.add_child(self, false, Node.INTERNAL_MODE_BACK)

func GET(url: String, request_obj: Dictionary = {}, _headers := []) -> HTTPResponse:
	return await request(url, HTTPClient.METHOD_GET, request_obj, _headers)
func POST(url: String, request_obj: Dictionary = {}, _headers := []) -> HTTPResponse:
	return await request(url, HTTPClient.METHOD_POST, request_obj, _headers)
func DELETE(url: String, request_obj: Dictionary = {}, _headers := []) -> HTTPResponse:
	return await request(url, HTTPClient.METHOD_DELETE, request_obj, _headers)
func PATCH(url: String, request_obj: Dictionary = {}, _headers := []) -> HTTPResponse:
	return await request(url, HTTPClient.METHOD_PATCH, request_obj, _headers)
func PUT(url: String, request_obj: Dictionary = {}, _headers := []) -> HTTPResponse:
	return await request(url, HTTPClient.METHOD_PUT, request_obj, _headers)

func request(endpoint: String, method := HTTPClient.METHOD_GET, request_obj := {}, _headers := []) -> HTTPResponse:
	var client = HTTPRequest.new()
	parent.add_child(client)
	var request_id := randi()
	client.request_completed.connect(_on_request_completed.bind(request_id))
	
	var url := url_mask % endpoint
	var request_data := ""
	if request_obj and method == HTTPClient.METHOD_GET:
		var query := "?"
		for k in request_obj:
			query += "%s=%s" % [k, str(request_obj[k]).uri_encode()]
		url += query
	elif method != HTTPClient.METHOD_GET:
		request_data = JSON.stringify(request_obj)
	
	for h in headers:
		_headers.append(h)
	
	client.request(url, _headers, method, request_data)
	while not request_id in _requests:
		await parent.get_tree().process_frame
	
	var r = _requests[request_id]
	_requests.erase(request_id)
	client.queue_free()
	return r

func _on_request_completed(_result: int, response_code: int, _headers: PackedStringArray,
						   body: PackedByteArray, request_id: int) -> void:
	var headers_dict = {}
	for h in headers:
		headers_dict[h.split(":")[0]] = ":".join(h.split(":").slice(1))
	
	_requests[request_id] = HTTPResponse.new(response_code, headers_dict, body)
