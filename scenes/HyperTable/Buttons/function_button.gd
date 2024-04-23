class_name FunctionButton
extends Area3D

@export var target : Node3D
@export var function_name : StringName

@export var material_false : StandardMaterial3D
@export var material_true  : StandardMaterial3D

@export var _mesh : Mesh

@export var lock = false

@onready var anim : AnimationPlayer = $Anim
@onready var mesh : MeshInstance3D = $Mesh

var callable
var on = false

## Lifecycle

func _ready():
	mesh.mesh = _mesh

	callable = Callable(target, function_name)

	material(material_false)

## Events

func _on_area_entered(_area:Area3D):
	if not lock:
		anim.play("push")
		swap(!on)

## Helpers

func swap(_on):
	if on != _on:
		on = _on

		callable.call(on)
		if on:
			material(material_true)
		else:
			material(material_false)

func material(m : Material):
	mesh.mesh.material = m
