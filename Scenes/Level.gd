extends Node2D
var asteroid_scene = load("res://Scenes/Asteroid.tscn")
var big_asteroid_scene = load("res://Scenes/BigAsteroid.tscn")
onready var globals = get_node("/root/GlobalStats")
onready var asteroid_timer = get_node("AsteroidTimer")
onready var player = get_node("Player")
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	#set edges of playfield:
	globals.set_top_left(get_node("BaseBlue640X640/TopLeft").global_position)
	globals.set_bottom_right(get_node("BaseBlue640X640/BottomRight").global_position)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_AsteroidTimer_timeout():
	var c1 = rand_range(0,1)>globals.asteroid_ratio	
	var asteroid = asteroid_scene.instance() if c1 else big_asteroid_scene.instance() 
	var asterRB = asteroid.get_node("RigidBody2D")
	var left = get_node("AsteroidSpawnLeft").position
	var right = get_node("AsteroidSpawnRight").position
	var pos = left + (right - left) * rand_range(0,1) # left + [0,1]*Vec(left->right)
	asterRB.position = pos
	#var sprite = asteroid.get_children()[0]
	var direction = Vector2(0,-1)
	#asteroid.linear_velocity = direction

	var velocity = Vector2(0.0, rand_range(150.0, 300.0))
	asterRB.linear_velocity = velocity #.rotated(direction)

	add_child(asteroid)
	#print(self.get_child_count()) #check if asteroids are auto-destroyed

func _on_player_hit():
	if globals.get_player_hp() > 0: #if player not dead
		player.hit()
	else:
		print("oh no, player has died")
		asteroid_timer.stop()
		#var player=get_node("Player")
		#player.visible = false#globals.remove(player)

func _on_restart():
	print("restarting")
	asteroid_timer.start()
