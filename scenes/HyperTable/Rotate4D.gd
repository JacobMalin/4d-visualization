@tool
class_name Rotate4D
extends Node4D

@export var table : HyperTable
@export var speed : float = 10
@export var pause_action : String = "by_button"

@export var anim : AnimationPlayer

enum RotationType { YZ, ZX, XY, XW, YW, ZW }
@export var rotation_plane : RotationType : 
	set(rp):
		rotation_plane = rp
		rotation_plane_changed.emit(rp)

@export var pause = true : 
	set(p):
		pause = p
		pause_changed.emit(p)


@onready var right_controller : XRController3D = table.right_controller
@onready var main_camera : MainCamera4D = table.main_camera

signal rotation_plane_changed(_plane)
signal pause_changed(_pause)

func _ready():
	right_controller.button_pressed.connect(_on_right_controller_button_pressed)

func _physics_process(delta):
	do_rotate(delta)

func do_rotate(delta):
	var delta_speed = speed * delta
	if not Engine.is_editor_hint() and !pause:
		match rotation_plane:
			RotationType.YZ:
				rotation_degrees.x += delta_speed
			RotationType.ZX:
				rotation_degrees.y += delta_speed
			RotationType.XY:
				rotation_degrees.z += delta_speed
			RotationType.XW:
				rotation_2.x += delta_speed
			RotationType.YW:
				rotation_2.y += delta_speed
			RotationType.ZW:
				rotation_2.z += delta_speed

func change_rotation_plane(rp):
	rotation_plane = rp

func reset():
	rotation_degrees = Vector3.ZERO
	rotation_2 = Vector3.ZERO

func play(do_play):
	pause = !do_play

func _on_right_controller_button_pressed(_name):
	if main_camera.movement_enabled and _name == pause_action:
		play(pause)

func push_z(_on):
	if _on:
		anim.play("push_z")
	else:
		anim.play_backwards("push_z")

func push_w(_on):
	if _on:
		anim.play("push_w")
	else:
		anim.play_backwards("push_w")
