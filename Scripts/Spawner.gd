extends Node


@onready var item_scn = load("res://Scenes/Item.tscn")

const idr = 50 #item-drop-rate: how many asteroids destroyed (average) until item appears
const dv = 10 #drop-variance: how far can the actual drop differ from the drop_rate?
var dest_until_drop = 0 #no. of destructions since last drop 

# Called when the node enters the scene tree for the first time.
func _ready():
	dest_until_drop = randi_range(idr-dv,idr+dv)
	print("destruction happens after ",dest_until_drop," enemies") 


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func spawn_item(position):
	var item = item_scn.instantiate()
	item.global_position = position
	get_node("/root/Node2D_Level").call_deferred("add_child",item)

func register_enemy_dest(pos):
	dest_until_drop-=1
	#print(dest_until_drop," destructions left")
	if dest_until_drop==0:
		spawn_item(pos)
		dest_until_drop = randi_range(idr-dv,idr+dv)
	
	
