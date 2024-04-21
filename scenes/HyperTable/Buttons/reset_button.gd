class_name ResetButton
extends Area3D

@export var resettable: Node3D

@export var lock = false
@export var enabled = true :
	set(value):
		enabled = value
		visible = value

@onready var anim: AnimationPlayer = $Anim

## Events

func _on_area_entered(_area: Area3D):
	if not lock and enabled:
		anim.play("push")
		reset()

## Helpers

func reset():
	resettable.reset()
