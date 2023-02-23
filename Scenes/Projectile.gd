extends Node2D

#export(Array, AudioStream) var shot_sounds
#onready var audio = get_node("AudioStreamPlayer2D")
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var globals = get_node("/root/GlobalStats")
onready var rb = get_node("RigidBody2D")
# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	#randomize()
	#var n = randi()%shot_sounds.size()
	#print("playing sfx no."+String(n))
	#audio.stream = shot_sounds[n]
	#audio.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#position = position + Vector2.UP*delta*500
	rb.linear_velocity = Vector2.UP*500	
	if rb.global_position.y < 0:
		globals.remove(self)
