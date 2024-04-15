class_name Transform4D

@export var position : Vector4 = Vector4.ZERO : 
	set(p) :
		basis_changed = true
		position = p
@export var rotation_1 : Vector3 = Vector3.ZERO : 
	set(r1) :
		basis_changed = true
		rotation_1 = r1
@export var rotation_2 : Vector3 = Vector3.ZERO : 
	set(r2) :
		basis_changed = true
		rotation_2 = r2
@export var scale : Vector4 = Vector4.ZERO : 
	set(s) :
		basis_changed = true
		scale = s

var basis_changed = true

var basis : Basis4D :
	get:
		if basis_changed:
			basis = Basis4D.newFromScaleAndRotation(scale, rotation_1, rotation_2)
			basis_changed = false

		return basis
var origin : Vector4 :
	get: return position
	set(p): position = p

func _init(p_position = Vector4(0, 0, 0, 0), p_rotation_1 = Vector3(0, 0, 0), 
		   p_rotation_2 = Vector3(0, 0, 0), p_scale = Vector4(1, 1, 1, 1)):
	position = p_position
	rotation_1 = p_rotation_1
	rotation_2 = p_rotation_2
	scale = p_scale

func mul(p_vector):
	var _basis = basis
	var _origin = origin

	return _basis.xform(p_vector) + _origin

func mul_affine_inverse(p_vector):
	var _basis = basis.inverse()
	var _origin = _basis.xform(-origin)

	return _basis.xform(p_vector) + _origin