extends CheckBox



func _on_CheckButton_toggled(button_pressed):
	if button_pressed:
		show()
	else:
		hide()
