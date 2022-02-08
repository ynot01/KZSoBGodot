extends TextureButton

func _ready():
	var settings = File.new()
	if settings.open("user://settings.dat", File.READ) == OK:
		settings.get_line() #GLMode, ignore
		settings.get_line() #PSMode, ignore
		settings.get_line() #DGMode, ignore
		if int(settings.get_line()) == 1:
			pressed = true
	settings.close()
