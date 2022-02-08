extends HTTPRequest

onready var Pop = get_parent().get_node("PopupDialog")

var yUserAgent = "yKZSoB-unknown"

func _ready():
	if OS.is_debug_build():
		yUserAgent = "yKZSoB-devtest"
	else:
		yUserAgent = "yKZSoB-1.0"

var last_request = -150000

func _on_Request_pressed():

	if OS.get_ticks_msec() < last_request + 15000:
		Pop.pop("Please wait "+str( ( last_request+15000-OS.get_ticks_msec() ) / 1000 )+" more seconds before requesting again!")
		return
		
	last_request = OS.get_ticks_msec()
	
	# speedrun.com's API rate limit is 100 requests per minute
	# This requests 24 times with a cooldown of 15 seconds
	
	# KZ Game ID = lde3nex6
	
	# All Stages category = 9d8xeo62
	# Golden Ending category = n2y7v3m2
	# Psychotherapy category = 7kj19pgk
	# Dragon Mod category = 824g0532
	
# warning-ignore:return_value_discarded
	request("https://www.speedrun.com/api/v1/leaderboards/lde3nex6/category/9d8xeo62?top=1&var-gnxr63pn=81wdk3mq", ["user-agent: "+yUserAgent])
var order = 1
var maxorder = 23
func _on_HTTPRequest_request_completed(_result, _response_code, _headers, _body):
	if order > maxorder:
		order = 1
		get_parent().get_node("ProgressBar").hide()
		return
	
	get_parent().get_node("ProgressBar").value = order
	get_parent().get_node("ProgressBar").show()
	
	match order:
		1:
			# Factory xd0l1z4d
# warning-ignore:return_value_discarded
			request("https://www.speedrun.com/api/v1/levels/xd0l1z4d/records", ["user-agent: "+yUserAgent])
		2:
			# Hotel n93816zw
# warning-ignore:return_value_discarded
			request("https://www.speedrun.com/api/v1/levels/n93816zw/records", ["user-agent: "+yUserAgent])
		3:
			# Club z98e31p9
# warning-ignore:return_value_discarded
			request("https://www.speedrun.com/api/v1/levels/z98e31p9/records", ["user-agent: "+yUserAgent])
		4:
			# Prison rdnr7e7w
# warning-ignore:return_value_discarded
			request("https://www.speedrun.com/api/v1/levels/rdnr7e7w/records", ["user-agent: "+yUserAgent])
		5:
			# Studio ldyjxmrd
# warning-ignore:return_value_discarded
			request("https://www.speedrun.com/api/v1/levels/ldyjxmrd/records", ["user-agent: "+yUserAgent])
		6:
			# Mansion nwln5red
# warning-ignore:return_value_discarded
			request("https://www.speedrun.com/api/v1/levels/nwln5red/records", ["user-agent: "+yUserAgent])
		7:
			# Chinatown yweny67w
# warning-ignore:return_value_discarded
			request("https://www.speedrun.com/api/v1/levels/yweny67w/records", ["user-agent: "+yUserAgent])
		8:
			# Drg.tape 69zx5kgd
# warning-ignore:return_value_discarded
			request("https://www.speedrun.com/api/v1/levels/69zx5kgd/records", ["user-agent: "+yUserAgent])
		9:
			# Sltr.house r9grlvpw
# warning-ignore:return_value_discarded
			request("https://www.speedrun.com/api/v1/levels/r9grlvpw/records", ["user-agent: "+yUserAgent])
		10:
			# Bunker o9xkgppw
# warning-ignore:return_value_discarded
			request("https://www.speedrun.com/api/v1/levels/o9xkgppw/records", ["user-agent: "+yUserAgent])
		11:
			# Bunker Pt.2 495y273w
# warning-ignore:return_value_discarded
			request("https://www.speedrun.com/api/v1/levels/495y273w/records", ["user-agent: "+yUserAgent])
		12:
			# Psychotherapy o9xkg8pw
# warning-ignore:return_value_discarded
			request("https://www.speedrun.com/api/v1/levels/o9xkg8pw/records", ["user-agent: "+yUserAgent])
		13:
			# Hardmode WR
# warning-ignore:return_value_discarded
			request("https://www.speedrun.com/api/v1/leaderboards/lde3nex6/category/9d8xeo62?top=1&var-gnxr63pn=zqo37d5q", ["user-agent: "+yUserAgent])
		14:
			# Golden Ending WR
# warning-ignore:return_value_discarded
			request("https://www.speedrun.com/api/v1/leaderboards/lde3nex6/category/n2y7v3m2?top=1", ["user-agent: "+yUserAgent])
		15:
			# Psychotherapy WR
# warning-ignore:return_value_discarded
			request("https://www.speedrun.com/api/v1/leaderboards/lde3nex6/category/7kj19pgk?top=1", ["user-agent: "+yUserAgent])
		16:
			# Golden Ending Hardmode WR
# warning-ignore:return_value_discarded
			request("https://www.speedrun.com/api/v1/leaderboards/lde3nex6/category/n2y7v3m2?top=1&var-2lggmx7l=81p6628q", ["user-agent: "+yUserAgent])
		17:
			# Psychotherapy Hardmode WR
# warning-ignore:return_value_discarded
			request("https://www.speedrun.com/api/v1/leaderboards/lde3nex6/category/7kj19pgk?top=1&var-wlexr428=jqzyy98l", ["user-agent: "+yUserAgent])
		18:
			# Dragon Mod Normal WR
# warning-ignore:return_value_discarded
			request("https://www.speedrun.com/api/v1/leaderboards/lde3nex6/category/824g0532?top=1&var-e8mmwkq8=21doo5pq&var-6njqoxjl=5q8rro31", ["user-agent: "+yUserAgent])
		19:
			# Dragon Mod Hardmode WR
# warning-ignore:return_value_discarded
			request("https://www.speedrun.com/api/v1/leaderboards/lde3nex6/category/824g0532?top=1&var-e8mmwkq8=5q8rrpy1&var-6njqoxjl=5q8rro31", ["user-agent: "+yUserAgent])
		20:
			# Dragon Mod Golden Ending Normal WR
# warning-ignore:return_value_discarded
			request("https://www.speedrun.com/api/v1/leaderboards/lde3nex6/category/824g0532?top=1&var-e8mmwkq8=21doo5pq&var-6njqoxjl=4qy88r21", ["user-agent: "+yUserAgent])
		21:
			# Dragon Mod Golden Ending Hardmode WR
# warning-ignore:return_value_discarded
			request("https://www.speedrun.com/api/v1/leaderboards/lde3nex6/category/824g0532?top=1&var-e8mmwkq8=5q8rrpy1&var-6njqoxjl=4qy88r21", ["user-agent: "+yUserAgent])
		22:
			# Dragon Mod Psychotherapy Normal WR
# warning-ignore:return_value_discarded
			request("https://www.speedrun.com/api/v1/leaderboards/lde3nex6/category/824g0532?top=1&var-e8mmwkq8=21doo5pq&var-6njqoxjl=mlnkknjl", ["user-agent: "+yUserAgent])
		23:
			# Dragon Mod Psychotherapy Hardmode WR
# warning-ignore:return_value_discarded
			request("https://www.speedrun.com/api/v1/leaderboards/lde3nex6/category/824g0532?top=1&var-e8mmwkq8=5q8rrpy1&var-6njqoxjl=mlnkknjl", ["user-agent: "+yUserAgent])
		
	order += 1
