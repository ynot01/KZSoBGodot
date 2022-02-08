extends ColorRect




func _on_Name_mouse_entered():
	if get_parent().get_text() == "WR✝":
		show()


func _on_Name_mouse_exited():
	hide()
