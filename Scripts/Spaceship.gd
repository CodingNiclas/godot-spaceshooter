extends Sprite2D


@export var cannon_paths :Array[NodePath]
#@export var cannons:Array[AudioStreamPlayer2D]
var cannons: Array[AudioStreamPlayer2D]

@export var shot_sounds: Array[AudioStream]
@onready var projectile_scene = load("res://Scenes/Projectile.tscn")

var iterator_id = 0 #

# Called when the node enters the scene tree for the first time.
func _ready():
	# workaround bc we cant use the nodes directly in export (its broken...)
	for x in cannon_paths:
		cannons.append(get_node(x))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func shoot_all():
	for c in cannons:
		shoot(c)
		
func shoot_next():
	iterator_id = iterator_id+1 if iterator_id<cannons.size()-1 else 0
	shoot(cannons[iterator_id])
	
func shoot(cannon):
	var pos = cannon.global_position
	var shot = projectile_scene.instantiate()
	#get_node("CharacterBody2D").add_child(shot)
	get_tree().get_root().get_node("Node2D_Level").add_child(shot)
	shot.global_position = pos
	#print(get_tree().get_root().get_node("Node2D_Level").get_child_count())
	# play randomized sfx
	var n = randi()%shot_sounds.size()
	#print("playing sfx "+String(n))
	cannon.stream = shot_sounds[n]
	cannon.play()
