class_name HideButton
extends Area3D

@export var to_hide : Node3D
@export var material_show : StandardMaterial3D
@export var material_hide : StandardMaterial3D

@export var lock = false

@onready var anim : AnimationPlayer = $Anim
@onready var mesh : MeshInstance3D = $Mesh

var hidden = false

## Lifecycle

func _ready():
	material(material_show)

## Events

func _on_area_entered(_area:Area3D):
	if not lock:
		anim.play("push")
		swap(!hidden)

## Helpers

func swap(_hidden):
	hidden = _hidden

	if hidden:
		to_hide.visible = false
		material(material_hide)
	else:
		to_hide.visible = true
		material(material_show)

func material(m : Material):
	mesh.mesh.material = m
