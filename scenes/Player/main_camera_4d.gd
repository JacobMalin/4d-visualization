@tool
class_name MainCamera4D
extends Node4D

func _physics_process(_delta):
	# Store space eq
	var global_normal = _global_transform.basis.w
	# print('--')
	# print(_global_transform.basis.x)
	# print(_global_transform.basis.y)
	# print(_global_transform.basis.z)
	# print(_global_transform.basis.w)
	HyperReference.space = Space.newFromPoint(global_normal, _global_position)
	HyperReference.camera_pos = _global_position

	if Engine.is_editor_hint(): return