@tool

class_name Node4D
extends Node3D

@export_group("Transform4D")
var _position : Vector4 = Vector4.ZERO :
	get: return Vector4(_transform.position)
	set(p): 
		_transform = Transform4D.new(p, _transform.rotation_degrees, _transform.scale)
var _rotation : Vector4 = Vector4.ZERO :
	get: return Vector4(_transform.rotation_degrees)
	set(r): 
		_transform = Transform4D.new(_transform.position, r, _transform.scale)
var _scale : Vector4 = Vector4.ONE :
	get: return Vector4(_transform.scale)
	set(s): 
		_transform = Transform4D.new(_transform.position, _transform.rotation_degrees, s)

var _transform : Transform4D = Transform4D.new() :
	get:
		var pos = Vector4(position.x, position.y, position.z, _transform.position.w)
		var rot = Vector4(rotation_degrees.x, rotation_degrees.y, rotation_degrees.z, _transform.rotation_degrees.w)
		var scl = Vector4(scale.x, scale.y, scale.z, _transform.scale.w)

		return Transform4D.new(pos, rot, scl)
	set(p_transform):
		position.x = p_transform.position.x
		position.y = p_transform.position.y
		position.z = p_transform.position.z
		rotation_degrees.x = p_transform.rotation_degrees.x
		rotation_degrees.y = p_transform.rotation_degrees.y
		rotation_degrees.z = p_transform.rotation_degrees.z
		scale.x = p_transform.scale.x
		scale.y = p_transform.scale.y
		scale.z = p_transform.scale.z

		_transform = p_transform

# Properties

func _get_property_list() -> Array[Dictionary]: ## Add hint to rotation and fix order
	var props:Array[Dictionary] = []

	props.push_back({
		"name": "_position",
		"type": TYPE_VECTOR4,
		"usage": PROPERTY_USAGE_DEFAULT,
	})

	props.push_back({
		"name": "_rotation",
		"type": TYPE_VECTOR4,
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
	return _property == "_position" || _property == "_rotation" || _property == "_scale"

func _property_get_revert(_property):
	if _property == "_position":
		return Vector4.ZERO
	if _property == "_rotation":
		return Vector4.ZERO
	if _property == "_scale":
		return Vector4.ONE
	return null