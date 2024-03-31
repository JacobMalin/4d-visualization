class_name ResetButton
extends Area3D

@export var tiny: Tiny

@export var lock = false
@export var enabled = false :
	set(value):
		enabled = value
		visible = value

@onready var anim: AnimationPlayer = $Anim

## Lifecycle

func _ready():
	visible = false

## Events

func _on_area_entered(_area: Area3D):
	if not lock and enabled:
		anim.play("push")
		reset()

## Helpers

func reset():
	tiny.reset()