class_name PauseButton
extends Area3D

@export var pausable : Rotate4D

@export var material_show : StandardMaterial3D
@export var material_hide : StandardMaterial3D

@export var lock = false

@onready var anim : AnimationPlayer = $Anim
@onready var mesh : MeshInstance3D = $Mesh

var disabled = false

## Lifecycle

func _ready():
	pausable.pause_changed.connect(_on_pause_changed)

	material(material_show)

## Events

func _on_pause_changed(_pause):
	if disabled != _pause:
		disabled = _pause

		if disabled:
			material(material_hide)
		else:
			material(material_show)

func _on_area_entered(_area:Area3D):
	if not lock:
		anim.play("push")
		swap(!disabled)

## Helpers

func swap(_disabled):
	disabled = _disabled

	if disabled:
		pausable.play(false)
		material(material_hide)
	else:
		pausable.play(true)
		material(material_show)

func material(m : Material):
	mesh.mesh.material = m
