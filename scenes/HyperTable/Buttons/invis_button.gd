class_name InvisButton
extends Area3D

@export var invisable : Node3D

@export var material_show : StandardMaterial3D
@export var material_hide : StandardMaterial3D

@export var _mesh : Mesh

@export var lock = false

@onready var anim : AnimationPlayer = $Anim
@onready var mesh : MeshInstance3D = $Mesh

var disabled = false

signal invis_pushed(_name)

## Lifecycle

func _ready():
	mesh.mesh = _mesh
	material(material_show)
	swap(!invisable.visible)

## Events

func _on_area_entered(_area:Area3D):
	if not lock:
		anim.play("push")
		swap(!disabled)

func _on_invis_pushed(_name):
	if _name != invisable.name:
		swap(true)

## Helpers

func swap(_disabled):
	disabled = _disabled

	if disabled:
		invisable.visible = false
		material(material_hide)
	else:
		invis_pushed.emit(invisable.name)
		invisable.visible = true
		material(material_show)

func material(m : Material):
	mesh.mesh.material = m
