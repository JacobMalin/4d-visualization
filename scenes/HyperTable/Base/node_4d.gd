@tool
class_name Node4D
extends Node3D

@export_group("Transform4D")
var position_w = 0.0
var rotation_2: Vector3 = Vector3.ZERO
var scale_w = 1.0

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
var _global_transform = Transform4D.new() :
	get:
		_global_transform.position = _global_position
		_global_transform.rotation_1 = _global_rotation_1
		_global_transform.rotation_2 = _global_rotation_2
		_global_transform.scale = _global_scale

		return _global_transform


func _get_property_list() -> Array[Dictionary]: ## Add hint to rotation and fix order
	var props:Array[Dictionary] = []

	props.push_back({
		"name": "position_w",
		"type": TYPE_FLOAT,
		"usage": PROPERTY_USAGE_DEFAULT,
	})

	props.push_back({
		"name": "rotation_2",
		"type": TYPE_VECTOR3,
		"hint": PROPERTY_HINT_RANGE,
		"hint_string": "-360,360,0.1",
	})

	props.push_back({
		"name": "scale_w",
		"type": TYPE_FLOAT,
		"hint": PROPERTY_HINT_LINK,
	})

	return props

func _property_can_revert(_property):
	return _property == "position_w" || _property == "rotation_2" || _property == "scale_w"

func _property_get_revert(_property):
	if _property == "position_w":
		return 0.0
	elif _property == "rotation_2":
		return Vector3.ZERO
	elif _property == "scale_w":
		return 1.0
	return null
