extends Camera2D


# Declare member variables here. Examples:
# var a = 2
var b:float


# Called when the node enters the scene tree for the first time.
func _ready():
	#OS.window_size = Vector2(2560, 1440)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	var pos:float = float(get_viewport().size.y+2) / 1440.0
	if(!b==pos):
		zoom=Vector2(pos,pos)
		b=pos
	#position = Vector2(pos.x-get_viewport().size.x,pos.y-get_viewport().size.y)
	pass
