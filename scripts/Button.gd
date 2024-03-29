extends Area3D

@export var anim : AnimationPlayer

@export var movement_controller : MovementController
@export var tiny : Tiny

@export var lock = false

@onready var mesh : MeshInstance3D = $Mesh

var tableControl = false

func _on_area_entered(_area:Area3D):
	if not lock:
		anim.play("push")
		swap()

func swap():
	tableControl = !tableControl

	if tableControl:
		movement_controller.deny()
		tiny.enabled = true
		color(Color.GREEN)
	else:
		movement_controller.allow()
		tiny.enabled = false
		color(Color.RED)

func color(c : Color):
	mesh.mesh.material.albedo_color = c