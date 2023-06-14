extends Control


@onready var globals = GlobalStats

# Called when the node enters the scene tree for the first time.
func _ready():
	#get_node("/root/Bgm")
	var anim = get_node("AnimationPlayer")
	anim.play("idle")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_start_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/Level_Mobile.tscn")
	
