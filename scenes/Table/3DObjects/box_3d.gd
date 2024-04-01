@tool
class_name Box3D
extends Node3D

@export var size: Vector2
@export var center_offset: Vector3

@export var colors: Color

@onready var squares = [
]

func _ready():
	for square in squares:
		add_child(square)

func _process(_double):
	pass