class_name MovementButton
extends Area3D

@export var table : Table
@export var tiny : Tiny
@export var reset_button : ResetButton

@export var lock = false
@export var exit_action = "menu_button"

@onready var left_controller : XRController3D = table.left_controller
@onready var movement_controller : MovementController = table.movement_controller

@onready var anim : AnimationPlayer = $Anim
@onready var mesh : MeshInstance3D = $Mesh

var tableControl = false

## Lifecycle

func _ready():
	left_controller.button_pressed.connect(_on_left_controller_button_pressed)

## Events

func _on_area_entered(_area:Area3D):
	if not lock:
		anim.play("push")
		swap(!tableControl)

func _on_left_controller_button_pressed(_name):
	if tableControl and _name == exit_action:
		swap(false)

## Helpers

func swap(_tableControl):
	tableControl = _tableControl

	if tableControl:
		movement_controller.deny()
		tiny.enabled = true
		reset_button.enabled = true
		color(Color.GREEN)
	else:
		movement_controller.allow()
		tiny.enabled = false
		reset_button.enabled = false
		color(Color.RED)

func color(c : Color):
	mesh.mesh.material.albedo_color = c
