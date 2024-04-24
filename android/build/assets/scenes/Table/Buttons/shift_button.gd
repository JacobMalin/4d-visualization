class_name ShiftButton
extends Area3D

@export var to_shift : Node3D
@export var normal_layer : int
@export var shifted_layer : int

@export var to_shift_2 : Node3D
@export var normal_layer_2 : int
@export var shifted_layer_2 : int

@export var material_show : StandardMaterial3D
@export var material_hide : StandardMaterial3D

@export var lock = false

@onready var anim : AnimationPlayer = $Anim
@onready var mesh : MeshInstance3D = $Mesh

var shifted = false

## Lifecycle

func _ready():
	material(material_show)

## Events

func _on_area_entered(_area:Area3D):
	if not lock:
		anim.play("push")
		swap(!shifted)

## Helpers

func swap(_shifted):
	shifted = _shifted

	if shifted:
		to_shift.layers = shifted_layer
		to_shift_2.collision_layer = shifted_layer_2
		material(material_hide)
	else:
		to_shift.layers = normal_layer
		to_shift_2.collision_layer = normal_layer_2
		material(material_show)

func material(m : Material):
	mesh.mesh.material = m
