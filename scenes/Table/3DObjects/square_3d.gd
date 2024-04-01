@tool
class_name Square3D
extends Node3D

@export var size : Vector2 = Vector2.ONE
@export var center_offset : Vector3

@export var colors = [
	Color(),
	Color(),
	Color(),
	Color(),
]

@onready var triangles = [
	Triangle3D.new(),
	Triangle3D.new(),
]

func _ready():
	add_child(triangles[0])
	add_child(triangles[1])

func _process(_double):
	var vertices = [
		center_offset - size.x * Vector3.RIGHT / 2 + size.y * Vector3.UP / 2,
		center_offset + size.x * Vector3.RIGHT / 2 + size.y * Vector3.UP / 2,
		center_offset + size.x * Vector3.RIGHT / 2 - size.y * Vector3.UP / 2,
		center_offset - size.x * Vector3.RIGHT / 2 - size.y * Vector3.UP / 2,
	]

	# Triangle0 - top right
	for i in range(3):
		triangles[0].vertices[i] = vertices[i]
		triangles[0].colors[i] = colors[i]

	# Triangle1 - bottom left
	for i in range(3):
		var j = (i + 2) % 4
		triangles[1].vertices[i] = vertices[j]
		triangles[1].colors[i] = colors[j]