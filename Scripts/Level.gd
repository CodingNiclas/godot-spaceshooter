extends Node2D

var asteroid_scene = load("res://Scenes/Asteroid.tscn")
var big_asteroid_scene = load("res://Scenes/BigAsteroid.tscn")
@onready var globals = get_node("/root/GlobalStats")
@onready var bgm = get_node("/root/Bgm")
@onready var asteroid_timer = get_node("AsteroidTimer")
@onready var player = get_node("Player")
@onready var last_player_hp = 99
#var asteroid_storage
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	#set edges of playfield:
	globals.set_top_left(get_node("BaseBlue640X640/TopLeft").global_position)
	globals.set_bottom_right(get_node("BaseBlue640X640/BottomRight").global_position)
	#Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED) #hide mouse
	Input.set_default_cursor_shape(Input.CURSOR_CROSS)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_AsteroidTimer_timeout():
	var c1 = randf_range(0,1)>globals.asteroid_ratio	
	var asteroid = asteroid_scene.instantiate() if c1 else big_asteroid_scene.instantiate()
	#var sprite = asteroid.get_children()[0]
	#var direction = Vector2(0,-1)
	#asteroid.linear_velocity = direction

	#var velocity = Vector2(0.0, randf_range(150.0, 300.0))
	#asterRB.linear_velocity = velocity #.rotated(direction)
	add_child(asteroid)
	
	
	var asterBody = asteroid.get_body()
	var left = get_node("AsteroidTimer/AsteroidSpawnLeft").position
	var right = get_node("AsteroidTimer/AsteroidSpawnRight").position
	var pos = left + (right - left) * randf_range(0,1) # spawn-pos (between left and right)
	asterBody.position = pos
	left = get_node("AsteroidTimer/AsteroidTargetLeft").position
	right = get_node("AsteroidTimer/AsteroidTargetRight").position
	var target = left.lerp(right,randf_range(0,1)) #target-pos (between left and right)
	
	
	globals.spawned_asteroids.append(asteroid)
	#asterBody.gravity = (target-asterBody.position).normalized() * globals.randomized_asteroid_gravity()
	asteroid.set_body_gravity((target-asterBody.position).normalized(),globals.asteroid_base_gravity)
	#globals.randomized_asteroid_gravity())
	asterBody.velo_diff = globals.random_speed_diff()	
	#asterBody.prewarm(5)
	#asteroid._initialize()	
	globals.calculate_asteroid_stats()
	#print(self.get_child_count()) #check if asteroids are auto-destroyed

func _on_player_hit():
	var player_hp = globals.get_player_hp()
	#if globals.is_player_immune():
	#	return
	
	if  player_hp >= 1: #and time-last_player_hit>player_immunity_time: #if player not dead
		player.hit()
		last_player_hp = player_hp
	else:
		#Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		print("oh no, player has died")
		bgm.play_game_over()
		asteroid_timer.stop()
		player.die()
		#var player=get_node("Player")
		#player.visible = false#globals.remove(player)

func _on_restart():
	#Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	print("restarting")
	bgm.play_ingame()	
	asteroid_timer.start()
	player.revive()
	globals.restart()
	globals.remove_spawned_asteroids()
