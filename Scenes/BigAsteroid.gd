extends Node2D
#signal player_dead
signal player_hit

var asteroid_scene = load("res://Asteroid.tscn")


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
#onready var foo = get_node("RigidBody2D")
onready var rb = get_node("RigidBody2D")
onready var fx = get_node("ExplosionParticles")
onready var sprite = get_node("RigidBody2D/Asteroid")
onready var globals = get_node("/root/GlobalStats")

var collision_velocity = Vector2(0,0)
var destroyed = false
var splitted = false
var rotation_direction = rand_range(-1, 1)
var max_y = 650

# Called when the node enters the scene tree for the first time.
func _ready():
	rb.linear_velocity = Vector2(0,100)
	#self.connect("player_dead",self.get_parent(),"_on_player_dead")
	self.connect("player_hit",self.get_parent(),"_on_player_hit")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !destroyed and sprite != null:
		sprite.set_rotation(sprite.rotation+(delta*rotation_direction))
		if rb.position.y > max_y:
			globals.remove(self)
	elif !splitted:
		var a1 = asteroid_scene.instance()
		var a1_rb = a1.get_node("RigidBody2D")
		a1_rb.global_position = self.fx.global_position
		a1_rb.linear_velocity = collision_velocity * 1.5
		self.get_parent().add_child(a1)
		#a1.global_position = self.global_position
		splitted = true
		print(a1.position)


func _on_RigidBody2D_body_entered(_body):
	print("big asteroid collision")
	if(_body.is_in_group("asteroid")):
		return
	elif(_body.is_in_group("projectile")):
		print("big asteroid damaged")
		fx.position = rb.position
		fx.emitting = true
		collision_velocity = rb.linear_velocity		
		globals.remove(rb)
		globals.remove(_body.get_parent())
		destroyed = true
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