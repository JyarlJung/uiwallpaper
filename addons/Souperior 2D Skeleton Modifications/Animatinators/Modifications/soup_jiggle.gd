@tool
@icon("Icons/icon_jiggle.png")
class_name SoupJiggle 
extends SoupMod
## "Souperior" modification for Skeleton2D; 
## Runs simplified physics simulation on the bone;
## Can be used as an alternative for LookAt with a different easing behaviour.

## Target node;
## The bone tries to align itself towards this node;
## To avoid unintended behaviour, make sure this node is NOT a child of the to-be-modified bone.
@export var target_node: Node2D:
	set(new_value):
		target_node = new_value
		fix_easing()
## If true, the modification is calculated and applied.
@export var enabled: bool = false:
	set(new_value):
		enabled = new_value
		fix_easing()

@export_category("Bones")

## The to-be-modified bone node.
@export var bone_node: Bone2D:
	set(new_value):
		bone_node=new_value
		fix_easing()
@export var tail_node: Bone2D:
	set(new_value):
		tail_node=new_value
		fix_easing()

#region easing
@export_category("Easing")

## If true, easing is appied;
## Required for the effect to feel "jiggly".
@export var use_easing: bool = false:
	set(new_value):
		use_easing = new_value
		fix_easing()

## Easing Resource;
## Defines easing behaviour
@export var easing: SoupySecondOrderEasing: 
	set(new_value):
		if !(new_value is SoupySecondOrderEasing):
			easing = null
			return
		easing = new_value.duplicate(true)
		
		if !bone_node:
			return
		fix_easing()
#endregion

var tail:Vector2
var tail_rotation:float

func _ready() -> void:
	fix_easing()


func _process(delta: float) -> void:
	if !(
			enabled 
			and target_node 
			and bone_node 
			and _parent_enable_check()
		):
		return
	
	var targetVector: Vector2 = \
	(target_node.global_position+get_tail() - bone_node.global_position).normalized()
	
	if easing and use_easing:
		easing.update(delta, target_node.global_position+get_tail())
		targetVector = (easing.state - bone_node.global_position).normalized()
	
	var result_rotation: float = \
	rotation_global_to_local(targetVector.angle()*sign(bone_node.global_scale.y),
			bone_node.get_parent()
			) - bone_node.get_bone_angle()
	
	var fixed_rotation: float = \
			_mod_stack.apply_bone_rotation_mod(bone_node, result_rotation) \
			 + bone_node.get_bone_angle()
	
	if fixed_rotation and easing and use_easing:
		easing.state = bone_node.global_position\
				+ Vector2.RIGHT.rotated(
					rotation_local_to_global(
						fixed_rotation,
						bone_node.get_parent()
					) * sign(bone_node.global_scale.y)
				)\
		* bone_node.global_position.distance_to(target_node.global_position+get_tail())


## Updates the internal variables of the easing resource to match the current wanted state;
## Prevents weird behaviour on bone change, scene reload, or any other situation that may cause the easing internals to become outdated.
func fix_easing():
	if !(easing and bone_node and target_node):
		return
	var angleVector:Vector2
	if(tail_node):
		angleVector = (tail_node.global_position - bone_node.global_position) * 1.15
	elif(!bone_node.get_autocalculate_length_and_angle()):
		angleVector = Vector2.RIGHT.rotated(bone_node.get_bone_angle()) * bone_node.get_length() * 1.15
	else:
		return
	
	tail = bone_node.global_position + angleVector - target_node.global_position
	tail_rotation = target_node.global_rotation
	
	easing.initialize_variables(target_node.global_position + get_tail())
	
func get_tail()->Vector2:
	return tail.rotated(target_node.global_rotation-tail_rotation)
	
