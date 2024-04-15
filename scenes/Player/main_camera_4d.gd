class_name MainCamera4D
extends Node4D

@export var mousepad_action : String = "grip"
@export var reset_action : String = "primary_click"

@export var movement_enabled = true
@export var right_controller : XRController3D

var prev_mouse_pos

const dpi = 5

## Lifecycle

func _ready():
	if Engine.is_editor_hint(): return

	prev_mouse_pos = right_controller.global_position
	right_controller.button_pressed.connect(_on_right_controller_button_pressed)

func _physics_process(_delta):
	# Store space eq
	var global_normal = _global_transform.basis.w
	HyperReference.space = Space.newFromPoint(global_normal, _global_position)
	HyperReference.camera_pos = _global_position

	if Engine.is_editor_hint(): return
	
	if movement_enabled:
		# Rotate camera
		if is_mousepad():
			_global_rotation_2 = _global_rotation_2 + Vector3(
				(mouse_diff()).z * (abs((mouse_diff()).z) / 0.01) * dpi,
			   -(mouse_diff()).x * (abs((mouse_diff()).x) / 0.01) * dpi,
				(mouse_diff()).y * (abs((mouse_diff()).y) / 0.01) * dpi,
			)

	HyperReference.camera_rot_2 = _global_rotation_2
	HyperReference.camera_basis = _global_transform.basis

	# Store previous mose pos
	prev_mouse_pos = right_controller.global_position

## Events

func _on_right_controller_button_pressed(_name):
	if movement_enabled and _name == reset_action:
		reset()

## Helper

func is_mousepad():
	if Engine.is_editor_hint(): return false
	return right_controller.is_button_pressed(mousepad_action)

func mouse_diff():
	if Engine.is_editor_hint(): return Vector3.ZERO
	return right_controller.global_basis.inverse() * (right_controller.global_position - prev_mouse_pos)

func reset():
	rotation_2 = Vector3.ZERO
