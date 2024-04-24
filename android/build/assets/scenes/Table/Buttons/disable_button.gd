class_name DisableButton
extends Area3D

@export var target_path : NodePath
@export var _name : StringName

@export var material_show : StandardMaterial3D
@export var material_hide : StandardMaterial3D

@export var lock = false

@onready var anim : AnimationPlayer = $Anim
@onready var mesh : MeshInstance3D = $Mesh
@onready var target : Node = get_tree().get_root().get_node(target_path)

var disabled = false

## Lifecycle

func _ready():
	material(material_show)

## Events

func _on_area_entered(_area:Area3D):
	if not lock:
		anim.play("push")
		swap(!disabled)

## Helpers

func swap(_disabled):
	disabled = _disabled

	if disabled:
		target.set(_name, false)
		material(material_hide)
	else:
		target.set(_name, true)
		material(material_show)

func material(m : Material):
	mesh.mesh.material = m
