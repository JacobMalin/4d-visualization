class_name TinyCamera
extends Camera3D

@export var head : XRCamera3D
@export var tiny : Tiny
@export var offset = Vector3.UP * 0.04

var start_rotation : Vector3

func _start():
	start_rotation = rotation

func _process(_delta):
	global_position = tiny.global_position + offset

	if tiny.enabled:
		global_rotation = head.global_rotation
	else:
		rotation = start_rotation
