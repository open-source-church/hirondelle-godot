extends RefCounted
class_name TwitchingHTTPResponse

var response_code: int
var headers: Dictionary
var response: Dictionary

func _init(_response_code:int, _headers: Dictionary, _response: Dictionary):
	response_code = _response_code
	headers = _headers
	response = _response

func _to_string() -> String:
	return JSON.stringify({
		"response_code": response_code,
		"headers": headers,
		"response": response
	}, "\t")
