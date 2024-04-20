@tool
extends Node4D

@export var speed : float = 1

enum RotationType { YZ, ZX, XY, XW, YW, ZW }
@export var rotation_plane : RotationType

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	do_rotate(delta)


func do_rotate(delta):
	if not Engine.is_editor_hint():
		match rotation_plane:
			RotationType.YZ:
				rotation.x += speed * delta
			RotationType.ZX:
				rotation.y += speed * delta
			RotationType.XY:
				rotation.z += speed * delta
			RotationType.XW:
				rotation_2.x += speed * delta
			RotationType.YW:
				rotation_2.y += speed * delta
			RotationType.ZW:
				rotation_2.z += speed * delta
