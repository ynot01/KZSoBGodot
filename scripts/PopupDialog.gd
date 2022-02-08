extends PopupDialog


func pop(msg):
	popup_centered()
	if msg:
		$Label.text = msg
