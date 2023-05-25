extends Area2D


var direction:Vector2 #direction the asteroid moves (=simulated gravity)
var force:float #base force
var velo_diff:float #indicates how the force differentiates from global velocity 
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
	#velocity = 0

# Applies the simulated gravity
func apply_gravity(delta):
	#print(velocity)
	var move = direction*delta*GlobalStats.asteroid_base_gravity
	#print(move)
	global_position += move
	#velocity+=force*delta => removed because we decided to omit accelerations...

func prewarm(seconds:float):
	print("please don't call this function ^^")
	#velocity+=force*seconds

func get_velocity_vector():
	return direction*velocity
