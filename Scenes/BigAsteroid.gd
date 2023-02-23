extends Node2D
#signal player_dead
signal player_hit

var asteroid_scene = load("res://Scenes/Asteroid.tscn")


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
#onready var foo = get_node("RigidBody2D")
onready var rb = get_node("RigidBody2D")
onready var fx = get_node("ExplosionParticles")
onready var hit_audio = get_node("HitAudio")
onready var sprite = get_node("RigidBody2D/Asteroid")
onready var globals = get_node("/root/GlobalStats")

var collision_velocity = Vector2(0,0)
var collision_position = Vector2(0,0)
var initial_velocity = Vector2(0,0)
var destroyed = false
var splitted = false
var rotation_direction = rand_range(-1, 1)
var max_y = 650
var destruction_points = 20
var gravity

# Called when the node enters the scene tree for the first time.
func _ready():
	#rb.linear_velocity = Vector2(0,100)
	#rb.gravity_scale = globals.randomized_asteroid_gravity()
	#self.connect("player_dead",self.get_parent(),"_on_player_dead")
	self.connect("player_hit",self.get_parent(),"_on_player_hit")

func _initialize():
	rb.linear_velocity = gravity*500
	initial_velocity = rb.linear_velocity
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !destroyed and sprite != null:
		sprite.set_rotation(sprite.rotation+(delta*rotation_direction))
		if rb.position.y > max_y:
			globals.remove(self)
		#apply gravity:
		rb.add_central_force(gravity*delta*10)
	elif !splitted:
		_newSplit(Vector2(1,1))
		_newSplit(Vector2(-1,1))
		_newSplit(Vector2(0,1))


func _newSplit(_dir):
	var a1 = asteroid_scene.instance()
	var a1_rb = a1.get_node("RigidBody2D")
	#a1_rb.linear_velocity = 150*_dir
	self.get_parent().add_child(a1)
	a1_rb.global_position = collision_position
	a1.gravity = _dir.normalized()
	#a1.global_position = self.global_position
	splitted = true
	print(a1.position)
	a1_rb.linear_velocity = a1.gravity*100
	

func _on_RigidBody2D_body_entered(_body):
	print("big asteroid collision")
	if(_body.is_in_group("asteroid")):
		return
	elif(_body.is_in_group("projectile")):
		collision_velocity = rb.linear_velocity
		collision_position = rb.position
		print("big asteroid damaged")
		fx.position = rb.position
		fx.emitting = true
		hit_audio.play()
		globals.remove(rb)
		globals.remove(_body.get_parent())
		destroyed = true
		globals.score+=destruction_points
		# split this asteroid
		#var par = self.get_parent()
		
		
		#a1_rb.linear_velocity = rb.linear_velocity*1.5;
		
	elif(_body.is_in_group("player")):
		fx.position = rb.position
		globals.remove(rb)
		fx.emitting = true
		destroyed = true
		var alive = globals.damage_player(1) #reduce player_health
		#if !alive:
		#	emit_signal("player_dead")
		#	globals.set_game_over(true)
		emit_signal("player_hit")



func set_max_y(_value):
	max_y = _value
