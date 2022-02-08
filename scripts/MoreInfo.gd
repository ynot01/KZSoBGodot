extends Button

func _pressed():
	get_parent().get_node("MoreInfoPop").popup_centered()
