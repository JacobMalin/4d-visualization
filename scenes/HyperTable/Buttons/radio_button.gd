class_name RadioButton
extends Area3D

@export var rotatable: Rotate4D

@export var lock = false

@export var material_on  : StandardMaterial3D
@export var material_off : StandardMaterial3D

@export var _mesh : Mesh

@onready var anim : AnimationPlayer = $Anim
@onready var mesh : MeshInstance3D  = $Mesh

@export var rotation_plane : Rotate4D.RotationType

var disabled = true

## Events

func _ready():
	rotatable.rotation_plane_changed.connect(_on_rotation_plane_changed)

	swap(rotatable.rotation_plane != rotation_plane)

	mesh.mesh = _mesh
	mesh.global_rotation = Vector3.ZERO

func _on_area_entered(_area: Area3D):
	if not lock:
		anim.play("push")
		change_rotation_plane()

## Helpers

func change_rotation_plane():
	rotatable.change_rotation_plane(rotation_plane)

func _on_rotation_plane_changed(rp):
	swap(rp != rotation_plane)

func swap(_disabled):
	if disabled == _disabled: return

	disabled = _disabled

	if disabled:
		material(material_off)
	else:
		change_rotation_plane()
		material(material_on)

func material(m : Material):
	mesh.mesh.material = m
