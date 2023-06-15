extends Node2D
#signal player_dead
signal player_hit

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
@onready var globals = get_node("/root/GlobalStats")
@onready var spawner = get_node("/root/Spawner")

@onready var bdy:Area2D = get_node("Area2D")
@onready var fx = get_node("ExplosionParticles")
@onready var hit_audio = get_node("HitAudio")
@onready var sprite = get_node("Area2D/Asteroid4")
@onready var max_y = globals.bottom_right.y

@onready var player = get_node("/root/Node2D_Level/Player")

var destroyed = false
var rotation_direction = randf_range(-1, 1)
var destruction_points = 10


enum CollisionType{Player,Enemy,Projectile} #used to differentiate types of collisions reported by bdy

# Called when the node enters the scene tree for the first time.
func _ready():
	#bdy.gravity_scale = globals.randomized_asteroid_gravity()
	#self.connect("player_dead",Callable(self.get_parent(),"_on_player_dead"))
	self.connect("player_hit",Callable(self.get_parent(),"_on_player_hit"))
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !destroyed:
		sprite.set_rotation(sprite.rotation+(delta*rotation_direction))
		if bdy.position.y > max_y:
			globals.remove(self)


func set_body_gravity(direction:Vector2,force:float):
	bdy.set_direction(direction,force)

func get_body():
	#print("bdy requested.")
	return bdy

func _on_area_body_entered(cbody):
	if(cbody.is_in_group("asteroid")):
		enemy_collide()
		#get_parent().collision(CollisionType.Enemy)
	elif(cbody.is_in_group("projectile")):
		projectile_collide(cbody)
		#get_parent().collision(CollisionType.Projectile)
	elif(cbody.is_in_group("player")):
		player_collide()
		#get_parent().collision(CollisionType.Player)	

func _on_area_area_entered(carea):
	if(carea.is_in_group("asteroid")):
		enemy_collide()
		#get_parent().collision(CollisionType.Enemy)
	elif(carea.is_in_group("projectile")):
		#globals.remove(carea)
		projectile_collide(carea)
		#get_parent().collision(CollisionType.Projectile)
	elif(carea.is_in_group("player")):
		player_collide()
		#get_parent().collision(CollisionType.Player)	

func enemy_collide():
	pass
func projectile_collide(projectile):
	if destroyed:
		return
	var par = projectile.get_parent()
	if par.hp<=0:
		#print(par.hp,": double collision => exit")	
		return
	#print("projectile hit, destroyed: ",destroyed)
	projectile.get_parent().hit(1)#hp -= 1	
	play_hit_effects()
	deactivate_body()		
	destroyed = true
	globals.score = globals.score + destruction_points
	#if randf_range(0,1)<globals.health_drop_rate:
	#	spawner.spawn_item(bdy.global_position)
	spawner.register_enemy_dest(bdy.global_position)
	
	
func player_collide():
	play_hit_effects()
	deactivate_body()	
	
	
	destroyed = true
	var hp = globals.get_player_hp()
	if hp>0:
		if(globals.damage_player(1)): #try reducing player_health and if successful 
			print("HIT")
			player.hit() #play hit effects
	if globals.get_player_hp()==0:
		get_node("/root/Bgm").play_game_over()
		get_node("/root/Node2D_Level/AsteroidTimer").stop()
		player.die()
	
	#emit_signal("player_hit")
	#if !alive:
	#	emit_signal("player_dead")
	#	globals.set_game_over(true)

func deactivate_body():
	bdy.set_collision_layer_value(2,false)
	bdy.set_collision_mask_value(1,false)
	bdy.visible = false

func play_hit_effects():
	var velocity:Vector3 = Vector3(0,0,0)*bdy.velocity#Vector3(bdy.get_velocity_vector().x , bdy.get_velocity_vector().y , 0)
	#audio:
	hit_audio.play()
	#particles:
	fx.position = bdy.position
	fx.emitting = true
	fx.process_material.set("gravity",velocity)
