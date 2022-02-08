extends LinkButton

func _pressed():
# warning-ignore:return_value_discarded
	OS.shell_open(get_text())
