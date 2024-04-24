extends Node

signal new_sse_event(headers, event, data)
signal connected
signal connection_error(error)

const event_tag = "id:"
const data_tag = "data:"
const continue_internal = "continue_internal"

var httpclient = HTTPClient.new()
var is_connected = false

var domain
var url_after_domain
var port
var use_ssl
var verify_host
var told_to_connect = false
var outgoing_request = null
var connection_in_progress = false
var request_in_progress = false
var is_requested = false
var response_body = PackedByteArray()

var process_id

func connect_to_host(domain : String, url_after_domain : String, port : int = -1, use_ssl : bool = false, verify_host : bool = true):
	self.domain = domain
	self.url_after_domain = url_after_domain
	self.port = port
	self.use_ssl = use_ssl
	self.verify_host = verify_host
	told_to_connect = true

func attempt_to_connect():
	var err = httpclient.connect_to_host(domain, port)
	if err == OK:
		emit_signal("connected")
		is_connected = true
	else:
		emit_signal("connection_error", str(err))

func attempt_to_request(httpclient_status):
	if httpclient_status == HTTPClient.STATUS_CONNECTING or httpclient_status == HTTPClient.STATUS_RESOLVING:
		return
	
	if httpclient_status == HTTPClient.STATUS_CONNECTION_ERROR: attempt_to_connect()
	
	if httpclient_status == HTTPClient.STATUS_CONNECTED:
		var err = httpclient.request(outgoing_request["method"], outgoing_request["url"], outgoing_request["headers"], outgoing_request["body"])
		if err == OK:
			outgoing_request = null
			is_requested = true

func _process(delta):
	if !told_to_connect:
		return
		
	if !is_connected:
		if !connection_in_progress:
			attempt_to_connect()
			connection_in_progress = true
		return
		
	httpclient.poll()
	var httpclient_status = httpclient.get_status()
	if outgoing_request:
		if !is_requested:
			if !request_in_progress:
				attempt_to_request(httpclient_status)
			return
		
	var httpclient_has_response = httpclient.has_response()
		
	if httpclient_has_response or httpclient_status == HTTPClient.STATUS_BODY:
		var headers = httpclient.get_response_headers_as_dictionary()
		httpclient.poll()
		var chunk = httpclient.read_response_body_chunk()
		if(chunk.size() == 0):
			return
		else:
			response_body = response_body + chunk
			
		var json = JSON.new()
		var body = response_body.get_string_from_utf8()
		if body:
			var event_data = get_event_data(body)
			if event_data.event != "keep-alive" and event_data.event != continue_internal:
				var result = event_data.data
				if response_body.size() > 0 and result: # stop here if the value doesn't parse
					response_body.resize(0)
					emit_signal("new_sse_event", headers, event_data.event, result)
			else:
				if event_data.event != continue_internal:
					response_body.resize(0)

func set_outgoing_request(method, url, headers, body):
	if not outgoing_request:
		outgoing_request = {"method":method, "url":url, "headers":headers, "body":body}

func get_event_data(body : String) -> Dictionary:
	var json = JSON.new()
	body = body.strip_edges()
	var result = {}
	var event_idx = body.find(event_tag)
	if event_idx == -1:
		result["event"] = continue_internal
		return result
	assert(event_idx != -1)
	var data_idx = body.find(data_tag)
	assert(data_idx != -1)
	var event = body.substr(event_idx, data_idx)
	event = event.replace(event_tag, "").strip_edges()
	assert(event)
	assert(event.length() > 0)
	result["event"] = event
	var data = body.right(-(data_idx + data_tag.length())).strip_edges()
	assert(data)
	assert(data.length() > 0)
	result["data"] = JSON.parse_string(data)
	return result

func _exit_tree():
	if httpclient:
		httpclient.close()

func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		if httpclient:
			httpclient.close()
		get_tree().quit()
