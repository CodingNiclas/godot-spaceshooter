extends AudioStreamPlayer2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export(AudioStream) var ingame_music
export(AudioStream) var game_over_music

onready var fade_timer = get_node("MusicFadeTimer")

const min_volume = -40
const max_volume = 0
var volume #the music volume that is set
#onready var base_volume_db = self.volume_db

var change_music = false
var change_stream = null
var target_volume = 1
var vol_thresh = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	#self.stream = in_game_music
	#self.play()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !change_music:
		return
#	print("set volume from "+String(self.volume_db)+" to "+String(target_volume))
	if abs(self.volume_db-target_volume)>vol_thresh:
		self.volume_db = lerp(self.volume_db,target_volume,delta*4)
	elif change_stream != self.stream: #if new bgm not playing
		self.volume_db = target_volume
		self.stream = change_stream
		self.play()
		self.target_volume = volume
		self.volume_db = volume
	else:	#if new bgm already playing
		self.volume_db = target_volume
		change_music = false
	

func set_volume_db(_value):
	volume = _value
	target_volume = _value
	self.volume_db = _value

func set_volume_perc(_value):
	if(_value>0):
		set_volume_db(lerp(min_volume,max_volume,_value))
		#self.volume_db = volume
		#print("bgm volume changed to "+String(self.volume_db))	
	else:
		set_volume_db(0)
		self.playing = false
		print("bgm turned off")

func play_game_over():
	change_stream = game_over_music
	target_volume = min_volume
	change_music = true	
	#fade_timer.start()
	#self.stream = game_over_music
	#self.play()
	
func play_ingame():
	change_stream = ingame_music
	change_music = true
	target_volume = min_volume	
	#fade_timer.start()
	#self.stream = ingame_music
	#self.play()


func _on_MusicFadeTimer_timeout():
	change_music = true
	#self.volume_db = volume
	#self.stream = change_stream
	#self.play()
	#change_music = false
