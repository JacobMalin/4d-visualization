@tool
class_name Tiny
extends CharacterBody3D

## Input action for movement direction
@export var move_action: String = "primary"
@export var jump_action: String = "ax_button"

@export var table: Table
@export var bounds: MeshInstance3D

@export var enabled = false

@onready var head: XRCamera3D = table.head
@onready var left_controller: XRController3D = table.left_controller
@onready var right_controller: XRController3D = table.right_controller

@onready var sub_viewport: SubViewport = $SubViewport
@onready var tiny_camera: TinyCamera = $SubViewport/TinyCamera

const SPEED = 0.5
const JUMP_VELOCITY = 1

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity") * 0.5



## Lifecycle

func _ready():
	if not Engine.is_editor_hint():
		right_controller.button_pressed.connect(_on_right_controller_button_pressed)

func _physics_process(delta):
	if enabled:
		global_rotation.y = head.global_rotation.y

		# Add the gravity.
		if not is_on_floor():
			velocity.y -= gravity * delta

		# Get the input direction and handle the movement/deceleration.
		# As good practice, you should replace UI actions with custom gameplay actions.
		var input_dir = XRToolsUserSettings.get_adjusted_vector2(left_controller, move_action)
		var direction = (transform.basis * Vector3(input_dir.x, 0, -input_dir.y)).normalized()
		if direction:
			velocity.x = direction.x * SPEED
			velocity.z = direction.z * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			velocity.z = move_toward(velocity.z, 0, SPEED)

		move_and_slide()

## Events

func _on_right_controller_button_pressed(_name):
	if _name == jump_action and enabled:
		# Handle jump.
		if is_on_floor():
			velocity.y = JUMP_VELOCITY

## Helper

func reset():
	position = Vector3.ZERO
	rotation = Vector3.ZERO