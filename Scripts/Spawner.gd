extends Node


@onready var item_health = load("res://Scenes/Item.tscn")
@onready var coin = load("res://Scenes/ItemCoin.tscn")

const dr_health = 50 #item-drop-rate: how many asteroids destroyed (average) until item appears
const dv_health = 10 #drop-variance: how far can the actual drop differ from the drop_rate?
const dr_coin = 20 #item-drop-rate: how many asteroids destroyed (average) until item appears
const dv_coin = 5 #drop-variance: how far can the actual drop differ from the drop_rate?
	
	
	
var till_health = 0 #no. of destructions since last drop 
var till_coin = 0 #no. of destructions since last drop 

# Called when the node enters the scene tree for the first time.
func _ready():
	recalculate_health()
	recalculate_coin()
	print("health spawn happens after ",till_health," enemies") 


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func spawn_item(position,item):
	var nitem = item.instantiate()
	nitem.global_position = position
	get_node("/root/Node2D_Level").call_deferred("add_child",nitem)

func register_enemy_dest(pos):
	till_health-=1
	till_coin-=1
	#print(dest_until_drop," destructions left")
	if till_health<=0:
		spawn_item(pos,item_health)
		recalculate_health()
	elif till_coin<=0:
		spawn_item(pos,coin)
		recalculate_coin()
	
	
func recalculate_health():
	till_health = randi_range(dr_health-dv_health,dr_health+dv_health)
func recalculate_coin():
	till_coin = randi_range(dr_coin-dv_coin,dr_coin+dv_coin)
	
