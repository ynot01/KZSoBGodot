extends HSlider

var lastmove = 0

func _process(_delta):
	if OS.get_ticks_msec() < lastmove:
		return
	
	if get_parent().get_node("JamStart/AudioStreamPlayer").playing:
		max_value = get_parent().get_node("JamStart/AudioStreamPlayer").leng
		value = get_parent().get_node("JamStart/AudioStreamPlayer").get_playback_position()
	
	lastmove = OS.get_ticks_msec()
