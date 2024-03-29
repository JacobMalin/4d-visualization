extends Node3D

@export var tiny : Tiny

func _physics_process(_delta):
	position.y = tiny.position.y
