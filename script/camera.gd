extends Camera2D


# Declare member variables here. Examples:
# var a = 2

func _ready() -> void:
	var height:float = float(get_viewport().size.y)
	var width:float = height * 1.78
	var width_current:float = float(get_viewport().size.x)
	var offset_x:float = width - width_current
	zoom=Vector2(height,height)/ 1440.0
	offset=Vector2(offset_x / zoom.x,0.0)
