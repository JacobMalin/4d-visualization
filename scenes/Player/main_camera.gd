@tool
class_name MainCamera
extends XRCamera3D

var w = 0

# func _physics_process(_delta):
# 	# Store plane eq
# 	var global_normal = global_transform4.basis.y
# 	FlatReference.plane = Plane(global_normal, global_position)
# 	FlatReference.tiny_camera_pos = global_position
