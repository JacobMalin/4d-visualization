@tool
class_name Box3D
extends Node3D

@export var size: Vector3 = Vector3.ONE

@export var color = Color.BLACK

@onready var squares = [
	Square3D.new(),
	Square3D.new(),
	Square3D.new(),
	Square3D.new(),
	Square3D.new(),
	Square3D.new(),
]

func _ready():
	for square in squares:
		add_child(square)

func _process(_delta):
	# Square 0 - +z
	squares[0].size = Vector2(size.x, size.y)
	squares[0].position.z = size.z / 2
	squares[0].color = color
	# Square 1 - -z
	squares[1].size = Vector2(size.x, size.y)
	squares[1].position.z = -size.z / 2
	squares[1].rotation_degrees.y = 180
	squares[1].color = color
	# Square 2 - +x
	squares[2].size = Vector2(size.z, size.y)
	squares[2].position.x = size.x / 2
	squares[2].rotation_degrees.y = 90
	squares[2].color = color
	# Square 3 - -x
	squares[3].size = Vector2(size.z, size.y)
	squares[3].position.x = -size.x / 2
	squares[3].rotation_degrees.y = 270
	squares[3].color = color
	# Square 4 - +y
	squares[4].size = Vector2(size.x, size.z)
	squares[4].position.y = size.y / 2
	squares[4].rotation_degrees.x = 270
	squares[4].color = color
	# Square 5 - -y
	squares[5].size = Vector2(size.x, size.z)
	squares[5].position.y = -size.y / 2
	squares[5].rotation_degrees.x = 90
	squares[5].color = color
