extends "res://Scripts/Asteroid.gd"


var asteroid_scene = load("res://Scenes/Asteroid.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func deactivate_body():
	bdy.set_collision_layer_value(2,false)
	bdy.set_collision_mask_value(1,false)
	bdy.visible = false
	self.call_deferred("split",Vector2(randf_range(0.25,0.5),1))
	self.call_deferred("split",Vector2(-randf_range(0.25,0.5),1))
	self.call_deferred("split",Vector2(randf_range(-0.1,0.1),1))
	
func split(dir):
	dir = dir.normalized()
	var a = asteroid_scene.instantiate()
	var area = a.get_node("Area2D")
	#a1_rb.linear_velocity = 150*_dir
	self.get_parent().add_child(a)
	area.global_position = bdy.global_position+dir*45
	a.set_body_gravity(dir,bdy.velocity)
	area.velocity = bdy.velocity
	globals.spawned_asteroids.append(a)

	
