extends Node

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var player_hp = 5
const max_player_hp = 5
var game_over = false
var asteroid_ratio = 0.2
var top_left = Vector2(0,0)
var bottom_right = Vector2(0,0)
var score = 0

# Called when the node enters the scene tree for the first time.
func _ready():
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
