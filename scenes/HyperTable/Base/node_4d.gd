@tool
class_name Node4D
extends Node3D

@export_group("Transform4D")
@warning_ignore("unused_private_class_variable")
var _rotation_2 : Vector3 = Vector3.ZERO :
	get: return Vector3(_transform.rotation_degrees_2)
	set(r2): 
		_transform = Transform4D.new(_transform.position, _transform.rotation_degrees_1, r2, _transform.scale)
@warning_ignore("unused_private_class_variable")
var _scale : Vector4 = Vector4.ONE :
	get: return Vector4(_transform.scale)
	set(s): 
		_transform = Transform4D.new(_transform.position, _transform.rotation_degrees_1, _transform.rotation_degrees_2, s)
@export var scale_w = 1.0

@onready var parent = get_parent()
@onready var parent_is_4d = parent and parent is Node4D

var _global_position_w:
	get:
		var global_position_w = position_w

		if parent_is_4d:
			global_position_w += parent._global_position_w

		return global_position_w

var _global_position:
	get:
		return Vector4(global_position.x, global_position.y, global_position.z, _global_position_w)

var _global_rotation_1:
	get:
		return global_rotation_degrees

var _global_rotation_2:
	get:
		var global_rotation_2 = rotation_2

		if parent_is_4d:
			global_rotation_2 += parent._global_rotation_2

		return global_rotation_2
	set(r2):
		rotation_2 = r2

		if parent_is_4d:
			rotation_2 -= parent._global_rotation_2

var _global_scale_w:
	get:
		var global_scale_w = scale_w

		if parent_is_4d:
			global_scale_w *= parent._global_scale_w

		return global_scale_w
		
var _global_scale:
	get:
		return Vector4(scale.x, scale.y, scale.z, _global_scale_w)

@warning_ignore("unused_private_class_variable")
var _global_transform:
	get:
		return Transform4D.new(_global_position, _global_rotation_1,
							   _global_rotation_2, _global_scale)
