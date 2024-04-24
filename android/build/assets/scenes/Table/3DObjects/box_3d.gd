@tool
class_name Box3D
extends Node3D

@export var size: Vector3 = Vector3.ONE : 
	set(s):
		size = s
		update_rects.call_deferred()

@export var color = Color.BLACK : 
	set(c):
		color = c
		update_rects.call_deferred()

@onready var rects = [
	Rect3D.new(),
	Rect3D.new(),
	Rect3D.new(),
	Rect3D.new(),
	Rect3D.new(),
	Rect3D.new(),
]

func _ready():
	for rect in rects:
		add_child(rect)

	update_rects()

func update_rects():
	# Rectangle 0 - +z
	rects[0].size = Vector2(size.x, size.y)
	rects[0].position.z = size.z / 2
	rects[0].color = color
	# Rectangle 1 - -z
	rects[1].size = Vector2(size.x, size.y)
	rects[1].position.z = -size.z / 2
	rects[1].rotation_degrees.y = 180
	rects[1].color = color
	# Rectangle 2 - +x
	rects[2].size = Vector2(size.z, size.y)
	rects[2].position.x = size.x / 2
	rects[2].rotation_degrees.y = 90
	rects[2].color = color
	# Rectangle 3 - -x
	rects[3].size = Vector2(size.z, size.y)
	rects[3].position.x = -size.x / 2
	rects[3].rotation_degrees.y = 270
	rects[3].color = color
	# Rectangle 4 - +y
	rects[4].size = Vector2(size.x, size.z)
	rects[4].position.y = size.y / 2
	rects[4].rotation_degrees.x = 270
	rects[4].color = color
	# Rectangle 5 - -y
	rects[5].size = Vector2(size.x, size.z)
	rects[5].position.y = -size.y / 2
	rects[5].rotation_degrees.x = 90
	rects[5].color = color
