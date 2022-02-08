extends TextureButton

func _ready():
	var settings = File.new()
	if settings.open("user://settings.dat", File.READ) == OK:
		settings.get_line() #GLMode, ignore
		settings.get_line() #PSMode, ignore
		if settings.get_line() == "True":
			pressed = true
			$FifteenCombat.show()
			$FifteenIdle.hide()
	settings.close()

func _toggled(btn):
	if btn:
		$FifteenCombat.show()
		$FifteenIdle.hide()
	else:
		$FifteenCombat.hide()
		$FifteenIdle.show()
