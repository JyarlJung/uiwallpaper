extends Polygon2D


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var time:float = (sin(Time.get_ticks_msec() * 0.014)*0.05)
	scale = Vector2(1.0+time,1.0+time)
	pass
