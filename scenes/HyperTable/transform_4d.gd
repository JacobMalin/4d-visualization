class_name Transform4D

@export var position : Vector4 = Vector4.ZERO
@export var rotation : Vector4 = Vector4.ZERO
@export var scale : Vector4 = Vector4.ZERO

var rotation_degrees : Vector4 :
	get: return rotation
	set(rd): rotation = rd

var basis : Basis4D
var origin : Vector4

func _init(p_position = Vector4(0, 0, 0, 0), p_rotation = Vector4(0, 0, 0, 0), p_scale = Vector4(1, 1, 1, 1)):
	position = p_position
	rotation = p_rotation
	scale = p_scale
