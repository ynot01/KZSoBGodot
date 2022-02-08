extends HSlider

func _ready():
	var saveread = File.new()
	if saveread.open("user://volume.dat", File.READ) == OK:
		value = float(saveread.get_as_text())
	saveread.close()

func _gui_input(event):
	if event.is_action_released("click"):
		var savewrite = File.new()
		savewrite.open("user://volume.dat", File.WRITE)
		savewrite.store_string(str(value))
		savewrite.close()
