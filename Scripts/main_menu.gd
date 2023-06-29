extends Control


@export var start_button:TextureButton
@export var credit_screen:Node
@export var credit_button:TextureButton
@export var credit_button_text:Label

@onready var highscore_label = get_node("HighscoreLabel")

@onready var globals = GlobalStats

var credits_active = false

# Called when the node enters the scene tree for the first time.
func _ready():
	#get_node("/root/Bgm")
	highscore_label.text = "Highscore\n%05dpts" % [globals.highscore] if globals.highscore>0 else ""
	var anim = get_node("AnimationPlayer")
	anim.play("idle")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_start_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/Level_Mobile.tscn")
	


func _on_creddit_button_pressed():
	credits_active = !credits_active
	start_button.visible = !credits_active
	credit_button.visible = !credits_active
	#credit_screen.visible = credits_active
	if credits_active:
		credit_screen.activate()
	#credit_screen.get_node("CreditsText").visible_ratio = 0
	credit_button_text.text = "close" if credits_active else "Credits"
