extends GridContainer

onready var Pop = get_parent().get_node("PopupDialog")
const LevelCont = preload("res://scenes/LevelCont.tscn")

var WROverride = {}
var WRMode = false

var GLMode = false
var PSMode = false

var DGMode = false

var SoBMode = true

var HMode = 0

var Medal = {
	"0":load("res://medals/none.png"),
	"1":load("res://medals/bronze.png"),
	"2":load("res://medals/silver.png"),
	"3":load("res://medals/gold.png"),
	"4":load("res://medals/platinum.png"),
}

var ZeroRun = load("res://btns/zero_run_sheet.png")
var FifteenRun = load("res://btns/fifteen_run_sheet.png")

var LevelID = {
	"xd0l1z4d":"Factory",
	"n93816zw":"Hotel",
	"z98e31p9":"Club",
	"rdnr7e7w":"Prison",
	"ldyjxmrd":"Studio",
	"nwln5red":"Mansion",
	"yweny67w":"Chinatown",
	"69zx5kgd":"Drg.tape",
	"r9grlvpw":"Sltr.house",
	"o9xkgppw":"Bunker",
	"495y273w":"Bunker Pt.2",
	"o9xkg8pw":"Psychotherapy"
}

var Factory = {"Name":"Factory","Image":load("res://levels/Factory.png"),"Loaded":true,"DGImage":load("res://levels_dragon/Factory.png")}
var Hotel = {"Name":"Hotel","Image":load("res://levels/Hotel.png"),"Loaded":true,"DGImage":load("res://levels_dragon/Hotel.png")}
var Club = {"Name":"Club","Image":load("res://levels/Club.png"),"Loaded":true,"DGImage":load("res://levels_dragon/Club.png")}
var Prison = {"Name":"Prison","Image":load("res://levels/Prison.png"),"Loaded":true,"DGImage":load("res://levels_dragon/Prison.png")}
var Studio = {"Name":"Studio","Image":load("res://levels/Studio.png"),"Loaded":true,"DGImage":load("res://levels_dragon/Studio.png")}
var Mansion = {"Name":"Mansion","Image":load("res://levels/Mansion.png"),"Loaded":true,"DGImage":load("res://levels_dragon/Mansion.png")}
var Chinatown = {"Name":"Chinatown","Image":load("res://levels/Chinatown.png"),"Loaded":true,"DGImage":load("res://levels_dragon/Chinatown.png")}
var Drgtape = {"Name":"Drg.tape","Image":load("res://levels/Drgtape.png"),"Loaded":true,"DGImage":load("res://levels_dragon/Drgtape.png")}
var Sltrhouse = {"Name":"Sltr.house","Image":load("res://levels/Sltrhouse.png"),"Loaded":true,"DGImage":load("res://levels_dragon/Sltrhouse.png")}
var Bunker = {"Name":"Bunker","Image":load("res://levels/Bunker.png"),"Loaded":true,"DGImage":load("res://levels_dragon/Bunker.png")}
var BunkerPt2 = {"Name":"Bunker Pt.2","Image":load("res://levels/BunkerPt2.png"),"Loaded":true,"DGImage":load("res://levels_dragon/BunkerPt2.png")}
var Psychotherapy = {"Name":"Psychotherapy","Image":load("res://levels/Psychotherapy.png"),"Loaded":false,"DGImage":load("res://levels_dragon/Psychotherapy.png")}

var Levels = [Factory,Hotel,Club,Prison,Studio,Mansion,Chinatown,Drgtape,Sltrhouse,Bunker,BunkerPt2,Psychotherapy]

var lastrefresh = 0
func _process(_delta):
	if OS.get_ticks_msec() < lastrefresh + 15000:
		return
	
	refresh()
	lastrefresh = OS.get_ticks_msec()

func format_time(secinput):
	var numsec = float(secinput)
	var hrs = str(floor(numsec/3600.0))
	var mins = str(floor(fmod(numsec/60, 60)))
	var secs = str(floor(fmod(numsec,60)))
	var msecs = str(fmod(numsec,1)*100)
	
	if msecs.length() == 1:
		msecs = "0"+msecs
	
	if int(hrs) > 0:
		if mins.length() == 1:
			mins = "0"+mins
		if secs.length() == 1:
			secs = "0"+secs
		
		return hrs+":"+mins+":"+secs+"."+msecs
	
	if int(mins) > 0:
		if secs.length() == 1:
			secs = "0"+secs
		return mins+":"+secs+"."+msecs
	
	return secs+"."+msecs

func _ready():
	var settings = File.new()
	if settings.open("user://settings.dat", File.READ) == OK:
		if settings.get_line() == "True":
			GLMode = true
		if settings.get_line() == "True":
			PSMode = true
		if settings.get_line() == "True":
			DGMode = true
		HMode = int(settings.get_line())
	settings.close()
	refresh()


func refresh():
	
	var settings = File.new()
	settings.open("user://settings.dat", File.WRITE)
	settings.store_line(str(GLMode))
	settings.store_line(str(PSMode))
	settings.store_line(str(DGMode))
	settings.store_line(str(HMode))
	settings.close()
	
	if PSMode:
		for lvl in Levels:
			lvl["Loaded"] = true
	
	if GLMode:
		for lvl in Levels:
			if GoldenDisabled.has(lvl["Name"]):
				lvl["Loaded"] = false
			else:
				lvl["Loaded"] = true
	
	if !PSMode and !GLMode:
		for lvl in Levels:
			if lvl["Name"] == "Psychotherapy":
				lvl["Loaded"] = false
			else:
				lvl["Loaded"] = true
	
	if !WRMode:
		# C:/Users/ynot01/AppData/Local/Katana_ZERO/KatanaSpeedrunOpt.zero
		var file = File.new()
		
		var drive = OS.get_environment("windir").rstrip("WINDOWS")
		var user = OS.get_environment("USERNAME")
		
		var failed = false
		
		if !DGMode:
			if file.open(drive+"/users/"+user+"/AppData/Local/Katana_ZERO/KatanaSpeedrunOpt.zero", File.READ) != OK:
				failed = true
		else:
			if file.open(drive+"/users/"+user+"/AppData/Local/Katana_FIFTEEN/KatanaSpeedrunOpt.zero", File.READ) != OK:
				failed = true
		
		for n in get_children():
			remove_child(n)
			n.queue_free()
		
		var content = {}
		if failed:
			pass
		else:
			content = file.get_as_text().split("\n", true)
		
		if failed:
			for n in Levels:
				n["Time"] = "0"
				n["Deaths"] = "0"
				n["Medal"] = "0"
		
		if !HMode and !failed:
			# Arrays start at zero. Lines start at 1. Line - 1 will give you the proper array index.
			if content[38] != "-1":
				Factory["Time"] = content[38]
				Factory["Deaths"] = content[39]
				Factory["Medal"] = content[40]
			else:
				Factory["Time"] = "0"
				Factory["Deaths"] = "0"
				Factory["Medal"] = "0"
			
			if content[56] != "-1":
				Hotel["Time"] = content[56]
				Hotel["Deaths"] = content[57]
				Hotel["Medal"] = content[58]
			else:
				Hotel["Time"] = "0"
				Hotel["Deaths"] = "0"
				Hotel["Medal"] = "0"
			
			if content[74] != "-1":
				Club["Time"] = content[74]
				Club["Deaths"] = content[75]
				Club["Medal"] = content[76]
			else:
				Club["Time"] = "0"
				Club["Deaths"] = "0"
				Club["Medal"] = "0"
			
			if content[92] != "-1":
				Prison["Time"] = content[92]
				Prison["Deaths"] = content[93]
				Prison["Medal"] = content[94]
			else:
				Prison["Time"] = "0"
				Prison["Deaths"] = "0"
				Prison["Medal"] = "0"
			
			if content[110] != "-1":
				Studio["Time"] = content[110]
				Studio["Deaths"] = content[111]
				Studio["Medal"] = content[112]
			else:
				Studio["Time"] = "0"
				Studio["Deaths"] = "0"
				Studio["Medal"] = "0"
			
			if content[128] != "-1":
				Mansion["Time"] = content[128]
				Mansion["Deaths"] = content[129]
				Mansion["Medal"] = content[130]
			else:
				Mansion["Time"] = "0"
				Mansion["Deaths"] = "0"
				Mansion["Medal"] = "0"
			
			if content[146] != "-1":
				Chinatown["Time"] = content[146]
				Chinatown["Deaths"] = content[147]
				Chinatown["Medal"] = content[148]
			else:
				Chinatown["Time"] = "0"
				Chinatown["Deaths"] = "0"
				Chinatown["Medal"] = "0"
			
			if content[164] != "-1":
				Drgtape["Time"] = content[164]
				Drgtape["Deaths"] = content[165]
				Drgtape["Medal"] = content[166]
			else:
				Drgtape["Time"] = "0"
				Drgtape["Deaths"] = "0"
				Drgtape["Medal"] = "0"
			
			if content[182] != "-1":
				Sltrhouse["Time"] = content[182]
				Sltrhouse["Deaths"] = content[183]
				Sltrhouse["Medal"] = content[184]
			else:
				Sltrhouse["Time"] = "0"
				Sltrhouse["Deaths"] = "0"
				Sltrhouse["Medal"] = "0"
			
			if content[200] != "-1":
				Bunker["Time"] = content[200]
				Bunker["Deaths"] = content[201]
				Bunker["Medal"] = content[202]
			else:
				Bunker["Time"] = "0"
				Bunker["Deaths"] = "0"
				Bunker["Medal"] = "0"
			
			if content[218] != "-1":
				BunkerPt2["Time"] = content[218]
				BunkerPt2["Deaths"] = content[219]
				BunkerPt2["Medal"] = content[220]
			else:
				BunkerPt2["Time"] = "0"
				BunkerPt2["Deaths"] = "0"
				BunkerPt2["Medal"] = "0"
			
			if content[236] != "-1":
				Psychotherapy["Time"] = content[236]
				Psychotherapy["Deaths"] = content[237]
				Psychotherapy["Medal"] = content[238]
			else:
				Psychotherapy["Time"] = "0"
				Psychotherapy["Deaths"] = "0"
				Psychotherapy["Medal"] = "0"
		elif !failed:
			if content[47] != "-1":
				Factory["Time"] = content[47]
				Factory["Deaths"] = content[48]
				Factory["Medal"] = content[49]
			else:
				Factory["Time"] = "0"
				Factory["Deaths"] = "0"
				Factory["Medal"] = "0"
			
			if content[65] != "-1":
				Hotel["Time"] = content[65]
				Hotel["Deaths"] = content[66]
				Hotel["Medal"] = content[67]
			else:
				Hotel["Time"] = "0"
				Hotel["Deaths"] = "0"
				Hotel["Medal"] = "0"
			
			if content[83] != "-1":
				Club["Time"] = content[83]
				Club["Deaths"] = content[84]
				Club["Medal"] = content[85]
			else:
				Club["Time"] = "0"
				Club["Deaths"] = "0"
				Club["Medal"] = "0"
			
			if content[101] != "-1":
				Prison["Time"] = content[101]
				Prison["Deaths"] = content[102]
				Prison["Medal"] = content[103]
			else:
				Prison["Time"] = "0"
				Prison["Deaths"] = "0"
				Prison["Medal"] = "0"
			
			if content[119] != "-1":
				Studio["Time"] = content[119]
				Studio["Deaths"] = content[120]
				Studio["Medal"] = content[121]
			else:
				Studio["Time"] = "0"
				Studio["Deaths"] = "0"
				Studio["Medal"] = "0"
			
			if content[137] != "-1":
				Mansion["Time"] = content[137]
				Mansion["Deaths"] = content[138]
				Mansion["Medal"] = content[139]
			else:
				Mansion["Time"] = "0"
				Mansion["Deaths"] = "0"
				Mansion["Medal"] = "0"
			
			if content[155] != "-1":
				Chinatown["Time"] = content[155]
				Chinatown["Deaths"] = content[156]
				Chinatown["Medal"] = content[157]
			else:
				Chinatown["Time"] = "0"
				Chinatown["Deaths"] = "0"
				Chinatown["Medal"] = "0"
			
			if content[173] != "-1":
				Drgtape["Time"] = content[173]
				Drgtape["Deaths"] = content[174]
				Drgtape["Medal"] = content[175]
			else:
				Drgtape["Time"] = "0"
				Drgtape["Deaths"] = "0"
				Drgtape["Medal"] = "0"
			
			if content[191] != "-1":
				Sltrhouse["Time"] = content[191]
				Sltrhouse["Deaths"] = content[192]
				Sltrhouse["Medal"] = content[193]
			else:
				Sltrhouse["Time"] = "0"
				Sltrhouse["Deaths"] = "0"
				Sltrhouse["Medal"] = "0"
			
			if content[209] != "-1":
				Bunker["Time"] = content[209]
				Bunker["Deaths"] = content[210]
				Bunker["Medal"] = content[211]
			else:
				Bunker["Time"] = "0"
				Bunker["Deaths"] = "0"
				Bunker["Medal"] = "0"
			
			if content[227] != "-1":
				BunkerPt2["Time"] = content[227]
				BunkerPt2["Deaths"] = content[228]
				BunkerPt2["Medal"] = content[229]
			else:
				BunkerPt2["Time"] = "0"
				BunkerPt2["Deaths"] = "0"
				BunkerPt2["Medal"] = "0"
			
			if content[245] != "-1":
				Psychotherapy["Time"] = content[245]
				Psychotherapy["Deaths"] = content[246]
				Psychotherapy["Medal"] = content[247]
			else:
				Psychotherapy["Time"] = "0"
				Psychotherapy["Deaths"] = "0"
				Psychotherapy["Medal"] = "0"
	elif DGMode:
		for n in get_children():
			remove_child(n)
			n.queue_free()
		for n in Levels:
			n["Time"] = "0"
			n["Deaths"] = ""
			n["Medal"] = "0"
	else:
		for n in get_children():
			remove_child(n)
			n.queue_free()
		Factory["Time"] = WROverride["Factory"][HMode]["runs"][0]["run"]["times"]["primary_t"]
		Factory["Deaths"] = ""
		Factory["Medal"] = "0"
		Hotel["Time"] = WROverride["Hotel"][HMode]["runs"][0]["run"]["times"]["primary_t"]
		Hotel["Deaths"] = ""
		Hotel["Medal"] = "0"
		Club["Time"] = WROverride["Club"][HMode]["runs"][0]["run"]["times"]["primary_t"]
		Club["Deaths"] = ""
		Club["Medal"] = "0"
		Prison["Time"] = WROverride["Prison"][HMode]["runs"][0]["run"]["times"]["primary_t"]
		Prison["Deaths"] = ""
		Prison["Medal"] = "0"
		Studio["Time"] = WROverride["Studio"][HMode]["runs"][0]["run"]["times"]["primary_t"]
		Studio["Deaths"] = ""
		Studio["Medal"] = "0"
		Mansion["Time"] = WROverride["Mansion"][HMode]["runs"][0]["run"]["times"]["primary_t"]
		Mansion["Deaths"] = ""
		Mansion["Medal"] = "0"
		Chinatown["Time"] = WROverride["Chinatown"][HMode]["runs"][0]["run"]["times"]["primary_t"]
		Chinatown["Deaths"] = ""
		Chinatown["Medal"] = "0"
		Drgtape["Time"] = WROverride["Drg.tape"][HMode]["runs"][0]["run"]["times"]["primary_t"]
		Drgtape["Deaths"] = ""
		Drgtape["Medal"] = "0"
		Sltrhouse["Time"] = WROverride["Sltr.house"][HMode]["runs"][0]["run"]["times"]["primary_t"]
		Sltrhouse["Deaths"] = ""
		Sltrhouse["Medal"] = "0"
		Bunker["Time"] = WROverride["Bunker"][HMode]["runs"][0]["run"]["times"]["primary_t"]
		Bunker["Deaths"] = ""
		Bunker["Medal"] = "0"
		BunkerPt2["Time"] = WROverride["Bunker Pt.2"][HMode]["runs"][0]["run"]["times"]["primary_t"]
		BunkerPt2["Deaths"] = ""
		BunkerPt2["Medal"] = "0"
		Psychotherapy["Time"] = WROverride["Psychotherapy"][HMode]["runs"][0]["run"]["times"]["primary_t"]
		Psychotherapy["Deaths"] = ""
		Psychotherapy["Medal"] = "0"
	
	var odd = false
	var oddcol = Color(0.243137, 0.360784, 0.435294)
	
	var totaltime = 0
	var totaldeaths = 0
	var medalest = 0
	
	var levelsloaded = 0
	
	for level in Levels:
		
		var newlvl = LevelCont.instance()
		
		if odd:
			newlvl.get_node("BG").color = oddcol
		odd = !odd
		
		if level["Loaded"]:
			if DGMode:
				newlvl.get_node("Image").texture = level["DGImage"]
				if level["DGImage"].get_width() > 60:
					newlvl.get_node("Image").scale *= 60.0/level["DGImage"].get_width()
					pass
			else:
				newlvl.get_node("Image").texture = level["Image"]
			newlvl.get_node("Name").text = level["Name"]
			
			if level.has("Time"):
				newlvl.get_node("Time").text = format_time(level["Time"])
				newlvl.get_node("Medal").texture = Medal[level["Medal"]]
				newlvl.get_node("Deaths").text = level["Deaths"]
				totaltime += float(level["Time"])
				totaldeaths += int(level["Deaths"])
				medalest += int(level["Medal"])
				levelsloaded += 1
			
		else:
			newlvl.get_node("Image").hide()
			newlvl.get_node("Name").hide()
			newlvl.get_node("Time").hide()
			newlvl.get_node("Medal").hide()
			newlvl.get_node("Deaths").hide()
		
		
		add_child(newlvl)
	
	
	
	var total = LevelCont.instance()
	total.get_node("Image").hide()
	if DGMode:
		total.get_node("FifteenRun").show()
	else:
		total.get_node("ZeroRun").show()
	
	
	if odd:
		total.get_node("BG").color = oddcol
	
	if WRMode:
		if SoBMode:
			total.get_node("Name").text = "Total"
			total.get_node("Time").text = format_time(str(totaltime))
		else:
			total.get_node("Name").text = "WR✝"
			if HMode:
				if !DGMode:
					if PSMode:
						total.get_node("Name").text = "Psych HM WR✝"
						total.get_node("Time").text = format_time(str(WROverride["TotalHMPS"]))
					elif GLMode:
						total.get_node("Name").text = "Golden HM WR✝"
						total.get_node("Time").text = format_time(str(WROverride["TotalHMGL"]))
					else:
						total.get_node("Name").text = "Hardmode WR✝"
						total.get_node("Time").text = format_time(str(WROverride["TotalHM"]))
				else:
					if PSMode:
						total.get_node("Name").text = "Psych HM WR✝"
						total.get_node("Time").text = format_time(str(WROverride["TotalDGHMPS"]))
					elif GLMode:
						total.get_node("Name").text = "Golden HM WR✝"
						total.get_node("Time").text = format_time(str(WROverride["TotalDGHMGL"]))
					else:
						total.get_node("Name").text = "Hardmode WR✝"
						total.get_node("Time").text = format_time(str(WROverride["TotalDGHM"]))
			else:
				if !DGMode:
					if PSMode:
						total.get_node("Name").text = "Psych WR✝"
						total.get_node("Time").text = format_time(str(WROverride["TotalPS"]))
					elif GLMode:
						total.get_node("Name").text = "Golden WR✝"
						total.get_node("Time").text = format_time(str(WROverride["TotalGL"]))
					else:
						total.get_node("Name").text = "Normal WR✝"
						total.get_node("Time").text = format_time(str(WROverride["TotalNM"]))
				else:
					if PSMode:
						total.get_node("Name").text = "Psych WR✝"
						total.get_node("Time").text = format_time(str(WROverride["TotalDGPS"]))
					elif GLMode:
						total.get_node("Name").text = "Golden WR✝"
						total.get_node("Time").text = format_time(str(WROverride["TotalDGGL"]))
					else:
						total.get_node("Name").text = "Normal WR✝"
						total.get_node("Time").text = format_time(str(WROverride["TotalDGNM"]))
		
		total.get_node("Medal").texture = Medal["0"]
		total.get_node("Deaths").text = ""
	else:
		total.get_node("Name").text = "Total"
		total.get_node("Time").text = format_time(str(totaltime))
		total.get_node("Deaths").text = str(totaldeaths)
		total.get_node("Medal").texture = Medal[str(floor(medalest/levelsloaded))]
		
	add_child(total)


func _on_Full_Run_pressed():
	GLMode = false
	PSMode = false
	refresh()

var GoldenDisabled = {
	"Psychotherapy":true,
	"Bunker Pt.2":true,
	"Bunker":true,
	"Sltr.house":true,
	"Drg.tape":true
}

func _on_Golden_pressed():
	GLMode = true
	PSMode = false
	refresh()


func _on_Psycho_pressed():
	GLMode = false
	PSMode = true
	refresh()

func _on_HTTPRequest_request_completed(_result, response_code, _headers, body):

	if response_code > 400:
		Pop.pop("HTTP Error code "+response_code)
		return
	
	var parsed = JSON.parse(body.get_string_from_utf8()).result
	if typeof(parsed) != 18 and typeof(parsed) != 19:
		Pop.pop("Response is not JSON!")
		push_error(body.get_string_from_utf8())
		return
	
	# IL
	if typeof(parsed["data"]) == 19:
		WROverride[LevelID[parsed["data"][0]["level"]]] = parsed["data"]
		
	# Total[DG?][NM?/HM?][GL?/PS?]
	# Do not put NM if GL/PS
		
	# Psychotherapy
	elif parsed["data"]["category"] == "7kj19pgk" and parsed["data"]["runs"][0]["run"]["values"]["wlexr428"] != "jqzyy98l":
		WROverride["TotalPS"] = parsed["data"]["runs"][0]["run"]["times"]["primary_t"]
	# Golden Ending
	elif parsed["data"]["category"] == "n2y7v3m2" and parsed["data"]["runs"][0]["run"]["values"]["2lggmx7l"] != "81p6628q":
		WROverride["TotalGL"] = parsed["data"]["runs"][0]["run"]["times"]["primary_t"]
	# WR Normal
	elif parsed["data"]["category"] == "9d8xeo62" and parsed["data"]["runs"][0]["run"]["values"]["gnxr63pn"] != "zqo37d5q":
		WROverride["TotalNM"] = parsed["data"]["runs"][0]["run"]["times"]["primary_t"]
	# Psychotherapy HM WR
	elif parsed["data"]["category"] == "7kj19pgk" and parsed["data"]["runs"][0]["run"]["values"]["wlexr428"] == "jqzyy98l":
		WROverride["TotalHMPS"] = parsed["data"]["runs"][0]["run"]["times"]["primary_t"]
	# Golden Ending HM WR
	elif parsed["data"]["category"] == "n2y7v3m2" and parsed["data"]["runs"][0]["run"]["values"]["2lggmx7l"] == "81p6628q":
		WROverride["TotalHMGL"] = parsed["data"]["runs"][0]["run"]["times"]["primary_t"]
	# WR HM
	elif parsed["data"]["category"] == "9d8xeo62" and parsed["data"]["runs"][0]["run"]["values"]["gnxr63pn"] == "zqo37d5q":
		WROverride["TotalHM"] = parsed["data"]["runs"][0]["run"]["times"]["primary_t"]
	# K15 Normal
	elif parsed["data"]["category"] == "824g0532" and parsed["data"]["runs"][0]["run"]["values"]["6njqoxjl"] == "5q8rro31" and parsed["data"]["runs"][0]["run"]["values"]["e8mmwkq8"] == "21doo5pq":
		WROverride["TotalDGNM"] = parsed["data"]["runs"][0]["run"]["times"]["primary_t"]
	# K15 Hard
	elif parsed["data"]["category"] == "824g0532" and parsed["data"]["runs"][0]["run"]["values"]["6njqoxjl"] == "5q8rro31" and parsed["data"]["runs"][0]["run"]["values"]["e8mmwkq8"] == "5q8rrpy1":
		WROverride["TotalDGHM"] = parsed["data"]["runs"][0]["run"]["times"]["primary_t"]
	# K15 Golden Normal
	elif parsed["data"]["category"] == "824g0532" and parsed["data"]["runs"][0]["run"]["values"]["6njqoxjl"] == "4qy88r21" and parsed["data"]["runs"][0]["run"]["values"]["e8mmwkq8"] == "21doo5pq":
		WROverride["TotalDGGL"] = parsed["data"]["runs"][0]["run"]["times"]["primary_t"]
	# K15 Golden Hard
	elif parsed["data"]["category"] == "824g0532" and parsed["data"]["runs"][0]["run"]["values"]["6njqoxjl"] == "4qy88r21" and parsed["data"]["runs"][0]["run"]["values"]["e8mmwkq8"] == "5q8rrpy1":
		WROverride["TotalDGHMGL"] = parsed["data"]["runs"][0]["run"]["times"]["primary_t"]
	# K15 Psycho Normal
	elif parsed["data"]["category"] == "824g0532" and parsed["data"]["runs"][0]["run"]["values"]["6njqoxjl"] == "mlnkknjl" and parsed["data"]["runs"][0]["run"]["values"]["e8mmwkq8"] == "21doo5pq":
		WROverride["TotalDGPS"] = parsed["data"]["runs"][0]["run"]["times"]["primary_t"]
	# K15 Psycho Hard
	elif parsed["data"]["category"] == "824g0532" and parsed["data"]["runs"][0]["run"]["values"]["6njqoxjl"] == "mlnkknjl" and parsed["data"]["runs"][0]["run"]["values"]["e8mmwkq8"] == "5q8rrpy1":
		WROverride["TotalDGHMPS"] = parsed["data"]["runs"][0]["run"]["times"]["primary_t"]
	

func _on_CheckButton_toggled(button_pressed):
	WRMode = button_pressed
	refresh()


func _on_HMToggle_toggled(button_pressed):
	if button_pressed:
		HMode = 1
	else:
		HMode = 0
	refresh()


func _on_CheckBox_toggled(button_pressed):
	SoBMode = !button_pressed
	refresh()


func _on_DMToggle_toggled(button_pressed):
	DGMode = button_pressed
	refresh()
