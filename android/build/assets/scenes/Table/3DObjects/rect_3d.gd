@tool
class_name Rect3D
extends Node3D

@export var size : Vector2 = Vector2.ONE : 
	set(s):
		size = s
		update_triangles.call_deferred()
@export var center_offset : Vector3 : 
	set(co):
		center_offset = co
		update_triangles.call_deferred()

@export var color = Color.BLACK : 
	set(c):
		color = c
		update_triangles.call_deferred()

@onready var triangles = [
	Triangle3D.new(),
	Triangle3D.new(),
]

func _ready():
	add_child(triangles[0])
	add_child(triangles[1])

	update_triangles()

func update_triangles():
	var vertices = [
		center_offset - size.x * Vector3.RIGHT / 2 + size.y * Vector3.UP / 2,
		center_offset + size.x * Vector3.RIGHT / 2 + size.y * Vector3.UP / 2,
		center_offset + size.x * Vector3.RIGHT / 2 - size.y * Vector3.UP / 2,
		center_offset - size.x * Vector3.RIGHT / 2 - size.y * Vector3.UP / 2,
	]

	# Triangle0 - top right
	for i in range(3):
		triangles[0].vertices[i] = vertices[i]
	triangles[0].color = color

	# Triangle1 - bottom left
	for i in range(3):
		var j = (i + 2) % 4
		triangles[1].vertices[i] = vertices[j]
	triangles[1].color = color
