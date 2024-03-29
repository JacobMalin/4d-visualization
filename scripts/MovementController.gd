class_name MovementController
extends Node3D

@export var direct: XRToolsMovementDirect
@export var turn: XRToolsMovementTurn
@export var jump: XRToolsMovementJump

func deny():
	direct.enabled = false
	turn.enabled = false
	jump.enabled = false

func allow():
	direct.enabled = true
	turn.enabled = true
	jump.enabled = true