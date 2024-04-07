@tool
class_name Node4D
extends Node3D

@export_group("Transform4D")
@warning_ignore("unused_private_class_variable")
var _position : Vector4 = Vector4.ZERO :
	get: return Vector4(_transform.position)
	set(p): 
		_transform = Transform4D.new(p, _transform.rotation_degrees_1, _transform.rotation_degrees_2, _transform.scale)
@warning_ignore("unused_private_class_variable")
var _rotation_1 : Vector3 = Vector3.ZERO :
	get: return Vector3(_transform.rotation_degrees_1)
	set(r1): 
		_transform = Transform4D.new(_transform.position, r1, _transform.rotation_degrees_2, _transform.scale)
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

var _transform : Transform4D = Transform4D.new() :
	get:
		var pos = Vector4(position.x, position.y, position.z, _transform.position.w)
		var rot_1 = Vector3(rotation_degrees)
		var rot_2 = Vector3(_transform.rotation_degrees_2)
		var scl = Vector4(scale.x, scale.y, scale.z, _transform.scale.w)

		return Transform4D.new(pos, rot_1, rot_2, scl)
	set(p_transform):
		position.x = p_transform.position.x
		position.y = p_transform.position.y
		position.z = p_transform.position.z
		rotation_degrees.x = p_transform.rotation_degrees_1.x
		rotation_degrees.y = p_transform.rotation_degrees_1.y
		rotation_degrees.z = p_transform.rotation_degrees_1.z
		scale.x = p_transform.scale.x
		scale.y = p_transform.scale.y
		scale.z = p_transform.scale.z

		_transform = p_transform


var _global_position : Vector4 = Vector4.ZERO :
	get:
		var parent = get_parent()
		var parent_pos = Vector4.ZERO
		if parent:
			if parent is Node4D:
				parent_pos = parent._global_position
			elif parent is Node3D:
				parent_pos.x = parent.global_position.x
				parent_pos.y = parent.global_position.y
				parent_pos.z = parent.global_position.z
		return parent_pos + Vector4(_transform.position)
	set(p):
		var parent = get_parent()
		var parent_pos = Vector4.ZERO
		if parent:
			if parent is Node4D:
				parent_pos = parent._global_position
			elif parent is Node3D:
				parent_pos.x = parent.global_position.x
				parent_pos.y = parent.global_position.y
				parent_pos.z = parent.global_position.z
		_transform = Transform4D.new(p - parent_pos, _transform.rotation_degrees_1, 
									 _transform.rotation_degrees_2, _transform.scale)


var _global_rotation_1 : Vector3 = Vector3.ZERO :
	get:
		var parent = get_parent()
		var parent_rot = Vector3.ZERO
		if parent:
			if parent is Node4D:
				parent_rot = parent._global_rotation_1
			elif parent is Node3D:
				parent_rot.x = parent.global_rotation_degrees.x
				parent_rot.y = parent.global_rotation_degrees.y
				parent_rot.z = parent.global_rotation_degrees.z
		return parent_rot + Vector3(_transform.rotation_degrees_1)
	set(r1):
		var parent = get_parent()
		var parent_rot = Vector3.ZERO
		if parent:
			if parent is Node4D:
				parent_rot = parent._global_rotation_1
			elif parent is Node3D:
				parent_rot.x = parent.global_rotation_degrees.x
				parent_rot.y = parent.global_rotation_degrees.y
				parent_rot.z = parent.global_rotation_degrees.z
		_transform = Transform4D.new(_transform.position, r1 - parent_rot, 
		                             _transform.rotation_degrees_2, _transform.scale)


var _global_rotation_2 : Vector3 = Vector3.ZERO :
	get:
		var parent = get_parent()
		var parent_rot = Vector3.ZERO
		if parent and parent is Node4D:
				parent_rot = parent._global_rotation_2
		return parent_rot + Vector3(_transform.rotation_degrees_2)
	set(r2):
		var parent = get_parent()
		var parent_rot = Vector3.ZERO
		if parent and parent is Node4D:
				parent_rot = parent._global_rotation_2
		_transform = Transform4D.new(_transform.position, _transform.rotation_degrees_1,
									 r2 - parent_rot, _transform.scale)


var _global_scale : Vector4 = Vector4.ZERO :
	get:
		var parent = get_parent()
		var parent_scl = Vector4.ONE
		if parent:
			if parent is Node4D:
				parent_scl = parent._global_scale
			elif parent is Node3D:
				parent_scl.x = parent.scale.x
				parent_scl.y = parent.scale.y
				parent_scl.z = parent.scale.z
		return parent_scl * Vector4(_transform.scale)
	set(s):
		var parent = get_parent()
		var parent_scl = Vector4.ONE
		if parent:
			if parent is Node4D:
				parent_scl = parent.scale
			elif parent is Node3D:
				parent_scl.x = parent.scale.x
				parent_scl.y = parent.scale.y
				parent_scl.z = parent.scale.z
		_transform = Transform4D.new(_transform.position, _transform.rotation_degrees_1, 
									 _transform.rotation_degrees_2, s / parent_scl)


@warning_ignore("unused_private_class_variable")
var _global_transform : Transform4D = Transform4D.new() :
	get:
		var pos = _global_position
		var rot_1 = _global_rotation_1
		var rot_2 = _global_rotation_2
		var scl = _global_scale

		return Transform4D.new(pos, rot_1, rot_2, scl)
	set(t):
		var _node = Node4D.new()

		_node._global_position = t._position
		_node._global_rotation_1 = t._rotation_degrees_1
		_node._global_rotation_2 = t._rotation_degrees_2
		_node._global_scale = t._scale

		_transform = _node._transform

# Properties

func _get_property_list() -> Array[Dictionary]: ## Add hint to rotation and fix order
	var props:Array[Dictionary] = []

	props.push_back({
		"name": "_position",
		"type": TYPE_VECTOR4,
		"usage": PROPERTY_USAGE_DEFAULT,
	})

	props.push_back({
		"name": "_rotation_1",
		"type": TYPE_VECTOR3,
		"hint": PROPERTY_HINT_RANGE,
		"hint_string": "-360,360,0.1",
	})

	props.push_back({
		"name": "_rotation_2",
		"type": TYPE_VECTOR3,
		"hint": PROPERTY_HINT_RANGE,
		"hint_string": "-360,360,0.1",
	})

	props.push_back({
		"name": "_scale",
		"type": TYPE_VECTOR4,
		"hint": PROPERTY_HINT_LINK,
	})

	return props

func _property_can_revert(_property):
	return _property == "_position" || _property == "_rotation_1" || _property == "_rotation_2" || _property == "_scale"

func _property_get_revert(_property):
	if _property == "_position":
		return Vector4.ZERO
	elif _property == "_rotation_1":
		return Vector3.ZERO
	elif _property == "_rotation_2":
		return Vector3.ZERO
	elif _property == "_scale":
		return Vector4.ONE
	return null