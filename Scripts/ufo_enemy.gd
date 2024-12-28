extends Node2D

@onready var ufo = get_node("SpaceshipUFO/UFOSprite")
var destroyed = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	global_position += delta * Vector2.DOWN * 50

func _on_shot_timer_timeout() -> void:
	ufo.shoot_all()

func _on_area_body_entered(cbody):
	print("ufo body entered!")
	if(cbody.is_in_group("asteroid")):
		pass
		#get_parent().collision(CollisionType.Enemy)
	elif(cbody.is_in_group("projectile")):
		projectile_collide(cbody)
		#get_parent().collision(CollisionType.Projectile)
	elif(cbody.is_in_group("player")):
		player_collide()

func _on_area_area_entered(carea):
	print("ufo area entered!")
	if(carea.is_in_group("asteroid")):
		pass
		#get_parent().collision(CollisionType.Enemy)
	elif(carea.is_in_group("projectile")):
		projectile_collide(carea)
		#get_parent().collision(CollisionType.Projectile)
	elif(carea.is_in_group("player")):
		player_collide()
		
func projectile_collide(projectile):
	if destroyed:
		return
	#var par = projectile.get_parent()
	#if par.hp<=0:
		#print(par.hp,": double collision => exit")	
	#	return
	#print("projectile hit, destroyed: ",destroyed)
	#projectile.get_parent().hit(1)#hp -= 1	
	#play_hit_effects()
	#deactivate_body()		
	destroyed = true
	deactivate_body()
	
	#globals.score = globals.score + destruction_points
	#if randf_range(0,1)<globals.health_drop_rate:
	#	spawner.spawn_item(bdy.global_position)
	#spawner.register_enemy_dest(bdy.global_position)
	
func deactivate_body():
	var bdy = get_node("SpaceshipUFO")
	bdy.set_collision_layer_value(2,false)
	bdy.set_collision_mask_value(1,false)
	bdy.visible = false

func player_collide():
	pass
#	play_hit_effects()
#	deactivate_body()	


#	destroyed = true
#	var hp = globals.get_player_hp()
#	if hp>0:
#		if(globals.damage_player(1)): #try reducing player_health and if successful 
#			print("HIT")
#			player.hit() #play hit effects
#	if globals.get_player_hp()==0:
#		get_node("/root/Bgm").play_game_over()
#		get_node("/root/Node2D_Level/AsteroidTimer").stop()
#		player.die()
