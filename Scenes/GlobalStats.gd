extends Node

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

const max_player_hp = 5
const init_asteroid_ratio = 0.2
const init_asteroid_base_gravity = 0.25
#const init_asteroid_gravity_variation = 0.15


var player_hp = 5
var game_over = false
var asteroid_ratio = init_asteroid_ratio
var top_left = Vector2(0,0)
var bottom_right = Vector2(0,0)
var score = 0
var music_volume = 0.8
var asteroid_base_gravity = init_asteroid_base_gravity
var asteroid_gravity_variation = 0.15
var phase = 1
var game_state = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	get_node("/root/Bgm").set_volume_perc(music_volume)
	pass # Replace with function body.

func set_top_left(var _vector):
	top_left = _vector
	
func set_bottom_right(var _vector):
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
	set_player_hp(player_hp-_damage)
	return player_hp>0
	
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
	var g = lerp(min_g,max_g,rand_range(0,1))
	return g
	
# used to increase the difficulty over time
func calculate_asteroid_stats():
	if (score/phase) > 500: #every 1000 points get to new phase
		asteroid_base_gravity = asteroid_base_gravity*1.2 #increase the base gravity by 20%
		asteroid_ratio = asteroid_ratio*1.2
		phase+=1
		print("we are now in phase "+String(phase))
	
func is_paused():
	return game_state == 1
	
func pause():
	get_tree().paused = true
	game_state = 1
	
func unpause():
	get_tree().paused = false
	game_state = 0
