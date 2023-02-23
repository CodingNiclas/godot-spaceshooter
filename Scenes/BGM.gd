extends AudioStreamPlayer2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
const min_volume = -40
const max_volume = 0
#onready var base_volume_db = self.volume_db


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func set_volume_db(_value):
	self.volume_db = _value

func set_volume_perc(_value):
	if(_value>0):
		self.volume_db = lerp(min_volume,max_volume,_value)
		print("bgm volume changed to "+String(self.volume_db))	
	else:
		self.playing = false
		print("bgm turned off")
