extends Node2D


@onready var globals = get_node("/root/GlobalStats") 
#@onready var player = get_node("/root/Node2D_Level/Player/CharacterBody2D")

var destroyed = false


# Called when the node enters the scene tree for the first time.
func _ready():
	#var tween = get_tree().create_tween()
	#var sprite = get_node("Sprite")
	##tween.tween_property(sprite, "modulate", Color.RED, 1)
	#tween.tween_property(sprite, "position", Vector2(20,0), 1)
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position += Vector2(0,1)*delta*20
	#TODO: some logic that pulls the item towards the player
	#var target = player.position
	#print(target)
	#var vec = (global_position-target).normalized()
	#global_position+=target*delta*0.5#*20



func _on_area_entered(area):
	pass #destroy()
	#pass # Replace with function body.


func _on_body_entered(body):
	# increase player hp by one:
	if body.is_in_group("player"):
		globals.heal_player(1)
		destroy()
	#pass # Replace with function body.

func destroy():
	if destroyed:
		return
	destroyed = true
	#print("item picked?")
	#globals.remove(self)
	var tween = get_tree().create_tween()
	var sprite = get_node("Sprite")
	##tween.tween_property(sprite, "modulate", Color.RED, 1)
	tween.tween_property(sprite, "scale", Vector2(0,0), 0.3)
	tween.tween_callback(self.queue_free)	
	get_node("AnimationTree").active = false
	
