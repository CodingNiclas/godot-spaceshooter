extends Node2D


@onready var globals = get_node("/root/GlobalStats") 
@onready var player = get_node("/root/Node2D_Level/Player/CharacterBody2D")

var destroyed = false
const rndmns = 0.35
const player_force_ratio = 0.25 #ratio of player attraction force vs gravity
var gravity = Vector2(0,1) #gravity direction
var pickup_points = 25 #no. of points the player recieves when picking up the item 

# Called when the node enters the scene tree for the first time.
func _ready():
	#var tween = get_tree().create_tween()
	#var sprite = get_node("Sprite")
	##tween.tween_property(sprite, "modulate", Color.RED, 1)
	#tween.tween_property(sprite, "position", Vector2(20,0), 1)
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#position += Vector2(0,1)*delta*20
	#TODO: some logic that pulls the item towards the player
	var target = player.global_position
	#print("target:",target,"position:",global_position)
	var rndm = Vector2(randf_range(1-rndmns,1+rndmns),randf_range(1-rndmns,1+rndmns)) 
	var vec = ((target-self.global_position)*rndm).normalized()
	
	global_position+=(gravity+player_force_ratio*vec)*delta*50#*0.5#*20



func _on_area_entered(area):
	pass #destroy()
	#pass # Replace with function body.


func _on_body_entered(body):
	# increase player hp by one:
	if body.is_in_group("player"):
		if destroyed:
			return
		globals.heal_player(1)
		globals.score += pickup_points
		destroy()
	#pass # Replace with function body.

func destroy():
	if destroyed:
		return
	get_node("AudioStreamPlayer2D").playing = true
	destroyed = true
	#print("item picked?")
	#globals.remove(self)
	var tween = get_tree().create_tween()
	var sprite = get_node("Sprite")
	##tween.tween_property(sprite, "modulate", Color.RED, 1)
	tween.tween_property(sprite, "scale", Vector2(0,0), 0.3)
	tween.tween_callback(self.queue_free)	
	get_node("AnimationTree").active = false
	
