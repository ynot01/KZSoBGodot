extends TextureButton

onready var Pop = get_parent().get_node("PopupDialog")

var cur_playing
var steam_dir
var lastRNG = -1

func _ready():
	var saveread = File.new()
	if saveread.open("user://kz_path.dat", File.READ) == OK:
		steam_dir = saveread.get_as_text()
		saveread.close()
	else:
		saveread.close()
		return
	
	var songread = File.new()
	if songread.open("user://song.dat", File.READ) == OK:
		lastRNG = int(songread.get_as_text()) - 1
		songread.close()
		
		var dir = Directory.new()
		
		if dir.open(steam_dir) != OK:
			Pop.pop("Failed to retrieve folder!")
			steam_dir = false
			return
		else:
			var savewrite = File.new()
			savewrite.open("user://kz_path.dat", File.WRITE)
			savewrite.store_string(steam_dir)
			savewrite.close()
		
		dir.list_dir_begin(true,true)
		var file_name = dir.get_next()
		
		var songs = []
		
		while file_name != "":
			if !dir.current_is_dir() and file_name.begins_with("song_") and file_name.get_extension() == "ogg":
				songs.insert(songs.size(), file_name)
			file_name = dir.get_next()
		
		if songs.size() == 0:
			Pop.pop("No songs in this folder!")
			steam_dir = false
			return
			
		cur_playing = songs[lastRNG]
		
		var snd_file = File.new()
		snd_file.open(steam_dir+"/"+cur_playing, File.READ)
		var stream = AudioStreamOGGVorbis.new()
		stream.data = snd_file.get_buffer(snd_file.get_len())
		stream.loop = true
		$AudioStreamPlayer.leng = stream.get_length()
		$AudioStreamPlayer.stream = stream
		snd_file.close()
		
		$Songname.text = str(lastRNG+1)+". "+cur_playing.get_basename().substr(5)
		$AudioStreamPlayer.play()
		get_parent().get_node("SongTime").lastmove = 0
		$ElectroBop.frame = 0
		$ElectroBop.playing = true
		
	else:
		songread.close()
		return

func _gui_input(event):
	
	if !event.is_action_pressed("click") and !event.is_action_pressed("rightclick") and !event.is_action_pressed("midclick"):
		return
	
	$AudioStreamPlayer.stop()
	
	if !steam_dir:
		$FileDialog.popup_centered()
		$FileDialog.window_title = "Select Katana ZERO folder"
		return
	
	var dir = Directory.new()
	
	if dir.open(steam_dir) != OK:
		Pop.pop("Failed to retrieve folder!")
		steam_dir = false
		return
	else:
		var savewrite = File.new()
		savewrite.open("user://kz_path.dat", File.WRITE)
		savewrite.store_string(steam_dir)
		savewrite.close()
	
	dir.list_dir_begin(true,true)
	var file_name = dir.get_next()
	
	var songs = []
	
	while file_name != "":
		if !dir.current_is_dir() and file_name.begins_with("song_") and file_name.get_extension() == "ogg":
			songs.insert(songs.size(), file_name)
		file_name = dir.get_next()
	
	if songs.size() == 0:
		Pop.pop("No songs in this folder!")
		steam_dir = false
		return
	
	if event.is_action_pressed("midclick"):
		var rng = RandomNumberGenerator.new()
		var randnum = lastRNG
		while lastRNG == randnum:
			rng.randomize()
			randnum = rng.randi_range(0,songs.size()-1)
			cur_playing = songs[randnum]
		lastRNG = randnum
	elif event.is_action_pressed("rightclick"):
		if songs.size() == lastRNG + 1:
			lastRNG = -1
		cur_playing = songs[lastRNG + 1]
		lastRNG += 1
	elif event.is_action_pressed("click"):
		if lastRNG <= 0:
			lastRNG = songs.size()
		cur_playing = songs[lastRNG - 1]
		lastRNG -= 1
	
	var snd_file = File.new()
	snd_file.open(steam_dir+"/"+cur_playing, File.READ)
	var stream = AudioStreamOGGVorbis.new()
	stream.data = snd_file.get_buffer(snd_file.get_len())
	stream.loop = true
	$AudioStreamPlayer.leng = stream.get_length()
	$AudioStreamPlayer.stream = stream
	snd_file.close()
	
	$Songname.text = str(lastRNG+1)+". "+cur_playing.get_basename().substr(5)
	$AudioStreamPlayer.play()
	get_parent().get_node("SongTime").lastmove = 0
	$ElectroBop.frame = 0
	$ElectroBop.playing = true
	
	var songwrite = File.new()
	songwrite.open("user://song.dat", File.WRITE)
	songwrite.store_string(str(lastRNG+1))
	songwrite.close()

func _on_FileDialog_dir_selected(dir):
	steam_dir = dir
	_pressed()


func _on_SongVolume_value_changed(value):
	AudioServer.get_bus_effect(0,0).set_volume_db(value-80)


func _on_SongTime_gui_input(event):
	if event.is_action_released("click"):
		get_parent().get_node("SongTime").editable = true
	
	if event.is_action_pressed("click"):
		get_parent().get_node("SongTime").lastmove = INF
		yield(get_tree().create_timer(0), "timeout")
		get_parent().get_node("SongTime").editable = false
		$AudioStreamPlayer.seek(get_parent().get_node("SongTime").value)
		get_parent().get_node("SongTime").lastmove = 0
