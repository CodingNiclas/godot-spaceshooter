extends Node2D

#export var shot_sounds # (Array, AudioStream)
#onready var audio = get_node("AudioStreamPlayer2D")
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var hp = 1

@onready var globals = get_node("/root/GlobalStats")
@onready var rb = get_node("Area2D")
# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	#randomize()
	#var n = randi()%shot_sounds.size()
	#print("playing sfx no."+String(n))
	#audio.stream = shot_sounds[n]
	#audio.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	rb.position = rb.position + Vector2.UP*_delta*500
	#rb.linear_velocity = Vector2.UP*500	
	if rb.global_position.y < 0:
		globals.remove(self)

func hit(dmg):
	hp-=dmg
	if hp<=0:
		globals.remove(self)
	else:
		print(hp)

func _on_area_2d_body_entered(body):
	pass#print("area hit")


func _on_area_area_entered(area):
	pass
	#if area.is_in_group("enemy"):
	#	hp-=1
	#	if hp<=0:
	#		globals.remove(self)
