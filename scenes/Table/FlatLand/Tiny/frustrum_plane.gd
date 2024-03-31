@tool
class_name FrustrumPlane
extends Node3D


func _process(_delta):
	# Store plane eq
	var global_normal = global_transform.basis.y
	TinyPlane.frustrum_plane = Plane(global_normal, global_position)
