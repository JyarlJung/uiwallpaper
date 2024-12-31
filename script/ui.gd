extends Node2D

@export var anime:AnimationPlayer
@export var chick:Bone2D
@export var head:Bone2D
@export var grab:AudioStreamPlayer
@export var rel:AudioStreamPlayer
var balled:bool = false
var cry:int = 0
var _initpos_mouse:Vector2
var _initpos_chick:Vector2
var _initpos_head:Vector2
# Called when the node enters the scene tree for the first time.



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	anime.advance(delta)
	if Input.is_action_just_pressed("click"):
		print(get_global_mouse_position().distance_to(chick.global_position))
		if get_global_mouse_position().distance_to(chick.global_position) < 70:
			_initpos_mouse=get_global_mouse_position()
			_initpos_chick = chick.position
			_initpos_head = head.position
			anime.play("balled",0.2)
			balled = true
			cry=0
			grab.play()
		
	if Input.is_action_just_released("click") and balled == true:
		balled = false
		anime.play("cry",0.12)
		anime.queue("cry_remain")
		#anime.play("idle",-1,1.0)
		cry=230
		rel.play()
		
	if cry>0:
		cry-=1
		if cry==0:
			anime.play("idle",0.3)
	
	if balled:
		var delt:Vector2 = (get_global_mouse_position()-_initpos_mouse)
		delt = delt.normalized() * (pow(delt.length(),0.75))
		delt.x = clamp(delt.x,delt.x,50)
		chick.position = _initpos_chick + delt
		head.position = _initpos_head + (delt*0.1)
		
		


	pass
