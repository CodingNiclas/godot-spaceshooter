extends CanvasLayer

signal restart


#sprites
@export var pause_sprite: Texture2D
@export var play_sprite: Texture2D

#labels
@onready var health_label = get_node("HealthLabel")
@onready var score_label = get_node("ScoreLabel")
@onready var lvl_label = get_node("LvlLabel")
@onready var time_label = get_node("TimeLabel")
@onready var coin_label = get_node("TextureRect/CoinLabel")

#buttons
@onready var pause_button = get_node("PauseButton")

@onready var volume_slider = get_node("PauseScreen/VolumeLabel/VolumeSlider")

@onready var go_screen = get_node("GameOverScreen")
@onready var pause_screen = get_node("PauseScreen")
@onready var globals = get_node("/root/GlobalStats")
@onready var bgm = get_node("/root/Bgm")

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var paused = false
var elapsed = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	pause_button.icon = pause_sprite
	volume_slider.value = bgm.get_volume_perc()
	process_mode = Node.PROCESS_MODE_ALWAYS
	go_screen.visible = false
	pause_screen.visible = false
	self.connect("restart",Callable(self.get_parent(),"_on_restart"))
	#health_label.text = "HP: 00"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var hp = globals.get_player_hp()
	health_label.text = "HP "+ String.num(hp)
	score_label.text = "Score\n%05d" % [globals.score]
	coin_label.text = "x%02d" % [globals.coins]
	lvl_label.text = "LVL "+String.num(globals.phase)
	if hp<=0:	
		go_screen.visible = true
		globals.set_game_over(true)
		pause_button.visible = false #deactivate pause function when game over
	if not globals.is_paused() and not globals.is_game_over():
		update_game_time(delta)



func _on_RestartButton_pressed():
	globals.unpause()	
		
	globals.refill_player_hp()
	go_screen.visible = false
	pause_screen.visible = false
	emit_signal("restart")
	globals.set_game_over(false)
	pause_button.visible = true #reactivate pause function when restarting
	elapsed = 0
	
	pause_button.icon = pause_sprite
	paused = false
	


func _on_PauseButton_pressed():
	#toggle pause:
	print("toggle pause")
	if globals.is_paused():
		bgm.play_ingame()		
		#pause_button.text = "| |"
		pause_button.icon = pause_sprite
		pause_screen.visible = false
		globals.unpause()
	else:
		#pause_button.text = ">"
		bgm.play_pause()
		pause_screen.visible = true
		pause_button.icon = play_sprite
		globals.pause()
	paused = globals.is_paused()
	
	
	
func update_game_time(delta):
	elapsed += int(delta*1000)#game_timer.wait_time*1000
	var ts = elapsed % 1000
	var secs =  ((elapsed-ts)/1000)%60
	var mins = (elapsed-ts-(secs*1000))/(60*1000)
#	var minutes = sec_elapsed % 3600 / 60
	var str_elapsed = "%02d:%02d:%02d" % [mins,secs,ts/10]
	time_label.text = str_elapsed


#func _on_game_timer_timeout():
#	elapsed += game_timer.wait_time*1000
#	var ts = elapsed % 1000
#	var secs =  ((elapsed-ts)/1000)%60
#	var mins = (elapsed-ts-(secs*1000))/(60*1000)
#	var minutes = sec_elapsed % 3600 / 60
#	var str_elapsed = "%02d : %02d : %01d" % [mins,secs,ts/100]
#	time_label.text = str_elapsed


func _on_volume_slider_changed(value):
	bgm.set_volume_perc(value)
