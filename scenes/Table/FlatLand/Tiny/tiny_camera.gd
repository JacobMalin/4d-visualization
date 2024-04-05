@tool
class_name TinyCamera
extends Camera3D

@export var mousepad_action: String = "grip"

@export var tiny : Tiny
@export var offset = Vector3.UP * 0.04

@onready var table : Table = tiny.table
@onready var head : XRCamera3D = table.head
@onready var right_controller: XRController3D = table.right_controller

var prev_mouse_pos

## Lifecycle

func _ready():
	if Engine.is_editor_hint(): return

	prev_mouse_pos = right_controller.global_position

func _physics_process(_delta):
	# Store plane eq
	var global_normal = global_transform.basis.y
	FlatReference.plane = Plane(global_normal, global_position)
	FlatReference.tiny_camera_pos = global_position

	# Move camera
	global_position = tiny.global_position + offset

	if Engine.is_editor_hint(): return

	if tiny.enabled:
		# global_rotation.y = head.global_rotation.y
		global_rotation.z = head.global_rotation.z

		# Rotate camera more
		if is_mousepad():
			var dpi = 5
			print(mouse_diff().z)
			global_rotation.x += (mouse_diff()).z * (abs((mouse_diff()).z) / 0.01) * dpi
			global_rotation.y -= (mouse_diff()).x * (abs((mouse_diff()).x) / 0.01) * dpi
			# global_rotation.z += (mouse_diff()).y * (abs((mouse_diff()).y) / 0.01) * dpi

	# Store previous mose pos
	prev_mouse_pos = right_controller.global_position

## Helpers

func is_mousepad():
	if Engine.is_editor_hint(): return false
	return right_controller.is_button_pressed(mousepad_action)

func mouse_diff():
	if Engine.is_editor_hint(): return Vector3.ZERO
	return right_controller.global_basis.inverse() * (right_controller.global_position - prev_mouse_pos)

func reset():
	rotation = Vector3.ZERO