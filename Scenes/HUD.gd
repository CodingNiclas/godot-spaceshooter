extends CanvasLayer

signal restart

onready var health_label = get_node("HealthLabel")
onready var score_label = get_node("ScoreLabel")
onready var lvl_label = get_node("LvlLabel")

onready var go_screen = get_node("GameOverScreen")
onready var globals = get_node("/root/GlobalStats")
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	go_screen.visible = false
	self.connect("restart",self.get_parent(),"_on_restart")
	#health_label.text = "HP: 00"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var hp = globals.get_player_hp()
	health_label.text = "HP: "+String(hp)
	score_label.text = "Score: "+String(globals.score)
	lvl_label.text = "lvl: "+String(globals.phase)
	if hp<=0:	
		go_screen.visible = true
		globals.set_game_over(true)


func _on_RestartButton_pressed():
	globals.refill_player_hp()
	go_screen.visible = false
	emit_signal("restart")
	globals.set_game_over(false)
	
