extends Area2D


var direction:Vector2 #direction the asteroid moves (=simulated gravity)
var force:float #base force
var velocity:float #the current speed (induced by gravity)



# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	#set_direction(Vector2(0,1),980)

# Called with physics updates
func _physics_process(delta):
	apply_gravity(delta)

# Sets direction of asteroid gravity (simulated)
func set_direction(direction, _force):
	#print(_force)
	#print("set asteroid gravity to ",direction, "with force ",force)
	self.direction = direction.normalized()
	self.force = _force
	velocity = 0

# Applies the simulated gravity
func apply_gravity(delta):
	var move = direction*velocity*delta
	global_position += move
	velocity+=force*delta

func prewarm(seconds:float):
	velocity+=force*seconds

func get_velocity_vector():
	return direction*velocity
