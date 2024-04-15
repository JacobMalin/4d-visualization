extends Node

@export var plane : Plane = Plane.PLANE_XZ
@export var tiny_camera_pos : Vector3 = Vector3.ZERO
@export var tiny_camera_rot : Vector3 = Vector3.ZERO
@export var tiny_camera_transform : Transform3D = Transform3D.IDENTITY

@export var show_3d = true
@export var show_2d = true
@export var do_rotate = true

@export var y_frustrum = 0.1

@onready var shader_2d = preload("res://materials/table_2d_material.tres")

func _ready():
	shader_2d.set_shader_parameter("y_frustrum", y_frustrum)

func _process(_delta):
	shader_2d.set_shader_parameter("normal", plane.normal)
	shader_2d.set_shader_parameter("d", plane.d)