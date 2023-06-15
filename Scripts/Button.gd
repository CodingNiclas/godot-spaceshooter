extends TextureButton


@export var text:String

@onready var text_obj = get_node("Text")

# Called when the node enters the scene tree for the first time.
func _ready():
	text_obj.text = text
	
	#pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
