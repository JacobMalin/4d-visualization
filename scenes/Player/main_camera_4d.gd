@tool
class_name MainCamera4D
extends Node4D

func _physics_process(_delta):
	# Store space eq
	var global_normal = _global_transform.basis.y
	HyperReference.space = Space.newFromPoint(global_normal, _global_position)
	HyperReference.space.normalize()
	HyperReference.camera_pos = _global_position

	if Engine.is_editor_hint(): return