extends Node


@onready var item_scn = load("res://Scenes/Item.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func spawn_item(position):
	var item = item_scn.instantiate()
	item.global_position = position
	get_node("/root/Node2D_Level").call_deferred("add_child",item)
