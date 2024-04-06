class_name Transform4D

@export var position : Vector4 = Vector4.ZERO
@export var rotation_1 : Vector3 = Vector3.ZERO
@export var rotation_2 : Vector3 = Vector3.ZERO
@export var scale : Vector4 = Vector4.ZERO

var rotation_degrees_1 : Vector3 :
	get: return rotation_1
	set(rd): rotation_1 = rd
var rotation_degrees_2 : Vector3 :
	get: return rotation_2
	set(rd): rotation_2 = rd

var basis : Basis4D :
	get: return Basis4D.newFromScaleAndRotation(scale, rotation_1, rotation_2)
	set(b): push_error("Attempt to set basis: please stop.")
var origin : Vector4 :
	get: return position
	set(p): position = p

func _init(p_position = Vector4(0, 0, 0, 0), p_rotation_1 = Vector3(0, 0, 0), 
		   p_rotation_2 = Vector3(0, 0, 0), p_scale = Vector4(1, 1, 1, 1)):
	position = p_position
	rotation_1 = p_rotation_1
	rotation_2 = p_rotation_2
	scale = p_scale
