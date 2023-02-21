extends Node2D
var asteroid_scene = load("res://Asteroid.tscn")

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_AsteroidTimer_timeout():
	var asteroid = asteroid_scene.instance()
	var left = get_node("AsteroidSpawnLeft").position
	var right = get_node("AsteroidSpawnRight").position
	var pos = left + (right - left) * rand_range(0,1) # left + [0,1]*Vec(left->right)
	asteroid.position = pos
	#var sprite = asteroid.get_children()[0]
	var direction = Vector2(0,-1)
	#asteroid.linear_velocity = direction
	
	var velocity = Vector2(0.0, rand_range(150.0, 200.0))
	asteroid.linear_velocity = velocity #.rotated(direction)

	add_child(asteroid)
