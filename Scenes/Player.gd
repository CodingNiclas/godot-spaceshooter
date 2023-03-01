extends Node2D

export(Array, AudioStream) var shot_sounds
export(Animation) var hit_anim
export(AudioStream) var hit_sound
export(AudioStream) var die_sound

var projectile_scene = load("res://Scenes/Projectile.tscn")
onready var proj_spawn_pos = get_node("KinematicBody2D/ProjectileSpawnPos")
onready var body = get_node("KinematicBody2D")
onready var globals = get_node("/root/GlobalStats")
onready var proj_audio = get_node("KinematicBody2D/ProjectileSpawnPos/ProjectileAudioPlayer")
onready var ship_audio = get_node("KinematicBody2D/ShipAudioPlayer")
onready var ship_animator = get_node("KinematicBody2D/AnimationPlayer")
onready var shot_timer = get_node("ShotTimer")

#onready var tl = globals.get_top_left()
#onready var br = globals.get_bottom_right()
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

const drag_factor = 1

var follow_mouse = true
var last_pos
var mouse_pos
var thresh = 10
var hp
var top_left = Vector2(0,0)

# Called when the node enters the scene tree for the first time.
func _ready():
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


func _input(event):
	if globals.is_game_over():
		return
	#if event is InputEventMouseMotion or event is InputEventScreenTouch:
	#	mouse_pos = body.global_position + (event.position-last_pos)
	#	last_pos = event.position
	#if event is InputEventScreenTouch:
	#	if event.pressed:
	#		follow_mouse = true
	#		last_pos = event.position
		#elif event.released:
		#	follow_mouse = false
		#	last_pos = Vector2.ZERO
	#if event.is_action_pressed("follow_mouse"):
	#	follow_mouse = true
	#	last_pos = get_viewport().get_mouse_position()
	#elif event.is_action_released("follow_mouse"):
	#	follow_mouse = false
	#	last_pos = Vector2.ZERO
	# ======
	if !(event is InputEventScreenDrag)\
		and !(event is InputEventScreenTouch)\
		and !(event is InputEventMouse):
			return

	
	#var is_drag = event is InputEventScreenDrag or event is InputEventMouseMotion
	#var is_press = event.is_pressed()
	#var is_release = !is_drag and !event.is_pressed()
	
	#if is_press:
	#	last_pos = event.position
	if event.is_pressed():
		mouse_pos = body.global_position
		last_pos = event.position
	elif event is InputEventScreenDrag:
		mouse_pos = body.global_position-(last_pos-event.position)*drag_factor
		last_pos = event.position
	
	
	#if event.is_action_pressed("fire"):
	#	spawn_projectile()

func spawn_projectile():
	var shot = projectile_scene.instance()
	#get_node("KinematicBody2D").add_child(shot)
	get_tree().get_root().get_node("Node2D_Level").add_child(shot)
	shot.global_position = proj_spawn_pos.global_position
	print(get_tree().get_root().get_node("Node2D_Level").get_child_count())
	# play randomized sfx
	var n = randi()%shot_sounds.size()
	print("playing sfx "+String(n))
	proj_audio.stream = shot_sounds[n]
	proj_audio.play()

func hit():
	Input.vibrate_handheld()
	ship_audio.stream = hit_sound
	ship_audio.play()
	ship_animator.play("player_ship_hit")
	#player_audio

func die():
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
	
