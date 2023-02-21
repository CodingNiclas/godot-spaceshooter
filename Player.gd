extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var mouse_pos = position
var thresh = 10

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var vector = (mouse_pos - position)#.normalized()
	if(vector.length()>thresh):
		position = position + (vector.normalized() * 1000 * delta)
	else:
		position = mouse_pos

func _input(event):
	if event is InputEventMouseMotion:
	   mouse_pos = event.position
