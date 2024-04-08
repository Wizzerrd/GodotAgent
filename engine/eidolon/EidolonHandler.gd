extends Node

var process_id = ""

var agent = "pirate_agent"
var title = "first meeting"

signal get_process_id(process_id: String)
signal get_message(message: String)


func _ready():
	var post_req = HTTPRequest.new()
	add_child(post_req)
	post_req.request_completed.connect(_set_process_id)
	var url = "http://localhost:8080/processes"
	var headers = ["Content-Type: application/json"]
	var method = HTTPClient.METHOD_POST
	var body = JSON.stringify({
		"agent": agent,
		"title": title
	})
	post_req.request(url, headers, method, body)

func post_message(message: String):
	var post_req = HTTPRequest.new()
	add_child(post_req)
	post_req.request_completed.connect(_render_response)
	var url = "http://localhost:8080/processes/%s/agent/%s/actions/converse" % [process_id, agent]
	var headers = ["Content-Type: application/json"]
	var method = HTTPClient.METHOD_POST
	var body = JSON.stringify(message)
	post_req.request(url, headers, method, body)
		
func _set_process_id(result, response_code, headers, body):
	var json = JSON.new()
	json.parse(body.get_string_from_utf8())
	var response = json.get_data()
	process_id = response.process_id
	get_process_id.emit(process_id)

func _render_response(result, response_code, headers, body):	
	var json = JSON.new()
	json.parse(body.get_string_from_utf8())
	var response = json.get_data()
	if response is Dictionary:
		var message = response.data
		get_message.emit(message)
	
