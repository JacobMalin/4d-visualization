@tool
class_name TinyCamera
extends Camera3D

@export var tiny : Tiny
@export var offset = Vector3.UP * 0.04

@onready var table : Table = tiny.table
@onready var head : XRCamera3D = table.head

var start_rotation : Vector3

func _start():
	start_rotation = rotation

func _process(_delta):
	# Store plane eq
	var global_normal = global_transform.basis.y
	TinyPlane.plane = Plane(global_normal, global_normal.dot(global_position))

	# Move camera
	global_position = tiny.global_position + offset

	if tiny.enabled:
		global_rotation = head.global_rotation
