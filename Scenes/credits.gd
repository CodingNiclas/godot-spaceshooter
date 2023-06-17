extends Control

@export var text:RichTextLabel
@export var close_button:TextureButton

var text_delay = 15

# Called when the node enters the scene tree for the first time.
func _ready():
	text.visible_ratio = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if text.visible_ratio<1:
		text.visible_ratio+=delta/text_delay
	elif close_button.visible==false:
		close_button.visible = true


func _on_close_button_pressed():
	self.visible = false
	self.get_node("../")._on_creddit_button_pressed()
