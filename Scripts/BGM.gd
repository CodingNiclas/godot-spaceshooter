extends AudioStreamPlayer2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

@export var ingame_music: AudioStream
@export var game_over_music: AudioStream
@export var pause_music: AudioStream


@onready var fade_timer = get_node("MusicFadeTimer")

const min_volume = -40
const max_volume = 0
var volume #the music volume that is set
var play_music = true #indicates if music should be played
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
		#the following 2 variables are needed because without lerp returns an error that an argument is nil... 
		var current:float = self.volume_db
		var target:float = target_volume
		#print("current=",current,"; target=",target_volume)
		var new_db = lerp(current,target,delta*4)
		self.volume_db = new_db
	elif change_stream != self.stream: #if new bgm not playing
		self.volume_db = target_volume
		self.stream = change_stream
		self.play()
		self.target_volume = volume
		self.volume_db = volume
	else:	#if new bgm already playing
		self.volume_db = target_volume
		change_music = false
	

func set_bgm_volume_db(_value):
	volume = _value
	target_volume = _value
	self.volume_db = _value
	print("set volume to ",volume_db," db")

func set_volume_perc(_value):
	print("set bgm to ",_value)
	if(_value>0):
		set_bgm_volume_db(lerp(min_volume,max_volume,_value))
		#self.volume_db = volume
		#print("bgm volume changed to "+String(self.volume_db))	
	else:
		set_bgm_volume_db(0)
		play_music = false
		self.playing = false
		print("bgm turned off")
		
func get_volume_perc():
	var m = max_volume - min_volume
	var v = volume_db-min_volume
	print(v/m)
	return v/m

func play_game_over():
	print(volume)
	if !play_music: #dont do anything if music is turned off
		return
	print("play game_over")
	change_stream = game_over_music
	target_volume = min_volume
	change_music = true	
	#fade_timer.start()
	#self.stream = game_over_music
	#self.play()
	
func play_ingame():
	if !play_music: #dont do anything if music is turned off
		return
	print("play ingame")
	if self.stream == ingame_music: self.stream = null #else breaks when restarting w/o gameover(-music)
	change_stream = ingame_music
	change_music = true
	target_volume = min_volume	
	print("volume:",target_volume)
	print("stream:",change_stream)
	#fade_timer.start()
	#self.stream = ingame_music
	#self.play()

func play_pause():
	if !play_music: #dont do anything if music is turned off
		return
	print("play pause")
	#if self.stream == ingame_music: self.stream = null #else breaks when restarting w/o gameover(-music)
	change_stream = pause_music
	change_music = true
	target_volume = min_volume


func _on_MusicFadeTimer_timeout():
	change_music = true
	#self.volume_db = volume
	#self.stream = change_stream
	#self.play()
	#change_music = false
