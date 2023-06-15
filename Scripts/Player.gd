extends Node2D

#@export var shot_sounds: Array[AudioStream] # (Array, AudioStream)
#@export var hit_anim: Animation
@export var hit_sound: AudioStream
@export var die_sound: AudioStream
@export var ship_paths: Array[NodePath]
var spaceships: Array[Node2D]

#@onready var projectile_scene = load("res://Scenes/Projectile.tscn")
#@onready var proj_spawn_pos = get_node("CharacterBody2D/ProjectileSpawnPos")
@onready var body = get_node("CharacterBody2D")
@onready var globals = get_node("/root/GlobalStats")
#@onready var proj_audio = get_node("CharacterBody2D/ProjectileSpawnPos/ProjectileAudioPlayer")
@onready var ship_audio = get_node("CharacterBody2D/ShipAudioPlayer")
@onready var ship_animator = get_node("CharacterBody2D/AnimationPlayer")
@onready var shot_timer = get_node("ShotTimer")

#onready var tl = globals.get_top_left()
#onready var br = globals.get_bottom_right()
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

const drag_factor = 1


var activeship = null
var follow_mouse = true
var last_pos
var mouse_pos
var thresh = 10
var hp
var top_left = Vector2(0,0)

# Called when the node enters the scene tree for the first time.
func _ready():
	for x in ship_paths:
		spaceships.append(get_node(x))
		
		
	update_active_ship()
	last_pos = position
	mouse_pos = position
	randomize()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if globals.is_game_over():
		return
	if !follow_mouse:
		return
	var vector = (mouse_pos - body.global_position)#.normalized()
	if(vector.length()>thresh):
		body.global_position = body.global_position + (vector.normalized() * 1000 * delta)
	else:
		body.global_position = mouse_pos
	var pos = body.global_position
	var tl = globals.get_top_left()
	var br = globals.get_bottom_right()
	body.global_position.x = clamp(pos.x,tl.x,br.x)
	body.global_position.y = clamp(pos.y,tl.y,br.y)
	check_kb_input()


func check_kb_input():
	var dir:Vector2 = Vector2.ZERO
	
	if Input.is_action_pressed("down"):
		dir+=Vector2(0,-1)
	if Input.is_action_pressed("up"):
		dir+=Vector2(0,1)
	if Input.is_action_pressed("left"):
		dir+=Vector2(1,0)
	if Input.is_action_pressed("right"):
		dir+=Vector2(-1,0)

	mouse_pos = body.global_position - dir.normalized()*10

func _input(event):
	if globals.is_game_over():
		return
	
	#if Input.is_action_just_pressed("down"):
	#	mouse_pos = body.global_position
	#	last_pos = event.position

	if !(event is InputEventScreenDrag)\
		and !(event is InputEventScreenTouch)\
		and !(event is InputEventMouse):
			return
	if event.is_pressed():
		mouse_pos = body.global_position
		last_pos = event.position
	elif event is InputEventScreenDrag:
		mouse_pos = body.global_position-(last_pos-event.position)*drag_factor
		last_pos = event.position

func _on_shot_timer_timeout():
	activeship.shoot_all()
#	var shot = projectile_scene.instantiate()
#	#get_node("CharacterBody2D").add_child(shot)
#	get_tree().get_root().get_node("Node2D_Level").add_child(shot)
#	shot.global_position = proj_spawn_pos.global_position
#	#print(get_tree().get_root().get_node("Node2D_Level").get_child_count())
#	# play randomized sfx
#	var n = randi()%shot_sounds.size()
#	#print("playing sfx "+String(n))
#	proj_audio.stream = shot_sounds[n]
#	proj_audio.play()

func hit():
	print("hit")
	Input.vibrate_handheld()
	ship_audio.stream = hit_sound
	ship_audio.play()
	if globals.ship_cannon_lvl==0:
		ship_animator.play("player_ship_hit")
	else:
		ship_animator.play("player_ship_hit_2")
		
	#player_audio

func die():
	print("Player DIES")
	Input.vibrate_handheld()	
	shot_timer.stop()
	ship_audio.stream = die_sound
	ship_audio.play()
	body.collision_mask = 0
	body.collision_layer = 0

func revive():
	shot_timer.start()	
	body.collision_mask = 1
	body.collision_layer = 1
	update_active_ship()
	
func update_active_ship():
#	spaceships[0].visible = false
#	spaceships[1].visible = false
	for s in spaceships:
		s.visible = false
	activeship = spaceships[min(globals.ship_cannon_lvl,spaceships.size()-1)]
	activeship.visible = true
	
	
	
	
	
