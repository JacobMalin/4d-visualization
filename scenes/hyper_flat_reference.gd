extends Node

@export var space: Space = Space.new():
	set(s):
		space.normal = s.normal
		space.e = s.e
@export var camera_pos: Vector4 = Vector4.ZERO
@export var camera_rot_2 : Vector3 = Vector3.ZERO
var camera_basis : Basis4D = Basis4D.new()

@export var show_3d = true

@export var w_frustrum = 1

@onready var shader_3d = preload ("res://materials/hyper_3d_material.tres")

func _process(_delta):
	shader_3d.set_shader_parameter("w_frustrum", w_frustrum)
	
	shader_3d.set_shader_parameter("normal", space.normal)
	shader_3d.set_shader_parameter("e", space.e)

	shader_3d.set_shader_parameter("camera_pos", camera_pos)
	shader_3d.set_shader_parameter("camera_rot_2", camera_rot_2)

	shader_3d.set_shader_parameter("camera_basis_x", camera_basis.x)
	shader_3d.set_shader_parameter("camera_basis_y", camera_basis.y)
	shader_3d.set_shader_parameter("camera_basis_z", camera_basis.z)
	shader_3d.set_shader_parameter("camera_basis_w", camera_basis.w)
	