extends Node

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

const max_player_hp = 5
const init_asteroid_ratio = 0.2
const init_asteroid_base_gravity = 100
const player_immunity_time = 500
const health_drop_rate = 0.02
const coin_drop_rate = 0.02
#const init_asteroid_gravity_variation = 0.15
const max_ship_cannon_lvl = 1 #maximum ship upgrades

var player_hp = max_player_hp
var game_over = false
var asteroid_ratio = init_asteroid_ratio
var top_left = Vector2(0,0)
var bottom_right = Vector2(0,0)
var score = 0
var music_volume = 0.9
var asteroid_base_gravity = init_asteroid_base_gravity
var asteroid_gravity_variation = 20
var phase = 1
var game_state = 0
var last_player_damage_time = 0
var spawned_asteroids = []
var player_immune = false
var coins = 0
var ship_cannon_lvl = 0 #used to indicate the upgrade-level of the players ship

func _process(_delta):
	if player_immune:
		var time = Time.get_ticks_msec()
		#print("immu time: "+String(player_immunity_time))
		#print(String(time)+"\\"+String(last_player_damage_time))
		player_immune = (time-last_player_damage_time)<player_immunity_time
		#print("player is immune: "+String(player_immune))

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	get_node("/root/Bgm").set_volume_perc(music_volume)
	pass # Replace with function body.

func set_top_left(_vector):
	top_left = _vector
	
func set_bottom_right(_vector):
	bottom_right = _vector

func get_top_left():
	return top_left
func get_bottom_right():
	return bottom_right

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func get_player_hp():
	return player_hp
	
func set_player_hp(_value):
	player_hp = max(_value,0)
	
func damage_player(_damage):
	var time = Time.get_ticks_msec()
	if !player_immune:
		#print("time:"+String(time - last_player_damage_time))		
		set_player_hp(player_hp-_damage)
		last_player_damage_time = time
		player_immune = true
	#return player_hp>0
	
func remove(_obj):
	for child in _obj.get_children():
		child.queue_free()
	_obj.queue_free()
	
func refill_player_hp():
	player_hp = max_player_hp
	
func set_game_over(_value):
	game_over = _value
	
func is_game_over():
	return game_over
	
func restart():
	score = 0
	refill_player_hp()
	asteroid_ratio = init_asteroid_ratio
	asteroid_base_gravity = init_asteroid_base_gravity
	phase = 1

func randomized_asteroid_gravity():
	var min_g = asteroid_base_gravity - asteroid_gravity_variation
	var max_g = asteroid_base_gravity + asteroid_gravity_variation
	var g = lerp(min_g,max_g,randf_range(0,1))
	return Vector2.ZERO#g# * 100
	
func random_speed_diff():
	return 1+randf_range(-asteroid_gravity_variation,asteroid_gravity_variation)
	
	
# used to increase the difficulty over time
func calculate_asteroid_stats():
	if (score/phase) > 500: #every 500 points get to new phase
		asteroid_base_gravity = asteroid_base_gravity*(1+0.25/sqrt(phase)) #increase the base gravity
		asteroid_ratio = ((-2)/(phase+2.5))+0.66 #increase ratio of BigAsteroids; asymptotic to 75%
		phase+=1
		print("we are now in phase ",phase)
		print("speed: ",asteroid_base_gravity)
		print("asteroid_ratio: ",asteroid_ratio)
	
func is_paused():
	return game_state == 1
	
func pause():
	get_tree().paused = true
	game_state = 1
	
func unpause():
	get_tree().paused = false
	game_state = 0
	
func remove_spawned_asteroids():
	for asteroid in spawned_asteroids:
		if asteroid != null:
			asteroid.queue_free()
		#else: 
		#	print("null-asteroid")
	spawned_asteroids = Array()
	
func is_player_immune():
	print("the player is "+ "immune" if player_immune else "not immune")
	print(last_player_damage_time)
	return player_immune

func heal_player(hp):
	if player_hp<max_player_hp:
		player_hp+=hp
		
func upgrade_ship_cannon():
	ship_cannon_lvl = min(ship_cannon_lvl+1,max_ship_cannon_lvl)
