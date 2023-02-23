extends Node2D
#signal player_dead
signal player_hit

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var rb = get_node("RigidBody2D")
onready var fx = get_node("ExplosionParticles")
onready var hit_audio = get_node("HitAudio")
onready var sprite = get_node("RigidBody2D/Asteroid4")
onready var globals = get_node("/root/GlobalStats")

var destroyed = false
var rotation_direction = rand_range(-1, 1)
var max_y = 650
var destruction_points = 10
var gravity

# Called when the node enters the scene tree for the first time.
func _ready():
	#rb.gravity_scale = globals.randomized_asteroid_gravity()
	#self.connect("player_dead",self.get_parent(),"_on_player_dead")
	self.connect("player_hit",self.get_parent(),"_on_player_hit")
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !destroyed:
		sprite.set_rotation(sprite.rotation+(delta*rotation_direction))
		if rb.position.y > max_y:
			globals.remove(self)
		if(gravity!=null):
			rb.add_central_force(gravity*delta*10)
	#print("foo")

func _initialize():
	rb.linear_velocity = gravity*500

func _on_RigidBody2D_body_entered(_body):
	if(_body.is_in_group("asteroid")):
		return
	elif(_body.is_in_group("projectile")):
		fx.position = rb.position
		globals.remove(rb)
		globals.remove(_body.get_parent())
		fx.emitting = true
		hit_audio.play()		
		destroyed = true
		globals.score = globals.score + destruction_points
	elif(_body.is_in_group("player")):
		fx.position = rb.position
		globals.remove(rb)
		fx.emitting = true
		#hit_audio.play()
		destroyed = true
		var alive = globals.damage_player(1) #reduce player_health
		#if !alive:
		#	emit_signal("player_dead")
		#	globals.set_game_over(true)
		emit_signal("player_hit")



func set_max_y(_value):
	max_y = _value
