@tool
class_name Square4D
extends Node4D

@export var size : Vector2 = Vector2.ONE :
	set(s):
		size = s
		recalc_vertices()
@export var center_offset : Vector4 : 
	set(co):
		center_offset = co
		recalc_vertices()

# @export var colors = [
# 	Color(),
# 	Color(),
# 	Color(),
# 	Color(),
# ]

@onready var triangles = [
	Triangle4D.new(),
	Triangle4D.new(),
]

func _ready():
	add_child(triangles[0])
	add_child(triangles[1])

	recalc_vertices()

func recalc_vertices():
	var vertices = [
		center_offset - size.x * Vector4(1,0,0,0) / 2 + size.y * Vector4(0,1,0,0) / 2,
		center_offset + size.x * Vector4(1,0,0,0) / 2 + size.y * Vector4(0,1,0,0) / 2,
		center_offset + size.x * Vector4(1,0,0,0) / 2 - size.y * Vector4(0,1,0,0) / 2,
		center_offset - size.x * Vector4(1,0,0,0) / 2 - size.y * Vector4(0,1,0,0) / 2,
	]

	# Triangle0 - top right
	for i in range(3):
		triangles[0].vertices[i] = vertices[i]
		# triangles[0].colors[i] = colors[i]

	# Triangle1 - bottom left
	for i in range(3):
		var j = (i + 2) % 4
		triangles[1].vertices[i] = vertices[j]
		# triangles[1].colors[i] = colors[j]
