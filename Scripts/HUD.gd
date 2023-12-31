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
@onready var upgrade_label = get_node("GameOverScreen/UpgradeLabel")

#buttons
@onready var pause_button = get_node("PauseButton")
@onready var upgrade_button = get_node("GameOverScreen/UpgradeLabel/UpgradeButton")
@onready var upgrade_button_text = get_node("GameOverScreen/UpgradeLabel/UpgradeButton/Text")

#sliders
@onready var bgm_slider = get_node("PauseScreen/BgmLabel/VolumeSlider")
@onready var sfx_slider = get_node("PauseScreen/SfxLabel/VolumeSlider")

@onready var go_screen = get_node("GameOverScreen")
@onready var pause_screen = get_node("PauseScreen")
@onready var globals = get_node("/root/GlobalStats")
@onready var bgm = get_node("/root/Bgm")

#highscore
@onready var highscore_anim = get_node("HighscoreLabel/AnimationPlayer")
@onready var highscore_pts_label = get_node("HighscoreLabel/HighscorePtsLabel")
var highscore_displayed = false

#audio
@onready var sfx_bus = AudioServer.get_bus_index("SFX")
@onready var bgm_bus = AudioServer.get_bus_index("BGM")



# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var paused = false
var elapsed = 0


const upgrade_cost = 25

# Called when the node enters the scene tree for the first time.
func _ready():
	#slider initialization:
	bgm_slider.value = pow(2,AudioServer.get_bus_volume_db(bgm_bus))
	sfx_slider.value = pow(2,AudioServer.get_bus_volume_db(sfx_bus))
	#sfx_slider.min_value = 0.0001
	#sfx_slider.step = 0.0001
	
	
	#prevent highscore displaying in first round:
	if globals.highscore<=0: #if no previous highscore set
		highscore_displayed = true #act as if new-highscore was shown 
	pause_button.icon = pause_sprite
	process_mode = Node.PROCESS_MODE_ALWAYS
	go_screen.visible = false
	pause_screen.visible = false
	upgrade_button_text.text = "upgrade ship\n(%d coins)"%[upgrade_cost]
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
		game_over()
	if not globals.is_paused() and not globals.is_game_over():
		update_game_time(delta)
	if !highscore_displayed && globals.score > globals.highscore:
		show_new_highscore()


func game_over():
	go_screen.visible = true
	globals.set_game_over(true)
	pause_button.visible = false #deactivate pause function when game over
	upgrade_button.disabled = globals.coins<upgrade_cost #disabled if we cant afford upgrade 
	if upgrade_button.disabled:
		upgrade_button_text.set("theme_override_colors/font_color", Color(1,1,1,0.75))
	else:
		upgrade_button_text.set("theme_override_colors/font_color", Color(1,1,1,1))
	upgrade_label.visible=globals.ship_cannon_lvl==0 # hide if already bought



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
	highscore_displayed = false
	


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
	
func _on_UpgradeButton_pressed():
	print("upgrade player weapon")
	globals.coins-=upgrade_cost
	globals.upgrade_ship_cannon()
	
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



func _on_to_main_menu_button_pressed():
	_on_RestartButton_pressed()
	bgm.play_title()
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")

func show_new_highscore():
	highscore_pts_label.text = "%dpts" % [globals.score]
	highscore_anim.play("highscore_indication")
	highscore_displayed = true
	
	
func _on_volume_slider_changed(value):
	#bgm.set_volume_perc(value)
	if value == 0:
		AudioServer.set_bus_volume_db(bgm_bus, -80)
	else:
		AudioServer.set_bus_volume_db(bgm_bus, log(value)*20)


func _on_sfx_slider_value_changed(value):
	if value == 0:
		AudioServer.set_bus_volume_db(sfx_bus, -80)
	else:
		AudioServer.set_bus_volume_db(sfx_bus, log(value)*20)
