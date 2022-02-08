extends CheckButton



func _on_HTTPRequest_request_completed(_result, _response_code, _headers, _body):
	if get_parent().get_node("HTTPRequest").order > get_parent().get_node("HTTPRequest").maxorder:
		disabled = false
