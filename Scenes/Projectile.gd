extends Node2D

#export(Array, AudioStream) var shot_sounds
#onready var audio = get_node("AudioStreamPlayer2D")
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var globals = get_node("/root/GlobalStats")

# Called when the node enters the scene tree for the first time.
func _ready():
	#randomize()
	#var n = randi()%shot_sounds.size()
	#print("playing sfx no."+String(n))
	#audio.stream = shot_sounds[n]
	#audio.play()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position = position + Vector2.UP*delta*500
	if position.y < 0:
		globals.remove(self)
