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
	
func on_sse_connected():
	$HTTPSSEClient.new_sse_event.connect(on_new_sse_event)
	
func on_new_sse_event(headers, event, data):
	print("event id is: " + event)
	print(data)

func post_message(message: String):
	var url = "http://localhost:8080/processes/%s/agent/%s/actions/converse" % [process_id, agent]
	var headers = ["Content-Type: application/json", "Accept: text/event-stream"]
	var method = HTTPClient.METHOD_POST
	var body = JSON.stringify(message)
	$HTTPSSEClient.set_outgoing_request(method, url, headers, body)
		
func _set_process_id(result, response_code, headers, body):
	var json = JSON.new()
	json.parse(body.get_string_from_utf8())
	var response = json.get_data()
	process_id = response.process_id
	get_process_id.emit(process_id)
	_connect_sse()

func _connect_sse():
	var sub_url = "" # Add the "/sub_list_url" stuff here, including query parameters as needed; for demo purposes, I use the list path in my Firebase database, combined with ".json?auth=" and whatever the auth token is.
	$HTTPSSEClient.process_id = process_id
	$HTTPSSEClient.connected.connect(on_sse_connected)
	$HTTPSSEClient.connect_to_host("localhost", sub_url, 8080, true, false)
	

func _render_response(result, response_code, headers, body):	
	var json = JSON.new()
	json.parse(body.get_string_from_utf8())
	var response = json.get_data()
	if response is Dictionary:
		var message = response.data
		get_message.emit(message)
	
