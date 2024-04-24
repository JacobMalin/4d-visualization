class_name MovementController
extends Node3D

@export var direct: XRToolsMovementDirect
@export var turn: XRToolsMovementTurn
@export var jump: XRToolsMovementJump
@export var camera: MainCamera4D

func deny():
	direct.enabled = false
	turn.enabled = false
	jump.enabled = false
	camera.movement_enabled = false

func allow():
	direct.enabled = true
	turn.enabled = true
	jump.enabled = true
	camera.movement_enabled = true
