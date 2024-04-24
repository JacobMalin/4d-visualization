class_name Slide
extends Node3D

@export var target : Node3D
@export var property : StringName

@onready var ball : SlideBall = $Ball

var min_w_frustrum = 0.01

func _process(_delta):
	var ball_percent = ball.get_percent()
	HyperReference.w_frustrum = ball_percent if ball_percent > min_w_frustrum else min_w_frustrum
